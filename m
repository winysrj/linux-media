Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55039 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab1G1M3n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 08:29:43 -0400
Date: Thu, 28 Jul 2011 14:29:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Pawel Osciak <pawel@osciak.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size videobuffer
 management
In-Reply-To: <201107280856.55731.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1107281422350.20737@axis700.grange>
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange>
 <CAMm-=zB3dOJyCy7ZhqiTQkeL2b=Dvtz8geMR8zbHYBCVR6=pEw@mail.gmail.com>
 <201107280856.55731.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 28 Jul 2011, Hans Verkuil wrote:

> On Thursday, July 28, 2011 06:11:38 Pawel Osciak wrote:
> > Hi Guennadi,
> > 
> > On Wed, Jul 20, 2011 at 01:43, Guennadi Liakhovetski
> > <g.liakhovetski@gmx.de> wrote:
> > > A possibility to preallocate and initialise buffers of different sizes
> > > in V4L2 is required for an efficient implementation of asnapshot mode.
> > > This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> > > VIDIOC_PREPARE_BUF and defines respective data structures.
> > >
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > >
> > <snip>
> > 
> > This looks nicer, I like how we got rid of destroy and gave up on
> > making holes, it would've given us a lot of headaches. I'm thinking
> > about some issues though and also have some comments/questions further
> > below.
> > 
> > Already mentioned by others mixing of REQBUFS and CREATE_BUFS.
> > Personally I'd like to allow mixing, including REQBUFS for non-zero,
> > because I think it would be easy to do. I think it could work in the
> > same way as REQBUFS for !=0 works currently (at least in vb2), if we
> > already have some buffers allocated and they are not in use, we free
> > them and a new set is allocated. So I guess it could just stay this
> > way. REQBUFS(0) would of course free everything.
> > 
> > Passing format to CREATE_BUFS will make vb2 a bit format-aware, as it
> > would have to pass it forward to the driver somehow. The obvious way
> > would be just vb2 calling the driver's s_fmt handler, but that won't
> > work, as you can't pass indexes to s_fmt. So we'd have to implement a
> > new driver callback for setting formats per index. I guess there is no
> > way around it, unless we actually take the format struct out of
> > CREATE_BUFS and somehow do it via S_FMT. The single-planar structure
> > is full already though, the only way would be to use
> > v4l2_pix_format_mplane instead with plane count = 1 (or more if
> > needed).
> 
> I just got an idea for this: use TRY_FMT. That will do exactly what
> you want. In fact, perhaps we should remove the format struct from
> CREATE_BUFS and use __u32 sizes[VIDEO_MAX_PLANES] instead. Let the
> application call TRY_FMT and initialize the sizes array instead of
> putting that into vb2. We may need a num_planes field as well. If the
> sizes are all 0 (or num_planes is 0), then the driver can use the current
> format, just as it does with REQBUFS.

Hm, I think, I like this idea. It gives applications more flexibility and 
removes the size == 0 vs. size != 0 dilemma. So, we get

/* VIDIOC_CREATE_BUFS */
struct v4l2_create_buffers {
	__u32			index;		/* output: buffers index...index + count - 1 have been created */
	__u32			count;
	__u32			num_planes;
	__u32			sizes[VIDEO_MAX_PLANES];
	enum v4l2_memory        memory;
	enum v4l2_buf_type	type;
	__u32			reserved[8];
};

?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
