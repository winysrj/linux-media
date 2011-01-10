Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43028 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab1AJABW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jan 2011 19:01:22 -0500
Received: by iyj18 with SMTP id 18so423418iyj.19
        for <linux-media@vger.kernel.org>; Sun, 09 Jan 2011 16:01:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=sCnVyXp090hKVWP+yprCn9da0sfQMAZxq9-Uc@mail.gmail.com>
References: <AANLkTi=sCnVyXp090hKVWP+yprCn9da0sfQMAZxq9-Uc@mail.gmail.com>
Date: Mon, 10 Jan 2011 01:01:21 +0100
Message-ID: <AANLkTimb6ozDq3HS9dO2LiWt9mPU36YQc2sjT_jBhAjm@mail.gmail.com>
Subject: cx23885 errors on Tevii S470
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello list, I have a Tevii S470 PCIe DVB-S2 card, I use it with MythTV
on a Debian
Squeeze (2.6.32-5) machine. I am getting some freeze on channel jump
and sometimes I must restart MythTV frontend to get it working.

I am using Tevii beta drivers:
http://tevii.com/100315_Beta_linux_tevii_ds3000.rar

This the dmesg output:

[ 4328.642850] cx23885[0]: mpeg risc op code error
[ 4328.642873] cx23885[0]: TS1 B - dma channel status dump
[ 4328.642883] cx23885[0]:   cmds: init risc lo   : 0x321af000
[ 4328.642891] cx23885[0]:   cmds: init risc hi   : 0x00000000
[ 4328.642899] cx23885[0]:   cmds: cdt base       : 0x00010580
[ 4328.642907] cx23885[0]:   cmds: cdt size       : 0x0000000a
[ 4328.642916] cx23885[0]:   cmds: iq base        : 0x00010400
[ 4328.642924] cx23885[0]:   cmds: iq size        : 0x00000010
[ 4328.642932] cx23885[0]:   cmds: risc pc lo     : 0x316c90f0
[ 4328.642939] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[ 4328.642947] cx23885[0]:   cmds: iq wr ptr      : 0x0000410c
[ 4328.642956] cx23885[0]:   cmds: iq rd ptr      : 0x00004103
[ 4328.642963] cx23885[0]:   cmds: cdt current    : 0x000105a8
[ 4328.642972] cx23885[0]:   cmds: pci target lo  : 0x316cd920
[ 4328.642982] cx23885[0]:   cmds: pci target hi  : 0x00000000
[ 4328.642989] cx23885[0]:   cmds: line / byte    : 0x030e0000
[ 4328.642996] cx23885[0]:   risc0: 0x1c0002f0 [ write sol eol count=752 ]
[ 4328.643012] cx23885[0]:   risc1: 0x316cd920 [ INVALID irq1 22 21 19
18 resync 14 12 count=2336 ]
[ 4328.643033] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[ 4328.643043] cx23885[0]:   risc3: 0x1c0002f0 [ write sol eol count=752 ]
[ 4328.643057] cx23885[0]:   (0x00010400) iq 0: 0x1c0002f0 [ write sol
eol count=752 ]
[ 4328.643072] cx23885[0]:   iq 1: 0x316cd920 [ arg #1 ]
[ 4328.643080] cx23885[0]:   iq 2: 0x00000000 [ arg #2 ]
[ 4328.643087] cx23885[0]:   (0x0001040c) iq 3: 0x1c0002f0 [ write sol
eol count=752 ]
[ 4328.643101] cx23885[0]:   iq 4: 0x316cdc10 [ arg #1 ]
[ 4328.643109] cx23885[0]:   iq 5: 0x00000000 [ arg #2 ]
[ 4328.643117] cx23885[0]:   (0x00010418) iq 6: 0x18000100 [ write sol
count=256 ]
[ 4328.643130] cx23885[0]:   iq 7: 0x316cdf00 [ arg #1 ]
[ 4328.643138] cx23885[0]:   iq 8: 0x00000000 [ arg #2 ]
[ 4328.643145] cx23885[0]:   (0x00010424) iq 9: 0x140001f0 [ write eol
count=496 ]
[ 4328.643158] cx23885[0]:   iq a: 0x316cc000 [ arg #1 ]
[ 4328.643166] cx23885[0]:   iq b: 0x00000000 [ arg #2 ]
[ 4328.643173] cx23885[0]:   (0x00010430) iq c: 0x00000000 [ INVALID count=0 ]
[ 4328.643185] cx23885[0]:   (0x00010434) iq d: 0x1c0002f0 [ write sol
eol count=752 ]
[ 4328.643199] cx23885[0]:   iq e: 0x316cd630 [ arg #1 ]
[ 4328.643207] cx23885[0]:   iq f: 0x00000000 [ arg #2 ]
[ 4328.643213] cx23885[0]: fifo: 0x00005000 -> 0x6000
[ 4328.643219] cx23885[0]: ctrl: 0x00010400 -> 0x10460
[ 4328.643226] cx23885[0]:   ptr1_reg: 0x000058f0
[ 4328.643233] cx23885[0]:   ptr2_reg: 0x000105b8
[ 4328.643240] cx23885[0]:   cnt1_reg: 0x00000002
[ 4328.643247] cx23885[0]:   cnt2_reg: 0x00000003
[ 4328.643279] cx23885[0]: mpeg risc op code error
[ 4328.643287] cx23885[0]: TS1 B - dma channel status dump
[ 4328.643295] cx23885[0]:   cmds: init risc lo   : 0x321af000
[ 4328.643303] cx23885[0]:   cmds: init risc hi   : 0x00000000
[ 4328.643312] cx23885[0]:   cmds: cdt base       : 0x00010580
[ 4328.643319] cx23885[0]:   cmds: cdt size       : 0x0000000a
[ 4328.643328] cx23885[0]:   cmds: iq base        : 0x00010400
[ 4328.643335] cx23885[0]:   cmds: iq size        : 0x00000010
[ 4328.643343] cx23885[0]:   cmds: risc pc lo     : 0x316c90f0
[ 4328.643352] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[ 4328.643361] cx23885[0]:   cmds: iq wr ptr      : 0x0000410c
[ 4328.643369] cx23885[0]:   cmds: iq rd ptr      : 0x00004103
[ 4328.643377] cx23885[0]:   cmds: cdt current    : 0x000105a8
[ 4328.643386] cx23885[0]:   cmds: pci target lo  : 0x316cd920
[ 4328.643395] cx23885[0]:   cmds: pci target hi  : 0x00000000
[ 4328.643403] cx23885[0]:   cmds: line / byte    : 0x030e0000
[ 4328.643411] cx23885[0]:   risc0: 0x1c0002f0 [ write sol eol count=752 ]
[ 4328.643425] cx23885[0]:   risc1: 0x316cd920 [ INVALID irq1 22 21 19
18 resync 14 12 count=2336 ]
[ 4328.643446] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[ 4328.643457] cx23885[0]:   risc3: 0x1c0002f0 [ write sol eol count=752 ]
[ 4328.643470] cx23885[0]:   (0x00010400) iq 0: 0x1c0002f0 [ write sol
eol count=752 ]
[ 4328.643485] cx23885[0]:   iq 1: 0x316cd920 [ arg #1 ]
[ 4328.643493] cx23885[0]:   iq 2: 0x00000000 [ arg #2 ]
[ 4328.643500] cx23885[0]:   (0x0001040c) iq 3: 0x1c0002f0 [ write sol
eol count=752 ]
[ 4328.643516] cx23885[0]:   iq 4: 0x316cdc10 [ arg #1 ]
[ 4328.643524] cx23885[0]:   iq 5: 0x00000000 [ arg #2 ]
[ 4328.643531] cx23885[0]:   (0x00010418) iq 6: 0x18000100 [ write sol
count=256 ]
[ 4328.643545] cx23885[0]:   iq 7: 0x316cdf00 [ arg #1 ]
[ 4328.643553] cx23885[0]:   iq 8: 0x00000000 [ arg #2 ]
[ 4328.643561] cx23885[0]:   (0x00010424) iq 9: 0x140001f0 [ write eol
count=496 ]
[ 4328.643574] cx23885[0]:   iq a: 0x316cc000 [ arg #1 ]
[ 4328.643581] cx23885[0]:   iq b: 0x00000000 [ arg #2 ]
[ 4328.643589] cx23885[0]:   (0x00010430) iq c: 0x00000000 [ INVALID count=0 ]
[ 4328.643600] cx23885[0]:   (0x00010434) iq d: 0x1c0002f0 [ write sol
eol count=752 ]
[ 4328.643615] cx23885[0]:   iq e: 0x316cd630 [ arg #1 ]
[ 4328.643623] cx23885[0]:   iq f: 0x00000000 [ arg #2 ]
[ 4328.643630] cx23885[0]: fifo: 0x00005000 -> 0x6000
[ 4328.643636] cx23885[0]: ctrl: 0x00010400 -> 0x10460
[ 4328.643643] cx23885[0]:   ptr1_reg: 0x000058f0
[ 4328.643650] cx23885[0]:   ptr2_reg: 0x000105b8
[ 4328.643657] cx23885[0]:   cnt1_reg: 0x00000002
[ 4328.643663] cx23885[0]:   cnt2_reg: 0x00000003

Has someone any idea what happens? I am new on this, I will appreciate any help.

Thanks for all your work and best regards.

-- 
Josu Lazkano
