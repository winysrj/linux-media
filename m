Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.academica.fi ([109.75.228.249]:33738 "EHLO
	smtp41.academica.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbbGAJLG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jul 2015 05:11:06 -0400
Message-ID: <5593AEA6.7020901@iki.fi>
Date: Wed, 01 Jul 2015 12:11:02 +0300
From: Jouni Karvo <Jouni.Karvo@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: cx23885 risc op code error with DvbSKY T982
References: <55870014.90902@iki.fi> <5587D8A5.70905@iki.fi> <5587DB9F.4020008@gmail.com> <55911239.4000709@iki.fi>
In-Reply-To: <55911239.4000709@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

29.06.2015, 12:39, Jouni Karvo kirjoitti:
> 22.06.2015, 12:55, Tycho Lürsen kirjoitti:
>> I've got a couple of T982 cards. Running Debian Jessie, with kernel 
>> 4.1-rc8, I cannot reproduce your errors.
>> Only difference might be:
>> I synced the silabs drivers with upstream and used the patch from:
>
> hi,
>
> I tested with 4.1.0 (which produced the errors.  4.1.0 with 
> media_build produced the errors.  I did not test that with the patch, 
> as because of another kernel bug (in mdraid) I switched to 4.0.6.
>
> With 4.0.6 this error does not seem to happen with neither card.

Just as I reported, it happened.  Then I got the media_build driver from 
Jun 25 (which seems to include the IF selection patch), and there it 
happens again...

Jun 30 21:16:40 xpc kernel: [11870.833240] cx23885[1]: mpeg risc op code 
error
Jun 30 21:16:40 xpc kernel: [11870.833244] cx23885[1]: TS1 B - dma 
channel status dump
Jun 30 21:16:40 xpc kernel: [11870.833247] cx23885[1]:   cmds: init risc 
lo   : 0x924d0000
Jun 30 21:16:40 xpc kernel: [11870.833248] cx23885[1]:   cmds: init risc 
hi   : 0x00000000
Jun 30 21:16:40 xpc kernel: [11870.833250] cx23885[1]:   cmds: cdt 
base       : 0x00010580
Jun 30 21:16:40 xpc kernel: [11870.833252] cx23885[1]:   cmds: cdt 
size       : 0x0000000a
Jun 30 21:16:40 xpc kernel: [11870.833254] cx23885[1]:   cmds: iq 
base        : 0x00010400
Jun 30 21:16:40 xpc kernel: [11870.833256] cx23885[1]:   cmds: iq 
size        : 0x00000010
Jun 30 21:16:40 xpc kernel: [11870.833257] cx23885[1]:   cmds: risc pc 
lo     : 0x924d000c
Jun 30 21:16:40 xpc kernel: [11870.833259] cx23885[1]:   cmds: risc pc 
hi     : 0x00000000
Jun 30 21:16:40 xpc kernel: [11870.833261] cx23885[1]:   cmds: iq wr 
ptr      : 0x00004103
Jun 30 21:16:40 xpc kernel: [11870.833263] cx23885[1]:   cmds: iq rd 
ptr      : 0x00004100
Jun 30 21:16:40 xpc kernel: [11870.833264] cx23885[1]:   cmds: cdt 
current    : 0x000105c8
Jun 30 21:16:40 xpc kernel: [11870.833266] cx23885[1]:   cmds: pci 
target lo  : 0xaed882f0
Jun 30 21:16:40 xpc kernel: [11870.833268] cx23885[1]:   cmds: pci 
target hi  : 0x00000000
Jun 30 21:16:40 xpc kernel: [11870.833270] cx23885[1]:   cmds: line / 
byte    : 0x01610000
Jun 30 21:16:40 xpc kernel: [11870.833272] cx23885[1]:   risc0: 
0x1c0002f0 [ write sol eol count=752 ]
Jun 30 21:16:40 xpc kernel: [11870.833275] cx23885[1]:   risc1: 
0xaed882f0 [ readc sol eol irq2 23 22 20 19 resync count=752 ]
Jun 30 21:16:40 xpc kernel: [11870.833279] cx23885[1]:   risc2: 
0x00000000 [ INVALID count=0 ]
Jun 30 21:16:40 xpc kernel: [11870.833281] cx23885[1]:   risc3: 
0x1c0002f0 [ write sol eol count=752 ]
Jun 30 21:16:40 xpc kernel: [11870.833284] cx23885[1]: (0x00010400) iq 
0: 0x80200080 [ sync 21 count=128 ]
Jun 30 21:16:40 xpc kernel: [11870.833286] cx23885[1]: (0x00010404) iq 
1: 0x87ff3140 [ sync eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 13 12 
count=320 ]
Jun 30 21:16:40 xpc kernel: [11870.833291] cx23885[1]: (0x00010408) iq 
2: 0x01000000 [ INVALID irq1 count=0 ]
Jun 30 21:16:40 xpc kernel: [11870.833293] cx23885[1]: (0x0001040c) iq 
3: 0x00000000 [ INVALID count=0 ]
Jun 30 21:16:40 xpc kernel: [11870.833295] cx23885[1]: (0x00010410) iq 
4: 0x1c0002f0 [ write sol eol count=752 ]
Jun 30 21:16:40 xpc kernel: [11870.833298] cx23885[1]:   iq 5: 
0xaed88bc0 [ arg #1 ]
Jun 30 21:16:40 xpc kernel: [11870.833300] cx23885[1]:   iq 6: 
0x00000000 [ arg #2 ]
Jun 30 21:16:40 xpc kernel: [11870.833301] cx23885[1]: (0x0001041c) iq 
7: 0x71000000 [ jump irq1 count=0 ]
Jun 30 21:16:40 xpc kernel: [11870.833304] cx23885[1]:   iq 8: 
0x1c0002f0 [ arg #1 ]
Jun 30 21:16:40 xpc kernel: [11870.833306] cx23885[1]:   iq 9: 
0xaed88000 [ arg #2 ]
Jun 30 21:16:40 xpc kernel: [11870.833307] cx23885[1]: (0x00010428) iq 
a: 0x00000000 [ INVALID count=0 ]
Jun 30 21:16:40 xpc kernel: [11870.833309] cx23885[1]: (0x0001042c) iq 
b: 0x1c0002f0 [ write sol eol count=752 ]
Jun 30 21:16:40 xpc kernel: [11870.833312] cx23885[1]:   iq c: 
0xaed882f0 [ arg #1 ]
Jun 30 21:16:40 xpc kernel: [11870.833314] cx23885[1]:   iq d: 
0x00000000 [ arg #2 ]
Jun 30 21:16:40 xpc kernel: [11870.833315] cx23885[1]: (0x00010438) iq 
e: 0x1c0002f0 [ write sol eol count=752 ]
Jun 30 21:16:40 xpc kernel: [11870.833318] cx23885[1]:   iq f: 
0xaed885e0 [ arg #1 ]
Jun 30 21:16:40 xpc kernel: [11870.833320] cx23885[1]:   iq 10: 
0x9beae2ae [ arg #2 ]
Jun 30 21:16:40 xpc kernel: [11870.833320] cx23885[1]: fifo: 0x00005000 
-> 0x6000
Jun 30 21:16:40 xpc kernel: [11870.833321] cx23885[1]: ctrl: 0x00010400 
-> 0x10460
Jun 30 21:16:40 xpc kernel: [11870.833323] cx23885[1]:   ptr1_reg: 
0x00005bf0
Jun 30 21:16:40 xpc kernel: [11870.833325] cx23885[1]:   ptr2_reg: 
0x000105c8
Jun 30 21:16:40 xpc kernel: [11870.833326] cx23885[1]:   cnt1_reg: 
0x00000003
Jun 30 21:16:40 xpc kernel: [11870.833328] cx23885[1]:   cnt2_reg: 
0x00000001

