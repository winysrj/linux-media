Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54025 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1KHLcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 06:32:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] media: vb2: vmalloc-based allocator user pointer handling
Date: Tue, 8 Nov 2011 12:32:06 +0100
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-media@vger.kernel.org,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Pawel Osciak'" <pawel@osciak.com>
References: <1320231122-22518-1-git-send-email-andrzej.p@samsung.com> <201111021453.46902.laurent.pinchart@ideasonboard.com> <020b01cc99fb$da90de70$8fb29b50$%szyprowski@samsung.com>
In-Reply-To: <020b01cc99fb$da90de70$8fb29b50$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111081232.07239.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

On Thursday 03 November 2011 08:40:26 Marek Szyprowski wrote:
> On Wednesday, November 02, 2011 2:54 PM Laurent Pinchart wrote:
> > On Wednesday 02 November 2011 11:52:02 Andrzej Pietrasiewicz wrote:
> > > vmalloc-based allocator user pointer handling

[snip]

> > > @@ -66,6 +70,83 @@ static void vb2_vmalloc_put(void *buf_priv)
> > > 
> > >  	}
> > >  
> > >  }
> > > 
> > > +static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long
> > > vaddr, +				     unsigned long size, int write)
> > > +{
> > > +	struct vb2_vmalloc_buf *buf;
> > > +
> > > +	unsigned long first, last;
> > > +	int n_pages_from_user, offset;
> > 
> > Doesn't the kernel coding style prefer one variable declaration per line
> > ?
> > 
> > > +
> > > +	buf = kzalloc(sizeof *buf, GFP_KERNEL);
> > > +	if (!buf)
> > > +		return NULL;
> > > +
> > > +	buf->vaddr = NULL;
> > > +	buf->write = write;
> > > +	offset = vaddr & ~PAGE_MASK;
> > > +	buf->size = size;
> > > +
> > > +	first = (vaddr & PAGE_MASK) >> PAGE_SHIFT;
> > > +	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
> > > +	buf->n_pages = last - first + 1;
> > > +	buf->pages = kzalloc(buf->n_pages * sizeof(struct page *),
> > > GFP_KERNEL); +	if (!buf->pages)
> > > +		goto userptr_fail_pages_array_alloc;
> > > +
> > > +	down_read(&current->mm->mmap_sem);
> > > +	n_pages_from_user = get_user_pages(current, current->mm,
> > > +					     vaddr & PAGE_MASK,
> > > +					     buf->n_pages,
> > > +					     write,
> > > +					     1, /* force */
> > > +					     buf->pages,
> > > +					     NULL);
> > > +	up_read(&current->mm->mmap_sem);
> > 
> > This can cause an AB-BA deadlock, and will be reported by deadlock
> > detection if enabled.
> > 
> > The issue is that the mmap() handler is called by the MM core with
> > current->mm->mmap_sem held, and then takes the driver's lock before
> > calling videobuf2's mmap handler. The VIDIOC_QBUF handler, on the other
> > hand, will first take the driver's lock and will then try to take
> > current->mm->mmap_sem here.
> > 
> > This can result in a deadlock if both MMAP and USERPTR buffers are used
> > by the same driver at the same time.
> > 
> > If we assume that MMAP and USERPTR buffers can't be used on the same
> > queue at the same time (VIDIOC_CREATEBUFS doesn't allow that if I'm not
> > mistaken, so we should be safe, at least for now), this can be fixed by
> > having a per-queue lock in the driver instead of a global device lock.
> > However, that means that drivers that want to support USERPTR will not
> > be allowed to delegate lock handling to the V4L2 core and
> > video_ioctl2().
> 
> Thanks for pointing this issue! This problem is already present in the
> other videobuf2 memory allocators as well as the old videobuf and other
> v4l2 drivers which implement queue handling by themselves.

The problem is present in most (but not all) drivers, yes. That's one more 
reason to fix it in videobuf2 :-)

> The only solution that will not complicate the videobuf2 and allocators
> code is to move taking current->mm->mmap_sem lock into videobuf2 core.
> Before acquiring this lock, vb2 calls wait_prepare to release device lock
> and then once mmap_sem is locked, calls wait_finish to get it again. This
> way the deadlock is avoided and allocators are free to call
> get_user_pages() without further messing with locks. The only drawback is
> the fact that a bit more code will be executed under mmap_sem lock.
> 
> What do you think about such solution?

Won't that create a race condition ? Wouldn't an application for instance be 
able to call VIDIOC_REQBUFS(0) during the time window where the device lock is 
released ?

> > > +	if (n_pages_from_user != buf->n_pages)
> > > +		goto userptr_fail_get_user_pages;
> > > +
> > > +	buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1, PAGE_KERNEL);
> > 
> > Will this create a second kernel mapping ?
> 
> Yes, it is very similar to vmalloc function which grabs a set of pages and
> creates contiguous virtual kernel mapping for them.
> 
> > What if the user tries to pass framebuffer memory that has been mapped
> > uncacheable to userspace ?
> 
> get_user_pages() fails if it is called for framebuffer memory (VM_PFNMAP
> type mappings).

Right. Do you think we should handle them, or should we wait for the buffer 
sharing API ?

-- 
Regards,

Laurent Pinchart
