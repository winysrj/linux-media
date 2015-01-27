Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63483 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbbA0Klb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 05:41:31 -0500
Received: by mail-lb0-f182.google.com with SMTP id l4so12304793lbv.13
        for <linux-media@vger.kernel.org>; Tue, 27 Jan 2015 02:41:29 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 27 Jan 2015 10:41:29 +0000
Message-ID: <CADBe_Tv3ijpsaS7Uy0XdAR+vz3mCL-qksuyZGwknrQCV6EAn+Q@mail.gmail.com>
Subject: cx23885 / DVBSky T9580: mpeg risc op code error
From: Mark Clarkstone <hello@markclarkstone.co.uk>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey folks,

I seem to keep getting the this error after a day or two with my DVBSky T9580.

The card appears to keep working regardless of the error but
unfortunately whenever this occurs the Sky (UK)+ HD box downstairs
goes completely bonkers (poor signal, blocking etc) until I tune to a
service or restart the box. I'm only guessing here but I think
whenever this happens the card must be sending some weird voltage to
the dish interfering with the STB.

dmesg output snip:

[  641.339516] cx23885[0]: mpeg risc op code error
[  641.339573] cx23885[0]: TS2 C - dma channel status dump
[  641.339580] cx23885[0]:   cmds: init risc lo   : 0xb6b8f000
[  641.339586] cx23885[0]:   cmds: init risc hi   : 0x00000000
[  641.339592] cx23885[0]:   cmds: cdt base       : 0x000105e0
[  641.339597] cx23885[0]:   cmds: cdt size       : 0x0000000a
[  641.339603] cx23885[0]:   cmds: iq base        : 0x00010440
[  641.339608] cx23885[0]:   cmds: iq size        : 0x00000010
[  641.339613] cx23885[0]:   cmds: risc pc lo     : 0xb6b8f008
[  641.339618] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[  641.339623] cx23885[0]:   cmds: iq wr ptr      : 0x00004112
[  641.339629] cx23885[0]:   cmds: iq rd ptr      : 0x00004110
[  641.339634] cx23885[0]:   cmds: cdt current    : 0x00010618
[  641.339639] cx23885[0]:   cmds: pci target lo  : 0xb7a51490
[  641.339644] cx23885[0]:   cmds: pci target hi  : 0x00000000
[  641.339649] cx23885[0]:   cmds: line / byte    : 0x01070000
[  641.339654] cx23885[0]:   risc0: 0x1c0002f0 [ write sol eol count=752 ]
[  641.339664] cx23885[0]:   risc1: 0xb7a51490 [ writerm eol irq2 irq1
23 21 18 cnt0 12 count=1168 ]
[  641.339676] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[  641.339682] cx23885[0]:   risc3: 0x1c0002f0 [ write sol eol count=752 ]
[  641.339690] cx23885[0]:   (0x00010440) iq 0: 0x5d771378 [ writec
sol eol irq1 22 21 20 18 cnt1 cnt0 12 count=888 ]
[  641.339703] cx23885[0]:   (0x00010444) iq 1: 0xe09717e2 [ INVALID
23 20 18 cnt1 cnt0 12 count=2018 ]
[  641.339713] cx23885[0]:   (0x00010448) iq 2: 0xb7a51780 [ writerm
eol irq2 irq1 23 21 18 cnt0 12 count=1920 ]
[  641.339725] cx23885[0]:   iq 3: 0x00000000 [ arg #1 ]
[  641.339730] cx23885[0]:   iq 4: 0x1c0002f0 [ arg #2 ]
[  641.339735] cx23885[0]:   (0x00010454) iq 5: 0xb7a51a70 [ writerm
eol irq2 irq1 23 21 18 cnt0 12 count=2672 ]
[  641.339747] cx23885[0]:   iq 6: 0x00000000 [ arg #1 ]
[  641.339752] cx23885[0]:   iq 7: 0x1c0002f0 [ arg #2 ]
[  641.339757] cx23885[0]:   (0x00010460) iq 8: 0xb7a51d60 [ writerm
eol irq2 irq1 23 21 18 cnt0 12 count=3424 ]
[  641.339769] cx23885[0]:   iq 9: 0x00000000 [ arg #1 ]
[  641.339774] cx23885[0]:   iq a: 0x00000000 [ arg #2 ]
[  641.339779] cx23885[0]:   (0x0001046c) iq b: 0x1c0002f0 [ write sol
eol count=752 ]
[  641.339787] cx23885[0]:   iq c: 0xb7a511a0 [ arg #1 ]
[  641.339791] cx23885[0]:   iq d: 0x00000000 [ arg #2 ]
[  641.339796] cx23885[0]:   (0x00010478) iq e: 0x1c0002f0 [ write sol
eol count=752 ]
[  641.339804] cx23885[0]:   iq f: 0xb7a51490 [ arg #1 ]
[  641.339810] cx23885[0]:   iq 10: 0xd8ceeaa3 [ arg #2 ]
[  641.339813] cx23885[0]: fifo: 0x00006000 -> 0x7000
[  641.339816] cx23885[0]: ctrl: 0x00010440 -> 0x104a0
[  641.339821] cx23885[0]:   ptr1_reg: 0x000068d0
[  641.339826] cx23885[0]:   ptr2_reg: 0x00010618
[  641.339830] cx23885[0]:   cnt1_reg: 0x00000000
[  641.339835] cx23885[0]:   cnt2_reg: 0x00000003
[34157.452715] perf interrupt took too long (2510 > 2500), lowering
kernel.perf_event_max_sample_rate to 50000

Full log here: http://sprunge.us/KPXS

Any help or assistance would greatly be received!

Cheers.
