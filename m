Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:18597 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaADOJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 09:09:38 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYV00F69RC04S50@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 04 Jan 2014 09:09:36 -0500 (EST)
Date: Sat, 04 Jan 2014 12:09:32 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 00/24] em28xx: split analog part into a separate module
Message-id: <20140104120932.3fb142ce@samsung.com>
In-reply-to: <52C71DA0.3000405@googlemail.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
 <52C71DA0.3000405@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 03 Jan 2014 21:29:20 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 28.12.2013 13:15, schrieb Mauro Carvalho Chehab:
> > This patch series split em28xx into a separate V4L2 driver,
> > allowing the new dvb-only chips to be supported without requiring
> > V4L2.
> >
> > While testing the original patchset, I noticed several issues with
> > HVR-950. The remaining patches on this series fix most of those
> > issues.
> >
> > There's one remaining issue: on my tests, when connecting the device
> > into an USB 3.0 port, the AC97 EMP202 is not properly detected. 
> > Also, the audio doesn't work fine. I'm still investigating what
> > would be the root cause for that.
> >
> > Mauro Carvalho Chehab (24):
> >   em28xx: move some video-specific functions to em28xx-video
> >   em28xx: some cosmetic changes
> >   em28xx: move analog-specific init to em28xx-video
> >   em28xx: make em28xx-video to be a separate module
> >   em28xx: initialize analog I2C devices at the right place
> >   em28xx-cards: remove a now dead code
> >   em28xx: fix a cut and paste error
> 
> I tried to review the core/V4L2 split patches [1-7] in detail, but it's
> nearly impossible.
> With one patch, you introduce issues which you then fix with other
> patches later.
> Patch 3 for example breaks compilation 2 times and introduces a deadlock
> and an oops...

That's actually the only patch that broke compilation. This patch was
actually generated as an intermediate step to patch 4, using git citool,
in order to make easier to review the code changes, splitting the code
move from the actual device split.

Anyway, it shouldn't break compilation.

The OOPS was fixed on a separate patch (patch 5). I opted to keep it in
separate, as it seemed interesting to preserve in git history why that
change happened. Eventually, I can reorder the patch to avoid the OOPS
to actually happen on bisect.

> Can you please rework these patches and resend them when you think they
> are ready for reviewing ?

Done. See Patch series v4.

> I've made some basic tests with the whole series applied and didn't
> observe any problems so far.

Ok. Then the better seems to apply them upstream, in order to allow
them to have a broader testing.

> Unfortunately I don't have a DVB-only device, too.

I'm acquiring two new em28xx devices. Let's hope that at least one of them
is DVB-only.

> 
> Regards,
> Frank
> 
> >   em28xx: add warn messages for timeout
> >   em28xx: improve extension information messages
> >   em28xx: convert i2c wait completion logic to use jiffies
> >   tvp5150: make read operations atomic
> >   tuner-xc2028: remove unused code
> >   em28xx: retry I2C ops if failed by timeout
> >   em28xx: remove a false positive warning
> >   em28xx: check if a device has audio earlier
> >   em28xx: properly implement AC97 wait code
> >   em28xx: initialize audio latter
> >   em28xx: improve I2C timeout error message
> >   em28xx: unify module version
> >   em28xx: Fix em28xx deplock
> >   em28xx: USB: adjust for changed 3.8 USB API
> >   em28xx: use a better value for I2C timeouts
> >   em28xx: don't return -ENODEV for I2C xfer errors
> >   em28xx: cleanup I2C debug messages
> >
> >  drivers/media/i2c/tvp5150.c              |  22 +-
> >  drivers/media/tuners/tuner-xc2028.c      |   9 -
> >  drivers/media/usb/em28xx/Kconfig         |   6 +-
> >  drivers/media/usb/em28xx/Makefile        |   5 +-
> >  drivers/media/usb/em28xx/em28xx-audio.c  |   9 +-
> >  drivers/media/usb/em28xx/em28xx-camera.c |   1 +
> >  drivers/media/usb/em28xx/em28xx-cards.c  | 310 ++--------------
> >  drivers/media/usb/em28xx/em28xx-core.c   | 295 +--------------
> >  drivers/media/usb/em28xx/em28xx-dvb.c    |  11 +-
> >  drivers/media/usb/em28xx/em28xx-i2c.c    | 226 ++++++------
> >  drivers/media/usb/em28xx/em28xx-input.c  |   7 +-
> >  drivers/media/usb/em28xx/em28xx-v4l.h    |  24 ++
> >  drivers/media/usb/em28xx/em28xx-vbi.c    |   1 +
> >  drivers/media/usb/em28xx/em28xx-video.c  | 607 +++++++++++++++++++++++++++++--
> >  drivers/media/usb/em28xx/em28xx.h        |  52 +--
> >  15 files changed, 835 insertions(+), 750 deletions(-)
> >  create mode 100644 drivers/media/usb/em28xx/em28xx-v4l.h
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
