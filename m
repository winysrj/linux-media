Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41280 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932715AbdEAQEO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:04:14 -0400
Subject: [PATCH 07/16] lirc_dev: merge lirc_register_driver() and
 lirc_allocate_driver()
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:04:11 +0200
Message-ID: <149365465153.12922.563884623878051967.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Merging the two means that lirc_allocate_buffer() is called before device_add()
and cdev_add() which makes more sense. This also simplifies the locking
slightly because lirc_allocate_buffer() will always be called with lirc_dev_lock
held.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |   41 +++++++++++++----------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 29eecddbd371..fcc88a09b108 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -120,8 +120,6 @@ static int lirc_allocate_buffer(struct irctl *ir)
 	unsigned int buffer_size;
 	struct lirc_driver *d = &ir->d;
 
-	mutex_lock(&lirc_dev_lock);
-
 	bytes_in_key = BITS_TO_LONGS(d->code_length) +
 						(d->code_length % 8 ? 1 : 0);
 	buffer_size = d->buffer_size ? d->buffer_size : BUFLEN / bytes_in_key;
@@ -145,16 +143,15 @@ static int lirc_allocate_buffer(struct irctl *ir)
 		}
 
 		ir->buf_internal = true;
+		d->rbuf = ir->buf;
 	}
 	ir->chunk_size = ir->buf->chunk_size;
 
 out:
-	mutex_unlock(&lirc_dev_lock);
-
 	return err;
 }
 
-static int lirc_allocate_driver(struct lirc_driver *d)
+int lirc_register_driver(struct lirc_driver *d)
 {
 	struct irctl *ir;
 	int minor;
@@ -225,6 +222,15 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 
 	ir->d = *d;
 
+	if (LIRC_CAN_REC(d->features)) {
+		err = lirc_allocate_buffer(irctls[minor]);
+		if (err) {
+			kfree(ir);
+			goto out_lock;
+		}
+		d->rbuf = ir->buf;
+	}
+
 	device_initialize(&ir->dev);
 	ir->dev.devt = MKDEV(MAJOR(lirc_base_dev), ir->d.minor);
 	ir->dev.class = lirc_class;
@@ -248,7 +254,9 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 
 	dev_info(ir->d.dev, "lirc_dev: driver %s registered at minor = %d\n",
 		 ir->d.name, ir->d.minor);
+
 	return minor;
+
 out_cdev:
 	cdev_del(&ir->cdev);
 out_free_dev:
@@ -258,29 +266,6 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 
 	return err;
 }
-
-int lirc_register_driver(struct lirc_driver *d)
-{
-	int minor, err = 0;
-
-	minor = lirc_allocate_driver(d);
-	if (minor < 0)
-		return minor;
-
-	if (LIRC_CAN_REC(d->features)) {
-		err = lirc_allocate_buffer(irctls[minor]);
-		if (err)
-			lirc_unregister_driver(minor);
-		else
-			/*
-			 * This is kind of a hack but ir-lirc-codec needs
-			 * access to the buffer that lirc_dev allocated.
-			 */
-			d->rbuf = irctls[minor]->buf;
-	}
-
-	return err ? err : minor;
-}
 EXPORT_SYMBOL(lirc_register_driver);
 
 int lirc_unregister_driver(int minor)
