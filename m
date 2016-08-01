Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44396 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbcHAO1W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 10:27:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kazunori Kobayashi <kkobayas@igel.co.jp>,
	linux-media@vger.kernel.org,
	Damian Hobson-Garcia <dhobsong@igel.co.jp>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Memory freeing when dmabuf fds are exported with VIDIOC_EXPBUF
Date: Mon, 01 Aug 2016 16:49:50 +0300
Message-ID: <1677075.k8UG1Er7L0@avalon>
In-Reply-To: <826e1919-49c9-c65c-8911-17baf34c1421@xs4all.nl>
References: <36bf3ef2-e43a-3910-16e2-b51439be5622@igel.co.jp> <1654646.5z1yHJNanq@avalon> <826e1919-49c9-c65c-8911-17baf34c1421@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 01 Aug 2016 14:27:48 Hans Verkuil wrote:
> On 08/01/2016 02:17 PM, Laurent Pinchart wrote:
> > On Monday 01 Aug 2016 12:56:55 Hans Verkuil wrote:
> >> On 07/27/2016 02:57 PM, Laurent Pinchart wrote:
> >>> On Wednesday 27 Jul 2016 16:51:47 Kazunori Kobayashi wrote:
> >>>> Hi,
> >>>> 
> >>>> I have a question about memory freeing by calling REQBUF(0) before all
> >>>> the dmabuf fds exported with VIDIOC_EXPBUF are closed.
> >>>> 
> >>>> In calling REQBUF(0), videobuf2-core returns -EBUSY when the reference
> >>>> count of a vb2 buffer is more than 1. When dmabuf fds are not exported
> >>>> (usual V4L2_MEMORY_MMAP case), the check is no problem, but when dmabuf
> >>>> fds are exported and some of them are not closed (in other words the
> >>>> references to that memory are left), we cannot succeed in calling
> >>>> REQBUF(0) despite being able to free the memory after all the
> >>>> references are dropped.
> >>>> 
> >>>> Actually REQBUF(0) does not force a vb2 buffer to be freed but
> >>>> decreases the refcount of it. Also all the vb2 memory allocators that
> >>>> support dmabuf exporting (dma-contig, dma-sg, vmalloc) implements
> >>>> memory freeing by release() of dma_buf_ops, so I think there is no need
> >>>> to return -EBUSY when exporting dmabuf fds.
> >>>> 
> >>>> Could you please tell me what you think?
> >>> 
> >>> I think you're right. vb2 allocates the vb2_buffer and the
> >>> memops-specific structure separately. videobuf2-core.c will free the
> >>> vb2_buffer instance, but won't touch the memops-specific structure or
> >>> the buffer memory. Both of these are reference-counted in the memops
> >>> allocators. We could thus allow REQBUFS(0) to proceed even when buffers
> >>> have been exported (or at least after fixing the small issues we'll run
> >>> into, I have a feeling that this is too easy to be true).
> >>> 
> >>> Hans, Marek, any opinion on this ?
> >> 
> >> What is the use-case for this? What you are doing here is to either free
> >> all existing buffers or reallocate buffers. We can decide to rely on
> >> refcounting, but then you would create a second set of buffers (when
> >> re-allocating) or leave a lot of unfreed memory behind. That's pretty
> >> hard
> >> on the memory usage.
> > 
> > Speaking of which, we have no way today to really limit memory usage. I
> > wonder whether we should try to integrate support for resource limits in
> > V4L2.
>
> I'm opposed to that. We had drivers in the past that did that (perhaps there
> are still a few old ones left), but I removed those checks. In practice
> this all depends on the use-case. And if you try to allocate more buffers
> than there is memory, you just get ENOMEM. Which is what it is there for.
> 
> After all, how to decide what limit to use? If someone wants to use all 32
> buffers for some reason, or allocate larger buffers than strictly needed,
> then they should be able to do so. Perhaps you want to be able to capture a
> burst of high quality snapshots without having to process them immediately.
> Or other video streams are going to be composed into the buffers so you
> need to make them larger.
> 
> The only real limits are the amount of physical (DMAable) memory and the
> artificial 32 buffer limit which we already know is insufficient in
> certain use-cases.

When the user running V4L2 applications has full control over the system, 
perhaps, but how about shared systems where the system administrator wants to 
control resource usage per user ? Containers also come to mind, per-cgroup 
memory limits should be honoured.

And even for single-user systems, having the system start trashing because a 
random 3rd party video application decided to allocate a large number of 
buffers for no good reason provides a pretty bad user experience.

-- 
Regards,

Laurent Pinchart

