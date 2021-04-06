#!/bin/python3
import subprocess
import string
import random
import shlex
def get_random_password():
	symbols = ['*', '%', '^'] # Can add more
	password = "aic"
	for _ in range(9):
	    password += random.choice(string.ascii_lowercase)
	password += random.choice(string.ascii_uppercase)
	password += random.choice(string.digits)
	password += random.choice(symbols)
	return password


class User:
	def __init__(self, name="", firstName="", lastName="", email="", phone=""):
		self.name=name
		self.firstName=firstName
		self.lastName=lastName
		self.email=email
		self.phone=phone
		self.password = get_random_password()
	def show(self):
		print("Name: " + self.name)
		print("First Name: " + self.firstName)
		print("Last Name: " + self.lastName)
		print("Email: " + self.email)
		print("Phone: " + self.phone)

def get_ipa_create_user_cmd(user):
	ipa_command = "ipa user-add {name} --first='{firstName}' --last='{lastName}' --email={email} --phone={phone} --shell=/bin/bash".format(
							name=user.name, firstName=user.firstName, lastName=user.lastName, email=user.email, phone=user.phone)
	print(ipa_command)
	return ipa_command

def get_change_ipa_user_password_cmd(user):
	ipa_command = "ipa passwd {username} {password}".format(username=user.name, password=user.password)
	print(ipa_command)
	return ipa_command


def get_create_beegfs_dir(user):
	mkdir_command = "mkdir -p /mnt/beegfs/{name}".format(name=user.name)
	return mkdir_command


def get_chown_cmd(user):
	change_owner_command = " chown -R {name} /mnt/beegfs/{name} ".format(name=user.name)
	return change_owner_command

def get_chgrp_cmd(user):
	chgrp_command = "chgrp -R {name} /mnt/beegfs/{name}".format(name=user.name)
	return chgrp_command 

def get_chmod_cmd(user):
	chmod_command = "chmod -R 770 /mnt/beegfs/{name}".format(name=user.name)
	return chmod_command

def get_add_to_admins_grp(user):
	grp_add_command = "ipa group-add-member sysadmin --users={name}".format(name=user.name)
	return grp_add_command 
users = []
users.append(User("mmagdy", "Mohammed", "Magdy", "m.magdy@mcit.gov.eg", "01068333364"))
users.append(User("mrehan", "Mohammed", "Rehan", "mohamed.rehan@mcit.gov.eg", "0122550461"))
users.append(User("sabdou", "Sherif", "Abdou", "sh.ma.abdou@gmail.com", "01026614479"))
users.append(User("akhalaf", "Ayman", "Khalafallah", "A.Khalafallah@mcit.gov.eg", "01001360078"))

#users.append(User("test10", "Ayman", "Khalafallah", "A.Khalafallah@mcit.gov.eg", "01001360078"))

admins = []
#admins.append(User("amagdy", "Amr", "Magdy", "A.Magdy@mcit.gov.eg", ""))
admins.append(User("ahameed", "Ahmed", "Abd El-Hameed", "A.Abdelhameed@mcit.gov.eg", ""))
#admins.append(User("dmahmoud", "Dina", "Mahmoud", "DMohamed@mcit.gov.eg", ""))
#admins.append(User("wahmed", "Walied", "Ahmed", "walied2@protonmail.com", ""))
#admins.append(User("gnabil", "George", "Nabil", "g.nabil@mcit.gov.eg", ""))
"""
testUser = User("test6", "Test", "12", "test@test.testing")
print("CREATING USER WITH IPA...")
# Create user with freeipa
p = subprocess.Popen(get_ipa_create_user_cmd(testUser).split(), stdout=subprocess.PIPE)
out, err = p.communicate()
print(out, err)

print("GENERATING RANDOM PASSWORD FOR {name}...".format(name=testUser.name))
# Generate random password for the user
p2 = subprocess.Popen(get_change_ipa_user_password_cmd(testUser).split(), stdout=subprocess.PIPE)
out2, err2 = p2.communicate()
print(out2, err2)

print("CREATING {name} UNDER /mnt/beegfs/...".format(name=testUser.name))
# Add user dir under /mnt/beegfs/
p3 = subprocess.Popen(get_create_beegfs_dir(testUser).split(), stdout=subprocess.PIPE)
out3, err3 = p3.communicate()
print(out3, err3)


print("CHANGING OWNER OF /mnt/beegfs/{name}".format(name=testUser.name))
# Add user dir under /mnt/beegfs/
p4 = subprocess.Popen(get_chown_cmd(testUser).split(), stdout=subprocess.PIPE)
out4, err4 = p4.communicate()
print(out4, err4)

print("CHANGING GROUP OF /mnt/beegfs/{name}".format(name=testUser.name))
# Add user dir under /mnt/beegfs/
p5 = subprocess.Popen(get_chgrp_cmd(testUser).split(), stdout=subprocess.PIPE)
out5, err5 = p5.communicate()
print(out5, err5)

print("CHANGING MOD OF /mnt/beegfs/{name}".format(name=testUser.name))
# Add user dir under /mnt/beegfs/
p6 = subprocess.Popen(get_chmod_cmd(testUser).split(), stdout=subprocess.PIPE)
out6, err6 = p6.communicate()
print(out6, err6)
"""


def run_process(user, command):
	print("RUNNING: {cmd}").format(cmd=command)
	p = subprocess.Popen(shlex.split(command), stdout=subprocess.PIPE)
	out, err = p.communicate()
	print(out)

choice = int(input("Enter 1 to create ordinary users, or 2 to create admin users:"))


if choice == 1:
	for user in users:
		print("+++++++++++++++++++++++++++++++++++++++++")	
		print("CREATING USER {name} WITH IPA...\n").format(name=user.name)
		print("+++++++++++++++++++++++++++++++++++++++++")
		run_process(user, get_ipa_create_user_cmd(user))

		print("GENERATING RANDOM PASSWORD FOR {name}...".format(name=user.name))
		run_process(user,get_change_ipa_user_password_cmd(user))

		print("CREATING {name} UNDER /mnt/beegfs/...".format(name=user.name))
		run_process(user, get_create_beegfs_dir(user))
		# Add user dir under /mnt/beegfs/

		print("CHANGING OWNER OF /mnt/beegfs/{name}".format(name=user.name))
		# Add user dir under /mnt/beegfs/
		run_process(user, get_chown_cmd(user))

		print("CHANGING GROUP OF /mnt/beegfs/{name}".format(name=user.name))
		# Add user dir under /mnt/beegfs/
		run_process(user, get_chgrp_cmd(user))

		print("CHANGING MOD OF /mnt/beegfs/{name}".format(name=user.name))
		# Add user dir under /mnt/beegfs/
		run_process(user, get_chmod_cmd(user))
		
		
		print("---------")
elif choice == 2:
	for admin in admins:
		print("+++++++++++++++++++++++++++++++++++++++++")	
		print("CREATING ADMIN {name} WITH IPA...\n").format(name=admin.name)
		print("+++++++++++++++++++++++++++++++++++++++++")
		run_process(admin, get_ipa_create_user_cmd(admin))

		print("GENERATING RANDOM PASSWORD FOR {name}...".format(name=admin.name))
		run_process(admin,get_change_ipa_user_password_cmd(admin))

		print("ADDING ADMIN {name} TO GROUP admins".format(name=admin.name))
		run_process(admin, get_add_to_admins_grp(admin))
		print("-----------")
else:
	print("Sorry. Unrecognizable choice")
