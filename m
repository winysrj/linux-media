Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpas8.vodafone.es ([62.87.37.76]:50784 "EHLO
	smtpas8.vodafone.es" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752904Ab0CUCvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 22:51:52 -0400
Received: from vodafone.es ([10.101.251.64])
	by smtpas8.vodafone.es with ESMTP id o2KMCI6A003229
	for <linux-media@vger.kernel.org>; Sat, 20 Mar 2010 23:12:18 +0100
Received: from [192.168.1.104] ([79.109.168.127]) by mail-smtp03-p.vodafone.es
 (Messaging) with ESMTPA id <0KZL00LEKPOH50B0@mail-smtp03-p.vodafone.es> for
 linux-media@vger.kernel.org; Sat, 20 Mar 2010 23:12:17 +0100 (MET)
Date: Sat, 20 Mar 2010 23:12:17 +0100
From: =?ISO-8859-1?Q?Jes=FAs_Vidal_Panal=E9s?= <jesusvpct@vodafone.es>
Subject: pinnacle pctv dvb-t 2000i
To: linux-media@vger.kernel.org
Message-id: <4BA54841.1060302@vodafone.es>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Any news about this card? Some time ago i read that it was on 
development the pinnacle DTV bridge, but i can't find any information 
now about this.

lspci -vvnnnx

03:07.0 Multimedia controller [0480]: Pinnacle Systems Inc. Royal TS 
Function 1 [11bd:0040]
         Subsystem: Pinnacle Systems Inc. Device [11bd:0044]
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (500ns min, 4000ns max), Cache Line Size: 4 bytes
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at fdcff000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: <access denied>
00: bd 11 40 00 06 00 90 02 00 00 80 04 01 20 80 00
10: 00 f0 cf fd 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 bd 11 44 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 02 10

03:07.1 Multimedia controller [0480]: Pinnacle Systems Inc. RoyalTS 
Function 2 [11bd:0041]
         Subsystem: Pinnacle Systems Inc. Device [11bd:0044]
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (500ns min, 4000ns max), Cache Line Size: 4 bytes
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at fdcfe000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: <access denied>
00: bd 11 41 00 06 00 90 02 00 00 80 04 01 20 80 00
10: 00 e0 cf fd 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 bd 11 44 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 02 10

03:07.2 Multimedia controller [0480]: Pinnacle Systems Inc. Royal TS 
Function 3 [11bd:0042]
         Subsystem: Pinnacle Systems Inc. Device [11bd:0044]
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (500ns min, 4000ns max), Cache Line Size: 4 bytes
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at fdcfd000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: <access denied>
00: bd 11 42 00 06 00 90 02 00 00 80 04 01 20 80 00
10: 00 d0 cf fd 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 bd 11 44 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 02 10


