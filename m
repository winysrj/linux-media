Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:54006 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1HHJTI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 05:19:08 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/6 v4] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Mon, 8 Aug 2011 11:16:41 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange> <Pine.LNX.4.64.1108050908590.26715@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1108050908590.26715@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108081116.41126.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi!

On Friday, August 05, 2011 09:47:13 Guennadi Liakhovetski wrote:
> A possibility to preallocate and initialise buffers of different sizes
> in V4L2 is required for an efficient implementation of asnapshot mode.
> This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> VIDIOC_PREPARE_BUF and defines respective data structures.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> v4:
> 
> 1. CREATE_BUFS now takes an array of plane sizes and a fourcc code in its 
>    argument, instead of a frame format specification, including 
>    documentation update
> 2. documentation improvements, as suggested by Hans
> 3. increased reserved fields to 18, as suggested by Sakari
> 
>  Documentation/DocBook/media/v4l/io.xml             |   17 ++
>  Documentation/DocBook/media/v4l/v4l2.xml           |    2 +
>  .../DocBook/media/v4l/vidioc-create-bufs.xml       |  161 
++++++++++++++++++++
>  .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   96 ++++++++++++
>  drivers/media/video/v4l2-compat-ioctl32.c          |    6 +
>  drivers/media/video/v4l2-ioctl.c                   |   26 +++
>  include/linux/videodev2.h                          |   18 +++
>  include/media/v4l2-ioctl.h                         |    2 +
>  8 files changed, 328 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> 

<snip>

> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index fca24cc..3cd0cb3 100644
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
> @@ -2092,6 +2095,18 @@ struct v4l2_dbg_chip_ident {
>  	__u32 revision;    /* chip revision, chip specific */
>  } __attribute__ ((packed));
>  
> +/* VIDIOC_CREATE_BUFS */
> +struct v4l2_create_buffers {
> +	__u32	index;	/* output: buffers index...index + count - 1 have been 
created */
> +	__u32	count;
> +	__u32	type;
> +	__u32	memory;
> +	__u32	fourcc;
> +	__u32	num_planes;
> +	__u32	sizes[VIDEO_MAX_PLANES];
> +	__u32	reserved[18];
> +};

I know you are going to hate me for this, but I've changed my mind: I think
this should use a struct v4l2_format after all.

This change of heart came out of discussions during the V4L2 brainstorm 
meeting last week. The only way to be sure the buffers are allocated optimally 
is if the driver has all the information. The easiest way to do that is by 
passing struct v4l2_format. This is also consistent with REQBUFS since that 
uses the information from the currently selected format (i.e. what you get 
back from VIDIOC_G_FMT).

There can be subtle behaviors such as allocating from different memory back 
based on the fourcc and the size of the image.

One reason why I liked passing sizes directly is that it allows the caller to 
ask for more memory than is strictly necessary.

However, while brainstorming last week the suggestion was made that there is 
no reason why the user can't set the sizeimage field in 
v4l2_pix_format(_mplane) to something higher. The S/TRY_FMT spec explicitly 
mentions that the sizeimage field is set by the driver, but for the new 
CREATEBUFS ioctl no such limitation has to be placed. The only thing necessary 
is to ensure that sizeimage is not too small (and you probably want some 
sanity check against crazy values as well).

This way the decision on how to allocate memory is the same between REQBUFS 
and CREATEBUFS (i.e. both use v4l2_format information), but there is no need 
for a union as we had in the initial proposal since apps can set the sizeimage 
to something larger than strictly necessary (or just leave it to 0 to get the 
smallest size).

Regards,

	Hans

> +
>  /*
>   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
>   *
> @@ -2182,6 +2197,9 @@ struct v4l2_dbg_chip_ident {
>  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct 
v4l2_event_subscription)
>  #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct 
v4l2_event_subscription)
>  
> +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> +#define VIDIOC_PREPARE_BUF	 _IOW('V', 93, struct v4l2_buffer)
> +
>  /* Reminder: when adding new ioctls please add support for them to
>     drivers/media/video/v4l2-compat-ioctl32.c as well! */
>  
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index dd9f1e7..4d1c74a 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -122,6 +122,8 @@ struct v4l2_ioctl_ops {
>  	int (*vidioc_qbuf)    (struct file *file, void *fh, struct v4l2_buffer 
*b);
>  	int (*vidioc_dqbuf)   (struct file *file, void *fh, struct v4l2_buffer 
*b);
>  
> +	int (*vidioc_create_bufs)(struct file *file, void *fh, struct 
v4l2_create_buffers *b);
> +	int (*vidioc_prepare_buf)(struct file *file, void *fh, struct v4l2_buffer 
*b);
>  
>  	int (*vidioc_overlay) (struct file *file, void *fh, unsigned int i);
>  	int (*vidioc_g_fbuf)   (struct file *file, void *fh,
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
