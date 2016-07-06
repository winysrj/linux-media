Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46763 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbcGFJnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 05:43:55 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 02/15] [media] lirc_dev: allow bufferless driver registration
Date: Wed, 06 Jul 2016 18:01:14 +0900
Message-id: <1467795687-10737-3-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
References: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Transmitters don't necessarily need to have a FIFO managed buffer
for their transfers.

When registering the driver, before allocating the buffer, check
whether the device is a transmitter or receiver. Allocate the
buffer only for receivers.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 5716978..154e553 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -205,12 +205,14 @@ err_out:
 
 static int lirc_allocate_buffer(struct irctl *ir)
 {
-	int err;
+	int err = 0;
 	int bytes_in_key;
 	unsigned int chunk_size;
 	unsigned int buffer_size;
 	struct lirc_driver *d = &ir->d;
 
+	mutex_lock(&lirc_dev_lock);
+
 	bytes_in_key = BITS_TO_LONGS(d->code_length) +
 						(d->code_length % 8 ? 1 : 0);
 	buffer_size = d->buffer_size ? d->buffer_size : BUFLEN / bytes_in_key;
@@ -220,21 +222,26 @@ static int lirc_allocate_buffer(struct irctl *ir)
 		ir->buf = d->rbuf;
 	} else {
 		ir->buf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-		if (!ir->buf)
-			return -ENOMEM;
+		if (!ir->buf) {
+			err = -ENOMEM;
+			goto out;
+		}
 
 		err = lirc_buffer_init(ir->buf, chunk_size, buffer_size);
 		if (err) {
 			kfree(ir->buf);
-			return err;
+			goto out;
 		}
 	}
 	ir->chunk_size = ir->buf->chunk_size;
 
-	return 0;
+out:
+	mutex_unlock(&lirc_dev_lock);
+
+	return err;
 }
 
-int lirc_register_driver(struct lirc_driver *d)
+static int lirc_allocate_driver(struct lirc_driver *d)
 {
 	struct irctl *ir;
 	int minor;
@@ -342,10 +349,6 @@ int lirc_register_driver(struct lirc_driver *d)
 	/* some safety check 8-) */
 	d->name[sizeof(d->name)-1] = '\0';
 
-	err = lirc_allocate_buffer(ir);
-	if (err)
-		goto out_lock;
-
 	if (d->features == 0)
 		d->features = LIRC_CAN_REC_LIRCCODE;
 
@@ -385,6 +388,23 @@ out_lock:
 out:
 	return err;
 }
+
+int lirc_register_driver(struct lirc_driver *d)
+{
+	int minor, err = 0;
+
+	minor = lirc_allocate_driver(d);
+	if (minor < 0)
+		return minor;
+
+	if (LIRC_CAN_REC(d->features)) {
+		err = lirc_allocate_buffer(irctls[minor]);
+		if (err)
+			lirc_unregister_driver(minor);
+	}
+
+	return err ? err : minor;
+}
 EXPORT_SYMBOL(lirc_register_driver);
 
 int lirc_unregister_driver(int minor)
-- 
2.8.1

