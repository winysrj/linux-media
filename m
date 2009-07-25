Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:45362 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289AbZGYVw7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 17:52:59 -0400
Subject: Re: Problem with My Tuner card
From: hermann pitton <hermann-pitton@arcor.de>
To: unni krishnan <unnikrishnan.a@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1f8bbe3c0907250856h6c059658m6caa838a0ac6f9c2@mail.gmail.com>
References: <1f8bbe3c0907232102t5c658d66o571571707ecdb1f4@mail.gmail.com>
	 <1248411383.3247.18.camel@pc07.localdom.local>
	 <1f8bbe3c0907232218g45c89eeapc4b86e9d07217037@mail.gmail.com>
	 <1248415576.3245.16.camel@pc07.localdom.local>
	 <1f8bbe3c0907250856h6c059658m6caa838a0ac6f9c2@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 23:49:08 +0200
Message-Id: <1248558548.3341.116.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Samstag, den 25.07.2009, 21:26 +0530 schrieb unni krishnan:
> Hi hermann,
> 
> I have recompiled the kernel and it is working now, thanks.
> 
> I have used :
> 
> modprobe saa7134 card=3

fine. So at least something working as a start.

It seems to me we have to add a new entry for your card.
Does it have a unique name they sell it, do you know the manufacturer?
Is there a website or did you investigate all the printings on the PCB
already.

The tuner type label is often hidden under a OEM vendor label.
Sometimes a drop of salad oil is enough to make the upper sticker
transparent. Tuner factory label underneath is in most cases close to
the antenna connector.

Please read a little at our wiki about information we need.
http://www.linuxtv.org/wiki/index.php/Development:_How_to_add_support_for_a_device

> But there are two problems now :
> 
> 1. My speakers will produce the channel sound even after closing
> tvtime and I need to remove the module using rmmod saa7134 to solve
> that, is there any solution for that ?

This is typical for saa7130 chips. They have no hardware mute on chip.

It also shows that your card is in more different than the TV vmux.
The FlyVideo2000 has hardware mute via its external audio mux chip.

You have some mux chip too, and by pure luck card=3 makes the TV sound
coming through from the tuner for you too.
The saa7134 driver uses so called masked writes to deal with single or
groups of the 28 (0-27) gpio pins it has. Only pins high in the gpio
mask are switchable.

For the FlyVideo2000 Wan Tat Chee uses a gpiomask of 0xe000.
If you convert to bin you see pin 13,14,15 dec are used for switching.
In hex pin 0x2000, 0x4000 and 0x8000.

All audio inputs are connected to the same pair of audio input on the
saa7130 called LINE2. All the audio routing on the card is completely
done by the external mux chip controlled with this three gpio pins of
the saa7130.

For having TV sound all this three pins are set to 0 (low/input).
This does not mean that this is really needed on your card.

Since 0x8000 does not work for mute on your card, you can try 0x4000 and
0x2000 in the mute section.

For cards without external mux, one must switch to an unused audio
input. That could be LINE1 on your card.

> 2. In Linux I am not getting all the channels that I can get in
> windows using this tuner card. I have scanned all the channels using
> tvtime scanner but some channels are missing, is there anything we can
> do to resolve it ?

Yes, find the right tuner. Your tuner=55 does use LG API.
Are the missing channels above 450MHz in UHF ranges?

/* ------------ TUNER_TCL_2002MB - TCL PAL ------------ */

static struct tuner_range tuner_tcl_2002mb_pal_ranges[] = {
	{ 16 * 170.00 /*MHz*/, 0xce, 0x01, },
	{ 16 * 450.00 /*MHz*/, 0xce, 0x02, },
	{ 16 * 999.99        , 0xce, 0x08, },
};

static struct tuner_params tuner_tcl_2002mb_params[] = {
	{
		.type   = TUNER_PARAM_TYPE_PAL,
		.ranges = tuner_tcl_2002mb_pal_ranges,
		.count  = ARRAY_SIZE(tuner_tcl_2002mb_pal_ranges),
	},
};

