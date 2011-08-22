Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37128 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab1HVPm3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Aug 2011 11:42:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/6 v4] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Mon, 22 Aug 2011 17:42:36 +0200
Cc: Hans Verkuil <hansverk@cisco.com>, Pawel Osciak <pawel@osciak.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange> <201108221316.27491.hansverk@cisco.com> <Pine.LNX.4.64.1108221448030.29246@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1108221448030.29246@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108221742.37278.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Monday 22 August 2011 15:54:03 Guennadi Liakhovetski wrote:
> We discussed a bit more with Hans on IRC, and below is my attempt of a
> summary. Hans, please, correct me, if I misunderstood anything. Pawel,
> Sakari, Laurent: please, reply, whether you're ok with this.

Sakari is on holidays this week.

> On Mon, 22 Aug 2011, Hans Verkuil wrote:
> > On Monday, August 22, 2011 12:40:25 Guennadi Liakhovetski wrote:
> [snip]
> 
> > > It would be good if you also could have a look at my reply to this
> > > Pawel's mail:
> > > 
> > > http://article.gmane.org/gmane.linux.drivers.video-input-
> > 
> > infrastructure/36905
> > 
> > > and, specifically, at the vb2_parse_planes() function in it. That's my
> > > understanding of what would be needed, if we preserve .queue_setup()
> > > and use your last suggestion to include struct v4l2_format in struct
> > > v4l2_create_buffers.
> > 
> > vb2_parse_planes can be useful as a utility function that 'normal'
> > drivers can call from the queue_setup. But vb2 should not parse the
> > format directly, it should just pass it on to the driver through the
> > queue_setup function.
> > 
> > You also mention: "All frame-format fields like fourcc code, width,
> > height, colorspace are only input from the user. If the user didn't fill
> > them in, they should not be used."
> > 
> > I disagree with that. The user should fill in a full format description,
> > just as with S/TRY_FMT. That's the information that the driver will use
> > to set up the buffers. It could have weird rules like: if the fourcc is
> > this, and the size is less than that, then we can allocate in this
> > memory bank.
> > 
> > It is also consistent with REQBUFS: there too the driver uses a full
> > format (i.e. the last set format).
> > 
> > I would modify queue_setup to something like this:
> > 
> > int (*queue_setup)(struct vb2_queue *q, struct v4l2_format *fmt,
> > 
> >                      unsigned int *num_buffers,
> >                      unsigned int *num_planes, unsigned int sizes[],
> >                      void *alloc_ctxs[]);
> > 
> > Whether fmt is left to NULL in the reqbufs case, or whether the driver
> > has to call g_fmt first before calling vb2 is something that could be
> > decided by what is easiest to implement.
> 
> 1. VIDIOC_CREATE_BUFS passes struct v4l2_create_buffers from the user to
>    the kernel, in which struct v4l2_format is embedded. The user _must_
>    fill in .type member of struct v4l2_format. For .type ==
>    V4L2_BUF_TYPE_VIDEO_CAPTURE or V4L2_BUF_TYPE_VIDEO_OUTPUT .fmt.pix is
>    used, for .type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE or
>    V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE .fmt.pix_mp is used. In both these
>    cases the user _must_ fill in .width, .height, .pixelformat, .field,
>    .colorspace by possibly calling VIDIOC_G_FMT or VIDIOC_TRY_FMT. The
>    user also _may_ optionally fill in any further buffer-size related
>    fields, if it believes to have any special requirements to them. On
>    a successful return from the ioctl() .count and .index fields are
>    filled in by the kernel, .format stays unchanged. The user has to call
>    VIDIOC_QUERYBUF to retrieve specific buffer information.
> 
> 2. Videobuf2 drivers, that implement .vidioc_create_bufs() operation, call
>    vb2_create_bufs() with a pointer to struct v4l2_create_buffers as a
>    second argument. vb2_create_bufs() in turn calls the .queue_setup()
>    driver callback, whose prototype is modified as follows:
> 
> int (*queue_setup)(struct vb2_queue *q, const struct v4l2_format *fmt,
> 			unsigned int *num_buffers,
> 			unsigned int *num_planes, unsigned int sizes[],
> 			void *alloc_ctxs[]);
> 
>    with &create->format as a second argument. As pointed out above, this
>    struct is not modified by V4L, instead, the usual arguments 3-6 are
>    filled in by the driver, which are then used by vb2_create_bufs() to
>    call __vb2_queue_alloc().
> 
> 3. vb2_reqbufs() shall call .queue_setup() with fmt == NULL, which will be
>    a signal to the driver to use the current format.
> 
> 4. We keep .queue_setup(), because its removal would inevitably push a
>    part of the common code from vb2_reqbufs() and vb2_create_bufs() down
>    into drivers, thus creating code redundancy and increasing its
>    complexity.

How much common code would be pushed down to drivers ? I don't think this is a 
real issue. I like Pawel's proposal of removing .queue_setup() better.

> You have 24 hours to object, before I proceed with the next version;-)

-- 
Regards,

Laurent Pinchart
