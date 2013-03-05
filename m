Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3165 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3CEHr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 02:47:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.9] cx231xx: v4l2 compliance and big-endian fixes.
Date: Tue, 5 Mar 2013 08:47:20 +0100
Cc: "Matt Gomboc" <gomboc0@gmail.com>
References: <201302150946.59696.hverkuil@xs4all.nl>
In-Reply-To: <201302150946.59696.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303050847.20585.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Small update: I've added Matt Gomboc's patch to this series as well:

http://patchwork.linuxtv.org/patch/17026/

Regards,

	Hans

On Fri February 15 2013 09:46:59 Hans Verkuil wrote:
> This patch series cleans up the cx231xx driver based on v4l2-compliance
> reports.
> 
> It is identical to the RFCv2 patch series I posted a week ago:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg58508.html
> 
> I have tested this on various cx231xx devices. However, I have no hardware
> that supports the radio tuner, so that's untested. To my knowledge, no such
> devices exist at the moment anyway.
> 
> Also note that the MPEG encoder support does not seem to work. It didn't work
> before these patches are applied, and it doesn't work afterwards. At best it
> will stream for a bit and then hang the machine. While I did convert the 417
> code to have it pass the compliance tests, I also disable 417 support in the
> single card that supports it (gracefully provided by Conexant for which I
> want to thank them!) until someone can find the time to dig into it and
> figure out what is wrong. Note that that board is an evaluation board and not
> a consumer product.
> 
> In addition the vbi support is flaky as well. It was flaky before this patch
> series, and it is equally flaky afterwards. I have managed to get something
> to work only on rare occasions and only for NTSC, never for PAL.
> 
> Finally I have tested this on a big-endian machine so there are a bunch of
> patches fixing a lot of endianness problems.
> 
> A general note regarding this driver: I've found this to be a particularly
> fragile driver. Things like changing formats/standards, unplugging at
> unexpected times and vbi support all seem very prone to errors. I have
> serious doubts about the disconnect handling: this code really should use the
> core support for handling such events (in particular the v4l2_device release
> callback).
> 
> Regards,
> 
>         Hans
> 
> The following changes since commit ed72d37a33fdf43dc47787fe220532cdec9da528:
> 
>   [media] media: Add 0x3009 USB PID to ttusb2 driver (fixed diff) (2013-02-13 18:05:29 -0200)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git cx231xx
> 
> for you to fetch changes up to bb047a3fd001f7de36f94058c9c296332c494f83:
> 
>   cx231xx: fix gpio big-endian problems (2013-02-15 09:42:39 +0100)
> 
> ----------------------------------------------------------------
> Hans Verkuil (26):
>       cx231xx: add device_caps support to QUERYCAP.
>       cx231xx: add required VIDIOC_DBG_G_CHIP_IDENT support.
>       cx231xx: clean up radio support.
>       cx231xx: remove broken audio input support from the driver.
>       cx231xx: fix tuner compliance issues.
>       cx231xx: zero priv field and use right width in try_fmt
>       cx231xx: fix frequency clamping.
>       cx231xx: fix vbi compliance issues.
>       cx231xx: convert to the control framework.
>       cx231xx: add struct v4l2_fh to get prio and event support.
>       cx231xx: remove current_norm usage.
>       cx231xx: replace ioctl by unlocked_ioctl.
>       cx231xx: get rid of a bunch of unused cx231xx_fh fields.
>       cx231xx: improve std handling.
>       cx231xx-417: remove empty functions.
>       cx231xx-417: use one querycap for all device nodes.
>       cx231xx-417: fix g/try_fmt compliance problems
>       cx231xx-417: checkpatch cleanups.
>       cx231xx-417: share ioctls with cx231xx-video.
>       cx231xx-417: convert to the control framework.
>       cx231xx: remove bogus driver prefix in log messages.
>       cx231xx: disable 417 support from the Conexant video grabber
>       cx231xx: don't reset width/height on first open.
>       cx231xx: don't use port 3 on the Conexant video grabber.
>       cx231xx: fix big-endian problems.
>       cx231xx: fix gpio big-endian problems
> 
>  drivers/media/usb/cx231xx/cx231xx-417.c     | 1178 +++++++++++++++++++++++++------------------------------------
>  drivers/media/usb/cx231xx/cx231xx-audio.c   |    8 +-
>  drivers/media/usb/cx231xx/cx231xx-avcore.c  |   83 ++---
>  drivers/media/usb/cx231xx/cx231xx-cards.c   |   24 +-
>  drivers/media/usb/cx231xx/cx231xx-core.c    |    2 +-
>  drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c |    2 +-
>  drivers/media/usb/cx231xx/cx231xx-vbi.c     |   25 +-
>  drivers/media/usb/cx231xx/cx231xx-video.c   |  589 ++++++++-----------------------
>  drivers/media/usb/cx231xx/cx231xx.h         |   54 ++-
>  9 files changed, 740 insertions(+), 1225 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
