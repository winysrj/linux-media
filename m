Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53950 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158Ab1ERN7T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 09:59:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer management
Date: Wed, 18 May 2011 15:59:08 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <Pine.LNX.4.64.1104011010530.9530@axis700.grange> <Pine.LNX.4.64.1105121835370.24486@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105121835370.24486@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105181559.09194.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday 13 May 2011 09:45:51 Guennadi Liakhovetski wrote:
> I've found some more time to get back to this. Let me try to recap, what
> has been discussed. I've looked through all replies again (thanks to
> all!), so, I'll present a summary. Any mistakes and misinterpretations are
> mine;) If I misunderstand someone or forget anything - please, shout!
> 
> On Fri, 1 Apr 2011, Guennadi Liakhovetski wrote:
> > A possibility to preallocate and initialise buffers of different sizes
> > in V4L2 is required for an efficient implementation of asnapshot mode.
> > This patch adds three new ioctl()s: VIDIOC_CREATE_BUFS,
> > VIDIOC_DESTROY_BUFS, and VIDIOC_SUBMIT_BUF and defines respective data
> > structures.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> >  drivers/media/video/v4l2-compat-ioctl32.c |    3 ++
> >  drivers/media/video/v4l2-ioctl.c          |   43
> >  +++++++++++++++++++++++++++++ include/linux/videodev2.h                
> >  |   24 ++++++++++++++++ include/media/v4l2-ioctl.h                |   
> >  3 ++
> >  4 files changed, 73 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-compat-ioctl32.c
> > b/drivers/media/video/v4l2-compat-ioctl32.c index 7c26947..d71b289
> > 100644
> > --- a/drivers/media/video/v4l2-compat-ioctl32.c
> > +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> > @@ -922,6 +922,9 @@ long v4l2_compat_ioctl32(struct file *file, unsigned
> > int cmd, unsigned long arg)
> > 
> >  	case VIDIOC_DQEVENT:
> >  	case VIDIOC_SUBSCRIBE_EVENT:
> > 
> >  	case VIDIOC_UNSUBSCRIBE_EVENT:
> > +	case VIDIOC_CREATE_BUFS:
> > +	case VIDIOC_DESTROY_BUFS:
> > 
> > +	case VIDIOC_SUBMIT_BUF:
> >  		ret = do_video_ioctl(file, cmd, arg);
> >  		break;
> > 
> > diff --git a/drivers/media/video/v4l2-ioctl.c
> > b/drivers/media/video/v4l2-ioctl.c index a01ed39..b80a211 100644
> > --- a/drivers/media/video/v4l2-ioctl.c
> > +++ b/drivers/media/video/v4l2-ioctl.c
> > @@ -259,6 +259,9 @@ static const char *v4l2_ioctls[] = {
> > 
> >  	[_IOC_NR(VIDIOC_DQEVENT)]	   = "VIDIOC_DQEVENT",
> >  	[_IOC_NR(VIDIOC_SUBSCRIBE_EVENT)]  = "VIDIOC_SUBSCRIBE_EVENT",
> >  	[_IOC_NR(VIDIOC_UNSUBSCRIBE_EVENT)] = "VIDIOC_UNSUBSCRIBE_EVENT",
> > 
> > +	[_IOC_NR(VIDIOC_CREATE_BUFS)]      = "VIDIOC_CREATE_BUFS",
> > +	[_IOC_NR(VIDIOC_DESTROY_BUFS)]     = "VIDIOC_DESTROY_BUFS",
> > +	[_IOC_NR(VIDIOC_SUBMIT_BUF)]       = "VIDIOC_SUBMIT_BUF",
> > 
> >  };
> >  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
> > 
> > @@ -2184,6 +2187,46 @@ static long __video_do_ioctl(struct file *file,
> > 
> >  		dbgarg(cmd, "type=0x%8.8x", sub->type);
> >  		break;
> >  	
> >  	}
> > 
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
> > 
> >  	default:
> >  	{
> >  	
> >  		bool valid_prio = true;
> > 
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index aa6c393..b6ef46e 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -1847,6 +1847,26 @@ struct v4l2_dbg_chip_ident {
> > 
> >  	__u32 revision;    /* chip revision, chip specific */
> >  
> >  } __attribute__ ((packed));
> > 
> > +/* VIDIOC_DESTROY_BUFS */
> > +struct v4l2_buffer_span {
> > +	__u32			index;	/* output: buffers index...index + count - 1 have been
> > created */ +	__u32			count;
> > +	__u32			reserved[2];
> > +};
> > +
> > +/* struct v4l2_createbuffers::flags */
> > +#define V4L2_BUFFER_FLAG_NO_CACHE_INVALIDATE	(1 << 0)
> 
> 1. An additional flag FLAG_NO_CACHE_FLUSH is needed for output devices.

Shouldn't it be NO_CACHE_CLEAN ?

> 2. Both these flags should not be passed with CREATE, but with SUBMIT
> (which will be renamed to PREPARE or something similar). It should be
> possible to prepare the same buffer with different cacheing attributes
> during a running operation. Shall these flags be added to values, taken by
> struct v4l2_buffer::flags, since that is the struct, that will be used as
> the argument for the new version of the SUBMIT ioctl()?

Do you have a use case for per-submit cache handling ?

> > +
> > +/* VIDIOC_CREATE_BUFS */
> > +struct v4l2_create_buffers {
> > +	__u32			index;		/* output: buffers index...index + count - 1 have 
been
> > created */ +	__u32			count;
> > +	__u32			flags;		/* V4L2_BUFFER_FLAG_* */
> > +	enum v4l2_memory        memory;
> > +	__u32			size;		/* Explicit size, e.g., for compressed streams */
> > +	struct v4l2_format	format;		/* "type" is used always, the rest if 
size
> > == 0 */ +};
> 
> 1. Care must be taken to keep index <= V4L2_MAX_FRAME

Does that requirement still make sense ?

> 2. A reserved field is needed.
> 
> > +
> > 
> >  /*
> >  
> >   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
> >   *
> > 
> > @@ -1937,6 +1957,10 @@ struct v4l2_dbg_chip_ident {
> > 
> >  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct
> >  v4l2_event_subscription) #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91,
> >  struct v4l2_event_subscription)
> > 
> > +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> > +#define VIDIOC_DESTROY_BUFS	_IOWR('V', 93, struct v4l2_buffer_span)
> > +#define VIDIOC_SUBMIT_BUF	 _IOW('V', 94, int)
> 
> This has become the hottest point for discussion.
> 
> 1. VIDIOC_CREATE_BUFS: should the REQBUFS and CREATE/DESTROY APIs be
> allowed to be mixed? REQBUFS is compulsory, CREATE/DESTROY will be
> optional. But shall applications be allowed to mix them? No consensus has
> been riched. This will also depend on whether DESTROY will be implemented
> at all (see below).

Would mixing them help in any known use case ? The API and implementation 
would be cleaner if we didn't allow mixing them.

> 2. VIDIOC_DESTROY_BUFS: has been discussed a lot
> 
> (a) shall it be allowed to create holes in indices? agreement was: not at
> this stage, but in the future this might be needed.
> 
> (b) ioctl() argument: shall it take a span or an array of indices? I don't
> think arrays make any sense here: on CREATE you always get contiguous
> index sequences, and you are only allowed to DESTROY the same index sets.
> 
> (c) shall it be implemented at all, now that we don't know, how to handle
> holes, or shall we just continue using REQBUFS(0) or close() to release
> all buffers at once? Not implementing DESTROY now has the disadvantage,
> that if you allocate 2 buffer sets of sizes A (small) and B (big), and
> then don't need B any more, but instead need C != B (big), you cannot do
> this. But this is just one of hypothetical use-cases. No consensus
> reached.

We could go with (c) as a first step, but it might be temporary only. I feel a 
bit uneasy implementing an API that we know will be temporary.

> 3. VIDIOC_SUBMIT_BUF:
> 
> (a) shall be renamed to something with prepare or pre-queue in the name
> and call the .buf_prepare() videobuf2 method. This hasn't raised any
> objections, has been implemented in v2 (has not been posted yet). Name
> will be changed to VIDIOC_PREPARE_BUF
> 
> (b) Proposed to use struct v4l2_buffer as the argument. Applications
> anyway need those structs for other ioctl()s and the information is needed
> for .buf_prepare(). This is done in v2.
> 
> 4. It has been proposed to create wrappers to allow drivers to only
> implement CREATE/DESTROY and have those wrappers also provide REQBUFS,
> using them.
> 
> > +
> > 
> >  /* Reminder: when adding new ioctls please add support for them to
> >  
> >     drivers/media/video/v4l2-compat-ioctl32.c as well! */
> 
> 1. 'enum memory' and struct v4l2_format need special handling. Fixed in
> v2, untested.
> 
> > diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> > index dd9f1e7..00962c6 100644
> > --- a/include/media/v4l2-ioctl.h
> > +++ b/include/media/v4l2-ioctl.h
> > @@ -122,6 +122,9 @@ struct v4l2_ioctl_ops {
> > 
> >  	int (*vidioc_qbuf)    (struct file *file, void *fh, struct v4l2_buffer
> >  	*b); int (*vidioc_dqbuf)   (struct file *file, void *fh, struct
> >  	v4l2_buffer *b);
> > 
> > +	int (*vidioc_create_bufs) (struct file *file, void *fh, struct
> > v4l2_create_buffers *b); +	int (*vidioc_destroy_bufs)(struct file *file,
> > void *fh, struct v4l2_buffer_span *b); +	int (*vidioc_submit_buf) 
> > (struct file *file, void *fh, unsigned int i);
> > 
> >  	int (*vidioc_overlay) (struct file *file, void *fh, unsigned int i);
> >  	int (*vidioc_g_fbuf)   (struct file *file, void *fh,
> 
> Personally, I think, one of viable solutions for now would be to implement
> 
> > +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> > +#define VIDIOC_PREPARE_BUF	 _IOW('V', 93, struct v4l2_buffer)

-- 
Regards,

Laurent Pinchart
