Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34027 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752974Ab3H1QjY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 12:39:24 -0400
Date: Wed, 28 Aug 2013 19:39:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	k.debski@samsung.com
Subject: Re: [PATCH v4.1 3/3] v4l: Add V4L2_BUF_FLAG_TIMESTAMP_SOF and use it
Message-ID: <20130828163919.GG2835@valkosipuli.retiisi.org.uk>
References: <201308281419.52009.hverkuil@xs4all.nl>
 <2110334.R9xrNvrTcZ@avalon>
 <20130828160922.GF2835@valkosipuli.retiisi.org.uk>
 <3137420.D3pZN9rLod@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3137420.D3pZN9rLod@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Aug 28, 2013 at 06:14:44PM +0200, Laurent Pinchart wrote:
...
> > > > diff --git a/drivers/media/usb/uvc/uvc_queue.c
> > > > b/drivers/media/usb/uvc/uvc_queue.c index cd962be..0d80512 100644
> > > > --- a/drivers/media/usb/uvc/uvc_queue.c
> > > > +++ b/drivers/media/usb/uvc/uvc_queue.c
> > > > @@ -149,7 +149,8 @@ int uvc_queue_init(struct uvc_video_queue *queue,
> > > > enum
> > > > v4l2_buf_type type, queue->queue.buf_struct_size = sizeof(struct
> > > > uvc_buffer);
> > > > 
> > > >  	queue->queue.ops = &uvc_queue_qops;
> > > >  	queue->queue.mem_ops = &vb2_vmalloc_memops;
> > > > 
> > > > -	queue->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > > > +	queue->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
> > > > +		| V4L2_BUF_FLAG_TIMESTAMP_SOF;
> > > > 
> > > >  	ret = vb2_queue_init(&queue->queue);
> > > >  	if (ret)
> > > >  	
> > > >  		return ret;
> > > > 
> > > > diff --git a/include/media/videobuf2-core.h
> > > > b/include/media/videobuf2-core.h index 6781258..033efc7 100644
> > > > --- a/include/media/videobuf2-core.h
> > > > +++ b/include/media/videobuf2-core.h
> > > > @@ -307,6 +307,7 @@ struct v4l2_fh;
> > > > 
> > > >   * @buf_struct_size: size of the driver-specific buffer structure;
> > > >   *		"0" indicates the driver doesn't want to use a custom buffer
> > > >   *		structure type, so sizeof(struct vb2_buffer) will is used
> > > > 
> > > > + * @timestamp_type: Timestamp flags; V4L2_BUF_FLAGS_TIMESTAMP_*
> > > > 
> > > >   * @gfp_flags:	additional gfp flags used when allocating the buffers.
> > > >   *		Typically this is 0, but it may be e.g. GFP_DMA or __GFP_DMA32
> > > >   *		to force the buffer allocation to a specific memory zone.
> > > > 
> > > > diff --git a/include/uapi/linux/videodev2.h
> > > > b/include/uapi/linux/videodev2.h index 691077d..c57765e 100644
> > > > --- a/include/uapi/linux/videodev2.h
> > > > +++ b/include/uapi/linux/videodev2.h
> > > > @@ -695,6 +695,16 @@ struct v4l2_buffer {
> > > > 
> > > >  #define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x00000000
> > > >  #define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x00002000
> > > >  #define V4L2_BUF_FLAG_TIMESTAMP_COPY		0x00004000
> > > > 
> > > > +/*
> > > > + * Timestamp taken once the first pixel is received (or transmitted).
> > > > + * If the flag is not set the buffer timestamp is taken at the end of
> > > > + * the frame. This is not a timestamp type.
> > > 
> > > UVC devices timestamp frames when the frame is captured, not when the
> > > first
> > > pixel is transmitted.
> > 
> > I.e. we shouldn't set the SOF flag? "When the frame is captured" doesn't say
> > much, or almost anything in terms of *when*. The frames have exposure time
> > and rolling shutter makes a difference, too.
> 
> The UVC 1.1 specification defines the timestamp as
> 
> "The source clock time in native deviceclock units when the raw frame capture 
> begins."
> 
> What devices do in practice may differ :-)

I think that this should mean start-of-frame - exposure time. I'd really
wonder if any practical implementation does that however.

What's your suggestion; should we use the SOF flag for this or do you prefer
the end-of-frame timestamp instead? I think it'd be quite nice for drivers
to know which one is which without having to guess, and based on the above
start-of-frame comes as close to that definition as is meaningful.

> > > For the other two patches,
> > > 
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Thanks! :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
