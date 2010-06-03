Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail138.messagelabs.com ([216.82.249.35]:2541 "EHLO
	mail138.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947Ab0FCArq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jun 2010 20:47:46 -0400
Received: from isdc1n1.macbank
	by mailsvc.macquarie.com with ESMTP id o530lgjZ020729
	for <linux-media@vger.kernel.org>; Thu, 3 Jun 2010 10:47:42 +1000 (EST)
Received: from [10.240.16.127] ([10.240.16.127])
	by isdc1n1.macbank (8.11.7+Sun/8.11.7) with ESMTP id o530lf119048
	for <linux-media@vger.kernel.org>; Thu, 3 Jun 2010 10:47:41 +1000 (EST)
Message-ID: <4C06FBAD.60304@macquarie.com>
Date: Thu, 03 Jun 2010 10:47:41 +1000
From: Martin Brown <martin.brown@macquarie.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: DNTV Dual Hybrid (7164) PCIe
References: <370023.77962.qm@web113202.mail.gq1.yahoo.com>
In-Reply-To: <370023.77962.qm@web113202.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to get a driver working for this card under Ubuntu Lucid (10.04).

I believe the card is based on the SAA7164 so I'm trying the kernellabs 
driver.

Results of modprobe saa7164 are:

/etc/modprobe.d/options.conf contains:
options saa7164 card=4


kernel: [ 159.091047] saa7164 driver loaded
kernel: [ 159.091102] saa7164 0000:04:00.0: PCI INT A -> GSI 18 (level, 
low) -> IRQ 18
kernel: [ 159.091974] CORE saa7164[0]: subsystem: 107d:6f2c, board: 
Hauppauge WinTV-HVR2200 [card=4,insmod option]
kernel: [ 159.091980] saa7164[0]/0: found at 0000:04:00.0, rev: 129, 
irq: 18, latency: 0, mmio: 0x93000000
kernel: [ 159.135163] tveeprom 0-0000: Encountered bad packet header 
[00]. Corrupt or not a Hauppauge eeprom.
kernel: [ 159.135168] saa7164[0]: Hauppauge eeprom: model=0

That's it. Nothing more. No /dev/dvb/adpator... created.

When /etc/modprobe.conf has:
options saa7164 card=5 I get:

kernel: [ 547.123384] saa7164 driver loaded
kernel: [ 547.123435] saa7164 0000:04:00.0: PCI INT A -> GSI 18 (level, 
low) -> IRQ 18
kernel: [ 547.123614] CORE saa7164[0]: subsystem: 107d:6f2c, board: 
Hauppauge WinTV-HVR2200 [card=5,insmod option]
kernel: [ 547.123619] saa7164[0]/0: found at 0000:04:00.0, rev: 129, 
irq: 18, latency: 0, mmio: 0x93000000
kernel: [ 547.160228] tveeprom 0-0000: Encountered bad packet header 
[ff]. Corrupt or not a Hauppauge eeprom.
kernel: [ 547.160233] saa7164[0]: Hauppauge eeprom: model=0
kernel: [ 547.207655] tda18271 1-0060: creating new instance
kernel: [ 547.211800] TDA18271HD/C2 detected @ 1-0060
kernel: [ 547.469221] DVB: registering new adapter (saa7164)
kernel: [ 547.469226] DVB: registering adapter 2 frontend 0 (NXP 
TDA10048HN DVB-T)...

But only one /dev/dvb/adaptor created instead of 2 and I suspect the 
tveeprom error is fatal.

Does anyone have any suggestions?

Thanks,
Martin
