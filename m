Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34326 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758968Ab2AFSdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 13:33:32 -0500
Received: by vcbfk14 with SMTP id fk14so1355639vcb.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 10:33:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHVY3emdMwEg9GPg1FMwVat3Xzn5AsoKZgveLvwHDxOFJiVtLA@mail.gmail.com>
References: <CAHVY3enRbcw-xKthuog5LXGMc_2tUAa0+owqbDm+C00mdWhV7w@mail.gmail.com>
	<CAHVY3emdMwEg9GPg1FMwVat3Xzn5AsoKZgveLvwHDxOFJiVtLA@mail.gmail.com>
Date: Fri, 6 Jan 2012 13:33:32 -0500
Message-ID: <CAGoCfixxiG+nxTRpLbvcy5CsktOtKk9k_3qwV4WUUhBHLaGPLQ@mail.gmail.com>
Subject: Re: em28xx: no sound on board 1b80:e309 (sveon stv40)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mario Ceresa <mrceresa@gmail.com>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 6, 2012 at 1:29 PM, Mario Ceresa <mrceresa@gmail.com> wrote:
> Ok boys: just to let you know that everything works now.
>
> thinking that the problem was with the audio input, I noticed that
> card=64 had an amux while card=19 no.
>
> .amux     = EM28XX_AMUX_LINE_IN,
>
> So I tried this card and modified the mplayer options accordingly:
>
> mplayer -tv device=/dev/video0:input=0:norm=PAL:forceaudio:alsa:immediatemode=0:audiorate=48000:amode=1:adevice=hw.2
> tv://
>
> notice the forceaudio parameter that reads the audio even if no source
> is reported from v4l (The same approach with card=19 does not work)
>
> The output was a bit slugglish so I switched off pulse audio control
> of the board (https://bbs.archlinux.org/viewtopic.php?id=114228) and
> now everything is ok!
>
> I hope this will help some lonenly googlers in the future :)
>
> Regards,
>
> Mario

Hi Mario,

Since you've spent the time to figure out the details of your
particular hardware, you should really consider submitting a patch to
the em28xx driver which adds your device's USB ID.  That would allow
others who have that hardware to have it work "out of the box" with no
need for figuring out the correct "cardid" value through
experimentation as you had to.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
