Return-path: <linux-media-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:34254 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab3EITDe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 15:03:34 -0400
Date: Thu, 9 May 2013 20:03:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: videobuf_vm_{open,close} race fixes
Message-ID: <20130509190333.GF25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

just use videobuf_queue_lock(map->q) to protect map->count; vm_area_operations
->open() and ->close() are called just under vma->vm_mm->mmap_sem, which
doesn't help the drivers at all, since clonal VMAs are normally in different
address spaces...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
WARNING: it's only build-tested

diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
index 67f572c3..8204c88 100644
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -66,11 +66,14 @@ static void __videobuf_dc_free(struct device *dev,
 static void videobuf_vm_open(struct vm_area_struct *vma)
 {
 	struct videobuf_mapping *map = vma->vm_private_data;
+	struct videobuf_queue *q = map->q;
 
-	dev_dbg(map->q->dev, "vm_open %p [count=%u,vma=%08lx-%08lx]\n",
+	dev_dbg(q->dev, "vm_open %p [count=%u,vma=%08lx-%08lx]\n",
 		map, map->count, vma->vm_start, vma->vm_end);
 
+	videobuf_queue_lock(q);
 	map->count++;
+	videobuf_queue_unlock(q);
 }
 
 static void videobuf_vm_close(struct vm_area_struct *vma)
@@ -82,12 +85,11 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 	dev_dbg(q->dev, "vm_close %p [count=%u,vma=%08lx-%08lx]\n",
 		map, map->count, vma->vm_start, vma->vm_end);
 
-	map->count--;
-	if (0 == map->count) {
+	videobuf_queue_lock(q);
+	if (!--map->count) {
 		struct videobuf_dma_contig_memory *mem;
 
 		dev_dbg(q->dev, "munmap %p q=%p\n", map, q);
-		videobuf_queue_lock(q);
 
 		/* We need first to cancel streams, before unmapping */
 		if (q->streaming)
@@ -126,8 +128,8 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 
 		kfree(map);
 
-		videobuf_queue_unlock(q);
 	}
+	videobuf_queue_unlock(q);
 }
 
 static const struct vm_operations_struct videobuf_vm_ops = {
diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 828e7c1..9db674c 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -338,11 +338,14 @@ EXPORT_SYMBOL_GPL(videobuf_dma_free);
 static void videobuf_vm_open(struct vm_area_struct *vma)
 {
 	struct videobuf_mapping *map = vma->vm_private_data;
+	struct videobuf_queue *q = map->q;
 
 	dprintk(2, "vm_open %p [count=%d,vma=%08lx-%08lx]\n", map,
 		map->count, vma->vm_start, vma->vm_end);
 
+	videobuf_queue_lock(q);
 	map->count++;
+	videobuf_queue_unlock(q);
 }
 
 static void videobuf_vm_close(struct vm_area_struct *vma)
@@ -355,10 +358,9 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 	dprintk(2, "vm_close %p [count=%d,vma=%08lx-%08lx]\n", map,
 		map->count, vma->vm_start, vma->vm_end);
 
-	map->count--;
-	if (0 == map->count) {
+	videobuf_queue_lock(q);
+	if (!--map->count) {
 		dprintk(1, "munmap %p q=%p\n", map, q);
-		videobuf_queue_lock(q);
 		for (i = 0; i < VIDEO_MAX_FRAME; i++) {
 			if (NULL == q->bufs[i])
 				continue;
@@ -374,9 +376,9 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 			q->bufs[i]->baddr = 0;
 			q->ops->buf_release(q, q->bufs[i]);
 		}
-		videobuf_queue_unlock(q);
 		kfree(map);
 	}
+	videobuf_queue_unlock(q);
 	return;
 }
 
diff --git a/drivers/media/v4l2-core/videobuf-vmalloc.c b/drivers/media/v4l2-core/videobuf-vmalloc.c
index 2ff7fcc..1365c65 100644
--- a/drivers/media/v4l2-core/videobuf-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf-vmalloc.c
@@ -54,11 +54,14 @@ MODULE_LICENSE("GPL");
 static void videobuf_vm_open(struct vm_area_struct *vma)
 {
 	struct videobuf_mapping *map = vma->vm_private_data;
+	struct videobuf_queue *q = map->q;
 
 	dprintk(2, "vm_open %p [count=%u,vma=%08lx-%08lx]\n", map,
 		map->count, vma->vm_start, vma->vm_end);
 
+	videobuf_queue_lock(q);
 	map->count++;
+	videobuf_queue_unlock(q);
 }
 
 static void videobuf_vm_close(struct vm_area_struct *vma)
@@ -70,12 +73,11 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 	dprintk(2, "vm_close %p [count=%u,vma=%08lx-%08lx]\n", map,
 		map->count, vma->vm_start, vma->vm_end);
 
-	map->count--;
-	if (0 == map->count) {
+	videobuf_queue_lock(q);
+	if (!--map->count) {
 		struct videobuf_vmalloc_memory *mem;
 
 		dprintk(1, "munmap %p q=%p\n", map, q);
-		videobuf_queue_lock(q);
 
 		/* We need first to cancel streams, before unmapping */
 		if (q->streaming)
@@ -114,8 +116,8 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 
 		kfree(map);
 
-		videobuf_queue_unlock(q);
 	}
+	videobuf_queue_unlock(q);
 
 	return;
 }
