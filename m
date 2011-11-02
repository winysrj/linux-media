Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:49978 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab1KBS7r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 14:59:47 -0400
Date: Wed, 2 Nov 2011 19:59:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH] media: vb2: vmalloc-based allocator user pointer handling
In-Reply-To: <201111021453.46902.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1111021949570.19054@axis700.grange>
References: <1320231122-22518-1-git-send-email-andrzej.p@samsung.com>
 <201111021453.46902.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2 Nov 2011, Laurent Pinchart wrote:

> Hi Andrzej,
> 
> Thanks for the patch.
> 
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

Wow?... That's something soooo new to me, that I'm (well, almost;-)) 
prepared to eat my hat, if this is stated in CodingStyle or if checkpatch 
complains about it...

> 
> > +
> > +	buf = kzalloc(sizeof *buf, GFP_KERNEL);
> > +	if (!buf)
> > +		return NULL;
> > +
> > +	buf->vaddr = NULL;

Technically, this is not needed, since kzalloc() already allocates zeroed 
memory, but it's up to the author to keep it, if he thinks, that this is 
important semantically.

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

I don't think this is checked in the version, waiting to be pulled in my 
tree. And I don't remember a patch for this, but we definitely want one, 
until we have a better solution for this.

> should be safe, at least for now), this can be fixed by having a per-queue 
> lock in the driver instead of a global device lock. However, that means that 
> drivers that want to support USERPTR will not be allowed to delegate lock 
> handling to the V4L2 core and video_ioctl2().
> 
> > +	if (n_pages_from_user != buf->n_pages)
> > +		goto userptr_fail_get_user_pages;
> > +
> > +	buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1, PAGE_KERNEL);
> 
> Will this create a second kernel mapping ? What if the user tries to pass 
> framebuffer memory that has been mapped uncacheable to userspace ?
> 
> > +
> > +	if (buf->vaddr) {
> > +		buf->vaddr += offset;
> > +		return buf;
> > +	}
> 
> if () statements with a return look like error handling, what about
> 
> 	if (buf->vaddr == NULL)
> 		goto userptr_fail_get_user_pages;
> 
> 	buf->vaddr += offset;
> 	return buf;
> 
> > +
> > +userptr_fail_get_user_pages:
> > +	printk(KERN_DEBUG "get_user_pages requested/got: %d/%d]\n",
> > +	       n_pages_from_user, buf->n_pages);
> 
> Do we really need that debug printk ?

...and if we _do_ need it, then, I think, pr_debug() is preferred these 
days.

> 
> > +	while (--n_pages_from_user >= 0)
> > +		put_page(buf->pages[n_pages_from_user]);
> > +	kfree(buf->pages);
> > +
> > +userptr_fail_pages_array_alloc:
> > +	kfree(buf);
> > +
> > +	return NULL;
> > +}
> > +
> > +static void vb2_vmalloc_put_userptr(void *buf_priv)
> > +{
> > +	struct vb2_vmalloc_buf *buf = buf_priv;
> > +
> > +	int i = buf->n_pages;
> > +	int offset = (unsigned long)buf->vaddr & ~PAGE_MASK;
> > +
> > +	printk(KERN_DEBUG "%s: Releasing userspace buffer of %d pages\n",
> > +	       __func__, buf->n_pages);
> > +	if (buf->vaddr)
> > +		vm_unmap_ram((const void *)((unsigned long)buf->vaddr - offset),
> > +			     buf->n_pages);
> > +	while (--i >= 0) {
> 
> Anything wrong with
> 
> for (i = 0; i < buf->n_pages; ++i)
> 
> ? :-)
> 
> You could then make i an unsigned int, which would match buf->n_pages.
> 
> > +		if (buf->write)
> > +			set_page_dirty_lock(buf->pages[i]);
> > +		put_page(buf->pages[i]);
> > +	}
> > +	kfree(buf->pages);
> > +	kfree(buf);
> > +}
> > +
> >  static void *vb2_vmalloc_vaddr(void *buf_priv)
> >  {
> >  	struct vb2_vmalloc_buf *buf = buf_priv;
> 
> -- 
> Regards,
> 
> Laurent Pinchart

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
