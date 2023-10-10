# Cheat Sheet for Iceman Proxmark3 board

- Official repository: [RfidResearchGroup/proxmark3](https://github.com/RfidResearchGroup/proxmark3).

### Commands for 13.56 MHz (Mifare Classic TAG):

- Dump:

  ```bash
  hf mf autopwn
  ```

- Dump with **Static nonce**:

  ```bash
  # Use a known key to discover the unknown keys
  # E.g.: key A from block 15 is FFFFFFFFFFFF
  hf mf staticnested --1k --blk 15 -a -k FFFFFFFFFFFF

  # Then, use the discovered key A on autopwn
  # E.g.: key A from block 0 is XXXXXXXXXXXX
  hf mf autopwn -s 0 -a -k XXXXXXXXXXXX
  ```

- Clone/Write:

  ```bash
  hf mf cload -f hf-mf-<UID>-dump.eml
  ```

- Emulate tag:

  ```bash
  # Upload a dump file to the emulator memory
  hf mf eload -f hf-mf-<UID>-dump.bin

  # Start the emulator
  # Replace the --1k based on the tag type to be emulated
  hf mf sim --1k

  # Press the side button to stop the emulator
  ```

### Commands for 125 KHz (HID, EM...):

- Detect TAG type:

  ```bash
  lf search
  ```

- For **HID Prox ID**:

  ```bash
  # Get raw info from the previous command
  # E.g.: [=] raw: 00000000000000XXXXXXXXXX
  lf hid clone -r 00000000000000XXXXXXXXXX
  ```

- For **EM410x ID**:

  ```bash
  # Get EM410x ID info from the previous command
  # E.g.: [+] EM 410x ID XXXXXXXXXX
  lf em 410x clone --id XXXXXXXXXX
  ```

- Emulate tag:

  ```bash
  # For HID Prox ID
  lf hid sim -r 00000000000000XXXXXXXXXX

  # For EM410x ID
  lf em 410x sim --id XXXXXXXXXX

  # Press the side button to stop the emulator
  ```
