Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:60890 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab3AEMvX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2013 07:51:23 -0500
Received: by mail-we0-f175.google.com with SMTP id z53so8435448wey.20
        for <linux-media@vger.kernel.org>; Sat, 05 Jan 2013 04:51:21 -0800 (PST)
Message-ID: <50E821E3.5020508@googlemail.com>
Date: Sat, 05 Jan 2013 13:51:47 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL FOR 3.9] em28xx videobuf2 support and v4l2-compliance
 fixes
References: <CAGoCfiyPaaE5aAkjQdPGD_e9s3K6L+sv+fwGHxeoY5K1+iBYpQ@mail.gmail.com>
In-Reply-To: <CAGoCfiyPaaE5aAkjQdPGD_e9s3K6L+sv+fwGHxeoY5K1+iBYpQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.01.2013 20:41, schrieb Devin Heitmueller:
> Hello Mauro,
>
> Please pull the following series for 3.9, which ports em28xx to VB2 as
> well as applying Hans Verkuil's v4l2-compliance fixes for em28xx.
>
> Thanks,
>
> Devin
>
> The following changes since commit 8cd7085ff460ead3aba6174052a408f4ad52ac36:
>
>   [media] get_dvb_firmware: Fix the location of firmware for Terratec
> HTC (2013-01-01 11:18:26 -0200)
>
> are available in the git repository at:
>
>   git://git.kernellabs.com/dheitmueller/linuxtv.git v39staging
>
> for you to fetch changes up to 381abfc158c2dad81a558a3d3ff924fc7f80d277:
>
>   em28xx: convert to videobuf2 (2013-01-04 14:16:24 -0500)
>
> ----------------------------------------------------------------
> Devin Heitmueller (1):
>       em28xx: convert to videobuf2
>
> Hans Verkuil (14):
>       em28xx: fix querycap.
>       em28xx: remove bogus input/audio ioctls for the radio device.
>       em28xx: fix VIDIOC_DBG_G_CHIP_IDENT compliance errors.
>       em28xx: fix tuner/frequency handling
>       v4l2-ctrls: add a notify callback.
>       em28xx: convert to the control framework.
>       em28xx: convert to v4l2_fh, fix priority handling.
>       em28xx: add support for control events.
>       em28xx: fill in readbuffers and fix incorrect return code.
>       em28xx: fix broken TRY_FMT.
>       tvp5150: remove compat control ops.
>       em28xx: std fixes: don't implement in webcam mode, and fix std changes.
>       em28xx: remove sliced VBI support.
>       em28xx: zero vbi_format reserved array and add try_vbi_fmt.
>
>  Documentation/video4linux/v4l2-controls.txt |   22 +-
>  drivers/media/i2c/tvp5150.c                 |    7 -
>  drivers/media/usb/em28xx/Kconfig            |    3 +-
>  drivers/media/usb/em28xx/em28xx-cards.c     |   31 +-
>  drivers/media/usb/em28xx/em28xx-dvb.c       |    4 +-
>  drivers/media/usb/em28xx/em28xx-vbi.c       |  123 ++-
>  drivers/media/usb/em28xx/em28xx-video.c     | 1159 ++++++++-------------------
>  drivers/media/usb/em28xx/em28xx.h           |   38 +-
>  drivers/media/v4l2-core/v4l2-ctrls.c        |   18 +
>  include/media/v4l2-ctrls.h                  |   25 +
>  10 files changed, 504 insertions(+), 926 deletions(-)
>

The server is down ?


