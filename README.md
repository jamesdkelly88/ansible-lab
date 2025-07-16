# Ansible

## Structure

```
*
├── inventory
│   ├── groups.yml                               # static file defining group tree
│   ├── netbox.yml                               # dynamic inventory configuration for nb_inventory plugin
│   ├── group_vars
│   │   ├── all                                  # variables to apply to all hosts
│   │   │   └── vars.yml                         #  <-- variables for group (including sensitive ones, using bitwarden lookup)     
│   │   └── group                                # variables to apply to specific group
│   └── host_vars                                # included for completeness - should be empty as Netbox is source of truth
├── roles
│   ├── role                                     # this hierarchy represents a "role"
│   │   ├── defaults
│   │   │   └── main.yml                         #  <-- default lower priority variables for this role
│   │   ├── files
│   │   │   ├── bar.txt                          #  <-- files for use with the copy resource
│   │   │   └── foo.sh                           #  <-- script files for use with the script resource
│   │   ├── handlers
│   │   │   └── main.yml                         #  <-- handlers file
│   │   ├── meta
│   │   │   └── main.yml                         #  <-- role dependencies
│   │   ├── tasks
│   │   │   ├── main.yml                         #  <-- tasks file can include smaller files if warranted
│   │   │   └── sub_tasks.yml                    #  <-- smaller task file for splitting complex processes or optional includes
│   │   ├── templates
│   │   │   └── ntp.conf.j2                      #  <-- templates end in .j2
│   │   └── vars
│   │       └── main.yml                         #  <-- variables associated with this role
│   └── another-role
├── .env                                         # environment variables file (not committed) - load with: source .env
├── .gitignore                                   # exclude .env from version control
├── ansible.cfg                                  # ansible configuration - sets inventory and connection properties
├── playbook.yml                                 # ansible playbook at top level of repository
├── README.md                                    # this file
└── shell.nix                                    # nix configuration for dependencies
```

## Dependencies

### System Packages

- ansible
- bws
- sshpass

### Python Packages

- jmespath (for json_query)
- pynetbox (for nb_inventory)
- pytz (for nb_inventory)

Verify: `pip list`

### Ansible Galaxy Collections

- netbox.netbox

Verify: `ansible-galaxy collections list`

## Usage

### Required environment variables:

- BWS_ACCESS_TOKEN - Bitwarden Secrets Manager token

### Check inventory

- Show inventory tree: `ansible-inventory --graph`
- Show full inventory including all hosts and variables: `ansible-inventory --list`
- Inspect a host: `ansible-inventory --host HOSTNAME`

### Playbooks

- Run: `ansible-playbook name.yml`
- Run with variables: `ansible-playbook name.yml -e target=XYZ`

## Secrets

Variables are applied to groups. All variables are defined in `vars.yml`, including sensitive ones. Sensitive variable should use the Bitwarden Secrets Manager lookup function. No secrets should be stored in version control. The secret must be reference by its GUID, not its name:

```yaml
{{ lookup("community.general.bitwarden_secrets_manager", "00000000-0000-0000-0000-000000000000").value }}
```

## Netbox

Some of the derived variables make assumptions based on data in Netbox:
- host names should be upper case
- wired network interfaces must be named `eth*` - if they have another name in the OS, set this as the label
- wireless network interfaces must be named `wl*` - if they have another name in the OS, set this as the label
- Windows hosts are assumed to have OpenSSH enabled
