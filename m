Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33802 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1BRJr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 04:47:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
Date: Fri, 18 Feb 2011 10:47:25 +0100
Cc: Hans Verkuil <hansverk@cisco.com>, Qing Xu <qingx@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Neil Johnson <realdealneil@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Uwe Taeubert <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Eino-Ville Talvala" <talvala@stanford.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1102151641490.16709@axis700.grange> <Pine.LNX.4.64.1102161033440.20711@axis700.grange> <Pine.LNX.4.64.1102171530420.30692@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102171530420.30692@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102181047.25573.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Thursday 17 February 2011 17:46:15 Guennadi Liakhovetski wrote:
> Hi all
> 
> Let me try to further elaborate on this topic. So far, I think, the
> following provides the cleanest solution to our quick format-switching /
> multiple video-queue problem:
> 
> On Wed, 16 Feb 2011, Guennadi Liakhovetski wrote:
> > (2) cleanly separate setting video data format (S_FMT) from specifying
> > the allocated buffer size.
> 
> The control flow then would look like:
> 
> 	struct v4l2_requestbuffers req;
> 
> 	fd = open();
> 
> 	/* initialise and configure the first "still-shot" buffer-queue */
> 	bufq.id = -EINVAL;
> 	ret = ioctl(fd, VIDIOC_BUFQ_SELECT, &bufq);

If we're going to introduce new ioctls, I think we should do it right from the 
start. Your proposal looks like an interim solution that would be deprecated 
when buffer pools will be implemented. I think we should work directly on 
buffer pools instead.

> 	/*
> 	 * bufq.id now contains a handle to a newly allocated videobuf
> 	 * queue, it also becomes the current queue.
> 	 */
> 
> 	still_qid = buf.id;
> 
> 	/*
> 	 * specify explicitly required buffer size - use one of reserved
> 	 * fields
> 	 */
> 	req.size = still_x * still_y * bpp;
> 	ret = ioctl(fd, VIDIOC_REQBUFS, &req);
> 
> 	for (i = 0; i < req.count; i++) {
> 		buf.index = i;
> 		ret = ioctl(fd, VIDIOC_QUERYBUF, &buf);
> 		start = mmap();
> 		ret = ioctl(fd, VIDIOC_QBUF, &buf);
> 	}
> 
> 	/* Allocate a second "preview" queue */
> 
> 	bufq.id = -EINVAL;
> 	ret = ioctl(fd, VIDIOC_BUFQ_SELECT, &bufq);
> 
> 	preview_qid = bufq.id;
> 
> 	req.size = preview_x * preview_y * bpp;
> 	ret = ioctl(fd, VIDIOC_REQBUFS, &req);
> 
> 	for (i = 0; i < req.count; i++) {
> 		buf.index = i;
> 		ret = ioctl(fd, VIDIOC_QUERYBUF, &buf);
> 		start = mmap();
> 		ret = ioctl(fd, VIDIOC_QBUF, &buf);
> 	}
> 
> 	/* Stay on the preview queue */
> 	ret = ioctl(fd, VIDIOC_STREAMON, &type);
> 
> 	for (i = 0; i < n; i++) {
> 		ret = ioctl(fd, VIDIOC_DQBUF, &buf);
> 		ret = ioctl(fd, VIDIOC_QBUF, &buf);
> 	}
> 
> 	ret = ioctl(fd, VIDIOC_STREAMOFF, &type);
> 
> 	/* Switch to the still-shot queue */
> 	bufq.id = still_qid;
> 	ret = ioctl(fd, VIDIOC_BUFQ_SELECT, &bufq);
> 
> 	ret = ioctl(fd, VIDIOC_STREAMON, &type);
> 
> 	for (i = 0; i < n; i++) {
> 		ret = ioctl(fd, VIDIOC_DQBUF, &buf);
> 		ret = ioctl(fd, VIDIOC_QBUF, &buf);
> 	}
> 
> 	ret = ioctl(fd, VIDIOC_STREAMOFF, &type);
> 
> And so on. If the above is _conceptually_ acceptable, we need 1 to 2 new
> ioctl()s and an extension to the VIDIOC_REQBUFS ioctl() to specify the
> buffer size. I wrote "1 or 2 new ioctl()s," because above the new
> VIDIOC_BUFQ_SELECT ioctl() performs two functions: if the handle is
> negative, it allocates a new queue, if it containes a valid (per-device or
> per file-handle?) queue ID, it switches to it. We might also decide to use
> two ioctl()s for these two functions.

-- 
Regards,

Laurent Pinchart
