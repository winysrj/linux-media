Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44282 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbeJERp7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 13:45:59 -0400
Received: by mail-lj1-f193.google.com with SMTP id v6-v6so11163420ljc.11
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2018 03:47:44 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 5 Oct 2018 12:47:41 +0200
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        snawrocki@kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 10/11] v4l2-ioctl: remove unused vidioc_g/s_crop
Message-ID: <20181005104741.GU24305@bigcity.dyn.berto.se>
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
 <20181005074911.47574-11-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181005074911.47574-11-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your work.

On 2018-10-05 09:49:10 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Now that all drivers have dropped vidioc_g/s_crop we can remove
> support for them in the V4L2 core.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

If the quirk patch hurt my head this makes me smile!

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/v4l2-core/v4l2-dev.c   | 4 ++--
>  drivers/media/v4l2-core/v4l2-ioctl.c | 4 ----
>  include/media/v4l2-ioctl.h           | 8 --------
>  3 files changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index 69e775930fc4..d81141d51faa 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -621,9 +621,9 @@ static void determine_valid_ioctls(struct video_device *vdev)
>  		SET_VALID_IOCTL(ops, VIDIOC_TRY_DECODER_CMD, vidioc_try_decoder_cmd);
>  		SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes);
>  		SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMEINTERVALS, vidioc_enum_frameintervals);
> -		if (ops->vidioc_g_crop || ops->vidioc_g_selection)
> +		if (ops->vidioc_g_selection)
>  			set_bit(_IOC_NR(VIDIOC_G_CROP), valid_ioctls);
> -		if (ops->vidioc_s_crop || ops->vidioc_s_selection)
> +		if (ops->vidioc_s_selection)
>  			set_bit(_IOC_NR(VIDIOC_S_CROP), valid_ioctls);
>  		SET_VALID_IOCTL(ops, VIDIOC_G_SELECTION, vidioc_g_selection);
>  		SET_VALID_IOCTL(ops, VIDIOC_S_SELECTION, vidioc_s_selection);
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 63a92285de39..a59954d351a2 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2207,8 +2207,6 @@ static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
>  	};
>  	int ret;
>  
> -	if (ops->vidioc_g_crop)
> -		return ops->vidioc_g_crop(file, fh, p);
>  	/* simulate capture crop using selection api */
>  
>  	/* crop means compose for output devices */
> @@ -2239,8 +2237,6 @@ static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
>  		.r = p->c,
>  	};
>  
> -	if (ops->vidioc_s_crop)
> -		return ops->vidioc_s_crop(file, fh, p);
>  	/* simulate capture crop using selection api */
>  
>  	/* crop means compose for output devices */
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index 5848d92c30da..85fdd3f4b8ad 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -222,10 +222,6 @@ struct v4l2_fh;
>   *	:ref:`VIDIOC_S_MODULATOR <vidioc_g_modulator>` ioctl
>   * @vidioc_cropcap: pointer to the function that implements
>   *	:ref:`VIDIOC_CROPCAP <vidioc_cropcap>` ioctl
> - * @vidioc_g_crop: pointer to the function that implements
> - *	:ref:`VIDIOC_G_CROP <vidioc_g_crop>` ioctl
> - * @vidioc_s_crop: pointer to the function that implements
> - *	:ref:`VIDIOC_S_CROP <vidioc_g_crop>` ioctl
>   * @vidioc_g_selection: pointer to the function that implements
>   *	:ref:`VIDIOC_G_SELECTION <vidioc_g_selection>` ioctl
>   * @vidioc_s_selection: pointer to the function that implements
> @@ -493,10 +489,6 @@ struct v4l2_ioctl_ops {
>  	/* Crop ioctls */
>  	int (*vidioc_cropcap)(struct file *file, void *fh,
>  			      struct v4l2_cropcap *a);
> -	int (*vidioc_g_crop)(struct file *file, void *fh,
> -			     struct v4l2_crop *a);
> -	int (*vidioc_s_crop)(struct file *file, void *fh,
> -			     const struct v4l2_crop *a);
>  	int (*vidioc_g_selection)(struct file *file, void *fh,
>  				  struct v4l2_selection *s);
>  	int (*vidioc_s_selection)(struct file *file, void *fh,
> -- 
> 2.18.0
> 

-- 
Regards,
Niklas Söderlund
