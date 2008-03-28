Return-path: <video4linux-list-bounces@redhat.com>
Message-Id: <20080328094022.060502743@ifup.org>
References: <20080328093944.278994792@ifup.org>
Date: Fri, 28 Mar 2008 02:39:51 -0700
From: brandon@ifup.org
To: mchehab@infradead.org
Content-Disposition: inline; filename=simplified-vivi.patch
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Brandon Philips <bphilips@suse.de>
Subject: [patch 7/9] vivi: Simplify the vivi driver and avoid deadlocks
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

vivi previously had a very complex queuing system and held spinlocks while
doing copy_to_user, kmalloc, etc.  This caused the driver to easily deadlock
when a multi-threaded application used it and revealed bugs in videobuf too.

This replaces the copy_to_user with memcpy since we were never copying to user
space addresses.  And makes the kmalloc atomic.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 linux/drivers/media/video/vivi.c |  318 ++++++++++-----------------------------
 1 file changed, 82 insertions(+), 236 deletions(-)

Index: v4l-dvb/linux/drivers/media/video/vivi.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/vivi.c
+++ v4l-dvb/linux/drivers/media/video/vivi.c
@@ -5,6 +5,7 @@
  *      Mauro Carvalho Chehab <mchehab--a.t--infradead.org>
  *      Ted Walther <ted--a.t--enumera.com>
  *      John Sokol <sokol--a.t--videotechnology.com>
+ *      Brandon Philips <brandon@ifup.org>
  *      http://v4l.videotechnology.com/
  *
  * This program is free software; you can redistribute it and/or modify
