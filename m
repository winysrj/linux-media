Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]
	helo=ctsmtpout2.frontal.correo)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jareguero@telefonica.net>) id 1KOauR-0006MI-1q
	for linux-dvb@linuxtv.org; Thu, 31 Jul 2008 18:21:48 +0200
Received: from jar.dominio (80.25.230.35) by ctsmtpout2.frontal.correo
	(7.2.056.6) (authenticated as jareguero$telefonica.net)
	id 48916FE0000CF117 for linux-dvb@linuxtv.org;
	Thu, 31 Jul 2008 18:21:11 +0200
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-dvb@linuxtv.org
Date: Thu, 31 Jul 2008 18:21:08 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_1ZekI8uiSdLbUzD"
Message-Id: <200807311821.09325.jareguero@telefonica.net>
Subject: [linux-dvb] Problem with avermedia Volar X and af9015 driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_1ZekI8uiSdLbUzD
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have a Avermedia Volar X and when using 
http://linuxtv.org/hg/~anttip/af9015-mxl500x/
And add the pids as sugested in the list
http://www.linuxtv.org/pipermail/linux-dvb/2008-June/026834.html
log2
I can tune all channels and have a good reception.But if I use
http://linuxtv.org/hg/~anttip/af9015/
log1
I can't tune to some transponders.
Can I help to improve the reception with the new driver?

Thanks.
Jose Alberto







--Boundary-00=_1ZekI8uiSdLbUzD
Content-Type: text/plain;
  charset="us-ascii";
  name="log1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log1"

Jul 29 10:23:21 jar kernel: af9015_usb_probe: interface:0
Jul 29 10:23:21 jar kernel: af9015_read_config: IR mode:1
Jul 29 10:23:21 jar kernel: af9015_read_config: TS mode:0
Jul 29 10:23:21 jar kernel: af9015_read_config: [0] xtal:2 set adc_clock:28000
Jul 29 10:23:21 jar kernel: af9015_read_config: [0] IF1:4570
Jul 29 10:23:21 jar kernel: af9015_read_config: [0] MT2060 IF1:0
Jul 29 10:23:21 jar kernel: af9015_read_config: [0] tuner id:13
Jul 29 10:23:21 jar kernel: af9015_identify_state: reply:02
Jul 29 10:23:21 jar kernel: dvb-usb: found a 'AVerMedia AVerTV DVB-T Volar X' in warm state.
Jul 29 10:23:21 jar kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Jul 29 10:23:21 jar kernel: DVB: registering new adapter (AVerMedia AVerTV DVB-T Volar X)
Jul 29 10:23:21 jar kernel: af9015_af9013_frontend_attach: init I2C
Jul 29 10:23:21 jar kernel: af9015_i2c_init:
Jul 29 10:23:21 jar kernel: 00: 2b 99 99 0b 00 00 00 00 ca 07 15 a8 00 02 01 02 
Jul 29 10:23:21 jar kernel: 10: 03 80 00 fa fa 10 40 ef 01 30 31 30 31 31 31 30 
Jul 29 10:23:21 jar kernel: 20: 31 30 36 30 30 30 30 31 ff ff ff ff ff ff ff ff 
Jul 29 10:23:21 jar kernel: 30: 00 00 3a 01 00 08 02 00 da 11 00 00 0d ff ff ff 
Jul 29 10:23:21 jar kernel: 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff 
Jul 29 10:23:21 jar kernel: 50: ff ff ff ff ff 24 00 00 04 03 09 04 14 03 41 00 
Jul 29 10:23:21 jar kernel: 60: 56 00 65 00 72 00 4d 00 65 00 64 00 69 00 61 00 
Jul 29 10:23:21 jar kernel: 70: 0a 03 41 00 38 00 31 00 35 00 20 03 33 00 30 00 
Jul 29 10:23:22 jar kernel: 80: 30 00 38 00 35 00 36 00 32 00 30 00 32 00 38 00 
Jul 29 10:23:22 jar kernel: 90: 38 00 36 00 30 00 30 00 30 00 00 ff ff ff ff ff 
Jul 29 10:23:22 jar kernel: a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
Jul 29 10:23:22 jar kernel: b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
Jul 29 10:23:22 jar kernel: c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
Jul 29 10:23:22 jar kernel: d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
Jul 29 10:23:22 jar kernel: e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
Jul 29 10:23:22 jar kernel: f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
Jul 29 10:23:22 jar kernel: af9013: chip version:1 ROM version:1.0
Jul 29 10:23:22 jar kernel: af9013: firmware version:4.95.0
Jul 29 10:23:22 jar kernel: DVB: registering frontend 2 (Afatech AF9013 DVB-T)...
Jul 29 10:23:22 jar kernel: af9015_tuner_attach: 
Jul 29 10:23:22 jar kernel: MXL5005S: Attached at address 0xc6
Jul 29 10:23:22 jar kernel: dvb-usb: AVerMedia AVerTV DVB-T Volar X successfully initialized and connected.
Jul 29 10:23:22 jar kernel: af9015_init:
Jul 29 10:23:22 jar kernel: af9015_init_endpoint: USB speed:3
Jul 29 10:23:22 jar kernel: af9015_download_ir_table:
Jul 29 10:23:22 jar kernel: input: AVerMedia A815 as /devices/pci0000:00/0000:00:10.4/usb1/1-3/1-3:1.1/input/input8
Jul 29 10:23:22 jar kernel: input,hidraw2: USB HID v1.01 Keyboard [AVerMedia A815] on usb-0000:00:10.4-3

