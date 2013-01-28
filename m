Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4627 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab3A1KBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 05:01:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [REVIEW PATCH 11/12] em28xx: make ioctl VIDIOC_DBG_G_CHIP_IDENT available for radio devices
Date: Mon, 28 Jan 2013 11:00:55 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com> <1359134822-4585-12-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1359134822-4585-12-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301281100.55798.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri January 25 2013 18:27:01 Frank Schäfer wrote:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-video.c |    1 +
>  1 Datei geändert, 1 Zeile hinzugefügt(+)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index dd05cfb..e97b095 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -1695,6 +1695,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	.vidioc_g_register    = vidioc_g_register,
>  	.vidioc_s_register    = vidioc_s_register,
> +	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
>  #endif
>  };
>  
> 

g_chip_ident can be moved out of ADV_DEBUG, both for video and radio devices.

Regards,

	Hans
