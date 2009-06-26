Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5QMcaSK011264
	for <video4linux-list@redhat.com>; Fri, 26 Jun 2009 18:38:36 -0400
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net
	[151.189.21.46])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n5QMcF7T001187
	for <video4linux-list@redhat.com>; Fri, 26 Jun 2009 18:38:16 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Vikraman Choudhury <vikraman.choudhury@gmail.com>
In-Reply-To: <1246053224.8505.12.camel@pc07.localdom.local>
References: <14b5ef430906251008j49859b24k93bcf2f122bf9590@mail.gmail.com>
	<1246053224.8505.12.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 00:37:23 +0200
Message-Id: <1246055843.8505.20.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: saa7134, help with integrated remote!
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


Am Freitag, den 26.06.2009, 23:53 +0200 schrieb hermann pitton:
> Hi Vikraman,
> 
> Am Donnerstag, den 25.06.2009, 22:38 +0530 schrieb Vikraman Choudhury: 
> > Hi, I have an analog TV tuner card (Enter 210-TV --
> > http://www.entermultimedia.com/tv_tuner_internal.html) with a Philips
> > SAA7134 chipset.
> > I can tune to all channels (PAL) by loading the module saa7134 passing
> > card=106 (card=3,10,42 , tuner=37,69 also work), and get audio using the
> > line-in cable.
> > However, I can't get the integrated ir remote to work, using any of the
> > above options. The device saa7134 IR is detected as /dev/input/event7, but
> > cat /dev/input/event7 either doesn't show any output or spits out the same
> > code repeatedly (without the remote pressed). I understand this means that
> > the card is not the model passed as argument. But, is there any possible way
> > to find the correct card= and tuner= configuration ?
> > 
> > System: Gentoo 2008.0 with vanilla-sources 2.6.30 CFLAGS="-O2
> > -march=pentium4 -pipe -fomit-frame-pointer" CHOST="i686-pc-linux-gnu"
> > 
> > Output from dmesg (options saa7134 card=106 in /etc/modprobe.conf) :
> > [    3.210960] saa7130/34: v4l2 driver version 0.2.15 loaded
> > [    3.211039] saa7134 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ
> > 18
> > [    3.211048] saa7130[0]: found at 0000:01:00.0, rev: 1, irq: 18, latency:
> > 32, mmio: 0xe8000000
> > [    3.211057] saa7130[0]: subsystem: 1131:0000, board: 10MOONS TM300 TV
> > Card [card=116,insmod option]
> > [    3.211077] saa7130[0]: board init: gpio is 17f00
> > [    3.211177] input: saa7134 IR (10MOONS TM300 TV Ca as
> > /devices/pci0000:00/0000:00:1e.0/0000:01:00.0/input/input6
> > [    3.211247] IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared
> > IRQs
> > [    3.312299] saa7130[0]: Huh, no eeprom present (err=-5)?
> > [    3.328111] tuner 1-0061: chip found @ 0xc2 (saa7130[0])
> > [    3.330042] tuner-simple 1-0061: creating new instance
> > [    3.330048] tuner-simple 1-0061: type set to 37 (LG PAL (newer TAPC
> > series))
> > [    3.336196] saa7130[0]: registered device video0 [v4l2]
> > [    3.336224] saa7130[0]: registered device vbi0
> 
> we have lots of cards without eeprom like yours, especially with saa7130
> chips and you can't tell much about them without having them.
> 
> For all the old tuners on them it is the same, if you don't look them
> up, but tuner=69 covers a lot of them. Tuner=37 might fail on UHF I
> guess.
> 
> If you boot without forcing any other card previously, the gpio init of
> the card is the only thin trace to something it might have in common
> with others already or makes it unique.
> 
> For "board init: gpio is 17f00" I seem not to find any trace in the
> archives and also not on the bttv-gallery.
> 
> If the gpio init stays unchanged, you likely have to do the remote
> support yourself.
> 
> If you can identify an IR micro controller on the board with connections
> to the gpio pins of the saa7130, you might find it on the
> http://www.bttv-gallery.de already on other cards too.
> 
> The pinning of the saa7130 is available from Philps/NXP and links to
> such information can be found on the wiki.
> 
> Also some instructions about how to get such stuff working.
> 
> Basically you start with a mask_keycode 0x0 for a device in
> saa7134-input.c you are using to see all activity caused by the remote
> on the gpio pins. Then you try to find the keydown/up button and further
> all other gpios in use to get unique code for each button.
> 
> Recent remotes are often more tricky, but for now I would not expect
> those on your hardware.
> 
> BTW, we changed to linux-media@vger.kernel.org.
> 
> Cheers,
> Hermann
> 

Hello hermann pitton,

  You just sent me an email about "Re: saa7134, help with integrated
remote!".

  I'll be more likely to see your email and future messages if you
  are on my priority Guest List.

  Click the link below to be put directly on my Guest List:
  https://www.boxbe.com/crs?tc=175073125_2124663582

  Thank you,
  Vikraman Choudhury


About Boxbe
This courtesy notice is part of a free service to make email
more reliable and useful.  Boxbe (http://www.boxbe.com) uses
your existing social network and that of your friends to keep
your inbox clean and make sure you receive email from people
who matter to you.

Boxbe: Say Goodbye to Email Overload
Visit http://www.boxbe.com/how-it-works?tc=175073125_2124663582

-------------

That is of course the opposite of that what works here.

Please stay away from further support requests and don't ask for my time
ever again ;)

Cheers,
Hermann






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
