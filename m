Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:50310 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbcGAIE1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 04:04:27 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v2 01/15] [media] lirc_dev: place buffer allocation on separate
 function
Date: Fri, 01 Jul 2016 17:01:24 +0900
Message-id: <1467360098-12539-2-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
References: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the driver registration, move the buffer allocation on a
separate function.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 57 +++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 92ae190..5716978 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -203,13 +203,41 @@ err_out:
 	return retval;
 }
 
-int lirc_register_driver(struct lirc_driver *d)
+static int lirc_allocate_buffer(struct irctl *ir)
 {
-	struct irctl *ir;
-	int minor;
+	int err;
 	int bytes_in_key;
 	unsigned int chunk_size;
 	unsigned int buffer_size;
+	struct lirc_driver *d = &ir->d;
+
+	bytes_in_key = BITS_TO_LONGS(d->code_length) +
+						(d->code_length % 8 ? 1 : 0);
+	buffer_size = d->buffer_size ? d->buffer_size : BUFLEN / bytes_in_key;
+	chunk_size  = d->chunk_size  ? d->chunk_size  : bytes_in_key;
+
+	if (d->rbuf) {
+		ir->buf = d->rbuf;
+	} else {
+		ir->buf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
+		if (!ir->buf)
+			return -ENOMEM;
+
+		err = lirc_buffer_init(ir->buf, chunk_size, buffer_size);
+		if (err) {
+			kfree(ir->buf);
+			return err;
+		}
+	}
+	ir->chunk_size = ir->buf->chunk_size;
+
+	return 0;
+}
+
+int lirc_register_driver(struct lirc_driver *d)
+{
+	struct irctl *ir;
+	int minor;
 	int err;
 
 	if (!d) {
@@ -314,26 +342,9 @@ int lirc_register_driver(struct lirc_driver *d)
 	/* some safety check 8-) */
 	d->name[sizeof(d->name)-1] = '\0';
 
-	bytes_in_key = BITS_TO_LONGS(d->code_length) +
-			(d->code_length % 8 ? 1 : 0);
-	buffer_size = d->buffer_size ? d->buffer_size : BUFLEN / bytes_in_key;
-	chunk_size  = d->chunk_size  ? d->chunk_size  : bytes_in_key;
-
-	if (d->rbuf) {
-		ir->buf = d->rbuf;
-	} else {
-		ir->buf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-		if (!ir->buf) {
-			err = -ENOMEM;
-			goto out_lock;
-		}
-		err = lirc_buffer_init(ir->buf, chunk_size, buffer_size);
-		if (err) {
-			kfree(ir->buf);
-			goto out_lock;
-		}
-	}
-	ir->chunk_size = ir->buf->chunk_size;
+	err = lirc_allocate_buffer(ir);
+	if (err)
+		goto out_lock;
 
 	if (d->features == 0)
 		d->features = LIRC_CAN_REC_LIRCCODE;
-- 
2.8.1

