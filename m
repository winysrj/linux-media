Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4431 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab3CILF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Mar 2013 06:05:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [PATCH] em28xx: set the timestamp type for video and vbi vb2_queues
Date: Sat, 9 Mar 2013 12:05:48 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1362826381-4460-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362826381-4460-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303091205.48761.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat March 9 2013 11:53:01 Frank Schäfer wrote:
> The em28xx driver obtains the timestamps using function v4l2_get_timestamp(),
> which produces a montonic timestamp.
> 
> Fixes the warnings appearing in the system log since commit 6aa69f99
> "[media] vb2: Add support for non monotonic timestamps"
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/usb/em28xx/em28xx-video.c |    2 ++
>  1 Datei geändert, 2 Zeilen hinzugefügt(+)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 93fc620..d585c19 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -700,6 +700,7 @@ int em28xx_vb2_setup(struct em28xx *dev)
>  	q = &dev->vb_vidq;
>  	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  	q->drv_priv = dev;
>  	q->buf_struct_size = sizeof(struct em28xx_buffer);
>  	q->ops = &em28xx_video_qops;
> @@ -713,6 +714,7 @@ int em28xx_vb2_setup(struct em28xx *dev)
>  	q = &dev->vb_vbiq;
>  	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
>  	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  	q->drv_priv = dev;
>  	q->buf_struct_size = sizeof(struct em28xx_buffer);
>  	q->ops = &em28xx_vbi_qops;
> 
