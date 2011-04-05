Return-path: <mchehab@pedra>
Received: from sj-iport-3.cisco.com ([171.71.176.72]:57571 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab1DEMfS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 08:35:18 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer management
Date: Tue, 5 Apr 2011 14:34:57 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <Pine.LNX.4.64.1104011010530.9530@axis700.grange> <201104051421.03597.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201104051421.03597.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104051434.57489.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, April 05, 2011 14:21:03 Laurent Pinchart wrote:
> On Friday 01 April 2011 10:13:02 Guennadi Liakhovetski wrote:
> > A possibility to preallocate and initialise buffers of different sizes
> > in V4L2 is required for an efficient implementation of asnapshot mode.
> > This patch adds three new ioctl()s: VIDIOC_CREATE_BUFS,
> > VIDIOC_DESTROY_BUFS, and VIDIOC_SUBMIT_BUF and defines respective data
> > structures.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  drivers/media/video/v4l2-compat-ioctl32.c |    3 ++
> >  drivers/media/video/v4l2-ioctl.c          |   43
> > +++++++++++++++++++++++++++++ include/linux/videodev2.h                 | 
> >  24 ++++++++++++++++ include/media/v4l2-ioctl.h                |    3 ++
> >  4 files changed, 73 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-compat-ioctl32.c
> > b/drivers/media/video/v4l2-compat-ioctl32.c index 7c26947..d71b289 100644
> > --- a/drivers/media/video/v4l2-compat-ioctl32.c
> > +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> > @@ -922,6 +922,9 @@ long v4l2_compat_ioctl32(struct file *file, unsigned
> > int cmd, unsigned long arg) case VIDIOC_DQEVENT:
> >  	case VIDIOC_SUBSCRIBE_EVENT:
> >  	case VIDIOC_UNSUBSCRIBE_EVENT:
> > +	case VIDIOC_CREATE_BUFS:
> > +	case VIDIOC_DESTROY_BUFS:
> > +	case VIDIOC_SUBMIT_BUF:
> >  		ret = do_video_ioctl(file, cmd, arg);
> >  		break;
> > 
> > diff --git a/drivers/media/video/v4l2-ioctl.c
> > b/drivers/media/video/v4l2-ioctl.c index a01ed39..b80a211 100644
> > --- a/drivers/media/video/v4l2-ioctl.c
> > +++ b/drivers/media/video/v4l2-ioctl.c
> > @@ -259,6 +259,9 @@ static const char *v4l2_ioctls[] = {
> >  	[_IOC_NR(VIDIOC_DQEVENT)]	   = "VIDIOC_DQEVENT",
> >  	[_IOC_NR(VIDIOC_SUBSCRIBE_EVENT)]  = "VIDIOC_SUBSCRIBE_EVENT",
> >  	[_IOC_NR(VIDIOC_UNSUBSCRIBE_EVENT)] = "VIDIOC_UNSUBSCRIBE_EVENT",
> > +	[_IOC_NR(VIDIOC_CREATE_BUFS)]      = "VIDIOC_CREATE_BUFS",
> > +	[_IOC_NR(VIDIOC_DESTROY_BUFS)]     = "VIDIOC_DESTROY_BUFS",
> > +	[_IOC_NR(VIDIOC_SUBMIT_BUF)]       = "VIDIOC_SUBMIT_BUF",
> >  };
> >  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
> > 
> > @@ -2184,6 +2187,46 @@ static long __video_do_ioctl(struct file *file,
> >  		dbgarg(cmd, "type=0x%8.8x", sub->type);
> >  		break;
> >  	}
> > +	case VIDIOC_CREATE_BUFS:
> > +	{
> > +		struct v4l2_create_buffers *create = arg;
> > +
> > +		if (!ops->vidioc_create_bufs)
> > +			break;
> > +		ret = check_fmt(ops, create->format.type);
> > +		if (ret)
> > +			break;
> > +
> > +		if (create->size)
> > +			CLEAR_AFTER_FIELD(create, count);
> > +
> > +		ret = ops->vidioc_create_bufs(file, fh, create);
> > +
> > +		dbgarg(cmd, "count=%d\n", create->count);
> > +		break;
> > +	}
> > +	case VIDIOC_DESTROY_BUFS:
> > +	{
> > +		struct v4l2_buffer_span *span = arg;
> > +
> > +		if (!ops->vidioc_destroy_bufs)
> > +			break;
> > +
> > +		ret = ops->vidioc_destroy_bufs(file, fh, span);
> > +
> > +		dbgarg(cmd, "count=%d", span->count);
> > +		break;
> > +	}
> > +	case VIDIOC_SUBMIT_BUF:
> > +	{
> > +		unsigned int *i = arg;
> > +
> > +		if (!ops->vidioc_submit_buf)
> > +			break;
> > +		ret = ops->vidioc_submit_buf(file, fh, *i);
> > +		dbgarg(cmd, "index=%d", *i);
> > +		break;
> > +	}
> >  	default:
> >  	{
> >  		bool valid_prio = true;
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index aa6c393..b6ef46e 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -1847,6 +1847,26 @@ struct v4l2_dbg_chip_ident {
> >  	__u32 revision;    /* chip revision, chip specific */
> >  } __attribute__ ((packed));
> > 
> > +/* VIDIOC_DESTROY_BUFS */
> > +struct v4l2_buffer_span {
> > +	__u32			index;	/* output: buffers index...index + count 
- 1 have been
> > created */ +	__u32			count;
> > +	__u32			reserved[2];
> > +};
> > +
> > +/* struct v4l2_createbuffers::flags */
> > +#define V4L2_BUFFER_FLAG_NO_CACHE_INVALIDATE	(1 << 0)
> > +
> > +/* VIDIOC_CREATE_BUFS */
> > +struct v4l2_create_buffers {
> > +	__u32			index;		/* output: buffers index...index + 
count - 1 have been
> > created */ +	__u32			count;
> > +	__u32			flags;		/* V4L2_BUFFER_FLAG_* */
> > +	enum v4l2_memory        memory;
> > +	__u32			size;		/* Explicit size, e.g., for 
compressed streams */
> > +	struct v4l2_format	format;		/* "type" is used always, the rest if 
size 
> ==
> > 0 */ +};
> > +
> >  /*
> >   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
> >   *
> > @@ -1937,6 +1957,10 @@ struct v4l2_dbg_chip_ident {
> >  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct
> > v4l2_event_subscription) #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91,
> > struct v4l2_event_subscription)
> > 
> > +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> > +#define VIDIOC_DESTROY_BUFS	_IOWR('V', 93, struct v4l2_buffer_span)
> > +#define VIDIOC_SUBMIT_BUF	 _IOW('V', 94, int)
> > +
> 
> In case we later need to pass other information (such as flags) to 
> VIDIOC_SUBMIT_BUF, you should use a structure instead of an int.

I would just pass struct v4l2_buffer to this ioctl, just like QBUF/DQBUF do.

Regards,

	Hans

> 
> >  /* Reminder: when adding new ioctls please add support for them to
> >     drivers/media/video/v4l2-compat-ioctl32.c as well! */
> > 
> > diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> > index dd9f1e7..00962c6 100644
> > --- a/include/media/v4l2-ioctl.h
> > +++ b/include/media/v4l2-ioctl.h
> > @@ -122,6 +122,9 @@ struct v4l2_ioctl_ops {
> >  	int (*vidioc_qbuf)    (struct file *file, void *fh, struct 
v4l2_buffer
> > *b); int (*vidioc_dqbuf)   (struct file *file, void *fh, struct
> > v4l2_buffer *b);
> > 
> > +	int (*vidioc_create_bufs) (struct file *file, void *fh, struct
> > v4l2_create_buffers *b); +	int (*vidioc_destroy_bufs)(struct file *file,
> > void *fh, struct v4l2_buffer_span *b); +	int (*vidioc_submit_buf)  
(struct
> > file *file, void *fh, unsigned int i);
> > 
> >  	int (*vidioc_overlay) (struct file *file, void *fh, unsigned int i);
> >  	int (*vidioc_g_fbuf)   (struct file *file, void *fh,
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
