Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.unsolicited.net ([173.255.193.191]:19213 "EHLO
        mx1.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbeIMXH7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 19:07:59 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: David R <david@unsolicited.net>
Subject: cx23885 - regression between 4.17.x and 4.18.x
Message-ID: <47a0c36e-3247-bae4-674d-d8ae7d503a40@unsolicited.net>
Date: Thu, 13 Sep 2018 18:39:57 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Just a heads up. I'm having to revert cx23885-core.c to the 4.17 version
to obtain stability with my old AMD Phenom/ASUS M4A785TD and Hauppauge
WinTV-HVR-5525. The latest code drops out and refuses to return video
streams in hours or a few days max. The 4.17 version is fine and stable
over weeks/months.

04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23887/8
PCIe Broadcast Audio and Video Decoder with 3D Comb (rev 04)
    Subsystem: Hauppauge computer works Inc. Device f038
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 17
    Region 0: Memory at fe800000 (64-bit, non-prefetchable) [size=2M]
    Capabilities: <access denied>
    Kernel driver in use: cx23885

Cheers
David
