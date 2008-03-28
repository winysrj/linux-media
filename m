Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SAYoE5028137
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:34:50 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SAYUGI018739
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:34:35 -0400
Received: by fg-out-1718.google.com with SMTP id e12so175366fga.7
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 03:34:30 -0700 (PDT)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <ab74ebf10c01d6a8a54a.1206699517@localhost>
In-Reply-To: <patchbomb.1206699511@localhost>
Date: Fri, 28 Mar 2008 03:18:37 -0700
From: Brandon Philips <brandon@ifup.org>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: [PATCH 6 of 9] videobuf-vmalloc.c: Fix hack of postponing mmap on
	remap failure
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

# HG changeset patch
# User Brandon Philips <brandon@ifup.org>
# Date 1206699280 25200
# Node ID ab74ebf10c01d6a8a54a39b6750bc86ec3e72286
# Parent  eb99bdd0a7e3f70eb40fcc6918794a8b8822ac49
videobuf-vmalloc.c: Fix hack of postponing mmap on remap failure

In videobuf-vmalloc.c remap_vmalloc_range is failing when applications are
trying to mmap buffers immediately after reqbuf.  It fails because the vmalloc
area isn't setup until the first QBUF when drivers call iolock.

This patch introduces mmap_setup to the qtype_ops and it is called in
__videobuf_mmap_setup if the buffer type is mmap.  In the case of vmalloc
buffers this calls iolock, and sets the state to idle.

I don't think this is needed for dma-sg buffers and it defaults to a no-op for
everything but vmalloc.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 linux/drivers/media/video/videobuf-core.c    |   29 +++++++-----------
 linux/drivers/media/video/videobuf-vmalloc.c |   43 +++++++++++++--------------
 linux/include/media/videobuf-core.h          |    3 +
 3 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/linux/drivers/media/video/videobuf-core.c b/linux/drivers/media/video/videobuf-core.c
--- a/linux/drivers/media/video/videobuf-core.c
+++ b/linux/drivers/media/video/videobuf-core.c
@@ -92,24 +92,16 @@ int videobuf_iolock(struct videobuf_queu
 	MAGIC_CHECK(vb->magic, MAGIC_BUFFER);
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
-	/* This is required to avoid OOPS on some cases,
-	   since mmap_mapper() method should be called before _iolock.
-	   On some cases, the mmap_mapper() is called only after scheduling.
-	 */
-	if (vb->memory == V4L2_MEMORY_MMAP) {
-		wait_event_timeout(vb->done, q->is_mmapped,
-				   msecs_to_jiffies(100));
-		if (!q->is_mmapped) {
-			printk(KERN_ERR
-			       "Error: mmap_mapper() never called!\n");
-			return -EINVAL;
-		}
-	}
-
 	return CALL(q, iolock, q, vb, fbuf);
 }
 
 /* --------------------------------------------------------------------- */
