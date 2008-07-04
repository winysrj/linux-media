Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gomeisa.profiz.com ([62.142.120.210])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <peter.parkkali@iki.fi>) id 1KEisn-0003jn-In
	for linux-dvb@linuxtv.org; Fri, 04 Jul 2008 12:51:19 +0200
From: Peter Parkkali <peter.parkkali@iki.fi>
To: Antti Palosaari <crope@iki.fi>
In-Reply-To: <486CC15B.5050902@iki.fi>
References: <1997F341-DFDB-47A9-9158-65BA7D26133D@iki.fi>
	<486CC15B.5050902@iki.fi>
Message-Id: <76F87D66-2788-4A13-BE2E-E745AAB8B86C@iki.fi>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Fri, 4 Jul 2008 13:50:18 +0300
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] af9015 driver fails on ubuntu 8.04 / alink dtu-m
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Moi,

On 3.7.2008, at 15:08, Antti Palosaari wrote:
>> Since upgrading to Ubuntu 8.04 (Linux 2.6.24-19), I haven't been  
>> able  to get Antti's af9015 driver to work with the a-link's  
>> "DTU(m)" dongle  (USB 15a4:9016). I'm using the latest version from http://linuxtv.org/hg/ 
>>  ~anttip/af9015/ . An older version of the driver did work earlier  
>> this  year on Ubuntu 7.10 with the same stick, however.
>
> From the logs I see that you have USB1.1. Could you comment out  
> USB1.1 stuff from af9015_read_config -function and test if it  
> resolves issue you have. Function is inside of the af9015.c -file.


I tried it, and it produces exactly the same kind of errors as before.  
However, this time VLC doesn't crash - it just keeps on sending the  
garbled stream out. (Could be a coincidence - the receiving vlc did  
eventually crash.)

I tried connecting it via a USB 2 adapter, and there it works 99% of  
the time :) although there are still some glitches in the picture and  
sound. Both vlc and kernel still print the same messages when running,  
but there are fewer,  about 10-20 lines after running for ~10 min.

- peter

Connecting to USB 1.1 w/ the USB 1.1 stuff commented out:

