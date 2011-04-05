Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57702 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1DEMz4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 08:55:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer management
Date: Tue, 5 Apr 2011 14:56:29 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <201104051359.18879.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1104051425030.14419@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1104051425030.14419@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104051456.29434.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Tuesday 05 April 2011 14:39:19 Guennadi Liakhovetski wrote:
> On Tue, 5 Apr 2011, Laurent Pinchart wrote:
> > On Friday 01 April 2011 10:13:02 Guennadi Liakhovetski wrote:
> > > A possibility to preallocate and initialise buffers of different sizes
> > > in V4L2 is required for an efficient implementation of asnapshot mode.
> > > This patch adds three new ioctl()s: VIDIOC_CREATE_BUFS,
> > > VIDIOC_DESTROY_BUFS, and VIDIOC_SUBMIT_BUF and defines respective data
> > > structures.

[snip]

> > > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > > index aa6c393..b6ef46e 100644
> > > --- a/include/linux/videodev2.h
> > > +++ b/include/linux/videodev2.h
> > > @@ -1847,6 +1847,26 @@ struct v4l2_dbg_chip_ident {

[snip]

> > > +/* struct v4l2_createbuffers::flags */
> > > +#define V4L2_BUFFER_FLAG_NO_CACHE_INVALIDATE	(1 << 0)
> > 
> > Shouldn't cache management be handled at submit/qbuf time instead of
> > being a buffer property ?
> 
> hmm, I'd prefer fixing it at create. Or do you want to be able to create
> buffers and then submit / queue them with different flags?...

That's the idea, yes. I'm not sure yet how useful that would be though.

[snip]

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
> > > 
> > > v4l2_event_subscription) #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91,
> > > struct v4l2_event_subscription)
> > > 
> > > +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> > > +#define VIDIOC_DESTROY_BUFS	_IOWR('V', 93, struct v4l2_buffer_span)
> > 
> > Just throwing an idea in here, what about using the same structure for
> > both ioctls ? Or even a single ioctl for both create and destroy, like
> > we do with REQBUFS ?
> 
> Personally, tbh, I don't like either of them. The first one seems an
> overkill - you don't need all those fields for destroy. The second one is
> a particular case of the first one, plus it adds confusion by re-using the
> ioctl:-) Where with REQBUFS we could just set count = 0 to say - release
> all buffers, with this one we need index and count, so, we'd need one more
> flag to distinguish between create / destroy...

OK, idea dismissed :-)

-- 
Regards,

Laurent Pinchart
