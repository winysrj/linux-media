Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:46900 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbZGIWFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2009 18:05:18 -0400
Received: from IO.local (149-238.105-92.cust.bluewin.ch [92.105.238.149])
	(authenticated bits=0)
	by smtp1.infomaniak.ch (8.14.2/8.14.2) with ESMTP id n69M598o015366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 10 Jul 2009 00:05:13 +0200
Message-ID: <4A566995.1050606@deckpoint.ch>
Date: Fri, 10 Jul 2009 00:05:09 +0200
From: Thomas Kernen <tkernen@deckpoint.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Ubuntu kernel 2.6.28-11/13 and KNC One clone
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I just noticed something on a "minor" Ubuntu kernel upgrade. Running 
Linux nylon 2.6.28-11-server #42-Ubuntu SMP Fri Apr 17 02:45:36 UTC 2009 
x86_64 GNU/Linux and Ubuntu update system offers 2.6.28-13.

I take the upgrade and notice that in 2.6.28-13 the budget-av module 
will not load anymore for the KNC One DVB-S2 card.

11:09.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: KNC One Device 0019
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 123 (3750ns min, 9500ns max)
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at d0220400 (32-bit, non-prefetchable) [size=512]
	Kernel driver in use: budget_av
	Kernel modules: budget-av

The only diff is that -13 will not have the last 2 lines. Nothing in 
dmesg that indicates any error on loading in -13.

Is this worth reporting to the Ubuntu QA team or already old news?

Thomas
