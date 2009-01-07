Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0707lVO011862
	for <video4linux-list@redhat.com>; Tue, 6 Jan 2009 19:07:47 -0500
Received: from mail-in-12.arcor-online.net (mail-in-12.arcor-online.net
	[151.189.21.52])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0707UUq025062
	for <video4linux-list@redhat.com>; Tue, 6 Jan 2009 19:07:30 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: andrzej zaborowski <balrogg@gmail.com>
In-Reply-To: <fb249edb0812301026u2675abah5e0bfb63a1668b7c@mail.gmail.com>
References: <fb249edb0812301007k245d3506k6d9dbe717ccd5284@mail.gmail.com>
	<412bdbff0812301015j17488464r7a77b325acb4e2ce@mail.gmail.com>
	<fb249edb0812301026u2675abah5e0bfb63a1668b7c@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 01:08:20 +0100
Message-Id: <1231286900.2618.60.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Adding Sabrent SC-PVS4 Capture Board to hardware list
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

Hi,

Am Dienstag, den 30.12.2008, 19:26 +0100 schrieb andrzej zaborowski:
> 2008/12/30 Devin Heitmueller <devin.heitmueller@gmail.com>:
> > On Tue, Dec 30, 2008 at 1:07 PM, andrzej zaborowski <balrogg@gmail.com> wrote:
> <snip>
> >> Here is all the information I know about the card. If anyone would
> >> like to know more about it, or I have left something out that is
> >> required to add this card to the officially supported hardware, please
> >> let me know.
> >>
> >> --------------------------------------------------------
> >> dmesg output:
> >> --------------------------------------------------------
> >>
> >> saa7130/34: v4l2 driver version 0.2.14 loaded
> >> saa7130[0]: found at 0000:02:0c.0, rev: 1, irq: 18, latency: 32, mmio:
> >> 0xfa000000
> >> saa7130[0]: subsystem: 1131:0000, board: AVerMedia DVD EZMaker
> >> [card=33,insmod option]
> >> saa7130[0]: board init: gpio is 10000
> >> saa7130[0]: Huh, no eeprom present (err=-5)?
> >> saa7130[0]: registered device video0 [v4l2]
> >> saa7130[0]: registered device vbi0
> >> saa7130[1]: found at 0000:02:0d.0, rev: 1, irq: 19, latency: 32, mmio:
> >> 0xfa001000
> >> saa7130[1]: subsystem: 1131:0000, board: AVerMedia DVD EZMaker
> >> [card=33,insmod option]
> >> saa7130[1]: board init: gpio is 10000
> >> saa7130[1]: Huh, no eeprom present (err=-5)?
> >> saa7130[1]: registered device video1 [v4l2]
> >> saa7130[1]: registered device vbi1
> >> saa7130[2]: found at 0000:02:0e.0, rev: 1, irq: 16, latency: 32, mmio:
> >> 0xfa002000
> >> saa7130[2]: subsystem: 1131:0000, board: AVerMedia DVD EZMaker
> >> [card=33,insmod option]
> >> saa7130[2]: board init: gpio is 10000
> >> saa7130[2]: Huh, no eeprom present (err=-5)?
> >> saa7130[2]: registered device video2 [v4l2]
> >> saa7130[2]: registered device vbi2
> >> saa7130[3]: found at 0000:02:0f.0, rev: 1, irq: 20, latency: 32, mmio:
> >> 0xfa003000
> >> saa7130[3]: subsystem: 1131:0000, board: AVerMedia DVD EZMaker
> >> [card=33,insmod option]
> >> saa7130[3]: board init: gpio is 10000
> >> saa7130[3]: Huh, no eeprom present (err=-5)?
> >> saa7130[3]: registered device video3 [v4l2]
> >> saa7130[3]: registered device vbi3
> >> irq 16: nobody cared (try booting with the "irqpoll" option)
> >>
> >> --------------------------------------------------------
> >> lspci output:
> >> --------------------------------------------------------
> >>
> >> 02:0c.0 Multimedia controller: Philips Semiconductors SAA7130 Video
> >> Broadcast Decoder (rev 01)
> >> 02:0d.0 Multimedia controller: Philips Semiconductors SAA7130 Video
> >> Broadcast Decoder (rev 01)
> >> 02:0e.0 Multimedia controller: Philips Semiconductors SAA7130 Video
> >> Broadcast Decoder (rev 01)
> >> 02:0f.0 Multimedia controller: Philips Semiconductors SAA7130 Video
> >> Broadcast Decoder (rev 01)
> >>
> >> --------------------------------------------------------
> >> lspci -vv output ( first entry only ):
> >> --------------------------------------------------------
> >>
> >> 02:0c.0 Multimedia controller: Philips Semiconductors SAA7130 Video
> >> Broadcast Decoder (rev 01)
> >> Subsystem: Philips Semiconductors Device 0000
> >> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> >> Stepping- SERR- FastB2B- DisINTx-
> >> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> >> <TAbort- <MAbort- >SERR- <PERR- INTx-
> >> Latency: 32 (3750ns min, 9500ns max)
> >> Interrupt: pin A routed to IRQ 18
> >> Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=1K]
> >> Capabilities: [40] Power Management version 1
> >> Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> >> Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> >> Kernel driver in use: saa7134
> >> Kernel modules: saa7134
> >>
> >> --
> >> video4linux-list mailing list
> >> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> >> https://www.redhat.com/mailman/listinfo/video4linux-list
> >>
> >
> > Could you please also provide the output of "lspci -n" so we can see
> > what the actual PCI ID is? (I don't see it in the lspci -v output for
> > some reason)
> 
> --------------------------------------------------------
> lspci -n output ( all 4 board/ic entries ):
> --------------------------------------------------------
> 
> 02:0c.0 0480: 1131:7130 (rev 01)
> 02:0d.0 0480: 1131:7130 (rev 01)
> 02:0e.0 0480: 1131:7130 (rev 01)
> 02:0f.0 0480: 1131:7130 (rev 01)
> 

just looked at some other Sabrent and came across this one.

It just means it has no eeprom and the above is not usable for
identification.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
