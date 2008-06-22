Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from eazy.amigager.de ([213.239.192.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tino@tikei.de>) id 1KATBW-0003v4-8S
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 19:17:04 +0200
Date: Sun, 22 Jun 2008 19:17:52 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080622171752.GA896@dose.home.local>
References: <480F9062.6000700@free.fr>
	<16781.192.100.124.220.1209712634.squirrel@ncircle.nullnet.fi>
	<481B4A78.8090305@free.fr>
	<30354.192.100.124.220.1209969477.squirrel@ncircle.nullnet.fi>
	<481F66B0.4090302@free.fr> <4821F9A9.6030304@ncircle.nullnet.fi>
	<48236E1F.5080300@free.fr>
	<60450.192.168.9.10.1210618180.squirrel@ncircle.nullnet.fi>
	<Pine.LNX.4.64.0805122100590.7907@pub3.ifh.de>
	<20080616152430.GA9995@dose.home.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080616152430.GA9995@dose.home.local>
Subject: Re: [linux-dvb] Testers wanted for alternative version of
	Terratec	Cinergy T2 driver
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

On Mon, Jun 16, 2008 at 17:24:30 +0200, Tino Keitel wrote:
> On Mon, May 12, 2008 at 21:05:40 +0200, Patrick Boettcher wrote:
> 
> [...]
> 
> > Trent Piepo was suggesting a solution, but no one ever had time to solve 
> > this problem. In fast this is only a propblem for developers, not so much 
> > for the average users as he is not unloading the module usually.
> 
> I unload the module at each suspend and reload it at resume. I did this
> with the old driver, because it was not suspend-proof, and I think I
> continued to do so because I had suspend/resume problems with the new
> driver.
> 
> I'll re-check if the current driver still causes problems with suspend.

Today my keyboard was broken after a resume: most key presses got
eaten. I unloaded the cinergy driver, removed the USB cable from the
CinergyT2 and re-plugged it, which restored the keyboard.

This never happened with module unload at suspend and reload at resume.

Hereis the dmesg output after resume:

dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in
warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T
Receiver)
DVB: registering frontend 0 (TerraTec/qanu USB2.0 Highspeed DVB-T
Receiver)...
input: IR-receiver inside an USB DVB receiver as /class/input/input21
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
initialized and connected.
usb 1-3: New USB device found, idVendor=0ccd, idProduct=0038
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-3: Product: Cinergy T<B2>
usb 1-3: Manufacturer: TerraTec GmbH
usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0
ret -84
usb 5-1: USB disconnect, address 15
usb 5-1: new full speed USB device using uhci_hcd and address 16
dvb-usb: recv bulk message failed: -75
usb 5-1: configuration #1 chosen from 1 choice
usb 5-1: New USB device found, idVendor=05ac, idProduct=8205
usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
dvb-usb: bulk message failed: -110 (9/0)
cinergyT2: cinergyt2_fe_set_frontend() Failed! err=-110

dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (9/0)

Regards,
Tino


Regards,
Tino

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
