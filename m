Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39757 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbcGWD32 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 23:29:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/3] [media] dvb_ringbuffer.h: some documentation improvements
Date: Sat, 23 Jul 2016 00:29:21 -0300
Message-Id: <2c6ae2f4f4e1fe673302a84c9766166958d20adb.1469244556.git.mchehab@s-opensource.com>
In-Reply-To: <fd20fc5ae65d3cd338b9925f633b2b962546b73f.1469244556.git.mchehab@s-opensource.com>
References: <fd20fc5ae65d3cd338b9925f633b2b962546b73f.1469244556.git.mchehab@s-opensource.com>
In-Reply-To: <fd20fc5ae65d3cd338b9925f633b2b962546b73f.1469244556.git.mchehab@s-opensource.com>
References: <fd20fc5ae65d3cd338b9925f633b2b962546b73f.1469244556.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Better document a note on this header.

While here, better format dvb_ringbuffer_pkt_read_user()
to adjust it to CodingStyle.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_ringbuffer.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ringbuffer.h b/drivers/media/dvb-core/dvb_ringbuffer.h
index 3ebc2d34b4a2..8af642399f1e 100644
--- a/drivers/media/dvb-core/dvb_ringbuffer.h
+++ b/drivers/media/dvb-core/dvb_ringbuffer.h
@@ -150,9 +150,6 @@ extern ssize_t dvb_ringbuffer_pkt_write(struct dvb_ringbuffer *rbuf, u8* buf,
 
 /**
  * dvb_ringbuffer_pkt_read_user - Read from a packet in the ringbuffer.
- * Note: unlike dvb_ringbuffer_read(), this does NOT update the read pointer
- * in the ringbuffer. You must use dvb_ringbuffer_pkt_dispose() to mark a
- * packet as no longer required.
  *
  * @rbuf: Ringbuffer concerned.
  * @idx: Packet index as returned by dvb_ringbuffer_pkt_next().
@@ -161,9 +158,17 @@ extern ssize_t dvb_ringbuffer_pkt_write(struct dvb_ringbuffer *rbuf, u8* buf,
  * @len: Size of destination buffer.
  *
  * returns Number of bytes read, or -EFAULT.
+ *
+ * .. note::
+ *
+ *    unlike dvb_ringbuffer_read(), this does **NOT** update the read pointer
+ *    in the ringbuffer. You must use dvb_ringbuffer_pkt_dispose() to mark a
+ *    packet as no longer required.
  */
-extern ssize_t dvb_ringbuffer_pkt_read_user(struct dvb_ringbuffer *rbuf, size_t idx,
-				       int offset, u8 __user *buf, size_t len);
+extern ssize_t dvb_ringbuffer_pkt_read_user(struct dvb_ringbuffer *rbuf,
+					    size_t idx,
+				            int offset, u8 __user *buf,
+					    size_t len);
 
 /**
  * dvb_ringbuffer_pkt_read - Read from a packet in the ringbuffer.
-- 
2.7.4

