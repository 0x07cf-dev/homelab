# Role: System

This Ansible role provides a basic setup for Debian/Ubuntu machines.

## Requirements

No requirements.

## Role Variables

Below is an overview with explanations and usage examples. All default values are set in [`defaults/main.yml`](defaults/main.yml).

### User Variables

The role can create system users and groups.

```yml
## Example user/group configuration.
# You can completely disable user/group configuration by setting this variable to false.
system_users_enabled: true

# Example system_users.
system_users:
  - name: alice
    groups: staff
    password: super-secret
  - name: bob
    comment: Bob Smith
    shell: /bin/zsh
    home: /home/bsmith
    groups: staff,docker
    password: hunter2
    ssh_keys:
      - bob_work.pub
      - bob_home.pub

# Example system_groups.
system_groups:
  - name: staff
    gid: 1001
  - name: devs
  - name: docker
    gid: 989
    system: true
```

### SSH Variables

The role can provide basic SSH configuration.

```yml
## Example SSH configuration.
# You can completely disable SSH configuration by setting this variable to false.
system_ssh_enabled: true

# Port number through which SSH will be available.
system_ssh_port: 2849

# Enable or disable password authentication.
system_ssh_password_auth: false

# Root login policy (`yes`, `no`, `prohibit-password`).
system_ssh_permit_root_login: prohibit-password

# Allow accounts with empty passwords to log in.
system_ssh_permit_empty_passwords: false

# Enable authentication via public key.
system_ssh_pubkey_auth: true

# Enable challenge-response authentication.
system_ssh_challenge_response_auth: false

# Allow X11 forwarding.
system_ssh_x11_forwarding: false

# Allow SSH agent forwarding.
system_ssh_allow_agent_forwarding: true

# Seconds between keepalive messages.
system_ssh_client_alive_interval: 300

# Number of missed keepalives before disconnect.
system_ssh_client_alive_count_max: 2

# List of explicitly allowed users.
system_ssh_allowed_users:
  - alice
  - bob

# List of explicitly allowed groups.
system_ssh_allowed_groups:
  - staff
  - devs

```

#### Public Key Authorization

You can provide SSH public key files in [`files/`](files) to be automatically added for users defined in `system_users`.

Each user in `system_users` can define a list of public key filenames (without path) which will be added to the target machine's authorized SSH keys for that user.

For example, if you have:

```yml
system_users:
  - name: alice
    groups: staff
    ssh_keys:
      - alice_work.pub
      - alice_home.pub
  - name: deploy
    groups: docker
    ssh_keys:
      - deploy_key.pub
```

Then the user `alice` will receive `files/alice_work.pub` and `files/alice_home.pub` as authorized keys from the control node, and `deploy` will receive `files/deploy_key.pub`.

### Unattended Upgrades Variables

This role can configure automatic updates via [`unattended-upgrades`](https://packages.debian.org/search?keywords=unattended-upgrades).

```yml
# You can completely disable SSH configuration by setting this variable to false.
system_unattended_upgrades_enabled: true

# Automatically reboot if required after upgrades.
system_unattended_upgrades_reboot: false

# Time of day to perform automatic reboot (if enabled).
system_unattended_upgrades_reboot_time: "03:00"

# List of allowed origins for performing upgrades.
# This variable is set by default based on operating system.
# Use the variable below to add your custom origins.
system_unattended_upgrades_origins:
  - Ubuntu:focal-security
  - Ubuntu:focal-updates

# Additional origins beyond the defaults that should be upgraded automatically.
system_unattended_upgrades_additional_origins:
  - PPA:my/custom-ppa

# Packages to exclude from automatic upgrades.
system_unattended_upgrades_package_blacklist:
  - docker
  - kernel

# Email address to send upgrade reports to.
system_unattended_upgrades_mail_to: admin@example.com

# Send reports only if errors occur.
system_unattended_upgrades_mail_only_on_error: true
```

## Dependencies

No dependencies.

## Example Playbook

```yml
- hosts: servers
  roles:
    - system
  vars_files:
    - vars/main.yml
```

Inside `vars/main.yml`:

```yml
system_users:
  - name: alice
    groups: staff
    password: super-secret
system_groups:
  - name: staff
    gid: 1001
system_ssh_allowed_groups:
  - staff
system_unattended_upgrades_enabled: false
```

## License

[MIT](LICENSE.md)

## Author Information

Role created by [0x07cf](0x07.cf)