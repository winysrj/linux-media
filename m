Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52008 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab1KQQfF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 11:35:05 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1RR4vY-0003qs-9k
	for linux-media@vger.kernel.org; Thu, 17 Nov 2011 17:35:04 +0100
Received: from p5491abec.dip.t-dialin.net ([84.145.171.236])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 17:35:04 +0100
Received: from sebastian.steinhuber by p5491abec.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 17:35:04 +0100
To: linux-media@vger.kernel.org
From: Sebastian Steinhuber <sebastian.steinhuber@googlemail.com>
Subject: Regression with kernel 3.1 and bt87x?
Date: Thu, 17 Nov 2011 17:29:33 +0100
Message-ID: <ja3cpe$6qm$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've got a Hauppauge WinTV pci board that used to be working until
kernel 3.1 was used; I tried 3.1.1, too, without luck. 3.0.7 is working,
with the same config as the 3.1s regarding the media parts.

I'm compiling my customized kernel from vanilla sources and a
linux-vserver patch, and I also tested the 3.1.0-1-amd64 from debian
stock with very result.


On starting up Zapping, I got these messages:
'Unable to open /dev/video0.'
'The device cannot be attached to any controller.'
Tvtime simply complained about 'No signal'.

I couldn't find further messages or any errors in syslog nor in
messages, so I'm feeling there might be a bug somewhere.


The same modules are loaded into the kernel with 3.0.7 (working, with
the same config as the 3.1s regarding the media parts), 3.1 and also 3.1.1:
bttv
btcx_risc
rc_core
tuner
tuner_simple
tuner_types
videobuf_dma_sg
videobuf_core
tveeprom


$lspci -vv
…
05:00.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 02)
	Subsystem: Hauppauge computer works Inc. WinTV Series
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (4000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d0001000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: bttv

05:00.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture
(rev 02)
	Subsystem: Hauppauge computer works Inc. WinTV Series
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (1000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: Bt87x


Thanks in advance.
Best,

Sebastian Steinhuber