Jul  4 13:15:09 ubuntu kernel: [35722.352458] usb 1-1: new full speed  
USB device using uhci_hcd and address 2
Jul  4 13:15:10 ubuntu kernel: [35722.542775] usb 1-1: configuration  
#1 chosen from 1 choice
Jul  4 13:15:10 ubuntu kernel: [35723.167091] af9015_usb_probe:  
interface:0
Jul  4 13:15:10 ubuntu kernel: [35723.170247] af9015_read_config: IR  
mode:1
Jul  4 13:15:10 ubuntu kernel: [35723.172182] af9015_read_config: TS  
mode:0
Jul  4 13:15:10 ubuntu kernel: [35723.175981] af9015_read_config: [0]  
xtal:2 set adc_clock:28000
Jul  4 13:15:10 ubuntu kernel: [35723.180192] af9015_read_config: [0]  
IF1:36125
Jul  4 13:15:10 ubuntu kernel: [35723.184361] af9015_read_config: [0]  
MT2060 IF1:1220
Jul  4 13:15:10 ubuntu kernel: [35723.186163] af9015_read_config: [0]  
tuner id:130
Jul  4 13:15:10 ubuntu kernel: [35723.188141] af9015_identify_state:  
reply:01
Jul  4 13:15:10 ubuntu kernel: [35723.188173] dvb-usb: found a  
'Afatech AF9015 DVB-T USB2.0 stick' in cold state, will try to load a  
firmware
Jul  4 13:15:10 ubuntu kernel: [35723.226420] dvb-usb: downloading  
firmware from file 'dvb-usb-af9015.fw'
Jul  4 13:15:10 ubuntu kernel: [35723.226447] af9015_download_firmware:
Jul  4 13:15:11 ubuntu kernel: [35723.519076] af9015_usb_probe:  
interface:1
Jul  4 13:15:11 ubuntu kernel: [35723.519165] usbcore: registered new  
interface driver dvb_usb_af9015
Jul  4 13:15:11 ubuntu kernel: [35723.639959] usbcore: registered new  
interface driver hiddev
Jul  4 13:15:11 ubuntu kernel: [35723.640051] usbcore: registered new  
interface driver usbhid
Jul  4 13:15:11 ubuntu kernel: [35723.640066] /build/buildd/ 
linux-2.6.24/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Jul  4 13:15:11 ubuntu kernel: [35723.702259] usb 1-1: USB disconnect,  
address 2
Jul  4 13:15:11 ubuntu kernel: [35723.702902] af9015_usb_device_exit:
Jul  4 13:15:11 ubuntu kernel: [35723.702916] dvb-usb: generic DVB-USB  
module successfully deinitialized and disconnected.
Jul  4 13:15:11 ubuntu kernel: [35723.703198] af9015_usb_device_exit:
Jul  4 13:15:11 ubuntu kernel: [35723.703208] dvb-usb: generic DVB-USB  
module successfully deinitialized and disconnected.
Jul  4 13:15:11 ubuntu kernel: [35723.982107] usb 1-1: new full speed  
USB device using uhci_hcd and address 3
Jul  4 13:15:11 ubuntu kernel: [35724.133702] usb 1-1: not running at  
top speed; connect to a high speed hub
Jul  4 13:15:11 ubuntu kernel: [35724.169156] usb 1-1: configuration  
#1 chosen from 1 choice
Jul  4 13:15:11 ubuntu kernel: [35724.172017] af9015_usb_probe:  
interface:0
Jul  4 13:15:11 ubuntu kernel: [35724.174791] af9015_read_config: IR  
mode:1
Jul  4 13:15:11 ubuntu kernel: [35724.176770] af9015_read_config: TS  
mode:0
Jul  4 13:15:11 ubuntu kernel: [35724.178788] af9015_read_config: [0]  
xtal:2 set adc_clock:28000
Jul  4 13:15:11 ubuntu kernel: [35724.182803] af9015_read_config: [0]  
IF1:36125
Jul  4 13:15:11 ubuntu kernel: [35724.186797] af9015_read_config: [0]  
MT2060 IF1:1220
Jul  4 13:15:11 ubuntu kernel: [35724.188770] af9015_read_config: [0]  
tuner id:130
Jul  4 13:15:11 ubuntu kernel: [35724.190772] af9015_identify_state:  
reply:02
Jul  4 13:15:11 ubuntu kernel: [35724.190802] dvb-usb: found a  
'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
Jul  4 13:15:11 ubuntu kernel: [35724.191052] dvb-usb: will use the  
device's hardware PID filter (table count: 32).
Jul  4 13:15:11 ubuntu kernel: [35724.192365] DVB: registering new  
adapter (Afatech AF9015 DVB-T USB2.0 stick)
Jul  4 13:15:11 ubuntu kernel: [35724.192900]  
af9015_af9013_frontend_attach: init I2C
Jul  4 13:15:11 ubuntu kernel: [35724.192912] af9015_i2c_init:
Jul  4 13:15:11 ubuntu kernel: [35724.226748] 00: 2c 75 9b 0b 00 00 00  
00 a4 15 16 90 00 02 01 02
Jul  4 13:15:11 ubuntu kernel: [35724.258699] 10: 00 80 00 fa fa 10 40  
ef 01 30 31 30 31 31 30 30
Jul  4 13:15:11 ubuntu kernel: [35724.290735] 20: 34 30 36 30 30 30 30  
31 ff ff ff ff ff ff ff ff
Jul  4 13:15:11 ubuntu kernel: [35724.322651] 30: 00 00 3a 01 00 08 02  
00 1d 8d c4 04 82 ff ff ff
Jul  4 13:15:11 ubuntu kernel: [35724.354640] 40: ff ff ff ff ff 08 02  
00 1d 8d c4 04 82 ff ff ff
Jul  4 13:15:11 ubuntu kernel: [35724.386625] 50: ff ff ff ff ff 24 00  
00 04 03 09 04 10 03 41 00
Jul  4 13:15:11 ubuntu kernel: [35724.418612] 60: 66 00 61 00 74 00 65  
00 63 00 68 00 10 03 44 00
Jul  4 13:15:12 ubuntu kernel: [35724.450588] 70: 56 00 42 00 2d 00 54  
00 20 00 32 00 20 03 30 00
Jul  4 13:15:12 ubuntu kernel: [35724.482578] 80: 31 00 30 00 31 00 31  
00 30 00 30 00 34 00 30 00
Jul  4 13:15:12 ubuntu kernel: [35724.514577] 90: 36 00 30 00 30 00 30  
00 30 00 31 00 00 ff ff ff
Jul  4 13:15:12 ubuntu kernel: [35724.546687] a0: ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff ff ff
Jul  4 13:15:12 ubuntu kernel: [35724.580528] b0: ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff ff ff
Jul  4 13:15:12 ubuntu kernel: [35724.612516] c0: ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff ff ff
Jul  4 13:15:12 ubuntu kernel: [35724.645506] d0: ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff ff ff
Jul  4 13:15:12 ubuntu kernel: [35724.677494] e0: ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff ff ff
Jul  4 13:15:12 ubuntu kernel: [35724.709475] f0: ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff ff ff
Jul  4 13:15:12 ubuntu kernel: [35724.828435] af9013: firmware version: 
4.95.0
Jul  4 13:15:12 ubuntu kernel: [35724.852448] DVB: registering  
frontend 0 (Afatech AF9013 DVB-T)...
Jul  4 13:15:12 ubuntu kernel: [35724.852642] af9015_tuner_attach:
Jul  4 13:15:12 ubuntu kernel: [35724.978386] af9015_i2c_xfer: UNLOCK  
pid:1280 38 38
Jul  4 13:15:12 ubuntu kernel: [35724.980386] MT2060: successfully  
identified (IF1 = 1220)
Jul  4 13:15:13 ubuntu kernel: [35725.560153] af9015_i2c_xfer: UNLOCK  
pid:1280 38 38
Jul  4 13:15:13 ubuntu kernel: [35725.560542] input: IR-receiver  
inside an USB DVB receiver as /devices/pci0000:00/0000:00:1f.2/ 
usb1/1-1/input/input3
Jul  4 13:15:13 ubuntu kernel: [35725.621944] dvb-usb: schedule remote  
query interval to 150 msecs.
Jul  4 13:15:13 ubuntu kernel: [35725.621977] dvb-usb: Afatech AF9015  
DVB-T USB2.0 stick successfully initialized and connected.
Jul  4 13:15:13 ubuntu kernel: [35725.621991] af9015_init:
Jul  4 13:15:13 ubuntu kernel: [35725.621998] af9015_init_endpoint:  
USB speed:2
Jul  4 13:15:13 ubuntu kernel: [35725.669115] af9015_download_ir_table:
Jul  4 13:15:13 ubuntu kernel: [35725.931838] af9015_usb_probe:  
interface:1


