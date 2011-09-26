Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52973 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1IZLVx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 07:21:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LS400E2UNKFWN30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 26 Sep 2011 12:21:51 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LS4006EBNKEKE@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 26 Sep 2011 12:21:51 +0100 (BST)
Date: Mon, 26 Sep 2011 13:21:45 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [GIT PULL] Selection API and fixes for v3.2
In-reply-to: <4E805E6E.3080007@redhat.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, pawel@osciak.com
Message-id: <011201cc7c3e$798c5bc0$6ca51340$%szyprowski@samsung.com>
Content-language: pl
References: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com>
 <4E805E6E.3080007@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, September 26, 2011 1:14 PM Mauro Carvalho Chehab wrote:

> > Scott Jiang (1):
> >       vb2: add vb2_get_unmapped_area in vb2 core
> 
> > diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> > index ea55c08..977410b 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h
> > @@ -309,6 +309,13 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
> >  int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
> >
> >  int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
> > +#ifndef CONFIG_MMU
> > +unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
> > +				    unsigned long addr,
> > +				    unsigned long len,
> > +				    unsigned long pgoff,
> > +				    unsigned long flags);
> > +#endif
> >  unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
> >  size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
> >  		loff_t *ppos, int nonblock);
> 
> This sounds me like a hack, as it is passing the problem of working with a non-mmu
> capable hardware to the driver, inserting architecture-dependent bits on them.
> 
> The proper way to do it is to provide a vb2 core support to handle the non-mmu case
> inside it.

This is exactly what this patch does - it provides generic vb2 implementation for 
fops->get_unmapped_area callback which any vb2 ready driver can use. This operation
is used only on NON-MMU systems. Please check drivers/media/video/v4l2-dev.c file and
the implementation of get_unmapped_area there. Similar code is used by uvc driver.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