+
+static int videobuf_mmap_setup_default(struct videobuf_queue *q,
+					struct videobuf_buffer *vb)
+{
+	return 0;
+}
 
 
 void videobuf_queue_core_init(struct videobuf_queue *q,
@@ -131,6 +123,9 @@ void videobuf_queue_core_init(struct vid
 	q->ops       = ops;
 	q->priv_data = priv;
 	q->int_ops   = int_ops;
+
+	if (!q->int_ops->mmap_setup)
+		q->int_ops->mmap_setup = videobuf_mmap_setup_default;
 
 	/* All buffer operations are mandatory */
 	BUG_ON(!q->ops->buf_setup);
@@ -305,8 +300,6 @@ static int __videobuf_mmap_free(struct v
 
 	rc  = CALL(q, mmap_free, q);
 
-	q->is_mmapped = 0;
-
 	if (rc < 0)
 		return rc;
 
@@ -358,6 +351,9 @@ static int __videobuf_mmap_setup(struct 
 		switch (memory) {
 		case V4L2_MEMORY_MMAP:
 			q->bufs[i]->boff  = bsize * i;
+			err = q->int_ops->mmap_setup(q, q->bufs[i]);
+			if (err)
+				break;
 			break;
 		case V4L2_MEMORY_USERPTR:
 		case V4L2_MEMORY_OVERLAY:
@@ -1018,7 +1014,6 @@ int videobuf_mmap_mapper(struct videobuf
 
 	mutex_lock(&q->vb_lock);
 	retval = CALL(q, mmap_mapper, q, vma);
-	q->is_mmapped = 1;
 	mutex_unlock(&q->vb_lock);
 
 	return retval;
diff --git a/linux/drivers/media/video/videobuf-vmalloc.c b/linux/drivers/media/video/videobuf-vmalloc.c
--- a/linux/drivers/media/video/videobuf-vmalloc.c
+++ b/linux/drivers/media/video/videobuf-vmalloc.c
@@ -152,21 +152,26 @@ static int __videobuf_iolock (struct vid
 				(unsigned long)mem->vmalloc,
 				pages << PAGE_SHIFT);
 
-	/* It seems that some kernel versions need to do remap *after*
-	   the mmap() call
-	 */
-	if (mem->vma) {
-		int retval=remap_vmalloc_range(mem->vma, mem->vmalloc,0);
-		kfree(mem->vma);
-		mem->vma=NULL;
-		if (retval<0) {
-			dprintk(1,"mmap app bug: remap_vmalloc_range area %p error %d\n",
-				mem->vmalloc,retval);
-			return retval;
+	return 0;
+}
+
+static int __videobuf_mmap_setup(struct videobuf_queue *q,
+			      struct videobuf_buffer *vb)
+{
+	int retval = 0;
+	BUG_ON(vb->memory != V4L2_MEMORY_MMAP);
+	if (vb->state == VIDEOBUF_NEEDS_INIT) {
+		/* bsize == size since the buffer needs to be large enough to
+		 * hold an entire frame, not the case in the read case for
+		 * example*/
+		vb->size = vb->bsize;
+		retval = __videobuf_iolock(q, vb, NULL);
+		if (!retval) {
+			/* Don't IOLOCK later */
+			vb->state = VIDEOBUF_IDLE;
 		}
 	}
-
-	return 0;
+	return retval;
 }
 
 static int __videobuf_sync(struct videobuf_queue *q,
@@ -239,15 +244,8 @@ static int __videobuf_mmap_mapper(struct
 	/* Try to remap memory */
 	retval=remap_vmalloc_range(vma, mem->vmalloc,0);
 	if (retval<0) {
-		dprintk(1,"mmap: postponing remap_vmalloc_range\n");
-
-		mem->vma=kmalloc(sizeof(*vma),GFP_KERNEL);
-		if (!mem->vma) {
-			kfree(map);
-			q->bufs[first]->map=NULL;
-			return -ENOMEM;
-		}
-		memcpy(mem->vma,vma,sizeof(*vma));
+		dprintk(1, "mmap: failed to remap_vmalloc_range\n");
+		return -EINVAL;
 	}
 
 	dprintk(1,"mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
@@ -315,6 +313,7 @@ static struct videobuf_qtype_ops qops = 
 	.alloc        = __videobuf_alloc,
 	.iolock       = __videobuf_iolock,
 	.sync         = __videobuf_sync,
+	.mmap_setup   = __videobuf_mmap_setup,
 	.mmap_free    = __videobuf_mmap_free,
 	.mmap_mapper  = __videobuf_mmap_mapper,
 	.video_copy_to_user = __videobuf_copy_to_user,
diff --git a/linux/include/media/videobuf-core.h b/linux/include/media/videobuf-core.h
--- a/linux/include/media/videobuf-core.h
+++ b/linux/include/media/videobuf-core.h
@@ -144,6 +144,8 @@ struct videobuf_qtype_ops {
 				 int vbihack,
 				 int nonblocking);
 	int (*mmap_free)	(struct videobuf_queue *q);
+	int (*mmap_setup)	(struct videobuf_queue *q,
+				 struct videobuf_buffer *vb);
 	int (*mmap_mapper)	(struct videobuf_queue *q,
 				struct vm_area_struct *vma);
 };
@@ -168,7 +170,6 @@ struct videobuf_queue {
 
 	unsigned int               streaming:1;
 	unsigned int               reading:1;
-	unsigned int		   is_mmapped:1;
 
 	/* capture via mmap() + ioctl(QBUF/DQBUF) */
 	struct list_head           stream;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
