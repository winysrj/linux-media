Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19467 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1I0IXx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 04:23:53 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LS600MK59ZR0Q@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Sep 2011 09:23:51 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LS600K1E9ZRCV@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Sep 2011 09:23:51 +0100 (BST)
Date: Tue, 27 Sep 2011 10:23:42 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [GIT PULL] Selection API and fixes for v3.2
In-reply-to: <4E807E67.3000508@redhat.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	laurent.pinchart@ideasonboard.com
Message-id: <000001cc7cee$c465d350$4d3179f0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com>
 <4E805E6E.3080007@redhat.com>
 <011201cc7c3e$798c5bc0$6ca51340$%szyprowski@samsung.com>
 <4E807E67.3000508@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, September 26, 2011 3:30 PM Mauro Carvalho Chehab wrote:

> Em 26-09-2011 08:21, Marek Szyprowski escreveu:
> > Hello,
> >
> > On Monday, September 26, 2011 1:14 PM Mauro Carvalho Chehab wrote:
> >
> >>> Scott Jiang (1):
> >>>       vb2: add vb2_get_unmapped_area in vb2 core
> >>
> >>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> >>> index ea55c08..977410b 100644
> >>> --- a/include/media/videobuf2-core.h
> >>> +++ b/include/media/videobuf2-core.h
> >>> @@ -309,6 +309,13 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
> >>>  int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
> >>>
> >>>  int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
> >>> +#ifndef CONFIG_MMU
> >>> +unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
> >>> +				    unsigned long addr,
> >>> +				    unsigned long len,
> >>> +				    unsigned long pgoff,
> >>> +				    unsigned long flags);
> >>> +#endif
> >>>  unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
> >>>  size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
> >>>  		loff_t *ppos, int nonblock);
> >>
> >> This sounds me like a hack, as it is passing the problem of working with a non-mmu
> >> capable hardware to the driver, inserting architecture-dependent bits on them.
> >>
> >> The proper way to do it is to provide a vb2 core support to handle the non-mmu case
> >> inside it.
> >
> > This is exactly what this patch does - it provides generic vb2 implementation for
> > fops->get_unmapped_area callback which any vb2 ready driver can use. This operation
> > is used only on NON-MMU systems. Please check drivers/media/video/v4l2-dev.c file and
> > the implementation of get_unmapped_area there. Similar code is used by uvc driver.
> 
> At least there, there is a:
> #ifdef CONFIG_MMU
> #define v4l2_get_unmapped_area NULL
> #else
> ...
> #endif
> 
> block, so, in thesis, a driver can be written to support both cases without inserting
> #ifdefs inside it.

videobuf2 functions are not meant to be used as direct callbacks in fops so defining it
as NULL makes no sense at all.

> Ideally, I would prefer if all those iommu-specific calls would be inside the core.
> A driver should not need to do anything special in order to support a different
> (sub)architecture.

It is not about IOMMU at all. Some (embedded) systems don't have MMU at all. Drivers on
such systems cannot do regular mmap operation. Instead it is emulated with 
get_unmapped_area fops callback and some (u)libC magic. This patch just provides
vb2_get_unmapped_area function. Drivers have to call it from their respective
my_driver_get_unmapped_area() function provided in its fops. Implementing it makes
sense only on NO-MMU systems. I really see no other way of dealing with this.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



