Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50645 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753447AbdLNRWD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:22:03 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 07/10] media: lirc: do not pass ERR_PTR to kfree
Date: Thu, 14 Dec 2017 17:22:01 +0000
Message-Id: <520044a764d3b795fb10e0b381cc7a48f729cfbb.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If memdup_user() fails, txbuf will be an error pointer and passed
to kfree.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 6cedb546c3e0..8618aba152c6 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -231,7 +231,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 {
 	struct lirc_fh *fh = file->private_data;
 	struct rc_dev *dev = fh->rc;
-	unsigned int *txbuf = NULL;
+	unsigned int *txbuf;
 	struct ir_raw_event *raw = NULL;
 	ssize_t ret;
 	size_t count;
@@ -246,14 +246,14 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 
 	if (!dev->registered) {
 		ret = -ENODEV;
-		goto out;
+		goto out_unlock;
 	}
 
 	start = ktime_get();
 
 	if (!dev->tx_ir) {
 		ret = -EINVAL;
-		goto out;
+		goto out_unlock;
 	}
 
 	if (fh->send_mode == LIRC_MODE_SCANCODE) {
@@ -261,17 +261,17 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 
 		if (n != sizeof(scan)) {
 			ret = -EINVAL;
-			goto out;
+			goto out_unlock;
 		}
 
 		if (copy_from_user(&scan, buf, sizeof(scan))) {
 			ret = -EFAULT;
-			goto out;
+			goto out_unlock;
 		}
 
 		if (scan.flags || scan.keycode || scan.timestamp) {
 			ret = -EINVAL;
-			goto out;
+			goto out_unlock;
 		}
 
 		/*
@@ -283,26 +283,26 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		if (scan.scancode > U32_MAX ||
 		    !rc_validate_scancode(scan.rc_proto, scan.scancode)) {
 			ret = -EINVAL;
-			goto out;
+			goto out_unlock;
 		}
 
 		raw = kmalloc_array(LIRCBUF_SIZE, sizeof(*raw), GFP_KERNEL);
 		if (!raw) {
 			ret = -ENOMEM;
-			goto out;
+			goto out_unlock;
 		}
 
 		ret = ir_raw_encode_scancode(scan.rc_proto, scan.scancode,
 					     raw, LIRCBUF_SIZE);
 		if (ret < 0)
-			goto out;
+			goto out_kfree;
 
 		count = ret;
 
 		txbuf = kmalloc_array(count, sizeof(unsigned int), GFP_KERNEL);
 		if (!txbuf) {
 			ret = -ENOMEM;
-			goto out;
+			goto out_kfree;
 		}
 
 		for (i = 0; i < count; i++)
@@ -318,26 +318,26 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	} else {
 		if (n < sizeof(unsigned int) || n % sizeof(unsigned int)) {
 			ret = -EINVAL;
-			goto out;
+			goto out_unlock;
 		}
 
 		count = n / sizeof(unsigned int);
 		if (count > LIRCBUF_SIZE || count % 2 == 0) {
 			ret = -EINVAL;
-			goto out;
+			goto out_unlock;
 		}
 
 		txbuf = memdup_user(buf, n);
 		if (IS_ERR(txbuf)) {
 			ret = PTR_ERR(txbuf);
-			goto out;
+			goto out_unlock;
 		}
 	}
 
 	for (i = 0; i < count; i++) {
 		if (txbuf[i] > IR_MAX_DURATION / 1000 - duration || !txbuf[i]) {
 			ret = -EINVAL;
-			goto out;
+			goto out_kfree;
 		}
 
 		duration += txbuf[i];
@@ -345,7 +345,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 
 	ret = dev->tx_ir(dev, txbuf, count);
 	if (ret < 0)
-		goto out;
+		goto out_kfree;
 
 	if (fh->send_mode == LIRC_MODE_SCANCODE) {
 		ret = n;
@@ -368,10 +368,11 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		schedule_timeout(usecs_to_jiffies(towait));
 	}
 
-out:
-	mutex_unlock(&dev->lock);
+out_kfree:
 	kfree(txbuf);
 	kfree(raw);
+out_unlock:
+	mutex_unlock(&dev->lock);
 	return ret;
 }
 
-- 
2.14.3
