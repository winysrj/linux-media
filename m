Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.aidsandchild.org ([195.134.143.66] helo=omega.omnis.ch)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <om-lists-linux@omx.ch>) id 1KmnDL-0007Yy-8x
	for linux-dvb@linuxtv.org; Mon, 06 Oct 2008 12:21:20 +0200
From: Olivier Mueller <om-lists-linux@omx.ch>
To: linux-dvb@linuxtv.org
Date: Mon, 06 Oct 2008 12:21:08 +0200
Message-Id: <1223288468.4776.42.camel@frosch.local>
Mime-Version: 1.0
Subject: [linux-dvb] Miglia Eyetv Hybrid 2008?
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

Hello,

First of all, many thanks for your work: when I plugged a good old
miglia TvMini in a test setup of opensuse 11.0 a few days ago, it worked
"out of the box", impressive. 

Then I hoped it would be the same for a brand new "Elgato EyeTV
Hybrid" (dvb-T + analog,
http://www.elgato.com/elgato/int/mainmenu/products/tuner/hybrid08/product1.en.html ), but no reaction in dmesg there, even after some testing with v4l-dvb-experimental: I guess the device is simply too new, and not compatible with the HVR-950 like told in some forum posts
(it may be the case for the older eyetv hybrid usb device from last
year).
 
Just in case, here the information told under OS X's Eyetv.app: 

Microcode version: 1.00
Model: EU 2008
Serial Number: 080604007023
USB Controller:  Empia EM2884
Stereo A/V Decoder:  Micronas AVF 49x0B
Hybrid Channel Decoder:  Micronas DRX-K DRX3926K:A1 0.8.0


And it looks like this in /var/log/messages (suse 11.0) :

Oct  3 15:16:24 kernel: usb 5-2: new high speed USB device using
ehci_hcd and address 7
Oct  3 15:16:24 kernel: usb 5-2: configuration #1 chosen from 1 choice
Oct  3 15:16:24 kernel: usb 5-2: New USB device found, idVendor=0fd9,
idProduct=0018
Oct  3 15:16:24 kernel: usb 5-2: New USB device strings: Mfr=3,
Product=1, SerialNumber=2
Oct  3 15:16:24 kernel: usb 5-2: Product: EyeTV Hybrid
Oct  3 15:16:24 kernel: usb 5-2: Manufacturer: Elgato
Oct  3 15:16:24 kernel: usb 5-2: SerialNumber: 080604007023


I will continue my experiments, but if in the mean time you have
suggestions to make it work under linux as well, I'll be happy to read
them :)

regards,
Olivier


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
