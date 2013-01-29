Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:58501 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3A2Nwk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 08:52:40 -0500
Received: by mail-qc0-f169.google.com with SMTP id t2so190940qcq.0
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2013 05:52:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201301291049.58085.hverkuil@xs4all.nl>
References: <201301291049.58085.hverkuil@xs4all.nl>
Date: Tue, 29 Jan 2013 08:52:39 -0500
Message-ID: <CAGoCfiwhRqo=_Na-mJYUcgH-28D2enePvx6Q3heMrz=SUTwLvA@mail.gmail.com>
Subject: Re: [RFC PATCH] em28xx: fix bytesperline calculation in TRY_FMT
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 29, 2013 at 4:49 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> This was part of my original em28xx patch series. That particular patch
> combined two things: this fix and the change where TRY_FMT would no
> longer return -EINVAL for unsupported pixelformats. The latter change was
> rejected (correctly), but we all forgot about the second part of the patch
> which fixed a real bug. I'm reposting just that fix.
>
> Regards,
>
>         Hans
>
> The bytesperline calculation was incorrect: it used the old width instead
> of the provided width, and it miscalculated the bytesperline value for the
> depth == 12 case.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/em28xx/em28xx-video.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 2eabf2a..070506d 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -906,7 +906,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>         f->fmt.pix.width = width;
>         f->fmt.pix.height = height;
>         f->fmt.pix.pixelformat = fmt->fourcc;
> -       f->fmt.pix.bytesperline = (dev->width * fmt->depth + 7) >> 3;
> +       f->fmt.pix.bytesperline = width * ((fmt->depth + 7) >> 3);
>         f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * height;
>         f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>         if (dev->progressive)

Reviewed-by: Devin Heitmueller <dheitmueller@kernellabs.com>

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
