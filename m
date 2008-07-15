Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <postfix@au-79.de>) id 1KIrdt-000167-9l
	for linux-dvb@linuxtv.org; Tue, 15 Jul 2008 23:01:06 +0200
Received: from agathe (dslb-088-065-143-075.pools.arcor-ip.net [88.65.143.75])
	by post.webmailer.de (fruni mo57) (RZmta 16.47)
	with ESMTP id w03723k6FJnrqm for <linux-dvb@linuxtv.org>;
	Tue, 15 Jul 2008 23:00:57 +0200 (MEST)
	(envelope-from: <postfix@au-79.de>)
Received: from localhost (agathe [127.0.0.1])
	by agathe (Postfix) with ESMTP id 6B98A1BC39
	for <linux-dvb@linuxtv.org>; Tue, 15 Jul 2008 23:00:57 +0200 (CEST)
Received: from agathe ([127.0.0.1])
	by localhost (agathe.au-79.intra [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pv87Sk0nlcE6 for <linux-dvb@linuxtv.org>;
	Tue, 15 Jul 2008 23:00:54 +0200 (CEST)
Received: from [192.168.23.123] (hepto.au-79.intra [192.168.23.123])
	by agathe (Postfix) with ESMTP id A28E11BC35
	for <linux-dvb@linuxtv.org>; Tue, 15 Jul 2008 23:00:53 +0200 (CEST)
Message-ID: <487D1005.8000208@au-79.de>
Date: Tue, 15 Jul 2008 23:00:53 +0200
From: "postfix@au-79.de" <postfix@au-79.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] unknown dvbt device 1ae7:0381 Xtensions 380U
Reply-To: postfix@au-79.de
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

Hello Antti,

this was the solution. It works now quite fine. Thanks a lot for your
fast and very good work.

here again the dmesg:

usb 1-6.1: new high speed USB device using ehci_hcd and address 10
usb 1-6.1: configuration #1 chosen from 1 choice
usb 1-6.1: New USB device found, idVendor=1ae7, idProduct=0381
usb 1-6.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-6.1: Product: DVB-T 2
usb 1-6.1: Manufacturer: Afatech
af9015_usb_probe: interface:0
af9015_read_config: IR mode:4
af9015_read_config: TS mode:0
af9015_read_config: [0] xtal:2 set adc_clock:28000
af9015_read_config: [0] IF1:36125
af9015_read_config: [0] MT2060 IF1:5888
af9015_read_config: [0] tuner id:134
af9015_identify_state: reply:01
dvb-usb: found a 'Xtensions XD-380' in cold state, will try to load a
firmware
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
af9015_download_firmware:
usbcore: registered new interface driver dvb_usb_af9015
usb 1-6.1: USB disconnect, address 10
af9015_usb_device_exit:
dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
usb 1-6.1: new high speed USB device using ehci_hcd and address 11
usb 1-6.1: configuration #1 chosen from 1 choice
af9015_usb_probe: interface:0
af9015_read_config: IR mode:4
af9015_read_config: TS mode:0
af9015_read_config: [0] xtal:2 set adc_clock:28000
af9015_read_config: [0] IF1:36125
af9015_read_config: [0] MT2060 IF1:5888
af9015_read_config: [0] tuner id:134
af9015_identify_state: reply:02
dvb-usb: found a 'Xtensions XD-380' in warm state.
i2c-adapter i2c-3: SMBus Quick command not supported, can't probe for chips
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (Xtensions XD-380)
af9015_af9013_frontend_attach: init I2C
af9015_i2c_init:
i2c-adapter i2c-4: SMBus Quick command not supported, can't probe for chips
00: 2b f0 9b 0b 00 00 00 00 e7 1a 81 03 00 02 01 02
10: 00 80 00 fa fa 10 40 ef 04 30 31 30 31 30 32 30
20: 32 30 37 30 30 30 30 31 ff ff ff ff ff ff ff ff
30: 00 00 3a 01 00 08 02 00 1d 8d 00 17 86 ff ff ff
40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
50: ff ff ff ff ff 26 00 00 04 03 09 04 10 03 41 00
60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00
70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00
80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
af9013: chip version:1 ROM version:1.0
af9013: firmware version:4.65.0
DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
af9015_tuner_attach:
Quantek QT1010 successfully identified.
dvb-usb: Xtensions XD-380 successfully initialized and connected.
af9015_init:
af9015_init_endpoint: USB speed:3
af9015_download_ir_table:
usb 1-6.1: New USB device found, idVendor=1ae7, idProduct=0381
usb 1-6.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-6.1: Product: DVB-T 2
usb 1-6.1: Manufacturer: Afatech
af9015_pid_filter_ctrl: onoff:0

If you want me to try any patches etc. please let me know. As far as I
see, this device has no IR-interface.

regards

Robert


Antti Palosaari schrieb:
> postfix@au-79.de wrote:
>> Hello Antti,
>>
>> thanks for your work. I tryed your patched files and according to 
>> dmesg, it looks like a good initialisation. But after init there are 
>> endless failures like:
>> dvb-usb: error while querying for an remote control event.
>> af9015: af9015_rw_udev: sending failed: -110 (8/0)
>> af9015: af9015_rw_udev: receiving failed: -110
> 
> I have no idea what IR-mode is 0x04 but hopefully it will start working 
> now when remote polling is disabled.
> Please test again.
> 
> regards
> Antti


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
