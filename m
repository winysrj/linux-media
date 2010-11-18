Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:30380 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759266Ab0KRQw6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 11:52:58 -0500
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LC300C55AW95220@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Nov 2010 01:52:57 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LC300EOZAW4RF@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Nov 2010 01:52:57 +0900 (KST)
Date: Thu, 18 Nov 2010 17:52:51 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 1/7] v4l: add videobuf2 Video for Linux 2 driver framework
In-reply-to: <1290083190.2070.24.camel@morgan.silverblock.net>
To: 'Andy Walls' <awalls@md.metrocast.net>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	kyungmin.park@samsung.com
Message-id: <009601cb8741$0cb05da0$261118e0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1289983174-2835-1-git-send-email-m.szyprowski@samsung.com>
 <1289983174-2835-2-git-send-email-m.szyprowski@samsung.com>
 <201011181017.39379.hverkuil@xs4all.nl>
 <1290083190.2070.24.camel@morgan.silverblock.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Thursday, November 18, 2010 1:27 PM Andy Walls wrote:

> Hi Hans and Marek,
> 
> Some meta-comments below... ;)
> 
> On Thu, 2010-11-18 at 10:17 +0100, Hans Verkuil wrote:
> > Hi Marek!
> >
> > Some comments below...
> >
> > On Wednesday, November 17, 2010 09:39:28 Marek Szyprowski wrote:

> ...

> > > +/**
> > > + * vb2_reqbufs() - Initiate streaming
> > > + * @q:		videobuf2 queue
> > > + * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
> > > + *
> > > + * Should be called from vidioc_reqbufs ioctl handler of a driver.
> > > + * This function:
> > > + * 1) verifies streaming parameters passed from the userspace,
> > > + * 2) sets up the queue,
> > > + * 3) negotiates number of buffers and planes per buffer with the driver
> > > + *    to be used during streaming,
> > > + * 4) allocates internal buffer structures (struct vb2_buffer), according to
> > > + *    the agreed parameters,
> > > + * 5) for MMAP memory type, allocates actual video memory, using the
> > > + *    memory handling/allocation routines provided during queue initialization
> > > + *
> > > + * If req->count is 0, all the memory will be freed instead.
> > > + * If the queue has been allocated previously (by a previous vb2_reqbufs) call
> > > + * and the queue is not busy, memory will be reallocated.
> > > + *
> > > + * The return values from this function are intended to be directly returned
> > > + * from vidioc_reqbufs handler in driver.
> > > + */
> > > +int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
> > > +{
> > > +	unsigned int num_buffers, num_planes;
> > > +	int ret = 0;
> > > +
> > > +	if (req->memory != V4L2_MEMORY_MMAP
> > > +			&& req->memory != V4L2_MEMORY_USERPTR) {
> > > +		dprintk(1, "reqbufs: unsupported memory type\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if (req->type != q->type) {
> > > +		dprintk(1, "reqbufs: queue type invalid\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if (q->streaming) {
> > > +		dprintk(1, "reqbufs: streaming active\n");
> > > +		return -EBUSY;
> > > +	}
> > > +
> > > +	if (req->count == 0) {
> > > +		/* Free/release memory for count = 0, but only if unused */
> > > +		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
> > > +			dprintk(1, "reqbufs: memory in use, cannot free\n");
> > > +			ret = -EBUSY;
> > > +			goto end;
> > > +		}
> > > +
> > > +		ret = __vb2_queue_free(q);
> >
> > OK, I have a problem here. How do I detect as an application whether a driver
> > supports MMAP and/or USERPTR?
> >
> > What I am using in qv4l2 (and it doesn't work properly with videobuf) is that
> > I call REQBUFS with count == 0 for MMAP and for USERPTR and I check whether it
> > returns 0 or -EINVAL.
> 
> 
> > It seems a reasonable test since it doesn't allocate anything. It would be nice
> > if vb2 can check for the memory field here based on what the driver supports.
> >
> > Ideally we should make this an official part of the spec (or have some other
> > mechanism to find out what it supported).
> 
> Well it seems to be documented, just not clearly:
> 
> First paragraph here:
> http://linuxtv.org/downloads/v4l-dvb-apis/mmap.html
> 
> First & second Paragraph here:
> http://linuxtv.org/downloads/v4l-dvb-apis/userp.html
> (which mentions not allocating things.)
> 
> And in the description here:
> http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-reqbufs.html
> 
> 
> I suppose  adding flags to VIDIOC_QUERYCAP results would remove all the
> hokey algorithmic probing of what the driver should already know.
>  http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-querycap.html
> 
> V4L2_CAP_STREAMING            0x04000000
> V4L2_CAP_STREAMING_MMAP       0x08000000
> V4L2_CAP_STREAMING_USER_PTR   0x10000000

Good idea! This way querying memory access types will be much less intrusive :)

> ...

> >
> > Great job! Thanks for all the hard work!
> 
> Ditto!

Thx :) 

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center

