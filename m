Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZEaT6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 15:58:47 -0400
Date: Sun, 31 May 2009 16:58:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Miroslav  =?UTF-8?B?xaB1c3Rlaw==?=" <sustmidown@centrum.cz>
Cc: <xyzzy@speakeasy.org>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Leadtek WinFast DTV-1800H support
Message-ID: <20090531165842.291b4ca6@pedra.chehab.org>
In-Reply-To: <200905311939.21114@centrum.cz>
References: <200905291638.9584@centrum.cz>
	<200905291639.30476@centrum.cz>
	<Pine.LNX.4.58.0905310536500.32713@shell2.speakeasy.net>
	<200905311939.21114@centrum.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 31 May 2009 19:39:15 +0200
"Miroslav  Šustek" <sustmidown@centrum.cz> escreveu:

> Trent Piepho <xyzzy <at> speakeasy.org> writes:
> 
> > Instead of raising the reset line here, why not change the gpio settings in
> > the card definition to have it high? Change gpio1 for television to 0x7050
> > and radio to 0x7010.
> Personally, I don't know when these .gpioX members are used (before
> firmware loads or after...).
> But I assume that adding the high on reset pin shouldn't break anything,
> so we can do this.
> 
> And shouldn't we put tuner reset pin to 0 when in composite and s-video mode?
> These inputs don't use tuner or do they?
> If I look in dmesg I can see that firmware is loaded into tuner even
> when these modes are used (I'm using MPlayer to select the input).
> And due to callbacks issued duting firmware loading, tuner is turned on
> (reset pin = 1) no matter if it was turned off by .gpioX setting.
> 
> And shouldn't we use the mask bits [24:16] of MO_GPX_IO
> in .gpioX members too? I know only few GPIO pins and the other I don't
> know either what direction they should be. That means GPIO pins which
> I don't know are set as Hi-Z = inputs... Now, when I think of that,
> if it works it's safer when the other pins are in Hi-Z mode. Never mind.
> 
> >
> > Then the reset can be done with:
> >
> > case XC2028_TUNER_RESET:
> > /* GPIO 12 (xc3028 tuner reset) */
> > cx_write(MO_GP1_IO, 0x101000);
> > mdelay(50);
> > cx_write(MO_GP1_IO, 0x101010);
> > mdelay(50);
> > return 0;
> >
> Earlier I was told to use 'cx_set' and 'cx_clear' because using 'cx_write'
> is risky.
> see here: http://www.spinics.net/lists/linux-dvb/msg29777.html
> And when you are using 'cx_set' and 'cx_clear' you need 3 calls.
> The first to set the direction bit, the second to set 0 on reset pin
> and the third to set 1 on reset pin.
> If you ask me which I think is nicer I'll tell you: that one with 'cx_write'.
> If you ask me which one I want to use, I'll tell: I don't care. :)
> 
> > Though I have to wonder why each card needs its own xc2028 reset function.
> > Shouldn't they all be the same other than what gpio they change?
> My English goes lame here. Do you mean that reset function shouldn't use
> GPIO at all?
> 
> >
> > @@ -2882,6 +2946,16 @@
> > cx_set(MO_GP0_IO, 0x00000080); /* 702 out of reset */
> > udelay(1000);
> > break;
> > +
> > + case CX88_BOARD_WINFAST_DTV1800H:
> > + /* GPIO 12 (xc3028 tuner reset) */
> > + cx_set(MO_GP1_IO, 0x1010);
> > + mdelay(50);
> > + cx_clear(MO_GP1_IO, 0x10);
> > + mdelay(50);
> > + cx_set(MO_GP1_IO, 0x10);
> > + mdelay(50);
> > + break;
> > }
> > }
> >
> > Couldn't you replace this with:
> >
> > case CX88_BOARD_WINFAST_DTV1800H:
> > cx88_xc3028_winfast1800h_callback(code, XC2028_TUNER_RESET, 0);
> > break;
> Yes, this will do the same job.
> I think that 'cx88_card_setup_pre_i2c' is to be called before any I2C
> communication. The 'cx88_xc3028_winfast1800h_callback' (cx88_tuner_callback)
> is meant to be used when tuner code (during firmware loading) needs it.
> This is probably why others did it this way (these are separated issues
> even if they do the same thing) and I only obey existing form.
> 
> I only want to finally add the support for this card.
> You know many people (not developers) don't care "if this function is used
> or that function is used twice, instead". They just want to install they distro
> and watch the tv.
> I classify myself as an programmer rather than ordinary user, so I care how
> the code looks like. I'm open to the discussion about these things, but
> this can take long time and I just want the card to be supported asap.
> There are more cards which has code like this so if linuxtv developers realize
> eg. to not use callbacks or use only cx_set and cx_clear (instead of cx_write)
> they'll do it all at once (not every card separately).
> 
> I attached modified patch:
> - .gpioX members of inputs which use tuner have reset pin 1 (tuner enabled)
> - .gpioX members of inputs which don't use tuner have reset pin 0 (tuner disabled)
> - resets (in callback and the one in pre_i2c) use only two 'cx_write' calls
> 
> I'm keeping the "tested-by" lines even if this modified version of patch wasn't
> tested by those people (the previous version was). I trust this changes can't
> break the functionality.
> If you think it's too audacious then drop them.
> 
> It's on linuxtv developers which of these two patches will be chosen.

For the sake of not loosing this patch again, I've applied it as-is. I hope I
got the latest version. It is hard to track patches that aren't got by patchwork.

I agree with Trent's proposals for optimizing the code: It is better to just
call xc3028_winfast1800h_callback() if you ever need to reset xc3028 before the
tuner driver. I suspect, however, that you don't need to do such reset, since
the tuner driver will do it during its initialization, especially if you've
properly initialized the gpio lines.



Cheers,
Mauro
