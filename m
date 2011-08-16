Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55126 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab1HPNNU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 09:13:20 -0400
Date: Tue, 16 Aug 2011 15:13:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hansverk@cisco.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/6 v4] V4L: add two new ioctl()s for multi-size videobuffer
 management
In-Reply-To: <Pine.LNX.4.64.1108151530410.7851@axis700.grange>
Message-ID: <Pine.LNX.4.64.1108161458510.13913@axis700.grange>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
 <201108081116.41126.hansverk@cisco.com> <Pine.LNX.4.64.1108151324220.7851@axis700.grange>
 <201108151336.07258.hansverk@cisco.com> <Pine.LNX.4.64.1108151530410.7851@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 15 Aug 2011, Guennadi Liakhovetski wrote:

> On Mon, 15 Aug 2011, Hans Verkuil wrote:
> 
> > On Monday, August 15, 2011 13:28:23 Guennadi Liakhovetski wrote:
> > > Hi Hans
> > > 
> > > On Mon, 8 Aug 2011, Hans Verkuil wrote:

[snip]

> > > > but I've changed my mind: I think
> > > > this should use a struct v4l2_format after all.
> 
> While switching back, I have to change the struct vb2_ops::queue_setup() 
> operation to take a struct v4l2_create_buffers pointer. An earlier version 
> of this patch just added one more parameter to .queue_setup(), which is 
> easier - changes to videobuf2-core.c are smaller, but it is then 
> redundant. We could use the create pointer for both input and output. The 
> video plane configuration in frame format is the same as what is 
> calculated in .queue_setup(), IIUC. So, we could just let the driver fill 
> that one in. This would require then the videobuf2-core.c to parse struct 
> v4l2_format to decide which union member we need, depending on the buffer 
> type. Do we want this or shall drivers duplicate plane sizes in separate 
> .queue_setup() parameters?

Let me explain my question a bit. The current .queue_setup() method is

	int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
			   unsigned int *num_planes, unsigned int sizes[],
			   void *alloc_ctxs[]);

To support multiple-size buffers we also have to pass a pointer to struct 
v4l2_create_buffers to this function now. We can either do it like this:

	int (*queue_setup)(struct vb2_queue *q,
			   struct v4l2_create_buffers *create,
			   unsigned int *num_buffers,
			   unsigned int *num_planes, unsigned int sizes[],
			   void *alloc_ctxs[]);

and let all drivers fill in respective fields in *create, e.g., either do

	create->format.fmt.pix_mp.plane_fmt[i].sizeimage = ...;
	create->format.fmt.pix_mp.num_planes = ...;

and also duplicate it in method parameters

	*num_planes = create->format.fmt.pix_mp.num_planes;
	sizes[i] = create->format.fmt.pix_mp.plane_fmt[i].sizeimage;

or with

	create->format.fmt.pix.sizeimage = ...;

for single-plane. Alternatively we make the prototype

	int (*queue_setup)(struct vb2_queue *q,
			   struct v4l2_create_buffers *create,
			   unsigned int *num_buffers,
			   void *alloc_ctxs[]);

then drivers only fill in *create, and the videobuf2-core will have to 
check create->format.type to decide, which of create->format.fmt.* is 
relevant and extract plane sizes from there.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
