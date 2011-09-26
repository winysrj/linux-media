Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45847 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1IZOlm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 10:41:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL] Selection API and fixes for v3.2
Date: Mon, 26 Sep 2011 16:41:44 +0200
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, pawel@osciak.com
References: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com> <011201cc7c3e$798c5bc0$6ca51340$%szyprowski@samsung.com> <4E807E67.3000508@redhat.com>
In-Reply-To: <4E807E67.3000508@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109261641.45904.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday 26 September 2011 15:30:15 Mauro Carvalho Chehab wrote:
> Em 26-09-2011 08:21, Marek Szyprowski escreveu:
> > On Monday, September 26, 2011 1:14 PM Mauro Carvalho Chehab wrote:
> >>> Scott Jiang (1):
> >>>       vb2: add vb2_get_unmapped_area in vb2 core
> >>> 
> >>> diff --git a/include/media/videobuf2-core.h
> >>> b/include/media/videobuf2-core.h index ea55c08..977410b 100644
> >>> --- a/include/media/videobuf2-core.h
> >>> +++ b/include/media/videobuf2-core.h
> >>> @@ -309,6 +309,13 @@ int vb2_streamon(struct vb2_queue *q, enum
> >>> v4l2_buf_type type);
> >>> 
> >>>  int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
> >>>  
> >>>  int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
> >>> 
> >>> +#ifndef CONFIG_MMU
> >>> +unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
> >>> +				    unsigned long addr,
> >>> +				    unsigned long len,
> >>> +				    unsigned long pgoff,
> >>> +				    unsigned long flags);
> >>> +#endif
> >>> 
> >>>  unsigned int vb2_poll(struct vb2_queue *q, struct file *file,
> >>>  poll_table *wait); size_t vb2_read(struct vb2_queue *q, char __user
> >>>  *data, size_t count,
> >>>  
> >>>  		loff_t *ppos, int nonblock);
> >> 
> >> This sounds me like a hack, as it is passing the problem of working with
> >> a non-mmu capable hardware to the driver, inserting
> >> architecture-dependent bits on them.
> >> 
> >> The proper way to do it is to provide a vb2 core support to handle the
> >> non-mmu case inside it.
> > 
> > This is exactly what this patch does - it provides generic vb2
> > implementation for fops->get_unmapped_area callback which any vb2 ready
> > driver can use. This operation is used only on NON-MMU systems. Please
> > check drivers/media/video/v4l2-dev.c file and the implementation of
> > get_unmapped_area there. Similar code is used by uvc driver.
> 
> At least there, there is a:
> #ifdef CONFIG_MMU
> #define v4l2_get_unmapped_area NULL
> #else
> ...
> #endif
> 
> block, so, in thesis, a driver can be written to support both cases without
> inserting #ifdefs inside it.
> 
> Ideally, I would prefer if all those iommu-specific calls would be inside
> the core. A driver should not need to do anything special in order to
> support a different (sub)architecture.

Just for the sake of correctness, this is about no-mmu systems, not about 
iommus.

-- 
Regards,

Laurent Pinchart
