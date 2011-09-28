Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2456 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab1I1IGl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 04:06:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/9 v8] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Wed, 28 Sep 2011 10:06:28 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de> <201109271540.52649.hverkuil@xs4all.nl> <Pine.LNX.4.64.1109271847310.7004@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109271847310.7004@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281006.28387.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, September 27, 2011 18:54:53 Guennadi Liakhovetski wrote:
> A possibility to preallocate and initialise buffers of different sizes
> in V4L2 is required for an efficient implementation of a snapshot
> mode. This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> VIDIOC_PREPARE_BUF and defines respective data structures.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> v8: addressed comments from Hans - thanks:
> 
>     1. added checks in ioctl() preprocessing
>     2. changed VIDIOC_PREPARE_BUF to _IOWR
> 
>  drivers/media/video/v4l2-compat-ioctl32.c |   67 +++++++++++++++++++++++++---
>  drivers/media/video/v4l2-ioctl.c          |   36 +++++++++++++++
>  include/linux/videodev2.h                 |   17 +++++++
>  include/media/v4l2-ioctl.h                |    2 +
>  4 files changed, 114 insertions(+), 8 deletions(-)
> 

Almost:

> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 9d14523..7d75dd1 100644
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
> @@ -2099,6 +2102,15 @@ struct v4l2_dbg_chip_ident {
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
> @@ -2189,6 +2201,11 @@ struct v4l2_dbg_chip_ident {
>  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
>  #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
>  
> +/* Experimental, the below two ioctls may change over the next couple of kernel
> +   versions */
> +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> +#define VIDIOC_PREPARE_BUF	_IOWR('V', 93, struct v4l2_buffer)
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

If this is IOWR, then there shouldn't be a const here.

I have been thinking about this a bit more. Currently we only have a V4L2_BUF_FLAG_QUEUED
flag and no V4L2_BUF_FLAG_PREPARED flag. I do think we need this after all. The QUEUED flag
can't be used here as the buffer isn't queued yet, it's only prepared.

Regards,

	Hans

>  
>  	int (*vidioc_overlay) (struct file *file, void *fh, unsigned int i);
>  	int (*vidioc_g_fbuf)   (struct file *file, void *fh,
> 
