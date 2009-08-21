Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.partofus.org ([87.106.139.108] helo=srvopt.partofus.org)
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <newsletter@team-erdle.de>) id 1MeZNB-000650-77
	for linux-dvb@linuxtv.org; Fri, 21 Aug 2009 21:02:01 +0200
Received: from localhost (localhost [127.0.0.1])
	by srvopt.partofus.org (Postfix) with ESMTP id EF6BA2CB6EAA3
	for <linux-dvb@linuxtv.org>; Fri, 21 Aug 2009 21:01:27 +0200 (CEST)
Message-Id: <B1DC5D7C-7607-4691-9A39-A88BA4DECDC4@team-erdle.de>
From: Christoph Erdle <newsletter@team-erdle.de>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v936)
Date: Fri, 21 Aug 2009 21:01:21 +0200
Subject: [linux-dvb] Driver for Mystique SaTix-SX
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi list,

I'm having problems getting a DVB-S card labeled "Mystique SaTix-SX"  
to run. According to the manufacturer (www.mystique-tv.de) all their  
cards are supported by the linux dvb drivers.

But I can't get this one to work.

lspci collected the following information about the card:

#lspci -nvv
[...]
01:09.0 Multimedia controller [0480]: Philips Semiconductors SAA7146  
[1131:7146] (rev 01)
	Subsystem: KNC One Device [1894:0054]
	Flags: bus master, medium devsel, latency 123, IRQ 11
	Memory at fc005800 (32-bit, non-prefetchable) [size=512]
[...]

So I think this means that the card is actually a clone of some card  
from KNC One (I think it's the TV Star DVB-S one).

A quick grep in the source delivered:

# grep -R "0x1894" *
drivers/media/dvb/ttpci/budget-av.c:		if (saa->pci->subsystem_vendor  
== 0x1894) {
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(knc1s, 0x1894,  
0x0010),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(knc1sp,  
0x1894, 0x0011),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(kncxs, 0x1894,  
0x0014),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(knc1spx4,  
0x1894, 0x0015),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(kncxs, 0x1894,  
0x0016),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(knc1s2,  
0x1894, 0x0018),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(knc1s2,  
0x1894, 0x0019),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(sates2,  
0x1894, 0x001d),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(satewpls,  
0x1894, 0x001e),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(satewpls1,  
0x1894, 0x001a),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(satewps,  
0x1894, 0x001b),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(satewplc,  
0x1894, 0x002a),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(satewcmk3,  
0x1894, 0x002c),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(satewt,  
0x1894, 0x003a),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(knc1c, 0x1894,  
0x0020),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(knc1cp,  
0x1894, 0x0021),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(knc1cmk3,  
0x1894, 0x0022),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(knc1cpmk3,  
0x1894, 0x0023),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(knc1t, 0x1894,  
0x0030),
drivers/media/dvb/ttpci/budget-av.c:	MAKE_EXTENSION_PCI(knc1tp,  
0x1894, 0x0031),
drivers/media/video/saa7134/saa7134-cards.c:		.subvendor    = 0x1894,
drivers/media/video/saa7134/saa7134-cards.c:		.subvendor    = 0x1894,

So it seems this card is not supported at the time as I don't see any  
SubID of 0x0054. How can I help to get this one supported?

Thanks for your help,
Chris
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Darwin)

iEYEARECAAYFAkqO7wIACgkQqqYbNmv9eYnaMACgg9SenBUdGy8DtvZIyG1+i5TU
rVgAn3PTbfxIFRgWQKRO2QzSsEY8VzHT
=FYci
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
