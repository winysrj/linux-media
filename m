Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60055 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab0IRNpF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Sep 2010 09:45:05 -0400
Received: by wwb39 with SMTP id 39so1912132wwb.1
        for <linux-media@vger.kernel.org>; Sat, 18 Sep 2010 06:45:03 -0700 (PDT)
Message-ID: <4C94C25B.5080702@gmail.com>
Date: Sat, 18 Sep 2010 15:44:59 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: crope@iki.fi
CC: linux-media@vger.kernel.org
Subject: Afatech AF9015 & MaxLinear MXL5007T dual tuner 2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi There,

Device:
Hardware based on Afatech AF9015 USB bridge & AF9013 demodulators & 
MaxLinear MXL5007T tuners:
Not Only TV/LifeView DUAL DVB-T USB LV52T
equivalent to TerraTec Cinergy T Stick Dual RC

Problem:
Boot from G2 (S5) aka Soft Off
or
Resume from G1 - S3 aka Suspend to RAM
tuner #2 nonfunctional

lsusb:
Bus 002 Device 002: ID 15a4:9016 Afatech Technologies, Inc. AF9015 DVB-T 
USB2.0 stick

uname:
2.6.35.4-12.el6.i686.PAE

Ref. modprobe.conf:
options dvb-core frontend_debug=1 debug=1 dvbdev_debug=1
options dvb-usb debug=511
options dvb_usb_af9015 debug=1
options af9013 debug=1
options mxl5007t debug=1

