- [ ] Must install correct (deprecated) ansible provisioner
- [x] Must install galaxy playbook from ansible on local provisioning system
```
ansible-galaxy install undergreen.mongodb
```
- [ ] Rewriting to use different (better and secure by default and maintained)
  Ansible roels: ansible-galaxy collection install community.mongodb
- [ ] Switch all configuration to be terraform style with custom provider?
- [ ] Automate the creation of additional EBS volumes/integrate EBS creation into main declarations
- [ ] Fix poor naming of EBS volumes, make them self explanatory as paired to specific rs and instance
- [ ] Confirm the EBS I provide are data volumes
- [ ] Fix incorrect Name (all using mongodb-rs0-1)
- [ ] Figure out manual installation of mongodb since repos only have access to latest 3.6.x line (ie 3.6.23) not other versions. Maybe it's install via apt-get then uninstall and override?
    https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu-tarball/#overview
- [ ] Fix issue:  fatal: [54.71.174.140]: FAILED! => {"attempts": 5, "changed": false, "msg": "No package matching 'ntp' is available"}
