Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:65285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab0J0TuF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 15:50:05 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9RJo5xZ028850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 27 Oct 2010 15:50:05 -0400
Date: Wed, 27 Oct 2010 15:50:04 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Subject: [PATCH] new_build/v2.6.32: build lirc_dev, ir-lirc-codec, mceusb,
 imon
Message-ID: <20101027195004.GE13824@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With some minor kfifo-related changes, lirc_dev ir-lirc-codec can be built
on a 2.6.32-based kernel (Red Hat Enterprise Linux 6). The mceusb and imon
drivers build fine without any changes, modulo a warning about pr_fmt
being redefined in the imon driver.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 backports/v2.6.32/kfifo.patch |  105 +++++++++++++++++++++++++++++++++++++++++
 v4l/versions.txt              |    4 --
 2 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/backports/v2.6.32/kfifo.patch b/backports/v2.6.32/kfifo.patch
index a612f1b..df97d07 100644
--- a/backports/v2.6.32/kfifo.patch
+++ b/backports/v2.6.32/kfifo.patch
@@ -426,3 +426,108 @@ diff -r 5254948f88c4 drivers/media/video/meye.h
  	spinlock_t doneq_lock;		/* lock protecting the queue */
  	wait_queue_head_t proc_list;	/* wait queue */
  	struct video_device *vdev;	/* video device parameters */
+diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
+index 54780a5..87b2ca6 100644
+--- a/include/media/lirc_dev.h
++++ b/include/media/lirc_dev.h
+@@ -28,19 +28,15 @@ struct lirc_buffer {
+ 	unsigned int size; /* in chunks */
+ 	/* Using chunks instead of bytes pretends to simplify boundary checking
+ 	 * And should allow for some performance fine tunning later */
+-	struct kfifo fifo;
++	struct kfifo *fifo;
+ 	u8 fifo_initialized;
+ };
+ 
+ static inline void lirc_buffer_clear(struct lirc_buffer *buf)
+ {
+-	unsigned long flags;
+-
+-	if (buf->fifo_initialized) {
+-		spin_lock_irqsave(&buf->fifo_lock, flags);
+-		kfifo_reset(&buf->fifo);
+-		spin_unlock_irqrestore(&buf->fifo_lock, flags);
+-	} else
++	if (buf->fifo)
++		kfifo_reset(buf->fifo);
++	else
+ 		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
+ 		     __func__);
+ }
+@@ -49,25 +45,23 @@ static inline int lirc_buffer_init(struct lirc_buffer *buf,
+ 				    unsigned int chunk_size,
+ 				    unsigned int size)
+ {
+-	int ret;
+-
+ 	init_waitqueue_head(&buf->wait_poll);
+ 	spin_lock_init(&buf->fifo_lock);
+ 	buf->chunk_size = chunk_size;
+ 	buf->size = size;
+-	ret = kfifo_alloc(&buf->fifo, size * chunk_size, GFP_KERNEL);
+-	if (ret == 0)
+-		buf->fifo_initialized = 1;
++	buf->fifo = kfifo_alloc(size * chunk_size, GFP_KERNEL,
++				&buf->fifo_lock);
++	if (!buf->fifo)
++		return -ENOMEM;
+ 
+-	return ret;
++	return 0;
+ }
+ 
+ static inline void lirc_buffer_free(struct lirc_buffer *buf)
+ {
+-	if (buf->fifo_initialized) {
+-		kfifo_free(&buf->fifo);
+-		buf->fifo_initialized = 0;
+-	} else
++	if (buf->fifo)
++		kfifo_free(buf->fifo);
++	else
+ 		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
+ 		     __func__);
+ }
+@@ -75,11 +69,8 @@ static inline void lirc_buffer_free(struct lirc_buffer *buf)
+ static inline int lirc_buffer_len(struct lirc_buffer *buf)
+ {
+ 	int len;
+-	unsigned long flags;
+ 
+-	spin_lock_irqsave(&buf->fifo_lock, flags);
+-	len = kfifo_len(&buf->fifo);
+-	spin_unlock_irqrestore(&buf->fifo_lock, flags);
++	len = kfifo_len(buf->fifo);
+ 
+ 	return len;
+ }
+@@ -102,24 +93,19 @@ static inline int lirc_buffer_available(struct lirc_buffer *buf)
+ static inline unsigned int lirc_buffer_read(struct lirc_buffer *buf,
+ 					    unsigned char *dest)
+ {
+-	unsigned int ret = 0;
+-
+ 	if (lirc_buffer_len(buf) >= buf->chunk_size)
+-		ret = kfifo_out_locked(&buf->fifo, dest, buf->chunk_size,
+-				       &buf->fifo_lock);
+-	return ret;
++		kfifo_get(buf->fifo, dest, buf->chunk_size);
++
++	return 0;
+ 
+ }
+ 
+ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
+ 					     unsigned char *orig)
+ {
+-	unsigned int ret;
+-
+-	ret = kfifo_in_locked(&buf->fifo, orig, buf->chunk_size,
+-			      &buf->fifo_lock);
++	kfifo_put(buf->fifo, orig, buf->chunk_size);
+ 
+-	return ret;
++	return 0;
+ }
+ 
+ struct lirc_driver {
diff --git a/v4l/versions.txt b/v4l/versions.txt
index 46db158..6465418 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -6,10 +6,6 @@
 VIDEO_VIA_CAMERA
 
 [2.6.36]
-LIRC
-IR_LIRC_CODEC
-IR_IMON
-IR_MCEUSB
 
 [2.6.34]
 MACH_DAVINCI_DM6467_EVM

-- 
Jarod Wilson
jarod@redhat.com

