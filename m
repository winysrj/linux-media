Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.128.26]:20271 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127Ab1DKIyh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 04:54:37 -0400
Message-ID: <4DA2C1C2.30609@maxwell.research.nokia.com>
Date: Mon, 11 Apr 2011 11:54:26 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer
 management
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <Pine.LNX.4.64.1104011010530.9530@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1104011010530.9530@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Guennadi,

Thanks for the RFC! I have a few comments below.

Guennadi Liakhovetski wrote:
> A possibility to preallocate and initialise buffers of different sizes
> in V4L2 is required for an efficient implementation of asnapshot mode.
> This patch adds three new ioctl()s: VIDIOC_CREATE_BUFS,
> VIDIOC_DESTROY_BUFS, and VIDIOC_SUBMIT_BUF and defines respective data
> structures.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/video/v4l2-compat-ioctl32.c |    3 ++
>  drivers/media/video/v4l2-ioctl.c          |   43 +++++++++++++++++++++++++++++
>  include/linux/videodev2.h                 |   24 ++++++++++++++++
>  include/media/v4l2-ioctl.h                |    3 ++
>  4 files changed, 73 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
> index 7c26947..d71b289 100644
> --- a/drivers/media/video/v4l2-compat-ioctl32.c
> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> @@ -922,6 +922,9 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>  	case VIDIOC_DQEVENT:
>  	case VIDIOC_SUBSCRIBE_EVENT:
>  	case VIDIOC_UNSUBSCRIBE_EVENT:
> +	case VIDIOC_CREATE_BUFS:
> +	case VIDIOC_DESTROY_BUFS:
> +	case VIDIOC_SUBMIT_BUF:
>  		ret = do_video_ioctl(file, cmd, arg);
>  		break;
>  
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index a01ed39..b80a211 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -259,6 +259,9 @@ static const char *v4l2_ioctls[] = {
>  	[_IOC_NR(VIDIOC_DQEVENT)]	   = "VIDIOC_DQEVENT",
>  	[_IOC_NR(VIDIOC_SUBSCRIBE_EVENT)]  = "VIDIOC_SUBSCRIBE_EVENT",
>  	[_IOC_NR(VIDIOC_UNSUBSCRIBE_EVENT)] = "VIDIOC_UNSUBSCRIBE_EVENT",
> +	[_IOC_NR(VIDIOC_CREATE_BUFS)]      = "VIDIOC_CREATE_BUFS",
> +	[_IOC_NR(VIDIOC_DESTROY_BUFS)]     = "VIDIOC_DESTROY_BUFS",
> +	[_IOC_NR(VIDIOC_SUBMIT_BUF)]       = "VIDIOC_SUBMIT_BUF",
>  };
>  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
>  
> @@ -2184,6 +2187,46 @@ static long __video_do_ioctl(struct file *file,
>  		dbgarg(cmd, "type=0x%8.8x", sub->type);
>  		break;
>  	}
> +	case VIDIOC_CREATE_BUFS:
> +	{
> +		struct v4l2_create_buffers *create = arg;
> +
> +		if (!ops->vidioc_create_bufs)
> +			break;
> +		ret = check_fmt(ops, create->format.type);
> +		if (ret)
> +			break;
> +
> +		if (create->size)
> +			CLEAR_AFTER_FIELD(create, count);
> +
> +		ret = ops->vidioc_create_bufs(file, fh, create);
> +
> +		dbgarg(cmd, "count=%d\n", create->count);
> +		break;
> +	}
> +	case VIDIOC_DESTROY_BUFS:
> +	{
> +		struct v4l2_buffer_span *span = arg;
> +
> +		if (!ops->vidioc_destroy_bufs)
> +			break;
> +
> +		ret = ops->vidioc_destroy_bufs(file, fh, span);
> +
> +		dbgarg(cmd, "count=%d", span->count);
> +		break;
> +	}
> +	case VIDIOC_SUBMIT_BUF:
> +	{
> +		unsigned int *i = arg;
> +
> +		if (!ops->vidioc_submit_buf)
> +			break;
> +		ret = ops->vidioc_submit_buf(file, fh, *i);
> +		dbgarg(cmd, "index=%d", *i);
> +		break;
> +	}
>  	default:
>  	{
>  		bool valid_prio = true;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index aa6c393..b6ef46e 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1847,6 +1847,26 @@ struct v4l2_dbg_chip_ident {
>  	__u32 revision;    /* chip revision, chip specific */
>  } __attribute__ ((packed));
>  
> +/* VIDIOC_DESTROY_BUFS */
> +struct v4l2_buffer_span {
> +	__u32			index;	/* output: buffers index...index + count - 1 have been created */
> +	__u32			count;
> +	__u32			reserved[2];
> +};
> +
> +/* struct v4l2_createbuffers::flags */
> +#define V4L2_BUFFER_FLAG_NO_CACHE_INVALIDATE	(1 << 0)
> +
> +/* VIDIOC_CREATE_BUFS */
> +struct v4l2_create_buffers {
> +	__u32			index;		/* output: buffers index...index + count - 1 have been created */
> +	__u32			count;
> +	__u32			flags;		/* V4L2_BUFFER_FLAG_* */
> +	enum v4l2_memory        memory;
> +	__u32			size;		/* Explicit size, e.g., for compressed streams */
> +	struct v4l2_format	format;		/* "type" is used always, the rest if size == 0 */
> +};

This assumes that the buffer indices that are returned by these ioctls
will be incremented beyond V4L2_MAX_FRAME. Don't you think this is an issue?

Proper handling of this still requires that once the count reaches
UINT_MAX, you do check that the buffer indices actually are available.
This might not be easier than keeping the range as contiguous as
possible and returning a set of buffer indices to the user. This would
change how the user needs to handle the buffer ids, so essentially
VIDIOC_{CREATE,DESTROY}_BUFS would operate on a array of buffer indices
rather than a single index.

I'm not fully convinced we absolutely must be able to operate on
multiple buffers at once either; most operations always work on single
buffers anyway.

Just my 0,05 euros --- as we have no smaller coins in here. :-)

>  /*
>   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
>   *
> @@ -1937,6 +1957,10 @@ struct v4l2_dbg_chip_ident {
>  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
>  #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
>  
> +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> +#define VIDIOC_DESTROY_BUFS	_IOWR('V', 93, struct v4l2_buffer_span)
> +#define VIDIOC_SUBMIT_BUF	 _IOW('V', 94, int)
> +
>  /* Reminder: when adding new ioctls please add support for them to
>     drivers/media/video/v4l2-compat-ioctl32.c as well! */
>  
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index dd9f1e7..00962c6 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -122,6 +122,9 @@ struct v4l2_ioctl_ops {
>  	int (*vidioc_qbuf)    (struct file *file, void *fh, struct v4l2_buffer *b);
>  	int (*vidioc_dqbuf)   (struct file *file, void *fh, struct v4l2_buffer *b);
>  
> +	int (*vidioc_create_bufs) (struct file *file, void *fh, struct v4l2_create_buffers *b);
> +	int (*vidioc_destroy_bufs)(struct file *file, void *fh, struct v4l2_buffer_span *b);
> +	int (*vidioc_submit_buf)  (struct file *file, void *fh, unsigned int i);
>  
>  	int (*vidioc_overlay) (struct file *file, void *fh, unsigned int i);
>  	int (*vidioc_g_fbuf)   (struct file *file, void *fh,

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
