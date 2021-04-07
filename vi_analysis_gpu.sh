#!/bin/bash
# Virutal Inspection
# Assumed folders name: cpunode01, cpunode02, ... , gpunode01, gpunode02, ...
# Assumed files names: gp01_command1.mcit, gp02_command1.mcit, ...
# , gp01_command2.mcit, gp02_command2.mcit, ...


# Assuming script is running from the same dir
parent_dir="."
csv_file="${parent_dir}/results-gpu.csv"

#metadata of the file
echo "#Structure" > $csv_file
echo "node, mellanox, intelX710, 2400PowerCapacity, BOSSController, ram, cpu, motherboard, TeslaV100" >> $csv_file




for i in {01..12}
do
  n_id=$i
  n_type="gpu"
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


  #2. Intel X710
  x710_regex1="Dell\sEthernet\s10G\s4P\sX710/I350\srNDC"
  x710_regex2="Dell\sEthernet\s10G\sX710\srNDC"
  x710_file="${path}_hwinfo.mcit"
  if (($(grep -c $x710_regex1 $x710_file)==1)) && (($(grep -c $x710_regex1 $x710_file)==1));then
    csv_record="${csv_record},1"
  else
    csv_record="${csv_record},0"
  fi


  #3. Powersupply
  powersup_regex="Max\sPower\sCapacity:\s2400\sW"
  powersup_file="${path}_dmidecode.mcit"
  if (($(grep -c $powersup_regex $powersup_file)==2)); then
    csv_record="${csv_record},1"
  else
    csv_record="${csv_record},0"
  fi


  #4. BOSS Controller
  boss_regex="480GB\sDELLBOSS\sVD"
  boss_file="${path}_lshw-short.mcit"
  if grep -q $boss_regex $boss_file; then
    csv_record="${csv_record},1"
  else
    csv_record="${csv_record},0"
  fi


  #5. RAM
  ram_regex="32GiB\sDIMM\sDDR4\sSynchronous\sRegistered\s(Buffered)\s2933\sMHz"
  ram_file="${path}_lshw-short.mcit"
  if (($(grep -c $ram_regex $ram_file)==12));then
    csv_record="${csv_record},1"
  else
    csv_record="${csv_record},0"
  fi


  #6 CPUS
  model_regex="Intel(R)\sXeon(R)\sGold\s6230\sCPU\s@\s2.10GHz"
  core_regex="Core(s)\sper\ssocket:\s*20"
  sockets_regex="Socket(s):\s*2"
  cpu_regex="CPU(s):\s*40"
  cpu_file="${path}_lscpu.mcit"
  if grep -q $cpu_regex $cpu_file && grep -q $model_regex $cpu_file && grep -q $core_regex $cpu_file && grep -q $sockets_regex $cpu_file; then
    csv_record="${csv_record},1"
  else
    csv_record="${csv_record},0"
  fi


  #7 Motherboard
  mother_model_regex="product:\s*PowerEdge\s*C4140"
  mother_file="${path}_lshw.mcit"
  if grep -q $mother_model_regex $mother_file;
  then
    csv_record="${csv_record},1"
  else
    csv_record="${csv_record},0"
  fi

  #8. Tesla V100
  tesla_regex="NVIDIA\sCorporation\sGV100GL\s\[Tesla\sV100\sSXM2\s32GB\]"
  tesla_file="${path}_lspci-long.mcit"
  if (($(grep -c $tesla_regex $tesla_file)==4));then
    csv_record="${csv_record},1"
  else
    csv_record="${csv_record},0"
  fi


  echo $csv_record >> $csv_file
done
exit 0






