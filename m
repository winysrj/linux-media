Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail10.syd.optusnet.com.au ([211.29.132.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pjama@optusnet.com.au>) id 1JzIju-0002Yy-KX
	for linux-dvb@linuxtv.org; Thu, 22 May 2008 23:54:25 +0200
Received: from zerver.home.pjama.net
	(c122-104-130-106.kelvn2.qld.optusnet.com.au [122.104.130.106])
	by mail10.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m4MLsD2G010720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Fri, 23 May 2008 07:54:15 +1000
Received: from [192.168.200.201] (emma.home.pjama.net [192.168.200.201])
	by zerver.home.pjama.net (8.13.8+Sun/8.13.8) with ESMTP id
	m4MLrhJ3023755
	for <linux-dvb@linuxtv.org>; Fri, 23 May 2008 07:53:44 +1000 (EST)
Message-ID: <4835EB67.1030702@optusnet.com.au>
Date: Fri, 23 May 2008 07:53:43 +1000
From: pjama <pjama@optusnet.com.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <56913.192.168.200.51.1211237228.squirrel@pjama.net>	<48320E91.3010306@iki.fi>	<57913.192.168.200.51.1211245507.squirrel@pjama.net>	<4832259A.6050101@iki.fi>
	<483232A9.6010609@iki.fi>
	<27514.203.9.185.254.1211343247.squirrel@pjama.net>
	<48340A29.6030505@iki.fi>
In-Reply-To: <48340A29.6030505@iki.fi>
Subject: Re: [linux-dvb] IR for Afatech 901x
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

Antti Palosaari wrote:
> pjama wrote:
>> As mentioned in an earlier response to this post, the above trashes the
>> device /dev/input/event7. Is there any way I can boot with debug set?
>
> 1) unplug your device

<unplugs device>

> 2) make sure new drivers are installed

$ modprobe -l | grep 9015
/lib/modules/2.6.24-16-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-af9015.ko
$

> 3) reboot your machine

$ sudo reboot

> 4) modprobe dvb-usb-af9015 debug=2

$ sudo modprobe dvb-usb-af9015 debug=2
<no visible output to console or /var/log/messages>

> 5) tail -f /var/log/messages


> 6) plug stick (now it should start pushing lines to /var/log/messages (or /var/log/debug) ?)

from /var/log/debug
May 23 07:17:54 SunU20 NetworkManager: <debug> [1211491074.409994] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_13d3_3226_010101010600001').
May 23 07:17:54 SunU20 NetworkManager: <debug> [1211491074.542633] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_ffffffff_ffffffff_noserial').
May 23 07:17:54 SunU20 NetworkManager: <debug> [1211491074.645105] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_ffffffff_ffffffff_noserial').
May 23 07:17:54 SunU20 NetworkManager: <debug> [1211491074.752626] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_ffffffff_ffffffff_noserial').
May 23 07:17:54 SunU20 NetworkManager: <debug> [1211491074.778197] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_ffffffff_ffffffff_noserial').
May 23 07:17:54 SunU20 NetworkManager: <debug> [1211491074.787075] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_13d3_3226_010101010600001').
May 23 07:17:54 SunU20 NetworkManager: <debug> [1211491074.976377] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_13d3_3226_010101010600001').
May 23 07:17:55 SunU20 NetworkManager: <debug> [1211491075.092114] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_13d3_3226_010101010600001_dvb').
May 23 07:17:55 SunU20 NetworkManager: <debug> [1211491075.178304] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_13d3_3226_010101010600001_dvb_0').
May 23 07:17:55 SunU20 NetworkManager: <debug> [1211491075.243582] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_13d3_3226_010101010600001_dvb_1').
May 23 07:17:55 SunU20 NetworkManager: <debug> [1211491075.245446] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_ffffffff_ffffffff_noserial').
May 23 07:17:55 SunU20 NetworkManager: <debug> [1211491075.741105] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_13d3_3226_010101010600001_dvb_2').
May 23 07:17:55 SunU20 NetworkManager: <debug> [1211491075.826068] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_13d3_3226_010101010600001_dvb_3').
May 23 07:17:55 SunU20 NetworkManager: <debug> [1211491075.860566] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_13d3_3226_010101010600001_dvb_4').
May 23 07:17:55 SunU20 NetworkManager: <debug> [1211491075.885109] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_13d3_3226_010101010600001_dvb_5').
May 23 07:17:56 SunU20 NetworkManager: <debug> [1211491076.558260] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_13d3_3226_010101010600001_dvb_6').
May 23 07:17:56 SunU20 NetworkManager: <debug> [1211491076.686901] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_13d3_3226_010101010600001_logicaldev_input').
May 23 07:17:57 SunU20 NetworkManager: <debug> [1211491077.468914] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_13d3_3226_010101010600001_if1').
May 23 07:17:57 SunU20 NetworkManager: <debug> [1211491077.620294] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_13d3_3226_010101010600001_if1_logicaldev_input').


