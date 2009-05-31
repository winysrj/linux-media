Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:42434 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbZEaUup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 16:50:45 -0400
Date: Sun, 31 May 2009 13:50:46 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Miroslav =?UTF-8?Q?=20=C5=A0ustek?= <sustmidown@centrum.cz>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Leadtek WinFast DTV-1800H support
In-Reply-To: <200905311933.22524@centrum.cz>
Message-ID: <Pine.LNX.4.58.0905311241560.32713@shell2.speakeasy.net>
References: <200905311925.19140@centrum.cz> <200905311926.3696@centrum.cz>
 <200905311927.20442@centrum.cz> <200905311928.4713@centrum.cz>
 <200905311929.21561@centrum.cz> <200905311930.5668@centrum.cz>
 <200905311931.18645@centrum.cz> <200905311932.22284@centrum.cz>
 <200905311933.22524@centrum.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 31 May 2009, Miroslav [UTF-8]  Šustek wrote:
> Trent Piepho <xyzzy <at> speakeasy.org> writes:
>
> > Instead of raising the reset line here, why not change the gpio settings in
> > the card definition to have it high?  Change gpio1 for television to 0x7050
> > and radio to 0x7010.
> Personally, I don't know when these .gpioX members are used (before
> firmware loads or after...).
> But I assume that adding the high on reset pin shouldn't break anything,
> so we can do this.

They are used whenever the video mux is set.  That will happen when
changing inputs and when the cx8800 driver first initializes the card.
Opening the radio device does an implicit change to the radio input.

It looks like firmware is loaded when needed as part of setting the tuner
frequency.  I think that makes it safe to assume that the gpios will be set
before firmware is loaded.   Though it might be possible if the cx8802
driver is loaded before the cx8800 driver.

Since you have the hardware, it would be easy to check.  Add printk's in
the reset callback code you wrote so you'll know when it's called.  Then
set video_debug to 1 and look for "video_mux:  " lines, which indicate the
card gpio values are being set.

It seems clear that the xc2028 has an active low reset line.  To reset, the
line must be lowered for some time period (probably very short) and then
raised to enable the chip, at which point there should be a delay (probably
longer) while waiting for the chip to come out of reset.  If you think
about it, it does not matter what state the reset line is in before we
lower it.  It can be high, it can be low, the chip be reset either way.

> And shouldn't we put tuner reset pin to 0 when in composite and s-video mode?
> These inputs don't use tuner or do they?

It should be unnecessary to do that, but might help with power consumption.
To do it, change the composite and s-video gpio1 values to 0x7060.

