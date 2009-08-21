Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.partofus.org ([87.106.139.108]:38672 "EHLO
	srvopt.partofus.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbZHUTdy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 15:33:54 -0400
Received: from localhost (localhost [127.0.0.1])
	by srvopt.partofus.org (Postfix) with ESMTP id 786862CB6EAC3
	for <linux-media@vger.kernel.org>; Fri, 21 Aug 2009 21:23:45 +0200 (CEST)
Message-Id: <57650B0A-A9D1-4902-9F4F-B9A10BC2ED64@team-erdle.de>
From: Christoph Erdle <newsletter@team-erdle.de>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Driver for Mystique Satix-SX
Date: Fri, 21 Aug 2009 21:23:40 +0200
Cc: Christoph Erdle <newsletter@team-erdle.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
