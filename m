Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46478 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935522AbaICXto (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 19:49:44 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH RFC] [media] ngene: properly handle __user ptr
Date: Wed,  3 Sep 2014 20:48:50 -0300
Message-Id: <81966812742f5acf92fd27c327734dceb5736aef.1409787991.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sparse is complaining about ngene's bad usage of a __user ptr:

>> drivers/media/pci/ngene/ngene-dvb.c:62:48: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/ngene/ngene-dvb.c:62:48:    expected unsigned char const [usertype] *buf
   drivers/media/pci/ngene/ngene-dvb.c:62:48:    got char const [noderef] <asn:1>*buf

As this is intercepting a .write() file ops, we can't just memcpy. We need to use
copy_from_user.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/dvb-core/dvb_ringbuffer.c b/drivers/media/dvb-core/dvb_ringbuffer.c
index a5712cd7c65f..1100e98a7b1d 100644
--- a/drivers/media/dvb-core/dvb_ringbuffer.c
+++ b/drivers/media/dvb-core/dvb_ringbuffer.c
@@ -166,6 +166,31 @@ ssize_t dvb_ringbuffer_write(struct dvb_ringbuffer *rbuf, const u8 *buf, size_t
 	return len;
 }
 
+ssize_t dvb_ringbuffer_write_user(struct dvb_ringbuffer *rbuf,
+				  const u8 __user *buf, size_t len)
+{
+	int status;
+	size_t todo = len;
+	size_t split;
+
+	split = (rbuf->pwrite + len > rbuf->size) ? rbuf->size - rbuf->pwrite : 0;
+
+	if (split > 0) {
+		status = copy_from_user(rbuf->data+rbuf->pwrite, buf, split);
+		if (status)
+			return len - todo;
+		buf += split;
+		todo -= split;
+		rbuf->pwrite = 0;
+	}
+	status = copy_from_user(rbuf->data+rbuf->pwrite, buf, todo);
+	if (status)
+		return len - todo;
+	rbuf->pwrite = (rbuf->pwrite + todo) % rbuf->size;
+
+	return len;
+}
+
 ssize_t dvb_ringbuffer_pkt_write(struct dvb_ringbuffer *rbuf, u8* buf, size_t len)
 {
 	int status;
@@ -297,3 +322,4 @@ EXPORT_SYMBOL(dvb_ringbuffer_flush_spinlock_wakeup);
 EXPORT_SYMBOL(dvb_ringbuffer_read_user);
 EXPORT_SYMBOL(dvb_ringbuffer_read);
 EXPORT_SYMBOL(dvb_ringbuffer_write);
+EXPORT_SYMBOL(dvb_ringbuffer_write_user);
diff --git a/drivers/media/dvb-core/dvb_ringbuffer.h b/drivers/media/dvb-core/dvb_ringbuffer.h
index 41f04dae69b6..9e1e11b7c39c 100644
--- a/drivers/media/dvb-core/dvb_ringbuffer.h
+++ b/drivers/media/dvb-core/dvb_ringbuffer.h
@@ -133,6 +133,8 @@ extern void dvb_ringbuffer_read(struct dvb_ringbuffer *rbuf,
 */
 extern ssize_t dvb_ringbuffer_write(struct dvb_ringbuffer *rbuf, const u8 *buf,
 				    size_t len);
+extern ssize_t dvb_ringbuffer_write_user(struct dvb_ringbuffer *rbuf,
+				         const u8 __user *buf, size_t len);
 
 
 /**
diff --git a/drivers/media/pci/ngene/ngene-dvb.c b/drivers/media/pci/ngene/ngene-dvb.c
index a8a4045f66d7..59bb2858c8d0 100644
--- a/drivers/media/pci/ngene/ngene-dvb.c
+++ b/drivers/media/pci/ngene/ngene-dvb.c
@@ -59,7 +59,7 @@ static ssize_t ts_write(struct file *file, const char __user *buf,
 				     (&dev->tsout_rbuf) >= count) < 0)
 		return 0;
 
-	dvb_ringbuffer_write(&dev->tsout_rbuf, buf, count);
+	dvb_ringbuffer_write_user(&dev->tsout_rbuf, buf, count);
 
 	return count;
 }
-- 
1.9.3

