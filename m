Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25208 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab0ELIC2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 04:02:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=utf-8
Received: from eu_spt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L2A00EGTRO1GG00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 May 2010 09:02:25 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L2A00L9MRO1MS@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 May 2010 09:02:25 +0100 (BST)
Date: Wed, 12 May 2010 10:01:53 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH 6/7] v4l: videobuf: Remove videobuf_mapping start and end
 fields
In-reply-to: <1273584994-14211-7-git-send-email-laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, kyungmin.park@samsung.com
Message-id: <000a01caf1a9$628c2840$27a478c0$%osciak@samsung.com>
Content-language: pl
References: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1273584994-14211-7-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>
>The fields are assigned but never used, remove them.
>
>Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>---
> drivers/media/video/videobuf-dma-contig.c |    2 --
> drivers/media/video/videobuf-dma-sg.c     |    2 --
> drivers/media/video/videobuf-vmalloc.c    |    2 --
> include/media/videobuf-core.h             |    2 --
> 4 files changed, 0 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/media/video/videobuf-dma-contig.c
>b/drivers/media/video/videobuf-dma-contig.c
>index d87ed21..c5d2552 100644
>--- a/drivers/media/video/videobuf-dma-contig.c
>+++ b/drivers/media/video/videobuf-dma-contig.c
>@@ -279,8 +279,6 @@ static int __videobuf_mmap_mapper(struct videobuf_queue
>*q,
> 		return -ENOMEM;
>
> 	buf->map = map;
>-	map->start = vma->vm_start;
>-	map->end = vma->vm_end;
> 	map->q = q;
>
> 	buf->baddr = vma->vm_start;
>diff --git a/drivers/media/video/videobuf-dma-sg.c
>b/drivers/media/video/videobuf-dma-sg.c
>index 8924e51..2d64040 100644
>--- a/drivers/media/video/videobuf-dma-sg.c
>+++ b/drivers/media/video/videobuf-dma-sg.c
>@@ -608,8 +608,6 @@ static int __videobuf_mmap_mapper(struct videobuf_queue
>*q,
> 	}
>
> 	map->count    = 1;
>-	map->start    = vma->vm_start;
>-	map->end      = vma->vm_end;
> 	map->q        = q;
> 	vma->vm_ops   = &videobuf_vm_ops;
> 	vma->vm_flags |= VM_DONTEXPAND | VM_RESERVED;
>diff --git a/drivers/media/video/videobuf-vmalloc.c
>b/drivers/media/video/videobuf-vmalloc.c
>index cf5be6b..f0d7cb8 100644
>--- a/drivers/media/video/videobuf-vmalloc.c
>+++ b/drivers/media/video/videobuf-vmalloc.c
>@@ -245,8 +245,6 @@ static int __videobuf_mmap_mapper(struct videobuf_queue
>*q,
> 		return -ENOMEM;
>
> 	buf->map = map;
>-	map->start = vma->vm_start;
>-	map->end   = vma->vm_end;
> 	map->q     = q;
>
> 	buf->baddr = vma->vm_start;
>diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
>index a157cd1..f2c41ce 100644
>--- a/include/media/videobuf-core.h
>+++ b/include/media/videobuf-core.h
>@@ -54,8 +54,6 @@ struct videobuf_queue;
>
> struct videobuf_mapping {
> 	unsigned int count;
>-	unsigned long start;
>-	unsigned long end;
> 	struct videobuf_queue *q;
> };
>
>--
>1.6.4.4


ack, I see no reason to keep them either.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