dmesg:
...
usb 2-1: new high speed USB device using ehci_hcd and address 2
psmouse serio1: ID: 10 00 64
usb 2-1: New USB device found, idVendor=15a4, idProduct=9016
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1: Product: DVB-T 2
usb 2-1: Manufacturer: Afatech
usb 2-1: SerialNumber: 010101010600001
Afatech DVB-T 2: Fixing fullspeed to highspeed interval: 10 -> 7
input: Afatech DVB-T 2 as 
/devices/pci0000:00/0000:00:04.1/usb2/2-1/2-1:1.1/input/input3
generic-usb 0003:15A4:9016.0001: input,hidraw0: USB HID v1.01 Keyboard 
[Afatech DVB-T 2] on usb-0000:00:04.1-1/input1
...
af9015_usb_probe: interface:0
00000000: 2b a5 9b 0b 00 00 00 00 a4 15 16 90 00 02 01 02  +...............
00000010: 03 80 00 fa fa 0a 40 ef 01 30 31 30 31 30 39 32  ......@..0101092
00000020: 31 30 39 30 30 30 30 31 ff ff ff ff ff ff ff ff  10900001........
00000030: 00 01 3a 01 00 08 02 00 da 11 00 00 b1 ff ff ff  ..:.............
00000040: ff ff ff ff ff 08 02 00 da 11 c4 04 b1 ff ff ff  ................
00000050: ff ff ff ff 10 26 00 00 04 03 09 04 10 03 41 00  .....&........A.
00000060: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00  f.a.t.e.c.h...D.
00000070: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00  V.B.-.T. .2. .0.
00000080: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00  1.0.1.0.1.0.1.0.
00000090: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff  6.0.0.0.0.1.....
000000a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
000000b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
000000c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
000000d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
000000e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
000000f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
af9015_eeprom_hash: eeprom sum=403c71e6
af9015_read_config: IR mode:1
af9015_read_config: TS mode:1
af9015_read_config: [0] xtal:2 set adc_clock:28000
af9015_read_config: [0] IF1:4570
af9015_read_config: [0] MT2060 IF1:0
af9015_read_config: [0] tuner id:177
af9015_read_config: [1] xtal:2 set adc_clock:28000
af9015_read_config: [1] IF1:4570
af9015_read_config: [1] MT2060 IF1:1220
af9015_read_config: [1] tuner id:177
check for cold 15a4 9015
check for cold 15a4 9016
af9015_identify_state: reply:02
dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
power control: 1
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
all in all I will use 98136 bytes for streaming
allocating buffer 0
buffer 0: f4dd8000 (dma: 886931456)
allocating buffer 1
buffer 1: f4da8000 (dma: 886734848)
allocating buffer 2
buffer 2: f4dac000 (dma: 886751232)
allocating buffer 3
buffer 3: f4dd0000 (dma: 886898688)
allocating buffer 4
buffer 4: f4dd4000 (dma: 886915072)
allocating buffer 5
buffer 5: f4de0000 (dma: 886964224)
allocation successful
DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
DVB: register adapter0/demux0 @ minor: 0 (0x00)
DVB: register adapter0/dvr0 @ minor: 1 (0x01)
DVB: register adapter0/net0 @ minor: 2 (0x02)
af9015_af9013_frontend_attach: init I2C
af9015_i2c_init:
af9013_attach: chip version:1 ROM version:1.0
af9013: firmware version:5.1.0.0
af9013_set_gpio: gpio:0 gpioval:07
af9013_set_gpio: gpio:1 gpioval:00
af9013_set_gpio: gpio:2 gpioval:00
af9013_set_gpio: gpio:3 gpioval:03
dvb_register_frontend
DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
DVB: register adapter0/frontend0 @ minor: 3 (0x03)
af9015_tuner_attach:
mxl5007t 2-00c0: creating new instance
af9013_i2c_gate_ctrl: enable:1
mxl5007t_get_chip_id: unknown rev (3f)
mxl5007t_get_chip_id: MxL5007T detected @ 2-00c0
af9013_i2c_gate_ctrl: enable:0
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
all in all I will use 98136 bytes for streaming
allocating buffer 0
buffer 0: f4dcc000 (dma: 886882304)
allocating buffer 1
buffer 1: f4de4000 (dma: 886980608)
allocating buffer 2
buffer 2: f4de8000 (dma: 886996992)
allocating buffer 3
buffer 3: f4dec000 (dma: 887013376)
allocating buffer 4
buffer 4: f4df0000 (dma: 887029760)
allocating buffer 5
buffer 5: f4df4000 (dma: 887046144)
allocation successful
DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
DVB: register adapter1/demux0 @ minor: 4 (0x04)
DVB: register adapter1/dvr0 @ minor: 5 (0x05)
DVB: register adapter1/net0 @ minor: 6 (0x06)
af9015_copy_firmware:
af9015_copy_firmware: firmware status:0c
af9013_attach: chip version:1 ROM version:0.0
af9013_download_firmware: firmware status:0c
af9013: found a 'Afatech AF9013 DVB-T' in warm state.
af9013: firmware version:5.1.0.0
af9013_set_gpio: gpio:0 gpioval:03
af9013_set_gpio: gpio:1 gpioval:03
af9013_set_gpio: gpio:2 gpioval:00
af9013_set_gpio: gpio:3 gpioval:00
dvb_register_frontend
DVB: registering adapter 1 frontend 0 (Afatech AF9013 DVB-T)...
DVB: register adapter1/frontend0 @ minor: 7 (0x07)
af9015_tuner_attach:
mxl5007t 3-00c0: creating new instance
af9013_i2c_gate_ctrl: enable:1
af9015: command failed:2
mxl5007t_read_reg: 506: failed!
mxl5007t_get_chip_id: error -121 on line 788
mxl5007t_get_chip_id: unable to identify device @ 3-00c0
af9013_i2c_gate_ctrl: enable:0
mxl5007t_attach: error -121 on line 866
power control: 0
dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully initialized and 
connected.
af9015_init:
af9015_init_endpoint: USB speed:3
usbcore: registered new interface driver dvb_usb_af9015
...

<tuner #1 tuning succeed>
  tzap -a0 -c channels.conf "RTL TV"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file 'channels.conf'
