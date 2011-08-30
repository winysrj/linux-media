Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:36779 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab1H3VaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 17:30:17 -0400
Date: Wed, 31 Aug 2011 00:30:12 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/5] [media] v4l: add support for selection api
Message-ID: <20110830213012.GJ12368@valkosipuli.localdomain>
References: <1314363967-6448-1-git-send-email-t.stanislaws@samsung.com>
 <1314363967-6448-2-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314363967-6448-2-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomaas,

Thanks for the patch.

On Fri, Aug 26, 2011 at 03:06:03PM +0200, Tomasz Stanislawski wrote:
> This patch introduces new api for a precise control of cropping and composing
> features for video devices. The new ioctls are VIDIOC_S_SELECTION and
> VIDIOC_G_SELECTION.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/v4l2-compat-ioctl32.c |    2 ++
>  drivers/media/video/v4l2-ioctl.c          |   28 ++++++++++++++++++++++++++++
>  include/linux/videodev2.h                 |   27 +++++++++++++++++++++++++++
>  include/media/v4l2-ioctl.h                |    4 ++++
>  4 files changed, 61 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
> index 61979b7..f3b9d15 100644
> --- a/drivers/media/video/v4l2-compat-ioctl32.c
> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> @@ -927,6 +927,8 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>  	case VIDIOC_CROPCAP:
>  	case VIDIOC_G_CROP:
>  	case VIDIOC_S_CROP:
> +	case VIDIOC_G_SELECTION:
> +	case VIDIOC_S_SELECTION:
>  	case VIDIOC_G_JPEGCOMP:
>  	case VIDIOC_S_JPEGCOMP:
>  	case VIDIOC_QUERYSTD:
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 002ce13..6e02b45 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -225,6 +225,8 @@ static const char *v4l2_ioctls[] = {
>  	[_IOC_NR(VIDIOC_CROPCAP)]          = "VIDIOC_CROPCAP",
>  	[_IOC_NR(VIDIOC_G_CROP)]           = "VIDIOC_G_CROP",
>  	[_IOC_NR(VIDIOC_S_CROP)]           = "VIDIOC_S_CROP",
> +	[_IOC_NR(VIDIOC_G_SELECTION)]      = "VIDIOC_G_SELECTION",
> +	[_IOC_NR(VIDIOC_S_SELECTION)]      = "VIDIOC_S_SELECTION",
>  	[_IOC_NR(VIDIOC_G_JPEGCOMP)]       = "VIDIOC_G_JPEGCOMP",
>  	[_IOC_NR(VIDIOC_S_JPEGCOMP)]       = "VIDIOC_S_JPEGCOMP",
>  	[_IOC_NR(VIDIOC_QUERYSTD)]         = "VIDIOC_QUERYSTD",
> @@ -1714,6 +1716,32 @@ static long __video_do_ioctl(struct file *file,
>  		ret = ops->vidioc_s_crop(file, fh, p);
>  		break;
>  	}
> +	case VIDIOC_G_SELECTION:
> +	{
> +		struct v4l2_selection *p = arg;
> +
> +		if (!ops->vidioc_g_selection)
> +			break;
> +
> +		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
> +
> +		ret = ops->vidioc_g_selection(file, fh, p);
> +		if (!ret)
> +			dbgrect(vfd, "", &p->r);
> +		break;
> +	}
> +	case VIDIOC_S_SELECTION:
> +	{
> +		struct v4l2_selection *p = arg;
> +
> +		if (!ops->vidioc_s_selection)
> +			break;
> +		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
> +		dbgrect(vfd, "", &p->r);
> +
> +		ret = ops->vidioc_s_selection(file, fh, p);
> +		break;
> +	}
>  	case VIDIOC_CROPCAP:
>  	{
>  		struct v4l2_cropcap *p = arg;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index fca24cc..fad4fb3 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -738,6 +738,29 @@ struct v4l2_crop {
>  	struct v4l2_rect        c;
>  };
>  
> +/* Hints for adjustments of selection rectangle */
> +#define V4L2_SEL_SIZE_GE	0x00000001
> +#define V4L2_SEL_SIZE_LE	0x00000002
> +
> +enum v4l2_sel_target {
> +	V4L2_SEL_CROP_ACTIVE  = 0,
> +	V4L2_SEL_CROP_DEFAULT = 1,
> +	V4L2_SEL_CROP_BOUNDS  = 2,
> +	V4L2_SEL_COMPOSE_ACTIVE  = 256 + 0,
> +	V4L2_SEL_COMPOSE_DEFAULT = 256 + 1,
> +	V4L2_SEL_COMPOSE_BOUNDS  = 256 + 2,
> +	V4L2_SEL_COMPOSE_PADDED  = 256 + 3,

What about defining V4L2_SEL_COMPOSE_BASE, for exmaple, and using that
instead of plain 256?

Also, as you change rhe enum to __u32 as Laurent suggested already, the enum
no longer needs a name. Whether it should have nde is another question. I
don't see a reason to have one.

> +};
> +
> +struct v4l2_selection {
> +	enum v4l2_buf_type      type;
> +	enum v4l2_sel_target	target;
> +	__u32                   flags;
> +	struct v4l2_rect        r;
> +	__u32                   reserved[9];
> +};
> +
> +
>  /*
>   *      A N A L O G   V I D E O   S T A N D A R D
>   */
> @@ -2182,6 +2205,10 @@ struct v4l2_dbg_chip_ident {
>  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
>  #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
>  
> +/* Experimental crop/compose API */
> +#define VIDIOC_G_SELECTION	_IOWR('V', 92, struct v4l2_selection)
> +#define VIDIOC_S_SELECTION	_IOWR('V', 93, struct v4l2_selection)
> +
>  /* Reminder: when adding new ioctls please add support for them to
>     drivers/media/video/v4l2-compat-ioctl32.c as well! */
>  
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index dd9f1e7..2c0396b 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -194,6 +194,10 @@ struct v4l2_ioctl_ops {
>  					struct v4l2_crop *a);
>  	int (*vidioc_s_crop)           (struct file *file, void *fh,
>  					struct v4l2_crop *a);
> +	int (*vidioc_g_selection)      (struct file *file, void *fh,
> +					struct v4l2_selection *a);
> +	int (*vidioc_s_selection)      (struct file *file, void *fh,
> +					struct v4l2_selection *a);
>  	/* Compression ioctls */
>  	int (*vidioc_g_jpegcomp)       (struct file *file, void *fh,
>  					struct v4l2_jpegcompression *a);
> -- 
> 1.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sakari Ailus
sakari.ailus@iki.fi
