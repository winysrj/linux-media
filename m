Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <andrew.williams@joratech.com>) id 1KhWl4-0007ly-4F
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 23:46:47 +0200
MIME-Version: 1.0
Date: Mon, 22 Sep 2008 07:43:20 +1000
Content-class: urn:content-classes:message
Message-ID: <546B4176F0487A4CBA62FC16EFC1D9D603D4B9@EXCHANGE.joratech.com>
References: <E57779B45D7559418D2EA8B6EC615674047F0A11@EXCHANGE.joratech.com>
From: "Andrew Williams" <andrew.williams@joratech.com>
To: <linux-dvb@linuxtv.org>
Subject: [linux-dvb] KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) / Afatech
	af9015 missing adapter1
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1165260582=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1165260582==
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C91C33.8646DBD7"
Content-class: urn:content-classes:message

This is a multi-part message in MIME format.

------_=_NextPart_001_01C91C33.8646DBD7
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Good day everybody,

Apologies if this is in HTML, sending from Outlook Web Access at the =
moment.

I am having a problem with the KWorld PlusTV Dual DVB-T Stick (DVB-T =
399U) / Afatech af9015 USB stick.

Firstly, thank you very much for the effort that everybody is putting =
into this. Much appreciated.

Back to my problem:

The above tuner only registers one adapter in /dev/dvb with the latest
build from http://linuxtv.org/hg/~anttip/af9015/

It does that under warmboot (firmware loaded) and coldboot conditions.

I have an older driver from http://linuxtv.org/hg/~anttip/af9015/ dated =
the 13/09/2008
which works perfectly under coldboot conditions in that it registers =
adapter0 and adapter1 with frontend0 under each adapter.
Unfortunately it does not work that well under warmboot conditions as it
registers adapter0 and adapter1 but only registers a frontend0 under =
adapter0.
It fails to registers frontend0 under adapter1.

Thus the reason for me to try and upgrade to a later/more current =
driver.

I am trying to provide as much info as possible, so my apologies if =
there is too much text attached.

Greatly appreciate if anybody could help me with regards to this.

Again, thanks for all the good work.

Regards


Latest from hg:
root@myth:~/af9015# uname -r
2.6.24-21-generic

hg clone http://linuxtv.org/hg/~anttip/af9015/

root@myth:~/af9015# hg log|more
changeset:   8969:b54d54d9d489
tag:         tip
user:        Antti Palosaari <crope@iki.fi>
date:        Sat Sep 20 00:34:06 2008 +0300
summary:     af9015: cleanup

changeset:   8968:ec8c45afda9e
user:        Antti Palosaari <crope@iki.fi>
date:        Sat Sep 20 00:26:05 2008 +0300
summary:     af9015: Add USB ID for Telestar Starstick 2

changeset:   8967:3897e8774246
user:        Antti Palosaari <crope@iki.fi>
date:        Tue Sep 16 20:22:43 2008 +0300
summary:     af9013: fix compile error coming from u64 div

changeset:   8966:86a15e6b2d89
user:        Antti Palosaari <crope@iki.fi>
date:        Mon Sep 15 23:18:09 2008 +0300
summary:     initial driver for af9015 chipset

changeset:   8965:db7c9edd25ef
user:        Antti Palosaari <crope@iki.fi>
date:        Mon Sep 15 21:01:52 2008 +0300
summary:     initial driver for af9013 demodulator

changeset:   8964:21c2419a92f1
user:        Antti Palosaari <crope@iki.fi>
date:        Mon Sep 15 20:34:31 2008 +0300
summary:     mt2060: implement I2C-gate control


modprobe -v dvb_usb_af9015 debug=3D3
Dmesg:
[  308.285527] usbcore: deregistering interface driver dvb_usb_af9015
[  308.337132] dvb-usb: KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) =
successfully deinitialized and disconnected.
[  311.632038] af9015_usb_probe: interface:0
[  311.633455] af9015_read_config: IR mode:1
[  311.635200] af9015_read_config: TS mode:1
[  311.637198] af9015_read_config: [0] xtal:2 set adc_clock:28000
[  311.641192] af9015_read_config: [0] IF1:4570
[  311.645187] af9015_read_config: [0] MT2060 IF1:0
[  311.647185] af9015_read_config: [0] tuner id:13
[  311.648932] af9015_identify_state: reply:02
[  311.648935] dvb-usb: found a 'KWorld PlusTV Dual DVB-T Stick (DVB-T =
399U)' in warm state.
[  311.648974] dvb-usb: will pass the complete MPEG2 transport stream to =
the software demuxer.
[  311.650063] DVB: registering new adapter (KWorld PlusTV Dual DVB-T =
Stick (DVB-T 399U))
[  311.650223] af9015_af9013_frontend_attach: init I2C
[  311.650225] af9015_i2c_init:
[  311.689134] 00: 2b 3f 9b 0b 00 00 00 00 80 1b 99 e3 00 02 01 02
[  311.723089] 10: 00 80 00 fa fa 10 40 ef 01 30 31 30 31 30 39 30
[  311.755052] 20: 38 30 36 30 30 30 30 31 ff ff ff ff ff ff ff ff
[  311.787010] 30: 00 01 3a 01 00 08 02 00 da 11 00 00 0d ff ff ff
[  311.818971] 40: ff ff ff ff ff 08 02 00 da 11 00 00 0d ff ff ff
[  311.850929] 50: ff ff ff ff ff 24 00 00 04 03 09 04 10 03 41 00
[  311.882889] 60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00
[  311.914847] 70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00
[  311.946808] 80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
[  311.978768] 90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
[  312.010726] a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  312.041683] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  312.073647] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  312.105607] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  312.137565] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  312.169526] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  312.202230] af9013: firmware version:4.95.0
[  312.226205] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
[  312.226237] af9015_tuner_attach:
[  312.253161] MXL5005S: Attached at address 0xc6
[  312.253230] input: IR-receiver inside an USB DVB receiver as =
/devices/pci0000:00/0000:00:02.1/usb3/3-5/input/input13
[  312.294242] dvb-usb: schedule remote query interval to 150 msecs.
[  312.294247] dvb-usb: KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) =
successfully initialized and connected.
[  312.294250] af9015_init:
[  312.294252] af9015_init_endpoint: USB speed:3
[  312.338061] af9015_download_ir_table:
[  312.953297] usbcore: registered new interface driver dvb_usb_af9015

root@myth:/home/awilliams# ls -l /dev/dvb/*
total 0
crw-rw----+ 1 root video 212, 4 2008-09-21 21:13 demux0
crw-rw----+ 1 root video 212, 5 2008-09-21 21:13 dvr0
crw-rw----+ 1 root video 212, 3 2008-09-21 21:13 frontend0
crw-rw----+ 1 root video 212, 7 2008-09-21 21:13 net0

