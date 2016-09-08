Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43776 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941737AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 05/47] [media] dvb_ringbuffer.h: Document all functions
Date: Thu,  8 Sep 2016 09:03:27 -0300
Message-Id: <200e5d03af8f16d57daa3e218352834847872c67.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several functions there there weren't properly
documented. Add documentation for them.

While here, make checkpatch.pl happier.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_ringbuffer.h | 179 ++++++++++++++++++++++++--------
 1 file changed, 134 insertions(+), 45 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ringbuffer.h b/drivers/media/dvb-core/dvb_ringbuffer.h
index 8af642399f1e..8209eb4db2aa 100644
--- a/drivers/media/dvb-core/dvb_ringbuffer.h
+++ b/drivers/media/dvb-core/dvb_ringbuffer.h
@@ -18,10 +18,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #ifndef _DVB_RINGBUFFER_H_
@@ -30,6 +26,18 @@
 #include <linux/spinlock.h>
 #include <linux/wait.h>
 
+/**
+ * struct dvb_ringbuffer - Describes a ring buffer used at DVB framework
+ *
+ * @data: Area were the ringbuffer data is written
+ * @size: size of the ringbuffer
+ * @pread: next position to read
+ * @pwrite: next position to write
+ * @error: used by ringbuffer clients to indicate that an error happened.
+ * @queue: Wait queue used by ringbuffer clients to indicate when buffer
+ *         was filled
+ * @lock: Spinlock used to protect the ringbuffer
+ */
 struct dvb_ringbuffer {
 	u8               *data;
 	ssize_t           size;
@@ -43,7 +51,21 @@ struct dvb_ringbuffer {
 
 #define DVB_RINGBUFFER_PKTHDRSIZE 3
 
+/**
+ * dvb_ringbuffer_init - initialize ring buffer, lock and queue
+ *
+ * @rbuf: pointer to struct dvb_ringbuffer
+ * @data: pointer to the buffer where the data will be stored
+ * @len: bytes from ring buffer into @buf
+ */
+extern void dvb_ringbuffer_init(struct dvb_ringbuffer *rbuf, void *data,
+				size_t len);
 
+/**
+ * dvb_ringbuffer_empty - test whether buffer is empty
+ *
+ * @rbuf: pointer to struct dvb_ringbuffer
+ */
 /*
  * Notes:
  * ------
@@ -72,69 +94,133 @@ struct dvb_ringbuffer {
  *     Resetting the buffer counts as a read and write operation.
  *     Two or more writers must be locked against each other.
  */
-
-/* initialize ring buffer, lock and queue */
-extern void dvb_ringbuffer_init(struct dvb_ringbuffer *rbuf, void *data, size_t len);
-
-/* test whether buffer is empty */
 extern int dvb_ringbuffer_empty(struct dvb_ringbuffer *rbuf);
 
-/* return the number of free bytes in the buffer */
+/**
+ * dvb_ringbuffer_free - returns the number of free bytes in the buffer
+ *
+ * @rbuf: pointer to struct dvb_ringbuffer
+ *
+ * Return: number of free bytes in the buffer
+ */
 extern ssize_t dvb_ringbuffer_free(struct dvb_ringbuffer *rbuf);
 
-/* return the number of bytes waiting in the buffer */
+/**
+ * dvb_ringbuffer_avail - returns the number of bytes waiting in the buffer
+ *
+ * @rbuf: pointer to struct dvb_ringbuffer
+ *
+ * Return: number of bytes waiting in the buffer
+ */
 extern ssize_t dvb_ringbuffer_avail(struct dvb_ringbuffer *rbuf);
 
-
-/*
- * Reset the read and write pointers to zero and flush the buffer
+/**
+ * dvb_ringbuffer_reset - resets the ringbuffer to initial state
+ *
+ * @rbuf: pointer to struct dvb_ringbuffer
+ *
+ * Resets the read and write pointers to zero and flush the buffer.
+ *
  * This counts as a read and write operation
  */
 extern void dvb_ringbuffer_reset(struct dvb_ringbuffer *rbuf);
 
 
-/* read routines & macros */
-/* ---------------------- */
-/* flush buffer */
+/*
+ * read routines & macros
+ */
+
+/**
+ * dvb_ringbuffer_flush - flush buffer
+ *
+ * @rbuf: pointer to struct dvb_ringbuffer
+ */
 extern void dvb_ringbuffer_flush(struct dvb_ringbuffer *rbuf);
 
-/* flush buffer protected by spinlock and wake-up waiting task(s) */
+/**
+ * dvb_ringbuffer_flush_spinlock_wakeup- flush buffer protected by spinlock
+ *      and wake-up waiting task(s)
+ *
+ * @rbuf: pointer to struct dvb_ringbuffer
+ */
 extern void dvb_ringbuffer_flush_spinlock_wakeup(struct dvb_ringbuffer *rbuf);
 
-/* peek at byte @offs: in the buffer */
-#define DVB_RINGBUFFER_PEEK(rbuf,offs)	\
-			(rbuf)->data[((rbuf)->pread+(offs))%(rbuf)->size]
+/* DVB_RINGBUFFER_PEEK - peek at byte @offs: in the buffer */
+#define DVB_RINGBUFFER_PEEK(rbuf, offs)	\
+			(rbuf)->data[((rbuf)->pread + (offs)) % (rbuf)->size]
 
 /* advance read ptr by @num: bytes */
-#define DVB_RINGBUFFER_SKIP(rbuf,num)	\
-			(rbuf)->pread=((rbuf)->pread+(num))%(rbuf)->size
+#define DVB_RINGBUFFER_SKIP(rbuf, num)	{\
+			(rbuf)->pread = ((rbuf)->pread + (num)) % (rbuf)->size;\
+}
 
-/*
- * read @len: bytes from ring buffer into @buf:
- * @usermem: specifies whether @buf: resides in user space
- * returns number of bytes transferred or -EFAULT
+/**
+ * dvb_ringbuffer_read_user - Reads a buffer into an user pointer
+ *
+ * @rbuf: pointer to struct dvb_ringbuffer
+ * @buf: pointer to the buffer where the data will be stored
+ * @len: bytes from ring buffer into @buf
+ *
+ * This variant assumes that the buffer is a memory at the userspace. So,
+ * it will internally call copy_to_user().
+ *
+ * Return: number of bytes transferred or -EFAULT
  */
 extern ssize_t dvb_ringbuffer_read_user(struct dvb_ringbuffer *rbuf,
 				   u8 __user *buf, size_t len);
+
+/**
+ * dvb_ringbuffer_read - Reads a buffer into a pointer
+ *
+ * @rbuf: pointer to struct dvb_ringbuffer
+ * @buf: pointer to the buffer where the data will be stored
+ * @len: bytes from ring buffer into @buf
+ *
+ * This variant assumes that the buffer is a memory at the Kernel space
+ *
+ * Return: number of bytes transferred or -EFAULT
+ */
 extern void dvb_ringbuffer_read(struct dvb_ringbuffer *rbuf,
 				   u8 *buf, size_t len);
 
 
-/* write routines & macros */
-/* ----------------------- */
+/*
+ * write routines & macros
+ */
+
 /* write single byte to ring buffer */
-#define DVB_RINGBUFFER_WRITE_BYTE(rbuf,byte)	\
-			{ (rbuf)->data[(rbuf)->pwrite]=(byte); \
-			(rbuf)->pwrite=((rbuf)->pwrite+1)%(rbuf)->size; }
-/*
- * write @len: bytes to ring buffer
- * @usermem: specifies whether @buf: resides in user space
- * returns number of bytes transferred or -EFAULT
-*/
+#define DVB_RINGBUFFER_WRITE_BYTE(rbuf, byte)	\
+			{ (rbuf)->data[(rbuf)->pwrite] = (byte); \
+			(rbuf)->pwrite = ((rbuf)->pwrite + 1) % (rbuf)->size; }
+
+/**
+ * dvb_ringbuffer_write - Writes a buffer into the ringbuffer
+ *
+ * @rbuf: pointer to struct dvb_ringbuffer
+ * @buf: pointer to the buffer where the data will be read
+ * @len: bytes from ring buffer into @buf
+ *
+ * This variant assumes that the buffer is a memory at the Kernel space
+ *
+ * return: number of bytes transferred or -EFAULT
+ */
 extern ssize_t dvb_ringbuffer_write(struct dvb_ringbuffer *rbuf, const u8 *buf,
 				    size_t len);
+
+/**
+ * dvb_ringbuffer_writeuser - Writes a buffer received via an user pointer
+ *
+ * @rbuf: pointer to struct dvb_ringbuffer
+ * @buf: pointer to the buffer where the data will be read
+ * @len: bytes from ring buffer into @buf
+ *
+ * This variant assumes that the buffer is a memory at the userspace. So,
+ * it will internally call copy_from_user().
+ *
+ * Return: number of bytes transferred or -EFAULT
+ */
 extern ssize_t dvb_ringbuffer_write_user(struct dvb_ringbuffer *rbuf,
-				         const u8 __user *buf, size_t len);
+					 const u8 __user *buf, size_t len);
 
 
 /**
@@ -143,9 +229,10 @@ extern ssize_t dvb_ringbuffer_write_user(struct dvb_ringbuffer *rbuf,
  * @rbuf: Ringbuffer to write to.
  * @buf: Buffer to write.
  * @len: Length of buffer (currently limited to 65535 bytes max).
- * returns Number of bytes written, or -EFAULT, -ENOMEM, -EVINAL.
+ *
+ * Return: Number of bytes written, or -EFAULT, -ENOMEM, -EVINAL.
  */
