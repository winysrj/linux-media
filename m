Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:56355 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaEBRAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 May 2014 13:00:25 -0400
Received: from localhost (localhost [127.0.0.1])
	by lindor.oans.dyndns.org (Postfix) with ESMTP id E1B899A3745
	for <linux-media@vger.kernel.org>; Fri,  2 May 2014 19:00:54 +0200 (CEST)
Received: from lindor.oans.dyndns.org ([127.0.0.1])
	by localhost (lindor.oans.dyndns.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zPExi323tDQf for <linux-media@vger.kernel.org>;
	Fri,  2 May 2014 19:00:53 +0200 (CEST)
Received: from callebaut.oans.dyndns.org (callebaut.oans.dyndns.org [192.168.1.20])
	by lindor.oans.dyndns.org (Postfix) with ESMTPSA id AE76F9A3739
	for <linux-media@vger.kernel.org>; Fri,  2 May 2014 19:00:53 +0200 (CEST)
From: Andreas Pilz <ap@oans.dyndns.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Help needed for TechniSat Skystar 2 HD
Message-Id: <6B7A203B-CF1D-4DAA-B469-A25B1FC5DA6B@oans.dyndns.org>
Date: Fri, 2 May 2014 19:00:17 +0200
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear DVB-S2 Knowers!

I am trying to get with a new kernel my two TechniSat Skystar HD 2 working.

I have 3 cards:

05:00.0 0480: 1822:4e35 (rev 01)
	Subsystem: 153b:1179
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort+ <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (2000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fafff000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: Mantis
	Kernel modules: mantis

05:01.0 0480: 1822:4e35 (rev 01)
	Subsystem: 1ae4:0003
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort+ <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (2000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at faffe000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: Mantis
	Kernel modules: mantis

05:02.0 0480: 1822:4e35 (rev 01)
	Subsystem: 1ae4:0003
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort+ <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (2000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at faffd000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: Mantis
	Kernel modules: mantis

This is the kernel (from SuSE 13.1):

	Linux godiva 3.11.10-7-desktop #1 SMP PREEMPT Mon Feb 3 09:41:24 UTC 2014 (750023e) x86_64 x86_64 x86_64 GNU/Linux

I used the s2-liplianin-v39 drivers from here :

	https://bitbucket.org/CrazyCat/s2-liplianin-v39

as these were the only ones I could compile under this kernel.

lsmod shows all fine, except that a dependency between mantis and stb0899 is missing.

Yet, with neither tool I can tune with the first card to Astra 19.2E. Yet, the other two cards always report no lock and a timeout of fronted in VDR.

Any hints? Much appreciated.

Thanks

	Andi


