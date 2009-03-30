Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:41128 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760148AbZC3TjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 15:39:25 -0400
From: Olivier MENUEL <omenuel@laposte.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: AverMedia Volar Black HD (A850)
Date: Mon, 30 Mar 2009 21:39:09 +0200
Cc: Laurent Haond <lhaond@bearstech.com>, linux-media@vger.kernel.org,
	Thomas RENARD <threnard@gmail.com>,
	Karsten Blumenau <info@blume-online.de>,
	pHilipp Zabel <philipp.zabel@gmail.com>,
	Martin =?iso-8859-1?q?M=FCller?= <mueller1977@web.de>
References: <200903291334.00879.olivier.menuel@free.fr> <200903292015.49152.omenuel@laposte.net> <49D11189.1010705@iki.fi>
In-Reply-To: <49D11189.1010705@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903302139.09809.omenuel@laposte.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Sorry,
I was at work today.

I just downloaded the latest version.
It works a lot better than the previous one (the device_nums are correct in the af9015.c and it seems the frontend is correctly initialized now). Here is the /var/log/messages :

Mar 30 21:30:26 blastor kernel: [ 2829.680263] usb 5-4.4: new high speed USB device using ehci_hcd and address 11
Mar 30 21:30:26 blastor kernel: [ 2829.776572] usb 5-4.4: configuration #1 chosen from 1 choice
Mar 30 21:30:26 blastor kernel: [ 2829.777269] af9015_usb_probe: interface:0
Mar 30 21:30:26 blastor kernel: [ 2829.781867] af9015_read_config: IR mode:0
Mar 30 21:30:26 blastor kernel: [ 2829.786071] af9015_read_config: TS mode:1
Mar 30 21:30:26 blastor kernel: [ 2829.804042] af9015_read_config: [0] xtal:2 set adc_clock:28000
Mar 30 21:30:26 blastor kernel: [ 2829.806990] af9015_read_config: [0] IF1:36125
Mar 30 21:30:26 blastor kernel: [ 2829.809859] af9015_read_config: [0] MT2060 IF1:0
Mar 30 21:30:26 blastor kernel: [ 2829.811355] af9015_read_config: [0] tuner id:13
Mar 30 21:30:26 blastor kernel: [ 2829.812861] af9015_read_config: [1] xtal:2 set adc_clock:28000
Mar 30 21:30:26 blastor kernel: [ 2829.815734] af9015_read_config: [1] IF1:36125
Mar 30 21:30:26 blastor kernel: [ 2829.818731] af9015_read_config: [1] MT2060 IF1:1220
Mar 30 21:30:26 blastor kernel: [ 2829.820234] af9015_read_config: [1] tuner id:130
Mar 30 21:30:26 blastor kernel: [ 2829.820239] af9015_read_config: ugly and broken AverMedia A850 device detected, will hack configuration...
Mar 30 21:30:26 blastor kernel: [ 2829.820611] af9015_identify_state: reply:01
Mar 30 21:30:26 blastor kernel: [ 2829.820616] dvb-usb: found a 'AVerMedia A850' in cold state, will try to load a firmware
Mar 30 21:30:26 blastor kernel: [ 2829.820619] firmware: requesting dvb-usb-af9015.fw
Mar 30 21:30:26 blastor kernel: [ 2829.839678] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
Mar 30 21:30:26 blastor kernel: [ 2829.839686] af9015_download_firmware:
Mar 30 21:30:26 blastor kernel: [ 2829.927037] dvb-usb: found a 'AVerMedia A850' in warm state.
Mar 30 21:30:26 blastor kernel: [ 2829.927130] i2c-adapter i2c-5: SMBus Quick command not supported, can't probe for chips
Mar 30 21:30:26 blastor kernel: [ 2829.927139] i2c-adapter i2c-5: SMBus Quick command not supported, can't probe for chips
Mar 30 21:30:26 blastor kernel: [ 2829.927152] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Mar 30 21:30:26 blastor kernel: [ 2829.929261] DVB: registering new adapter (AVerMedia A850)
Mar 30 21:30:26 blastor kernel: [ 2829.929635] af9015_af9013_frontend_attach: init I2C
Mar 30 21:30:26 blastor kernel: [ 2829.929638] af9015_i2c_init:
Mar 30 21:30:26 blastor kernel: [ 2829.929676] i2c-adapter i2c-6: SMBus Quick command not supported, can't probe for chips
Mar 30 21:30:26 blastor kernel: [ 2829.929686] i2c-adapter i2c-6: SMBus Quick command not supported, can't probe for chips
Mar 30 21:30:26 blastor kernel: [ 2829.964978] 00: 2c 8f a3 0b 00 00 00 00 ca 07 0a 85 01 01 01 02
Mar 30 21:30:26 blastor kernel: [ 2829.988831] 10: 03 80 00 fa fa 10 40 ef 00 30 31 30 31 30 37 30
Mar 30 21:30:26 blastor kernel: [ 2830.012576] 20: 33 30 37 30 30 30 30 31 ff ff ff ff ff ff ff ff
Mar 30 21:30:26 blastor kernel: [ 2830.036627] 30: 01 01 38 01 00 08 02 01 1d 8d 00 00 0d ff ff ff
Mar 30 21:30:26 blastor kernel: [ 2830.060015] 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
Mar 30 21:30:26 blastor kernel: [ 2830.083685] 50: ff ff ff ff ff 26 00 00 04 03 09 04 14 03 41 00
Mar 30 21:30:26 blastor kernel: [ 2830.107431] 60: 56 00 65 00 72 00 4d 00 65 00 64 00 69 00 61 00
Mar 30 21:30:26 blastor kernel: [ 2830.131178] 70: 14 03 41 00 38 00 35 00 30 00 20 00 44 00 56 00
Mar 30 21:30:26 blastor kernel: [ 2830.155049] 80: 42 00 54 00 20 03 33 00 30 00 31 00 34 00 37 00
Mar 30 21:30:26 blastor kernel: [ 2830.179420] 90: 35 00 34 00 30 00 30 00 37 00 33 00 36 00 30 00
Mar 30 21:30:26 blastor kernel: [ 2830.203166] a0: 30 00 30 00 00 ff ff ff ff ff ff ff ff ff ff ff
Mar 30 21:30:26 blastor kernel: [ 2830.227038] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 30 21:30:26 blastor kernel: [ 2830.250412] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 30 21:30:26 blastor kernel: [ 2830.274282] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 30 21:30:26 blastor kernel: [ 2830.297904] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 30 21:30:26 blastor kernel: [ 2830.321900] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 30 21:30:26 blastor kernel: [ 2830.324902] af9013: firmware version:4.95.0
Mar 30 21:30:26 blastor kernel: [ 2830.330900] DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
Mar 30 21:30:26 blastor kernel: [ 2830.330957] af9015_tuner_attach:
Mar 30 21:30:26 blastor kernel: [ 2830.331167] MXL5005S: Attached at address 0xc6
Mar 30 21:30:26 blastor kernel: [ 2830.331172] dvb-usb: AVerMedia A850 successfully initialized and connected.
Mar 30 21:30:26 blastor kernel: [ 2830.331175] af9015_init:
Mar 30 21:30:26 blastor kernel: [ 2830.331177] af9015_init_endpoint: USB speed:3
Mar 30 21:30:26 blastor kernel: [ 2830.347269] af9015_download_ir_table:
Mar 30 21:30:26 blastor kernel: [ 2830.347487] usb 5-4.4: New USB device found, idVendor=07ca, idProduct=850a
Mar 30 21:30:26 blastor kernel: [ 2830.347490] usb 5-4.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Mar 30 21:30:26 blastor kernel: [ 2830.347493] usb 5-4.4: Product: A850 DVBT
Mar 30 21:30:26 blastor kernel: [ 2830.347495] usb 5-4.4: Manufacturer: AVerMedia
Mar 30 21:30:26 blastor kernel: [ 2830.347497] usb 5-4.4: SerialNumber: 301475400736000

I tried a scan with kaffeine : the blue light is on when scanning (which is a pretty good news), but I can't find any channels : the signal goes up to 85% but SNR stays at 0% and no channel is found ...
But I tried a scan with the scan command line and everything worked fine !!!!!!!!!
I found all channels and it seems to work really fine with vlc !!!

Thanks a lot !



Le lundi 30 mars 2009, Antti Palosaari a écrit :
> 
> hei,
> 
> Could someone please test this asap? I am still hoping I can get this 
> 2.6.30 and there is not too much time...
> http://linuxtv.org/hg/~anttip/af9015_aver_a850/
> 
> It must not be big issue anymore to get this working...
> 
> regards
> Antti