Connectig w/ USB 2:


ul  4 13:26:18 ubuntu kernel: [36390.045300] usb 4-2: new high speed  
USB device using ehci_hcd and address 2
Jul  4 13:26:18 ubuntu kernel: [36390.199888] usb 4-2: configuration  
#1 chosen from 1 choice
Jul  4 13:26:19 ubuntu kernel: [36390.873480] af9015_usb_probe:  
interface:0
Jul  4 13:26:19 ubuntu kernel: [36390.874945] af9015_read_config: IR  
mode:1
Jul  4 13:26:19 ubuntu kernel: [36390.876514] af9015_read_config: TS  
mode:0
Jul  4 13:26:19 ubuntu kernel: [36390.877954] af9015_read_config: [0]  
xtal:2 set adc_clock:28000
Jul  4 13:26:19 ubuntu kernel: [36390.880992] af9015_read_config: [0]  
IF1:36125
Jul  4 13:26:19 ubuntu kernel: [36390.884112] af9015_read_config: [0]  
MT2060 IF1:1220
Jul  4 13:26:19 ubuntu kernel: [36390.885798] af9015_read_config: [0]  
tuner id:130
Jul  4 13:26:19 ubuntu kernel: [36390.887171] af9015_identify_state:  
reply:01
Jul  4 13:26:19 ubuntu kernel: [36390.887203] dvb-usb: found a  
'Afatech AF9015 DVB-T USB2.0 stick' in cold state, will try to load a  
firmware
Jul  4 13:26:19 ubuntu kernel: [36390.938154] dvb-usb: downloading  
firmware from file 'dvb-usb-af9015.fw'
Jul  4 13:26:19 ubuntu kernel: [36390.938189] af9015_download_firmware:
Jul  4 13:26:19 ubuntu kernel: [36391.008945] af9015_usb_probe:  
interface:1
Jul  4 13:26:19 ubuntu kernel: [36391.009057] usbcore: registered new  
interface driver dvb_usb_af9015
Jul  4 13:26:19 ubuntu kernel: [36391.015241] usb 4-2: USB disconnect,  
address 2
Jul  4 13:26:19 ubuntu kernel: [36391.015835] af9015_usb_device_exit:
Jul  4 13:26:19 ubuntu kernel: [36391.015851] dvb-usb: generic DVB-USB  
module successfully deinitialized and disconnected.
Jul  4 13:26:19 ubuntu kernel: [36391.016074] af9015_usb_device_exit:
Jul  4 13:26:19 ubuntu kernel: [36391.016083] dvb-usb: generic DVB-USB  
module successfully deinitialized and disconnected.
Jul  4 13:26:19 ubuntu kernel: [36391.295051] usb 4-2: new high speed  
USB device using ehci_hcd and address 3
Jul  4 13:26:20 ubuntu kernel: [36391.450227] usb 4-2: configuration  
#1 chosen from 1 choice
Jul  4 13:26:20 ubuntu kernel: [36391.451978] af9015_usb_probe:  
interface:0
Jul  4 13:26:20 ubuntu kernel: [36391.453638] af9015_read_config: IR  
mode:1
Jul  4 13:26:20 ubuntu kernel: [36391.455258] af9015_read_config: TS  
mode:0
Jul  4 13:26:20 ubuntu kernel: [36391.457018] af9015_read_config: [0]  
xtal:2 set adc_clock:28000
Jul  4 13:26:20 ubuntu kernel: [36391.460340] af9015_read_config: [0]  
IF1:36125
Jul  4 13:26:20 ubuntu kernel: [36391.463456] af9015_read_config: [0]  
MT2060 IF1:1220
Jul  4 13:26:20 ubuntu kernel: [36391.465051] af9015_read_config: [0]  
tuner id:130
Jul  4 13:26:20 ubuntu kernel: [36391.465859] af9015_identify_state:  
reply:02
Jul  4 13:26:20 ubuntu kernel: [36391.465883] dvb-usb: found a  
'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
Jul  4 13:26:20 ubuntu kernel: [36391.466170] dvb-usb: will pass the  
complete MPEG2 transport stream to the software demuxer.
Jul  4 13:26:20 ubuntu kernel: [36391.466870] DVB: registering new  
adapter (Afatech AF9015 DVB-T USB2.0 stick)
Jul  4 13:26:20 ubuntu kernel: [36391.468203]  
af9015_af9013_frontend_attach: init I2C
Jul  4 13:26:20 ubuntu kernel: [36391.468221] af9015_i2c_init:
Jul  4 13:26:20 ubuntu kernel: [36391.494551] 00: 2c 75 9b 0b 00 00 00  
00 a4 15 16 90 00 02 01 02
Jul  4 13:26:20 ubuntu kernel: [36391.517923] 10: 00 80 00 fa fa 10 40  
ef 01 30 31 30 31 31 30 30
Jul  4 13:26:20 ubuntu kernel: [36391.542668] 20: 34 30 36 30 30 30 30  
31 ff ff ff ff ff ff ff ff
Jul  4 13:26:20 ubuntu kernel: [36391.565800] 30: 00 00 3a 01 00 08 02  
00 1d 8d c4 04 82 ff ff ff
Jul  4 13:26:20 ubuntu kernel: [36391.589421] 40: ff ff ff ff ff 08 02  
00 1d 8d c4 04 82 ff ff ff
Jul  4 13:26:20 ubuntu kernel: [36391.613035] 50: ff ff ff ff ff 24 00  
00 04 03 09 04 10 03 41 00
Jul  4 13:26:20 ubuntu kernel: [36391.636532] 60: 66 00 61 00 74 00 65  
00 63 00 68 00 10 03 44 00
Jul  4 13:26:20 ubuntu kernel: [36391.659279] 70: 56 00 42 00 2d 00 54  
00 20 00 32 00 20 03 30 00
Jul  4 13:26:20 ubuntu kernel: [36391.681903] 80: 31 00 30 00 31 00 31  
00 30 00 30 00 34 00 30 00
Jul  4 13:26:20 ubuntu kernel: [36391.705276] 90: 36 00 30 00 30 00 30  
00 30 00 31 00 00 ff ff ff
Jul  4 13:26:20 ubuntu kernel: [36391.728768] a0: ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff ff ff
Jul  4 13:26:20 ubuntu kernel: [36391.751773] b0: ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff ff ff
Jul  4 13:26:20 ubuntu kernel: [36391.775398] c0: ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff ff ff
Jul  4 13:26:20 ubuntu kernel: [36391.798767] d0: ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff ff ff
Jul  4 13:26:20 ubuntu kernel: [36391.822008] e0: ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff ff ff
Jul  4 13:26:20 ubuntu kernel: [36391.845260] f0: ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff ff ff
Jul  4 13:26:20 ubuntu kernel: [36391.990863] af9013: firmware version: 
4.95.0
Jul  4 13:26:20 ubuntu kernel: [36391.996884] DVB: registering  
frontend 0 (Afatech AF9013 DVB-T)...
Jul  4 13:26:20 ubuntu kernel: [36391.997170] af9015_tuner_attach:
Jul  4 13:26:20 ubuntu kernel: [36392.156500] af9015_i2c_xfer: UNLOCK  
pid:1281 38 38
Jul  4 13:26:20 ubuntu kernel: [36392.158175] MT2060: successfully  
identified (IF1 = 1220)
Jul  4 13:26:21 ubuntu kernel: [36392.738401] af9015_i2c_xfer: UNLOCK  
pid:1281 38 38
Jul  4 13:26:21 ubuntu kernel: [36392.738918] input: IR-receiver  
inside an USB DVB receiver as /devices/pci0000:00/0000:00:1e. 
0/0000:01:08.2/usb4/4-2/input/input3
Jul  4 13:26:21 ubuntu kernel: [36392.794891] dvb-usb: schedule remote  
query interval to 150 msecs.
Jul  4 13:26:21 ubuntu kernel: [36392.794929] dvb-usb: Afatech AF9015  
DVB-T USB2.0 stick successfully initialized and connected.
Jul  4 13:26:21 ubuntu kernel: [36392.794943] af9015_init:
Jul  4 13:26:21 ubuntu kernel: [36392.794953] af9015_init_endpoint:  
USB speed:3
Jul  4 13:26:21 ubuntu kernel: [36392.807260] af9015_download_ir_table:
Jul  4 13:26:21 ubuntu kernel: [36392.858843] af9015_usb_probe:  
interface:1
Jul  4 13:26:21 ubuntu kernel: [36392.859188] usbcore: registered new  
interface driver hiddev
Jul  4 13:26:21 ubuntu kernel: [36392.859311] usbcore: registered new  
interface driver usbhid
Jul  4 13:26:21 ubuntu kernel: [36392.859327] /build/buildd/ 
linux-2.6.24/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver


