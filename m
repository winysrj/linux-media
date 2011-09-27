Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1170 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab1I0Keh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 06:34:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/9 v7] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Tue, 27 Sep 2011 12:34:20 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de> <20110901084229.GU12368@valkosipuli.localdomain> <Pine.LNX.4.64.1109080942172.31156@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109080942172.31156@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271234.20485.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, September 08, 2011 09:45:15 Guennadi Liakhovetski wrote:
> A possibility to preallocate and initialise buffers of different sizes
> in V4L2 is required for an efficient implementation of a snapshot
> mode. This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> VIDIOC_PREPARE_BUF and defines respective data structures.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> v7: added the "experimental" comment, as suggested by Sakari - thanks.
> 
>  drivers/media/video/v4l2-compat-ioctl32.c |   67 +++++++++++++++++++++++++---
>  drivers/media/video/v4l2-ioctl.c          |   29 ++++++++++++
>  include/linux/videodev2.h                 |   17 +++++++
>  include/media/v4l2-ioctl.h                |    2 +
>  4 files changed, 107 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
> index 61979b7..85758d2 100644
> --- a/drivers/media/video/v4l2-compat-ioctl32.c
> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> @@ -159,11 +159,16 @@ struct v4l2_format32 {
>  	} fmt;
>  };
>  
> -static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
> +struct v4l2_create_buffers32 {
> +	__u32			index;		/* output: buffers index...index + count - 1 have been created */
> +	__u32			count;
> +	enum v4l2_memory        memory;
> +	struct v4l2_format32	format;		/* filled in by the user, plane sizes calculated by the driver */
> +	__u32			reserved[8];
> +};
> +
> +static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
>  {
> -	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_format32)) ||
> -			get_user(kp->type, &up->type))
> -			return -EFAULT;
>  	switch (kp->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> @@ -192,11 +197,24 @@ static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user
>  	}
>  }
>  
> -static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
> +static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
> +{
> +	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_format32)) ||
> +			get_user(kp->type, &up->type))
> +			return -EFAULT;
> +	return __get_v4l2_format32(kp, up);
> +}
> +
> +static int get_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up)
> +{
> +	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_create_buffers32)) ||
> +	    copy_from_user(kp, up, offsetof(struct v4l2_create_buffers32, format.fmt)))
> +			return -EFAULT;
> +	return __get_v4l2_format32(&kp->format, &up->format);
> +}
> +
> +static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
>  {
> -	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_format32)) ||
> -		put_user(kp->type, &up->type))
> -		return -EFAULT;
>  	switch (kp->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> @@ -225,6 +243,22 @@ static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user
>  	}
>  }
>  
> +static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
> +{
> +	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_format32)) ||
> +		put_user(kp->type, &up->type))
> +		return -EFAULT;
> +	return __put_v4l2_format32(kp, up);
> +}
> +
> +static int put_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up)
> +{
> +	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_create_buffers32)) ||
> +	    copy_to_user(up, kp, offsetof(struct v4l2_create_buffers32, format.fmt)))
> +			return -EFAULT;
> +	return __put_v4l2_format32(&kp->format, &up->format);
> +}
> +
>  struct v4l2_standard32 {
>  	__u32		     index;
>  	__u32		     id[2]; /* __u64 would get the alignment wrong */
> @@ -702,6 +736,8 @@ static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *u
>  #define VIDIOC_S_EXT_CTRLS32    _IOWR('V', 72, struct v4l2_ext_controls32)
>  #define VIDIOC_TRY_EXT_CTRLS32  _IOWR('V', 73, struct v4l2_ext_controls32)
>  #define	VIDIOC_DQEVENT32	_IOR ('V', 89, struct v4l2_event32)
> +#define VIDIOC_CREATE_BUFS32	_IOWR('V', 92, struct v4l2_create_buffers32)
> +#define VIDIOC_PREPARE_BUF32	_IOW ('V', 93, struct v4l2_buffer32)
>  
>  #define VIDIOC_OVERLAY32	_IOW ('V', 14, s32)
>  #define VIDIOC_STREAMON32	_IOW ('V', 18, s32)
> @@ -721,6 +757,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  		struct v4l2_standard v2s;
>  		struct v4l2_ext_controls v2ecs;
>  		struct v4l2_event v2ev;
> +		struct v4l2_create_buffers v2crt;
>  		unsigned long vx;
>  		int vi;
>  	} karg;
> @@ -751,6 +788,8 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	case VIDIOC_S_INPUT32: cmd = VIDIOC_S_INPUT; break;
>  	case VIDIOC_G_OUTPUT32: cmd = VIDIOC_G_OUTPUT; break;
>  	case VIDIOC_S_OUTPUT32: cmd = VIDIOC_S_OUTPUT; break;
> +	case VIDIOC_CREATE_BUFS32: cmd = VIDIOC_CREATE_BUFS; break;
> +	case VIDIOC_PREPARE_BUF32: cmd = VIDIOC_PREPARE_BUF; break;
>  	}
>  
>  	switch (cmd) {
> @@ -775,6 +814,12 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  		compatible_arg = 0;
>  		break;
>  
> +	case VIDIOC_CREATE_BUFS:
> +		err = get_v4l2_create32(&karg.v2crt, up);
> +		compatible_arg = 0;
> +		break;
> +
> +	case VIDIOC_PREPARE_BUF:
>  	case VIDIOC_QUERYBUF:
>  	case VIDIOC_QBUF:
>  	case VIDIOC_DQBUF:
> @@ -860,6 +905,10 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  		err = put_v4l2_format32(&karg.v2f, up);
>  		break;
>  
> +	case VIDIOC_CREATE_BUFS:
> +		err = put_v4l2_create32(&karg.v2crt, up);
> +		break;
> +
>  	case VIDIOC_QUERYBUF:
>  	case VIDIOC_QBUF:
>  	case VIDIOC_DQBUF:
> @@ -959,6 +1008,8 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>  	case VIDIOC_DQEVENT32:
>  	case VIDIOC_SUBSCRIBE_EVENT:
>  	case VIDIOC_UNSUBSCRIBE_EVENT:
> +	case VIDIOC_CREATE_BUFS32:
> +	case VIDIOC_PREPARE_BUF32:
>  		ret = do_video_ioctl(file, cmd, arg);
>  		break;
>  
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 21c49dc..3c2295b 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -273,6 +273,8 @@ static const char *v4l2_ioctls[] = {
>  	[_IOC_NR(VIDIOC_DQEVENT)]	   = "VIDIOC_DQEVENT",
>  	[_IOC_NR(VIDIOC_SUBSCRIBE_EVENT)]  = "VIDIOC_SUBSCRIBE_EVENT",
>  	[_IOC_NR(VIDIOC_UNSUBSCRIBE_EVENT)] = "VIDIOC_UNSUBSCRIBE_EVENT",
> +	[_IOC_NR(VIDIOC_CREATE_BUFS)]      = "VIDIOC_CREATE_BUFS",
> +	[_IOC_NR(VIDIOC_PREPARE_BUF)]      = "VIDIOC_PREPARE_BUF",
>  };
>  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
>  
> @@ -2096,6 +2098,33 @@ static long __video_do_ioctl(struct file *file,
>  		dbgarg(cmd, "type=0x%8.8x", sub->type);
>  		break;
>  	}
> +	case VIDIOC_CREATE_BUFS:
> +	{
> +		struct v4l2_create_buffers *create = arg;
> +
> +		if (!ops->vidioc_create_bufs)
> +			break;

Just as with REQBUFS you need to add code here to handle priority checking:

		if (ret_prio) {
			ret = ret_prio;
			break;
		}

> +		ret = check_fmt(ops, create->format.type);
> +		if (ret)
> +			break;
> +
> +		ret = ops->vidioc_create_bufs(file, fh, create);
> +
> +		dbgarg(cmd, "count=%d @ %d\n", create->count, create->index);
> +		break;
> +	}
> +	case VIDIOC_PREPARE_BUF:
> +	{
> +		struct v4l2_buffer *b = arg;
> +
> +		if (!ops->vidioc_prepare_buf)
> +			break;

You need a check_fmt call here as well (just as in QBUF et al).

> +		ret = ops->vidioc_prepare_buf(file, fh, b);
> +
> +		dbgarg(cmd, "index=%d", b->index);
> +		break;
> +	}
>  	default:
>  		if (!ops->vidioc_default)
>  			break;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index a5359c6..6e87ea9 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -653,6 +653,9 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_ERROR	0x0040
>  #define V4L2_BUF_FLAG_TIMECODE	0x0100	/* timecode field is valid */
>  #define V4L2_BUF_FLAG_INPUT     0x0200  /* input field is valid */
> +/* Cache handling flags */
> +#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0400
> +#define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x0800
>  
>  /*
>   *	O V E R L A Y   P R E V I E W
> @@ -2098,6 +2101,15 @@ struct v4l2_dbg_chip_ident {
>  	__u32 revision;    /* chip revision, chip specific */
>  } __attribute__ ((packed));
>  
> +/* VIDIOC_CREATE_BUFS */
> +struct v4l2_create_buffers {
> +	__u32			index;		/* output: buffers index...index + count - 1 have been created */
> +	__u32			count;
> +	enum v4l2_memory        memory;
> +	struct v4l2_format	format;		/* "type" is used always, the rest if sizeimage == 0 */
> +	__u32			reserved[8];
> +};
> +
>  /*
>   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
>   *
> @@ -2188,6 +2200,11 @@ struct v4l2_dbg_chip_ident {
>  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
>  #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
>  
> +/* Experimental, the below two ioctls may change over the next couple of kernel
> +   versions */
> +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> +#define VIDIOC_PREPARE_BUF	 _IOW('V', 93, struct v4l2_buffer)

I think I would prefer _IOWR here. QBUF etc. also use IOWR and you never know
what you might return in the future. At the very least using IOWR allows us
to update the state field, which would be a perfectly reasonable thing to do.

> +
>  /* Reminder: when adding new ioctls please add support for them to
>     drivers/media/video/v4l2-compat-ioctl32.c as well! */
>  
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index dd9f1e7..55cf8ae 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -122,6 +122,8 @@ struct v4l2_ioctl_ops {
>  	int (*vidioc_qbuf)    (struct file *file, void *fh, struct v4l2_buffer *b);
>  	int (*vidioc_dqbuf)   (struct file *file, void *fh, struct v4l2_buffer *b);
>  
> +	int (*vidioc_create_bufs)(struct file *file, void *fh, struct v4l2_create_buffers *b);
> +	int (*vidioc_prepare_buf)(struct file *file, void *fh, const struct v4l2_buffer *b);
>  
>  	int (*vidioc_overlay) (struct file *file, void *fh, unsigned int i);
>  	int (*vidioc_g_fbuf)   (struct file *file, void *fh,
> 

Regards,

	Hans
