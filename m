Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2-g19.free.fr ([212.27.42.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nboullis@tryphon.debian.net>) id 1JfmAq-0004x6-Ki
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 03:17:29 +0200
Received: from smtp2-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 0A24312B6AF
	for <linux-dvb@linuxtv.org>; Sun, 30 Mar 2008 03:17:24 +0200 (CEST)
Received: from tryphon.home (tryphon.debian.net [82.66.113.220])
	by smtp2-g19.free.fr (Postfix) with ESMTP id D8B5112B6AD
	for <linux-dvb@linuxtv.org>; Sun, 30 Mar 2008 03:17:23 +0200 (CEST)
Received: from localhost ([127.0.0.1]) by tryphon.home with esmtp (Exim 4.50)
	id 1JfmAl-0004UP-H1
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 03:17:23 +0200
Received: from tryphon.home ([127.0.0.1])
	by localhost (tryphon [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 05956-09 for <linux-dvb@linuxtv.org>;
	Sun, 30 Mar 2008 03:17:23 +0200 (CEST)
Received: from irma.home ([192.168.18.8] ident=Debian-exim)
	by tryphon.home with esmtp (Exim 4.50) id 1JfmAl-0004UK-6u
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 03:17:23 +0200
Received: from nboullis by irma.home with local (Exim 4.63)
	(envelope-from <nboullis@tryphon.debian.net>) id 1JfmAX-0001Q7-0w
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 03:17:09 +0200
Date: Sun, 30 Mar 2008 03:17:08 +0200
From: Nicolas Boullis <nboullis@debian.org>
To: linux-dvb@linuxtv.org
Message-ID: <20080330011707.GC3978@tryphon.debian.net>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] corrupted EEPROM in USB-based DVB-T device
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

Hi,

I have a ADS Tech Instant TV DVB-T USB device that suddenly stopped 
working when I plugged it in. After that, it was recognized as a 
"Cypress Semiconductor Corp. CY76803 EZ-USB FX2 USB 2.0 Development Kit"

Googling around the internat, I found out that it might be related to a 
corrupted on-board EEPROM chip.

Since I have a second such device, and know some electronics, I first 
thought I would unsolder open the box, unsolder the EEPROM chips, and 
the copy the good one on the corrupted one. But such hardware hacking is 
somewhat dangerous for my devices...

Then I realized that the firmware and the driver give me access to the 
I2C bus, where the EEPROM is connected. So it should be possible to do 
all this with no hardware hacking.

The first step was to hack dibusb-mb.c so that my device was identified 
as a cold "KWorld/ADSTech Instant DVB-T USB2.0" device, just like it can 
be done for "Artec T1 USB1.1 TVBOX with AN2235 (faulty USB IDs)".

But then I figured out that I still was unsuccessfull when trying to 
access the EEPROM. With an oscilloscope, I figured out that the I2C bus 
was running at 400kHz, while the EEPROM chip only supports 100kHz...

Fortunately, I could easily hack the dvb-usb-adstech-usb2-02.fw firmware 
to make the I2C bus run at 100kHz. Thinking about this, the EEPROM chip 
might be confused by the 400kHz data that it does not understand. I 
guess my EEPROM might have been corrupted because of this.

Then I could read (not that easily, unfortunately) the EEPROM on both 
the sane device and the damaged device.
The sane one starts with: C0 E1 06 33 A3 01 00
The damaged one with:     00 00 00 FF FF FF FF
(there are a few other differences, but I'm not sure what they affect, 
and may rightfully be related to one device being older that the other.)

I fixed the first 7 bytes of the damaged EEPROM, copying the first 7 
bytes of the sane one. Now, my device works fine again, with an 
unpatched driver.


Out of this experience, I think that you should patch the 
dvb-usb-adstech-usb2-02.fw firmware that you distribute, as it might 
break some devices, by corrupting the EEPROM chip.

I also guess that "Artec T1 USB1.1 TVBOX with AN2235 (faulty USB IDs)" 
could be fixed, regrogramming their EEPROM chips, just like I fixed my 
device (unless they lack an EEPROM chip).


I can provide more information to interested people.


Cheers,

Nicolas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