Cold Boot:
[  428.767893] usb 3-5: new high speed USB device using ehci_hcd and =
address 7
[  428.903593] usb 3-5: configuration #1 chosen from 1 choice
[  428.903908] af9015_usb_probe: interface:0
[  428.906130] af9015_read_config: IR mode:1
[  428.908167] af9015_read_config: TS mode:1
[  428.910192] af9015_read_config: [0] xtal:2 set adc_clock:28000
[  428.914122] af9015_read_config: [0] IF1:4570
[  428.918119] af9015_read_config: [0] MT2060 IF1:0
[  428.920113] af9015_read_config: [0] tuner id:13
[  428.921859] af9015_identify_state: reply:01
[  428.921863] dvb-usb: found a 'KWorld PlusTV Dual DVB-T Stick (DVB-T =
399U)' in cold state, will try to load a firmware
[  428.923766] dvb-usb: downloading firmware from file =
'dvb-usb-af9015.fw'
[  428.923771] af9015_download_firmware:
[  429.001777] af9015_usb_probe: interface:1
[  429.001842] usb 3-5: USB disconnect, address 7
[  429.008901] af9015_usb_device_exit:
[  429.008906] dvb-usb: generic DVB-USB module successfully =
deinitialized and disconnected.
[  429.008951] af9015_usb_device_exit:
[  429.008954] dvb-usb: generic DVB-USB module successfully =
deinitialized and disconnected.
[  429.247020] usb 3-5: new high speed USB device using ehci_hcd and =
address 8
[  429.383486] usb 3-5: configuration #1 chosen from 1 choice
[  429.383797] af9015_usb_probe: interface:0
[  429.385520] af9015_read_config: IR mode:1
[  429.387518] af9015_read_config: TS mode:1
[  429.389525] af9015_read_config: [0] xtal:2 set adc_clock:28000
[  429.393514] af9015_read_config: [0] IF1:4570
[  429.397507] af9015_read_config: [0] MT2060 IF1:0
[  429.399504] af9015_read_config: [0] tuner id:13
[  429.401251] af9015_identify_state: reply:02
[  429.401255] dvb-usb: found a 'KWorld PlusTV Dual DVB-T Stick (DVB-T =
399U)' in warm state.
[  429.401293] dvb-usb: will pass the complete MPEG2 transport stream to =
the software demuxer.
[  429.402380] DVB: registering new adapter (KWorld PlusTV Dual DVB-T =
Stick (DVB-T 399U))
[  429.402532] af9015_af9013_frontend_attach: init I2C
[  429.402535] af9015_i2c_init:
[  429.439456] 00: 2b 3f 9b 0b 00 00 00 00 80 1b 99 e3 00 02 01 02
[  429.472691] 10: 00 80 00 fa fa 10 40 ef 01 30 31 30 31 30 39 30
[  429.504373] 20: 38 30 36 30 30 30 30 31 ff ff ff ff ff ff ff ff
[  429.536332] 30: 00 01 3a 01 00 08 02 00 da 11 00 00 0d ff ff ff
[  429.568291] 40: ff ff ff ff ff 08 02 00 da 11 00 00 0d ff ff ff
[  429.600251] 50: ff ff ff ff ff 24 00 00 04 03 09 04 10 03 41 00
[  429.632210] 60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00
[  429.664170] 70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00
[  429.696129] 80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
[  429.728089] 90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
[  429.760048] a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  429.792007] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  429.822968] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  429.854928] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  429.886888] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  429.918846] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  429.930581] af9013: firmware version:4.95.0
[  429.954554] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
[  429.954588] af9015_tuner_attach:
[  429.954635] MXL5005S: Attached at address 0xc6
[  429.954691] input: IR-receiver inside an USB DVB receiver as =
/devices/pci0000:00/0000:00:02.1/usb3/3-5/input/input14
[  429.995007] dvb-usb: schedule remote query interval to 150 msecs.
[  429.995015] dvb-usb: KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) =
successfully initialized and connected.
[  429.995018] af9015_init:
[  429.995020] af9015_init_endpoint: USB speed:3
[  430.039222] af9015_download_ir_table:
[  430.656474] input: Afatech DVB-T 2 as =
/devices/pci0000:00/0000:00:02.1/usb3/3-5/3-5:1.1/input/input15
[  430.689731] input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] =
on usb-0000:00:02.1-5

root@myth:~/af9015# ls -l /dev/dvb/*
total 0
crw-rw----+ 1 root video 212, 4 2008-09-21 22:30 demux0
crw-rw----+ 1 root video 212, 5 2008-09-21 22:30 dvr0
crw-rw----+ 1 root video 212, 3 2008-09-21 22:30 frontend0
crw-rw----+ 1 root video 212, 7 2008-09-21 22:30 net0
root@myth:~/af9015#



Older driver info and results below:
Driver 13 Sept 2008 http://linuxtv.org/hg/~anttip/af9015/
af9015-c560fdca9848:

Cold Boot:

Dmesg:
[  983.072405] usb 1-5: USB disconnect, address 3
[  983.072693] af9015_usb_device_exit:
[  983.072696] af9015_i2c_exit:
[  983.073070] dvb-usb: KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) =
successfully deinitialized and disconnected.
[  987.538084] usb 1-5: new high speed USB device using ehci_hcd and =
address 5
[  987.674237] usb 1-5: configuration #1 chosen from 1 choice
[  987.674547] af9015_usb_probe: interface:0
[  987.676770] af9015_read_config: IR mode:1
[  987.678768] af9015_read_config: TS mode:1
[  987.682764] af9015_read_config: [0] xtal:2 set adc_clock:28000
[  987.686760] af9015_read_config: [0] IF1:4570
[  987.690754] af9015_read_config: [0] MT2060 IF1:0
[  987.692750] af9015_read_config: [0] tuner id:13
[  987.694749] af9015_read_config: [1] xtal:2 set adc_clock:28000
[  987.698744] af9015_read_config: [1] IF1:4570
[  987.702738] af9015_read_config: [1] MT2060 IF1:0
[  987.704736] af9015_read_config: [1] tuner id:13
[  987.706484] af9015_identify_state: reply:01
[  987.706488] dvb-usb: found a 'KWorld PlusTV Dual DVB-T Stick (DVB-T =
399U)' in cold state, will try to load a firmware
[  987.766336] dvb-usb: downloading firmware from file =
'dvb-usb-af9015.fw'
[  987.766342] af9015_download_firmware:
[  987.844323] af9015_usb_probe: interface:1
[  987.844385] usb 1-5: USB disconnect, address 5
[  987.851116] af9015_usb_device_exit:
[  987.851120] dvb-usb: generic DVB-USB module successfully =
deinitialized and disconnected.
[  987.851161] af9015_usb_device_exit:
[  987.851164] dvb-usb: generic DVB-USB module successfully =
deinitialized and disconnected.
[  988.089352] usb 1-5: new high speed USB device using ehci_hcd and =
address 6
[  988.226034] usb 1-5: configuration #1 chosen from 1 choice
[  988.226346] af9015_usb_probe: interface:0
[  988.228069] af9015_read_config: IR mode:1
[  988.230082] af9015_read_config: TS mode:1
[  988.234067] af9015_read_config: [0] xtal:2 set adc_clock:28000
[  988.238057] af9015_read_config: [0] IF1:4570
[  988.242053] af9015_read_config: [0] MT2060 IF1:0
[  988.244051] af9015_read_config: [0] tuner id:13
[  988.246048] af9015_read_config: [1] xtal:2 set adc_clock:28000
[  988.250043] af9015_read_config: [1] IF1:4570
[  988.254038] af9015_read_config: [1] MT2060 IF1:0
[  988.256035] af9015_read_config: [1] tuner id:13
[  988.257783] af9015_identify_state: reply:02
[  988.257787] dvb-usb: found a 'KWorld PlusTV Dual DVB-T Stick (DVB-T =
399U)' in warm state.
[  988.257824] dvb-usb: will pass the complete MPEG2 transport stream to =
the software demuxer.
[  988.258912] DVB: registering new adapter (KWorld PlusTV Dual DVB-T =
Stick (DVB-T 399U))
[  988.259062] af9015_af9013_frontend_attach: init I2C
[  988.259065] af9015_i2c_init:
[  988.294986] 00: 2b 3f 9b 0b 00 00 00 00 80 1b 99 e3 00 02 01 02
[  988.326944] 10: 00 80 00 fa fa 10 40 ef 01 30 31 30 31 30 39 30
[  988.358908] 20: 38 30 36 30 30 30 30 31 ff ff ff ff ff ff ff ff
[  988.390868] 30: 00 01 3a 01 00 08 02 00 da 11 00 00 0d ff ff ff
[  988.422826] 40: ff ff ff ff ff 08 02 00 da 11 00 00 0d ff ff ff
[  988.454786] 50: ff ff ff ff ff 24 00 00 04 03 09 04 10 03 41 00
[  988.486745] 60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00
[  988.518705] 70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00
[  988.550663] 80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
[  988.582625] 90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
[  988.614582] a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  988.646543] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  988.678500] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  988.710461] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  988.742421] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  988.774379] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  988.786115] af9013: firmware version:4.95.0
[  988.810086] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
[  988.810122] af9015_tuner_attach:
[  988.810165] MXL5005S: Attached at address 0xc6
[  988.810168] dvb-usb: will pass the complete MPEG2 transport stream to =
the software demuxer.
[  988.811208] DVB: registering new adapter (KWorld PlusTV Dual DVB-T =
Stick (DVB-T 399U))
[  988.811348] af9015_copy_firmware:
[  989.315443] af9015_copy_firmware: firmware copy done
[  989.421308] af9015_copy_firmware: firmware boot cmd status:0
[  989.526174] af9015_copy_firmware: firmware status cmd status:0 fw =
status:0c
[  989.637030] af9013: found a 'Afatech AF9013 DVB-T' in warm state.
[  989.643027] af9013: firmware version:4.95.0
[  989.670993] DVB: registering frontend 1 (Afatech AF9013 DVB-T)...
[  989.671027] af9015_tuner_attach:
[  989.671097] MXL5005S: Attached at address 0xc6
[  989.671101] dvb-usb: KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) =
successfully initialized and connected.
[  989.671105] af9015_init:
[  989.671106] af9015_init_endpoint: USB speed:3
[  989.726920] af9015_download_ir_table:
[  990.345588] input: Afatech DVB-T 2 as =
/devices/pci0000:00/0000:00:02.1/usb1/1-5/1-5:1.1/input/input10
[  990.383674] input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] =
on usb-0000:00:02.1-5
root@myth:~#

