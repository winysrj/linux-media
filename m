Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:65448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851Ab1ERPPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 11:15:47 -0400
Date: Wed, 18 May 2011 17:15:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size
 videobuffer management
In-Reply-To: <201105181559.09194.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1105181649590.16324@axis700.grange>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
 <Pine.LNX.4.64.1104011010530.9530@axis700.grange>
 <Pine.LNX.4.64.1105121835370.24486@axis700.grange>
 <201105181559.09194.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 18 May 2011, Laurent Pinchart wrote:

> On Friday 13 May 2011 09:45:51 Guennadi Liakhovetski wrote:

[snip]

> > 2. Both these flags should not be passed with CREATE, but with SUBMIT
> > (which will be renamed to PREPARE or something similar). It should be
> > possible to prepare the same buffer with different cacheing attributes
> > during a running operation. Shall these flags be added to values, taken by
> > struct v4l2_buffer::flags, since that is the struct, that will be used as
> > the argument for the new version of the SUBMIT ioctl()?
> 
> Do you have a use case for per-submit cache handling ?

This was Sakari's idea, I think, ask him;) But I think, he suggested a 
case, when not all buffers have to be processed in the user-space. In 
principle, I can imagine such a case too. E.g., if most of the buffers you 
pass directly to output / further processing, and only some of them you 
analyse in software, perhaps, for some WB, exposure, etc.

> > > +
> > > +/* VIDIOC_CREATE_BUFS */
> > > +struct v4l2_create_buffers {
> > > +	__u32			index;		/* output: buffers index...index + count - 1 have 
> been
> > > created */ +	__u32			count;
> > > +	__u32			flags;		/* V4L2_BUFFER_FLAG_* */
> > > +	enum v4l2_memory        memory;
> > > +	__u32			size;		/* Explicit size, e.g., for compressed streams */
> > > +	struct v4l2_format	format;		/* "type" is used always, the rest if 
> size
> > > == 0 */ +};
> > 
> > 1. Care must be taken to keep index <= V4L2_MAX_FRAME
> 
> Does that requirement still make sense ?

Don't know, again, not my idea. videobuf2-core still uses it. At one 
location it seems to be pretty arbitrary, at another it is the size of an 
array in struct vb2_fileio_data, but maybe we could allocate that one 
dynamically too. So, do I understand it right, that this would affect our 
case, if we would CREATE our buffers and then the user would decide to do 
read() / write() on them?

> > 2. A reserved field is needed.
> > 
> > > +
> > > 
> > >  /*
> > >  
> > >   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
> > >   *
> > > 
> > > @@ -1937,6 +1957,10 @@ struct v4l2_dbg_chip_ident {
> > > 
> > >  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct
> > >  v4l2_event_subscription) #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91,
> > >  struct v4l2_event_subscription)
> > > 
> > > +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> > > +#define VIDIOC_DESTROY_BUFS	_IOWR('V', 93, struct v4l2_buffer_span)
> > > +#define VIDIOC_SUBMIT_BUF	 _IOW('V', 94, int)
> > 
> > This has become the hottest point for discussion.
> > 
> > 1. VIDIOC_CREATE_BUFS: should the REQBUFS and CREATE/DESTROY APIs be
> > allowed to be mixed? REQBUFS is compulsory, CREATE/DESTROY will be
> > optional. But shall applications be allowed to mix them? No consensus has
> > been riched. This will also depend on whether DESTROY will be implemented
> > at all (see below).
> 
> Would mixing them help in any known use case ? The API and implementation 
> would be cleaner if we didn't allow mixing them.

It would help us avoid designing non-mature APIs and still have the 
functionality, we need;)

> > 2. VIDIOC_DESTROY_BUFS: has been discussed a lot
> > 
> > (a) shall it be allowed to create holes in indices? agreement was: not at
> > this stage, but in the future this might be needed.
> > 
> > (b) ioctl() argument: shall it take a span or an array of indices? I don't
> > think arrays make any sense here: on CREATE you always get contiguous
> > index sequences, and you are only allowed to DESTROY the same index sets.
> > 
> > (c) shall it be implemented at all, now that we don't know, how to handle
> > holes, or shall we just continue using REQBUFS(0) or close() to release
> > all buffers at once? Not implementing DESTROY now has the disadvantage,
> > that if you allocate 2 buffer sets of sizes A (small) and B (big), and
> > then don't need B any more, but instead need C != B (big), you cannot do
> > this. But this is just one of hypothetical use-cases. No consensus
> > reached.
> 
> We could go with (c) as a first step, but it might be temporary only. I feel a 
> bit uneasy implementing an API that we know will be temporary.

It shouldn't be temporary. CREATE and PREPARE should stay. It's just 
DESTROY that we're not certain about yet.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
