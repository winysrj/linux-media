Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42065 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab0I0Dsh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 23:48:37 -0400
Received: by ewy23 with SMTP id 23so1164101ewy.19
        for <linux-media@vger.kernel.org>; Sun, 26 Sep 2010 20:48:35 -0700 (PDT)
Date: Mon, 27 Sep 2010 13:49:04 -0400
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Felipe Sanches <juca@members.fsf.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>
Subject: Re: [PATCH v2] tm6000+audio
Message-ID: <20100927134904.0ee9ca5b@glory.local>
In-Reply-To: <4C9ADEF6.4040809@redhat.com>
References: <20100622180521.614eb85d@glory.loctelecom.ru>
	<4C20D91F.500@redhat.com>
	<4C212A90.7070707@arcor.de>
	<4C213257.6060101@redhat.com>
	<4C222561.4040605@arcor.de>
	<4C224753.2090109@redhat.com>
	<4C225A5C.7050103@arcor.de>
	<20100716161623.2f3314df@glory.loctelecom.ru>
	<4C4C4DCA.1050505@redhat.com>
	<20100728113158.0f1495c0@glory.loctelecom.ru>
	<4C4FD659.9050309@arcor.de>
	<20100729140936.5bddd275@glory.loctelecom.ru>
	<4C51ADB5.7010906@redhat.com>
	<20100731122428.4ee569b4@glory.loctelecom.ru>
	<4C53A837.3070700@redhat.com>
	<20100825043746.225a352a@glory.local>
	<4C7543DA.1070307@redhat.com>
	<AANLkTimr3=1QHzX3BzUVyo6uqLdCKt8SS9sDtHfZtHGZ@mail.gmail.com>
	<4C767302.7070506@redhat.com>
	<20100920160715.7594ee2e@glory.local>
	<4C99177F.9060100@redhat.com>
	<20100923124524.73a28b0c@glory.local>
	<4C9ADEF6.4040809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

> Em 23-09-2010 13:45, Dmitri Belimov escreveu:
> > Hi
> > 
> >> Em 20-09-2010 17:07, Dmitri Belimov escreveu:
> >>> Hi 
> >>>
> >>> I rework my last patch for audio and now audio works well. This
> >>> patch can be submited to GIT tree Quality of audio now is good for
> >>> SECAM-DK. For other standard I set some value from datasheet need
> >>> some tests.
> >>>
> >>> 1. Fix pcm buffer overflow
> >>> 2. Rework pcm buffer fill method
> >>> 3. Swap bytes in audio stream
> >>> 4. Change some registers value for TM6010
> >>> 5. Change pcm buffer size
> >>> --- a/drivers/staging/tm6000/tm6000-stds.c
> >>> +++ b/drivers/staging/tm6000/tm6000-stds.c
> >>> @@ -96,6 +96,7 @@ static struct tm6000_std_tv_settings tv_stds[]
> >>> = { 
> >>>  			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL,
> >>> 0xdc}, {TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> >>> +			{TM6010_REQ08_R05_A_STANDARD_MOD,
> >>> 0x21}, /* FIXME */
> >>
> >> This didn't seem to work for PAL-M. Probably, the right value for
> >> it is 0x22, to follow NTSC/M, since both uses the same audio
> >> standard.
> >>
> >> On some tests, I was able to receive some audio there, at the
> >> proper rate, with a tm6010-based device. It died when I tried to
> >> change the channel, so I didn't rear yet the real audio, but I
> >> suspect it will work on my next tests.
> >>
> >> Yet, is being hard to test, as the driver has a some spinlock logic
> >> broken. I'm enclosing the logs.
> > 
> > Yes. I have some as crash from mplayer and arecord.
> > 
> >> I was able to test only when using a monitor on the same machine.
> >> All trials of using vnc and X11 export ended by not receiving any
> >> audio and hanging the machine.
> >>
> >> I suspect that we need to fix the spinlock issue, in order to
> >> better test it.
> > 
> > Who can fix it?
> 
> Well, any of us ;)
> 
> I did a BKL lock fix series of patches, and hverkuil is improving
> them. They'll make easier to avoid problems inside tm6000. We just
> need to make sure that we'll hold/release the proper locks at
> tm6000-alsa, after applying it at the mainstream.

I found that mplayer crashed when call usb_control_msg and kfree functions.

With my best regards, Dmitry.
