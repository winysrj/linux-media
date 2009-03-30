Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:51512 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbZC3WzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 18:55:05 -0400
From: Olivier MENUEL <omenuel@laposte.net>
To: Thomas RENARD <threnard@gmail.com>
Subject: Re: AverMedia Volar Black HD (A850)
Date: Tue, 31 Mar 2009 00:48:19 +0200
Cc: Antti Palosaari <crope@iki.fi>,
	Laurent Haond <lhaond@bearstech.com>,
	linux-media@vger.kernel.org,
	Karsten Blumenau <info@blume-online.de>,
	pHilipp Zabel <philipp.zabel@gmail.com>,
	Martin =?iso-8859-1?q?M=FCller?= <mueller1977@web.de>
References: <200903291334.00879.olivier.menuel@free.fr> <49D1287C.5010803@iki.fi> <49D13272.7050906@laposte.net>
In-Reply-To: <49D13272.7050906@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903310048.19629.omenuel@laposte.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Here are my tests :

http://linuxtv.org/hg/~anttip/af9015_aver_a850_2/ :

Mar 31 00:16:27 blastor kernel: [12790.692333] usb 5-4.4: new high speed USB device using ehci_hcd and address 13
Mar 31 00:16:27 blastor kernel: [12790.788517] usb 5-4.4: configuration #1 chosen from 1 choice
Mar 31 00:16:27 blastor kernel: [12790.789245] af9015_usb_probe: interface:0
Mar 31 00:16:27 blastor kernel: [12790.793278] af9015_read_config: IR mode:0
Mar 31 00:16:27 blastor kernel: [12790.795755] af9015_read_config: TS mode:1
Mar 31 00:16:27 blastor kernel: [12790.798681] af9015_read_config: [0] xtal:2 set adc_clock:28000
Mar 31 00:16:27 blastor kernel: [12790.801555] af9015_read_config: [0] IF1:36125
Mar 31 00:16:27 blastor kernel: [12790.804556] af9015_read_config: [0] MT2060 IF1:0
Mar 31 00:16:27 blastor kernel: [12790.805935] af9015_read_config: [0] tuner id:13
Mar 31 00:16:27 blastor kernel: [12790.807424] af9015_read_config: [1] xtal:2 set adc_clock:28000
Mar 31 00:16:27 blastor kernel: [12790.810300] af9015_read_config: [1] IF1:36125
Mar 31 00:16:27 blastor kernel: [12790.830517] af9015_read_config: [1] MT2060 IF1:1220
Mar 31 00:16:27 blastor kernel: [12790.836368] af9015_read_config: [1] tuner id:130
Mar 31 00:16:27 blastor kernel: [12790.836376] af9015_read_config: AverMedia A850: overriding config
Mar 31 00:16:27 blastor kernel: [12790.836805] af9015_identify_state: reply:01
Mar 31 00:16:27 blastor kernel: [12790.836810] dvb-usb: found a 'AverMedia AVerTV Volar Black HD (A850)' in cold state, will try to load a firmware
Mar 31 00:16:27 blastor kernel: [12790.836813] firmware: requesting dvb-usb-af9015.fw
Mar 31 00:16:27 blastor kernel: [12790.872856] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
Mar 31 00:16:27 blastor kernel: [12790.872864] af9015_download_firmware:
Mar 31 00:16:27 blastor kernel: [12790.964480] dvb-usb: found a 'AverMedia AVerTV Volar Black HD (A850)' in warm state.
Mar 31 00:16:27 blastor kernel: [12790.964570] i2c-adapter i2c-5: SMBus Quick command not supported, can't probe for chips
Mar 31 00:16:27 blastor kernel: [12790.964579] i2c-adapter i2c-5: SMBus Quick command not supported, can't probe for chips
Mar 31 00:16:27 blastor kernel: [12790.964594] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Mar 31 00:16:27 blastor kernel: [12790.966730] DVB: registering new adapter (AverMedia AVerTV Volar Black HD (A850))
Mar 31 00:16:27 blastor kernel: [12790.967156] af9015_af9013_frontend_attach: init I2C
Mar 31 00:16:27 blastor kernel: [12790.967160] af9015_i2c_init:
Mar 31 00:16:27 blastor kernel: [12790.967196] i2c-adapter i2c-6: SMBus Quick command not supported, can't probe for chips
Mar 31 00:16:27 blastor kernel: [12790.967216] i2c-adapter i2c-6: SMBus Quick command not supported, can't probe for chips
Mar 31 00:16:27 blastor kernel: [12791.004560] 00: 2c 8f a3 0b 00 00 00 00 ca 07 0a 85 01 01 01 02
Mar 31 00:16:27 blastor kernel: [12791.028769] 10: 03 80 00 fa fa 10 40 ef 00 30 31 30 31 30 37 30
Mar 31 00:16:27 blastor kernel: [12791.052023] 20: 33 30 37 30 30 30 30 31 ff ff ff ff ff ff ff ff
Mar 31 00:16:27 blastor kernel: [12791.075878] 30: 01 01 38 01 00 08 02 01 1d 8d 00 00 0d ff ff ff
Mar 31 00:16:27 blastor kernel: [12791.099499] 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
Mar 31 00:16:27 blastor kernel: [12791.123372] 50: ff ff ff ff ff 26 00 00 04 03 09 04 14 03 41 00
Mar 31 00:16:27 blastor kernel: [12791.147194] 60: 56 00 65 00 72 00 4d 00 65 00 64 00 69 00 61 00
Mar 31 00:16:27 blastor kernel: [12791.170869] 70: 14 03 41 00 38 00 35 00 30 00 20 00 44 00 56 00
Mar 31 00:16:27 blastor kernel: [12791.195111] 80: 42 00 54 00 20 03 33 00 30 00 31 00 34 00 37 00
Mar 31 00:16:27 blastor kernel: [12791.219359] 90: 35 00 34 00 30 00 30 00 37 00 33 00 36 00 30 00
Mar 31 00:16:27 blastor kernel: [12791.243602] a0: 30 00 30 00 00 ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:16:27 blastor kernel: [12791.267347] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:16:27 blastor kernel: [12791.291469] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:16:27 blastor kernel: [12791.315592] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:16:27 blastor kernel: [12791.339711] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:16:28 blastor kernel: [12791.363335] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:16:28 blastor kernel: [12791.366460] af9013: firmware version:4.95.0
Mar 31 00:16:28 blastor kernel: [12791.372472] DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
Mar 31 00:16:28 blastor kernel: [12791.372532] af9015_tuner_attach:
Mar 31 00:16:28 blastor kernel: [12791.372770] MXL5005S: Attached at address 0xc6
Mar 31 00:16:28 blastor kernel: [12791.372776] dvb-usb: AverMedia AVerTV Volar Black HD (A850) successfully initialized and connected.
Mar 31 00:16:28 blastor kernel: [12791.372778] af9015_init:
Mar 31 00:16:28 blastor kernel: [12791.372780] af9015_init_endpoint: USB speed:3
Mar 31 00:16:28 blastor kernel: [12791.389336] af9015_download_ir_table:
Mar 31 00:16:28 blastor kernel: [12791.389559] usb 5-4.4: New USB device found, idVendor=07ca, idProduct=850a
Mar 31 00:16:28 blastor kernel: [12791.389563] usb 5-4.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Mar 31 00:16:28 blastor kernel: [12791.389566] usb 5-4.4: Product: A850 DVBT
Mar 31 00:16:28 blastor kernel: [12791.389568] usb 5-4.4: Manufacturer: AVerMedia
Mar 31 00:16:28 blastor kernel: [12791.389570] usb 5-4.4: SerialNumber: 301475400736000

