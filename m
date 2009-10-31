Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:52664 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757640AbZJaC4z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 22:56:55 -0400
Subject: Re: [PATCH video4linux] For STLabs PCI saa7134 analog receiver card
From: hermann pitton <hermann-pitton@arcor.de>
To: Flink Dinky <flinkdeldinky@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <48bf42dd0910300803q8b98f1an3935901358cf3bf9@mail.gmail.com>
References: <200910292307.28202.flinkdeldinky@gmail.com>
	 <1256859539.3270.23.camel@pc07.localdom.local>
	 <48bf42dd0910300803q8b98f1an3935901358cf3bf9@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 31 Oct 2009 03:54:06 +0100
Message-Id: <1256957646.4272.42.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Michael,

Am Freitag, den 30.10.2009, 22:03 +0700 schrieb Flink Dinky:
> Hello Hermann, I apologize to you and the list about the quality of my
> patch.  I'm not really a programmer.  I've been using the patch below
> for years now and it was cobbled together from the windows Dscaler tv
> program.

patches are always welcome and coding style is not a problem.

But especially on saa7130 devices, we have a lot of different OEMs using
invalid PCI subsystem IDs derived from the original Philips PCI
vendor/device IDs and they do create a mess. 

> After reading your email I looked through the saa7134-cards.c and
> found what looked like an identical card which is listed in saa7134.h
> as:
> #define SAA7134_BOARD_10MOONSTVMASTER3     116
> 
> if I load the saa7134 module like this:
> modprobe saa7134 card=116 tuner=5
> 
> It works just the same as my patch.

Yes, that is what happens in most such cases if you start to look
closer. But also all three pins high in the mask turned to 0 seem to be
needed to get TV sound from the tuner then.

However, there are still variants of such cards, some with and some
without analog radio, also with different remotes etc.

In this case, to know if the remote does work too now, could help to
make a decision how to further deal with it.

> My card is a no name brand.  It's an STLabs PCI TV Tuner card with a
> firewire port (which is autodetected by the kernel and has always
> worked).

There are _some_ of such ST cards and it is not more no name than
others.

Also for cards with old can/tin tuners per TV standard, but sold
globally with different tuners, we can't detect the tuner type, and in
most cases it is not even worth to think about, if the tuner type might
be coded somewhere in eeprom content or placement of gpio resistors,
since they already fail on proper usage of the PCI subvendor and device.

In most cases they don't have any further info than this mistake in the
eeprom.

> I'm probably the only guy still using this card but what if I'm not?
> Can you put something in the Documentation to let them know?

Thanks for your report, seems to be around in India and China ...

We should still remove that early invalid and now duplicate 10moons
saa7130 from auto detection and can of course start some guide lines for
how to deal with such cards in CARDLIST.saa7134 too, but we'll need
links to the old bttv-gallery.de and the current wiki to really help
people to identify such unpleasant cards most easily, if we have enough
there.

Cheers,
Hermann