Running with USB 2:

pfp@ubuntu:~$ vlcdvb
VLC media player 0.8.6e Janus
[00000289] skins2 interface: skin: VLC 0.8.5 Default Skin  author:  
aLtgLasS
[00000375] main private: creating httpd
[00000420] main private: creating httpd
libdvbpsi error (PSI decoder): TS discontinuity (received 6, expected  
0) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 2, expected  
0) for PID 18
libdvbpsi error (PSI decoder): TS discontinuity (received 12, expected  
0) for PID 17
libdvbpsi error (misc PSI): Bad CRC_32 (0x914ee554) !!!
libdvbpsi error (misc PSI): Bad CRC_32 (0x39df29f6) !!!
libdvbpsi error (PSI decoder): TS discontinuity (received 8, expected  
7) for PID 18
libdvbpsi error (PSI decoder): TS discontinuity (received 3, expected  
2) for PID 18
libdvbpsi error (PSI decoder): TS discontinuity (received 6, expected  
5) for PID 18
libdvbpsi error (misc PSI): Bad CRC_32 (0xc0a5eb0c) !!!
libdvbpsi error (misc PSI): Bad CRC_32 (0x9092c41a) !!!
libdvbpsi error (PSI decoder): TS discontinuity (received 6, expected  
5) for PID 256
libdvbpsi error (PSI decoder): TS discontinuity (received 12, expected  
11) for PID 18
libdvbpsi error (misc PSI): Bad CRC_32 (0xc05ed92c) !!!
libdvbpsi error (PSI decoder): TS discontinuity (received 4, expected  
3) for PID 18
libdvbpsi error (misc PSI): Bad CRC_32 (0xf0eeb44c) !!!
signal 2 received, terminating vlc - do it again in case it gets stuck
libdvbpsi error (PSI decoder): TS discontinuity (received 0, expected  
15) for PID 17
libdvbpsi error (PSI decoder): TS discontinuity (received 6, expected  
5) for PID 18
user insisted too much, dying badly
Aborted



