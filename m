Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n38.bullet.mail.ukl.yahoo.com ([87.248.110.171])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dirk_vornheder@yahoo.de>) id 1KjvB0-0007hZ-Mx
	for linux-dvb@linuxtv.org; Sun, 28 Sep 2008 14:15:05 +0200
From: Dirk Vornheder <dirk_vornheder@yahoo.de>
To: "Antti Palosaari" <crope@iki.fi>,
 linux-dvb@linuxtv.org
Date: Sun, 28 Sep 2008 14:13:48 +0200
References: <200809152345.37786.dirk_vornheder@yahoo.de>
	<200809210904.28192.dirk_vornheder@yahoo.de>
	<39633.85.23.68.42.1222000546.squirrel@webmail.kapsi.fi>
	(sfid-20080921_171923_977954_A48793EA)
In-Reply-To: <39633.85.23.68.42.1222000546.squirrel@webmail.kapsi.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809281413.49474.dirk_vornheder@yahoo.de>
Subject: Re: [linux-dvb] UNS: Re:  New unspported device AVerMedia DVB-T
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


> > Sep 21 08:17:51 lappc kernel: dvb-usb: found a 'AVerMedia DVB-T' in cold
> > state, will try to load a firmware
> > Sep 21 08:17:51 lappc kernel: firmware: requesting dvb-usb-af9015.fw
> > Sep 21 08:17:51 lappc kernel: dvb-usb: downloading firmware from file
> > 'dvb-
> > usb-af9015.fw'
> > Sep 21 08:17:51 lappc kernel: usbcore: registered new interface driver
> > dvb_usb_af9015
> >
> > But i found no device entries in /dev/dvb.
> >
> > Dirk
>
> Markus Ranne reported this working, see couple of mails back on the list.
>
> But anyhow, looks like you has problem that firmware does not run.
> Re-download and install firmware. Hopefully it helps.
>

After download, compile with option CONFIG_DVB_USB_DEBUG=y and install latest 

v4l-dvb sources the device only works if i add option

options dvb_usb_af9015 debug=3

to /etc/modprobe.conf.local and load module dvb-usb-af9015

with option debug=3 !

Some messages after loading the module:

Sep 28 08:38:02 lappc kernel: af9015_usb_probe: interface:0
Sep 28 08:38:02 lappc kernel: af9015_read_config: IR mode:0
Sep 28 08:38:02 lappc kernel: af9015_read_config: TS mode:0
Sep 28 08:38:02 lappc kernel: af9015_read_config: [0] xtal:2 set 
adc_clock:28000
Sep 28 08:38:02 lappc kernel: af9015_read_config: [0] IF1:4570
Sep 28 08:38:02 lappc kernel: af9015_read_config: [0] MT2060 IF1:0
Sep 28 08:38:02 lappc kernel: af9015_read_config: [0] tuner id:13
Sep 28 08:38:02 lappc kernel: af9015_identify_state: reply:02
Sep 28 08:38:02 lappc kernel: dvb-usb: found a 'AVerMedia A309' in warm state.
Sep 28 08:38:02 lappc kernel: dvb-usb: will pass the complete MPEG2 transport 
stream to the software demuxer.
Sep 28 08:38:02 lappc kernel: DVB: registering new adapter (AVerMedia A309)
Sep 28 08:38:02 lappc kernel: af9015_af9013_frontend_attach: init I2C
Sep 28 08:38:02 lappc kernel: af9015_i2c_init:
Sep 28 08:38:02 lappc kernel: 00: 2b 7a 99 0b 00 00 00 00 ca 07 09 a3 00 02 01 
02 
Sep 28 08:38:03 lappc kernel: 10: 03 80 00 fa fa 10 40 ef 00 30 31 30 31 31 32 
30 
Sep 28 08:38:03 lappc kernel: 20: 34 30 36 30 30 30 30 31 ff ff ff ff ff ff ff 
ff 
Sep 28 08:38:03 lappc kernel: 30: 01 00 3a 01 00 08 02 00 da 11 00 00 0d ff ff 
ff 
Sep 28 08:38:03 lappc kernel: 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff 
ff 
Sep 28 08:38:03 lappc kernel: 50: ff ff ff ff ff 24 00 00 04 03 09 04 14 03 41 
00 
Sep 28 08:38:03 lappc kernel: 60: 56 00 65 00 72 00 4d 00 65 00 64 00 69 00 61 
00 
Sep 28 08:38:03 lappc kernel: 70: 0a 03 41 00 33 00 30 00 39 00 20 03 33 00 30 
00 
Sep 28 08:38:03 lappc kernel: 80: 30 00 39 00 33 00 38 00 34 00 30 00 35 00 30 
00 
Sep 28 08:38:03 lappc kernel: 90: 30 00 30 00 30 00 30 00 30 00 00 ff ff ff ff 
ff 
Sep 28 08:38:03 lappc kernel: a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff 
Sep 28 08:38:03 lappc kernel: b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff 
Sep 28 08:38:03 lappc kernel: c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff 
Sep 28 08:38:03 lappc kernel: d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff 
Sep 28 08:38:03 lappc kernel: e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff 
Sep 28 08:38:03 lappc kernel: f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff 
Sep 28 08:38:03 lappc kernel: af9013: firmware version:4.95.0
Sep 28 08:38:03 lappc kernel: DVB: registering frontend 0 (Afatech AF9013 DVB-
T)...
Sep 28 08:38:03 lappc kernel: af9015_tuner_attach: 
Sep 28 08:38:03 lappc kernel: MXL5005S: Attached at address 0xc6
Sep 28 08:38:03 lappc kernel: dvb-usb: AVerMedia A309 successfully initialized 
and connected.
Sep 28 08:38:03 lappc kernel: af9015_init:
Sep 28 08:38:03 lappc kernel: af9015_init_endpoint: USB speed:3
Sep 28 08:38:03 lappc kernel: af9015_download_ir_table:
Sep 28 08:38:03 lappc kernel: usbcore: registered new interface driver 
dvb_usb_af9015

The device now works with vdr.

Dirk


		
___________________________________________________________ 
Telefonate ohne weitere Kosten vom PC zum PC: http://messenger.yahoo.de


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