from /var/log/messages
May 23 07:17:54 SunU20 kernel: [  540.173598] usb 2-2: new high speed USB device using ehci_hcd and address 4
May 23 07:17:54 SunU20 kernel: [  540.310477] usb 2-2: configuration #1 chosen from 1 choice
May 23 07:17:54 SunU20 kernel: [  540.318760] af9015_usb_probe: interface:0
May 23 07:17:54 SunU20 kernel: [  540.321138] af9015_read_config: TS mode:1
May 23 07:17:54 SunU20 kernel: [  540.323141] af9015_read_config: [0] xtal:2 set adc_clock:28000
May 23 07:17:54 SunU20 kernel: [  540.327127] af9015_read_config: [0] IF1:4570
May 23 07:17:54 SunU20 kernel: [  540.331126] af9015_read_config: [0] MT2060 IF1:0
May 23 07:17:54 SunU20 kernel: [  540.333122] af9015_read_config: [0] tuner id:30
May 23 07:17:54 SunU20 kernel: [  540.335122] af9015_read_config: [1] xtal:2 set adc_clock:28000
May 23 07:17:54 SunU20 kernel: [  540.339118] af9015_read_config: [1] IF1:4570
May 23 07:17:54 SunU20 kernel: [  540.343114] af9015_read_config: [1] MT2060 IF1:0
May 23 07:17:54 SunU20 kernel: [  540.345114] af9015_read_config: [1] tuner id:30
May 23 07:17:54 SunU20 kernel: [  540.346862] af9015_identify_state: reply:01
May 23 07:17:54 SunU20 kernel: [  540.346867] dvb-usb: found a 'DigitalNow TinyTwin DVB-T Receiver' in cold state, will try to load a firmware
May 23 07:17:54 SunU20 kernel: [  540.382541] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
May 23 07:17:54 SunU20 kernel: [  540.382549] af9015_download_firmware:
May 23 07:17:54 SunU20 kernel: [  540.495783] af9015_usb_probe: interface:1
May 23 07:17:54 SunU20 kernel: [  540.495892] usb 2-2: USB disconnect, address 4
May 23 07:17:54 SunU20 kernel: [  540.497615] af9015_usb_device_exit:
May 23 07:17:54 SunU20 kernel: [  540.497621] dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
May 23 07:17:54 SunU20 kernel: [  540.497697] af9015_usb_device_exit:
May 23 07:17:54 SunU20 kernel: [  540.497700] dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
May 23 07:17:54 SunU20 kernel: [  540.737250] usb 2-2: new high speed USB device using ehci_hcd and address 5
May 23 07:17:54 SunU20 kernel: [  540.874852] usb 2-2: configuration #1 chosen from 1 choice
May 23 07:17:54 SunU20 kernel: [  540.875266] af9015_usb_probe: interface:0
May 23 07:17:54 SunU20 kernel: [  540.876726] af9015_read_config: TS mode:1
May 23 07:17:54 SunU20 kernel: [  540.883959] af9015_read_config: [0] xtal:2 set adc_clock:28000
May 23 07:17:54 SunU20 kernel: [  540.887726] af9015_read_config: [0] IF1:4570
May 23 07:17:54 SunU20 kernel: [  540.891715] af9015_read_config: [0] MT2060 IF1:0
May 23 07:17:54 SunU20 kernel: [  540.893713] af9015_read_config: [0] tuner id:30
May 23 07:17:54 SunU20 kernel: [  540.895707] af9015_read_config: [1] xtal:2 set adc_clock:28000
May 23 07:17:54 SunU20 kernel: [  540.899704] af9015_read_config: [1] IF1:4570
May 23 07:17:54 SunU20 kernel: [  540.903700] af9015_read_config: [1] MT2060 IF1:0
May 23 07:17:54 SunU20 kernel: [  540.905700] af9015_read_config: [1] tuner id:30
May 23 07:17:55 SunU20 kernel: [  540.907448] af9015_identify_state: reply:02
May 23 07:17:55 SunU20 kernel: [  540.907453] dvb-usb: found a 'DigitalNow TinyTwin DVB-T Receiver' in warm state.
May 23 07:17:55 SunU20 kernel: [  540.907520] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
May 23 07:17:55 SunU20 kernel: [  540.908586] DVB: registering new adapter (DigitalNow TinyTwin DVB-T Receiver)
May 23 07:17:55 SunU20 kernel: [  540.908871] af9015_af9013_frontend_attach: init I2C
May 23 07:17:55 SunU20 kernel: [  540.908875] af9015_i2c_init:
May 23 07:17:55 SunU20 kernel: [  540.908899] af9015_eeprom_dump:
May 23 07:17:55 SunU20 kernel: [  540.966659] 00: 2a 88 9b 0b 00 00 00 00 d3 13 26 32 00 02 01 02
May 23 07:17:55 SunU20 kernel: [  541.009863] 10: 03 80 00 fa fa 10 40 ef 01 30 31 30 31 30 39 31
May 23 07:17:55 SunU20 kernel: [  541.053354] 20: 34 30 36 30 30 30 30 31 ff ff ff ff ff ff ff ff
May 23 07:17:55 SunU20 kernel: [  541.097560] 30: 00 01 3a 01 00 08 02 00 da 11 00 00 1e ff ff ff
May 23 07:17:55 SunU20 kernel: [  541.137636] 40: ff ff ff ff ff 08 02 00 da 11 00 00 1e ff ff ff
May 23 07:17:55 SunU20 kernel: [  541.181502] 50: ff ff ff ff ff 24 00 00 04 03 09 04 10 03 41 00
May 23 07:17:55 SunU20 kernel: [  541.213478] 60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00
May 23 07:17:55 SunU20 kernel: [  541.245458] 70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00
May 23 07:17:55 SunU20 kernel: [  541.277433] 80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
May 23 07:17:55 SunU20 kernel: [  541.309409] 90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
May 23 07:17:55 SunU20 kernel: [  541.341385] a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 23 07:17:55 SunU20 kernel: [  541.373361] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 23 07:17:55 SunU20 kernel: [  541.405329] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 23 07:17:55 SunU20 kernel: [  541.437314] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 23 07:17:55 SunU20 kernel: [  541.469290] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 23 07:17:55 SunU20 kernel: [  541.501263] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 23 07:17:55 SunU20 kernel: [  541.562963] af9013: firmware version:4.95.0
May 23 07:17:55 SunU20 kernel: [  541.582960] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
May 23 07:17:55 SunU20 kernel: [  541.583019] af9015_tuner_attach:
May 23 07:17:55 SunU20 kernel: [  541.674600] mxl500x_attach: Attaching ...
May 23 07:17:55 SunU20 kernel: [  541.674608] mxl500x_attach: MXL500x tuner succesfully attached
May 23 07:17:55 SunU20 kernel: [  541.674614] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
May 23 07:17:55 SunU20 kernel: [  541.675238] DVB: registering new adapter (DigitalNow TinyTwin DVB-T Receiver)
May 23 07:17:55 SunU20 kernel: [  541.675520] af9015_copy_firmware:
May 23 07:17:56 SunU20 kernel: [  542.183518] af9015_copy_firmware: firmware copy done
May 23 07:17:56 SunU20 kernel: [  542.289426] af9015_copy_firmware: firmware boot cmd status:0
May 23 07:17:56 SunU20 kernel: [  542.393349] af9015_copy_firmware: firmware status cmd status:0 fw status:0c
May 23 07:17:56 SunU20 kernel: [  542.399344] af9013: firmware version:4.95.0
May 23 07:17:56 SunU20 kernel: [  542.419332] DVB: registering frontend 1 (Afatech AF9013 DVB-T)...
May 23 07:17:56 SunU20 kernel: [  542.419391] af9015_tuner_attach:
May 23 07:17:56 SunU20 kernel: [  542.419458] mxl500x_attach: Attaching ...
May 23 07:17:56 SunU20 kernel: [  542.419461] mxl500x_attach: MXL500x tuner succesfully attached
May 23 07:17:56 SunU20 kernel: [  542.419541] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:02.1/usb2/2-2/input/input6
May 23 07:17:56 SunU20 kernel: [  542.448249] dvb-usb: schedule remote query interval to 150 msecs.
May 23 07:17:56 SunU20 kernel: [  542.448259] dvb-usb: DigitalNow TinyTwin DVB-T Receiver successfully initialized and connected.
May 23 07:17:56 SunU20 kernel: [  542.448264] af9015_init:
May 23 07:17:56 SunU20 kernel: [  542.448267] af9015_init_endpoint: USB speed:3
May 23 07:17:56 SunU20 kernel: [  542.526252] af9015_download_ir_table:
May 23 07:17:57 SunU20 kernel: [  543.257845] input: Afatech DVB-T 2 as /devices/pci0000:00/0000:00:02.1/usb2/2-2/2-2:1.1/input/input7
May 23 07:17:57 SunU20 kernel: [  543.287701] input,hidraw2: USB HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:02.1-2

>
> Remote buttons should now recognized in debug dumps.

nada. No more output to debug when pressing remote buttons, enter, left right 1,2,3 vol+/- etc


cheers
Peter

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
