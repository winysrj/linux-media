Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.academica.fi ([109.75.228.249]:44629 "EHLO
	smtp41.academica.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbbFVJnE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 05:43:04 -0400
Received: from localhost (localhost [IPv6:::1])
	by smtp41.academica.fi (Postfix) with ESMTP id ED16F6020A
	for <linux-media@vger.kernel.org>; Mon, 22 Jun 2015 12:43:02 +0300 (EEST)
Received: from smtp41.academica.fi ([127.0.0.1])
	by localhost (smtp41.academica.fi [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NlPul0A5luAa for <linux-media@vger.kernel.org>;
	Mon, 22 Jun 2015 12:43:02 +0300 (EEST)
Received: from [192.168.2.157] (host-109-75-226-21.igua.fi [109.75.226.21])
	by smtp41.academica.fi (Postfix) with ESMTP id 0A707601FA
	for <linux-media@vger.kernel.org>; Mon, 22 Jun 2015 12:43:02 +0300 (EEST)
Message-ID: <5587D8A5.70905@iki.fi>
Date: Mon, 22 Jun 2015 12:43:01 +0300
From: Jouni Karvo <Jouni.Karvo@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cx23885 risc op code error with DvbSKY T982
References: <55870014.90902@iki.fi>
In-Reply-To: <55870014.90902@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

21.06.2015, 21:19, Jouni Karvo kirjoitti:
> I have dvbsky T982.  The firmware is up to date from openelec site. 
> Nothing on the CI slot
>
(actually, the empty CI-slot belongs to another card)

A couple of more of these for the same card.  Unless someone shows 
interest on these, this is the last one I'll send on the list on this 
card/error.

Jun 22 11:48:36 xpc kernel: [78360.929167] cx23885[0]: mpeg risc op code 
error
Jun 22 11:48:36 xpc kernel: [78360.929172] cx23885[0]: TS1 B - dma 
channel status dump
Jun 22 11:48:36 xpc kernel: [78360.929175] cx23885[0]:   cmds: init risc 
lo   : 0x06a26000
Jun 22 11:48:36 xpc kernel: [78360.929177] cx23885[0]:   cmds: init risc 
hi   : 0x00000000
Jun 22 11:48:36 xpc kernel: [78360.929182] cx23885[0]:   cmds: cdt 
base       : 0x00010580
Jun 22 11:48:36 xpc kernel: [78360.929184] cx23885[0]:   cmds: cdt 
size       : 0x0000000a
Jun 22 11:48:36 xpc kernel: [78360.929187] cx23885[0]:   cmds: iq 
base        : 0x00010400
Jun 22 11:48:36 xpc kernel: [78360.929189] cx23885[0]:   cmds: iq 
size        : 0x00000010
Jun 22 11:48:36 xpc kernel: [78360.929193] cx23885[0]:   cmds: risc pc 
lo     : 0x06a26004
Jun 22 11:48:36 xpc kernel: [78360.929198] cx23885[0]:   cmds: risc pc 
hi     : 0x00000000
Jun 22 11:48:36 xpc kernel: [78360.929200] cx23885[0]:   cmds: iq wr 
ptr      : 0x00004101
Jun 22 11:48:36 xpc kernel: [78360.929202] cx23885[0]:   cmds: iq rd 
ptr      : 0x00004100
Jun 22 11:48:36 xpc kernel: [78360.929204] cx23885[0]:   cmds: cdt 
current    : 0x00010598
Jun 22 11:48:36 xpc kernel: [78360.929207] cx23885[0]:   cmds: pci 
target lo  : 0x2e71c2f0
Jun 22 11:48:36 xpc kernel: [78360.929209] cx23885[0]:   cmds: pci 
target hi  : 0x00000000
Jun 22 11:48:36 xpc kernel: [78360.929211] cx23885[0]:   cmds: line / 
byte    : 0x01810000
Jun 22 11:48:36 xpc kernel: [78360.929215] cx23885[0]:   risc0: 
0x1c0002f0 [ write sol eol count=752 ]
Jun 22 11:48:36 xpc kernel: [78360.929220] cx23885[0]:   risc1: 
0x2e71c2f0 [ skip sol eol irq2 22 21 20 cnt0 resync 14 count=752 ]
Jun 22 11:48:36 xpc kernel: [78360.929226] cx23885[0]:   risc2: 
0x00000000 [ INVALID count=0 ]
Jun 22 11:48:36 xpc kernel: [78360.929229] cx23885[0]:   risc3: 
0x1c0002f0 [ write sol eol count=752 ]
Jun 22 11:48:36 xpc kernel: [78360.929233] cx23885[0]: (0x00010400) iq 
0: 0x0660d080 [ INVALID eol irq2 22 21 resync 14 12 count=128 ]
Jun 22 11:48:36 xpc kernel: [78360.929238] cx23885[0]: (0x00010404) iq 
1: 0x2e71c2f0 [ skip sol eol irq2 22 21 20 cnt0 resync 14 count=752 ]
Jun 22 11:48:36 xpc kernel: [78360.929243] cx23885[0]: (0x00010408) iq 
2: 0x00000000 [ INVALID count=0 ]
Jun 22 11:48:36 xpc kernel: [78360.929246] cx23885[0]: (0x0001040c) iq 
3: 0x1c0002f0 [ write sol eol count=752 ]
Jun 22 11:48:36 xpc kernel: [78360.929251] cx23885[0]:   iq 4: 
0x2e71c5e0 [ arg #1 ]
Jun 22 11:48:36 xpc kernel: [78360.929253] cx23885[0]:   iq 5: 
0x00000000 [ arg #2 ]
Jun 22 11:48:36 xpc kernel: [78360.929256] cx23885[0]: (0x00010418) iq 
6: 0x1c0002f0 [ write sol eol count=752 ]
Jun 22 11:48:36 xpc kernel: [78360.929260] cx23885[0]:   iq 7: 
0x2e71c8d0 [ arg #1 ]
Jun 22 11:48:36 xpc kernel: [78360.929264] cx23885[0]:   iq 8: 
0x00000000 [ arg #2 ]
Jun 22 11:48:36 xpc kernel: [78360.929267] cx23885[0]: (0x00010424) iq 
9: 0x1c0002f0 [ write sol eol count=752 ]
Jun 22 11:48:36 xpc kernel: [78360.929270] cx23885[0]:   iq a: 
0x2e71cbc0 [ arg #1 ]
Jun 22 11:48:36 xpc kernel: [78360.929272] cx23885[0]:   iq b: 
0x00000000 [ arg #2 ]
Jun 22 11:48:36 xpc kernel: [78360.929274] cx23885[0]: (0x00010430) iq 
c: 0x71000000 [ jump irq1 count=0 ]
Jun 22 11:48:36 xpc kernel: [78360.929278] cx23885[0]:   iq d: 
0x1c0002f0 [ arg #1 ]
Jun 22 11:48:36 xpc kernel: [78360.929280] cx23885[0]:   iq e: 
0x2e71c000 [ arg #2 ]
Jun 22 11:48:36 xpc kernel: [78360.929282] cx23885[0]: (0x0001043c) iq 
f: 0x00000000 [ INVALID count=0 ]
Jun 22 11:48:36 xpc kernel: [78360.929283] cx23885[0]: fifo: 0x00005000 
-> 0x6000
Jun 22 11:48:36 xpc kernel: [78360.929284] cx23885[0]: ctrl: 0x00010400 
-> 0x10460
Jun 22 11:48:36 xpc kernel: [78360.929287] cx23885[0]:   ptr1_reg: 
0x00005320
Jun 22 11:48:36 xpc kernel: [78360.929289] cx23885[0]:   ptr2_reg: 
0x00010598
Jun 22 11:48:36 xpc kernel: [78360.929291] cx23885[0]:   cnt1_reg: 
0x00000003
Jun 22 11:48:36 xpc kernel: [78360.929293] cx23885[0]:   cnt2_reg: 
0x00000007

Jun 22 12:28:30 xpc kernel: [80750.504214] cx23885[0]: mpeg risc op code 
error
Jun 22 12:28:30 xpc kernel: [80750.504219] cx23885[0]: TS1 B - dma 
channel status dump
Jun 22 12:28:30 xpc kernel: [80750.504221] cx23885[0]:   cmds: init risc 
lo   : 0x2e6d8000
Jun 22 12:28:30 xpc kernel: [80750.504223] cx23885[0]:   cmds: init risc 
hi   : 0x00000000
Jun 22 12:28:30 xpc kernel: [80750.504225] cx23885[0]:   cmds: cdt 
base       : 0x00010580
Jun 22 12:28:30 xpc kernel: [80750.504227] cx23885[0]:   cmds: cdt 
size       : 0x0000000a
Jun 22 12:28:30 xpc kernel: [80750.504228] cx23885[0]:   cmds: iq 
base        : 0x00010400
Jun 22 12:28:30 xpc kernel: [80750.504230] cx23885[0]:   cmds: iq 
size        : 0x00000010
Jun 22 12:28:30 xpc kernel: [80750.504232] cx23885[0]:   cmds: risc pc 
lo     : 0x2e6d8004
Jun 22 12:28:30 xpc kernel: [80750.504234] cx23885[0]:   cmds: risc pc 
hi     : 0x00000000
Jun 22 12:28:30 xpc kernel: [80750.504236] cx23885[0]:   cmds: iq wr 
ptr      : 0x00004101
Jun 22 12:28:30 xpc kernel: [80750.504237] cx23885[0]:   cmds: iq rd 
ptr      : 0x00004100
Jun 22 12:28:30 xpc kernel: [80750.504239] cx23885[0]:   cmds: cdt 
current    : 0x000105a8
Jun 22 12:28:30 xpc kernel: [80750.504241] cx23885[0]:   cmds: pci 
target lo  : 0x465802f0
Jun 22 12:28:30 xpc kernel: [80750.504243] cx23885[0]:   cmds: pci 
target hi  : 0x00000000
Jun 22 12:28:30 xpc kernel: [80750.504245] cx23885[0]:   cmds: line / 
byte    : 0x00c10000
Jun 22 12:28:30 xpc kernel: [80750.504246] cx23885[0]:   risc0: 
0x1c0002f0 [ write sol eol count=752 ]
Jun 22 12:28:30 xpc kernel: [80750.504250] cx23885[0]:   risc1: 
0x465802f0 [ INVALID eol irq2 22 20 19 count=752 ]
Jun 22 12:28:30 xpc kernel: [80750.504253] cx23885[0]:   risc2: 
0x00000000 [ INVALID count=0 ]
Jun 22 12:28:30 xpc kernel: [80750.504255] cx23885[0]:   risc3: 
0x1c0002f0 [ write sol eol count=752 ]
Jun 22 12:28:30 xpc kernel: [80750.504258] cx23885[0]: (0x00010400) iq 
0: 0x00000000 [ INVALID count=0 ]
Jun 22 12:28:30 xpc kernel: [80750.504260] cx23885[0]: (0x00010404) iq 
1: 0x00000000 [ INVALID count=0 ]
Jun 22 12:28:30 xpc kernel: [80750.504262] cx23885[0]: (0x00010408) iq 
2: 0x1c0002f0 [ write sol eol count=752 ]
Jun 22 12:28:30 xpc kernel: [80750.504264] cx23885[0]:   iq 3: 
0x465802f0 [ arg #1 ]
Jun 22 12:28:30 xpc kernel: [80750.504266] cx23885[0]:   iq 4: 
0x00000000 [ arg #2 ]
Jun 22 12:28:30 xpc kernel: [80750.504268] cx23885[0]: (0x00010414) iq 
5: 0x1c0002f0 [ write sol eol count=752 ]
Jun 22 12:28:30 xpc kernel: [80750.504270] cx23885[0]:   iq 6: 
0x465805e0 [ arg #1 ]
Jun 22 12:28:30 xpc kernel: [80750.504272] cx23885[0]:   iq 7: 
0x00000000 [ arg #2 ]
Jun 22 12:28:30 xpc kernel: [80750.504274] cx23885[0]: (0x00010420) iq 
8: 0x1c0002f0 [ write sol eol count=752 ]
Jun 22 12:28:30 xpc kernel: [80750.504276] cx23885[0]:   iq 9: 
0x465808d0 [ arg #1 ]
Jun 22 12:28:30 xpc kernel: [80750.504278] cx23885[0]:   iq a: 
0x00000000 [ arg #2 ]
Jun 22 12:28:30 xpc kernel: [80750.504280] cx23885[0]: (0x0001042c) iq 
b: 0x1c0002f0 [ write sol eol count=752 ]
Jun 22 12:28:30 xpc kernel: [80750.504282] cx23885[0]:   iq c: 
0x46580bc0 [ arg #1 ]
Jun 22 12:28:30 xpc kernel: [80750.504284] cx23885[0]:   iq d: 
0x00000000 [ arg #2 ]
Jun 22 12:28:30 xpc kernel: [80750.504286] cx23885[0]: (0x00010438) iq 
e: 0x71000000 [ jump irq1 count=0 ]
Jun 22 12:28:30 xpc kernel: [80750.504288] cx23885[0]:   iq f: 
0x1c0002f0 [ arg #1 ]
Jun 22 12:28:30 xpc kernel: [80750.504290] cx23885[0]:   iq 10: 
0x1c0002f0 [ arg #2 ]
Jun 22 12:28:30 xpc kernel: [80750.504291] cx23885[0]: fifo: 0x00005000 
-> 0x6000
Jun 22 12:28:30 xpc kernel: [80750.504291] cx23885[0]: ctrl: 0x00010400 
-> 0x10460
Jun 22 12:28:30 xpc kernel: [80750.504293] cx23885[0]:   ptr1_reg: 
0x00005610
Jun 22 12:28:30 xpc kernel: [80750.504295] cx23885[0]:   ptr2_reg: 
0x000105a8
Jun 22 12:28:30 xpc kernel: [80750.504296] cx23885[0]:   cnt1_reg: 
0x00000003
Jun 22 12:28:30 xpc kernel: [80750.504298] cx23885[0]:   cnt2_reg: 
0x00000005

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
