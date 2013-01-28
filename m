Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2683 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3A1KB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 05:01:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [REVIEW PATCH 00/12] em28xx: ioctl fixes/clean-ups
Date: Mon, 28 Jan 2013 11:01:51 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301281101.51719.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri January 25 2013 18:26:50 Frank Schäfer wrote:
> This patch series addresses some issues with the ioctl code of the em28xx driver:
> Patches 1-5 and 11 fix and clean up the enabling/disabling of the ioctls 
> depending on the device type and equipment.
> Patches 6-10 remove some obsolete/useless code.
> Patch 12 improves the VBI support detection and device node registration.
> 
> 
> Frank Schäfer (12):
>   em28xx: use v4l2_disable_ioctl() to disable ioctls VIDIOC_QUERYSTD,
>     VIDIOC_G/S_STD
>   em28xx: disable tuner related ioctls for video and VBI devices
>     without tuner
>   em28xx: use v4l2_disable_ioctl() to disable ioctls VIDIOC_G_AUDIO and
>     VIDIOC_S_AUDIO
>   em28xx: use v4l2_disable_ioctl() to disable ioctl VIDIOC_S_PARM
>   em28xx: disable ioctl VIDIOC_S_PARM for VBI devices
>   em28xx: make ioctls VIDIOC_G/S_PARM working for VBI devices
>   em28xx: remove ioctl VIDIOC_CROPCAP
>   em28xx: get rid of duplicate function vidioc_s_fmt_vbi_cap()
>   em28xx: VIDIOC_G_TUNER: remove unneeded setting of tuner type
>   em28xx: remove obsolete device state checks from the ioctl functions
>   em28xx: make ioctl VIDIOC_DBG_G_CHIP_IDENT available for radio
>     devices
>   em28xx: do not claim VBI support if the device is a camera
> 
>  drivers/media/usb/em28xx/em28xx-core.c  |    5 ++
>  drivers/media/usb/em28xx/em28xx-video.c |  147 +++++++------------------------
>  2 Dateien geändert, 35 Zeilen hinzugefügt(+), 117 Zeilen entfernt(-)
> 
> 

After fixing the small comment I made for patch 11/12 you can add my Acked-by
for this patch series.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
