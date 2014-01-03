Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:49098 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbaACU2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jan 2014 15:28:15 -0500
Received: by mail-ee0-f51.google.com with SMTP id b15so6952810eek.10
        for <linux-media@vger.kernel.org>; Fri, 03 Jan 2014 12:28:14 -0800 (PST)
Message-ID: <52C71DA0.3000405@googlemail.com>
Date: Fri, 03 Jan 2014 21:29:20 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3 00/24] em28xx: split analog part into a separate module
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.12.2013 13:15, schrieb Mauro Carvalho Chehab:
> This patch series split em28xx into a separate V4L2 driver,
> allowing the new dvb-only chips to be supported without requiring
> V4L2.
>
> While testing the original patchset, I noticed several issues with
> HVR-950. The remaining patches on this series fix most of those
> issues.
>
> There's one remaining issue: on my tests, when connecting the device
> into an USB 3.0 port, the AC97 EMP202 is not properly detected. 
> Also, the audio doesn't work fine. I'm still investigating what
> would be the root cause for that.
>
> Mauro Carvalho Chehab (24):
>   em28xx: move some video-specific functions to em28xx-video
>   em28xx: some cosmetic changes
>   em28xx: move analog-specific init to em28xx-video
>   em28xx: make em28xx-video to be a separate module
>   em28xx: initialize analog I2C devices at the right place
>   em28xx-cards: remove a now dead code
>   em28xx: fix a cut and paste error

I tried to review the core/V4L2 split patches [1-7] in detail, but it's
nearly impossible.
With one patch, you introduce issues which you then fix with other
patches later.
Patch 3 for example breaks compilation 2 times and introduces a deadlock
and an oops...

Can you please rework these patches and resend them when you think they
are ready for reviewing ?

I've made some basic tests with the whole series applied and didn't
observe any problems so far.
Unfortunately I don't have a DVB-only device, too.

Regards,
Frank

>   em28xx: add warn messages for timeout
>   em28xx: improve extension information messages
>   em28xx: convert i2c wait completion logic to use jiffies
>   tvp5150: make read operations atomic
>   tuner-xc2028: remove unused code
>   em28xx: retry I2C ops if failed by timeout
>   em28xx: remove a false positive warning
>   em28xx: check if a device has audio earlier
>   em28xx: properly implement AC97 wait code
>   em28xx: initialize audio latter
>   em28xx: improve I2C timeout error message
>   em28xx: unify module version
>   em28xx: Fix em28xx deplock
>   em28xx: USB: adjust for changed 3.8 USB API
>   em28xx: use a better value for I2C timeouts
>   em28xx: don't return -ENODEV for I2C xfer errors
>   em28xx: cleanup I2C debug messages
>
>  drivers/media/i2c/tvp5150.c              |  22 +-
>  drivers/media/tuners/tuner-xc2028.c      |   9 -
>  drivers/media/usb/em28xx/Kconfig         |   6 +-
>  drivers/media/usb/em28xx/Makefile        |   5 +-
>  drivers/media/usb/em28xx/em28xx-audio.c  |   9 +-
>  drivers/media/usb/em28xx/em28xx-camera.c |   1 +
>  drivers/media/usb/em28xx/em28xx-cards.c  | 310 ++--------------
>  drivers/media/usb/em28xx/em28xx-core.c   | 295 +--------------
>  drivers/media/usb/em28xx/em28xx-dvb.c    |  11 +-
>  drivers/media/usb/em28xx/em28xx-i2c.c    | 226 ++++++------
>  drivers/media/usb/em28xx/em28xx-input.c  |   7 +-
>  drivers/media/usb/em28xx/em28xx-v4l.h    |  24 ++
>  drivers/media/usb/em28xx/em28xx-vbi.c    |   1 +
>  drivers/media/usb/em28xx/em28xx-video.c  | 607 +++++++++++++++++++++++++++++--
>  drivers/media/usb/em28xx/em28xx.h        |  52 +--
>  15 files changed, 835 insertions(+), 750 deletions(-)
>  create mode 100644 drivers/media/usb/em28xx/em28xx-v4l.h
>

