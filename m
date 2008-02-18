Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from planetmail5.outgw.tn ([193.95.28.40])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <serge.lavoie@laposte.net>) id 1JRFIa-0007SZ-6I
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 00:21:24 +0100
Received: from smtp1.planet.net.tn (unknown [193.95.123.25])
	by tounes-23.ati.tn (Postfix) with ESMTP id 0C9741D018A8
	for <linux-dvb@linuxtv.org>; Tue, 19 Feb 2008 00:21:19 +0100 (CET)
Received: from MailGateway.planettunisie.com ([193.95.123.22])
	by smtp1.planet.net.tn (Switch-3.1.8/Switch-3.1.7) with ESMTP id
	m1INLI6K002073
	for <linux-dvb@linuxtv.org>; Tue, 19 Feb 2008 00:21:18 +0100 (CET)
From: "serge.lavoie" <serge.lavoie@laposte.net>
To: linux-dvb@linuxtv.org
Date: Tue, 19 Feb 2008 00:21:13 +0100
Message-Id: <1203376873.4883.80.camel@tibook>
Mime-Version: 1.0
Subject: [linux-dvb] any solution to the endianness issue for ppc machines
	with	usb-skystar ?
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

After more than two years of waiting, i decided to retry the linux dvb
driver in order to use a dvb-s technisat skystar-USB box in my 667mhz
macintosh powerbook G4 running debian lenny kernel 2.6.22.

I obtained the latest v4l-dvb source code from linuxTV :
hg clone http://linuxtv.org/hg/v4l-dvb
cd v4l-dvb
make
make install

As usual all went fine. The flexcop modules loaded very well despite the
fact that my usb dvb-box still remain unusable.

A quick look to dmsg log show this :

usb 1-1: new full speed USB device using ohci_hcd and address 2
usb 1-1: device descriptor read/64, error -62
usb 1-1: device descriptor read/64, error -62
usb 1-1: new full speed USB device using ohci_hcd and address 3
PM: Adding info for usb:1-1
PM: Adding info for No Bus:usbdev1.3_ep00
usb 1-1: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-1:1.0
PM: Adding info for No Bus:usbdev1.3_ep81
PM: Adding info for No Bus:usbdev1.3
b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded
successfully
PM: Removing info for No Bus:usbdev1.3_ep81
PM: Adding info for No Bus:usbdev1.3_ep81
flexcop_usb: running at FULL speed.
b2c2-flexcop: unkown FlexCop Revision: 8. Please report the
linux-dvb@linuxtv.org.dvb-s technisat skystar-USB box
DVB: registering new adapter (FlexCop Digital TV device)
PM: Adding info for No Bus:dvb0.demux0
PM: Adding info for No Bus:dvb0.dvr0
PM: Adding info for No Bus:dvb0.net0
b2c2-flexcop: MAC address = 00:d0:d7:0c:b8:1c
PM: Adding info for No Bus:i2c-9
b2c2-flexcop: found the stv0299 at i2c address: 0x68
DVB: registering frontend 0 (ST STV0299 DVB-S)...
PM: Adding info for No Bus:dvb0.frontend0
b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2 DVB-S' at the 'USB'
bus controlled by a 'Unkown chip' complete
flexcop_usb: submitting urb 0 failed with -90.
PM: Removing info for No Bus:dvb0.frontend0
PM: Removing info for No Bus:i2c-9
PM: Removing info for No Bus:dvb0.net0
PM: Removing info for No Bus:dvb0.demux0
PM: Removing info for No Bus:dvb0.dvr0
b2c2_flexcop_usb: probe of 1-1:1.0 failed with error -90
usbcore: registered new interface driver b2c2_flexcop_usb

More than two year ago patrick.boettcher from this forum explained me
this is related to the endianness issue in ppc machines...apparently the
problem remain unsolved and nobody has wrote a driver taking into
account this particularity. So will they be in the future a serious
attempt to improve the flexcop driver in that sense ?

As far as i know, this endianness issue concern only the linux skystar
usb part of the driver not the pci one. And because this a common driver
for both hardware (pci & usb skystar2) then solving the problem for one
type of hardware could alter the usability of the other type. So a
"trade-off" was made.

I don't ask to rewrite the driver from scratch for the ppc community but
i wonder if someone can write a patch to overcome the issue after
applying it and recompiling the driver (surely not me i'm not a
developper only a hobbyist and it's beyond my modest capacities) so we
could watch tv on our beloved machines.

waiting to hearing from you. Best regards.

 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
