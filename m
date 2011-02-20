Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57678 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1BTUSH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Feb 2011 15:18:07 -0500
Received: by iyb26 with SMTP id 26so59842iyb.19
        for <linux-media@vger.kernel.org>; Sun, 20 Feb 2011 12:18:06 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 20 Feb 2011 21:18:05 +0100
Message-ID: <AANLkTinXc5q=V3nQ7hUSzwqc+kVwkSp0oY0ZRhJeVZ63@mail.gmail.com>
Subject: Upgrade cx23885
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello, I have a Tevii S470 DVB-S2 card on a Debian Squeeze system. I
have Tevii drivers for the card. Sometimes I get problems watching HD
channels, I am not expert and I don't know how to get it stable. Here
is the dmesg output for cx23885 module:

[ 5902.952411] cx23885[0]: mpeg risc op code error
[ 5902.952439] cx23885[0]: TS1 B - dma channel status dump
[ 5902.952452] cx23885[0]:   cmds: init risc lo   : 0x1158e000
[ 5902.952462] cx23885[0]:   cmds: init risc hi   : 0x00000000
[ 5902.952471] cx23885[0]:   cmds: cdt base       : 0x00010580
[ 5902.952479] cx23885[0]:   cmds: cdt size       : 0x0000000a
[ 5902.952487] cx23885[0]:   cmds: iq base        : 0x00010400
[ 5902.952496] cx23885[0]:   cmds: iq size        : 0x00000010
[ 5902.952504] cx23885[0]:   cmds: risc pc lo     : 0x16bbe0a8
[ 5902.952513] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[ 5902.952522] cx23885[0]:   cmds: iq wr ptr      : 0x0000410a
[ 5902.952531] cx23885[0]:   cmds: iq rd ptr      : 0x0000410e
[ 5902.952540] cx23885[0]:   cmds: cdt current    : 0x000105c8
[ 5902.952549] cx23885[0]:   cmds: pci target lo  : 0x28e52780
[ 5902.952558] cx23885[0]:   cmds: pci target hi  : 0x00000000
[ 5902.952567] cx23885[0]:   cmds: line / byte    : 0x03680000
[ 5902.952575] cx23885[0]:   risc0: 0x1c0002f0 [ write sol eol count=752 ]
[ 5902.952594] cx23885[0]:   risc1: 0x28e52780 [ skip sol 23 22 21 18
cnt0 13 count=1920 ]
[ 5902.952615] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[ 5902.952626] cx23885[0]:   risc3: 0x1c0002f0 [ write sol eol count=752 ]
[ 5902.952641] cx23885[0]:   (0x00010400) iq 0: 0x00000000 [ INVALID count=0 ]
[ 5902.952656] cx23885[0]:   (0x00010404) iq 1: 0x180002a0 [ write sol
count=672 ]
[ 5902.952673] cx23885[0]:   iq 2: 0x28e52d60 [ arg #1 ]
[ 5902.952682] cx23885[0]:   iq 3: 0x00000000 [ arg #2 ]
[ 5902.952690] cx23885[0]:   (0x00010410) iq 4: 0x14000050 [ write eol
count=80 ]
[ 5902.952705] cx23885[0]:   iq 5: 0x28e53000 [ arg #1 ]
[ 5902.952714] cx23885[0]:   iq 6: 0x00000000 [ arg #2 ]
[ 5902.952722] cx23885[0]:   (0x0001041c) iq 7: 0x1c0002f0 [ write sol
eol count=752 ]
[ 5902.952738] cx23885[0]:   iq 8: 0x28e53050 [ arg #1 ]
[ 5902.952747] cx23885[0]:   iq 9: 0x00000000 [ arg #2 ]
[ 5902.952755] cx23885[0]:   (0x00010428) iq a: 0x00000000 [ INVALID count=0 ]
[ 5902.952768] cx23885[0]:   (0x0001042c) iq b: 0x1c0002f0 [ write sol
eol count=752 ]
[ 5902.952784] cx23885[0]:   iq c: 0x28e52780 [ arg #1 ]
[ 5902.952793] cx23885[0]:   iq d: 0x00000000 [ arg #2 ]
[ 5902.952801] cx23885[0]:   (0x00010438) iq e: 0x1c0002f0 [ write sol
eol count=752 ]
[ 5902.952818] cx23885[0]:   iq f: 0x28e52a70 [ arg #1 ]
[ 5902.952827] cx23885[0]:   iq 10: 0xfaab715b [ arg #2 ]
[ 5902.952835] cx23885[0]: fifo: 0x00005000 -> 0x6000
[ 5902.952842] cx23885[0]: ctrl: 0x00010400 -> 0x10460
[ 5902.952850] cx23885[0]:   ptr1_reg: 0x00005c70
[ 5902.952859] cx23885[0]:   ptr2_reg: 0x000105c8
[ 5902.952866] cx23885[0]:   cnt1_reg: 0x0000000b
[ 5902.952874] cx23885[0]:   cnt2_reg: 0x00000001
[ 6153.701506] cx23885[0]: mpeg risc op code error
[ 6153.701533] cx23885[0]: TS1 B - dma channel status dump
[ 6153.701545] cx23885[0]:   cmds: init risc lo   : 0x16bbe000
[ 6153.701554] cx23885[0]:   cmds: init risc hi   : 0x00000000
[ 6153.701563] cx23885[0]:   cmds: cdt base       : 0x00010580
[ 6153.701573] cx23885[0]:   cmds: cdt size       : 0x0000000a
[ 6153.701582] cx23885[0]:   cmds: iq base        : 0x00010400
[ 6153.701591] cx23885[0]:   cmds: iq size        : 0x00000010
[ 6153.701601] cx23885[0]:   cmds: risc pc lo     : 0x2f768090
[ 6153.701609] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[ 6153.701618] cx23885[0]:   cmds: iq wr ptr      : 0x00004104
[ 6153.701627] cx23885[0]:   cmds: iq rd ptr      : 0x00004108
[ 6153.701636] cx23885[0]:   cmds: cdt current    : 0x00010588
[ 6153.701645] cx23885[0]:   cmds: pci target lo  : 0x114e21a0
[ 6153.701653] cx23885[0]:   cmds: pci target hi  : 0x00000000
[ 6153.701661] cx23885[0]:   cmds: line / byte    : 0x01e60000
[ 6153.701667] cx23885[0]:   risc0: 0x1c0002f0 [ write sol eol count=752 ]
[ 6153.701683] cx23885[0]:   risc1: 0x114e21a0 [ write irq1 22 19 18
cnt1 13 count=416 ]
[ 6153.701699] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[ 6153.701708] cx23885[0]:   risc3: 0x1c0002f0 [ write sol eol count=752 ]
[ 6153.701720] cx23885[0]:   (0x00010400) iq 0: 0x00000000 [ INVALID count=0 ]
[ 6153.701731] cx23885[0]:   (0x00010404) iq 1: 0x180002a0 [ write sol
count=672 ]
[ 6153.701743] cx23885[0]:   iq 2: 0x114e2d60 [ arg #1 ]
[ 6153.701750] cx23885[0]:   iq 3: 0x00000000 [ arg #2 ]
[ 6153.701757] cx23885[0]:   (0x00010410) iq 4: 0x00000000 [ INVALID count=0 ]
[ 6153.701767] cx23885[0]:   (0x00010414) iq 5: 0x1c0002f0 [ write sol
eol count=752 ]
[ 6153.701780] cx23885[0]:   iq 6: 0x114e21a0 [ arg #1 ]
[ 6153.701787] cx23885[0]:   iq 7: 0x00000000 [ arg #2 ]
[ 6153.701794] cx23885[0]:   (0x00010420) iq 8: 0x1c0002f0 [ write sol
eol count=752 ]
[ 6153.701807] cx23885[0]:   iq 9: 0x114e2490 [ arg #1 ]
[ 6153.701814] cx23885[0]:   iq a: 0x00000000 [ arg #2 ]
[ 6153.701821] cx23885[0]:   (0x0001042c) iq b: 0x1c0002f0 [ write sol
eol count=752 ]
[ 6153.701833] cx23885[0]:   iq c: 0x114e2780 [ arg #1 ]
[ 6153.701840] cx23885[0]:   iq d: 0x00000000 [ arg #2 ]
[ 6153.701846] cx23885[0]:   (0x00010438) iq e: 0x1c0002f0 [ write sol
eol count=752 ]
[ 6153.701859] cx23885[0]:   iq f: 0x114e2a70 [ arg #1 ]
[ 6153.701866] cx23885[0]:   iq 10: 0xfaab715b [ arg #2 ]
[ 6153.701871] cx23885[0]: fifo: 0x00005000 -> 0x6000
[ 6153.701876] cx23885[0]: ctrl: 0x00010400 -> 0x10460
[ 6153.701884] cx23885[0]:   ptr1_reg: 0x000050b0
[ 6153.701890] cx23885[0]:   ptr2_reg: 0x00010588
[ 6153.701897] cx23885[0]:   cnt1_reg: 0x0000000b
[ 6153.701903] cx23885[0]:   cnt2_reg: 0x00000009
[ 7196.212002] cx23885[0]: mpeg risc op code error
[ 7196.212039] cx23885[0]: TS1 B - dma channel status dump
[ 7196.212051] cx23885[0]:   cmds: init risc lo   : 0x0cc14000
[ 7196.212060] cx23885[0]:   cmds: init risc hi   : 0x00000000
[ 7196.212069] cx23885[0]:   cmds: cdt base       : 0x00010580
[ 7196.212078] cx23885[0]:   cmds: cdt size       : 0x0000000a
[ 7196.212087] cx23885[0]:   cmds: iq base        : 0x00010400
[ 7196.212096] cx23885[0]:   cmds: iq size        : 0x00000010
[ 7196.212106] cx23885[0]:   cmds: risc pc lo     : 0x21d670e4
[ 7196.212114] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[ 7196.212123] cx23885[0]:   cmds: iq wr ptr      : 0x00004109
[ 7196.212132] cx23885[0]:   cmds: iq rd ptr      : 0x0000410d
[ 7196.212142] cx23885[0]:   cmds: cdt current    : 0x000105c8
[ 7196.212150] cx23885[0]:   cmds: pci target lo  : 0x21e1b340
[ 7196.212160] cx23885[0]:   cmds: pci target hi  : 0x00000000
[ 7196.212168] cx23885[0]:   cmds: line / byte    : 0x00ec0000
[ 7196.212178] cx23885[0]:   risc0: 0x1c0002f0 [ write sol eol count=752 ]
[ 7196.212196] cx23885[0]:   risc1: 0x21e1b340 [ skip irq1 23 22 21
cnt0 resync 13 12 count=832 ]
[ 7196.212220] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[ 7196.212233] cx23885[0]:   risc3: 0x1c0002f0 [ write sol eol count=752 ]
[ 7196.212250] cx23885[0]:   (0x00010400) iq 0: 0x1c0002f0 [ write sol
eol count=752 ]
[ 7196.212267] cx23885[0]:   iq 1: 0x21e1b920 [ arg #1 ]
[ 7196.212275] cx23885[0]:   iq 2: 0x00000000 [ arg #2 ]
[ 7196.212284] cx23885[0]:   (0x0001040c) iq 3: 0x1c0002f0 [ write sol
eol count=752 ]
[ 7196.212301] cx23885[0]:   iq 4: 0x21e1bc10 [ arg #1 ]
[ 7196.212311] cx23885[0]:   iq 5: 0x00000000 [ arg #2 ]
[ 7196.212320] cx23885[0]:   (0x00010418) iq 6: 0x18000100 [ write sol
count=256 ]
[ 7196.212335] cx23885[0]:   iq 7: 0x21e1bf00 [ arg #1 ]
[ 7196.212345] cx23885[0]:   iq 8: 0x00000000 [ arg #2 ]
[ 7196.212354] cx23885[0]:   (0x00010424) iq 9: 0x00000000 [ INVALID count=0 ]
[ 7196.212367] cx23885[0]:   (0x00010428) iq a: 0x1c0002f0 [ write sol
eol count=752 ]
[ 7196.212384] cx23885[0]:   iq b: 0x21e1b340 [ arg #1 ]
[ 7196.212394] cx23885[0]:   iq c: 0x00000000 [ arg #2 ]
[ 7196.212402] cx23885[0]:   (0x00010434) iq d: 0x1c0002f0 [ write sol
eol count=752 ]
[ 7196.212418] cx23885[0]:   iq e: 0x21e1b630 [ arg #1 ]
[ 7196.212427] cx23885[0]:   iq f: 0x00000000 [ arg #2 ]
[ 7196.212434] cx23885[0]: fifo: 0x00005000 -> 0x6000
[ 7196.212441] cx23885[0]: ctrl: 0x00010400 -> 0x10460
[ 7196.212451] cx23885[0]:   ptr1_reg: 0x00005ea0
[ 7196.212458] cx23885[0]:   ptr2_reg: 0x000105c8
[ 7196.212465] cx23885[0]:   cnt1_reg: 0x0000002e
[ 7196.212474] cx23885[0]:   cnt2_reg: 0x00000001
[ 7494.003932] cx23885[0]: mpeg risc op code error
[ 7494.003975] cx23885[0]: TS1 B - dma channel status dump
[ 7494.003988] cx23885[0]:   cmds: init risc lo   : 0x11052000
[ 7494.003997] cx23885[0]:   cmds: init risc hi   : 0x00000000
[ 7494.004006] cx23885[0]:   cmds: cdt base       : 0x00010580
[ 7494.004015] cx23885[0]:   cmds: cdt size       : 0x0000000a
[ 7494.004025] cx23885[0]:   cmds: iq base        : 0x00010400
[ 7494.004034] cx23885[0]:   cmds: iq size        : 0x00000010
[ 7494.004043] cx23885[0]:   cmds: risc pc lo     : 0x11052018
[ 7494.004051] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[ 7494.004060] cx23885[0]:   cmds: iq wr ptr      : 0x00004106
[ 7494.004069] cx23885[0]:   cmds: iq rd ptr      : 0x00004100
[ 7494.004078] cx23885[0]:   cmds: cdt current    : 0x00010588
[ 7494.004089] cx23885[0]:   cmds: pci target lo  : 0x2c2ed0a0
[ 7494.004097] cx23885[0]:   cmds: pci target hi  : 0x00000000
[ 7494.004106] cx23885[0]:   cmds: line / byte    : 0x01d60000
[ 7494.004114] cx23885[0]:   risc0: 0x140000a0 [ write eol count=160 ]
[ 7494.004130] cx23885[0]:   risc1: 0x2c2ed000 [ skip sol eol 21 19 18
cnt1 resync 14 12 count=0 ]
[ 7494.004156] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[ 7494.004168] cx23885[0]:   risc3: 0x1c0002f0 [ write sol eol count=752 ]
[ 7494.004184] cx23885[0]:   (0x00010400) iq 0: 0x1c0002f0 [ write sol
eol count=752 ]
[ 7494.004201] cx23885[0]:   iq 1: 0x2c2ed390 [ arg #1 ]
[ 7494.004210] cx23885[0]:   iq 2: 0x00000000 [ arg #2 ]
[ 7494.004218] cx23885[0]:   (0x0001040c) iq 3: 0x1c0002f0 [ write sol
eol count=752 ]
[ 7494.004235] cx23885[0]:   iq 4: 0x2c2ed680 [ arg #1 ]
[ 7494.004244] cx23885[0]:   iq 5: 0x00000000 [ arg #2 ]
[ 7494.004253] cx23885[0]:   (0x00010418) iq 6: 0x2c2ecac0 [ skip sol
eol 21 19 18 cnt1 resync 14 count=2752 ]
[ 7494.004278] cx23885[0]:   (0x0001041c) iq 7: 0x00000000 [ INVALID count=0 ]
[ 7494.004290] cx23885[0]:   (0x00010420) iq 8: 0x18000250 [ write sol
count=592 ]
[ 7494.004304] cx23885[0]:   iq 9: 0x2c2ecdb0 [ arg #1 ]
[ 7494.004313] cx23885[0]:   iq a: 0x00000000 [ arg #2 ]
[ 7494.004322] cx23885[0]:   (0x0001042c) iq b: 0x140000a0 [ write eol
count=160 ]
[ 7494.004338] cx23885[0]:   iq c: 0x2c2ed000 [ arg #1 ]
[ 7494.004347] cx23885[0]:   iq d: 0x00000000 [ arg #2 ]
[ 7494.004355] cx23885[0]:   (0x00010438) iq e: 0x1c0002f0 [ write sol
eol count=752 ]
[ 7494.004371] cx23885[0]:   iq f: 0x2c2ed0a0 [ arg #1 ]
[ 7494.004379] cx23885[0]:   iq 10: 0xfaab715b [ arg #2 ]
[ 7494.004385] cx23885[0]: fifo: 0x00005000 -> 0x6000
[ 7494.004392] cx23885[0]: ctrl: 0x00010400 -> 0x10460
[ 7494.004400] cx23885[0]:   ptr1_reg: 0x000053a0
[ 7494.004409] cx23885[0]:   ptr2_reg: 0x00010598
[ 7494.004417] cx23885[0]:   cnt1_reg: 0x0000000b
[ 7494.004425] cx23885[0]:   cnt2_reg: 0x00000007
[ 7494.004508] cx23885[0]: mpeg risc op code error
[ 7494.004518] cx23885[0]: TS1 B - dma channel status dump
[ 7494.004528] cx23885[0]:   cmds: init risc lo   : 0x11052000
[ 7494.004538] cx23885[0]:   cmds: init risc hi   : 0x00000000
[ 7494.004547] cx23885[0]:   cmds: cdt base       : 0x00010580
[ 7494.004555] cx23885[0]:   cmds: cdt size       : 0x0000000a
[ 7494.004563] cx23885[0]:   cmds: iq base        : 0x00010400
[ 7494.004573] cx23885[0]:   cmds: iq size        : 0x00000010
[ 7494.004582] cx23885[0]:   cmds: risc pc lo     : 0x11052018
[ 7494.004592] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[ 7494.004602] cx23885[0]:   cmds: iq wr ptr      : 0x00004106
[ 7494.004612] cx23885[0]:   cmds: iq rd ptr      : 0x00004100
[ 7494.004621] cx23885[0]:   cmds: cdt current    : 0x00010588
[ 7494.004630] cx23885[0]:   cmds: pci target lo  : 0x2c2ed0a0
[ 7494.004640] cx23885[0]:   cmds: pci target hi  : 0x00000000
[ 7494.004649] cx23885[0]:   cmds: line / byte    : 0x01d60000
[ 7494.004657] cx23885[0]:   risc0: 0x140000a0 [ write eol count=160 ]
[ 7494.004672] cx23885[0]:   risc1: 0x2c2ed000 [ skip sol eol 21 19 18
cnt1 resync 14 12 count=0 ]
[ 7494.004697] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[ 7494.004708] cx23885[0]:   risc3: 0x1c0002f0 [ write sol eol count=752 ]
[ 7494.004725] cx23885[0]:   (0x00010400) iq 0: 0x1c0002f0 [ write sol
eol count=752 ]
[ 7494.004743] cx23885[0]:   iq 1: 0x2c2ed390 [ arg #1 ]
[ 7494.004753] cx23885[0]:   iq 2: 0x00000000 [ arg #2 ]
[ 7494.004761] cx23885[0]:   (0x0001040c) iq 3: 0x1c0002f0 [ write sol
eol count=752 ]
[ 7494.004777] cx23885[0]:   iq 4: 0x2c2ed680 [ arg #1 ]
[ 7494.004785] cx23885[0]:   iq 5: 0x00000000 [ arg #2 ]
[ 7494.004793] cx23885[0]:   (0x00010418) iq 6: 0x2c2ecac0 [ skip sol
eol 21 19 18 cnt1 resync 14 count=2752 ]
[ 7494.004818] cx23885[0]:   (0x0001041c) iq 7: 0x00000000 [ INVALID count=0 ]
[ 7494.004831] cx23885[0]:   (0x00010420) iq 8: 0x18000250 [ write sol
count=592 ]
[ 7494.004848] cx23885[0]:   iq 9: 0x2c2ecdb0 [ arg #1 ]
[ 7494.004855] cx23885[0]:   iq a: 0x00000000 [ arg #2 ]
[ 7494.004862] cx23885[0]:   (0x0001042c) iq b: 0x140000a0 [ write eol
count=160 ]
[ 7494.004874] cx23885[0]:   iq c: 0x2c2ed000 [ arg #1 ]
[ 7494.004881] cx23885[0]:   iq d: 0x00000000 [ arg #2 ]
[ 7494.004887] cx23885[0]:   (0x00010438) iq e: 0x1c0002f0 [ write sol
eol count=752 ]
[ 7494.004900] cx23885[0]:   iq f: 0x2c2ed0a0 [ arg #1 ]
[ 7494.004908] cx23885[0]:   iq 10: 0xfaab715b [ arg #2 ]
[ 7494.004913] cx23885[0]: fifo: 0x00005000 -> 0x6000
[ 7494.004918] cx23885[0]: ctrl: 0x00010400 -> 0x10460
[ 7494.004924] cx23885[0]:   ptr1_reg: 0x000053a0
[ 7494.004931] cx23885[0]:   ptr2_reg: 0x00010598
[ 7494.004937] cx23885[0]:   cnt1_reg: 0x0000000b
[ 7494.004944] cx23885[0]:   cnt2_reg: 0x00000007
[ 8235.021176] cx23885[0]: mpeg risc op code error
[ 8235.021213] cx23885[0]: TS1 B - dma channel status dump
[ 8235.021226] cx23885[0]:   cmds: init risc lo   : 0x18bb4000
[ 8235.021235] cx23885[0]:   cmds: init risc hi   : 0x00000000
[ 8235.021244] cx23885[0]:   cmds: cdt base       : 0x00010580
[ 8235.021252] cx23885[0]:   cmds: cdt size       : 0x0000000a
[ 8235.021261] cx23885[0]:   cmds: iq base        : 0x00010400
[ 8235.021269] cx23885[0]:   cmds: iq size        : 0x00000010
[ 8235.021278] cx23885[0]:   cmds: risc pc lo     : 0x10d49018
[ 8235.021287] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[ 8235.021294] cx23885[0]:   cmds: iq wr ptr      : 0x00004106
[ 8235.021302] cx23885[0]:   cmds: iq rd ptr      : 0x00004109
[ 8235.021310] cx23885[0]:   cmds: cdt current    : 0x000105b8
[ 8235.021318] cx23885[0]:   cmds: pci target lo  : 0x10e5f530
[ 8235.021326] cx23885[0]:   cmds: pci target hi  : 0x00000000
[ 8235.021335] cx23885[0]:   cmds: line / byte    : 0x023d0000
[ 8235.021343] cx23885[0]:   risc0: 0x1c0002f0 [ write sol eol count=752 ]
[ 8235.021359] cx23885[0]:   risc1: 0x10e5f530 [ write 23 22 21 18
cnt0 resync 14 13 12 count=1328 ]
[ 8235.021382] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[ 8235.021394] cx23885[0]:   risc3: 0x1c0002f0 [ write sol eol count=752 ]
[ 8235.021410] cx23885[0]:   (0x00010400) iq 0: 0x1c0002f0 [ write sol
eol count=752 ]
[ 8235.021427] cx23885[0]:   iq 1: 0x10e3e000 [ arg #1 ]
[ 8235.021436] cx23885[0]:   iq 2: 0x00000000 [ arg #2 ]
[ 8235.021445] cx23885[0]:   (0x0001040c) iq 3: 0x1c0002f0 [ write sol
eol count=752 ]
[ 8235.021461] cx23885[0]:   iq 4: 0x10e3e2f0 [ arg #1 ]
[ 8235.021469] cx23885[0]:   iq 5: 0x00000000 [ arg #2 ]
[ 8235.021477] cx23885[0]:   (0x00010418) iq 6: 0x1c0002f0 [ write sol
eol count=752 ]
[ 8235.021493] cx23885[0]:   iq 7: 0x10e5f530 [ arg #1 ]
[ 8235.021502] cx23885[0]:   iq 8: 0x00000000 [ arg #2 ]
[ 8235.021510] cx23885[0]:   (0x00010424) iq 9: 0x1c0002f0 [ write sol
eol count=752 ]
[ 8235.021526] cx23885[0]:   iq a: 0x10e5f820 [ arg #1 ]
[ 8235.021536] cx23885[0]:   iq b: 0x00000000 [ arg #2 ]
[ 8235.021544] cx23885[0]:   (0x00010430) iq c: 0x1c0002f0 [ write sol
eol count=752 ]
[ 8235.021562] cx23885[0]:   iq d: 0x10e5fb10 [ arg #1 ]
[ 8235.021572] cx23885[0]:   iq e: 0x00000000 [ arg #2 ]
[ 8235.021582] cx23885[0]:   (0x0001043c) iq f: 0x71010000 [ jump irq1
cnt0 count=0 ]
[ 8235.021602] cx23885[0]:   iq 10: 0xfaab715b [ arg #1 ]
[ 8235.021614] cx23885[0]:   iq 11: 0x2fb39dda [ arg #2 ]
[ 8235.021622] cx23885[0]: fifo: 0x00005000 -> 0x6000
[ 8235.021629] cx23885[0]: ctrl: 0x00010400 -> 0x10460
[ 8235.021638] cx23885[0]:   ptr1_reg: 0x00005980
[ 8235.021648] cx23885[0]:   ptr2_reg: 0x000105b8
[ 8235.021657] cx23885[0]:   cnt1_reg: 0x0000000b
[ 8235.021665] cx23885[0]:   cnt2_reg: 0x00000003

I have some questions:

1. How can I test it better? Any debug option?
2. Is there any stable driver version? Is there any "easy" way to get
it updated? (compile, repository...)
3. I search on s2-liplianin and there are some cx23885 fixes, how can I test it?

Thanks for all your help, regards.

-- 
Josu Lazkano