> If I look in dmesg I can see that firmware is loaded into tuner even
> when these modes are used (I'm using MPlayer to select the input).
> And due to callbacks issued duting firmware loading, tuner is turned on
> (reset pin = 1) no matter if it was turned off by .gpioX setting.

It seems like firmware loaded should only happen on frequency change.

> And shouldn't we use the mask bits [24:16] of MO_GPX_IO
> in .gpioX members too? I know only few GPIO pins and the other I don't
> know either what direction they should be. That means GPIO pins which
> I don't know are set as Hi-Z = inputs... Now, when I think of that,
> if it works it's safer when the other pins are in Hi-Z mode. Never mind.

Normally all the unused gpio lines are just set as inputs.

> > Then the reset can be done with:
> >
> > 	case XC2028_TUNER_RESET:
> > 		/* GPIO 12 (xc3028 tuner reset) */
> > 		cx_write(MO_GP1_IO, 0x101000);
> > 		mdelay(50);
> > 		cx_write(MO_GP1_IO, 0x101010);
> > 		mdelay(50);
> > 		return 0;
> >
> Earlier I was told to use 'cx_set' and 'cx_clear' because using 'cx_write'
> is risky.
> see here: http://www.spinics.net/lists/linux-dvb/msg29777.html

Steven is wrong there and you are right.  The cx88 gpio lines have the mask
bits in the 3rd byte, which allow changing a gpio without modifying the
others with a single write.  It is better to use this than to do a
read-modify-write.  That is actually less safe, since it's not an atomic
operation.

> And when you are using 'cx_set' and 'cx_clear' you need 3 calls.
> The first to set the direction bit, the second to set 0 on reset pin
> and the third to set 1 on reset pin.

You could use cx_andor() to set the direction bit and lower the reset pin
in one call.  cx_set/cx_clear are just calls to cx_andor().  But using the
mask bit and cx_write is best.

> > Though I have to wonder why each card needs its own xc2028 reset function.
> > Shouldn't they all be the same other than what gpio they change?
> My English goes lame here. Do you mean that reset function shouldn't use
> GPIO at all?

There is other code for xc2028 reset for different cards, e.g.
cx88_dvico_xc2028_callback, cx88_xc3028_geniatech_tuner_callback,
cx88_xc2028_tuner_callback, cx88_pv_8000gt_callback, and even
cx88_xc5000_tuner_callback.  Shouldn't these functions all do the same
thing other than what gpio line they change?

> > @@ -2882,6 +2946,16 @@
> >                 cx_set(MO_GP0_IO, 0x00000080); /* 702 out of reset */
> >                 udelay(1000);
> >                 break;
> > +
> > +       case CX88_BOARD_WINFAST_DTV1800H:
> > +               /* GPIO 12 (xc3028 tuner reset) */
> > +               cx_set(MO_GP1_IO, 0x1010);
> > +               mdelay(50);
> > +               cx_clear(MO_GP1_IO, 0x10);
> > +               mdelay(50);
> > +               cx_set(MO_GP1_IO, 0x10);
> > +               mdelay(50);
> > +               break;
> >         }
> >  }
> >
> > Couldn't you replace this with:
> >
> > 	case CX88_BOARD_WINFAST_DTV1800H:
> > 		cx88_xc3028_winfast1800h_callback(code, XC2028_TUNER_RESET, 0);
> > 		break;
> Yes, this will do the same job.
> I think that 'cx88_card_setup_pre_i2c' is to be called before any I2C
> communication. The 'cx88_xc3028_winfast1800h_callback' (cx88_tuner_callback)
> is meant to be used when tuner code (during firmware loading) needs it.
> This is probably why others did it this way (these are separated issues
> even if they do the same thing) and I only obey existing form.

The reason cx88_card_setup_pre_i2c() needs to do something is to reset
(actually, un-reset) the xc2028 since the chip will mess up i2c if it is in
reset state.  So really it is the same thing.  I think in this function we
could probably just say:

	if (core->board.tuner_type == TUNER_XC2028)
		cx88_xc2028_tuner_callback(core, XC2028_TUNER_RESET, 0);

That would handle all xc2028 cards at once and there would be no need for
each xc2028 to put a block of code here.

> I only want to finally add the support for this card.
> You know many people (not developers) don't care "if this function is used
> or that function is used twice, instead". They just want to install they distro
> and watch the tv.

They will care if the driver becomes a broken mess and is full of bugs and
no one will work on it anymore.  They will care if linux is as bloated
as vista.  So developers need to take care to do things right.

> I classify myself as an programmer rather than ordinary user, so I care how
> the code looks like. I'm open to the discussion about these things, but
> this can take long time and I just want the card to be supported asap.
> There are more cards which has code like this so if linuxtv developers realize
> eg. to not use callbacks or use only cx_set and cx_clear (instead of cx_write)
> they'll do it all at once (not every card separately).
>
> I attached modified patch:
> - .gpioX members of inputs which use tuner have reset pin  1 (tuner enabled)
> - .gpioX members of inputs which don't use tuner have reset pin 0 (tuner disabled)
> - resets (in callback and the one in pre_i2c) use only two 'cx_write' calls
>
> I'm keeping the "tested-by" lines even if this modified version of patch wasn't
> tested by those people (the previous version was). I trust this changes can't
> break the functionality.
> If you think it's too audacious then drop them.
>
> It's on linuxtv developers which of these two patches will be chosen.
>
> - Miroslav Šustek
>
>