@@ -155,8 +156,6 @@ struct vivi_buffer {
 
 struct vivi_dmaqueue {
 	struct list_head       active;
-	struct list_head       queued;
-	struct timer_list      timeout;
 
 	/* thread for generating video stream*/
 	struct task_struct         *kthread;
@@ -175,11 +174,6 @@ static LIST_HEAD(vivi_devlist);
 struct vivi_dev {
 	struct list_head           vivi_devlist;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 16)
-	struct mutex               lock;
-#else
-	struct semaphore           lock;
-#endif
 	spinlock_t                 slock;
 
 	int                        users;
@@ -339,24 +333,26 @@ static void gen_line(char *basep, int in
 end:
 	return;
 }
+
 static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 {
 	int h , pos = 0;
 	int hmax  = buf->vb.height;
 	int wmax  = buf->vb.width;
 	struct timeval ts;
-	char *tmpbuf = kmalloc(wmax * 2, GFP_KERNEL);
+	char *tmpbuf = kmalloc(wmax * 2, GFP_ATOMIC);
 	void *vbuf = videobuf_to_vmalloc(&buf->vb);
 
 	if (!tmpbuf)
 		return;
 
+	if (!vbuf)
+		return;
+
 	for (h = 0; h < hmax; h++) {
 		gen_line(tmpbuf, 0, wmax, hmax, h, dev->mv_count,
 			 dev->timestr);
-		/* FIXME: replacing to __copy_to_user */
-		if (copy_to_user(vbuf + pos, tmpbuf, wmax * 2) != 0)
-			dprintk(dev, 2, "vivifill copy_to_user failed.\n");
+		memcpy(vbuf + pos, tmpbuf, wmax * 2);
 		pos += wmax*2;
 	}
 
@@ -389,67 +385,58 @@ static void vivi_fillbuff(struct vivi_de
 			dev->timestr, (unsigned long)tmpbuf, pos);
 
 	/* Advice that buffer was filled */
-	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
 	do_gettimeofday(&ts);
 	buf->vb.ts = ts;
-
-	list_del(&buf->vb.queue);
-	wake_up(&buf->vb.done);
+	buf->vb.state = VIDEOBUF_DONE;
 }
 
-static int restart_video_queue(struct vivi_dmaqueue *dma_q);
-
-static void vivi_thread_tick(struct vivi_dmaqueue  *dma_q)
+static void vivi_thread_tick(struct vivi_fh *fh)
 {
-	struct vivi_buffer    *buf;
-	struct vivi_dev *dev = container_of(dma_q, struct vivi_dev, vidq);
+	struct vivi_buffer *buf;
+	struct vivi_dev *dev = fh->dev;
+	struct vivi_dmaqueue *dma_q = &dev->vidq;
 
-	int bc;
+	unsigned long flags = 0;
 
-	spin_lock(&dev->slock);
-	/* Announces videobuf that all went ok */
-	for (bc = 0;; bc++) {
-		if (list_empty(&dma_q->active)) {
-			dprintk(dev, 1, "No active queue to serve\n");
-			break;
-		}
+	dprintk(dev, 1, "Thread tick\n");
 
-		buf = list_entry(dma_q->active.next,
-				 struct vivi_buffer, vb.queue);
+	spin_lock_irqsave(&dev->slock, flags);
+	if (list_empty(&dma_q->active)) {
+		dprintk(dev, 1, "No active queue to serve\n");
+		goto unlock;
+	}
 
-		/* Nobody is waiting something to be done, just return */
-		if (!waitqueue_active(&buf->vb.done)) {
-			mod_timer(&dma_q->timeout, jiffies+BUFFER_TIMEOUT);
-			spin_unlock(&dev->slock);
-			return;
-		}
+	buf = list_entry(dma_q->active.next,
+			 struct vivi_buffer, vb.queue);
 
-		do_gettimeofday(&buf->vb.ts);
-		dprintk(dev, 2, "[%p/%d] wakeup\n", buf, buf->vb. i);
+	/* Nobody is waiting on this buffer, return */
+	if (!waitqueue_active(&buf->vb.done))
+		goto unlock;
 
-		/* Fill buffer */
-		vivi_fillbuff(dev, buf);
+	list_del(&buf->vb.queue);
 
-		if (list_empty(&dma_q->active)) {
-			del_timer(&dma_q->timeout);
-		} else {
-			mod_timer(&dma_q->timeout, jiffies + BUFFER_TIMEOUT);
-		}
-	}
-	if (bc != 1)
-		dprintk(dev, 1, "%s: %d buffers handled (should be 1)\n",
-			__FUNCTION__, bc);
-	spin_unlock(&dev->slock);
+	do_gettimeofday(&buf->vb.ts);
+
+	/* Fill buffer */
+	vivi_fillbuff(dev, buf);
+	dprintk(dev, 1, "filled buffer %p\n", buf);
+
+	wake_up(&buf->vb.done);
+	dprintk(dev, 2, "[%p/%d] wakeup\n", buf, buf->vb. i);
+unlock:
+	spin_unlock_irqrestore(&dev->slock, flags);
+	return;
 }
 
 #define frames_to_ms(frames)					\
 	((frames * WAKE_NUMERATOR * 1000) / WAKE_DENOMINATOR)
 
-static void vivi_sleep(struct vivi_dmaqueue  *dma_q)
+static void vivi_sleep(struct vivi_fh *fh)
 {
-	struct vivi_dev *dev = container_of(dma_q, struct vivi_dev, vidq);
-	int timeout, running_time;
+	struct vivi_dev *dev = fh->dev;
+	struct vivi_dmaqueue *dma_q = &dev->vidq;
+	int timeout;
 	DECLARE_WAITQUEUE(wait, current);
 
 	dprintk(dev, 1, "%s dma_q=0x%08lx\n", __FUNCTION__,
@@ -464,37 +451,10 @@ static void vivi_sleep(struct vivi_dmaqu
 		goto stop_task;
 #endif
 
-	running_time = jiffies - dma_q->ini_jiffies;
-	dma_q->frame++;
-
 	/* Calculate time to wake up */
-	timeout = msecs_to_jiffies(frames_to_ms(dma_q->frame)) - running_time;
-
-	if (timeout > msecs_to_jiffies(frames_to_ms(2)) || timeout <= 0) {
-		int old = dma_q->frame;
-		int nframes;
-
-		dma_q->frame = (jiffies_to_msecs(running_time) /
-			       frames_to_ms(1)) + 1;
-
-		timeout = msecs_to_jiffies(frames_to_ms(dma_q->frame))
-			  - running_time;
-
-		if (unlikely (timeout <= 0))
-			timeout = 1;
+	timeout = msecs_to_jiffies(frames_to_ms(1));
 
-		nframes = (dma_q->frame > old)?
-				  dma_q->frame - old : old - dma_q->frame;
-
-		dprintk(dev, 1, "%ld: %s %d frames. "
-			"Current frame is %d. Will sleep for %d jiffies\n",
-			jiffies,
-			(dma_q->frame > old)? "Underrun, losed" : "Overrun of",
-			nframes, dma_q->frame, timeout);
-	} else
-		dprintk(dev, 1, "will sleep for %d jiffies\n", timeout);
-
-	vivi_thread_tick(dma_q);
+	vivi_thread_tick(fh);
 
 	schedule_timeout_interruptible(timeout);
 
@@ -505,8 +465,8 @@ stop_task:
 
 static int vivi_thread(void *data)
 {
-	struct vivi_dmaqueue  *dma_q = data;
-	struct vivi_dev *dev = container_of(dma_q, struct vivi_dev, vidq);
+	struct vivi_fh  *fh = data;
+	struct vivi_dev *dev = fh->dev;
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 5, 0)
 	daemonize();
@@ -524,11 +484,10 @@ static int vivi_thread(void *data)
 #endif
 	dprintk(dev, 1, "thread started\n");
 
-	mod_timer(&dma_q->timeout, jiffies+BUFFER_TIMEOUT);
 	set_freezable();
 
 	for (;;) {
-		vivi_sleep(dma_q);
+		vivi_sleep(fh);
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 5, 0)
 		if (dma_q->rmmod || signal_pending(current))
@@ -547,9 +506,10 @@ static int vivi_thread(void *data)
 	return 0;
 }
 
-static int vivi_start_thread(struct vivi_dmaqueue  *dma_q)
+static int vivi_start_thread(struct vivi_fh *fh)
 {
-	struct vivi_dev *dev = container_of(dma_q, struct vivi_dev, vidq);
+	struct vivi_dev *dev = fh->dev;
+	struct vivi_dmaqueue *dma_q = &dev->vidq;
 
 	dma_q->frame = 0;
 	dma_q->ini_jiffies = jiffies;
@@ -557,7 +517,7 @@ static int vivi_start_thread(struct vivi
 	dprintk(dev, 1, "%s\n", __FUNCTION__);
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 5, 0)
-	dma_q->kthread = kthread_run(vivi_thread, dma_q, "vivi");
+	dma_q->kthread = kthread_run(vivi_thread, fh, "vivi");
 
 	if (IS_ERR(dma_q->kthread)) {
 		printk(KERN_ERR "vivi: kernel_thread() failed\n");
@@ -570,7 +530,7 @@ static int vivi_start_thread(struct vivi
 	dma_q->notify = &sem;
 	dma_q->rmmod = 0;
 
-	if (kernel_thread(vivi_thread, dma_q, 0) < 0) {
+	if (kernel_thread(vivi_thread, fh, 0) < 0) {
 		printk(KERN_ERR "sdim: kernel_thread() failed\n");
 		return -EINVAL;
 	}
@@ -609,91 +569,6 @@ static void vivi_stop_thread(struct vivi
 	}
 }
 
-static int restart_video_queue(struct vivi_dmaqueue *dma_q)
-{
-	struct vivi_dev *dev = container_of(dma_q, struct vivi_dev, vidq);
-	struct vivi_buffer *buf, *prev;
-
-	dprintk(dev, 1, "%s dma_q=0x%08lx\n", __FUNCTION__,
-		(unsigned long)dma_q);
-
-	if (!list_empty(&dma_q->active)) {
-		buf = list_entry(dma_q->active.next,
-				 struct vivi_buffer, vb.queue);
-		dprintk(dev, 2, "restart_queue [%p/%d]: restart dma\n",
-			buf, buf->vb.i);
-
-		dprintk(dev, 1, "Restarting video dma\n");
-		vivi_stop_thread(dma_q);
-
-		/* cancel all outstanding capture / vbi requests */
-		list_for_each_entry_safe(buf, prev, &dma_q->active, vb.queue) {
-			list_del(&buf->vb.queue);
-			buf->vb.state = VIDEOBUF_ERROR;
-			wake_up(&buf->vb.done);
-		}
-		mod_timer(&dma_q->timeout, jiffies+BUFFER_TIMEOUT);
-
-		return 0;
-	}
-
-	prev = NULL;
-	for (;;) {
-		if (list_empty(&dma_q->queued))
-			return 0;
-		buf = list_entry(dma_q->queued.next,
-				 struct vivi_buffer, vb.queue);
-		if (NULL == prev) {
-			list_del(&buf->vb.queue);
-			list_add_tail(&buf->vb.queue, &dma_q->active);
-
-			dprintk(dev, 1, "Restarting video dma\n");
-			vivi_stop_thread(dma_q);
-			vivi_start_thread(dma_q);
-
-			buf->vb.state = VIDEOBUF_ACTIVE;
-			mod_timer(&dma_q->timeout, jiffies+BUFFER_TIMEOUT);
-			dprintk(dev, 2,
-				"[%p/%d] restart_queue - first active\n",
-				buf, buf->vb.i);
-
-		} else if (prev->vb.width  == buf->vb.width  &&
-			   prev->vb.height == buf->vb.height &&
-			   prev->fmt       == buf->fmt) {
-			list_del(&buf->vb.queue);
-			list_add_tail(&buf->vb.queue, &dma_q->active);
-			buf->vb.state = VIDEOBUF_ACTIVE;
-			dprintk(dev, 2,
-				"[%p/%d] restart_queue - move to active\n",
-				buf, buf->vb.i);
-		} else {
-			return 0;
-		}
-		prev = buf;
-	}
-}
-
-static void vivi_vid_timeout(unsigned long data)
-{
-	struct vivi_dev      *dev  = (struct vivi_dev *)data;
-	struct vivi_dmaqueue *vidq = &dev->vidq;
-	struct vivi_buffer   *buf;
-
-	spin_lock(&dev->slock);
-
-	while (!list_empty(&vidq->active)) {
-		buf = list_entry(vidq->active.next,
-				 struct vivi_buffer, vb.queue);
-		list_del(&buf->vb.queue);
-		buf->vb.state = VIDEOBUF_ERROR;
-		wake_up(&buf->vb.done);
-		printk(KERN_INFO "vivi/0: [%p/%d] timeout\n", buf, buf->vb.i);
-	}
-	restart_video_queue(vidq);
-
-	spin_unlock(&dev->slock);
-}
-
 /* ------------------------------------------------------------------
 	Videobuf operations
    ------------------------------------------------------------------*/
@@ -722,13 +597,13 @@ static void free_buffer(struct videobuf_
 	struct vivi_fh  *fh = vq->priv_data;
 	struct vivi_dev *dev  = fh->dev;
 
-	dprintk(dev, 1, "%s\n", __FUNCTION__);
+	dprintk(dev, 1, "%s, state: %i\n", __FUNCTION__, buf->vb.state);
 
 	if (in_interrupt())
 		BUG();
 
-	videobuf_waiton(&buf->vb, 0, 0);
 	videobuf_vmalloc_free(&buf->vb);
+	dprintk(dev, 1, "free_buffer: freed");
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
 
@@ -741,28 +616,25 @@ buffer_prepare(struct videobuf_queue *vq
 	struct vivi_fh     *fh  = vq->priv_data;
 	struct vivi_dev    *dev = fh->dev;
 	struct vivi_buffer *buf = container_of(vb, struct vivi_buffer, vb);
-	int rc, init_buffer = 0;
+	int rc;
 
 	dprintk(dev, 1, "%s, field=%d\n", __FUNCTION__, field);
 
 	BUG_ON(NULL == fh->fmt);
+
 	if (fh->width  < 48 || fh->width  > norm_maxw() ||
 	    fh->height < 32 || fh->height > norm_maxh())
 		return -EINVAL;
+
 	buf->vb.size = fh->width*fh->height*2;
 	if (0 != buf->vb.baddr  &&  buf->vb.bsize < buf->vb.size)
 		return -EINVAL;
 
-	if (buf->fmt       != fh->fmt    ||
-	    buf->vb.width  != fh->width  ||
-	    buf->vb.height != fh->height ||
-	buf->vb.field  != field) {
-		buf->fmt       = fh->fmt;
-		buf->vb.width  = fh->width;
-		buf->vb.height = fh->height;
-		buf->vb.field  = field;
-		init_buffer = 1;
-	}
+	/* These properties only change when queue is idle, see s_fmt */
+	buf->fmt       = fh->fmt;
+	buf->vb.width  = fh->width;
+	buf->vb.height = fh->height;
+	buf->vb.field  = field;
 
 	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
 		rc = videobuf_iolock(vq, &buf->vb, NULL);
@@ -785,45 +657,12 @@ buffer_queue(struct videobuf_queue *vq, 
 	struct vivi_buffer    *buf  = container_of(vb, struct vivi_buffer, vb);
 	struct vivi_fh        *fh   = vq->priv_data;
 	struct vivi_dev       *dev  = fh->dev;
-	struct vivi_dmaqueue  *vidq = &dev->vidq;
-	struct vivi_buffer    *prev;
+	struct vivi_dmaqueue *vidq = &dev->vidq;
 
-	if (!list_empty(&vidq->queued)) {
-		dprintk(dev, 1, "adding vb queue=0x%08lx\n",
-			(unsigned long)&buf->vb.queue);
-		list_add_tail(&buf->vb.queue, &vidq->queued);
-		buf->vb.state = VIDEOBUF_QUEUED;
-		dprintk(dev, 2, "[%p/%d] buffer_queue - append to queued\n",
-			buf, buf->vb.i);
-	} else if (list_empty(&vidq->active)) {
-		list_add_tail(&buf->vb.queue, &vidq->active);
-
-		buf->vb.state = VIDEOBUF_ACTIVE;
-		mod_timer(&vidq->timeout, jiffies+BUFFER_TIMEOUT);
-		dprintk(dev, 2, "[%p/%d] buffer_queue - first active\n",
-			buf, buf->vb.i);
-
-		vivi_start_thread(vidq);
-	} else {
-		prev = list_entry(vidq->active.prev,
-				  struct vivi_buffer, vb.queue);
-		if (prev->vb.width  == buf->vb.width  &&
-		    prev->vb.height == buf->vb.height &&
-		    prev->fmt       == buf->fmt) {
-			list_add_tail(&buf->vb.queue, &vidq->active);
-			buf->vb.state = VIDEOBUF_ACTIVE;
-			dprintk(dev, 2,
-				"[%p/%d] buffer_queue - append to active\n",
-				buf, buf->vb.i);
-
-		} else {
-			list_add_tail(&buf->vb.queue, &vidq->queued);
-			buf->vb.state = VIDEOBUF_QUEUED;
-			dprintk(dev, 2,
-				"[%p/%d] buffer_queue - first queued\n",
-				buf, buf->vb.i);
-		}
-	}
+	dprintk(dev, 1, "%s\n", __FUNCTION__);
+
+	buf->vb.state = VIDEOBUF_QUEUED;
+	list_add_tail(&buf->vb.queue, &vidq->active);
 }
 
 static void buffer_release(struct videobuf_queue *vq,
@@ -832,12 +671,9 @@ static void buffer_release(struct videob
 	struct vivi_buffer   *buf  = container_of(vb, struct vivi_buffer, vb);
 	struct vivi_fh       *fh   = vq->priv_data;
 	struct vivi_dev      *dev  = (struct vivi_dev *)fh->dev;
-	struct vivi_dmaqueue *vidq = &dev->vidq;
 
 	dprintk(dev, 1, "%s\n", __FUNCTION__);
 
-	vivi_stop_thread(vidq);
-
 	free_buffer(vq, buf);
 }
 
@@ -943,17 +779,31 @@ static int vidioc_s_fmt_cap(struct file 
 					struct v4l2_format *f)
 {
 	struct vivi_fh  *fh = priv;
+	struct videobuf_queue *q = &fh->vb_vidq;
+
 	int ret = vidioc_try_fmt_cap(file, fh, f);
 	if (ret < 0)
 		return (ret);
 
+	mutex_lock(&q->vb_lock);
+
+	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
+		dprintk(fh->dev, 1, "%s queue busy\n", __FUNCTION__);
+		ret = -EBUSY;
+		goto out;
+	}
+
 	fh->fmt           = &format;
 	fh->width         = f->fmt.pix.width;
 	fh->height        = f->fmt.pix.height;
 	fh->vb_vidq.field = f->fmt.pix.field;
 	fh->type          = f->type;
 
-	return (0);
+	ret = 0;
+out:
+	mutex_unlock(&q->vb_lock);
+
+	return (ret);
 }
 
 static int vidioc_reqbufs(struct file *file, void *priv,
@@ -1158,6 +1008,8 @@ found:
 			NULL, &dev->slock, fh->type, V4L2_FIELD_INTERLACED,
 			sizeof(struct vivi_buffer), fh);
 
+	vivi_start_thread(fh);
+
 	return 0;
 }
 
@@ -1310,17 +1162,11 @@ static int __init vivi_init(void)
 
 		/* init video dma queues */
 		INIT_LIST_HEAD(&dev->vidq.active);
-		INIT_LIST_HEAD(&dev->vidq.queued);
 		init_waitqueue_head(&dev->vidq.wq);
 
 		/* initialize locks */
-		mutex_init(&dev->lock);
 		spin_lock_init(&dev->slock);
 
-		dev->vidq.timeout.function = vivi_vid_timeout;
-		dev->vidq.timeout.data     = (unsigned long)dev;
-		init_timer(&dev->vidq.timeout);
-
 		vfd = video_device_alloc();
 		if (NULL == vfd)
 			break;

-- 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
