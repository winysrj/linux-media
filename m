Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4508 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1I0NlO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 09:41:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/9 v7] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Tue, 27 Sep 2011 15:40:52 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de> <201109271306.21095.hverkuil@xs4all.nl> <Pine.LNX.4.64.1109271417280.5816@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109271417280.5816@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271540.52649.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, September 27, 2011 14:19:54 Guennadi Liakhovetski wrote:
> On Tue, 27 Sep 2011, Hans Verkuil wrote:
> 
> > On Tuesday, September 27, 2011 13:00:24 Guennadi Liakhovetski wrote:
> > > Hi Hans
> > > 
> > > On Tue, 27 Sep 2011, Hans Verkuil wrote:
> > > 
> > > > On Thursday, September 08, 2011 09:45:15 Guennadi Liakhovetski wrote:
> > > > > A possibility to preallocate and initialise buffers of different sizes
> > > > > in V4L2 is required for an efficient implementation of a snapshot
> > > > > mode. This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> > > > > VIDIOC_PREPARE_BUF and defines respective data structures.
> > > > > 
> > > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > > ---
> > > > > 
> > > > > v7: added the "experimental" comment, as suggested by Sakari - thanks.
> > > > > 
> > > > >  drivers/media/video/v4l2-compat-ioctl32.c |   67 +++++++++++++++++++++++++---
> > > > >  drivers/media/video/v4l2-ioctl.c          |   29 ++++++++++++
> > > > >  include/linux/videodev2.h                 |   17 +++++++
> > > > >  include/media/v4l2-ioctl.h                |    2 +
> > > > >  4 files changed, 107 insertions(+), 8 deletions(-)
> > > 
> > > [snip]
> > > 
> > > > > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > > > > index a5359c6..6e87ea9 100644
> > > > > --- a/include/linux/videodev2.h
> > > > > +++ b/include/linux/videodev2.h
> > > > > @@ -653,6 +653,9 @@ struct v4l2_buffer {
> > > > >  #define V4L2_BUF_FLAG_ERROR	0x0040
> > > > >  #define V4L2_BUF_FLAG_TIMECODE	0x0100	/* timecode field is valid */
> > > > >  #define V4L2_BUF_FLAG_INPUT     0x0200  /* input field is valid */
> > > > > +/* Cache handling flags */
> > > > > +#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0400
> > > > > +#define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x0800
> > > > >  
> > > > >  /*
> > > > >   *	O V E R L A Y   P R E V I E W
> > > > > @@ -2098,6 +2101,15 @@ struct v4l2_dbg_chip_ident {
> > > > >  	__u32 revision;    /* chip revision, chip specific */
> > > > >  } __attribute__ ((packed));
> > > > >  
> > > > > +/* VIDIOC_CREATE_BUFS */
> > > > > +struct v4l2_create_buffers {
> > > > > +	__u32			index;		/* output: buffers index...index + count - 1 have been created */
> > > > > +	__u32			count;
> > > > > +	enum v4l2_memory        memory;
> > > > > +	struct v4l2_format	format;		/* "type" is used always, the rest if sizeimage == 0 */
> > > > > +	__u32			reserved[8];
> > > > > +};
> > > > > +
> > > > >  /*
> > > > >   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
> > > > >   *
> > > > > @@ -2188,6 +2200,11 @@ struct v4l2_dbg_chip_ident {
> > > > >  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
> > > > >  #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
> > > > >  
> > > > > +/* Experimental, the below two ioctls may change over the next couple of kernel
> > > > > +   versions */
> > > > > +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> > > > > +#define VIDIOC_PREPARE_BUF	 _IOW('V', 93, struct v4l2_buffer)
> > > > 
> > > > I think I would prefer _IOWR here. QBUF etc. also use IOWR and you never know
> > > > what you might return in the future. At the very least using IOWR allows us
> > > > to update the state field, which would be a perfectly reasonable thing to do.
> > > 
> > > Sorry, which state field do you mean? We have already marked these ioctl() 
> > > as experimental, isn't this enough?
> > 
> > The state field in the v4l2_buffer argument.
> 
> Is this a new field? I seem to remember some discussion to replace one of 
> existing unused fields in a user-exposed struct (ioctl() argument) with a 
> different one. Is this what you're referring to? Can you point me out to 
> the patch?

Sorry, my fault. I confused vb2_buffer 'state' with v4l2_buffer 'flags'.
What happens in the case of QBUF is that v4l2_buffer is returned and the flags
field is set to FLAG_QUEUED. Something similar can be done if you have a IOWR
PREPARE_BUF: let it set FLAG_QUEUED. That makes it consistent with the QBUF
behavior as well (I always like consistent APIs).

I'm not sure whether we want to add a FLAG_PREPARED as well. I don't think it
has much value, although it would be a trivial addition.

Regards,

	Hans

> 
> > The experimental tag allows for changes, that's true. So this is my proposed
> > change :-)
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
