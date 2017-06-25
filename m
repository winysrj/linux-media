Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56409 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdFYMbd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:31:33 -0400
Subject: [PATCH 03/19] lirc_dev: remove min_timeout and max_timeout
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:31:30 +0200
Message-ID: <149839388999.28811.3205928557994306883.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are no users of this functionality (ir-lirc-codec.c has its own
implementation and lirc_zilog.c doesn't use it) so remove it.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |   18 ------------------
 include/media/lirc_dev.h    |    8 --------
 2 files changed, 26 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index c9afaf5e64a9..591dee9f6ba2 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -404,24 +404,6 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case LIRC_GET_LENGTH:
 		result = put_user(ir->d.code_length, (__u32 __user *)arg);
 		break;
-	case LIRC_GET_MIN_TIMEOUT:
-		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
-		    ir->d.min_timeout == 0) {
-			result = -ENOTTY;
-			break;
-		}
-
-		result = put_user(ir->d.min_timeout, (__u32 __user *)arg);
-		break;
-	case LIRC_GET_MAX_TIMEOUT:
-		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
-		    ir->d.max_timeout == 0) {
-			result = -ENOTTY;
-			break;
-		}
-
-		result = put_user(ir->d.max_timeout, (__u32 __user *)arg);
-		break;
 	default:
 		result = -ENOTTY;
 	}
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 1419d64e2e59..53eef86e07a0 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -132,12 +132,6 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
  * @data:		it may point to any driver data and this pointer will
  *			be passed to all callback functions.
  *
- * @min_timeout:	Minimum timeout for record. Valid only if
- *			LIRC_CAN_SET_REC_TIMEOUT is defined.
- *
- * @max_timeout:	Maximum timeout for record. Valid only if
- *			LIRC_CAN_SET_REC_TIMEOUT is defined.
- *
  * @rbuf:		if not NULL, it will be used as a read buffer, you will
  *			have to write to the buffer by other means, like irq's
  *			(see also lirc_serial.c).
@@ -168,8 +162,6 @@ struct lirc_driver {
 	unsigned int chunk_size;
 
 	void *data;
-	int min_timeout;
-	int max_timeout;
 	struct lirc_buffer *rbuf;
 	struct rc_dev *rdev;
 	const struct file_operations *fops;
