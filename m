Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m65Mq5ib008049
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 18:52:05 -0400
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m65MpPwB029675
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 18:51:25 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: D <therealisttruest@gmail.com>
In-Reply-To: <486FF148.2060506@gmail.com>
References: <486FF148.2060506@gmail.com>
Content-Type: text/plain
Date: Sun, 06 Jul 2008 00:48:06 +0200
Message-Id: <1215298086.3237.19.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Help with Chinese card
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


Am Samstag, den 05.07.2008, 14:10 -0800 schrieb D:
> Anyone,
> 
> Firstly, let me state I'm not a total noob to Linux, but have only 
> recompiled a kernel once or twice and then couldn't have done so without 
> a decent step by step guide. I'm a programmer, but not a good one yet as 
> I'm still learning a lot. So on to my problem.....
> 
> I was working on this for an associate of mine who is across the country 
> so I have somewhat limited access to the machine with the card on it. I 
> have tried a couple module recompilations with a possible addition for 
> this card, but with no real success.
> 
> It's a LE-8008A from Shenzhen Rare Numeral Science bought on EBay and it 
> appears to be an SAA7134 card. Based on a previous posting on the 
> mailing list, I've made changes to the saa7134-cards.c and saa7134.h 
> below, but with little success(the previous user  evidently used RegSpy 
> in Windows, but I don't have access to that)--
> 
> [SAA7134_BOARD_AOP_8008A_16_PORT] = {/*added definition*/
>         .name = "AOPVision AOP-8008A 16CH/240fps Capture Card",
>         .audio_clock = 0x00187de7,
>         .tuner_type = TUNER_ABSENT,

You only use TUNER_ABSENT, tuner=4, if it is DVB only or only has
external inputs for surveillance nonsense.

Do you have any tuners on that wreckage?

>         .radio_type = UNSET,
>         .tuner_addr = ADDR_UNSET,
>         .radio_addr = ADDR_UNSET,
>         .inputs = {{
>         .name = name_comp1,
>         .gpio = 0xe3c00,

The driver uses masked writes for gpio stuff.

If you think there is anything to do on comp audio, you would like to
have it in the gpio mask set previously.

>         .vmux = 0,
>         },{
>         .name = name_comp2,
>         .gpio = 0xe3c00,
>         .vmux = 2,
>         }},
> 
> Here's some pertinent info-
> 
> lspci
> 
> 04:08.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)

It are some saa7130 only, the detection for these is valid and we have
countless clones of prior cards floating around.

> 04:09.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
> 04:0a.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
> 04:0b.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
> 04:0c.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
> 04:0d.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
> 04:0e.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
> 04:0f.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
> 
> 
> lspci -vn
> 
> 04:08.0 0480: 1131:7130 (rev 01)
>     Subsystem: 1131:0000
>     Flags: bus master, medium devsel, latency 64, IRQ 21
>     Memory at febffc00 (32-bit, non-prefetchable) [size=1K]
>     Capabilities: [40] Power Management version 1
> 
> 04:09.0 0480: 1131:7130 (rev 01)
>     Subsystem: 1131:0000
>     Flags: bus master, medium devsel, latency 64, IRQ 22
>     Memory at febff800 (32-bit, non-prefetchable) [size=1K]
>     Capabilities: [40] Power Management version 1
> 
> 04:0a.0 0480: 1131:7130 (rev 01)
>     Subsystem: 1131:0000
>     Flags: bus master, medium devsel, latency 64, IRQ 17
>     Memory at febff400 (32-bit, non-prefetchable) [size=1K]
>     Capabilities: [40] Power Management version 1
> 
> 04:0b.0 0480: 1131:7130 (rev 01)
>     Subsystem: 1131:0000
>     Flags: bus master, medium devsel, latency 64, IRQ 23
>     Memory at febff000 (32-bit, non-prefetchable) [size=1K]
>     Capabilities: [40] Power Management version 1
> 
> 04:0c.0 0480: 1131:7130 (rev 01)
>     Subsystem: 1131:0000
>     Flags: bus master, medium devsel, latency 64, IRQ 21
>     Memory at febfec00 (32-bit, non-prefetchable) [size=1K]
>     Capabilities: [40] Power Management version 1
> 
> 04:0d.0 0480: 1131:7130 (rev 01)
>     Subsystem: 1131:0000
>     Flags: bus master, medium devsel, latency 64, IRQ 22
>     Memory at febfe800 (32-bit, non-prefetchable) [size=1K]
>     Capabilities: [40] Power Management version 1
> 
> 04:0e.0 0480: 1131:7130 (rev 01)
>     Subsystem: 1131:0000
>     Flags: bus master, medium devsel, latency 64, IRQ 17
>     Memory at febfe400 (32-bit, non-prefetchable) [size=1K]
>     Capabilities: [40] Power Management version 1
> 
> 04:0f.0 0480: 1131:7130 (rev 01)
>     Subsystem: 1131:0000
>     Flags: bus master, medium devsel, latency 64, IRQ 23
>     Memory at febfe000 (32-bit, non-prefetchable) [size=1K]
>     Capabilities: [40] Power Management version 1

So lots of saa7130 chips there, but they don't have the few cents left
for some eeproms on it ...

> 
> Any advice on what to do next or any questions for me to help clarify?
> 
> Thanks in advance!
> 
> Daniel
> 

Likely already all over the lists and fully ;) working ...

Don't post here, if you don't provide at least, as a absolute minimum,
"dmesg" on loading the drivers.

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