Then we might have to switch to a tuner using MK3 API.

If the missing channels are only close to the takeover frequencies of
170 and 450MHz, then the correct or at least better tuner needs to be
found. You might enable debug=1 for tuner and tuner-simple.

For example, if you have missing channels between 450 and 471.25 MHz,
you can try with tuner=69 again.

Is for that card FM radio support announced?

Cheers,
Hermann

> On Fri, Jul 24, 2009 at 11:36 AM, hermann pitton<hermann-pitton@arcor.de> wrote:
> > Hi,
> >
> > Am Freitag, den 24.07.2009, 10:48 +0530 schrieb unni krishnan:
> >> > Hi Unni,
> >> Hi Hermann,
> >>
> >> >
> >> > we have lots of saa7130 cards without eeprom on it providing not at
> >> > least a valid PCI subvendor and subdevice, so we can't know what it is
> >> > at all, neither for the tuner type and also not for how video and audio
> >> > inputs are connected.
> >> >
> >> > If you can tell a card with working video and another one with working
> >> > audio, it should not be hard to get something together for both on TV
> >> > from the tuner as a start.
> >>
> >> The option
> >>
> >> modprobe saa7134 card=3 tuner=55
> >>
> >> gives me sound without much noise but no video
> >
> > You need the external audio mux gpio switching of the FlyVideo2000
> > card=3.
> >
> >> This gives me video, but no audio
> >>
> >> modprobe saa7134 card=37 tuner=55
> >>
> >
> > But you also need the vmux=3 of card=37 for it.
> > Change the vmux of card = 3 in saa7134-cards.c from one to 3 and
> > recompile and install and try again with your "maybe" tuner.
> >
> >
> >        [SAA7134_BOARD_FLYVIDEO2000] = {
> >                /* "TC Wan" <tcwan@cs.usm.my> */
> >                .name           = "LifeView/Typhoon FlyVIDEO2000",
> >                .audio_clock    = 0x00200000,
> >                .tuner_type     = TUNER_LG_PAL_NEW_TAPC,
> >                .radio_type     = UNSET,
> >                .tuner_addr     = ADDR_UNSET,
> >                .radio_addr     = ADDR_UNSET,
> >
> >                .gpiomask       = 0xe000,
> >                .inputs         = {{
> >                        .name = name_tv,
> >                        .vmux = 1,        <--change to vmux = 3
> >                        .amux = LINE2,
> >                        .gpio = 0x0000,
> >                        .tv   = 1,
> >                },{
> >                        .name = name_comp1,
> >                        .vmux = 0,
> >                        .amux = LINE2,
> >                        .gpio = 0x4000,
> >                },{
> >                        .name = name_comp2,
> >                        .vmux = 3,
> >                        .amux = LINE2,
> >                        .gpio = 0x4000,
> >                },{
> >                        .name = name_svideo,
> >                        .vmux = 8,
> >                        .amux = LINE2,
> >                        .gpio = 0x4000,
> >                }},
> >                .radio = {
> >                        .name = name_radio,
> >                        .amux = LINE2,
> >                        .gpio = 0x2000,
> >                },
> >                .mute = {
> >                        .name = name_mute,
> >                        .amux = LINE2,
> >                        .gpio = 0x8000,
> >                },
> >        },
> >
> >
> >> >
> >> > Also, if you do a cold boot without forcing any card, there might be a
> >> > slight chance, that the gpio configuration on card init has been seen
> >> > previously.
> >>
> >> Sorry, do you want me to just reboot the system ? I have already
> >> rebooted the system many times. Is there any other thing that I need
> >> to do before/after reboot ? I am new to Linux devices
> >>
> >
> > If you tried different cards with different gpio configurations
> > previously, those settings are not cleared, except you take care for it.
> >
> > Easiest is to do a cold boot, to see the card coming up untouched on
> > gpios.
> >
> > I did not care yet, if we have it already duplicate, but likely try to
> > look it up in the evening here.
> >
> > Cheers,
> > Hermann
> >
> >
> >
> 
> 
> 

