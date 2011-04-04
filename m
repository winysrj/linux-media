Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:52989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab1DDIYA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 04:24:00 -0400
Date: Mon, 4 Apr 2011 10:23:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size
 videobuffer management
In-Reply-To: <56f5dd2ffa0a55d09a5f391f0fa2e9d0.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.1104041013420.4668@axis700.grange>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>   
 <Pine.LNX.4.64.1104011010530.9530@axis700.grange>    <201104040905.57067.hverkuil@xs4all.nl>
    <Pine.LNX.4.64.1104040915590.4668@axis700.grange>
 <56f5dd2ffa0a55d09a5f391f0fa2e9d0.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 4 Apr 2011, Hans Verkuil wrote:

[snip]

> >> > +/* VIDIOC_CREATE_BUFS */
> >> > +struct v4l2_create_buffers {
> >> > +	__u32			index;		/* output: buffers index...index + count - 1 have
> >> been created */
> >> > +	__u32			count;
> >> > +	__u32			flags;		/* V4L2_BUFFER_FLAG_* */
> >> > +	enum v4l2_memory        memory;
> >> > +	__u32			size;		/* Explicit size, e.g., for compressed streams */
> >>
> >> Hmm, shouldn't this be an array of size VIDEO_MAX_PLANES?
> >
> > Not sure. As the comment says, this is mainly for bitstream formats. For
> > any pixel-based format you really should just fill in the format below. If
> > you allow the user to specify planes, then you also need to know
> > alignment, contiguity, padding, etc.
> >
> >> > +	struct v4l2_format	format;		/* "type" is used always, the rest if
> >> size == 0 */
> >>
> >> Needs some reserved fields as well.
> >
> > v4l2_format is a union with 200 bytes, is this not enough?
> 
> You can't add new fields to the v4l2_pix_format struct in this union,
> because that would mess up the G/S_FBUF ioctls. Really a V4L2 design flaw.
> 
> So it's better to add some extra reserveds at the top level.

Can do that, sure, but just for understanding: as long as we're sure the 
other union members don't exceed ("a bit fewer than") 200 bytes, why 
cannot we change 200 to 196 in the union and add a reserver u32 to all 
affected ioctl()s - if / when needed?

> >> > +};
> >> > +
> >> >  /*
> >> >   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
> >> >   *
> >> > @@ -1937,6 +1957,10 @@ struct v4l2_dbg_chip_ident {
> >> >  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct
> >> v4l2_event_subscription)
> >> >  #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct
> >> v4l2_event_subscription)
> >> >
> >> > +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> >> > +#define VIDIOC_DESTROY_BUFS	_IOWR('V', 93, struct v4l2_buffer_span)
> >> > +#define VIDIOC_SUBMIT_BUF	 _IOW('V', 94, int)
> >>
> >> I don't really like the name. I think I'd go for _PRE_QBUF or _PREP_BUF
> >> or
> >> something like that.
> >
> > I didn't want to use any form of prepare, because we already have a
> > .buf_prepare() method, and IMHO it would be confusing. Pre-queue I didn't
> > like very much either, for the same reasons, why we rejected it at the
> > meeting, which was, I think, that it's not really doing anything with the
> > queue, right? What this ioctl() does is it passes buffer ownership from
> > the user-space to the kernel, right? Any good name for that? In fact
> > "submit" doesn't sound too bad to me:-)
> 
> Well, naming isn't my strongest point. But isn't buf_prepare exactly the
> op that SUBMIT is supposed to call (besides pinning the buffers in
> memory)? That's the whole point of this ioctl. Anyway, I'd have to hear
> what others think.

I've been thinking about that too. Currently .buf_prepare() is called on 
each QBUF, so, it performs a different task - a dynamic preparation, 
necessary during a running capture / playback. Whereas the new ioctl() 
should only perform a one-off operation - passing the ownership on the 
buffer. Seems pretty different to me.

> >> BTW, I agree with other reviewers that DESTROY_BUFS shouldn't leave any
> >> holes.
> >
> > That was our decision at the meeting - I can well remember that, I was
> > surprised about that too, so, I think, I even asked to clarify this point.
> > But we can change it of course. Shall we return -EBUSY if the user is
> > trying to free buffers in the middle?
> 
> I'm having second thoughts about this. If you have lots of buffers of
> different sizes, then it might make sense to destroy buffers in the
> middle.
> 
> But we should perhaps just disallow it for now. We can always be more
> lenient later if necessary.

That would be the easiest for now. Do we all agree?

> >> > +
> >> >  /* Reminder: when adding new ioctls please add support for them to
> >> >     drivers/media/video/v4l2-compat-ioctl32.c as well! */
> >>
> >> Don't forget this! VIDIOC_CREATE_BUFS will need to be handled in
> >> compat-ioctl32.
> >
> > I didn't:
> >
> >> >  drivers/media/video/v4l2-compat-ioctl32.c |    3 ++
> >
> > Or is that not enough? Is any special handling required? AFAICS, REQBUFS
> > is not treated specially either.
> 
> No, you need special handling for the 'enum memory' and the struct
> v4l2_format. These have different sizes depending on the architecture.

Hm, I'll have a look at them then...

> BTW, REQBUFS and CREATE/DESTROY_BUFS should definitely co-exist. REQBUFS
> is compulsory, while CREATE/DESTROY are optional.

Sure, drivers _must_ implement REQBUFS and _may_ implement CREATE/DESTROY. 
The question is - should we allow mixing of them? E.g., an app first 
calling REQBUFS, then CREATE to add more buffers, and eventually 
REQBUFS(0) to destroy them all?...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
