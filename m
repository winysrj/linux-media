Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:53363 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbbBMWjV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:39:21 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Subject: [PATCH] sh_vou: fix memory leak on error paths in sh_vou_open()
Date: Sat, 14 Feb 2015 01:39:03 +0300
Message-Id: <1423867143-8332-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Memory allocated for sh_vou_file is not deallocated
on error paths in sh_vou_open().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/platform/sh_vou.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 261f1195b49f..6d1959d1ad02 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1168,10 +1168,10 @@ static int sh_vou_open(struct file *file)
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-	file->private_data = vou_file;
-
-	if (mutex_lock_interruptible(&vou_dev->fop_lock))
+	if (mutex_lock_interruptible(&vou_dev->fop_lock)) {
+		kfree(vou_file);
 		return -ERESTARTSYS;
+	}
 	if (atomic_inc_return(&vou_dev->use_count) == 1) {
 		int ret;
 		/* First open */
@@ -1183,6 +1183,7 @@ static int sh_vou_open(struct file *file)
 			pm_runtime_put(vou_dev->v4l2_dev.dev);
 			vou_dev->status = SH_VOU_IDLE;
 			mutex_unlock(&vou_dev->fop_lock);
+			kfree(vou_file);
 			return ret;
 		}
 	}
@@ -1195,6 +1196,8 @@ static int sh_vou_open(struct file *file)
 				       vou_dev->vdev, &vou_dev->fop_lock);
 	mutex_unlock(&vou_dev->fop_lock);
 
+	file->private_data = vou_file;
+
 	return 0;
 }
 
-- 
1.9.1

