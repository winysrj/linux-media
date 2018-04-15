Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:32890 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752470AbeDORhw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 13:37:52 -0400
Received: by mail-vk0-f50.google.com with SMTP id d201so8160062vke.0
        for <linux-media@vger.kernel.org>; Sun, 15 Apr 2018 10:37:52 -0700 (PDT)
MIME-Version: 1.0
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Sun, 15 Apr 2018 13:37:50 -0400
Message-ID: <CAGoCfiw_oD6PLOoot55zkNBVaujeG7ReNQORiqUbLuh-=iwcyw@mail.gmail.com>
Subject: cx88 invalid video opcodes when VBI enabled
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I received a report of a case where cx88 video capture was failing on
start and the dmesg was reporting an invalid opcode on the video IRQ
handler.  I did a bisect, and it looks like it's a result of the
videobuf2 conversion done back in late 2014.  A few notes:

1.  It only seems to occur if both video and VBI are being used.  I
cannot reproduce the issue when doing video only.

2.  It seems like it's some sort of order-of-operations issue when
interacting with the video/vbi device nodes, since it only happens
with the stock VLC and not tvtime.  It could also be that VLC uses
libzvbi, which access the VBI device in mmap mode, whereas tvtime
still uses read() for VBI access.

3.  The problem is readily reproducible on a stock Ubuntu 14.04
system, as well as with 16.04, using the stock VLC that ships with the
distro.  I'm testing with the following command line:

vlc v4l:///dev/video0 :v4l2-vbi-dev=/dev/vbi0

Sometimes it doesn't happen on the first hit and you have to run it a
few times, but I've never seen it take more than 5 executions for the
failure to occur.

4.  The problem occurs even when I blacklist the cx88-alsa driver.
This is worth noting since cx88-alsa has a different issue that
results in dumping out the RISC engine state, and I wanted to both
ensure the two issues weren't confused for each other, nor that the
ALSA interaction could be impacting the order of operations for
interacting with the driver.

Any suggestions on the best way to debug this without having to learn
the intimate details of the RISC engine on the cx88?  From the state
of the RISC engine it looks like there is some issue with queuing the
opcodes/arguments (where in some cases arguments are interpreted as
opcodes), but this is certainly not my area of expertise.

Thanks,

Devin

[   54.427224] cx88[0]: irq vid [0x10088] vbi_risc1* vbi_risc2* opc_err*
[   54.427232] cx88[0]/0: video risc op code error
[   54.427238] cx88[0]: video y / packed - dma channel status dump
[   54.427241] cx88[0]:   cmds: initial risc: 0x87cdb000
[   54.427244] cx88[0]:   cmds: cdt base    : 0x00180440
[   54.427247] cx88[0]:   cmds: cdt size    : 0x0000000c
[   54.427249] cx88[0]:   cmds: iq base     : 0x00180400
[   54.427251] cx88[0]:   cmds: iq size     : 0x00000010
[   54.427253] cx88[0]:   cmds: risc pc     : 0x87cdb03c
[   54.427256] cx88[0]:   cmds: iq wr ptr   : 0x0000010e
[   54.427258] cx88[0]:   cmds: iq rd ptr   : 0x00000102
[   54.427260] cx88[0]:   cmds: cdt current : 0x00000458
[   54.427263] cx88[0]:   cmds: pci target  : 0x00000000
[   54.427265] cx88[0]:   cmds: line / byte : 0x00000000
[   54.427267] cx88[0]:   risc0: 0x80008000 [ sync resync count=0 ]
[   54.427271] cx88[0]:   risc1: 0x1c000280 [ write sol eol count=640 ]
[   54.427276] cx88[0]:   risc2: 0x87dc0000 [ arg #1 ]
[   54.427279] cx88[0]:   risc3: 0x1c000280 [ write sol eol count=640 ]
[   54.427283] cx88[0]:   iq 0: 0x70000000 [ jump count=0 ]
[   54.427286] cx88[0]:   iq 1: 0x80008000 [ arg #1 ]
[   54.427289] cx88[0]:   iq 2: 0x1c000280 [ write sol eol count=640 ]
[   54.427293] cx88[0]:   iq 3: 0x87dc0000 [ arg #1 ]
[   54.427295] cx88[0]:   iq 4: 0x1c000280 [ write sol eol count=640 ]
[   54.427300] cx88[0]:   iq 5: 0x87dc0500 [ arg #1 ]
[   54.427302] cx88[0]:   iq 6: 0x1c000280 [ write sol eol count=640 ]
[   54.427306] cx88[0]:   iq 7: 0x87dc0a00 [ arg #1 ]
[   54.427309] cx88[0]:   iq 8: 0x1c000280 [ write sol eol count=640 ]
[   54.427313] cx88[0]:   iq 9: 0x87dc0f00 [ arg #1 ]
[   54.427315] cx88[0]:   iq a: 0x1c000280 [ write sol eol count=640 ]
[   54.427319] cx88[0]:   iq b: 0x87dc1400 [ arg #1 ]
[   54.427321] cx88[0]:   iq c: 0x1c000280 [ write sol eol count=640 ]
[   54.427326] cx88[0]:   iq d: 0x87dc1900 [ arg #1 ]
[   54.427328] cx88[0]:   iq e: 0xd2000001 [ writecr irq2 count=1 ]
[   54.427332] cx88[0]:   iq f: 0x0031c040 [ arg #1 ]
[   54.427334] cx88[0]:   iq 10: 0x00180c00 [ arg #2 ]
[   54.427337] cx88[0]:   iq 11: 0x6f60580c [ arg #3 ]
[   54.427339] cx88[0]: fifo: 0x00180c00 -> 0x183400
[   54.427340] cx88[0]: ctrl: 0x00180400 -> 0x180460
[   54.427342] cx88[0]:   ptr1_reg: 0x00180eb8
[   54.427344] cx88[0]:   ptr2_reg: 0x00180458
[   54.427347] cx88[0]:   cnt1_reg: 0x00000007
[   54.427349] cx88[0]:   cnt2_reg: 0x00000000


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
