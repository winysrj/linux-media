Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43276 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1KHOBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 09:01:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] media: vb2: vmalloc-based allocator user pointer handling
Date: Tue, 8 Nov 2011 15:01:00 +0100
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-media@vger.kernel.org,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Pawel Osciak'" <pawel@osciak.com>
References: <1320231122-22518-1-git-send-email-andrzej.p@samsung.com> <201111081232.07239.laurent.pinchart@ideasonboard.com> <004d01cc9e1e$6101fef0$2305fcd0$%szyprowski@samsung.com>
In-Reply-To: <004d01cc9e1e$6101fef0$2305fcd0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111081501.00656.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

On Tuesday 08 November 2011 14:57:40 Marek Szyprowski wrote:
> On Tuesday, November 08, 2011 12:32 PM Laurent Pinchart wrote:
> > On Thursday 03 November 2011 08:40:26 Marek Szyprowski wrote:
> > > On Wednesday, November 02, 2011 2:54 PM Laurent Pinchart wrote:
> > > > On Wednesday 02 November 2011 11:52:02 Andrzej Pietrasiewicz wrote:
> > > > > vmalloc-based allocator user pointer handling
> > 
> > [snip]
> > 
> > > > This can cause an AB-BA deadlock, and will be reported by deadlock
> > > > detection if enabled.
> > > > 
> > > > The issue is that the mmap() handler is called by the MM core with
> > > > current->mm->mmap_sem held, and then takes the driver's lock before
> > > > calling videobuf2's mmap handler. The VIDIOC_QBUF handler, on the
> > > > other hand, will first take the driver's lock and will then try to
> > > > take current->mm->mmap_sem here.
> > > > 
> > > > This can result in a deadlock if both MMAP and USERPTR buffers are
> > > > used by the same driver at the same time.
> > > > 
> > > > If we assume that MMAP and USERPTR buffers can't be used on the same
> > > > queue at the same time (VIDIOC_CREATEBUFS doesn't allow that if I'm
> > > > not mistaken, so we should be safe, at least for now), this can be
> > > > fixed by having a per-queue lock in the driver instead of a global
> > > > device lock. However, that means that drivers that want to support
> > > > USERPTR will not be allowed to delegate lock handling to the V4L2
> > > > core and
> > > > video_ioctl2().
> > > 
> > > Thanks for pointing this issue! This problem is already present in the
> > > other videobuf2 memory allocators as well as the old videobuf and other
> > > v4l2 drivers which implement queue handling by themselves.
> > 
> > The problem is present in most (but not all) drivers, yes. That's one
> > more reason to fix it in videobuf2 :-)
> > 
> > > The only solution that will not complicate the videobuf2 and allocators
> > > code is to move taking current->mm->mmap_sem lock into videobuf2 core.
> > > Before acquiring this lock, vb2 calls wait_prepare to release device
> > > lock and then once mmap_sem is locked, calls wait_finish to get it
> > > again. This way the deadlock is avoided and allocators are free to
> > > call
> > > get_user_pages() without further messing with locks. The only drawback
> > > is the fact that a bit more code will be executed under mmap_sem lock.
> > > 
> > > What do you think about such solution?
> > 
> > Won't that create a race condition ? Wouldn't an application for instance
> > be able to call VIDIOC_REQBUFS(0) during the time window where the
> > device lock is released ?
> 
> Hmm... Right...
> 
> The only solution I see now is to move acquiring mmap_sem as early as
> possible to make the possible race harmless. The first operation in
> vb2_qbuf will be then:
> 
> if (b->memory == V4L2_MEMORY_USERPTR) {
>        call_qop(q, wait_prepare, q);
>        down_read(&current->mm->mmap_sem);
>        call_qop(q, wait_finish, q);
> }
> 
> This should solve the race although all userptr buffers will be handled
> under mmap_sem lock. Do you have any other idea?

If queues don't mix MMAP and USERPTR buffers (is that something we want to 
allow ?), wouldn't using a per-queue lock instead of a device-wide lock be a 
better way to fix the problem ?

> > > > > +	if (n_pages_from_user != buf->n_pages)
> > > > > +		goto userptr_fail_get_user_pages;
> > > > > +
> > > > > +	buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1,
> > > > > PAGE_KERNEL);
> > > > 
> > > > Will this create a second kernel mapping ?
> > > 
> > > Yes, it is very similar to vmalloc function which grabs a set of pages
> > > and creates contiguous virtual kernel mapping for them.
> > > 
> > > > What if the user tries to pass framebuffer memory that has been
> > > > mapped uncacheable to userspace ?
> > > 
> > > get_user_pages() fails if it is called for framebuffer memory
> > > (VM_PFNMAP type mappings).
> > 
> > Right. Do you think we should handle them, or should we wait for the
> > buffer sharing API ?
> 
> I'm not sure that waiting for buffer sharing API makes much sense here.
> First I would like to have vmalloc allocator finished for the typical
> desktop centric use cases (well, that's the most common use case for usb
> cams). Code for handling VM_PFNMAP buffers can be added later in the
> separate patches as it is useful mainly in the embedded world...

Capturing video directly to the frame buffer is a very common use case in the 
embedded world. I agree that we can implement that in a second step.

-- 
Regards,

Laurent Pinchart
