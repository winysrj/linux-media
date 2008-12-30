Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBUIamRM014488
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 13:36:56 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBUIF8S5016394
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 13:15:22 -0500
Received: by qw-out-2122.google.com with SMTP id 3so2094067qwe.39
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 10:15:08 -0800 (PST)
Message-ID: <412bdbff0812301015j17488464r7a77b325acb4e2ce@mail.gmail.com>
Date: Tue, 30 Dec 2008 13:15:07 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "andrzej zaborowski" <balrogg@gmail.com>
In-Reply-To: <fb249edb0812301007k245d3506k6d9dbe717ccd5284@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fb249edb0812301007k245d3506k6d9dbe717ccd5284@mail.gmail.com>
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

On Tue, Dec 30, 2008 at 1:07 PM, andrzej zaborowski <balrogg@gmail.com> wrote:
> [Forwarded from the coder who wants to be anonymous.]
>
> I recently purchased a video capture board, that is not in the V4L
> drivers officially recognized hardware list, and was asked to post
> information on the card to this mailing list, by an active member of
> the #v4l freenode irc channel, in the hopes of getting it added to
> the official V4L codebase.
>
> The board is a "Sabrent SC-PVS4" 4 port, 4 chip, video capture PCI card
> and the manufacturers website link for this card is at:
>
> http://www.sabrent.com/#itemID=142&section=Product&itemName=SURVEILLANCE
>
> It is a relatively inexpensive ( around $60 delivered ) capture board,
> and has an IC on it for each BNC input port. These cards can be found
> around the web at places like newegg.com, amazon.com, geeks.com, etc and
> seem to be fairly popular.
>
> The card did not work "out of the box," and after googleing around I
> found the following post:
>
> http://www.zoneminder.com/forums/viewtopic.php?p=46054&sid=f37c6496cc74be2f0689468ca42005ed
>
> After adding the suggested module option "card=33,33,33,33" the board
> seems to work properly with the tvtime application. Its in an Athlon64
> 3200+ system with integrated VIA Unichrome graphics, and displays
> captured NTSC video at approx 30 fps useing approx 5-10% cpu with
> Xv/Xvmc as a display target from a single input source.
>
> Here is all the information I know about the card. If anyone would
> like to know more about it, or I have left something out that is
> required to add this card to the officially supported hardware, please
> let me know.
>
> --------------------------------------------------------
> dmesg output:
> --------------------------------------------------------
>
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7130[0]: found at 0000:02:0c.0, rev: 1, irq: 18, latency: 32, mmio:
> 0xfa000000
> saa7130[0]: subsystem: 1131:0000, board: AVerMedia DVD EZMaker
> [card=33,insmod option]
> saa7130[0]: board init: gpio is 10000
> saa7130[0]: Huh, no eeprom present (err=-5)?
> saa7130[0]: registered device video0 [v4l2]
> saa7130[0]: registered device vbi0
> saa7130[1]: found at 0000:02:0d.0, rev: 1, irq: 19, latency: 32, mmio:
> 0xfa001000
> saa7130[1]: subsystem: 1131:0000, board: AVerMedia DVD EZMaker
> [card=33,insmod option]
> saa7130[1]: board init: gpio is 10000
> saa7130[1]: Huh, no eeprom present (err=-5)?
> saa7130[1]: registered device video1 [v4l2]
> saa7130[1]: registered device vbi1
> saa7130[2]: found at 0000:02:0e.0, rev: 1, irq: 16, latency: 32, mmio:
> 0xfa002000
> saa7130[2]: subsystem: 1131:0000, board: AVerMedia DVD EZMaker
> [card=33,insmod option]
> saa7130[2]: board init: gpio is 10000
> saa7130[2]: Huh, no eeprom present (err=-5)?
> saa7130[2]: registered device video2 [v4l2]
> saa7130[2]: registered device vbi2
> saa7130[3]: found at 0000:02:0f.0, rev: 1, irq: 20, latency: 32, mmio:
> 0xfa003000
> saa7130[3]: subsystem: 1131:0000, board: AVerMedia DVD EZMaker
> [card=33,insmod option]
> saa7130[3]: board init: gpio is 10000
> saa7130[3]: Huh, no eeprom present (err=-5)?
> saa7130[3]: registered device video3 [v4l2]
> saa7130[3]: registered device vbi3
> irq 16: nobody cared (try booting with the "irqpoll" option)
>
> --------------------------------------------------------
> lspci output:
> --------------------------------------------------------
>
> 02:0c.0 Multimedia controller: Philips Semiconductors SAA7130 Video
> Broadcast Decoder (rev 01)
> 02:0d.0 Multimedia controller: Philips Semiconductors SAA7130 Video
> Broadcast Decoder (rev 01)
> 02:0e.0 Multimedia controller: Philips Semiconductors SAA7130 Video
> Broadcast Decoder (rev 01)
> 02:0f.0 Multimedia controller: Philips Semiconductors SAA7130 Video
> Broadcast Decoder (rev 01)
>
> --------------------------------------------------------
> lspci -vv output ( first entry only ):
> --------------------------------------------------------
>
> 02:0c.0 Multimedia controller: Philips Semiconductors SAA7130 Video
> Broadcast Decoder (rev 01)
> Subsystem: Philips Semiconductors Device 0000
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 32 (3750ns min, 9500ns max)
> Interrupt: pin A routed to IRQ 18
> Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=1K]
> Capabilities: [40] Power Management version 1
> Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> Kernel driver in use: saa7134
> Kernel modules: saa7134
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

Could you please also provide the output of "lspci -n" so we can see
what the actual PCI ID is? (I don't see it in the lspci -v output for
some reason)

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
