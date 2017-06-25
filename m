Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56421 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdFYMbw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:31:52 -0400
Subject: [PATCH 07/19] lirc_dev: remove kmalloc in lirc_dev_fop_read()
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:31:50 +0200
Message-ID: <149839391031.28811.5094791739782133013.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lirc_zilog uses a chunk_size of 2 and ir-lirc-codec uses sizeof(int).

Therefore, using stack memory should be perfectly fine.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 1773a2934484..92048d945ba7 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -376,7 +376,7 @@ ssize_t lirc_dev_fop_read(struct file *file,
 			  loff_t *ppos)
 {
 	struct irctl *ir = file->private_data;
-	unsigned char *buf;
+	unsigned char buf[ir->buf->chunk_size];
 	int ret = 0, written = 0;
 	DECLARE_WAITQUEUE(wait, current);
 
@@ -385,10 +385,6 @@ ssize_t lirc_dev_fop_read(struct file *file,
 
 	dev_dbg(ir->d.dev, LOGHEAD "read called\n", ir->d.name, ir->d.minor);
 
-	buf = kzalloc(ir->buf->chunk_size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
 	if (mutex_lock_interruptible(&ir->irctl_lock)) {
 		ret = -ERESTARTSYS;
 		goto out_unlocked;
@@ -464,8 +460,6 @@ ssize_t lirc_dev_fop_read(struct file *file,
 	mutex_unlock(&ir->irctl_lock);
 
 out_unlocked:
-	kfree(buf);
-
 	return ret ? ret : written;
 }
 EXPORT_SYMBOL(lirc_dev_fop_read);
