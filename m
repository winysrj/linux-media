Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:46191 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab2EXMOg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 08:14:36 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4J006WN0MU9O50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 13:13:42 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4J00F6V0O808@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 13:14:33 +0100 (BST)
Date: Thu, 24 May 2012 14:14:29 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [Q] vb2 userptr: struct vb2_ops::buf_cleanup() is called without
 buf_init()
In-reply-to: <1400345.yHxUgq6vV0@avalon>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>
Cc: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Pawel Osciak' <pawel@osciak.com>
Message-id: <01db01cd39a6$c4b84f20$4e28ed60$%szyprowski@samsung.com>
Content-language: pl
References: <Pine.LNX.4.64.1205210902060.30522@axis700.grange>
 <1400345.yHxUgq6vV0@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for CC.

On Tuesday, May 22, 2012 6:22 PM Laurent Pinchart wrote:

> Hi Guennadi,
> 
> (CC'ing Pawel and Marek)
> 
> On Monday 21 May 2012 10:30:19 Guennadi Liakhovetski wrote:
> > Hi
> >
> > A recent report
> >
> > http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/47594
> >
> > has revealed the following asymmetry in how videobuf2 functions:
> >
> > as is also documented in videobuf2-core.h, the user's struct
> > vb2_ops::buf_init() method in the MMAP case is called after allocating the
> > respective buffer, which happens at REQBUFS time, in the USERPTR case it
> > is called after acquiring a new buffer at QBUF time. If the allocation in
> > MMAP case fails, the respective buffer simply doesn't get created.
> > However, if acquiring a new USERPTR buffer at QBUF time fails, the buffer
> > object remains on the queue, but the user-provided .buf_init() method is
> > not called for it. When the queue is destroyed, the user's .buf_cleanup()
> > method is called on an uninitialised buffer. This is exactly the reason
> > for the BUG() in the above referenced report.
> >
> > Therefore my question: is this videobuf2-core behaviour really correct and
> > we should be prepared in .buf_cleanup() to process uninitialised buffers,
> > or should the videobuf2-core be adjusted?
> 
> From a driver's point of view, it would make sense not to call .buf_cleanup()
> if .buf_init() hasn't been called. Otherwise each driver would need to check
> whether the buffer has been initialized, which would lead to code duplication.
> 
> A new buffer state would help tracking this in the vb2 core. I haven't tried
> to implement it though, so I might be underestimating the effort.

That's definitely a bug in videobuf2. The initial idea was to call buf_cleanup 
only if buf_init has been called earlier for the given buffer. Like Laurent 
pointed out a new buffer state might help in resolving all possible cases, 
especially if you consider that vb2_queue_release might be called almost at any
point in the buffer state machine.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


