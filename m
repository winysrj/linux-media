Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56418 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdFYMbr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:31:47 -0400
Subject: [PATCH 06/19] lirc_dev: make chunk_size and buffer_size mandatory
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:31:45 +0200
Message-ID: <149839390523.28811.16125400091891762736.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make setting chunk_size and buffer_size mandatory for drivers which
expect lirc_dev to allocate the lirc_buffer (i.e. ir-lirc-codec) and
don't set them in lirc-zilog (which creates its own buffer).

Also remove an unnecessary copy of chunk_size in struct irctl (the
same information is already available from struct lirc_buffer).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c             |   26 +++++++++++++-------------
 drivers/staging/media/lirc/lirc_zilog.c |    5 +----
 include/media/lirc_dev.h                |    9 +++++----
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 2de840dd829d..1773a2934484 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -41,7 +41,6 @@ struct irctl {
 	struct mutex irctl_lock;
 	struct lirc_buffer *buf;
 	bool buf_internal;
-	unsigned int chunk_size;
 
 	struct device dev;
 	struct cdev cdev;
@@ -72,16 +71,8 @@ static void lirc_release(struct device *ld)
 static int lirc_allocate_buffer(struct irctl *ir)
 {
 	int err = 0;
-	int bytes_in_key;
-	unsigned int chunk_size;
-	unsigned int buffer_size;
 	struct lirc_driver *d = &ir->d;
 
-	bytes_in_key = BITS_TO_LONGS(d->code_length) +
-						(d->code_length % 8 ? 1 : 0);
-	buffer_size = d->buffer_size ? d->buffer_size : BUFLEN / bytes_in_key;
-	chunk_size  = d->chunk_size  ? d->chunk_size  : bytes_in_key;
-
 	if (d->rbuf) {
 		ir->buf = d->rbuf;
 		ir->buf_internal = false;
@@ -92,7 +83,7 @@ static int lirc_allocate_buffer(struct irctl *ir)
 			goto out;
 		}
 
-		err = lirc_buffer_init(ir->buf, chunk_size, buffer_size);
+		err = lirc_buffer_init(ir->buf, d->chunk_size, d->buffer_size);
 		if (err) {
 			kfree(ir->buf);
 			ir->buf = NULL;
@@ -102,7 +93,6 @@ static int lirc_allocate_buffer(struct irctl *ir)
 		ir->buf_internal = true;
 		d->rbuf = ir->buf;
 	}
-	ir->chunk_size = ir->buf->chunk_size;
 
 out:
 	return err;
@@ -129,6 +119,16 @@ int lirc_register_driver(struct lirc_driver *d)
 		return -EINVAL;
 	}
 
+	if (!d->rbuf && d->chunk_size < 1) {
+		pr_err("chunk_size must be set!\n");
+		return -EINVAL;
+	}
+
+	if (!d->rbuf && d->buffer_size < 1) {
+		pr_err("buffer_size must be set!\n");
+		return -EINVAL;
+	}
+
 	if (d->code_length < 1 || d->code_length > (BUFLEN * 8)) {
 		dev_err(d->dev, "code length must be less than %d bits\n",
 								BUFLEN * 8);
@@ -385,7 +385,7 @@ ssize_t lirc_dev_fop_read(struct file *file,
 
 	dev_dbg(ir->d.dev, LOGHEAD "read called\n", ir->d.name, ir->d.minor);
 
-	buf = kzalloc(ir->chunk_size, GFP_KERNEL);
+	buf = kzalloc(ir->buf->chunk_size, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -398,7 +398,7 @@ ssize_t lirc_dev_fop_read(struct file *file,
 		goto out_locked;
 	}
 
-	if (length % ir->chunk_size) {
+	if (length % ir->buf->chunk_size) {
 		ret = -EINVAL;
 		goto out_locked;
 	}
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 6d4c5a957ab4..c6a2fe2ad210 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1348,8 +1348,6 @@ static const struct file_operations lirc_fops = {
 static struct lirc_driver lirc_template = {
 	.name		= "lirc_zilog",
 	.code_length	= 13,
-	.buffer_size	= BUFLEN / 2,
-	.chunk_size	= 2,
 	.fops		= &lirc_fops,
 	.owner		= THIS_MODULE,
 };
@@ -1456,8 +1454,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		ir->l.dev  = &adap->dev;
 		/* This will be returned by lirc_get_pdata() */
 		ir->l.data = ir;
-		ret = lirc_buffer_init(ir->l.rbuf,
-				       ir->l.chunk_size, ir->l.buffer_size);
+		ret = lirc_buffer_init(ir->l.rbuf, 2, BUFLEN / 2);
 		if (ret)
 			goto out_put_ir;
 	}
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 20c5c5d6f101..a01fe5433bb7 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -121,13 +121,14 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
  *
  * @code_length:	length of the remote control key code expressed in bits.
  *
- * @buffer_size:	Number of FIFO buffers with @chunk_size size. If zero,
- *			creates a buffer with BUFLEN size (16 bytes).
- *
  * @features:		lirc compatible hardware features, like LIRC_MODE_RAW,
  *			LIRC_CAN\_\*, as defined at include/media/lirc.h.
  *
+ * @buffer_size:	Number of FIFO buffers with @chunk_size size.
+ *			Only used if @rbuf is NULL.
+ *
  * @chunk_size:		Size of each FIFO buffer.
+ *			Only used if @rbuf is NULL.
  *
  * @data:		it may point to any driver data and this pointer will
  *			be passed to all callback functions.
@@ -156,9 +157,9 @@ struct lirc_driver {
 	char name[40];
 	unsigned minor;
 	__u32 code_length;
-	unsigned int buffer_size; /* in chunks holding one code each */
 	__u32 features;
 
+	unsigned int buffer_size; /* in chunks holding one code each */
 	unsigned int chunk_size;
 
 	void *data;
