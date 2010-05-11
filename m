Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43079 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211Ab0EKNfk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 09:35:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, hverkuil@xs4all.nl
Subject: [PATCH 6/7] v4l: videobuf: Remove videobuf_mapping start and end fields
Date: Tue, 11 May 2010 15:36:33 +0200
Message-Id: <1273584994-14211-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fields are assigned but never used, remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf-dma-contig.c |    2 --
 drivers/media/video/videobuf-dma-sg.c     |    2 --
 drivers/media/video/videobuf-vmalloc.c    |    2 --
 include/media/videobuf-core.h             |    2 --
 4 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index d87ed21..c5d2552 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -279,8 +279,6 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 		return -ENOMEM;
 
 	buf->map = map;
-	map->start = vma->vm_start;
-	map->end = vma->vm_end;
 	map->q = q;
 
 	buf->baddr = vma->vm_start;
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 8924e51..2d64040 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -608,8 +608,6 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	}
 
 	map->count    = 1;
-	map->start    = vma->vm_start;
-	map->end      = vma->vm_end;
 	map->q        = q;
 	vma->vm_ops   = &videobuf_vm_ops;
 	vma->vm_flags |= VM_DONTEXPAND | VM_RESERVED;
diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
index cf5be6b..f0d7cb8 100644
--- a/drivers/media/video/videobuf-vmalloc.c
+++ b/drivers/media/video/videobuf-vmalloc.c
@@ -245,8 +245,6 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 		return -ENOMEM;
 
 	buf->map = map;
-	map->start = vma->vm_start;
-	map->end   = vma->vm_end;
 	map->q     = q;
 
 	buf->baddr = vma->vm_start;
diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
index a157cd1..f2c41ce 100644
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -54,8 +54,6 @@ struct videobuf_queue;
 
 struct videobuf_mapping {
 	unsigned int count;
-	unsigned long start;
-	unsigned long end;
 	struct videobuf_queue *q;
 };
 
-- 
1.6.4.4

