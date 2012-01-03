Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31096 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2ACI1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 03:27:47 -0500
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LX700BK4RI85K@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Jan 2012 08:27:45 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LX700IQDRI8SG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Jan 2012 08:27:44 +0000 (GMT)
Date: Tue, 03 Jan 2012 09:27:40 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 1/2] media: vb2: support userptr for PFN mappings.
In-reply-to: <CACKLOr01K_j0EKGQ4EL8v1cHcH0Q2xZ0nd6AmSreG1vYckGq9A@mail.gmail.com>
To: 'javier Martin' <javier.martin@vista-silicon.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	pawel@osciak.com, kyungmin.park@samsung.com
Message-id: <00cb01ccc9f1$8ec24760$ac46d620$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 8BIT
References: <1325513543-17299-1-git-send-email-javier.martin@vista-silicon.com>
 <201201022000.30078.laurent.pinchart@ideasonboard.com>
 <CACKLOr01K_j0EKGQ4EL8v1cHcH0Q2xZ0nd6AmSreG1vYckGq9A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, January 03, 2012 8:48 AM javier Martin wrote:

> On 2 January 2012 20:00, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> > Hi Javier,
> >
> > Thanks for the patch.
> >
> > On Monday 02 January 2012 15:12:22 Javier Martin wrote:
> >> Some video devices need to use contiguous memory
> >> which is not backed by pages as it happens with
> >> vmalloc. This patch provides userptr handling for
> >> those devices.
> >
> > What's your main use case ? Capturing to the frame buffer ?
> 
> My main use case is capturing to my mx2_emmaprp mem2mem driver which
> converts from YUV422 to YUV420 format in HW.
> 
> >> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> >> ---
> >>  drivers/media/video/videobuf2-vmalloc.c |   66
> >> +++++++++++++++++++----------- 1 files changed, 42 insertions(+), 24
> >> deletions(-)
> >>
> >> diff --git a/drivers/media/video/videobuf2-vmalloc.c
> >> b/drivers/media/video/videobuf2-vmalloc.c index 03aa62f..5bc7cec 100644
> >> --- a/drivers/media/video/videobuf2-vmalloc.c
> >> +++ b/drivers/media/video/videobuf2-vmalloc.c
> >> @@ -15,6 +15,7 @@
> >>  #include <linux/sched.h>
> >>  #include <linux/slab.h>
> >>  #include <linux/vmalloc.h>
> >> +#include <linux/io.h>
> >
> > Please keep headers sorted alphabetically.
> 
> OK. I didn't know that was the rule.
> 
> >>  #include <media/videobuf2-core.h>
> >>  #include <media/videobuf2-memops.h>
> >> @@ -71,6 +72,8 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx,
> >> unsigned long vaddr, struct vb2_vmalloc_buf *buf;
> >>       unsigned long first, last;
> >>       int n_pages, offset;
> >> +     struct vm_area_struct *vma;
> >> +     unsigned long int physp;
> >>
> >>       buf = kzalloc(sizeof(*buf), GFP_KERNEL);
> >>       if (!buf)
> >> @@ -80,23 +83,34 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx,
> >> unsigned long vaddr, offset = vaddr & ~PAGE_MASK;
> >>       buf->size = size;
> >>
> >> -     first = vaddr >> PAGE_SHIFT;
> >> -     last  = (vaddr + size - 1) >> PAGE_SHIFT;
> >> -     buf->n_pages = last - first + 1;
> >> -     buf->pages = kzalloc(buf->n_pages * sizeof(struct page *), GFP_KERNEL);
> >> -     if (!buf->pages)
> >> -             goto fail_pages_array_alloc;
> >> -
> >> -     /* current->mm->mmap_sem is taken by videobuf2 core */
> >> -     n_pages = get_user_pages(current, current->mm, vaddr & PAGE_MASK,
> >> -                                     buf->n_pages, write, 1, /* force */
> >> -                                     buf->pages, NULL);
> >> -     if (n_pages != buf->n_pages)
> >> -             goto fail_get_user_pages;
> >> -
> >> -     buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1, PAGE_KERNEL);
> >> -     if (!buf->vaddr)
> >> -             goto fail_get_user_pages;
> >> +     vma = find_vma(current->mm, vaddr);
> >> +     if (vma && (vma->vm_flags & VM_IO) && (vma->vm_pgoff)) {
> >> +             physp = (vma->vm_pgoff << PAGE_SHIFT) + (vaddr - vma->vm_start);
> >> +             buf->vaddr = ioremap_nocache(physp, size);
> >> +             if (!buf->vaddr)
> >> +                     goto fail_pages_array_alloc;
> >
> > What if the region spans multiple VMAs ? Shouldn't you at least verify that
> > the region is physically contiguous, and that all VMAs share the same flags ?
> > That's what the OMAP3 ISP driver does (in ispqueue.c). Maybe it's overkill
> > though.
> >
> > If you do that, the could might be cleaner if you split this function in two,
> > as in the OMAP3 ISP driver.
> 
> Yes, I suspected this could probably be troublesome. I'll take a look
> at OMAP3 ISP and see what I can do.

You can grab most of the required code for proper vma locking and contiguous pfn
extraction from videobuf2-dma_contig.c (vb2_dma_contig_get_userptr) and 
videobuf2-memops.c (vb2_get_contig_userptr function), although the latter still 
has some incomplete assumptions (it works correctly only with platforms where 
dma address equals physical address in system memory - we will fix this soon).

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


