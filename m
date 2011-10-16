Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52088 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1JPEGf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Oct 2011 00:06:35 -0400
Received: by pzk36 with SMTP id 36so2161018pzk.1
        for <linux-media@vger.kernel.org>; Sat, 15 Oct 2011 21:06:35 -0700 (PDT)
Message-ID: <4E9A5849.3030808@gmail.com>
Date: Sat, 15 Oct 2011 21:06:33 -0700
From: Mario Torres <mtmontaras@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Can I Say a Word to you Guys?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Can I say a word to you guys?

Cool

I got one AVerMedia M792 PCIe Combo (OEM) on Ubuntu 11.10 and i wonder 
if we can work it out, it is a pci-e and yes it is on the unsupported 
list. but if we can work it out lets do it.

when i do a lspci -vv
it gives me this


03:00.0 Multimedia video controller: Conexant Systems, Inc. CX23887/8 
PCIe Broadcast Audio and Video Decoder with 3D Comb (rev 0f)
     Subsystem: Avermedia Technologies Inc Device df39
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 17
     Region 0: Memory at f9e00000 (64-bit, non-prefetchable) [size=2M]
     Capabilities: <access denied>
     Kernel driver in use: cx23885
     Kernel modules: cx23885