--Boundary-00=_1ZekI8uiSdLbUzD
Content-Type: text/plain;
  charset="us-ascii";
  name="log2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log2"

Jul 31 15:46:33 jar kernel: af9015_usb_probe: interface:0
Jul 31 15:46:33 jar kernel: af9015_identify_state: reply:02
Jul 31 15:46:33 jar kernel: dvb-usb: found a ' AverMedia DVB-T Volar X' in warm state.
Jul 31 15:46:33 jar kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Jul 31 15:46:33 jar kernel: DVB: registering new adapter ( AverMedia DVB-T Volar X)
Jul 31 15:46:33 jar kernel: af9015_eeprom_dump:
Jul 31 15:46:33 jar kernel: 00: 2b 99 99 0b 00 00 00 00 ca 07 15 a8 00 02 01 02 
Jul 31 15:46:33 jar kernel: 10: 03 80 00 fa fa 10 40 ef 01 30 31 30 31 31 31 30 
Jul 31 15:46:33 jar kernel: 20: 31 30 36 30 30 30 30 31 ff ff ff ff ff ff ff ff 
Jul 31 15:46:33 jar kernel: 30: 00 00 3a 01 00 08 02 00 da 11 00 00 0d ff ff ff 
Jul 31 15:46:33 jar kernel: 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff 
Jul 31 15:46:33 jar kernel: 50: ff ff ff ff ff 24 00 00 04 03 09 04 14 03 41 00 
Jul 31 15:46:33 jar kernel: 60: 56 00 65 00 72 00 4d 00 65 00 64 00 69 00 61 00 
Jul 31 15:46:33 jar kernel: 70: 0a 03 41 00 38 00 31 00 35 00 20 03 33 00 30 00 
Jul 31 15:46:33 jar kernel: 80: 30 00 38 00 35 00 36 00 32 00 30 00 32 00 38 00 
Jul 31 15:46:33 jar kernel: 90: 38 00 36 00 30 00 30 00 30 00 00 ff ff ff ff ff 
Jul 31 15:46:33 jar kernel: a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
Jul 31 15:46:33 jar kernel: b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
Jul 31 15:46:33 jar kernel: c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
Jul 31 15:46:33 jar kernel: d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
Jul 31 15:46:33 jar kernel: e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
Jul 31 15:46:33 jar kernel: f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
Jul 31 15:46:33 jar kernel: af9015_read_config: TS mode:0
Jul 31 15:46:33 jar kernel: af9015_read_config: xtal:2 set adc_clock:28000
Jul 31 15:46:33 jar kernel: af9015_read_config: IF1:4570
Jul 31 15:46:33 jar kernel: af9015_read_config: MT2060 IF1:0
Jul 31 15:46:33 jar kernel: af9015_read_config: tuner id1:13
Jul 31 15:46:33 jar kernel: af9015_read_config: spectral inversion:0
Jul 31 15:46:33 jar kernel: af9013: firmware version:4.95.0
Jul 31 15:46:33 jar kernel: DVB: registering frontend 2 (Afatech AF9013 DVB-T)...
Jul 31 15:46:33 jar kernel: af9015_tuner_attach: 
Jul 31 15:46:33 jar kernel: mxl500x_attach: Attaching ...
Jul 31 15:46:33 jar kernel: mxl500x_attach: MXL500x tuner succesfully attached
Jul 31 15:46:33 jar kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Jul 31 15:46:33 jar kernel: DVB: registering new adapter ( AverMedia DVB-T Volar X)
Jul 31 15:46:33 jar kernel: dvb-usb: no frontend was attached by ' AverMedia DVB-T Volar X'
Jul 31 15:46:33 jar kernel: dvb-usb:  AverMedia DVB-T Volar X successfully initialized and connected.
Jul 31 15:46:33 jar kernel: af9015_init:
Jul 31 15:46:33 jar kernel: af9015_init_endpoint: USB speed:3
Jul 31 15:46:33 jar kernel: af9015_download_ir_table:
Jul 31 15:46:33 jar kernel: input: AVerMedia A815 as /devices/pci0000:00/0000:00:10.4/usb1/1-8/1-8:1.1/input/input8

--Boundary-00=_1ZekI8uiSdLbUzD
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_1ZekI8uiSdLbUzD--