tuning to 570000000 Hz
video pid 0x012d, audio pid 0x012e
status 03 | signal 67b9 | snr 00f0 | ber 00000000 | unc 00000000 |
status 1f | signal 67b9 | snr 00f0 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 7a5b | snr 0078 | ber 0000000e | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 7a5b | snr 0078 | ber 0000000e | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 7a5b | snr 00f0 | ber 00000032 | unc 00000000 | 
FE_HAS_LOCK
^C
dmesg:
dvb_frontend_open
dvb_frontend_start
dvb_frontend_ioctl (61)
dvb_frontend_thread
DVB: initialising adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
power control: 1
af9013_init
af9013_reset
af9013_power_ctrl: onoff:1
af9013_set_adc_ctrl: adc_clock:28000
af913_div: a:28000000 b:1000000 x:19
af913_div: a:0 b:1000000 x:19 r:14680064 r:e00000
af9013_set_adc_ctrl: adc_cw:00 00 e0
af9013_init: load ofsm settings
af9013_init: load tuner specific settings
af9013_init: setting ts mode
af9013_lock_led: onoff:1
af9013_i2c_gate_ctrl: enable:1
af9013_i2c_gate_ctrl: enable:1
af9013_i2c_gate_ctrl: enable:0
af9013_i2c_gate_ctrl: enable:0
dvb_frontend_ioctl (76)
dvb_frontend_add_event
start pid: 0x012d, feedtype: 0
setting pid (no):   301 012d at index 0 'on'
submitting all URBs
submitting URB no. 0
submitting URB no. 1
submitting URB no. 2
submitting URB no. 3
submitting URB no. 4
submitting URB no. 5
controlling pid parser
af9015_pid_filter_ctrl: onoff:0
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0 
auto_sub_step:0 started_auto_step:0
af9013_set_frontend: freq:570000000 bw:0
af9013_i2c_gate_ctrl: enable:1
start feeding
start pid: 0x012e, feedtype: 0
setting pid (no):   302 012e at index 1 'on'
dvb_frontend_ioctl (69)
af9013_i2c_gate_ctrl: enable:0
af9013_set_coeff: adc_clock:28000 bw:0
af9013_set_coeff: coeff:02 9c bc 15 05 39 78 0a 00 a7 34 3f 00 a7 2f 05 
00 a7 29 cc 01 4e 5e 03
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:34 e4 14
af9013_set_frontend: manual TPS
'bulk' urb completed. status: 0, length: 512/16356, pack_num: 0, errors: 0
af9013_update_signal_strength
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (71)
dvb_frontend_ioctl (72)
dvb_frontend_ioctl (70)
dvb_frontend_ioctl (73)
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
...
dvb_frontend_add_event
af9013_get_frontend
dvb_frontend_swzigzag_update_delay
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
...
dvb_frontend_ioctl (69)
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (71)
dvb_frontend_ioctl (72)
dvb_frontend_ioctl (70)
dvb_frontend_ioctl (73)
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
...
dvb_frontend_ioctl (69)
af9013_update_signal_strength
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
...
af9013_update_ber_unc: err bits:26 total bits:16320000 abort count:0
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (71)
dvb_frontend_ioctl (72)
dvb_frontend_ioctl (70)
dvb_frontend_ioctl (73)
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
...
dvb_frontend_swzigzag_update_delay
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
...
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (71)
dvb_frontend_ioctl (72)
dvb_frontend_ioctl (70)
dvb_frontend_ioctl (73)
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
...
dvb_frontend_swzigzag_update_delay
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
...
af9013_update_signal_strength
dvb_frontend_ioctl (69)
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
...
af9013_update_ber_unc: err bits:18 total bits:16320000 abort count:0
dvb_frontend_swzigzag_update_delay
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (71)
dvb_frontend_ioctl (72)
dvb_frontend_ioctl (70)
dvb_frontend_ioctl (73)
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
'bulk' urb completed. status: 0, length: 16356/16356, pack_num: 0, errors: 0
...
dvb_frontend_release
stop pid: 0x012d, feedtype: 0
setting pid (no):   301 012d at index 0 'off'
stop pid: 0x012e, feedtype: 0
stop feeding
killing URB no. 0.
'bulk' urb completed. status: -2, length: 0/16356, pack_num: 0, errors: 0
killing URB no. 1.
'bulk' urb completed. status: -2, length: 0/16356, pack_num: 0, errors: 0
killing URB no. 2.
'bulk' urb completed. status: -2, length: 0/16356, pack_num: 0, errors: 0
killing URB no. 3.
'bulk' urb completed. status: -2, length: 4608/16356, pack_num: 0, errors: 0
killing URB no. 4.
'bulk' urb completed. status: -2, length: 0/16356, pack_num: 0, errors: 0
killing URB no. 5.
'bulk' urb completed. status: -2, length: 0/16356, pack_num: 0, errors: 0
setting pid (no):   302 012e at index 1 'off'
af9013_i2c_gate_ctrl: enable:1
af9013_i2c_gate_ctrl: enable:1
af9013_i2c_gate_ctrl: enable:0
af9013_i2c_gate_ctrl: enable:0
af9013_sleep
af9013_lock_led: onoff:0
af9013_power_ctrl: onoff:0
af9013_reset
power control: 0
</tuner #1 tuning succeed>

