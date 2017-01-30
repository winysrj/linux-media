Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33095 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdA3RrU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 12:47:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Avraham Shukron <avraham.shukron@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: omap4iss: fix coding style issues
Date: Mon, 30 Jan 2017 19:47:40 +0200
Message-ID: <4008193.dpuA6Cf6Yl@avalon>
In-Reply-To: <1485626408-9768-1-git-send-email-avraham.shukron@gmail.com>
References: <1485626408-9768-1-git-send-email-avraham.shukron@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Avraham,

Thank you for the patch.

On Saturday 28 Jan 2017 20:00:08 Avraham Shukron wrote:
> This is a patch that fixes checkpatch.pl issues in omap4iss/iss_video.c
> Specifically, it fixes "line over 80 characters" issues
> 
> Signed-off-by: Avraham Shukron <avraham.shukron@gmail.com>

This looks OK to me. I've applied the patch to my tree and will push it to 
v4.11.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/staging/media/omap4iss/iss_video.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss_video.c
> b/drivers/staging/media/omap4iss/iss_video.c index c16927a..cdab053 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -298,7 +298,8 @@ iss_video_check_format(struct iss_video *video, struct
> iss_video_fh *vfh)
> 
>  static int iss_video_queue_setup(struct vb2_queue *vq,
>  				 unsigned int *count, unsigned int 
*num_planes,
> -				 unsigned int sizes[], struct device 
*alloc_devs[])
> +				 unsigned int sizes[],
> +				 struct device *alloc_devs[])
>  {
>  	struct iss_video_fh *vfh = vb2_get_drv_priv(vq);
>  	struct iss_video *video = vfh->video;
> @@ -678,8 +679,8 @@ iss_video_get_selection(struct file *file, void *fh,
> struct v4l2_selection *sel) if (subdev == NULL)
>  		return -EINVAL;
> 
> -	/* Try the get selection operation first and fallback to get format if 
not
> -	 * implemented.
> +	/* Try the get selection operation first and fallback to get format if
> +	 * not implemented.
>  	 */
>  	sdsel.pad = pad;
>  	ret = v4l2_subdev_call(subdev, pad, get_selection, NULL, &sdsel);

-- 
Regards,

Laurent Pinchart

