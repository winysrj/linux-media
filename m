Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43206 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755640AbcJPPcy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Oct 2016 11:32:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hector Roussille <hector.roussille@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: media: omap4iss: fixed coding style issues
Date: Sun, 16 Oct 2016 18:30:36 +0300
Message-ID: <1923076.kU1We4cU9n@avalon>
In-Reply-To: <20161016151856.19209-1-hector.roussille@gmail.com>
References: <20161016151856.19209-1-hector.roussille@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hector,

Thank you for the patch.

On Sunday 16 Oct 2016 17:18:56 Hector Roussille wrote:
> Fixed coding style issues

What coding style issues ?

> 
> Signed-off-by: Hector Roussille <hector.roussille@gmail.com>
> ---
>  drivers/staging/media/omap4iss/iss_video.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss_video.c
> b/drivers/staging/media/omap4iss/iss_video.c index c16927a..8f2d374 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -297,8 +297,10 @@ iss_video_check_format(struct iss_video *video, struct
> iss_video_fh *vfh) */
> 
>  static int iss_video_queue_setup(struct vb2_queue *vq,
> -				 unsigned int *count, unsigned int 
*num_planes,

This line doesn't exceed the 80 columns limit, no need to split it.

> -				 unsigned int sizes[], struct device 
*alloc_devs[])
> +				 unsigned int *count,
> +				 unsigned int *num_planes,
> +				 unsigned int sizes[],
> +				 struct device *alloc_devs[])
>  {
>  	struct iss_video_fh *vfh = vb2_get_drv_priv(vq);
>  	struct iss_video *video = vfh->video;
> @@ -678,9 +680,10 @@ iss_video_get_selection(struct file *file, void *fh,
> struct v4l2_selection *sel) if (subdev == NULL)
>  		return -EINVAL;
> 
> -	/* Try the get selection operation first and fallback to get format if 
not
> -	 * implemented.
> +	/* Try the get selection operation first and fallback to

while do you split the line here and not right before the 80 columns limit ?

> +	 * get format if not implemented.
>  	 */

This isn't the preferred comment style for the kernel, see 
http://lkml.iu.edu/hypermail/linux/kernel/1607.1/00627.html. The problem 
doesn't predate your patch, but while at it you might want to fix it through 
the driver.

> +

How does adding a blank line here fix a coding style issue ?

>  	sdsel.pad = pad;
>  	ret = v4l2_subdev_call(subdev, pad, get_selection, NULL, &sdsel);
>  	if (!ret)

-- 
Regards,

Laurent Pinchart

