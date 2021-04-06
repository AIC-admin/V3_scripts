#!/bin/bash
# Virutal Inspection
# Assumed folders name: cpunode01, cpunode02, ... , gpunode01, gpunode02, ...
# Assumed files names: cp01_command1.mcit, cp02_command1.mcit, ...
# , cp01_command2.mcit, cp02_command2.mcit, ...


# Assuming script is running from the same dir
parent_dir="."
csv_file="${parent_dir}/results.csv"

#metadata of the file
echo "#Structure" > $csv_file
echo "node, mellanox, broadcom, powersupply, perc, sata, ram, cpu, motherboard" >> $csv_file




for i in {01..20}
do
  n_id=$i
  n_type="cpu"
  csv_record="${n_type}node${n_id}"
  path="${parent_dir}/${n_type}node${n_id}/${n_type:0:2}${n_id}"

  #1. Mellanox
  mellanox_regex="Mellanox.*\[ConnectX-5\]"
  mellanox_file="${path}_lspci.mcit"
  if grep -q $mellanox_regex $mellanox_file; then
    csv_record="${csv_record},1"
  else
    csv_record="${csv_record},0"
  fi


  #2. Broadcom
  broadcom_regex1="Broadcom.*57412.*10Gb"
  broadcom_regex2="Broadcom.*5720"
  broadcom_file="${path}_hwinfo-short.mcit"
  if (($(grep -c $broadcom_regex1 $broadcom_file)==2)) && (($(grep -c $broadcom_regex2 $broadcom_file)==2));then
    csv_record="${csv_record},1"
  else
    csv_record="${csv_record},0"
  fi


  #3. Powersupply
  powersup_regex="Max\sPower\sCapacity:\s1100\sW"
  powersup_file="${path}_dmidecode.mcit"
  if (($(grep -c $powersup_regex $powersup_file)==2)); then
    csv_record="${csv_record},1"
  else
    csv_record="${csv_record},0"
  fi


  #4. PERC
  perc_regex="PERC\sH740P\sMini"
  perc_file="${path}_lsscsi.mcit"
  if grep -q $perc_regex $perc_file; then
    csv_record="${csv_record},1"
  else
    csv_record="${csv_record},0"
  fi


  #5. SATA
  sata_regex="6\sGbps"
  sata_file1="${path}_dmesg.mcit"
  if grep -q $sata_regex $sata_file1; then
    sata_file2="${path}_lsblk-rota.mcit"
    if grep -q "0" $sata_file2 && ! grep -q "1" $sata_file2;then
      csv_record="${csv_record},1"
    else
      csv_record="${csv_record},0"
    fi
  fi


  #6. RAM
  ram_regex="16GiB\sDIMM\sDDR4"
  ram_file="${path}_lshw-short.mcit"
  if (($(grep -c $ram_regex $ram_file)==24));then
    csv_record="${csv_record},1"
  else
    csv_record="${csv_record},0"
  fi


  #7 CPUS
  model_regex="Intel(R)\sXeon(R)\sGold\s6248R\sCPU\s@\s3.00GHz"
  core_regex="Core(s)\sper\ssocket:\s*24"
  sockets_regex="Socket(s):\s*2"
  cpu_regex="CPU(s):\s*48"
  cpu_file="${path}_lscpu.mcit"
  if grep -q $cpu_regex $cpu_file && grep -q $model_regex $cpu_file && grep -q $core_regex $cpu_file && grep -q $sockets_regex $cpu_file; then
    csv_record="${csv_record},1"
  else
    csv_record="${csv_record},0"
  fi


  #8 Motherboard
  mother_model_regex="product:\s*PowerEdge\s*R640"
  mother_code_regex="product:\s*0H28RR"
  mother_file="${path}_lshw.mcit"
  if grep -q $mother_model_regex $mother_file && grep -q $mother_code_regex $mother_file;
  then
    csv_record="${csv_record},1"
  else
    csv_record="${csv_record},0"
  fi

  echo $csv_record >> $csv_file
done
exit 0






