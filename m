Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m65MAnrZ030112
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 18:10:49 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.228])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m65MAROR016333
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 18:10:27 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2168301rvb.51
	for <video4linux-list@redhat.com>; Sat, 05 Jul 2008 15:10:26 -0700 (PDT)
Message-ID: <486FF148.2060506@gmail.com>
Date: Sat, 05 Jul 2008 14:10:16 -0800
From: D <therealisttruest@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Help with Chinese card
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

Anyone,

Firstly, let me state I'm not a total noob to Linux, but have only 
recompiled a kernel once or twice and then couldn't have done so without 
a decent step by step guide. I'm a programmer, but not a good one yet as 
I'm still learning a lot. So on to my problem.....

I was working on this for an associate of mine who is across the country 
so I have somewhat limited access to the machine with the card on it. I 
have tried a couple module recompilations with a possible addition for 
this card, but with no real success.

It's a LE-8008A from Shenzhen Rare Numeral Science bought on EBay and it 
appears to be an SAA7134 card. Based on a previous posting on the 
mailing list, I've made changes to the saa7134-cards.c and saa7134.h 
below, but with little success(the previous user  evidently used RegSpy 
in Windows, but I don't have access to that)--

[SAA7134_BOARD_AOP_8008A_16_PORT] = {/*added definition*/
        .name = "AOPVision AOP-8008A 16CH/240fps Capture Card",
        .audio_clock = 0x00187de7,
        .tuner_type = TUNER_ABSENT,
        .radio_type = UNSET,
        .tuner_addr = ADDR_UNSET,
        .radio_addr = ADDR_UNSET,
        .inputs = {{
        .name = name_comp1,
        .gpio = 0xe3c00,
        .vmux = 0,
        },{
        .name = name_comp2,
        .gpio = 0xe3c00,
        .vmux = 2,
        }},

Here's some pertinent info-

lspci

04:08.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
Broadcast Decoder (rev 01)
04:09.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
Broadcast Decoder (rev 01)
04:0a.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
Broadcast Decoder (rev 01)
04:0b.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
Broadcast Decoder (rev 01)
04:0c.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
Broadcast Decoder (rev 01)
04:0d.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
Broadcast Decoder (rev 01)
04:0e.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
Broadcast Decoder (rev 01)
04:0f.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
Broadcast Decoder (rev 01)


lspci -vn

04:08.0 0480: 1131:7130 (rev 01)
    Subsystem: 1131:0000
    Flags: bus master, medium devsel, latency 64, IRQ 21
    Memory at febffc00 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [40] Power Management version 1

04:09.0 0480: 1131:7130 (rev 01)
    Subsystem: 1131:0000
    Flags: bus master, medium devsel, latency 64, IRQ 22
    Memory at febff800 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [40] Power Management version 1

04:0a.0 0480: 1131:7130 (rev 01)
    Subsystem: 1131:0000
    Flags: bus master, medium devsel, latency 64, IRQ 17
    Memory at febff400 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [40] Power Management version 1

04:0b.0 0480: 1131:7130 (rev 01)
    Subsystem: 1131:0000
    Flags: bus master, medium devsel, latency 64, IRQ 23
    Memory at febff000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [40] Power Management version 1

04:0c.0 0480: 1131:7130 (rev 01)
    Subsystem: 1131:0000
    Flags: bus master, medium devsel, latency 64, IRQ 21
    Memory at febfec00 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [40] Power Management version 1

04:0d.0 0480: 1131:7130 (rev 01)
    Subsystem: 1131:0000
    Flags: bus master, medium devsel, latency 64, IRQ 22
    Memory at febfe800 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [40] Power Management version 1

04:0e.0 0480: 1131:7130 (rev 01)
    Subsystem: 1131:0000
    Flags: bus master, medium devsel, latency 64, IRQ 17
    Memory at febfe400 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [40] Power Management version 1

04:0f.0 0480: 1131:7130 (rev 01)
    Subsystem: 1131:0000
    Flags: bus master, medium devsel, latency 64, IRQ 23
    Memory at febfe000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [40] Power Management version 1


Any advice on what to do next or any questions for me to help clarify?

Thanks in advance!

Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
