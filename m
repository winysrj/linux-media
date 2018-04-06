Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:62292 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756746AbeDFOXh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 19/21] media: fsl-viu: use %p to print pointers
Date: Fri,  6 Apr 2018 10:23:20 -0400
Message-Id: <5551e90993915cfe61a7c2771f22a552d6a49d9d.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Solve those warnings:

    drivers/media/platform/fsl-viu.c:299 restart_video_queue() warn: argument 3 to %08lx specifier is cast from pointer
    drivers/media/platform/fsl-viu.c:506 buffer_queue() warn: argument 2 to %08lx specifier is cast from pointer
    drivers/media/platform/fsl-viu.c:518 buffer_queue() warn: argument 2 to %08lx specifier is cast from pointer
    drivers/media/platform/fsl-viu.c:528 buffer_queue() warn: argument 2 to %08lx specifier is cast from pointer
    drivers/media/platform/fsl-viu.c:1219 viu_open() warn: argument 2 to %08lx specifier is cast from pointer
    drivers/media/platform/fsl-viu.c:1219 viu_open() warn: argument 3 to %08lx specifier is cast from pointer
    drivers/media/platform/fsl-viu.c:1219 viu_open() warn: argument 4 to %08lx specifier is cast from pointer
    drivers/media/platform/fsl-viu.c:1329 viu_mmap() warn: argument 2 to %08lx specifier is cast from pointer
    drivers/media/platform/fsl-viu.c:1334 viu_mmap() warn: argument 2 to %08lx specifier is cast from pointer

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/fsl-viu.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 6fd1c8f66047..4ca060ee8c08 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -296,7 +296,7 @@ static int restart_video_queue(struct viu_dmaqueue *vidq)
 {
 	struct viu_buf *buf, *prev;
 
-	dprintk(1, "%s vidq=0x%08lx\n", __func__, (unsigned long)vidq);
+	dprintk(1, "%s vidq=%p\n", __func__, vidq);
 	if (!list_empty(&vidq->active)) {
 		buf = list_entry(vidq->active.next, struct viu_buf, vb.queue);
 		dprintk(2, "restart_queue [%p/%d]: restart dma\n",
@@ -503,8 +503,7 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 	struct viu_buf       *prev;
 
 	if (!list_empty(&vidq->queued)) {
-		dprintk(1, "adding vb queue=0x%08lx\n",
-				(unsigned long)&buf->vb.queue);
+		dprintk(1, "adding vb queue=%p\n", &buf->vb.queue);
 		dprintk(1, "vidq pointer 0x%p, queued 0x%p\n",
 				vidq, &vidq->queued);
 		dprintk(1, "dev %p, queued: self %p, next %p, head %p\n",
@@ -515,8 +514,7 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 		dprintk(2, "[%p/%d] buffer_queue - append to queued\n",
 			buf, buf->vb.i);
 	} else if (list_empty(&vidq->active)) {
-		dprintk(1, "adding vb active=0x%08lx\n",
-				(unsigned long)&buf->vb.queue);
+		dprintk(1, "adding vb active=%p\n", &buf->vb.queue);
 		list_add_tail(&buf->vb.queue, &vidq->active);
 		buf->vb.state = VIDEOBUF_ACTIVE;
 		mod_timer(&vidq->timeout, jiffies+BUFFER_TIMEOUT);
@@ -525,8 +523,7 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 
 		buffer_activate(dev, buf);
 	} else {
-		dprintk(1, "adding vb queue2=0x%08lx\n",
-				(unsigned long)&buf->vb.queue);
+		dprintk(1, "adding vb queue2=%p\n", &buf->vb.queue);
 		prev = list_entry(vidq->active.prev, struct viu_buf, vb.queue);
 		if (prev->vb.width  == buf->vb.width  &&
 		    prev->vb.height == buf->vb.height &&
@@ -1216,9 +1213,7 @@ static int viu_open(struct file *file)
 	dev->crop_current.width  = fh->width;
 	dev->crop_current.height = fh->height;
 
-	dprintk(1, "Open: fh=0x%08lx, dev=0x%08lx, dev->vidq=0x%08lx\n",
-		(unsigned long)fh, (unsigned long)dev,
-		(unsigned long)&dev->vidq);
+	dprintk(1, "Open: fh=%p, dev=%p, dev->vidq=%p\n", fh, dev, &dev->vidq);
 	dprintk(1, "Open: list_empty queued=%d\n",
 		list_empty(&dev->vidq.queued));
 	dprintk(1, "Open: list_empty active=%d\n",
@@ -1331,7 +1326,7 @@ static int viu_mmap(struct file *file, struct vm_area_struct *vma)
 	struct viu_dev *dev = fh->dev;
 	int ret;
 
-	dprintk(1, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
+	dprintk(1, "mmap called, vma=%p\n", vma);
 
 	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
-- 
2.14.3
