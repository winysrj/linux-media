Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8377 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1KCHlH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 03:41:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LU2003IRQOGFH20@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Nov 2011 07:41:04 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LU20007WQOG0V@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Nov 2011 07:41:04 +0000 (GMT)
Date: Thu, 03 Nov 2011 08:40:26 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: vb2: vmalloc-based allocator user pointer handling
In-reply-to: <201111021453.46902.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>
Message-id: <020b01cc99fb$da90de70$8fb29b50$%szyprowski@samsung.com>
Content-language: pl
References: <1320231122-22518-1-git-send-email-andrzej.p@samsung.com>
 <201111021453.46902.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, November 02, 2011 2:54 PM Laurent Pinchart wrote:
> On Wednesday 02 November 2011 11:52:02 Andrzej Pietrasiewicz wrote:
> > vmalloc-based allocator user pointer handling
> >
> > Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/media/video/videobuf2-vmalloc.c |   86 +++++++++++++++++++++++++++-
> >  1 files changed, 85 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/media/video/videobuf2-vmalloc.c
> > b/drivers/media/video/videobuf2-vmalloc.c index a3a8842..ee0ee37 100644
> > --- a/drivers/media/video/videobuf2-vmalloc.c
> > +++ b/drivers/media/video/videobuf2-vmalloc.c
> > @@ -12,6 +12,7 @@
> >
> >  #include <linux/module.h>
> >  #include <linux/mm.h>
> > +#include <linux/sched.h>
> >  #include <linux/slab.h>
> >  #include <linux/vmalloc.h>
> >
> > @@ -20,7 +21,10 @@
> >
> >  struct vb2_vmalloc_buf {
> >  	void				*vaddr;
> > +	struct page			**pages;
> > +	int				write;
> >  	unsigned long			size;
> > +	unsigned int			n_pages;
> >  	atomic_t			refcount;
> >  	struct vb2_vmarea_handler	handler;
> >  };
> > @@ -66,6 +70,83 @@ static void vb2_vmalloc_put(void *buf_priv)
> >  	}
> >  }
> >
> > +static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
> > +				     unsigned long size, int write)
> > +{
> > +	struct vb2_vmalloc_buf *buf;
> > +
> > +	unsigned long first, last;
> > +	int n_pages_from_user, offset;
> 
> Doesn't the kernel coding style prefer one variable declaration per line ?
> 
> > +
> > +	buf = kzalloc(sizeof *buf, GFP_KERNEL);
> > +	if (!buf)
> > +		return NULL;
> > +
> > +	buf->vaddr = NULL;
> > +	buf->write = write;
> > +	offset = vaddr & ~PAGE_MASK;
> > +	buf->size = size;
> > +
> > +	first = (vaddr & PAGE_MASK) >> PAGE_SHIFT;
> > +	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
> > +	buf->n_pages = last - first + 1;
> > +	buf->pages = kzalloc(buf->n_pages * sizeof(struct page *), GFP_KERNEL);
> > +	if (!buf->pages)
> > +		goto userptr_fail_pages_array_alloc;
> > +
> > +	down_read(&current->mm->mmap_sem);
> > +	n_pages_from_user = get_user_pages(current, current->mm,
> > +					     vaddr & PAGE_MASK,
> > +					     buf->n_pages,
> > +					     write,
> > +					     1, /* force */
> > +					     buf->pages,
> > +					     NULL);
> > +	up_read(&current->mm->mmap_sem);
> 
> This can cause an AB-BA deadlock, and will be reported by deadlock detection
> if enabled.
> 
> The issue is that the mmap() handler is called by the MM core with current-
> >mm->mmap_sem held, and then takes the driver's lock before calling
> videobuf2's mmap handler. The VIDIOC_QBUF handler, on the other hand, will
> first take the driver's lock and will then try to take current->mm->mmap_sem
> here.
> 
> This can result in a deadlock if both MMAP and USERPTR buffers are used by the
> same driver at the same time.
> 
> If we assume that MMAP and USERPTR buffers can't be used on the same queue at
> the same time (VIDIOC_CREATEBUFS doesn't allow that if I'm not mistaken, so we
> should be safe, at least for now), this can be fixed by having a per-queue
> lock in the driver instead of a global device lock. However, that means that
> drivers that want to support USERPTR will not be allowed to delegate lock
> handling to the V4L2 core and video_ioctl2().

Thanks for pointing this issue! This problem is already present in the other 
videobuf2 memory allocators as well as the old videobuf and other v4l2 drivers
which implement queue handling by themselves.

The only solution that will not complicate the videobuf2 and allocators code
is to move taking current->mm->mmap_sem lock into videobuf2 core. Before acquiring
this lock, vb2 calls wait_prepare to release device lock and then once mmap_sem is
locked, calls wait_finish to get it again. This way the deadlock is avoided and 
allocators are free to call get_user_pages() without further messing with locks.
The only drawback is the fact that a bit more code will be executed under mmap_sem
lock.

What do you think about such solution?

> > +	if (n_pages_from_user != buf->n_pages)
> > +		goto userptr_fail_get_user_pages;
> > +
> > +	buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1, PAGE_KERNEL);
> 
> Will this create a second kernel mapping ?

Yes, it is very similar to vmalloc function which grabs a set of pages and 
creates contiguous virtual kernel mapping for them.

> What if the user tries to pass
> framebuffer memory that has been mapped uncacheable to userspace ?

get_user_pages() fails if it is called for framebuffer memory (VM_PFNMAP type
mappings).

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


