Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40425 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbbHVR2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:37 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 19/39] [media] DocBook: add dvb_ringbuffer.h to documentation
Date: Sat, 22 Aug 2015 14:28:04 -0300
Message-Id: <6850525e4406648e6475ec444b955d1fef784093.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are already some comments at dvb_ringbuffer.h that are ready
for DocBook, although not properly formatted.

Convert them, fix some issues and add this file to
the device-drivers DocBook.

While here, put multi-line comments on the right format.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 21fc7684d706..030b3803cc68 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -230,6 +230,7 @@ X!Isound/sound_firmware.c
 !Idrivers/media/dvb-core/dvb_ca_en50221.h
 !Idrivers/media/dvb-core/dvb_frontend.h
 !Idrivers/media/dvb-core/dvb_math.h
+!Idrivers/media/dvb-core/dvb_ringbuffer.h
 <!-- FIXME: Removed for now due to document generation inconsistency
 X!Iinclude/media/v4l2-ctrls.h
 X!Iinclude/media/v4l2-dv-timings.h
@@ -241,7 +242,6 @@ X!Iinclude/media/lirc.h
 X!Edrivers/media/dvb-core/dvb_demux.c
 X!Idrivers/media/dvb-core/dvbdev.h
 X!Edrivers/media/dvb-core/dvb_net.c
-X!Idrivers/media/dvb-core/dvb_ringbuffer.h
 -->
 
   </chapter>
