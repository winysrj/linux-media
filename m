Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50623 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750885AbeDRSaC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 14:30:02 -0400
Received: from minime.bse ([77.22.125.85]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MC8iq-1fHhWq2EGO-008p64 for
 <linux-media@vger.kernel.org>; Wed, 18 Apr 2018 20:30:00 +0200
Date: Wed, 18 Apr 2018 20:29:59 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: cx88 invalid video opcodes when VBI enabled
Message-ID: <20180418182959.GA19152@minime.bse>
References: <CAGoCfiw_oD6PLOoot55zkNBVaujeG7ReNQORiqUbLuh-=iwcyw@mail.gmail.com>
 <20180417045300.GA7723@minime.bse>
 <CAGoCfiwwCtp0entUfK74PhJDAubxAQeuAYgf6Jotw_EOT7+hSw@mail.gmail.com>
 <CAGoCfizXy6j5rgzDghT3Lo3ZKvoUjLt7P3k7qo5wnX+xEE7m-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGoCfizXy6j5rgzDghT3Lo3ZKvoUjLt7P3k7qo5wnX+xEE7m-g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Apr 17, 2018 at 09:49:22PM -0400, Devin Heitmueller wrote:
> [   68.750809] cx88[0]: video y / packed - dma channel status dump
> [   68.750811] cx88[0]:   cmds: initial risc: 0x8aa98000
> [   68.750813] cx88[0]:   cmds: cdt base    : 0x00180440
> [   68.750815] cx88[0]:   cmds: cdt size    : 0x0000000c
> [   68.750816] cx88[0]:   cmds: iq base     : 0x00180400
[...]
> [   68.750887] cx88[0]: vbi - dma channel status dump
[...]
> [   68.750899] cx88[0]:   cmds: iq wr ptr   : 0x0000017f
> [   68.750901] cx88[0]:   cmds: iq rd ptr   : 0x00000011
> [   68.750902] cx88[0]:   cmds: cdt current : 0x00000638
[...]
> [   68.750910] cx88[0]:   risc0: 0x8aa98000 [ sync sol irq2 23 21 19 cnt0 resync count=0 ]
> [   68.750913] cx88[0]:   risc1: 0x00180440 [ INVALID 20 19 count=1088 ]
> [   68.750915] cx88[0]:   risc2: 0x0000000c [ INVALID count=12 ]
> [   68.750918] cx88[0]:   risc3: 0x00180400 [ INVALID 20 19 count=1024 ]

The VBI instruction queue read pointer points outside the VBI instruction
queue and into the video y/packed CMDS (to 0x180000+0x11*4). The values
next to the iq rd ptr look ok.

We only initialize the iq rd ptr to zero in cx88_sram_channel_setup and
then never touch it again. The hardware takes care of updating it.
Maybe cx88_sram_channel_setup is sometimes called for channel 24 while the
VBI risc engine is still running? One could try adding a WARN_ONCE at the
top of the function to catch that case.

Best regards,

  Daniel
