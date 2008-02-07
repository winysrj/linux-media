Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17NSiIi005470
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 18:28:44 -0500
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.251])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m17NSL2L020812
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 18:28:21 -0500
Received: by an-out-0708.google.com with SMTP id c31so1596158ana.124
	for <video4linux-list@redhat.com>; Thu, 07 Feb 2008 15:28:16 -0800 (PST)
Message-ID: <9c4b1d600802071528p70de4e55ud582ef66d9ebb3d7@mail.gmail.com>
Date: Thu, 7 Feb 2008 21:28:16 -0200
From: "Adrian Pardini" <pardo.bsso@gmail.com>
To: "hermann pitton" <hermann-pitton@arcor.de>
In-Reply-To: <1202421849.20032.25.camel@pc08.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9c4b1d600802071009q7fc69d4cj88c3ec2586e484a0@mail.gmail.com>
	<20080207173926.53b9e0ce@gaivota>
	<1202421849.20032.25.camel@pc08.localdom.local>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] New card entry (saa7134) and FM support for TNF9835
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

2008/2/7, hermann pitton <hermann-pitton@arcor.de>:

> here a saa7130 is said, and the wrong auto detection is for a saa7130.
> Then the TV section with amux = TV is wrong. The saa7130 can't decode
> anything from SIF. Only the TV mono section should be correct then.

Ok, I'll drop the other section but I get tv audio from both. The "AF
out" from the tuner goes directly to the pin "LEFT 1" of the saa7130.
Right 1, 2 and Left 2 go together with the video signal to a chip
without numbering (al least on the visible side, now I don't feel like
desoldering it to see behind)

> See the card=3 FlyVideo2000 to which yours is very close anyway,
> but else different enough for a new entry.

You are right, I used the FlyVideo3000 (card=2) just because it was
the first that worked fine.


> Please always send relevant "dmesg" for all card/tuner related when
> loading the driver.
dmesg output without the card= parameter:
---
Feb  4 20:19:49 virulazo kernel: [   36.294884] saa7130[0]: found at
0000:00:0c.0, rev: 1, irq: 11, latency: 64, mmio: 0xdffffc00
Feb  4 20:19:49 virulazo kernel: [   36.294959] saa7130[0]: subsystem:
1131:2004, board: Philips TOUGH DVB-T reference design
[card=61,autodetected]
Feb  4 20:19:49 virulazo kernel: [   36.295039] saa7130[0]: board
init: gpio is 571ff
Feb  4 20:19:49 virulazo kernel: [   36.447561] saa7130[0]: i2c eeprom
00: 31 11 04 20 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Feb  4 20:19:49 virulazo kernel: [   36.448904] saa7130[0]: i2c eeprom
10: 00 df 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
Feb  4 20:19:49 virulazo kernel: [   36.449795] saa7130[0]: i2c eeprom
20: 01 40 01 02 02 ff 01 03 08 ff 00 8f ff ff ff ff
Feb  4 20:19:49 virulazo kernel: [   36.451065] saa7130[0]: i2c eeprom
30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  4 20:19:49 virulazo kernel: [   36.452408] saa7130[0]: i2c eeprom
40: ff 87 00 c2 96 10 03 32 15 08 ff ff ff ff ff ff
Feb  4 20:19:49 virulazo kernel: [   36.453295] saa7130[0]: i2c eeprom
50: ff ff ff ff ff ff ff 41 83 ff 31 30 4d 4f 4f 4e
Feb  4 20:19:49 virulazo kernel: [   36.454596] saa7130[0]: i2c eeprom
60: 53 50 44 41 31 30 30 ff 41 ff ff ff ff ff ff ff
Feb  4 20:19:49 virulazo kernel: [   36.455456] saa7130[0]: i2c eeprom
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  4 20:19:49 virulazo kernel: [   36.466274] saa7130[0]: registered
device video0 [v4l2]
Feb  4 20:19:49 virulazo kernel: [   36.466401] saa7130[0]: registered
device vbi0
---

dmesg with card=132 parameter:
---
Feb  7 18:24:04 virulazo kernel: [   35.350727] Linux video capture
interface: v2.00
Feb  7 18:24:04 virulazo kernel: [   35.508345] saa7130/34: v4l2
driver version 0.2.14 loaded
Feb  7 18:24:04 virulazo kernel: [   35.508931] ACPI: PCI Interrupt
Link [LNKA] enabled at IRQ 11
Feb  7 18:24:04 virulazo kernel: [   35.508997] ACPI: PCI Interrupt
0000:00:0c.0[A] -> Link [LNKA] -> GSI 11 (level, low) ->
 IRQ 11
