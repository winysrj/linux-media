Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2083 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZB0Nl2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 08:41:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: W.: v4l-dvb won't compile with new version
Date: Fri, 27 Feb 2009 14:41:20 +0100
Cc: schollsky@arcor.de, linux-media@vger.kernel.org
References: <12645682.1235740797539.JavaMail.ngmail@webmail10.arcor-online.net> <32779969.1235740935861.JavaMail.ngmail@webmail14.arcor-online.net>
In-Reply-To: <32779969.1235740935861.JavaMail.ngmail@webmail14.arcor-online.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902271441.20856.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 27 February 2009 14:22:15 schollsky@arcor.de wrote:
> Hi there,
>
> this I get when trying to compile latest mercurial .tar.gz:
>
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c: In function
> 'tvmixer_ioctl':
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:78: error: storage
> size of 'va' isn't known
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:114: error:
> 'VIDIOCGAUDIO' undeclared (first use in this function)
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:114: error: (Each
> undeclared identifier is reported only once
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:114: error: for
> each function it appears in.)
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:129: error:
> 'VIDEO_AUDIO_BASS' undeclared (first use in this function)
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:131: error:
> 'VIDEO_AUDIO_TREBLE' undeclared (first use in this function)
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:142: error:
> 'VIDEO_AUDIO_MUTE' undeclared (first use in this function)
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:143: error:
> 'VIDIOCSAUDIO' undeclared (first use in this function)
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:147: warning: type
> defaults to 'int' in declaration of '_min1'
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:149: warning: type
> defaults to 'int' in declaration of '_min1'
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:149: warning:
> comparison of distinct pointer types lacks a cast
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:78: warning: unused
> variable 'va' /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c: In
> function 'tvmixer_clients':
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:254: error: storage
> size of 'va' isn't known
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:286: error:
> 'VIDIOCGAUDIO' undeclared (first use in this function)
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:288: error:
> 'VIDEO_AUDIO_VOLUME' undeclared (first use in this function)
> /home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:254: warning:
> unused variable 'va' make[3]: ***
> [/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.o] Error 1 make[2]:
> *** [_module_/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-2.6.29-desktop-0.rc6.1.1mnb'
> make[1]: *** [default] Fehler 2
> make[1]: Leaving directory `/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l'
> make: *** [all] Fehler 2
>
> Any hints please?

Run 'make menuconfig' and disable this driver (should be in 'Audio devices 
for multimedia'). It's pointless for 2.6.29 anyway.

Mauro, I suggest we drop this driver altogether from our tree. The 
SOUND_TVMIXER config was removed from kernel 2.6.23 onwards (and the actual 
source from 2.6.25 onwards), it uses oss instead of alsa, assumes v4l1 i2c 
modules and it's never going to work with the new i2c API.

I actually thought it was removed already...

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
