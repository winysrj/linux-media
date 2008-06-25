Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from xdsl-83-150-88-111.nebulazone.fi ([83.150.88.111]
	helo=ncircle.nullnet.fi) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tomimo@ncircle.nullnet.fi>) id 1KBQmn-0003t8-N9
	for linux-dvb@linuxtv.org; Wed, 25 Jun 2008 10:55:30 +0200
Message-ID: <50083.192.100.124.219.1214384122.squirrel@ncircle.nullnet.fi>
In-Reply-To: <20080622171752.GA896@dose.home.local>
References: <480F9062.6000700@free.fr>
	<16781.192.100.124.220.1209712634.squirrel@ncircle.nullnet.fi>
	<481B4A78.8090305@free.fr>
	<30354.192.100.124.220.1209969477.squirrel@ncircle.nullnet.fi>
	<481F66B0.4090302@free.fr> <4821F9A9.6030304@ncircle.nullnet.fi>
	<48236E1F.5080300@free.fr>
	<60450.192.168.9.10.1210618180.squirrel@ncircle.nullnet.fi>
	<Pine.LNX.4.64.0805122100590.7907@pub3.ifh.de>
	<20080616152430.GA9995@dose.home.local>
	<20080622171752.GA896@dose.home.local>
Date: Wed, 25 Jun 2008 11:55:22 +0300 (EEST)
From: "Tomi Orava" <tomimo@ncircle.nullnet.fi>
To: tino.keitel@tikei.de
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Testers wanted for alternative version of Terratec
 Cinergy T2 driver
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


Hi Tino,

> Today my keyboard was broken after a resume: most key presses got
> eaten. I unloaded the cinergy driver, removed the USB cable from the
> CinergyT2 and re-plugged it, which restored the keyboard.
>
> This never happened with module unload at suspend and reload at resume.

I'm not entirely confident that what you saw is related to the problem
I've seen in one particular type of motherboard-type, but here it
is anyway:

http://www.mail-archive.com/linux-usb-users@lists.sourceforge.net/msg19363.html

The usb disconnection problem I've had in the past happened only with
certain type of Asus motherboard (I've got 2 machines with the same hw) and
I never got those to work properly with this Terratec tuner (it did not
matter which driver, the original or the new one I tried).
Have you by any chance modified by any means your USB-device setup ?

By co-insidence I have setup a few days ago the old problematic machine
as a test machine for the Terratec cinergyT2 tuner box and I'm quite
interested to see if the problem still persists ---> this time I've
added an externally powered USB 2.0 hub into the setup in order to
make sure that there should be enough power available for the devices.

If your problem happens again, please try to get usb debug log in order
to see more clearly what's actually happening and if your problem
is more or less related to what I've seen.

Regards,
Tomi Orava

>
> Hereis the dmesg output after resume:
>
> dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in
> warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T
> Receiver)
> DVB: registering frontend 0 (TerraTec/qanu USB2.0 Highspeed DVB-T
> Receiver)...
> input: IR-receiver inside an USB DVB receiver as /class/input/input21
> dvb-usb: schedule remote query interval to 50 msecs.
> dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
> initialized and connected.
> usb 1-3: New USB device found, idVendor=0ccd, idProduct=0038
> usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 1-3: Product: Cinergy T<B2>
> usb 1-3: Manufacturer: TerraTec GmbH
> usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0
> ret -84
> usb 5-1: USB disconnect, address 15
> usb 5-1: new full speed USB device using uhci_hcd and address 16
> dvb-usb: recv bulk message failed: -75
> usb 5-1: configuration #1 chosen from 1 choice
> usb 5-1: New USB device found, idVendor=05ac, idProduct=8205
> usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> dvb-usb: bulk message failed: -110 (9/0)
> cinergyT2: cinergyt2_fe_set_frontend() Failed! err=-110
>
> dvb-usb: bulk message failed: -110 (1/0)
> dvb-usb: bulk message failed: -110 (1/0)
> dvb-usb: bulk message failed: -110 (1/0)
> dvb-usb: bulk message failed: -110 (1/0)
> dvb-usb: bulk message failed: -110 (9/0)
>
> Regards,
> Tino
>
>
> Regards,
> Tino
>


-- 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