root@myth:~# ls -l /dev/dvb/*
/dev/dvb/adapter0:
total 0
crw-rw----+ 1 root video 212, 4 2008-09-21 21:34 demux0
crw-rw----+ 1 root video 212, 5 2008-09-21 21:34 dvr0
crw-rw----+ 1 root video 212, 3 2008-09-21 21:34 frontend0
crw-rw----+ 1 root video 212, 7 2008-09-21 21:34 net0

/dev/dvb/adapter1:
total 0
crw-rw----+ 1 root video 212, 68 2008-09-21 21:34 demux0
crw-rw----+ 1 root video 212, 69 2008-09-21 21:34 dvr0
crw-rw----+ 1 root video 212, 67 2008-09-21 21:34 frontend0
crw-rw----+ 1 root video 212, 71 2008-09-21 21:34 net0
root@myth:~#


Warm Boot:


Dmesg:

[   38.911448] af9015_usb_probe: interface:0
[   38.913790] af9015_read_config: IR mode:1
[   38.915786] af9015_read_config: TS mode:1
[   38.919782] af9015_read_config: [0] xtal:2 set adc_clock:28000
[   38.923777] af9015_read_config: [0] IF1:4570
[   38.927771] af9015_read_config: [0] MT2060 IF1:0
[   38.929768] af9015_read_config: [0] tuner id:13
[   38.931766] af9015_read_config: [1] xtal:2 set adc_clock:28000
[   38.935760] af9015_read_config: [1] IF1:4570
[   38.939756] af9015_read_config: [1] MT2060 IF1:0
[   38.941754] af9015_read_config: [1] tuner id:13
[   38.943517] af9015_identify_state: reply:02
[   38.943519] dvb-usb: found a 'KWorld PlusTV Dual DVB-T Stick (DVB-T =
399U)' in warm state.
[   38.943564] dvb-usb: will pass the complete MPEG2 transport stream to =
the software demuxer.
[   38.944631] DVB: registering new adapter (KWorld PlusTV Dual DVB-T =
Stick (DVB-T 399U))
[   38.944783] af9015_af9013_frontend_attach: init I2C
[   38.944785] af9015_i2c_init:
[   38.984699] 00: 2b 3f 9b 0b 00 00 00 00 80 1b 99 e3 00 02 01 02
[   39.016664] 10: 00 80 00 fa fa 10 40 ef 01 30 31 30 31 30 39 30
[   39.048617] 20: 38 30 36 30 30 30 30 31 ff ff ff ff ff ff ff ff
[   39.080575] 30: 00 01 3a 01 00 08 02 00 da 11 00 00 0d ff ff ff
[   39.112537] 40: ff ff ff ff ff 08 02 00 da 11 00 00 0d ff ff ff
[   39.144505] 50: ff ff ff ff ff 24 00 00 04 03 09 04 10 03 41 00
[   39.176462] 60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00
[   39.210415] 70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00
[   39.242369] 80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
[   39.274329] 90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
[   39.306290] a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   39.338255] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   39.370207] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   39.402168] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   39.434137] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   39.466086] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   39.532752] af9013: firmware version:4.95.0
[   39.556724] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
[   39.556755] af9015_tuner_attach:
[   39.614630] MXL5005S: Attached at address 0xc6
[   39.614635] dvb-usb: will pass the complete MPEG2 transport stream to =
the software demuxer.
[   39.615783] DVB: registering new adapter (KWorld PlusTV Dual DVB-T =
Stick (DVB-T 399U))
[   39.615936] af9015_copy_firmware:
[   39.779439] af9015_copy_firmware: firmware copy done
[   39.882310] af9015_copy_firmware: firmware boot cmd status:0
[   39.986177] af9015_copy_firmware: firmware status cmd status:0 fw =
status:00
[   39.988175] af9015_copy_firmware: firmware boot cmd status:0
[   40.090046] af9015_copy_firmware: firmware status cmd status:0 fw =
status:00
[   40.092043] af9015_copy_firmware: firmware boot cmd status:0
[   40.193914] af9015_copy_firmware: firmware status cmd status:0 fw =
status:00
[   40.195910] af9015_copy_firmware: firmware boot cmd status:0
[   40.297782] af9015_copy_firmware: firmware status cmd status:0 fw =
status:00
[   40.299779] af9015_copy_firmware: firmware boot cmd status:0
[   40.401650] af9015_copy_firmware: firmware status cmd status:0 fw =
status:00
[   40.403647] af9015_copy_firmware: firmware boot cmd status:0
[   40.505518] af9015_copy_firmware: firmware status cmd status:0 fw =
status:00
[   40.507515] af9015_copy_firmware: firmware boot cmd status:0
[   40.609384] af9015_copy_firmware: firmware status cmd status:0 fw =
status:00
[   40.611383] af9015_copy_firmware: firmware boot cmd status:0
[   40.713251] af9015_copy_firmware: firmware status cmd status:0 fw =
status:00
[   40.715247] af9015_copy_firmware: firmware boot cmd status:0
[   40.818117] af9015_copy_firmware: firmware status cmd status:0 fw =
status:00
[   40.820114] af9015_copy_firmware: firmware boot cmd status:0
[   40.921985] af9015_copy_firmware: firmware status cmd status:0 fw =
status:00
[   40.921987] af9015: firmware did not run
[   40.921989] af9015: firmware copy to 2nd frontend failed, will =
disable it
[   40.921992] dvb-usb: no frontend was attached by 'KWorld PlusTV Dual =
DVB-T Stick (DVB-T 399U)'
[   40.921995] dvb-usb: KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) =
successfully initialized and connected.
[   40.921997] af9015_init:
[   40.921999] af9015_init_endpoint: USB speed:3
[   40.965932] af9015_download_ir_table:
[   41.581174] usbcore: registered new interface driver dvb_usb_af9015