Jul  4 13:30:18 ubuntu kernel: [36629.603014] af9015_i2c_xfer: UNLOCK  
pid:4251 38 38
Jul  4 13:30:18 ubuntu kernel: [36629.606151] af9015_i2c_xfer: UNLOCK  
pid:4251 38 38
Jul  4 13:30:18 ubuntu kernel: [36629.607669] af9015_i2c_xfer: UNLOCK  
pid:4251 38 38
Jul  4 13:30:18 ubuntu kernel: [36629.609895] af9015_i2c_xfer: UNLOCK  
pid:4251 38 38
Jul  4 13:30:18 ubuntu kernel: [36629.612109] af9015_i2c_xfer: UNLOCK  
pid:4251 38 38
Jul  4 13:30:18 ubuntu kernel: [36629.798758] af9015_i2c_xfer: UNLOCK  
pid:4251 38 38
Jul  4 13:30:18 ubuntu kernel: [36629.801499] af9015_i2c_xfer: UNLOCK  
pid:4251 38 38
Jul  4 13:30:18 ubuntu kernel: [36629.803005] af9015_i2c_xfer: UNLOCK  
pid:4251 38 38
Jul  4 13:30:18 ubuntu kernel: [36629.805326] af9015_pid_filter_ctrl:  
onoff:0
Jul  4 13:30:18 ubuntu kernel: [36629.826373] af9015_i2c_xfer: UNLOCK  
pid:4251 38 38
Jul  4 13:30:18 ubuntu kernel: [36629.865614] af9015_i2c_xfer: UNLOCK  
pid:4251 38 38
Jul  4 13:32:28 ubuntu kernel: [36759.976894] af9015_i2c_xfer: UNLOCK  
pid:4251 38 38
Jul  4 13:32:28 ubuntu kernel: [36759.978384] af9015_i2c_xfer: UNLOCK  
pid:4251 38 38
Jul  4 13:32:28 ubuntu kernel: [36759.979253] af9015_i2c_xfer: UNLOCK  
pid:4251 38 38


-- 
peter.parkkali@iki.fi | +358 40 532 9580




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
