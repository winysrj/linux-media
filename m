Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43781 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941738AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 07/47] [media] dvb_ringbuffer.h: document the define macros
Date: Thu,  8 Sep 2016 09:03:29 -0300
Message-Id: <eb1db69a9b57034169bb0b441fe529cb959a6ac5.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a few define macros not documented, because the ReST
output was causing more warnings.

Now that this got fixed, document them. While here, fix the
remaining coding style issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_ringbuffer.h | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ringbuffer.h b/drivers/media/dvb-core/dvb_ringbuffer.h
index f64bd86fe5fd..eae3f091b6a0 100644
--- a/drivers/media/dvb-core/dvb_ringbuffer.h
+++ b/drivers/media/dvb-core/dvb_ringbuffer.h
@@ -97,7 +97,6 @@ extern ssize_t dvb_ringbuffer_avail(struct dvb_ringbuffer *rbuf);
  */
 extern void dvb_ringbuffer_reset(struct dvb_ringbuffer *rbuf);
 
-
 /*
  * read routines & macros
  */
@@ -117,11 +116,21 @@ extern void dvb_ringbuffer_flush(struct dvb_ringbuffer *rbuf);
  */
 extern void dvb_ringbuffer_flush_spinlock_wakeup(struct dvb_ringbuffer *rbuf);
 
-/* DVB_RINGBUFFER_PEEK - peek at byte @offs: in the buffer */
+/**
+ * DVB_RINGBUFFER_PEEK - peek at byte @offs in the buffer
+ *
+ * @rbuf: pointer to struct dvb_ringbuffer
+ * @offs: offset inside the ringbuffer
+ */
 #define DVB_RINGBUFFER_PEEK(rbuf, offs)	\
-			(rbuf)->data[((rbuf)->pread + (offs)) % (rbuf)->size]
+			((rbuf)->data[((rbuf)->pread + (offs)) % (rbuf)->size])
 
-/* advance read ptr by @num: bytes */
+/**
+ * DVB_RINGBUFFER_SKIP - advance read ptr by @num bytes
+ *
+ * @rbuf: pointer to struct dvb_ringbuffer
+ * @num: number of bytes to advance
+ */
 #define DVB_RINGBUFFER_SKIP(rbuf, num)	{\
 			(rbuf)->pread = ((rbuf)->pread + (num)) % (rbuf)->size;\
 }
@@ -155,12 +164,16 @@ extern ssize_t dvb_ringbuffer_read_user(struct dvb_ringbuffer *rbuf,
 extern void dvb_ringbuffer_read(struct dvb_ringbuffer *rbuf,
 				   u8 *buf, size_t len);
 
-
 /*
  * write routines & macros
  */
 
-/* write single byte to ring buffer */
+/**
+ * DVB_RINGBUFFER_WRITE_BYTE - write single byte to ring buffer
+ *
+ * @rbuf: pointer to struct dvb_ringbuffer
+ * @byte: byte to write
+ */
 #define DVB_RINGBUFFER_WRITE_BYTE(rbuf, byte)	\
 			{ (rbuf)->data[(rbuf)->pwrite] = (byte); \
 			(rbuf)->pwrite = ((rbuf)->pwrite + 1) % (rbuf)->size; }
@@ -194,7 +207,6 @@ extern ssize_t dvb_ringbuffer_write(struct dvb_ringbuffer *rbuf, const u8 *buf,
 extern ssize_t dvb_ringbuffer_write_user(struct dvb_ringbuffer *rbuf,
 					 const u8 __user *buf, size_t len);
 
-
 /**
  * dvb_ringbuffer_pkt_write - Write a packet into the ringbuffer.
  *
@@ -265,5 +277,4 @@ extern void dvb_ringbuffer_pkt_dispose(struct dvb_ringbuffer *rbuf, size_t idx);
 extern ssize_t dvb_ringbuffer_pkt_next(struct dvb_ringbuffer *rbuf,
 				       size_t idx, size_t *pktlen);
 
-
 #endif /* _DVB_RINGBUFFER_H_ */
-- 
2.7.4