I found why kaffeine was not working : I needed to check all offset checkboxes when scanning.
Like Thomas, I get these messages in /var/log/messages when scanning or changing channel : af9015_pid_filter_ctrl: onoff:0 (with kaffeine, scan or vlc)

I found a weird thing though with kaffeine (that may be a wrong setting somewhere in kaffeine though, it's the first time I use a DVB device on linux). If I stop kaffeine and restart it I can't access the channels I just scanned anymore : I get an error message :
Tuning to: NRJ12 / autocount: 0
Using DVB device 0:0 "Afatech AF9013 DVB-T"
tuning DVB-T to 498167000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
.....
Not able to lock to the signal on the given frequency
Frontend closed
Tuning delay: 1062 ms

I need to switch channels several times and eventually it works : I can now change channels without any problems !
But if I quit and restart kaffeine, I get the same problem again
No problem with VLC.

Except that everything seems to work perfectly fine !
I'm not sure exactly what you want me to test though.


GPI01 :
Mar 31 00:25:01 blastor kernel: [13305.044263] usb 5-4.4: new high speed USB device using ehci_hcd and address 14
Mar 31 00:25:01 blastor kernel: [13305.140573] usb 5-4.4: configuration #1 chosen from 1 choice
Mar 31 00:25:01 blastor kernel: [13305.141320] af9015_usb_probe: interface:0
Mar 31 00:25:01 blastor kernel: [13305.145389] af9015_read_config: IR mode:0
Mar 31 00:25:01 blastor kernel: [13305.150442] af9015_read_config: TS mode:1
Mar 31 00:25:01 blastor kernel: [13305.154098] af9015_read_config: [0] xtal:2 set adc_clock:28000
Mar 31 00:25:01 blastor kernel: [13305.160898] af9015_read_config: [0] IF1:36125
Mar 31 00:25:01 blastor kernel: [13305.171403] af9015_read_config: [0] MT2060 IF1:0
Mar 31 00:25:01 blastor kernel: [13305.173394] af9015_read_config: [0] tuner id:13
Mar 31 00:25:01 blastor kernel: [13305.174894] af9015_read_config: [1] xtal:2 set adc_clock:28000
Mar 31 00:25:01 blastor kernel: [13305.182112] af9015_read_config: [1] IF1:36125
Mar 31 00:25:01 blastor kernel: [13305.185108] af9015_read_config: [1] MT2060 IF1:1220
Mar 31 00:25:01 blastor kernel: [13305.186484] af9015_read_config: [1] tuner id:130
Mar 31 00:25:01 blastor kernel: [13305.186489] af9015_read_config: AverMedia A850: overriding config
Mar 31 00:25:01 blastor kernel: [13305.186977] af9015_identify_state: reply:01
Mar 31 00:25:01 blastor kernel: [13305.186982] dvb-usb: found a 'AverMedia AVerTV Volar Black HD (A850)' in cold state, will try to load a firmware
Mar 31 00:25:01 blastor kernel: [13305.186985] firmware: requesting dvb-usb-af9015.fw
Mar 31 00:25:01 blastor kernel: [13305.194723] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
Mar 31 00:25:01 blastor kernel: [13305.194733] af9015_download_firmware:
Mar 31 00:25:01 blastor kernel: [13305.275294] dvb-usb: found a 'AverMedia AVerTV Volar Black HD (A850)' in warm state.
Mar 31 00:25:01 blastor kernel: [13305.275388] i2c-adapter i2c-5: SMBus Quick command not supported, can't probe for chips
Mar 31 00:25:01 blastor kernel: [13305.275398] i2c-adapter i2c-5: SMBus Quick command not supported, can't probe for chips
Mar 31 00:25:01 blastor kernel: [13305.275412] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Mar 31 00:25:01 blastor kernel: [13305.278513] DVB: registering new adapter (AverMedia AVerTV Volar Black HD (A850))
Mar 31 00:25:01 blastor kernel: [13305.278928] af9015_af9013_frontend_attach: init I2C
Mar 31 00:25:01 blastor kernel: [13305.278931] af9015_i2c_init:
Mar 31 00:25:01 blastor kernel: [13305.278969] i2c-adapter i2c-6: SMBus Quick command not supported, can't probe for chips
Mar 31 00:25:01 blastor kernel: [13305.278980] i2c-adapter i2c-6: SMBus Quick command not supported, can't probe for chips
Mar 31 00:25:01 blastor kernel: [13305.307006] 00: 2c 8f a3 0b 00 00 00 00 ca 07 0a 85 01 01 01 02
Mar 31 00:25:01 blastor kernel: [13305.332710] 10: 03 80 00 fa fa 10 40 ef 00 30 31 30 31 30 37 30
Mar 31 00:25:02 blastor kernel: [13305.356927] 20: 33 30 37 30 30 30 30 31 ff ff ff ff ff ff ff ff
Mar 31 00:25:02 blastor kernel: [13305.381326] 30: 01 01 38 01 00 08 02 01 1d 8d 00 00 0d ff ff ff
Mar 31 00:25:02 blastor kernel: [13305.405332] 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
Mar 31 00:25:02 blastor kernel: [13305.430064] 50: ff ff ff ff ff 26 00 00 04 03 09 04 14 03 41 00
Mar 31 00:25:02 blastor kernel: [13305.453937] 60: 56 00 65 00 72 00 4d 00 65 00 64 00 69 00 61 00
Mar 31 00:25:02 blastor kernel: [13305.478681] 70: 14 03 41 00 38 00 35 00 30 00 20 00 44 00 56 00
Mar 31 00:25:02 blastor kernel: [13305.504683] 80: 42 00 54 00 20 03 33 00 30 00 31 00 34 00 37 00
Mar 31 00:25:02 blastor kernel: [13305.528680] 90: 35 00 34 00 30 00 30 00 37 00 33 00 36 00 30 00
Mar 31 00:25:02 blastor kernel: [13305.552924] a0: 30 00 30 00 00 ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:25:02 blastor kernel: [13305.576549] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:25:02 blastor kernel: [13305.601042] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:25:02 blastor kernel: [13305.624662] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:25:02 blastor kernel: [13305.648162] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:25:02 blastor kernel: [13305.672528] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:25:02 blastor kernel: [13305.675647] af9013: firmware version:4.95.0
Mar 31 00:25:02 blastor kernel: [13305.681782] DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
Mar 31 00:25:02 blastor kernel: [13305.681843] af9015_tuner_attach:
Mar 31 00:25:02 blastor kernel: [13305.682074] MXL5005S: Attached at address 0xc6
Mar 31 00:25:02 blastor kernel: [13305.682081] dvb-usb: AverMedia AVerTV Volar Black HD (A850) successfully initialized and connected.
Mar 31 00:25:02 blastor kernel: [13305.682084] af9015_init:
Mar 31 00:25:02 blastor kernel: [13305.682086] af9015_init_endpoint: USB speed:3
Mar 31 00:25:02 blastor kernel: [13305.698619] af9015_download_ir_table:
Mar 31 00:25:02 blastor kernel: [13305.698836] usb 5-4.4: New USB device found, idVendor=07ca, idProduct=850a
Mar 31 00:25:02 blastor kernel: [13305.698839] usb 5-4.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Mar 31 00:25:02 blastor kernel: [13305.698842] usb 5-4.4: Product: A850 DVBT
Mar 31 00:25:02 blastor kernel: [13305.698844] usb 5-4.4: Manufacturer: AVerMedia
Mar 31 00:25:02 blastor kernel: [13305.698846] usb 5-4.4: SerialNumber: 301475400736000

Seems quite similar to previous one. Everything seems fine too (except the weird kaffeine issue).
In the logs I get the same message : af9015_pid_filter_ctrl: onoff:0



Finally, I tested GPI00 :
Mar 31 00:29:12 blastor kernel: [13555.756325] usb 5-4.4: new high speed USB device using ehci_hcd and address 15
Mar 31 00:29:12 blastor kernel: [13555.852627] usb 5-4.4: configuration #1 chosen from 1 choice
Mar 31 00:29:12 blastor kernel: [13555.853345] af9015_usb_probe: interface:0
Mar 31 00:29:12 blastor kernel: [13555.857669] af9015_read_config: IR mode:0
Mar 31 00:29:12 blastor kernel: [13555.862155] af9015_read_config: TS mode:1
Mar 31 00:29:12 blastor kernel: [13555.878721] af9015_read_config: [0] xtal:2 set adc_clock:28000
Mar 31 00:29:12 blastor kernel: [13555.885175] af9015_read_config: [0] IF1:36125
Mar 31 00:29:12 blastor kernel: [13555.888166] af9015_read_config: [0] MT2060 IF1:0
Mar 31 00:29:12 blastor kernel: [13555.889538] af9015_read_config: [0] tuner id:13
Mar 31 00:29:12 blastor kernel: [13555.891038] af9015_read_config: [1] xtal:2 set adc_clock:28000
Mar 31 00:29:12 blastor kernel: [13555.893921] af9015_read_config: [1] IF1:36125
Mar 31 00:29:12 blastor kernel: [13555.896912] af9015_read_config: [1] MT2060 IF1:1220
Mar 31 00:29:12 blastor kernel: [13555.898284] af9015_read_config: [1] tuner id:130
Mar 31 00:29:12 blastor kernel: [13555.898288] af9015_read_config: AverMedia A850: overriding config
Mar 31 00:29:12 blastor kernel: [13555.898783] af9015_identify_state: reply:01
Mar 31 00:29:12 blastor kernel: [13555.898788] dvb-usb: found a 'AverMedia AVerTV Volar Black HD (A850)' in cold state, will try to load a firmware
Mar 31 00:29:12 blastor kernel: [13555.898792] firmware: requesting dvb-usb-af9015.fw
Mar 31 00:29:12 blastor kernel: [13555.911638] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
Mar 31 00:29:12 blastor kernel: [13555.911647] af9015_download_firmware:
Mar 31 00:29:12 blastor kernel: [13555.993946] dvb-usb: found a 'AverMedia AVerTV Volar Black HD (A850)' in warm state.
Mar 31 00:29:12 blastor kernel: [13555.994042] i2c-adapter i2c-0: SMBus Quick command not supported, can't probe for chips
Mar 31 00:29:12 blastor kernel: [13555.994051] i2c-adapter i2c-0: SMBus Quick command not supported, can't probe for chips
Mar 31 00:29:12 blastor kernel: [13555.994065] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Mar 31 00:29:12 blastor kernel: [13555.994420] DVB: registering new adapter (AverMedia AVerTV Volar Black HD (A850))
Mar 31 00:29:12 blastor kernel: [13555.994781] af9015_af9013_frontend_attach: init I2C
Mar 31 00:29:12 blastor kernel: [13555.994784] af9015_i2c_init:
Mar 31 00:29:12 blastor kernel: [13555.994816] i2c-adapter i2c-5: SMBus Quick command not supported, can't probe for chips
Mar 31 00:29:12 blastor kernel: [13555.994823] i2c-adapter i2c-5: SMBus Quick command not supported, can't probe for chips
Mar 31 00:29:12 blastor kernel: [13556.020831] 00: 2c 8f a3 0b 00 00 00 00 ca 07 0a 85 01 01 01 02
Mar 31 00:29:12 blastor kernel: [13556.046261] 10: 03 80 00 fa fa 10 40 ef 00 30 31 30 31 30 37 30
Mar 31 00:29:12 blastor kernel: [13556.070381] 20: 33 30 37 30 30 30 30 31 ff ff ff ff ff ff ff ff
Mar 31 00:29:12 blastor kernel: [13556.094003] 30: 01 01 38 01 00 08 02 01 1d 8d 00 00 0d ff ff ff
Mar 31 00:29:12 blastor kernel: [13556.117876] 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
Mar 31 00:29:12 blastor kernel: [13556.141496] 50: ff ff ff ff ff 26 00 00 04 03 09 04 14 03 41 00
Mar 31 00:29:12 blastor kernel: [13556.165245] 60: 56 00 65 00 72 00 4d 00 65 00 64 00 69 00 61 00
Mar 31 00:29:12 blastor kernel: [13556.189118] 70: 14 03 41 00 38 00 35 00 30 00 20 00 44 00 56 00
Mar 31 00:29:12 blastor kernel: [13556.212860] 80: 42 00 54 00 20 03 33 00 30 00 31 00 34 00 37 00
Mar 31 00:29:12 blastor kernel: [13556.239114] 90: 35 00 34 00 30 00 30 00 37 00 33 00 36 00 30 00
Mar 31 00:29:12 blastor kernel: [13556.263098] a0: 30 00 30 00 00 ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:29:12 blastor kernel: [13556.287094] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:29:12 blastor kernel: [13556.311091] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:29:12 blastor kernel: [13556.335088] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:29:13 blastor kernel: [13556.359582] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:29:13 blastor kernel: [13556.383329] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 31 00:29:13 blastor kernel: [13556.386456] af9013: firmware version:4.95.0
Mar 31 00:29:13 blastor kernel: [13556.393213] DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
Mar 31 00:29:13 blastor kernel: [13556.393275] af9015_tuner_attach:
Mar 31 00:29:13 blastor kernel: [13556.393508] MXL5005S: Attached at address 0xc6
Mar 31 00:29:13 blastor kernel: [13556.393515] dvb-usb: AverMedia AVerTV Volar Black HD (A850) successfully initialized and connected.
Mar 31 00:29:13 blastor kernel: [13556.393518] af9015_init:
Mar 31 00:29:13 blastor kernel: [13556.393520] af9015_init_endpoint: USB speed:3
Mar 31 00:29:13 blastor kernel: [13556.409454] af9015_download_ir_table:
Mar 31 00:29:13 blastor kernel: [13556.409677] usb 5-4.4: New USB device found, idVendor=07ca, idProduct=850a
Mar 31 00:29:13 blastor kernel: [13556.409680] usb 5-4.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Mar 31 00:29:13 blastor kernel: [13556.409683] usb 5-4.4: Product: A850 DVBT
Mar 31 00:29:13 blastor kernel: [13556.409685] usb 5-4.4: Manufacturer: AVerMedia
Mar 31 00:29:13 blastor kernel: [13556.409687] usb 5-4.4: SerialNumber: 301475400736000

Working fine too, seems exactly like previous ones.

I hope I installed these correctly and did not mess up between the different drivers.
Let me know if something seems weird or if you want me to test something else.

I'm really glad it finally works ;) Thanks a lot.


Le lundi 30 mars 2009, Thomas RENARD a �crit�:
> 
> Hi,
> 
> I try http://linuxtv.org/hg/~anttip/af9015_aver_a850/.
> 
> Here is my /var/log/messages :
> Mar 30 22:27:57 trubuntu kernel: [ 5020.136029] usb 3-6: new high speed 
> USB device using ehci_hcd and address 3
> Mar 30 22:27:57 trubuntu kernel: [ 5020.277506] usb 3-6: configuration 
> #1 chosen from 1 choice
> Mar 30 22:27:58 trubuntu kernel: [ 5020.693808] af9015_usb_probe: 
> interface:0
> Mar 30 22:27:58 trubuntu kernel: [ 5020.695742] af9015_read_config: IR 
> mode:0
> Mar 30 22:27:58 trubuntu kernel: [ 5020.697752] af9015_read_config: TS 
> mode:1
> Mar 30 22:27:58 trubuntu kernel: [ 5020.701256] af9015_read_config: [0] 
> xtal:2 set adc_clock:28000
> Mar 30 22:27:58 trubuntu kernel: [ 5020.704341] af9015_read_config: [0] 
> IF1:36125
> Mar 30 22:27:58 trubuntu kernel: [ 5020.707708] af9015_read_config: [0] 
> MT2060 IF1:0
> Mar 30 22:27:58 trubuntu kernel: [ 5020.709583] af9015_read_config: [0] 
> tuner id:13
> Mar 30 22:27:58 trubuntu kernel: [ 5020.711459] af9015_read_config: [1] 
> xtal:2 set adc_clock:28000
> Mar 30 22:27:58 trubuntu kernel: [ 5020.714830] af9015_read_config: [1] 
> IF1:36125
> Mar 30 22:27:58 trubuntu kernel: [ 5020.718084] af9015_read_config: [1] 
> MT2060 IF1:1220
> Mar 30 22:27:58 trubuntu kernel: [ 5020.719957] af9015_read_config: [1] 
> tuner id:130
> Mar 30 22:27:58 trubuntu kernel: [ 5020.719962] af9015_read_config: ugly 
> and broken AverMedia A850 device detected, will hack configuration...
> Mar 30 22:27:58 trubuntu kernel: [ 5020.721706] af9015_identify_state: 
> reply:01
> Mar 30 22:27:58 trubuntu kernel: [ 5020.721711] dvb-usb: found a 
> 'AVerMedia A850' in cold state, will try to load a firmware
> Mar 30 22:27:58 trubuntu kernel: [ 5020.721715] firmware: requesting 
> dvb-usb-af9015.fw
> Mar 30 22:27:58 trubuntu kernel: [ 5020.777040] dvb-usb: downloading 
> firmware from file 'dvb-usb-af9015.fw'
> Mar 30 22:27:58 trubuntu kernel: [ 5020.777051] af9015_download_firmware:
> Mar 30 22:27:58 trubuntu kernel: [ 5020.847585] dvb-usb: found a 
> 'AVerMedia A850' in warm state.
> Mar 30 22:27:58 trubuntu kernel: [ 5020.849750] dvb-usb: will pass the 
> complete MPEG2 transport stream to the software demuxer.
> Mar 30 22:27:58 trubuntu kernel: [ 5020.852368] DVB: registering new 
> adapter (AVerMedia A850)
> Mar 30 22:27:58 trubuntu kernel: [ 5020.853615] 
> af9015_af9013_frontend_attach: init I2C
> Mar 30 22:27:58 trubuntu kernel: [ 5020.853626] af9015_i2c_init:
> Mar 30 22:27:58 trubuntu kernel: [ 5020.889200] 00: 2c 83 a3 0b 00 00 00 
> 00 ca 07 0a 85 01 01 01 02
> Mar 30 22:27:58 trubuntu kernel: [ 5020.913427] 10: 03 80 00 fa fa 10 40 
> ef 00 30 31 30 31 30 37 30
> Mar 30 22:27:58 trubuntu kernel: [ 5020.959135] 20: 33 30 37 30 30 30 30 
> 31 ff ff ff ff ff ff ff ff
> Mar 30 22:27:58 trubuntu kernel: [ 5020.987860] 30: 01 01 38 01 00 08 02 
> 01 1d 8d 00 00 0d ff ff ff
> Mar 30 22:27:58 trubuntu kernel: [ 5021.051391] 40: ff ff ff ff ff 08 02 
> 00 1d 8d c4 04 82 ff ff ff
> Mar 30 22:27:58 trubuntu kernel: [ 5021.092053] 50: ff ff ff ff ff 26 00 
> 00 04 03 09 04 14 03 41 00
> Mar 30 22:27:58 trubuntu kernel: [ 5021.125472] 60: 56 00 65 00 72 00 4d 
> 00 65 00 64 00 69 00 61 00
> Mar 30 22:27:58 trubuntu kernel: [ 5021.169028] 70: 14 03 41 00 38 00 35 
> 00 30 00 20 00 44 00 56 00
> Mar 30 22:27:58 trubuntu kernel: [ 5021.235275] 80: 42 00 54 00 20 03 33 
> 00 30 00 31 00 34 00 37 00
> Mar 30 22:27:58 trubuntu kernel: [ 5021.260035] 90: 35 00 32 00 30 00 31 
> 00 30 00 33 00 32 00 30 00
> Mar 30 22:27:58 trubuntu kernel: [ 5021.284759] a0: 30 00 30 00 00 ff ff 
> ff ff ff ff ff ff ff ff ff
> Mar 30 22:27:58 trubuntu kernel: [ 5021.316493] b0: ff ff ff ff ff ff ff 
> ff ff ff ff ff ff ff ff ff
> Mar 30 22:27:58 trubuntu kernel: [ 5021.339978] c0: ff ff ff ff ff ff ff 
> ff ff ff ff ff ff ff ff ff
> Mar 30 22:27:58 trubuntu kernel: [ 5021.362849] d0: ff ff ff ff ff ff ff 
> ff ff ff ff ff ff ff ff ff
> Mar 30 22:27:58 trubuntu kernel: [ 5021.385971] e0: ff ff ff ff ff ff ff 
> ff ff ff ff ff ff ff ff ff
> Mar 30 22:27:58 trubuntu kernel: [ 5021.408985] f0: ff ff ff ff ff ff ff 
> ff ff ff ff ff ff ff ff ff
> Mar 30 22:27:58 trubuntu kernel: [ 5021.441584] af9013: firmware 
> version:4.95.0
> Mar 30 22:27:58 trubuntu kernel: [ 5021.446464] DVB: registering adapter 
> 0 frontend 0 (Afatech AF9013 DVB-T)...
> Mar 30 22:27:58 trubuntu kernel: [ 5021.447354] af9015_tuner_attach:
> Mar 30 22:27:58 trubuntu kernel: [ 5021.527526] MXL5005S: Attached at 
> address 0xc6
> Mar 30 22:27:58 trubuntu kernel: [ 5021.527536] dvb-usb: AVerMedia A850 
> successfully initialized and connected.
> Mar 30 22:27:58 trubuntu kernel: [ 5021.527540] af9015_init:
> Mar 30 22:27:58 trubuntu kernel: [ 5021.527542] af9015_init_endpoint: 
> USB speed:3
> Mar 30 22:27:58 trubuntu kernel: [ 5021.537693] af9015_download_ir_table:
> Mar 30 22:27:58 trubuntu kernel: [ 5021.538262] usbcore: registered new 
> interface driver dvb_usb_af9015
> Mar 30 22:36:09 trubuntu kernel: [ 5512.208930] af9015_pid_filter_ctrl: 
> onoff:0
> Mar 30 22:36:09 trubuntu kernel: [ 5512.363024] af9015_pid_filter_ctrl: 
> onoff:0
> Mar 30 22:36:09 trubuntu kernel: [ 5512.472992] af9015_pid_filter_ctrl: 
> onoff:0
> Mar 30 22:36:10 trubuntu kernel: [ 5512.660525] af9015_pid_filter_ctrl: 
> onoff:0
> Mar 30 22:36:10 trubuntu kernel: [ 5512.763080] af9015_pid_filter_ctrl: 
> onoff:0
> Mar 30 22:36:10 trubuntu kernel: [ 5512.977671] af9015_pid_filter_ctrl: 
> onoff:0
> ...
> I think I have "af9015_pid_filter_ctrl: onoff:0" when I run Kaffeine.
> 
> Here are some messages when I run then scan with Kaffeine :
> ..................................................
> 
> Not able to lock to the signal on the given frequency
> Frontend closed
> dvbsi: Cant tune DVB
> Using DVB device 0:0 "Afatech AF9013 DVB-T"
> tuning DVB-T to 522000000 Hz
> inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
> ...... LOCKED.
> Transponders: 15/57
> scanMode=0
> it's dvb 2!
> Reading SDT: pid=17
> CANAL+: sid=769
> CANAL+ CINEMA: sid=770
> CANAL+ SPORT: sid=771
> PLANETE: sid=772
> CANAL J: sid=773
> TPS STAR: sid=774
> Unknown: sid=1008
> Unknown: sid=1009
> Reading PAT: pid=0
> Reading PMT: pid=1280
> 
> DVB SUB on CANAL+ page_id: 1 anc_id: 2 lang: fra
> 
> Reading PMT: pid=1281
> 
> DVB SUB on CANAL+ CINEMA page_id: 1 anc_id: 2 lang: fra
> 
> Reading PMT: pid=1282
> 
> DVB SUB on CANAL+ SPORT page_id: 1 anc_id: 2 lang: fra
> 
> Reading PMT: pid=1283
> Reading PMT: pid=1284
> Reading PMT: pid=1285
> 
> DVB SUB on TPS STAR page_id: 1 anc_id: 2 lang: fra
> 
> Reading PMT: pid=1290
> Reading PMT: pid=1291
> Frontend closed
> Using DVB device 0:0 "Afatech AF9013 DVB-T"
> tuning DVB-T to 530000000 Hz
> inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
> ..................................................
> 
> Not able to lock to the signal on the given frequency
> Frontend closed
> dvbsi: Cant tune DVB
> Using DVB device 0:0 "Afatech AF9013 DVB-T"
> tuning DVB-T to 538000000 Hz
> inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
> ..................................................
> 
> Not able to lock to the signal on the given frequency
> Frontend closed
> dvbsi: Cant tune DVB
> Using DVB device 0:0 "Afatech AF9013 DVB-T"
> tuning DVB-T to 562000000 Hz
> inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
> ...... LOCKED.
> Transponders: 20/57
> scanMode=0
> it's dvb 2!
> Reading SDT: pid=17
> TF1: sid=1537
> NRJ12: sid=1538
> Eurosport: sid=1540
> LCI: sid=1539
> TMC: sid=1542
> TF6: sid=1541
> Reading PAT: pid=0
> Reading PMT: pid=100
> 
> DVB SUB on TF1 page_id: 1 anc_id: 0 lang: fra
> 
> 
> DVB SUB on TF1 page_id: 1 anc_id: 0 lang: eng
> 
> Reading PMT: pid=200
> 
> DVB SUB on NRJ12 page_id: 1 anc_id: 1 lang: fra
> 
> Reading PMT: pid=400
> Reading PMT: pid=300
> Reading PMT: pid=600
> 
> DVB SUB on TMC page_id: 1 anc_id: 0 lang: fra
> 
> 
> DVB SUB on TMC page_id: 1 anc_id: 0 lang: fra
> 
> Reading PMT: pid=500
> 
> DVB SUB on TF6 page_id: 1 anc_id: 0 lang: fra
> 
> Reading PMT: pid=8000
> Frontend closed
> Using DVB device 0:0 "Afatech AF9013 DVB-T"
> tuning DVB-T to 570000000 Hz
> inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
> ..................................................
> 
> Not able to lock to the signal on the given frequency
> Frontend closed
> dvbsi: Cant tune DVB
> Transponders: 57
> dvbsi: The end :)
> |ARTE HD|498000|v|0
> |PARIS PREMIERE|498000|v|0
> |CANAL+|522000|v|0
> |CANAL+ CINEMA|522000|v|0
> |CANAL+ SPORT|522000|v|0
> |PLANETE|522000|v|0
> |CANAL J|522000|v|0
> |TPS STAR|522000|v|0
> |Eurosport|562000|v|0
> |LCI|562000|v|0
> |TF6|562000|v|0
> Channels found: 11
> Saved epg data : 0 events (0 msecs)
> DCOP Cleaning up dead connections.
> 
> I hope this could help.
> 
> This work for me ! I can use my Volar Black ! Thank you for your 
> wonderful work !
> 
> I'll try http://linuxtv.org/hg/~anttip/af9015_aver_a850_2/ tomorrow and 
> tell you...
> 
> Regards,
> 
> Thomas
> 
> 
> Antti Palosaari a �crit :
> >
> > Olivier MENUEL wrote:
> >> Sorry,
> >> I was at work today.
> >>
> >> I just downloaded the latest version.
> >> It works a lot better than the previous one (the device_nums are 
> >> correct in the af9015.c and it seems the frontend is correctly 
> >> initialized now). Here is the /var/log/messages :
> >
> > Looks just correct!
> >
> >> I tried a scan with kaffeine : the blue light is on when scanning 
> >> (which is a pretty good news), but I can't find any channels : the 
> >> signal goes up to 85% but SNR stays at 0% and no channel is found ...
> >
> > hmm, not AverMedia A850 issue. I should look this later...
> >
> >> But I tried a scan with the scan command line and everything worked 
> >> fine !!!!!!!!!
> >> I found all channels and it seems to work really fine with vlc !!!
> >
> > :)
> >
> > Now I need some more tests. I can see from logs GPIO0 and GPIO1 are 
> > set differently.
> >
> > 1) reference design GPIOs:
> > If that works you don't need to test more.
> > http://linuxtv.org/hg/~anttip/af9015_aver_a850_2/
> >
> > 2) GPIO1 tuner
> > looks like tuner is connected to this GPIO
> > If that works no need to test more.
> > http://linuxtv.org/hg/~anttip/af9015_aver_a850_GPIO1/
> >
> > 3) GPIO0 tuner
> > last test if nothing before works
> > http://linuxtv.org/hg/~anttip/af9015_aver_a850_GPIO0/
> >
> > regards
> > Antti
> 
> 
