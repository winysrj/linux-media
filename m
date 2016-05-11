Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:62964 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbcEKQtv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 12:49:51 -0400
From: Soeren Moch <smoch@web.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Soeren Moch <smoch@web.de>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: dvb_ringbuffer: Add memory barriers
Date: Wed, 11 May 2016 18:49:11 +0200
Message-Id: <1462985353-4437-1-git-send-email-smoch@web.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement memory barriers according to Documentation/circular-buffers.txt:
- use smp_store_release() to update ringbuffer read/write pointers
- use smp_load_acquire() to load write pointer on reader side
- use ACCESS_ONCE() to load read pointer on writer side

This fixes data stream corruptions observed e.g. on an ARM Cortex-A9
quad core system with different types (PCI, USB) of DVB tuners.

Signed-off-by: Soeren Moch <smoch@web.de>
Cc: stable@vger.kernel.org # 3.14+
---
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Since smp_store_release() and smp_load_acquire() were introduced in linux-3.14,
a 3.14+ stable tag was added. Is it desired to apply a similar patch to older
stable kernels?

changes in v2:
    - add comments for smp_store_release() and smp_load_acquire() calls
      to avoid checkpatch warnings
---
 drivers/media/dvb-core/dvb_ringbuffer.c | 74 +++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ringbuffer.c b/drivers/media/dvb-core/dvb_ringbuffer.c
index 1100e98..7df7fb3 100644
--- a/drivers/media/dvb-core/dvb_ringbuffer.c
+++ b/drivers/media/dvb-core/dvb_ringbuffer.c
@@ -55,7 +55,13 @@ void dvb_ringbuffer_init(struct dvb_ringbuffer *rbuf, void *data, size_t len)
 
 int dvb_ringbuffer_empty(struct dvb_ringbuffer *rbuf)
 {
-	return (rbuf->pread==rbuf->pwrite);
+	/* smp_load_acquire() to load write pointer on reader side
+	 * this pairs with smp_store_release() in dvb_ringbuffer_write(),
+	 * dvb_ringbuffer_write_user(), or dvb_ringbuffer_reset()
+	 *
+	 * for memory barriers also see Documentation/circular-buffers.txt
+	 */
+	return (rbuf->pread == smp_load_acquire(&rbuf->pwrite));
 }
 
 
