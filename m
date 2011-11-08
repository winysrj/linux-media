Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41708 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab1KHN5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 08:57:42 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LUC00HI6HG4YL70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Nov 2011 13:57:40 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LUC002Q4HG4PX@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Nov 2011 13:57:40 +0000 (GMT)
Date: Tue, 08 Nov 2011 14:57:40 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: vb2: vmalloc-based allocator user pointer handling
In-reply-to: <201111081232.07239.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>
Message-id: <004d01cc9e1e$6101fef0$2305fcd0$%szyprowski@samsung.com>
Content-language: pl
References: <1320231122-22518-1-git-send-email-andrzej.p@samsung.com>
 <201111021453.46902.laurent.pinchart@ideasonboard.com>
 <020b01cc99fb$da90de70$8fb29b50$%szyprowski@samsung.com>
 <201111081232.07239.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, November 08, 2011 12:32 PM Laurent Pinchart wrote:
> On Thursday 03 November 2011 08:40:26 Marek Szyprowski wrote:
> > On Wednesday, November 02, 2011 2:54 PM Laurent Pinchart wrote:
> > > On Wednesday 02 November 2011 11:52:02 Andrzej Pietrasiewicz wrote:
> > > > vmalloc-based allocator user pointer handling
> 
> [snip]
> 
> > > This can cause an AB-BA deadlock, and will be reported by deadlock
> > > detection if enabled.
> > >
> > > The issue is that the mmap() handler is called by the MM core with
> > > current->mm->mmap_sem held, and then takes the driver's lock before
> > > calling videobuf2's mmap handler. The VIDIOC_QBUF handler, on the other
> > > hand, will first take the driver's lock and will then try to take
> > > current->mm->mmap_sem here.
> > >
> > > This can result in a deadlock if both MMAP and USERPTR buffers are used
> > > by the same driver at the same time.
> > >
> > > If we assume that MMAP and USERPTR buffers can't be used on the same
> > > queue at the same time (VIDIOC_CREATEBUFS doesn't allow that if I'm not
> > > mistaken, so we should be safe, at least for now), this can be fixed by
> > > having a per-queue lock in the driver instead of a global device lock.
> > > However, that means that drivers that want to support USERPTR will not
> > > be allowed to delegate lock handling to the V4L2 core and
> > > video_ioctl2().
> >
> > Thanks for pointing this issue! This problem is already present in the
> > other videobuf2 memory allocators as well as the old videobuf and other
> > v4l2 drivers which implement queue handling by themselves.
> 
> The problem is present in most (but not all) drivers, yes. That's one more
> reason to fix it in videobuf2 :-)
>
> > The only solution that will not complicate the videobuf2 and allocators
> > code is to move taking current->mm->mmap_sem lock into videobuf2 core.
> > Before acquiring this lock, vb2 calls wait_prepare to release device lock
> > and then once mmap_sem is locked, calls wait_finish to get it again. This
> > way the deadlock is avoided and allocators are free to call
> > get_user_pages() without further messing with locks. The only drawback is
> > the fact that a bit more code will be executed under mmap_sem lock.
> >
> > What do you think about such solution?
> 
> Won't that create a race condition ? Wouldn't an application for instance be
> able to call VIDIOC_REQBUFS(0) during the time window where the device lock is
> released ?

Hmm... Right... 

The only solution I see now is to move acquiring mmap_sem as early as possible
to make the possible race harmless. The first operation in vb2_qbuf will be then:

if (b->memory == V4L2_MEMORY_USERPTR) {
       call_qop(q, wait_prepare, q);
       down_read(&current->mm->mmap_sem);
       call_qop(q, wait_finish, q);
}

This should solve the race although all userptr buffers will be handled under
mmap_sem lock. Do you have any other idea?
 
> > > > +	if (n_pages_from_user != buf->n_pages)
> > > > +		goto userptr_fail_get_user_pages;
> > > > +
> > > > +	buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1, PAGE_KERNEL);
> > >
> > > Will this create a second kernel mapping ?
> >
> > Yes, it is very similar to vmalloc function which grabs a set of pages and
> > creates contiguous virtual kernel mapping for them.
> >
> > > What if the user tries to pass framebuffer memory that has been mapped
> > > uncacheable to userspace ?
> >
> > get_user_pages() fails if it is called for framebuffer memory (VM_PFNMAP
> > type mappings).
> 
> Right. Do you think we should handle them, or should we wait for the buffer
> sharing API ?

I'm not sure that waiting for buffer sharing API makes much sense here. 
First I would like to have vmalloc allocator finished for the typical desktop
centric use cases (well, that's the most common use case for usb cams). Code
for handling VM_PFNMAP buffers can be added later in the separate patches as
it is useful mainly in the embedded world... 

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