> If you need any info email me with instructions on what to do.
> Otherwise my problem is solved.
> 
> Thanks for your help.
> 
> On Fri, Oct 30, 2009 at 6:38 AM, hermann pitton
> <hermann-pitton@arcor.de> wrote:
>         Hi Michael,
>         
>         Am Donnerstag, den 29.10.2009, 23:07 +0700 schrieb
>         flinkdeldinky:
>         > The following patch provides functionality for the STLabs
>         PCI TV receiver card. It only adds some information to
>         saa7134.h and saa7134-cards.c
>         >
>         > The card is auto detected as a 10 MOONS card but that will
>         not work.
>         
>         
>         I still can't see how your card could make it in that way and
>         how Mauro
>         could make a decision in that direction, assuming you pass
>         patchwork
>         once.
>         
>         > I load the saa7134 module with:
>         > saa7134 card=175 tuner=5
>         
>         
>         In that case, having the Philips reference boards 0x2001
>         subdevice twice
>         now for a saa7130, remove the auto detection for the 10MOONS
>         too and
>         drop the one for yours.
>         
>         Also, the tuners are different, but not everybody has the
>         opportunity to
>         test them on their differences. In this case, tuner=5 and
>         TUNER_LG_PAL_NEW_TAPC makes a big difference for the UHF
>         switch.
>         Likely you can't test it and sit on a clone anyway.
>         
>         See more inline.
>         
>         > I have not tested the remote control or the s-video.
>          Everything else works.
>         >
>         > Tuners 3, 5, 14, 20, 28, 29, 48 seem to work equally well.
>         >
>         > diff -r d6c09c3711b5
>         linux/drivers/media/video/saa7134/saa7134-cards.c
>         > --- a/linux/drivers/media/video/saa7134/saa7134-cards.c Sun
>         Sep 20 15:14:21 2009 +0000
>         > +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Thu
>         Oct 29 14:54:31 2009 +0700
>         
>         
>         Run at least "make checkpatch" once on recent mercurial
>         v4l-dvb.
>         
>         For what I can see, you have spaces instead of tabs in front
>         of your
>         lines and also you are filling them up with useless spaces at
>         the ends
>         and for new lines.
>         
>         >
>         > @@ -5342,7 +5342,38 @@
>         >                         .amux   = LINE2,
>         >                 } },
>         >         },
>         > -
>         > +       [SAA7134_BOARD_STLAB_PCI_TV7130] = {
>         > +       /* "Aidan Gill" */
>         > +               .name = "ST Lab ST Lab PCI-TV7130 ",
>         > +               .audio_clock = 0x00200000,
>         > +               .tuner_type = TUNER_LG_PAL_NEW_TAPC,
>         > +               .radio_type     = UNSET,
>         > +               .tuner_addr     = ADDR_UNSET,
>         > +               .radio_addr     = ADDR_UNSET,
>         > +               .gpiomask = 0x7000,
>         
>         
>         There is one unused gpio pin high in that mask, should it be
>         needed for
>         something ..., don't we have a same card already?
>         
>         >
>         > +               .inputs = {{
>         > +                       .name = name_tv,
>         > +                       .vmux = 1,
>         > +                       .amux = LINE2,
>         > +                       .gpio = 0x0000,
>         > +                       .tv = 1,
>         > +               }, {
>         > +                       .name = name_comp1,
>         > +                       .vmux = 3,
>         > +                       .amux = LINE1,
>         > +                       .gpio = 0x2000,
>         > +               }, {
>         > +                       .name = name_svideo,
>         > +                       .vmux = 0,
>         > +                       .amux = LINE1,
>         > +                       .gpio = 0x2000,
>         
>         
>         Most often comp2 is on vmux 0. S-Video can only be on vmux
>         6,7,8 or 9.
>         Put it on 8 and comment it as untested.
>         
>         >
>         > +               } },
>         > +               .mute = {
>         > +                       .name = name_mute,
>         > +                       .amux = TV,
>         > +                       .gpio = 0x3000,
>         > +               },
>         > +       },
>         >  };
>         >
>         >  const unsigned int saa7134_bcount =
>         ARRAY_SIZE(saa7134_boards);
>         > @@ -6487,6 +6518,12 @@
>         >                 .subdevice    = 0x4847,
>         >                 .driver_data  =
>         SAA7134_BOARD_ASUS_EUROPA_HYBRID,
>         >         }, {
>         > +               .vendor       = PCI_VENDOR_ID_PHILIPS,
>         > +               .device       =
>         PCI_DEVICE_ID_PHILIPS_SAA7130,
>         > +               .subvendor    =  PCI_VENDOR_ID_PHILIPS,
>         > +               .subdevice    = 0x2001,
>         > +               .driver_data  =
>         SAA7134_BOARD_STLAB_PCI_TV7130,
>         > +       }, {
>         
>         
>         Throw that away with the 10MOONS stuff, or find some eeprom
>         detection.
>         
>         >                 /* --- boards without eeprom + subsystem ID
>         --- */
>         >                 .vendor       = PCI_VENDOR_ID_PHILIPS,
>         >                 .device       =
>         PCI_DEVICE_ID_PHILIPS_SAA7134,
>         > diff -r d6c09c3711b5
>         linux/drivers/media/video/saa7134/saa7134.h
>         > --- a/linux/drivers/media/video/saa7134/saa7134.h       Sun
>         Sep 20 15:14:21 2009 +0000
>         > +++ b/linux/drivers/media/video/saa7134/saa7134.h       Thu
>         Oct 29 14:54:31 2009 +0700
>         > @@ -299,6 +299,7 @@
>         >  #define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM 172
>         >  #define SAA7134_BOARD_ZOLID_HYBRID_PCI         173
>         >  #define SAA7134_BOARD_ASUS_EUROPA_HYBRID       174
>         > +#define SAA7134_BOARD_STLAB_PCI_TV7130         175
>         >
>         >  #define SAA7134_MAXBOARDS 32
>         >  #define SAA7134_INPUT_MAX 8
>         >
>         > Signed-off-by: Michael Wellman <flinkdeldinky@gmail.com>
>         
>         
>         Cheers,
>         Hermann
>         
>         
> 

