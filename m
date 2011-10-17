Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36531 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1JQXuN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Oct 2011 19:50:13 -0400
Message-ID: <4E9CBF33.5090401@gmail.com>
Date: Mon, 17 Oct 2011 16:50:11 -0700
From: Mario Torres <mtmontaras@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, majordomo@vger.kernel.org
Subject: help
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