@@ -64,7 +70,12 @@ ssize_t dvb_ringbuffer_free(struct dvb_ringbuffer *rbuf)
 {
 	ssize_t free;
 
-	free = rbuf->pread - rbuf->pwrite;
+	/* ACCESS_ONCE() to load read pointer on writer side
+	 * this pairs with smp_store_release() in dvb_ringbuffer_read(),
+	 * dvb_ringbuffer_read_user(), dvb_ringbuffer_flush(),
+	 * or dvb_ringbuffer_reset()
+	 */
+	free = ACCESS_ONCE(rbuf->pread) - rbuf->pwrite;
 	if (free <= 0)
 		free += rbuf->size;
 	return free-1;
@@ -76,7 +87,11 @@ ssize_t dvb_ringbuffer_avail(struct dvb_ringbuffer *rbuf)
 {
 	ssize_t avail;
 
-	avail = rbuf->pwrite - rbuf->pread;
+	/* smp_load_acquire() to load write pointer on reader side
+	 * this pairs with smp_store_release() in dvb_ringbuffer_write(),
+	 * dvb_ringbuffer_write_user(), or dvb_ringbuffer_reset()
+	 */
+	avail = smp_load_acquire(&rbuf->pwrite) - rbuf->pread;
 	if (avail < 0)
 		avail += rbuf->size;
 	return avail;
@@ -86,14 +101,25 @@ ssize_t dvb_ringbuffer_avail(struct dvb_ringbuffer *rbuf)
 
 void dvb_ringbuffer_flush(struct dvb_ringbuffer *rbuf)
 {
-	rbuf->pread = rbuf->pwrite;
+	/* dvb_ringbuffer_flush() counts as read operation
+	 * smp_load_acquire() to load write pointer
+	 * smp_store_release() to update read pointer, this ensures that the
+	 * correct pointer is visible for subsequent dvb_ringbuffer_free()
+	 * calls on other cpu cores
+	 */
+	smp_store_release(&rbuf->pread, smp_load_acquire(&rbuf->pwrite));
 	rbuf->error = 0;
 }
 EXPORT_SYMBOL(dvb_ringbuffer_flush);
 
 void dvb_ringbuffer_reset(struct dvb_ringbuffer *rbuf)
 {
-	rbuf->pread = rbuf->pwrite = 0;
+	/* dvb_ringbuffer_reset() counts as read and write operation
+	 * smp_store_release() to update read pointer
+	 */
+	smp_store_release(&rbuf->pread, 0);
+	/* smp_store_release() to update write pointer */
+	smp_store_release(&rbuf->pwrite, 0);
 	rbuf->error = 0;
 }
 
@@ -119,12 +145,17 @@ ssize_t dvb_ringbuffer_read_user(struct dvb_ringbuffer *rbuf, u8 __user *buf, si
 			return -EFAULT;
 		buf += split;
 		todo -= split;
-		rbuf->pread = 0;
+		/* smp_store_release() for read pointer update to ensure
+		 * that buf is not overwritten until read is complete,
+		 * this pairs with ACCESS_ONCE() in dvb_ringbuffer_free()
+		 */
+		smp_store_release(&rbuf->pread, 0);
 	}
 	if (copy_to_user(buf, rbuf->data+rbuf->pread, todo))
 		return -EFAULT;
 
-	rbuf->pread = (rbuf->pread + todo) % rbuf->size;
+	/* smp_store_release() to update read pointer, see above */
+	smp_store_release(&rbuf->pread, (rbuf->pread + todo) % rbuf->size);
 
 	return len;
 }
@@ -139,11 +170,16 @@ void dvb_ringbuffer_read(struct dvb_ringbuffer *rbuf, u8 *buf, size_t len)
 		memcpy(buf, rbuf->data+rbuf->pread, split);
 		buf += split;
 		todo -= split;
-		rbuf->pread = 0;
+		/* smp_store_release() for read pointer update to ensure
+		 * that buf is not overwritten until read is complete,
+		 * this pairs with ACCESS_ONCE() in dvb_ringbuffer_free()
+		 */
+		smp_store_release(&rbuf->pread, 0);
 	}
 	memcpy(buf, rbuf->data+rbuf->pread, todo);
 
-	rbuf->pread = (rbuf->pread + todo) % rbuf->size;
+	/* smp_store_release() to update read pointer, see above */
+	smp_store_release(&rbuf->pread, (rbuf->pread + todo) % rbuf->size);
 }
 
 
@@ -158,10 +194,16 @@ ssize_t dvb_ringbuffer_write(struct dvb_ringbuffer *rbuf, const u8 *buf, size_t
 		memcpy(rbuf->data+rbuf->pwrite, buf, split);
 		buf += split;
 		todo -= split;
-		rbuf->pwrite = 0;
+		/* smp_store_release() for write pointer update to ensure that
+		 * written data is visible on other cpu cores before the pointer
+		 * update, this pairs with smp_load_acquire() in
+		 * dvb_ringbuffer_empty() or dvb_ringbuffer_avail()
+		 */
+		smp_store_release(&rbuf->pwrite, 0);
 	}
 	memcpy(rbuf->data+rbuf->pwrite, buf, todo);
-	rbuf->pwrite = (rbuf->pwrite + todo) % rbuf->size;
+	/* smp_store_release() for write pointer update, see above */
+	smp_store_release(&rbuf->pwrite, (rbuf->pwrite + todo) % rbuf->size);
 
 	return len;
 }
@@ -181,12 +223,18 @@ ssize_t dvb_ringbuffer_write_user(struct dvb_ringbuffer *rbuf,
 			return len - todo;
 		buf += split;
 		todo -= split;
-		rbuf->pwrite = 0;
+		/* smp_store_release() for write pointer update to ensure that
+		 * written data is visible on other cpu cores before the pointer
+		 * update, this pairs with smp_load_acquire() in
+		 * dvb_ringbuffer_empty() or dvb_ringbuffer_avail()
+		 */
+		smp_store_release(&rbuf->pwrite, 0);
 	}
 	status = copy_from_user(rbuf->data+rbuf->pwrite, buf, todo);
 	if (status)
 		return len - todo;
-	rbuf->pwrite = (rbuf->pwrite + todo) % rbuf->size;
+	/* smp_store_release() for write pointer update, see above */
+	smp_store_release(&rbuf->pwrite, (rbuf->pwrite + todo) % rbuf->size);
 
 	return len;
 }
-- 
1.9.1

