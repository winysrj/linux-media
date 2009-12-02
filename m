Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout09.t-online.de ([194.25.134.84]:51051 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbZLBQbw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 11:31:52 -0500
Date: Wed, 2 Dec 2009 17:32:09 +0100
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-media@vger.kernel.org
Subject: knc1 dvb-c plus doesn't work with kenrel 2.6.31
Message-ID: <20091202163209.GA2811@gentoo.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello list,
The mentioned card doesnÄ't work any more.
I am running an opensuse 2.6.31 kernel.
It sems that no frontend can be loaded.
I am getting also many cam inserted or cam ejected messages.

dmesg contains this message:

[ 1067.280898] budget-av: A frontend driver was not found for device
[1131:7146]
 subsystem [1894:0021]

lspci -vvv
01:05.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
Subsystem: KNC One Device 0021
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- S
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbo
Latency: 64 (3750ns min, 9500ns max)
Interrupt: pin A routed to IRQ 18
Region 0: [virtual] Memory at 80000000 (32-bit, non-prefetchable)
[size=512]
Kernel driver in use: budget_av
ny ideas?

Regards
Halim

