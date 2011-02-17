Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:60697 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1BQQq3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 11:46:29 -0500
Date: Thu, 17 Feb 2011 17:46:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans Verkuil <hansverk@cisco.com>, Qing Xu <qingx@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Neil Johnson <realdealneil@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Uwe Taeubert <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Eino-Ville Talvala <talvala@stanford.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
In-Reply-To: <Pine.LNX.4.64.1102161033440.20711@axis700.grange>
Message-ID: <Pine.LNX.4.64.1102171530420.30692@axis700.grange>
References: <Pine.LNX.4.64.1102151641490.16709@axis700.grange>
 <201102160949.04605.hansverk@cisco.com> <Pine.LNX.4.64.1102160954560.20711@axis700.grange>
 <201102161011.59830.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1102161033440.20711@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all

Let me try to further elaborate on this topic. So far, I think, the 
following provides the cleanest solution to our quick format-switching / 
multiple video-queue problem:

On Wed, 16 Feb 2011, Guennadi Liakhovetski wrote:

> (2) cleanly separate setting video data format (S_FMT) from specifying the 
> allocated buffer size.

The control flow then would look like:

	struct v4l2_requestbuffers req;

	fd = open();

	/* initialise and configure the first "still-shot" buffer-queue */
	bufq.id = -EINVAL;
	ret = ioctl(fd, VIDIOC_BUFQ_SELECT, &bufq);

	/*
	 * bufq.id now contains a handle to a newly allocated videobuf 
	 * queue, it also becomes the current queue.
	 */

	still_qid = buf.id;

	/*
	 * specify explicitly required buffer size - use one of reserved 
	 * fields
	 */
	req.size = still_x * still_y * bpp;
	ret = ioctl(fd, VIDIOC_REQBUFS, &req);

	for (i = 0; i < req.count; i++) {
		buf.index = i;
		ret = ioctl(fd, VIDIOC_QUERYBUF, &buf);
		start = mmap();
		ret = ioctl(fd, VIDIOC_QBUF, &buf);
	}

	/* Allocate a second "preview" queue */

	bufq.id = -EINVAL;
	ret = ioctl(fd, VIDIOC_BUFQ_SELECT, &bufq);

	preview_qid = bufq.id;

	req.size = preview_x * preview_y * bpp;
	ret = ioctl(fd, VIDIOC_REQBUFS, &req);

	for (i = 0; i < req.count; i++) {
		buf.index = i;
		ret = ioctl(fd, VIDIOC_QUERYBUF, &buf);
		start = mmap();
		ret = ioctl(fd, VIDIOC_QBUF, &buf);
	}

	/* Stay on the preview queue */
	ret = ioctl(fd, VIDIOC_STREAMON, &type);

	for (i = 0; i < n; i++) {
		ret = ioctl(fd, VIDIOC_DQBUF, &buf);
		ret = ioctl(fd, VIDIOC_QBUF, &buf);
	}

	ret = ioctl(fd, VIDIOC_STREAMOFF, &type);

	/* Switch to the still-shot queue */
	bufq.id = still_qid;
	ret = ioctl(fd, VIDIOC_BUFQ_SELECT, &bufq);

	ret = ioctl(fd, VIDIOC_STREAMON, &type);

	for (i = 0; i < n; i++) {
		ret = ioctl(fd, VIDIOC_DQBUF, &buf);
		ret = ioctl(fd, VIDIOC_QBUF, &buf);
	}

	ret = ioctl(fd, VIDIOC_STREAMOFF, &type);

And so on. If the above is _conceptually_ acceptable, we need 1 to 2 new 
ioctl()s and an extension to the VIDIOC_REQBUFS ioctl() to specify the 
buffer size. I wrote "1 or 2 new ioctl()s," because above the new 
VIDIOC_BUFQ_SELECT ioctl() performs two functions: if the handle is 
negative, it allocates a new queue, if it containes a valid (per-device or 
per file-handle?) queue ID, it switches to it. We might also decide to use 
two ioctl()s for these two functions.

Comments?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
