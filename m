Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout09.t-online.de ([194.25.134.84]:59041 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab0HHP5s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Aug 2010 11:57:48 -0400
Date: Sun, 8 Aug 2010 17:40:28 +0200
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-media@vger.kernel.org
Subject: knc1 dvb-c card frequently looses CAM when switching channels
 quickly
Message-ID: <20100808154028.GA30216@gentoo.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I have experienced the following on my vdr machine:

When changing channels quickly between encrypted channels, the card
loosses cam and I get the following in my /var/log/messages:


[   67.645354] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[   84.659047] budget-av: cam inserted A
[   85.656855] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[60706.931218] budget-av: cam inserted A
[60707.485891] dvb_ca adapter 0: DVB CAM detected and initialised
successfully


lspci -vvv

03:00.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: KNC One Device 0022
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (3750ns min, 9500ns max)
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at f9fffc00 (32-bit, non-prefetchable) [size=512]
	Kernel driver in use: budget_av

I am using drivers from kernel 2.6.34.
Any Ideas for solving this issue?
Thx.
Halim