root@myth:~# ls -l /dev/dvb/*
/dev/dvb/adapter0:
total 0
crw-rw----+ 1 root video 212, 4 2008-09-21 21:18 demux0
crw-rw----+ 1 root video 212, 5 2008-09-21 21:18 dvr0
crw-rw----+ 1 root video 212, 3 2008-09-21 21:18 frontend0
crw-rw----+ 1 root video 212, 7 2008-09-21 21:18 net0

/dev/dvb/adapter1:
total 0
crw-rw----+ 1 root video 212, 68 2008-09-21 21:18 demux0
crw-rw----+ 1 root video 212, 69 2008-09-21 21:18 dvr0
crw-rw----+ 1 root video 212, 71 2008-09-21 21:18 net0
root@myth:~#




------_=_NextPart_001_01C91C33.8646DBD7
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">=0A=
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">=0A=
<HTML>=0A=
<HEAD>=0A=
=0A=
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7652.24">=0A=
<TITLE>KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) / Afatech af9015 =
missing adapter1 </TITLE>=0A=
</HEAD>=0A=
<BODY>=0A=
<DIV id=3DidOWAReplyText91891 dir=3Dltr>=0A=
<DIV dir=3Dltr><FONT size=3D2>Good&nbsp;day everybody,<BR></FONT></DIV>=0A=
<DIV dir=3Dltr><FONT size=3D2>Apologies if this is in HTML, sending from =
Outlook Web =0A=
Access at the moment.</DIV></FONT>=0A=
<DIV dir=3Dltr><FONT size=3D2><BR>I am having a problem with the KWorld =
PlusTV Dual =0A=
DVB-T Stick (DVB-T 399U) / Afatech af9015 USB stick.<BR><BR>Firstly, =
thank you =0A=
very much for the effort that everybody is putting into this. Much =0A=
appreciated.<BR><BR>Back to my problem:<BR><BR>The above tuner only =
registers =0A=
one adapter in /dev/dvb with the latest<BR>build from <A =0A=
href=3D"http://linuxtv.org/hg/~anttip/af9015/">http://linuxtv.org/hg/~ant=
tip/af9015/</A><BR><BR>It =0A=
does that under warmboot (firmware loaded) and coldboot =
conditions.<BR><BR>I =0A=
have an older driver from <A =0A=
href=3D"http://linuxtv.org/hg/~anttip/af9015/">http://linuxtv.org/hg/~ant=
tip/af9015/</A> =0A=
dated the 13/09/2008<BR>which works perfectly under coldboot conditions =
in that =0A=
it registers adapter0 and adapter1 with frontend0 under each =0A=
adapter.<BR>Unfortunately it does not work that well under warmboot =
conditions =0A=
as it<BR>registers adapter0 and adapter1 but only registers a frontend0 =
under =0A=
adapter0.<BR>It fails to registers frontend0 under adapter1.<BR><BR>Thus =
the =0A=
reason for me to try and upgrade to a later/more current =
driver.<BR><BR>I am =0A=
trying to provide as much info as possible, so my apologies if there is =
too much =0A=
text attached.<BR><BR>Greatly appreciate if anybody could help me with =
regards =0A=
to this.<BR><BR>Again, thanks for all the good =0A=
work.<BR><BR>Regards<BR><BR><BR>Latest from hg:<BR>root@myth:~/af9015# =
uname =0A=
-r<BR>2.6.24-21-generic<BR><BR>hg clone <A =0A=
href=3D"http://linuxtv.org/hg/~anttip/af9015/">http://linuxtv.org/hg/~ant=
tip/af9015/</A><BR><BR>root@myth:~/af9015# =0A=
hg log|more<BR>changeset:&nbsp;&nbsp; =0A=
8969:b54d54d9d489<BR>tag:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 =0A=
tip<BR>user:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Antti Palosaari =0A=
&lt;crope@iki.fi&gt;<BR>date:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Sat Sep =0A=
20 00:34:06 2008 +0300<BR>summary:&nbsp;&nbsp;&nbsp;&nbsp; af9015: =0A=
cleanup<BR><BR>changeset:&nbsp;&nbsp; =0A=
8968:ec8c45afda9e<BR>user:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Antti =0A=
Palosaari =0A=
&lt;crope@iki.fi&gt;<BR>date:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Sat Sep =0A=
20 00:26:05 2008 +0300<BR>summary:&nbsp;&nbsp;&nbsp;&nbsp; af9015: Add =
USB ID =0A=
for Telestar Starstick 2<BR><BR>changeset:&nbsp;&nbsp; =0A=
8967:3897e8774246<BR>user:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Antti =0A=
Palosaari =0A=
&lt;crope@iki.fi&gt;<BR>date:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Tue Sep =0A=
16 20:22:43 2008 +0300<BR>summary:&nbsp;&nbsp;&nbsp;&nbsp; af9013: fix =
compile =0A=
error coming from u64 div<BR><BR>changeset:&nbsp;&nbsp; =0A=
8966:86a15e6b2d89<BR>user:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Antti =0A=
Palosaari =0A=
&lt;crope@iki.fi&gt;<BR>date:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Mon Sep =0A=
15 23:18:09 2008 +0300<BR>summary:&nbsp;&nbsp;&nbsp;&nbsp; initial =
driver for =0A=
af9015 chipset<BR><BR>changeset:&nbsp;&nbsp; =0A=
8965:db7c9edd25ef<BR>user:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Antti =0A=
Palosaari =0A=
&lt;crope@iki.fi&gt;<BR>date:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Mon Sep =0A=
15 21:01:52 2008 +0300<BR>summary:&nbsp;&nbsp;&nbsp;&nbsp; initial =
driver for =0A=
af9013 demodulator<BR><BR>changeset:&nbsp;&nbsp; =0A=
8964:21c2419a92f1<BR>user:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Antti =0A=
Palosaari =0A=
&lt;crope@iki.fi&gt;<BR>date:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Mon Sep =0A=
15 20:34:31 2008 +0300<BR>summary:&nbsp;&nbsp;&nbsp;&nbsp; mt2060: =
implement =0A=
I2C-gate control<BR><BR><BR>modprobe -v dvb_usb_af9015 =0A=
debug=3D3<BR>Dmesg:<BR>[&nbsp; 308.285527] usbcore: deregistering =
interface driver =0A=
dvb_usb_af9015<BR>[&nbsp; 308.337132] dvb-usb: KWorld PlusTV Dual DVB-T =
Stick =0A=
(DVB-T 399U) successfully deinitialized and disconnected.<BR>[&nbsp; =
311.632038] =0A=
af9015_usb_probe: interface:0<BR>[&nbsp; 311.633455] af9015_read_config: =
IR =0A=
mode:1<BR>[&nbsp; 311.635200] af9015_read_config: TS mode:1<BR>[&nbsp; =0A=
311.637198] af9015_read_config: [0] xtal:2 set =
adc_clock:28000<BR>[&nbsp; =0A=
311.641192] af9015_read_config: [0] IF1:4570<BR>[&nbsp; 311.645187] =0A=
af9015_read_config: [0] MT2060 IF1:0<BR>[&nbsp; 311.647185] =
af9015_read_config: =0A=
[0] tuner id:13<BR>[&nbsp; 311.648932] af9015_identify_state: =0A=
reply:02<BR>[&nbsp; 311.648935] dvb-usb: found a 'KWorld PlusTV Dual =
DVB-T Stick =0A=
(DVB-T 399U)' in warm state.<BR>[&nbsp; 311.648974] dvb-usb: will pass =
the =0A=
complete MPEG2 transport stream to the software demuxer.<BR>[&nbsp; =
311.650063] =0A=
DVB: registering new adapter (KWorld PlusTV Dual DVB-T Stick (DVB-T =0A=
399U))<BR>[&nbsp; 311.650223] af9015_af9013_frontend_attach: init =
I2C<BR>[&nbsp; =0A=
311.650225] af9015_i2c_init:<BR>[&nbsp; 311.689134] 00: 2b 3f 9b 0b 00 =
00 00 00 =0A=
80 1b 99 e3 00 02 01 02<BR>[&nbsp; 311.723089] 10: 00 80 00 fa fa 10 40 =
ef 01 30 =0A=
31 30 31 30 39 30<BR>[&nbsp; 311.755052] 20: 38 30 36 30 30 30 30 31 ff =
ff ff ff =0A=
ff ff ff ff<BR>[&nbsp; 311.787010] 30: 00 01 3a 01 00 08 02 00 da 11 00 =
00 0d ff =0A=
ff ff<BR>[&nbsp; 311.818971] 40: ff ff ff ff ff 08 02 00 da 11 00 00 0d =
ff ff =0A=
ff<BR>[&nbsp; 311.850929] 50: ff ff ff ff ff 24 00 00 04 03 09 04 10 03 =
41 =0A=
00<BR>[&nbsp; 311.882889] 60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 =
44 =0A=
00<BR>[&nbsp; 311.914847] 70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 =
30 =0A=
00<BR>[&nbsp; 311.946808] 80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 =
30 =0A=
00<BR>[&nbsp; 311.978768] 90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff =
ff =0A=
ff<BR>[&nbsp; 312.010726] a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 312.041683] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 312.073647] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 312.105607] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 312.137565] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 312.169526] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 312.202230] af9013: firmware version:4.95.0<BR>[&nbsp; =
312.226205] =0A=
DVB: registering frontend 0 (Afatech AF9013 DVB-T)...<BR>[&nbsp; =
312.226237] =0A=
af9015_tuner_attach:<BR>[&nbsp; 312.253161] MXL5005S: Attached at =
address =0A=
0xc6<BR>[&nbsp; 312.253230] input: IR-receiver inside an USB DVB =
receiver as =0A=
/devices/pci0000:00/0000:00:02.1/usb3/3-5/input/input13<BR>[&nbsp; =
312.294242] =0A=
dvb-usb: schedule remote query interval to 150 msecs.<BR>[&nbsp; =
312.294247] =0A=
dvb-usb: KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) successfully =
initialized =0A=
and connected.<BR>[&nbsp; 312.294250] af9015_init:<BR>[&nbsp; =
312.294252] =0A=
af9015_init_endpoint: USB speed:3<BR>[&nbsp; 312.338061] =0A=
af9015_download_ir_table:<BR>[&nbsp; 312.953297] usbcore: registered new =0A=
interface driver dvb_usb_af9015<BR><BR>root@myth:/home/awilliams# ls -l =0A=
/dev/dvb/*<BR>total 0<BR>crw-rw----+ 1 root video 212, 4 2008-09-21 =
21:13 =0A=
demux0<BR>crw-rw----+ 1 root video 212, 5 2008-09-21 21:13 =
dvr0<BR>crw-rw----+ 1 =0A=
root video 212, 3 2008-09-21 21:13 frontend0<BR>crw-rw----+ 1 root video =
212, 7 =0A=
2008-09-21 21:13 net0<BR><BR>Cold Boot:<BR>[&nbsp; 428.767893] usb 3-5: =
new high =0A=
speed USB device using ehci_hcd and address 7<BR>[&nbsp; 428.903593] usb =
3-5: =0A=
configuration #1 chosen from 1 choice<BR>[&nbsp; 428.903908] =
af9015_usb_probe: =0A=
interface:0<BR>[&nbsp; 428.906130] af9015_read_config: IR =
mode:1<BR>[&nbsp; =0A=
428.908167] af9015_read_config: TS mode:1<BR>[&nbsp; 428.910192] =0A=
af9015_read_config: [0] xtal:2 set adc_clock:28000<BR>[&nbsp; =
428.914122] =0A=
af9015_read_config: [0] IF1:4570<BR>[&nbsp; 428.918119] =
af9015_read_config: [0] =0A=
MT2060 IF1:0<BR>[&nbsp; 428.920113] af9015_read_config: [0] tuner =0A=
id:13<BR>[&nbsp; 428.921859] af9015_identify_state: reply:01<BR>[&nbsp; =0A=
428.921863] dvb-usb: found a 'KWorld PlusTV Dual DVB-T Stick (DVB-T =
399U)' in =0A=
cold state, will try to load a firmware<BR>[&nbsp; 428.923766] dvb-usb: =0A=
downloading firmware from file 'dvb-usb-af9015.fw'<BR>[&nbsp; =
428.923771] =0A=
af9015_download_firmware:<BR>[&nbsp; 429.001777] af9015_usb_probe: =0A=
interface:1<BR>[&nbsp; 429.001842] usb 3-5: USB disconnect, address =
7<BR>[&nbsp; =0A=
429.008901] af9015_usb_device_exit:<BR>[&nbsp; 429.008906] dvb-usb: =
generic =0A=
DVB-USB module successfully deinitialized and disconnected.<BR>[&nbsp; =0A=
429.008951] af9015_usb_device_exit:<BR>[&nbsp; 429.008954] dvb-usb: =
generic =0A=
DVB-USB module successfully deinitialized and disconnected.<BR>[&nbsp; =0A=
429.247020] usb 3-5: new high speed USB device using ehci_hcd and =
address =0A=
8<BR>[&nbsp; 429.383486] usb 3-5: configuration #1 chosen from 1 =0A=
choice<BR>[&nbsp; 429.383797] af9015_usb_probe: interface:0<BR>[&nbsp; =0A=
429.385520] af9015_read_config: IR mode:1<BR>[&nbsp; 429.387518] =0A=
af9015_read_config: TS mode:1<BR>[&nbsp; 429.389525] af9015_read_config: =
[0] =0A=
xtal:2 set adc_clock:28000<BR>[&nbsp; 429.393514] af9015_read_config: =
[0] =0A=
IF1:4570<BR>[&nbsp; 429.397507] af9015_read_config: [0] MT2060 =
IF1:0<BR>[&nbsp; =0A=
429.399504] af9015_read_config: [0] tuner id:13<BR>[&nbsp; 429.401251] =0A=
af9015_identify_state: reply:02<BR>[&nbsp; 429.401255] dvb-usb: found a =
'KWorld =0A=
PlusTV Dual DVB-T Stick (DVB-T 399U)' in warm state.<BR>[&nbsp; =
429.401293] =0A=
dvb-usb: will pass the complete MPEG2 transport stream to the software =0A=
demuxer.<BR>[&nbsp; 429.402380] DVB: registering new adapter (KWorld =
PlusTV Dual =0A=
DVB-T Stick (DVB-T 399U))<BR>[&nbsp; 429.402532] =
af9015_af9013_frontend_attach: =0A=
init I2C<BR>[&nbsp; 429.402535] af9015_i2c_init:<BR>[&nbsp; 429.439456] =
00: 2b =0A=
3f 9b 0b 00 00 00 00 80 1b 99 e3 00 02 01 02<BR>[&nbsp; 429.472691] 10: =
00 80 00 =0A=
fa fa 10 40 ef 01 30 31 30 31 30 39 30<BR>[&nbsp; 429.504373] 20: 38 30 =
36 30 30 =0A=
30 30 31 ff ff ff ff ff ff ff ff<BR>[&nbsp; 429.536332] 30: 00 01 3a 01 =
00 08 02 =0A=
00 da 11 00 00 0d ff ff ff<BR>[&nbsp; 429.568291] 40: ff ff ff ff ff 08 =
02 00 da =0A=
11 00 00 0d ff ff ff<BR>[&nbsp; 429.600251] 50: ff ff ff ff ff 24 00 00 =
04 03 09 =0A=
04 10 03 41 00<BR>[&nbsp; 429.632210] 60: 66 00 61 00 74 00 65 00 63 00 =
68 00 10 =0A=
03 44 00<BR>[&nbsp; 429.664170] 70: 56 00 42 00 2d 00 54 00 20 00 32 00 =
20 03 30 =0A=
00<BR>[&nbsp; 429.696129] 80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 =
30 =0A=
00<BR>[&nbsp; 429.728089] 90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff =
ff =0A=
ff<BR>[&nbsp; 429.760048] a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 429.792007] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 429.822968] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 429.854928] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 429.886888] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 429.918846] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 429.930581] af9013: firmware version:4.95.0<BR>[&nbsp; =
429.954554] =0A=
DVB: registering frontend 0 (Afatech AF9013 DVB-T)...<BR>[&nbsp; =
429.954588] =0A=
af9015_tuner_attach:<BR>[&nbsp; 429.954635] MXL5005S: Attached at =
address =0A=
0xc6<BR>[&nbsp; 429.954691] input: IR-receiver inside an USB DVB =
receiver as =0A=
/devices/pci0000:00/0000:00:02.1/usb3/3-5/input/input14<BR>[&nbsp; =
429.995007] =0A=
dvb-usb: schedule remote query interval to 150 msecs.<BR>[&nbsp; =
429.995015] =0A=
dvb-usb: KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) successfully =
initialized =0A=
and connected.<BR>[&nbsp; 429.995018] af9015_init:<BR>[&nbsp; =
429.995020] =0A=
af9015_init_endpoint: USB speed:3<BR>[&nbsp; 430.039222] =0A=
af9015_download_ir_table:<BR>[&nbsp; 430.656474] input: Afatech DVB-T 2 =
as =0A=
/devices/pci0000:00/0000:00:02.1/usb3/3-5/3-5:1.1/input/input15<BR>[&nbsp=
; =0A=
430.689731] input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] on =0A=
usb-0000:00:02.1-5<BR><BR>root@myth:~/af9015# ls -l /dev/dvb/*<BR>total =0A=
0<BR>crw-rw----+ 1 root video 212, 4 2008-09-21 22:30 =
demux0<BR>crw-rw----+ 1 =0A=
root video 212, 5 2008-09-21 22:30 dvr0<BR>crw-rw----+ 1 root video 212, =
3 =0A=
2008-09-21 22:30 frontend0<BR>crw-rw----+ 1 root video 212, 7 2008-09-21 =
22:30 =0A=
net0<BR>root@myth:~/af9015#<BR><BR><BR><BR>Older driver info and results =0A=
below:<BR>Driver 13 Sept 2008 <A =0A=
href=3D"http://linuxtv.org/hg/~anttip/af9015/">http://linuxtv.org/hg/~ant=
tip/af9015/</A><BR>af9015-c560fdca9848:<BR><BR>Cold =0A=
Boot:<BR><BR>Dmesg:<BR>[&nbsp; 983.072405] usb 1-5: USB disconnect, =
address =0A=
3<BR>[&nbsp; 983.072693] af9015_usb_device_exit:<BR>[&nbsp; 983.072696] =0A=
af9015_i2c_exit:<BR>[&nbsp; 983.073070] dvb-usb: KWorld PlusTV Dual =
DVB-T Stick =0A=
(DVB-T 399U) successfully deinitialized and disconnected.<BR>[&nbsp; =
987.538084] =0A=
usb 1-5: new high speed USB device using ehci_hcd and address =
5<BR>[&nbsp; =0A=
987.674237] usb 1-5: configuration #1 chosen from 1 choice<BR>[&nbsp; =0A=
987.674547] af9015_usb_probe: interface:0<BR>[&nbsp; 987.676770] =0A=
af9015_read_config: IR mode:1<BR>[&nbsp; 987.678768] af9015_read_config: =
TS =0A=
mode:1<BR>[&nbsp; 987.682764] af9015_read_config: [0] xtal:2 set =0A=
adc_clock:28000<BR>[&nbsp; 987.686760] af9015_read_config: [0] =0A=
IF1:4570<BR>[&nbsp; 987.690754] af9015_read_config: [0] MT2060 =
IF1:0<BR>[&nbsp; =0A=
987.692750] af9015_read_config: [0] tuner id:13<BR>[&nbsp; 987.694749] =0A=
af9015_read_config: [1] xtal:2 set adc_clock:28000<BR>[&nbsp; =
987.698744] =0A=
af9015_read_config: [1] IF1:4570<BR>[&nbsp; 987.702738] =
af9015_read_config: [1] =0A=
MT2060 IF1:0<BR>[&nbsp; 987.704736] af9015_read_config: [1] tuner =0A=
id:13<BR>[&nbsp; 987.706484] af9015_identify_state: reply:01<BR>[&nbsp; =0A=
987.706488] dvb-usb: found a 'KWorld PlusTV Dual DVB-T Stick (DVB-T =
399U)' in =0A=
cold state, will try to load a firmware<BR>[&nbsp; 987.766336] dvb-usb: =0A=
downloading firmware from file 'dvb-usb-af9015.fw'<BR>[&nbsp; =
987.766342] =0A=
af9015_download_firmware:<BR>[&nbsp; 987.844323] af9015_usb_probe: =0A=
interface:1<BR>[&nbsp; 987.844385] usb 1-5: USB disconnect, address =
5<BR>[&nbsp; =0A=
987.851116] af9015_usb_device_exit:<BR>[&nbsp; 987.851120] dvb-usb: =
generic =0A=
DVB-USB module successfully deinitialized and disconnected.<BR>[&nbsp; =0A=
987.851161] af9015_usb_device_exit:<BR>[&nbsp; 987.851164] dvb-usb: =
generic =0A=
DVB-USB module successfully deinitialized and disconnected.<BR>[&nbsp; =0A=
988.089352] usb 1-5: new high speed USB device using ehci_hcd and =
address =0A=
6<BR>[&nbsp; 988.226034] usb 1-5: configuration #1 chosen from 1 =0A=
choice<BR>[&nbsp; 988.226346] af9015_usb_probe: interface:0<BR>[&nbsp; =0A=
988.228069] af9015_read_config: IR mode:1<BR>[&nbsp; 988.230082] =0A=
af9015_read_config: TS mode:1<BR>[&nbsp; 988.234067] af9015_read_config: =
[0] =0A=
xtal:2 set adc_clock:28000<BR>[&nbsp; 988.238057] af9015_read_config: =
[0] =0A=
IF1:4570<BR>[&nbsp; 988.242053] af9015_read_config: [0] MT2060 =
IF1:0<BR>[&nbsp; =0A=
988.244051] af9015_read_config: [0] tuner id:13<BR>[&nbsp; 988.246048] =0A=
af9015_read_config: [1] xtal:2 set adc_clock:28000<BR>[&nbsp; =
988.250043] =0A=
af9015_read_config: [1] IF1:4570<BR>[&nbsp; 988.254038] =
af9015_read_config: [1] =0A=
MT2060 IF1:0<BR>[&nbsp; 988.256035] af9015_read_config: [1] tuner =0A=
id:13<BR>[&nbsp; 988.257783] af9015_identify_state: reply:02<BR>[&nbsp; =0A=
988.257787] dvb-usb: found a 'KWorld PlusTV Dual DVB-T Stick (DVB-T =
399U)' in =0A=
warm state.<BR>[&nbsp; 988.257824] dvb-usb: will pass the complete MPEG2 =0A=
transport stream to the software demuxer.<BR>[&nbsp; 988.258912] DVB: =0A=
registering new adapter (KWorld PlusTV Dual DVB-T Stick (DVB-T =
399U))<BR>[&nbsp; =0A=
988.259062] af9015_af9013_frontend_attach: init I2C<BR>[&nbsp; =
988.259065] =0A=
af9015_i2c_init:<BR>[&nbsp; 988.294986] 00: 2b 3f 9b 0b 00 00 00 00 80 =
1b 99 e3 =0A=
00 02 01 02<BR>[&nbsp; 988.326944] 10: 00 80 00 fa fa 10 40 ef 01 30 31 =
30 31 30 =0A=
39 30<BR>[&nbsp; 988.358908] 20: 38 30 36 30 30 30 30 31 ff ff ff ff ff =
ff ff =0A=
ff<BR>[&nbsp; 988.390868] 30: 00 01 3a 01 00 08 02 00 da 11 00 00 0d ff =
ff =0A=
ff<BR>[&nbsp; 988.422826] 40: ff ff ff ff ff 08 02 00 da 11 00 00 0d ff =
ff =0A=
ff<BR>[&nbsp; 988.454786] 50: ff ff ff ff ff 24 00 00 04 03 09 04 10 03 =
41 =0A=
00<BR>[&nbsp; 988.486745] 60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 =
44 =0A=
00<BR>[&nbsp; 988.518705] 70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 =
30 =0A=
00<BR>[&nbsp; 988.550663] 80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 =
30 =0A=
00<BR>[&nbsp; 988.582625] 90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff =
ff =0A=
ff<BR>[&nbsp; 988.614582] a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 988.646543] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 988.678500] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 988.710461] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 988.742421] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 988.774379] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff =0A=
ff<BR>[&nbsp; 988.786115] af9013: firmware version:4.95.0<BR>[&nbsp; =
988.810086] =0A=
DVB: registering frontend 0 (Afatech AF9013 DVB-T)...<BR>[&nbsp; =
988.810122] =0A=
af9015_tuner_attach:<BR>[&nbsp; 988.810165] MXL5005S: Attached at =
address =0A=
0xc6<BR>[&nbsp; 988.810168] dvb-usb: will pass the complete MPEG2 =
transport =0A=
stream to the software demuxer.<BR>[&nbsp; 988.811208] DVB: registering =
new =0A=
adapter (KWorld PlusTV Dual DVB-T Stick (DVB-T 399U))<BR>[&nbsp; =
988.811348] =0A=
af9015_copy_firmware:<BR>[&nbsp; 989.315443] af9015_copy_firmware: =
firmware copy =0A=
done<BR>[&nbsp; 989.421308] af9015_copy_firmware: firmware boot cmd =0A=
status:0<BR>[&nbsp; 989.526174] af9015_copy_firmware: firmware status =
cmd =0A=
status:0 fw status:0c<BR>[&nbsp; 989.637030] af9013: found a 'Afatech =
AF9013 =0A=
DVB-T' in warm state.<BR>[&nbsp; 989.643027] af9013: firmware =0A=
version:4.95.0<BR>[&nbsp; 989.670993] DVB: registering frontend 1 =
(Afatech =0A=
AF9013 DVB-T)...<BR>[&nbsp; 989.671027] af9015_tuner_attach:<BR>[&nbsp; =0A=
989.671097] MXL5005S: Attached at address 0xc6<BR>[&nbsp; 989.671101] =
dvb-usb: =0A=
KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) successfully initialized and =0A=
connected.<BR>[&nbsp; 989.671105] af9015_init:<BR>[&nbsp; 989.671106] =0A=
af9015_init_endpoint: USB speed:3<BR>[&nbsp; 989.726920] =0A=
af9015_download_ir_table:<BR>[&nbsp; 990.345588] input: Afatech DVB-T 2 =
as =0A=
/devices/pci0000:00/0000:00:02.1/usb1/1-5/1-5:1.1/input/input10<BR>[&nbsp=
; =0A=
990.383674] input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] on =0A=
usb-0000:00:02.1-5<BR>root@myth:~#<BR><BR>root@myth:~# ls -l =0A=
/dev/dvb/*<BR>/dev/dvb/adapter0:<BR>total 0<BR>crw-rw----+ 1 root video =
212, 4 =0A=
2008-09-21 21:34 demux0<BR>crw-rw----+ 1 root video 212, 5 2008-09-21 =
21:34 =0A=
dvr0<BR>crw-rw----+ 1 root video 212, 3 2008-09-21 21:34 =0A=
frontend0<BR>crw-rw----+ 1 root video 212, 7 2008-09-21 21:34 =0A=
net0<BR><BR>/dev/dvb/adapter1:<BR>total 0<BR>crw-rw----+ 1 root video =
212, 68 =0A=
2008-09-21 21:34 demux0<BR>crw-rw----+ 1 root video 212, 69 2008-09-21 =
21:34 =0A=
dvr0<BR>crw-rw----+ 1 root video 212, 67 2008-09-21 21:34 =0A=
frontend0<BR>crw-rw----+ 1 root video 212, 71 2008-09-21 21:34 =0A=
net0<BR>root@myth:~#<BR><BR><BR>Warm =0A=
Boot:<BR><BR><BR>Dmesg:<BR><BR>[&nbsp;&nbsp; 38.911448] =
af9015_usb_probe: =0A=
interface:0<BR>[&nbsp;&nbsp; 38.913790] af9015_read_config: IR =0A=
mode:1<BR>[&nbsp;&nbsp; 38.915786] af9015_read_config: TS =0A=
mode:1<BR>[&nbsp;&nbsp; 38.919782] af9015_read_config: [0] xtal:2 set =0A=
adc_clock:28000<BR>[&nbsp;&nbsp; 38.923777] af9015_read_config: [0] =0A=
IF1:4570<BR>[&nbsp;&nbsp; 38.927771] af9015_read_config: [0] MT2060 =0A=
IF1:0<BR>[&nbsp;&nbsp; 38.929768] af9015_read_config: [0] tuner =0A=
id:13<BR>[&nbsp;&nbsp; 38.931766] af9015_read_config: [1] xtal:2 set =0A=
adc_clock:28000<BR>[&nbsp;&nbsp; 38.935760] af9015_read_config: [1] =0A=
IF1:4570<BR>[&nbsp;&nbsp; 38.939756] af9015_read_config: [1] MT2060 =0A=
IF1:0<BR>[&nbsp;&nbsp; 38.941754] af9015_read_config: [1] tuner =0A=
id:13<BR>[&nbsp;&nbsp; 38.943517] af9015_identify_state: =0A=
reply:02<BR>[&nbsp;&nbsp; 38.943519] dvb-usb: found a 'KWorld PlusTV =
Dual DVB-T =0A=
Stick (DVB-T 399U)' in warm state.<BR>[&nbsp;&nbsp; 38.943564] dvb-usb: =
will =0A=
pass the complete MPEG2 transport stream to the software =0A=
demuxer.<BR>[&nbsp;&nbsp; 38.944631] DVB: registering new adapter =
(KWorld PlusTV =0A=
Dual DVB-T Stick (DVB-T 399U))<BR>[&nbsp;&nbsp; 38.944783] =0A=
af9015_af9013_frontend_attach: init I2C<BR>[&nbsp;&nbsp; 38.944785] =0A=
af9015_i2c_init:<BR>[&nbsp;&nbsp; 38.984699] 00: 2b 3f 9b 0b 00 00 00 00 =
80 1b =0A=
99 e3 00 02 01 02<BR>[&nbsp;&nbsp; 39.016664] 10: 00 80 00 fa fa 10 40 =
ef 01 30 =0A=
31 30 31 30 39 30<BR>[&nbsp;&nbsp; 39.048617] 20: 38 30 36 30 30 30 30 =
31 ff ff =0A=
ff ff ff ff ff ff<BR>[&nbsp;&nbsp; 39.080575] 30: 00 01 3a 01 00 08 02 =
00 da 11 =0A=
00 00 0d ff ff ff<BR>[&nbsp;&nbsp; 39.112537] 40: ff ff ff ff ff 08 02 =
00 da 11 =0A=
00 00 0d ff ff ff<BR>[&nbsp;&nbsp; 39.144505] 50: ff ff ff ff ff 24 00 =
00 04 03 =0A=
09 04 10 03 41 00<BR>[&nbsp;&nbsp; 39.176462] 60: 66 00 61 00 74 00 65 =
00 63 00 =0A=
68 00 10 03 44 00<BR>[&nbsp;&nbsp; 39.210415] 70: 56 00 42 00 2d 00 54 =
00 20 00 =0A=
32 00 20 03 30 00<BR>[&nbsp;&nbsp; 39.242369] 80: 31 00 30 00 31 00 30 =
00 31 00 =0A=
30 00 31 00 30 00<BR>[&nbsp;&nbsp; 39.274329] 90: 36 00 30 00 30 00 30 =
00 30 00 =0A=
31 00 00 ff ff ff<BR>[&nbsp;&nbsp; 39.306290] a0: ff ff ff ff ff ff ff =
ff ff ff =0A=
ff ff ff ff ff ff<BR>[&nbsp;&nbsp; 39.338255] b0: ff ff ff ff ff ff ff =
ff ff ff =0A=
ff ff ff ff ff ff<BR>[&nbsp;&nbsp; 39.370207] c0: ff ff ff ff ff ff ff =
ff ff ff =0A=
ff ff ff ff ff ff<BR>[&nbsp;&nbsp; 39.402168] d0: ff ff ff ff ff ff ff =
ff ff ff =0A=
ff ff ff ff ff ff<BR>[&nbsp;&nbsp; 39.434137] e0: ff ff ff ff ff ff ff =
ff ff ff =0A=
ff ff ff ff ff ff<BR>[&nbsp;&nbsp; 39.466086] f0: ff ff ff ff ff ff ff =
ff ff ff =0A=
ff ff ff ff ff ff<BR>[&nbsp;&nbsp; 39.532752] af9013: firmware =0A=
version:4.95.0<BR>[&nbsp;&nbsp; 39.556724] DVB: registering frontend 0 =
(Afatech =0A=
AF9013 DVB-T)...<BR>[&nbsp;&nbsp; 39.556755] =0A=
af9015_tuner_attach:<BR>[&nbsp;&nbsp; 39.614630] MXL5005S: Attached at =
address =0A=
0xc6<BR>[&nbsp;&nbsp; 39.614635] dvb-usb: will pass the complete MPEG2 =
transport =0A=
stream to the software demuxer.<BR>[&nbsp;&nbsp; 39.615783] DVB: =
registering new =0A=
adapter (KWorld PlusTV Dual DVB-T Stick (DVB-T 399U))<BR>[&nbsp;&nbsp; =0A=
39.615936] af9015_copy_firmware:<BR>[&nbsp;&nbsp; 39.779439] =0A=
af9015_copy_firmware: firmware copy done<BR>[&nbsp;&nbsp; 39.882310] =0A=
af9015_copy_firmware: firmware boot cmd status:0<BR>[&nbsp;&nbsp; =
39.986177] =0A=
af9015_copy_firmware: firmware status cmd status:0 fw =
status:00<BR>[&nbsp;&nbsp; =0A=
39.988175] af9015_copy_firmware: firmware boot cmd =
status:0<BR>[&nbsp;&nbsp; =0A=
40.090046] af9015_copy_firmware: firmware status cmd status:0 fw =0A=
status:00<BR>[&nbsp;&nbsp; 40.092043] af9015_copy_firmware: firmware =
boot cmd =0A=
status:0<BR>[&nbsp;&nbsp; 40.193914] af9015_copy_firmware: firmware =
status cmd =0A=
status:0 fw status:00<BR>[&nbsp;&nbsp; 40.195910] af9015_copy_firmware: =
firmware =0A=
boot cmd status:0<BR>[&nbsp;&nbsp; 40.297782] af9015_copy_firmware: =
firmware =0A=
status cmd status:0 fw status:00<BR>[&nbsp;&nbsp; 40.299779] =0A=
af9015_copy_firmware: firmware boot cmd status:0<BR>[&nbsp;&nbsp; =
40.401650] =0A=
af9015_copy_firmware: firmware status cmd status:0 fw =
status:00<BR>[&nbsp;&nbsp; =0A=
40.403647] af9015_copy_firmware: firmware boot cmd =
status:0<BR>[&nbsp;&nbsp; =0A=
40.505518] af9015_copy_firmware: firmware status cmd status:0 fw =0A=
status:00<BR>[&nbsp;&nbsp; 40.507515] af9015_copy_firmware: firmware =
boot cmd =0A=
status:0<BR>[&nbsp;&nbsp; 40.609384] af9015_copy_firmware: firmware =
status cmd =0A=
status:0 fw status:00<BR>[&nbsp;&nbsp; 40.611383] af9015_copy_firmware: =
firmware =0A=
boot cmd status:0<BR>[&nbsp;&nbsp; 40.713251] af9015_copy_firmware: =
firmware =0A=
status cmd status:0 fw status:00<BR>[&nbsp;&nbsp; 40.715247] =0A=
af9015_copy_firmware: firmware boot cmd status:0<BR>[&nbsp;&nbsp; =
40.818117] =0A=
af9015_copy_firmware: firmware status cmd status:0 fw =
status:00<BR>[&nbsp;&nbsp; =0A=
40.820114] af9015_copy_firmware: firmware boot cmd =
status:0<BR>[&nbsp;&nbsp; =0A=
40.921985] af9015_copy_firmware: firmware status cmd status:0 fw =0A=
status:00<BR>[&nbsp;&nbsp; 40.921987] af9015: firmware did not =0A=
run<BR>[&nbsp;&nbsp; 40.921989] af9015: firmware copy to 2nd frontend =
failed, =0A=
will disable it<BR>[&nbsp;&nbsp; 40.921992] dvb-usb: no frontend was =
attached by =0A=
'KWorld PlusTV Dual DVB-T Stick (DVB-T 399U)'<BR>[&nbsp;&nbsp; =
40.921995] =0A=
dvb-usb: KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) successfully =
initialized =0A=
and connected.<BR>[&nbsp;&nbsp; 40.921997] af9015_init:<BR>[&nbsp;&nbsp; =0A=
40.921999] af9015_init_endpoint: USB speed:3<BR>[&nbsp;&nbsp; 40.965932] =0A=
af9015_download_ir_table:<BR>[&nbsp;&nbsp; 41.581174] usbcore: =
registered new =0A=
interface driver dvb_usb_af9015<BR><BR><BR>root@myth:~# ls -l =0A=
/dev/dvb/*<BR>/dev/dvb/adapter0:<BR>total 0<BR>crw-rw----+ 1 root video =
212, 4 =0A=
2008-09-21 21:18 demux0<BR>crw-rw----+ 1 root video 212, 5 2008-09-21 =
21:18 =0A=
dvr0<BR>crw-rw----+ 1 root video 212, 3 2008-09-21 21:18 =0A=
frontend0<BR>crw-rw----+ 1 root video 212, 7 2008-09-21 21:18 =0A=
net0<BR><BR>/dev/dvb/adapter1:<BR>total 0<BR>crw-rw----+ 1 root video =
212, 68 =0A=
2008-09-21 21:18 demux0<BR>crw-rw----+ 1 root video 212, 69 2008-09-21 =
21:18 =0A=
dvr0<BR>crw-rw----+ 1 root video 212, 71 2008-09-21 21:18 =0A=
net0<BR>root@myth:~#<BR><BR><BR></DIV></FONT></DIV>=0A=
=0A=
</BODY>=0A=
</HTML>
------_=_NextPart_001_01C91C33.8646DBD7--


--===============1165260582==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1165260582==--