diff --git a/drivers/media/dvb-core/dvb_ringbuffer.h b/drivers/media/dvb-core/dvb_ringbuffer.h
index 9e1e11b7c39c..3ebc2d34b4a2 100644
--- a/drivers/media/dvb-core/dvb_ringbuffer.h
+++ b/drivers/media/dvb-core/dvb_ringbuffer.h
@@ -45,33 +45,33 @@ struct dvb_ringbuffer {
 
 
 /*
-** Notes:
-** ------
-** (1) For performance reasons read and write routines don't check buffer sizes
-**     and/or number of bytes free/available. This has to be done before these
-**     routines are called. For example:
-**
-**     *** write <buflen> bytes ***
-**     free = dvb_ringbuffer_free(rbuf);
-**     if (free >= buflen)
-**         count = dvb_ringbuffer_write(rbuf, buffer, buflen);
-**     else
-**         ...
-**
-**     *** read min. 1000, max. <bufsize> bytes ***
-**     avail = dvb_ringbuffer_avail(rbuf);
-**     if (avail >= 1000)
-**         count = dvb_ringbuffer_read(rbuf, buffer, min(avail, bufsize));
-**     else
-**         ...
-**
-** (2) If there is exactly one reader and one writer, there is no need
-**     to lock read or write operations.
-**     Two or more readers must be locked against each other.
-**     Flushing the buffer counts as a read operation.
-**     Resetting the buffer counts as a read and write operation.
-**     Two or more writers must be locked against each other.
-*/
+ * Notes:
+ * ------
+ * (1) For performance reasons read and write routines don't check buffer sizes
+ *     and/or number of bytes free/available. This has to be done before these
+ *     routines are called. For example:
+ *
+ *     *** write @buflen: bytes ***
+ *     free = dvb_ringbuffer_free(rbuf);
+ *     if (free >= buflen)
+ *         count = dvb_ringbuffer_write(rbuf, buffer, buflen);
+ *     else
+ *         ...
+ *
+ *     *** read min. 1000, max. @bufsize: bytes ***
+ *     avail = dvb_ringbuffer_avail(rbuf);
+ *     if (avail >= 1000)
+ *         count = dvb_ringbuffer_read(rbuf, buffer, min(avail, bufsize));
+ *     else
+ *         ...
+ *
+ * (2) If there is exactly one reader and one writer, there is no need
+ *     to lock read or write operations.
+ *     Two or more readers must be locked against each other.
+ *     Flushing the buffer counts as a read operation.
+ *     Resetting the buffer counts as a read and write operation.
+ *     Two or more writers must be locked against each other.
+ */
 
 /* initialize ring buffer, lock and queue */
 extern void dvb_ringbuffer_init(struct dvb_ringbuffer *rbuf, void *data, size_t len);
@@ -87,9 +87,9 @@ extern ssize_t dvb_ringbuffer_avail(struct dvb_ringbuffer *rbuf);
 
 
 /*
-** Reset the read and write pointers to zero and flush the buffer
-** This counts as a read and write operation
-*/
+ * Reset the read and write pointers to zero and flush the buffer
+ * This counts as a read and write operation
+ */
 extern void dvb_ringbuffer_reset(struct dvb_ringbuffer *rbuf);
 
 
@@ -101,19 +101,19 @@ extern void dvb_ringbuffer_flush(struct dvb_ringbuffer *rbuf);
 /* flush buffer protected by spinlock and wake-up waiting task(s) */
 extern void dvb_ringbuffer_flush_spinlock_wakeup(struct dvb_ringbuffer *rbuf);
 
-/* peek at byte <offs> in the buffer */
+/* peek at byte @offs: in the buffer */
 #define DVB_RINGBUFFER_PEEK(rbuf,offs)	\
 			(rbuf)->data[((rbuf)->pread+(offs))%(rbuf)->size]
 
-/* advance read ptr by <num> bytes */
+/* advance read ptr by @num: bytes */
 #define DVB_RINGBUFFER_SKIP(rbuf,num)	\
 			(rbuf)->pread=((rbuf)->pread+(num))%(rbuf)->size
 
 /*
-** read <len> bytes from ring buffer into <buf>
-** <usermem> specifies whether <buf> resides in user space
-** returns number of bytes transferred or -EFAULT
-*/
+ * read @len: bytes from ring buffer into @buf:
+ * @usermem: specifies whether @buf: resides in user space
+ * returns number of bytes transferred or -EFAULT
+ */
 extern ssize_t dvb_ringbuffer_read_user(struct dvb_ringbuffer *rbuf,
 				   u8 __user *buf, size_t len);
 extern void dvb_ringbuffer_read(struct dvb_ringbuffer *rbuf,
@@ -127,9 +127,9 @@ extern void dvb_ringbuffer_read(struct dvb_ringbuffer *rbuf,
 			{ (rbuf)->data[(rbuf)->pwrite]=(byte); \
 			(rbuf)->pwrite=((rbuf)->pwrite+1)%(rbuf)->size; }
 /*
-** write <len> bytes to ring buffer
-** <usermem> specifies whether <buf> resides in user space
-** returns number of bytes transferred or -EFAULT
+ * write @len: bytes to ring buffer
+ * @usermem: specifies whether @buf: resides in user space
+ * returns number of bytes transferred or -EFAULT
 */
 extern ssize_t dvb_ringbuffer_write(struct dvb_ringbuffer *rbuf, const u8 *buf,
 				    size_t len);
@@ -138,48 +138,63 @@ extern ssize_t dvb_ringbuffer_write_user(struct dvb_ringbuffer *rbuf,
 
 
 /**
- * Write a packet into the ringbuffer.
+ * dvb_ringbuffer_pkt_write - Write a packet into the ringbuffer.
  *
- * <rbuf> Ringbuffer to write to.
- * <buf> Buffer to write.
- * <len> Length of buffer (currently limited to 65535 bytes max).
+ * @rbuf: Ringbuffer to write to.
+ * @buf: Buffer to write.
+ * @len: Length of buffer (currently limited to 65535 bytes max).
  * returns Number of bytes written, or -EFAULT, -ENOMEM, -EVINAL.
  */
 extern ssize_t dvb_ringbuffer_pkt_write(struct dvb_ringbuffer *rbuf, u8* buf,
 					size_t len);
 
 /**
- * Read from a packet in the ringbuffer. Note: unlike dvb_ringbuffer_read(), this
- * does NOT update the read pointer in the ringbuffer. You must use
- * dvb_ringbuffer_pkt_dispose() to mark a packet as no longer required.
+ * dvb_ringbuffer_pkt_read_user - Read from a packet in the ringbuffer.
+ * Note: unlike dvb_ringbuffer_read(), this does NOT update the read pointer
+ * in the ringbuffer. You must use dvb_ringbuffer_pkt_dispose() to mark a
+ * packet as no longer required.
+ *
+ * @rbuf: Ringbuffer concerned.
+ * @idx: Packet index as returned by dvb_ringbuffer_pkt_next().
+ * @offset: Offset into packet to read from.
+ * @buf: Destination buffer for data.
+ * @len: Size of destination buffer.
  *
- * <rbuf> Ringbuffer concerned.
- * <idx> Packet index as returned by dvb_ringbuffer_pkt_next().
- * <offset> Offset into packet to read from.
- * <buf> Destination buffer for data.
- * <len> Size of destination buffer.
- * <usermem> Set to 1 if <buf> is in userspace.
  * returns Number of bytes read, or -EFAULT.
  */
 extern ssize_t dvb_ringbuffer_pkt_read_user(struct dvb_ringbuffer *rbuf, size_t idx,
 				       int offset, u8 __user *buf, size_t len);
+
+/**
+ * dvb_ringbuffer_pkt_read - Read from a packet in the ringbuffer.
+ * Note: unlike dvb_ringbuffer_read_user(), this DOES update the read pointer
+ * in the ringbuffer.
+ *
+ * @rbuf: Ringbuffer concerned.
+ * @idx: Packet index as returned by dvb_ringbuffer_pkt_next().
+ * @offset: Offset into packet to read from.
+ * @buf: Destination buffer for data.
+ * @len: Size of destination buffer.
+ *
+ * returns Number of bytes read, or -EFAULT.
+ */
 extern ssize_t dvb_ringbuffer_pkt_read(struct dvb_ringbuffer *rbuf, size_t idx,
 				       int offset, u8 *buf, size_t len);
 
 /**
- * Dispose of a packet in the ring buffer.
+ * dvb_ringbuffer_pkt_dispose - Dispose of a packet in the ring buffer.
  *
- * <rbuf> Ring buffer concerned.
- * <idx> Packet index as returned by dvb_ringbuffer_pkt_next().
+ * @rbuf: Ring buffer concerned.
+ * @idx: Packet index as returned by dvb_ringbuffer_pkt_next().
  */
 extern void dvb_ringbuffer_pkt_dispose(struct dvb_ringbuffer *rbuf, size_t idx);
 
 /**
- * Get the index of the next packet in a ringbuffer.
+ * dvb_ringbuffer_pkt_next - Get the index of the next packet in a ringbuffer.
  *
- * <rbuf> Ringbuffer concerned.
- * <idx> Previous packet index, or -1 to return the first packet index.
- * <pktlen> On success, will be updated to contain the length of the packet in bytes.
+ * @rbuf: Ringbuffer concerned.
+ * @idx: Previous packet index, or -1 to return the first packet index.
+ * @pktlen: On success, will be updated to contain the length of the packet in bytes.
  * returns Packet index (if >=0), or -1 if no packets available.
  */
 extern ssize_t dvb_ringbuffer_pkt_next(struct dvb_ringbuffer *rbuf, size_t idx, size_t* pktlen);
-- 
2.4.3