-extern ssize_t dvb_ringbuffer_pkt_write(struct dvb_ringbuffer *rbuf, u8* buf,
+extern ssize_t dvb_ringbuffer_pkt_write(struct dvb_ringbuffer *rbuf, u8 *buf,
 					size_t len);
 
 /**
@@ -157,7 +244,7 @@ extern ssize_t dvb_ringbuffer_pkt_write(struct dvb_ringbuffer *rbuf, u8* buf,
  * @buf: Destination buffer for data.
  * @len: Size of destination buffer.
  *
- * returns Number of bytes read, or -EFAULT.
+ * Return: Number of bytes read, or -EFAULT.
  *
  * .. note::
  *
@@ -167,7 +254,7 @@ extern ssize_t dvb_ringbuffer_pkt_write(struct dvb_ringbuffer *rbuf, u8* buf,
  */
 extern ssize_t dvb_ringbuffer_pkt_read_user(struct dvb_ringbuffer *rbuf,
 					    size_t idx,
-				            int offset, u8 __user *buf,
+					    int offset, u8 __user *buf,
 					    size_t len);
 
 /**
@@ -181,7 +268,7 @@ extern ssize_t dvb_ringbuffer_pkt_read_user(struct dvb_ringbuffer *rbuf,
  * @buf: Destination buffer for data.
  * @len: Size of destination buffer.
  *
- * returns Number of bytes read, or -EFAULT.
+ * Return: Number of bytes read, or -EFAULT.
  */
 extern ssize_t dvb_ringbuffer_pkt_read(struct dvb_ringbuffer *rbuf, size_t idx,
 				       int offset, u8 *buf, size_t len);
@@ -199,10 +286,12 @@ extern void dvb_ringbuffer_pkt_dispose(struct dvb_ringbuffer *rbuf, size_t idx);
  *
  * @rbuf: Ringbuffer concerned.
  * @idx: Previous packet index, or -1 to return the first packet index.
- * @pktlen: On success, will be updated to contain the length of the packet in bytes.
+ * @pktlen: On success, will be updated to contain the length of the packet
+ *          in bytes.
  * returns Packet index (if >=0), or -1 if no packets available.
  */
-extern ssize_t dvb_ringbuffer_pkt_next(struct dvb_ringbuffer *rbuf, size_t idx, size_t* pktlen);
+extern ssize_t dvb_ringbuffer_pkt_next(struct dvb_ringbuffer *rbuf,
+				       size_t idx, size_t *pktlen);
 
 
 #endif /* _DVB_RINGBUFFER_H_ */
-- 
2.7.4


