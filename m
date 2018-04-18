Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:40836 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751248AbeDRBtX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 21:49:23 -0400
Received: by mail-ua0-f176.google.com with SMTP id c9so101908uaf.7
        for <linux-media@vger.kernel.org>; Tue, 17 Apr 2018 18:49:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiwwCtp0entUfK74PhJDAubxAQeuAYgf6Jotw_EOT7+hSw@mail.gmail.com>
References: <CAGoCfiw_oD6PLOoot55zkNBVaujeG7ReNQORiqUbLuh-=iwcyw@mail.gmail.com>
 <20180417045300.GA7723@minime.bse> <CAGoCfiwwCtp0entUfK74PhJDAubxAQeuAYgf6Jotw_EOT7+hSw@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Tue, 17 Apr 2018 21:49:22 -0400
Message-ID: <CAGoCfizXy6j5rgzDghT3Lo3ZKvoUjLt7P3k7qo5wnX+xEE7m-g@mail.gmail.com>
Subject: Re: cx88 invalid video opcodes when VBI enabled
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Daniel,

See below.

Devin

[   68.750805] cx88[0]: irq vid [0x18080] vbi_risc2* vbi_sync opc_err*
[   68.750805] cx88[0]/0: video risc op code error
[   68.750809] cx88[0]: video y / packed - dma channel status dump
[   68.750811] cx88[0]:   cmds: initial risc: 0x8aa98000
[   68.750813] cx88[0]:   cmds: cdt base    : 0x00180440
[   68.750815] cx88[0]:   cmds: cdt size    : 0x0000000c
[   68.750816] cx88[0]:   cmds: iq base     : 0x00180400
[   68.750818] cx88[0]:   cmds: iq size     : 0x00000010
[   68.750820] cx88[0]:   cmds: risc pc     : 0x8aa1f03c
[   68.750821] cx88[0]:   cmds: iq wr ptr   : 0x0000010d
[   68.750823] cx88[0]:   cmds: iq rd ptr   : 0x00000101
[   68.750825] cx88[0]:   cmds: cdt current : 0x00000478
[   68.750827] cx88[0]:   cmds: pci target  : 0x8a9ed800
[   68.750828] cx88[0]:   cmds: line / byte : 0x02780000
[   68.750832] cx88[0]:   risc0: 0x80008000 [ sync resync count=0 ]
[   68.750835] cx88[0]:   risc1: 0x1c000280 [ write sol eol count=640 ]
[   68.750837] cx88[0]:   risc2: 0x8ab20000 [ arg #1 ]
[   68.750840] cx88[0]:   risc3: 0x1c000280 [ write sol eol count=640 ]
[   68.750842] cx88[0]:   iq 0: 0x80008000 [ sync resync count=0 ]
[   68.750845] cx88[0]:   iq 1: 0x1c000280 [ write sol eol count=640 ]
[   68.750847] cx88[0]:   iq 2: 0x8ab20000 [ arg #1 ]
[   68.750850] cx88[0]:   iq 3: 0x1c000280 [ write sol eol count=640 ]
[   68.750852] cx88[0]:   iq 4: 0x8ab20500 [ arg #1 ]
[   68.750854] cx88[0]:   iq 5: 0x1c000280 [ write sol eol count=640 ]
[   68.750856] cx88[0]:   iq 6: 0x8ab20a00 [ arg #1 ]
[   68.750859] cx88[0]:   iq 7: 0x1c000280 [ write sol eol count=640 ]
[   68.750861] cx88[0]:   iq 8: 0x8ab20f00 [ arg #1 ]
[   68.750864] cx88[0]:   iq 9: 0x1c000280 [ write sol eol count=640 ]
[   68.750866] cx88[0]:   iq a: 0x8ab21400 [ arg #1 ]
[   68.750868] cx88[0]:   iq b: 0x1c000280 [ write sol eol count=640 ]
[   68.750870] cx88[0]:   iq c: 0x8ab21900 [ arg #1 ]
[   68.750873] cx88[0]:   iq d: 0x1c000280 [ write sol eol count=640 ]
[   68.750875] cx88[0]:   iq e: 0x8a9ed580 [ arg #1 ]
[   68.750877] cx88[0]:   iq f: 0x70010000 [ jump cnt0 count=0 ]
[   68.750879] cx88[0]:   iq 10: 0x00180c00 [ arg #1 ]
[   68.750880] cx88[0]: fifo: 0x00180c00 -> 0x183400
[   68.750881] cx88[0]: ctrl: 0x00180400 -> 0x180460
[   68.750882] cx88[0]:   ptr1_reg: 0x00181380
[   68.750884] cx88[0]:   ptr2_reg: 0x00180478
[   68.750885] cx88[0]:   cnt1_reg: 0x00000000
[   68.750887] cx88[0]:   cnt2_reg: 0x00000000
[   68.750887] cx88[0]: vbi - dma channel status dump
[   68.750889] cx88[0]:   cmds: initial risc: 0x8a9cd000
[   68.750891] cx88[0]:   cmds: cdt base    : 0x00180620
[   68.750892] cx88[0]:   cmds: cdt size    : 0x00000004
[   68.750894] cx88[0]:   cmds: iq base     : 0x001805e0
[   68.750896] cx88[0]:   cmds: iq size     : 0x00000010
[   68.750897] cx88[0]:   cmds: risc pc     : 0x8a9cd008
[   68.750899] cx88[0]:   cmds: iq wr ptr   : 0x0000017f
[   68.750901] cx88[0]:   cmds: iq rd ptr   : 0x00000011
[   68.750902] cx88[0]:   cmds: cdt current : 0x00000638
[   68.750904] cx88[0]:   cmds: pci target  : 0x05d9d242
[   68.750906] cx88[0]:   cmds: line / byte : 0x00030000
[   68.750910] cx88[0]:   risc0: 0x8aa98000 [ sync sol irq2 23 21 19
cnt0 resync count=0 ]
[   68.750913] cx88[0]:   risc1: 0x00180440 [ INVALID 20 19 count=1088 ]
[   68.750915] cx88[0]:   risc2: 0x0000000c [ INVALID count=12 ]
[   68.750918] cx88[0]:   risc3: 0x00180400 [ INVALID 20 19 count=1024 ]
[   68.750920] cx88[0]:   iq 0: 0x1c000800 [ write sol eol count=2048 ]
[   68.750922] cx88[0]:   iq 1: 0x8ab4f800 [ arg #1 ]
[   68.750925] cx88[0]:   iq 2: 0x1c000800 [ write sol eol count=2048 ]
[   68.750927] cx88[0]:   iq 3: 0x8aa02000 [ arg #1 ]
[   68.750930] cx88[0]:   iq 4: 0x1c000800 [ write sol eol count=2048 ]
[   68.750932] cx88[0]:   iq 5: 0x8ab43000 [ arg #1 ]
[   68.750934] cx88[0]:   iq 6: 0x70010000 [ jump cnt0 count=0 ]
[   68.750936] cx88[0]:   iq 7: 0x8ab43800 [ arg #1 ]
[   68.750939] cx88[0]:   iq 8: 0x1c000800 [ write sol eol count=2048 ]
[   68.750940] cx88[0]:   iq 9: 0x8ab48000 [ arg #1 ]
[   68.750943] cx88[0]:   iq a: 0x80008200 [ sync resync count=512 ]
[   68.750946] cx88[0]:   iq b: 0x1c000800 [ write sol eol count=2048 ]
[   68.750948] cx88[0]:   iq c: 0x8ab4c800 [ arg #1 ]
[   68.750951] cx88[0]:   iq d: 0x1c000800 [ write sol eol count=2048 ]
[   68.750952] cx88[0]:   iq e: 0x8ab4d000 [ arg #1 ]
[   68.750955] cx88[0]:   iq f: 0x1c000800 [ write sol eol count=2048 ]
[   68.750957] cx88[0]:   iq 10: 0x00184400 [ arg #1 ]
[   68.750958] cx88[0]: fifo: 0x00184400 -> 0x185400
[   68.750958] cx88[0]: ctrl: 0x001805e0 -> 0x180640
[   68.750960] cx88[0]:   ptr1_reg: 0x00184400
[   68.750961] cx88[0]:   ptr2_reg: 0x00180628
[   68.750963] cx88[0]:   cnt1_reg: 0x00000000
[   68.750964] cx88[0]:   cnt2_reg: 0x00000000

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
