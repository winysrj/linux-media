Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58832 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453AbcB0Kv3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 05:51:29 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 7/7] [media] lirc_dev: avoid double mutex unlock
Date: Sat, 27 Feb 2016 07:51:13 -0300
Message-Id: <b7194339caf580006f4b90171f519c1459921f62.1456570258.git.mchehab@osg.samsung.com>
In-Reply-To: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
References: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
In-Reply-To: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
References: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We can only unlock if mutex_lock() succeeds.

Fixes the following warning:
	drivers/media/rc/lirc_dev.c:535 lirc_dev_fop_close() error: double unlock 'mutex:&lirc_dev_lock'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/rc/lirc_dev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 4de0e85af805..92ae1903c010 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -506,6 +506,7 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 {
 	struct irctl *ir = irctls[iminor(inode)];
 	struct cdev *cdev;
+	int ret;
 
 	if (!ir) {
 		printk(KERN_ERR "%s: called with invalid irctl\n", __func__);
@@ -516,7 +517,8 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 
 	dev_dbg(ir->d.dev, LOGHEAD "close called\n", ir->d.name, ir->d.minor);
 
-	WARN_ON(mutex_lock_killable(&lirc_dev_lock));
+	ret = mutex_lock_killable(&lirc_dev_lock);
+	WARN_ON(ret);
 
 	rc_close(ir->d.rdev);
 
@@ -532,7 +534,8 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 		kfree(ir);
 	}
 
-	mutex_unlock(&lirc_dev_lock);
+	if (!ret)
+		mutex_unlock(&lirc_dev_lock);
 
 	return 0;
 }
-- 
2.5.0