<tuner #2 tuning failed>
  tzap -a1 -c channels.conf "RTL TV"
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
reading channels from file 'channels.conf'
tuning to 570000000 Hz
video pid 0x012d, audio pid 0x012e
status 00 | signal 0000 | snr 0078 | ber 00000000 | unc 00000000 |
status 03 | signal 0000 | snr 0078 | ber 00000000 | unc 00000000 |
status 03 | signal 0000 | snr 0078 | ber 00000000 | unc 00000000 |
status 03 | signal 0000 | snr 0078 | ber 00000000 | unc 00000000 |
status 03 | signal 0000 | snr 0078 | ber 00000000 | unc 00000000 |
^C
dmesg:
dvb_frontend_open
dvb_frontend_start
dvb_frontend_ioctl (61)
dvb_frontend_thread
DVB: initialising adapter 1 frontend 0 (Afatech AF9013 DVB-T)...
power control: 1
af9013_init
af9013_reset
af9013_power_ctrl: onoff:1
af9013_set_adc_ctrl: adc_clock:28000
af913_div: a:28000000 b:1000000 x:19
af913_div: a:0 b:1000000 x:19 r:14680064 r:e00000
af9013_set_adc_ctrl: adc_cw:00 00 e0
af9013_init: load ofsm settings
af9013_init: load tuner specific settings
af9013_init: setting ts mode
af9013_lock_led: onoff:1
dvb_frontend_ioctl (76)
dvb_frontend_add_event
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:0 
auto_sub_step:0 started_auto_step:0
af9013_set_frontend: freq:570000000 bw:0
af9013_set_coeff: adc_clock:28000 bw:0
af9013_set_coeff: coeff:02 9c bc 15 05 39 78 0a 00 a7 34 3f 00 a7 2f 05 
00 a7 29 cc 01 4e 5e 03
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:34 e4 14
af9013_set_frontend: manual TPS
dvb_frontend_ioctl (69)
af9013_update_signal_strength
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
dvb_frontend_add_event
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0 
auto_sub_step:1 started_auto_step:0
af9013_set_frontend: freq:570000000 bw:0
af9013_set_coeff: adc_clock:28000 bw:0
af9013_set_coeff: coeff:02 9c bc 15 05 39 78 0a 00 a7 34 3f 00 a7 2f 05 
00 a7 29 cc 01 4e 5e 03
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:34 e4 14
af9013_set_frontend: manual TPS
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
af9013_update_signal_strength
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:1 
auto_sub_step:0 started_auto_step:0
af9013_set_frontend: freq:570000000 bw:0
af9013_set_coeff: adc_clock:28000 bw:0
af9013_set_coeff: coeff:02 9c bc 15 05 39 78 0a 00 a7 34 3f 00 a7 2f 05 
00 a7 29 cc 01 4e 5e 03
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:34 e4 14
af9013_set_frontend: manual TPS
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (76)
dvb_frontend_add_event
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0 
auto_sub_step:0 started_auto_step:0
af9013_set_frontend: freq:570000000 bw:0
af9013_set_coeff: adc_clock:28000 bw:0
af9013_set_coeff: coeff:02 9c bc 15 05 39 78 0a 00 a7 34 3f 00 a7 2f 05 
00 a7 29 cc 01 4e 5e 03
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:34 e4 14
af9013_set_frontend: manual TPS
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
af9013_update_signal_strength
dvb_frontend_ioctl (69)
dvb_frontend_add_event
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:0 
auto_sub_step:1 started_auto_step:0
af9013_set_frontend: freq:570000000 bw:0
af9013_set_coeff: adc_clock:28000 bw:0
af9013_set_coeff: coeff:02 9c bc 15 05 39 78 0a 00 a7 34 3f 00 a7 2f 05 
00 a7 29 cc 01 4e 5e 03
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:34 e4 14
af9013_set_frontend: manual TPS
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:1 
auto_sub_step:0 started_auto_step:0
af9013_set_frontend: freq:570000000 bw:0
af9013_set_coeff: adc_clock:28000 bw:0
af9013_set_coeff: coeff:02 9c bc 15 05 39 78 0a 00 a7 34 3f 00 a7 2f 05 
00 a7 29 cc 01 4e 5e 03
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:34 e4 14
af9013_set_frontend: manual TPS
dvb_frontend_ioctl (69)
af9013_update_signal_strength
dvb_frontend_ioctl (69)
dvb_frontend_release
af9013_sleep
af9013_lock_led: onoff:0
af9013_power_ctrl: onoff:0
af9013_reset
power control: 0
dvb_frontend_open
dvb_frontend_start
dvb_frontend_ioctl (61)
dvb_frontend_thread
DVB: initialising adapter 1 frontend 0 (Afatech AF9013 DVB-T)...
power control: 1
af9013_init
af9013_reset
af9013_power_ctrl: onoff:1
af9013_set_adc_ctrl: adc_clock:28000
af913_div: a:28000000 b:1000000 x:19
af913_div: a:0 b:1000000 x:19 r:14680064 r:e00000
af9013_set_adc_ctrl: adc_cw:00 00 e0
af9013_init: load ofsm settings
af9013_init: load tuner specific settings
af9013_init: setting ts mode
af9013_lock_led: onoff:1
dvb_frontend_ioctl (76)
dvb_frontend_add_event
start pid: 0x012d, feedtype: 0
setting pid (no):   301 012d at index 0 'on'
submitting all URBs
submitting URB no. 0
submitting URB no. 1
submitting URB no. 2
submitting URB no. 3
submitting URB no. 4
submitting URB no. 5
controlling pid parser
start feeding
start pid: 0x012e, feedtype: 0
setting pid (no):   302 012e at index 1 'on'
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (71)
af9013_update_signal_strength
dvb_frontend_ioctl (72)
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:0 
auto_sub_step:0 started_auto_step:0
af9013_set_frontend: freq:570000000 bw:0
af9013_set_coeff: adc_clock:28000 bw:0
af9013_set_coeff: coeff:02 9c bc 15 05 39 78 0a 00 a7 34 3f 00 a7 2f 05 
00 a7 29 cc 01 4e 5e 03
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:34 e4 14
af9013_set_frontend: manual TPS
dvb_frontend_ioctl (70)
dvb_frontend_ioctl (73)
dvb_frontend_add_event
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0 
auto_sub_step:1 started_auto_step:0
af9013_set_frontend: freq:570000000 bw:0
af9013_set_coeff: adc_clock:28000 bw:0
af9013_set_coeff: coeff:02 9c bc 15 05 39 78 0a 00 a7 34 3f 00 a7 2f 05 
00 a7 29 cc 01 4e 5e 03
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:34 e4 14
af9013_set_frontend: manual TPS
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (71)
dvb_frontend_ioctl (72)
dvb_frontend_ioctl (70)
dvb_frontend_ioctl (73)
af9013_update_signal_strength
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:1 
auto_sub_step:0 started_auto_step:0
af9013_set_frontend: freq:570000000 bw:0
af9013_set_coeff: adc_clock:28000 bw:0
af9013_set_coeff: coeff:02 9c bc 15 05 39 78 0a 00 a7 34 3f 00 a7 2f 05 
00 a7 29 cc 01 4e 5e 03
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:34 e4 14
af9013_set_frontend: manual TPS
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (71)
dvb_frontend_ioctl (72)
dvb_frontend_ioctl (70)
dvb_frontend_ioctl (73)
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:1 
auto_sub_step:1 started_auto_step:0
af9013_set_frontend: freq:570000000 bw:0
af9013_set_coeff: adc_clock:28000 bw:0
af9013_set_coeff: coeff:02 9c bc 15 05 39 78 0a 00 a7 34 3f 00 a7 2f 05 
00 a7 29 cc 01 4e 5e 03
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:34 e4 14
af9013_set_frontend: manual TPS
dvb_frontend_ioctl (69)
af9013_update_signal_strength
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (71)
dvb_frontend_ioctl (72)
dvb_frontend_ioctl (70)
dvb_frontend_ioctl (73)
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:2 
auto_sub_step:0 started_auto_step:0
af9013_set_frontend: freq:570000000 bw:0
af9013_set_coeff: adc_clock:28000 bw:0
af9013_set_coeff: coeff:02 9c bc 15 05 39 78 0a 00 a7 34 3f 00 a7 2f 05 
00 a7 29 cc 01 4e 5e 03
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:34 e4 14
af9013_set_frontend: manual TPS
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (69)
dvb_frontend_ioctl (71)
dvb_frontend_ioctl (72)
dvb_frontend_ioctl (70)
dvb_frontend_ioctl (73)
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:2 
auto_sub_step:1 started_auto_step:0
af9013_set_frontend: freq:570000000 bw:0
af9013_set_coeff: adc_clock:28000 bw:0
af9013_set_coeff: coeff:02 9c bc 15 05 39 78 0a 00 a7 34 3f 00 a7 2f 05 
00 a7 29 cc 01 4e 5e 03
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:cc 1b 6b
af913_div: a:4570000 b:28000000 x:23
af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
af9013_set_freq_ctrl: freq_cw:34 e4 14
af9013_set_frontend: manual TPS
dvb_frontend_release
stop pid: 0x012d, feedtype: 0
setting pid (no):   301 012d at index 0 'off'
stop pid: 0x012e, feedtype: 0
stop feeding
killing URB no. 0.
'bulk' urb completed. status: -2, length: 0/16356, pack_num: 0, errors: 0
killing URB no. 1.
'bulk' urb completed. status: -2, length: 0/16356, pack_num: 0, errors: 0
killing URB no. 2.
'bulk' urb completed. status: -2, length: 0/16356, pack_num: 0, errors: 0
killing URB no. 3.
'bulk' urb completed. status: -2, length: 0/16356, pack_num: 0, errors: 0
killing URB no. 4.
'bulk' urb completed. status: -2, length: 0/16356, pack_num: 0, errors: 0
killing URB no. 5.
'bulk' urb completed. status: -2, length: 0/16356, pack_num: 0, errors: 0
setting pid (no):   302 012e at index 1 'off'
af9013_sleep
af9013_lock_led: onoff:0
af9013_power_ctrl: onoff:0
af9013_reset
power control: 0
</tuner #2 tuning failed>

p.s.
Boot from G3 aka Mechanical Off
tuner #1 and tuner #2 fully functional

p.p.s.
Boot from G2 (S5) aka Soft Off
or
Resume from G1 - S3 aka Suspend to RAM
tuner #1 and tuner #2 functional WITH module option:
dvb-core dvb_powerdown_on_sleep=0
namely dvb_powerdown_on_sleep:
0: do not power down,
1: turn LNB voltage off on sleep (default) (int)

Antti, is this the same case with TerraTec Cinergy T Stick Dual RC and
is this the only solution, to keep the tuners on with "dvb-core 
dvb_powerdown_on_sleep=0"?

regards,
poma

