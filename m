Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:49180 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab1DEMjb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 08:39:31 -0400
Date: Tue, 5 Apr 2011 14:39:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size
 videobuffer management
In-Reply-To: <201104051359.18879.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1104051425030.14419@axis700.grange>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
 <Pine.LNX.4.64.1104011010530.9530@axis700.grange>
 <201104051359.18879.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent

On Tue, 5 Apr 2011, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Friday 01 April 2011 10:13:02 Guennadi Liakhovetski wrote:
> > A possibility to preallocate and initialise buffers of different sizes
> > in V4L2 is required for an efficient implementation of asnapshot mode.
> > This patch adds three new ioctl()s: VIDIOC_CREATE_BUFS,
> > VIDIOC_DESTROY_BUFS, and VIDIOC_SUBMIT_BUF and defines respective data
> > structures.
> 
> [snip]
> 
> > diff --git a/drivers/media/video/v4l2-ioctl.c
> > b/drivers/media/video/v4l2-ioctl.c index a01ed39..b80a211 100644
> > --- a/drivers/media/video/v4l2-ioctl.c
> > +++ b/drivers/media/video/v4l2-ioctl.c
> 
> [snip]
> 
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
> 
> Why only when create->size is > 0 ?

Because otherwise create->format contains the frame format, that will be 
used for plane-size calculations.

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
> > +	__u32			index;	/* output: buffers index...index + count - 1 have been
> > created */ +	__u32			count;
> > +	__u32			reserved[2];
> > +};
> > +
> > +/* struct v4l2_createbuffers::flags */
> > +#define V4L2_BUFFER_FLAG_NO_CACHE_INVALIDATE	(1 << 0)
> 
> Shouldn't cache management be handled at submit/qbuf time instead of being a 
> buffer property ?

hmm, I'd prefer fixing it at create. Or do you want to be able to create 
buffers and then submit / queue them with different flags?...

> > +/* VIDIOC_CREATE_BUFS */
> > +struct v4l2_create_buffers {
> > +	__u32			index;		/* output: buffers index...index + count - 1 have been
> > created */ +	__u32			count;
> > +	__u32			flags;		/* V4L2_BUFFER_FLAG_* */
> > +	enum v4l2_memory        memory;
> > +	__u32			size;		/* Explicit size, e.g., for compressed streams */
> > +	struct v4l2_format	format;		/* "type" is used always, the rest if size 
> ==
> > 0 */ +};
> 
> You need reserved fields here.

Yes, already discussed with Hans, will add.

> 
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
> 
> Just throwing an idea in here, what about using the same structure for both 
> ioctls ? Or even a single ioctl for both create and destroy, like we do with 
> REQBUFS ?

Personally, tbh, I don't like either of them. The first one seems an 
overkill - you don't need all those fields for destroy. The second one is 
a particular case of the first one, plus it adds confusion by re-using the 
ioctl:-) Where with REQBUFS we could just set count = 0 to say - release 
all buffers, with this one we need index and count, so, we'd need one more 
flag to distinguish between create / destroy...

> > +#define VIDIOC_SUBMIT_BUF	 _IOW('V', 94, int)
> > +
> >  /* Reminder: when adding new ioctls please add support for them to
> >     drivers/media/video/v4l2-compat-ioctl32.c as well! */
> > 
> 
> [snip]
> 
> -- 
> Regards,
> 
> Laurent Pinchart

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