Feb  7 18:24:04 virulazo kernel: [   35.509143] saa7130[0]: found at
0000:00:0c.0, rev: 1, irq: 11, latency: 64, mmio: 0xdff
ffc00
Feb  7 18:24:04 virulazo kernel: [   35.509216] saa7130[0]: subsystem:
1131:2004, board: Genius TVGO AM11MCE [card=132,insmo
d option]
Feb  7 18:24:04 virulazo kernel: [   35.509292] saa7130[0]: board
init: gpio is 571ff
Feb  7 18:24:04 virulazo kernel: [   35.509483] input: saa7134 IR
(Genius TVGO AM11MCE as /class/input/input1
Feb  7 18:24:04 virulazo kernel: [   35.651756] saa7130[0]: i2c eeprom
00: 31 11 04 20 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Feb  7 18:24:04 virulazo kernel: [   35.652423] saa7130[0]: i2c eeprom
10: 00 df 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
Feb  7 18:24:04 virulazo kernel: [   35.653092] saa7130[0]: i2c eeprom
20: 01 40 01 02 02 ff 01 03 08 ff 00 8f ff ff ff ff
Feb  7 18:24:04 virulazo kernel: [   35.653760] saa7130[0]: i2c eeprom
30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  7 18:24:04 virulazo kernel: [   35.654412] saa7130[0]: i2c eeprom
40: ff 87 00 c2 96 10 03 32 15 08 ff ff ff ff ff ff
Feb  7 18:24:04 virulazo kernel: [   35.655075] saa7130[0]: i2c eeprom
50: ff ff ff ff ff ff ff 41 83 ff 31 30 4d 4f 4f 4e
Feb  7 18:24:04 virulazo kernel: [   35.655728] saa7130[0]: i2c eeprom
60: 53 50 44 41 31 30 30 ff 41 ff ff ff ff ff ff ff
Feb  7 18:24:04 virulazo kernel: [   35.656394] saa7130[0]: i2c eeprom
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  7 18:24:04 virulazo kernel: [   35.657062] saa7130[0]: i2c eeprom
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  7 18:24:04 virulazo kernel: [   35.657714] saa7130[0]: i2c eeprom
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  7 18:24:04 virulazo kernel: [   35.658383] saa7130[0]: i2c eeprom
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  7 18:24:04 virulazo kernel: [   35.659049] saa7130[0]: i2c eeprom
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  7 18:24:04 virulazo kernel: [   35.659701] saa7130[0]: i2c eeprom
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  7 18:24:04 virulazo kernel: [   35.660370] saa7130[0]: i2c eeprom
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  7 18:24:04 virulazo kernel: [   35.661038] saa7130[0]: i2c eeprom
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  7 18:24:04 virulazo kernel: [   35.661689] saa7130[0]: i2c eeprom
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  7 18:24:04 virulazo kernel: [   36.525537] All bytes are equal.
It is not a TEA5767
Feb  7 18:24:04 virulazo kernel: [   36.525607] tuner' 1-0060: chip
found @ 0xc0 (saa7130[0])
Feb  7 18:24:04 virulazo kernel: [   36.525717] tuner-simple 1-0060:
type set to 77 (TNF9835 FM / PAL B-BG / NTSC)
Feb  7 18:24:04 virulazo kernel: [   36.529540] tuner' 1-0061: chip
found @ 0xc2 (saa7130[0])
Feb  7 18:24:04 virulazo kernel: [   36.532408] saa7130[0]: registered
device video0 [v4l2]
Feb  7 18:24:04 virulazo kernel: [   36.532517] saa7130[0]: registered
device vbi0
Feb  7 18:24:04 virulazo kernel: [   36.532649] saa7130[0]: registered
device radio0
---

> Did not look up the IR keymap yet, but mask_keydown seems unique.
> Can you tell us the name of the IR controller chip?
Inside it has an ic of the kind that looks like a black plastic drop.
There is a label that reads "www.seneasy.com s42a85".  It's a Chinese
company that makes remote controls in massive quantities, but that's
all I found;
The mask_keydown needs a bit of more work, sometimes when changing
channels or input an event with data=0xff is generated.

> Mauro, this one should be covered by your tuner=69 entry. Might have a
> datasheet somewhere, but I think don't need it.
>
> The Tena sheets always have a gap between the end of a band and the
> start of the next band. For all what I previously looked up around that
> stuff, there is no broadcast in that gap. So it doesn't matter much
> where to start and end. Also, a TNF9835 tuner board was within the
> TVF58t5-MFF. Except Adrian can show us missing channels, we should drop
> the tuner stuff entirely.

I agree about dropping the tuner stuff, they only differ in only
6~8Mhz; that's enough bandwidth for a channel but right now I have no
means to prove that it is being used.
Lets drop it until someone comes with more information.

Cheers, Adrian.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
