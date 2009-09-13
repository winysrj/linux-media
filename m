Return-path: <linux-media-owner@vger.kernel.org>
Received: from server15.01domain.net ([216.7.191.132]:52771 "EHLO
	server15.01domain.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbZIMDDy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 23:03:54 -0400
Received: from localhost ([127.0.0.1])
	by server15.01domain.net with esmtpa (Exim 4.69)
	(envelope-from <vikevid@omnitude.net>)
	id 1MmeAa-0008VD-CU
	for linux-media@vger.kernel.org; Sat, 12 Sep 2009 19:46:24 -0600
Message-ID: <20090913114622.cwfj5t1kgowgkgo4@omnitude.net>
Date: Sun, 13 Sep 2009 11:46:22 +1000
From: Adam Swift <vikevid@omnitude.net>
To: linux-media@vger.kernel.org
Subject: cx88: 2 channels on each of 2 cards
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have 2 LeadTek WinFast TV2000 XP Expert analog capture cards. I'm  
attempting to get 4 channels of video in, using both the S-video and  
component inputs (not the tuners) of each cards. I understand that  
this was possible with the bt878 which this chip is an evolution of.

However, it doesn't work.

1 channel on each card gives no signal on the "second" card- i.e. the  
one initialised second. This is from tests with  and ZoneAlarm (the  
application I'm trying to use the cards with).

2 channels on one card kinda works, but not correctly. Sometimes one  
channel will display vertical split-screen of both feeds, with a  
little noise at the top, bottom, and in between. Sometimes each  
channel will display correctly, but will appear to "vibrate" up and  
down, and the channels seem to alternate between which one updates. I  
can provide screenshots of both these behaviours if it will help.

I've tried this with the following kernels:
2.6.29-larch
2.6.17-10mdv

If someone can point me in the right direction I may be able to do any  
patches required myself, but I need a starting point.

Thanks in advance,
Adam Swift


relevant parts of lspci -vv:

02:0b.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video  
and Audio Decoder (rev 05)
	Subsystem: LeadTek Research Inc. Unknown device 6611
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-  
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-  
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at ec000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:0d.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video  
and Audio Decoder (rev 05)
	Subsystem: LeadTek Research Inc. Unknown device 6611
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-  
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-  
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at eb000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

