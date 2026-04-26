# Cisco CP-6921 ∙ Smol

## Preparing the Provisioning Files

> [!IMPORTANT]
> **This configuration is insecure.** Local credentials are stored in plaintext in the SEPMAC file.
> Please refer to Device Security section of [usecallmanager.nz](https://usecallmanager.nz/device-security.html) for
> details on config file encryption and other security measures.

1. In `tftpboot` directory, copy `SEPMAC-CP6921.cnf.xml` to `SEP<MAC_ADDRESS>.cnf.xml`,
   where `<MAC_ADDRESS>` is the MAC address of your phone in uppercase without colons.
   For example, if your phone's MAC address is `00:11:22:33:44:55`,
   the file should be named `SEP001122334455.cnf.xml`.

2. Download the latest base locales and firmware packages from [this Wiki page](https://wiki.bksp.in/doc/sip-phones-BhkOXpXDjD).

3. Extract them into the `tftpboot` directory.

4. Create empty Trust List files:

    ```shell
    touch tftpboot/ITLFile.tlv tftpboot/CTLFile.tlv
    ```

5. Adjust IP address and username/password in `SEP<MAC_ADDRESS>.cnf.xml` file according to SMOL_LOCAL_USERNAME and SMOL_LOCAL_PASSWORD values in your `.env` file.

You should end up with a structure like this:

```plain
tftpboot/
├── SEPMAC-CP6921.cnf.xml
├── SEP001122334455.cnf.xml
├── SIP69xx.9-4-1-3SR3.loads
├── SIP69xx.9-4-1-3SR3.zz.sgn
├── ...
├── united_states/
├── english_united_states/
└── ...
```

## Phone Setup

### Factory Reset

- **Soft way:** If your phone Admin Settings are not disabled, you can perform a factory reset from the phone's menu:
  - Press the `Settings` button (gear icon).
  - Navigate to `Admin Settings` > `Reset Settings` > `All` > `Reset`.
  - Phone might prompt you to confirm removal of installed MSC or Trusted Lists. Accept it to proceed.

- **Ultimate way:** Unplug the power, hold down the `#` key, and plug the power back in
  while keeping the `#` key pressed until the line keys start flashing red.
  Immediately press `123456789*0#` to confirm the reset.

### Setting an alternate TFTP server

For the sake of simplicity, we'll skip DHCP Option 150 provisioning and point the phone directly
to the provisioning server.

- Press the `Settings` button (gear icon).

- Navigate to `Admin Settings` > `Network Setup` > `IPv4 Setup`

- Find the `Alternate TFTP` parameter and set it to **Yes**.

- Back in the `IPv4 Setup` menu, find the `Alternate TFTP Server` parameter,
  and set it to the IP address of your Smol server (`192.0.2.1` in our example).

- Wait for the phone to fetch the provisioning files, update firmware if necessary, and reboot.

## Troubleshooting

CP-6921 are very slow. It can take up to five minutes from the power on
until the phone is successfully registered. Please be patient.

If you're sure that something is wrong – great! This phone is surprisingly verbose in
its logs if asked nicely.

- Press the `Settings` button (gear icon).

- Navigate to `Admin Settings` > `Debug Phone`

- Pick the module you want to debug (e.g. `SIP`), and set the log level to `Debug`.

- Open Phone Web UI on `http://<PHONE_IP_ADDRESS>` and click on `Console Logs` page in the sidebar menu.
