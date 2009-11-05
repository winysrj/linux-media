Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.184]:50631 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595AbZKEVEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 16:04:23 -0500
Received: by gv-out-0910.google.com with SMTP id r4so136698gve.37
        for <linux-media@vger.kernel.org>; Thu, 05 Nov 2009 13:04:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <702870ef0911051257k52c142e8ne1b32506f1efb45c@mail.gmail.com>
References: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
	 <829197380911042051l295e9796g65fe1b163f72a70c@mail.gmail.com>
	 <26256.64.213.30.2.1257398603.squirrel@webmail.exetel.com.au>
	 <829197380911050602t30bc69d0sd0b269c39bf759e@mail.gmail.com>
	 <702870ef0911051257k52c142e8ne1b32506f1efb45c@mail.gmail.com>
Date: Thu, 5 Nov 2009 16:04:26 -0500
Message-ID: <829197380911051304g1544e277s870f869be14e1a18@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: Robert Lowery <rglowery@exemail.com.au>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 5, 2009 at 3:57 PM, Vincent McIntyre
<vincent.mcintyre@gmail.com> wrote:
> I have one of these too.
>
> lsusb:
> Bus 003 Device 003: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
> (ZL10353+xc2028/xc3028) (initialized)
> Bus 003 Device 002: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
> (ZL10353+xc2028/xc3028) (initialized)
>
> In addition I have a "DViCO Dual Digital Express" which is a PCIe card
> based on Conexant, with the Zarlink frontend.
> lspci:
> 04:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
> CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
>        Subsystem: DViCO Corporation Device [18ac:db78]
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 19
>        Region 0: Memory at 90000000 (64-bit, non-prefetchable) [size=2M]
>        Capabilities: <access denied>
>        Kernel driver in use: cx23885
>        Kernel modules: cx23885

Crap.  This is the price I pay for not having noticed Robert included
a launchpad ticket with the dmesg output.

Yeah, it's a zl10353, so I know what the problem is.  Let me look at
the code and send you a patch for testing.  If you don't hear back
from me within 24 hours, ping me again.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
