Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39295 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753468Ab3AVQYb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 11:24:31 -0500
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:6d9a::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 05E3E601E6
	for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 18:24:30 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] media: Add 64--32 bit compat ioctl handler
Date: Tue, 22 Jan 2013 18:27:55 +0200
Message-Id: <1358872076-5477-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20130122162343.GO13641@valkosipuli.retiisi.org.uk>
References: <20130122162343.GO13641@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide an ioctl handler for 32-bit binaries on 64-bit systems.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-devnode.c |   31 ++++++++++++++++++++++++++++---
 include/media/media-devnode.h |    1 +
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 023b2a1..fb0f046 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -116,19 +116,41 @@ static unsigned int media_poll(struct file *filp,
 	return mdev->fops->poll(filp, poll);
 }
 
-static long media_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static long
+__media_ioctl(struct file *filp, unsigned int cmd, unsigned long arg,
+	      long (*ioctl_func)(struct file *filp, unsigned int cmd,
+				 unsigned long arg))
 {
 	struct media_devnode *mdev = media_devnode_data(filp);
 
-	if (!mdev->fops->ioctl)
+	if (!ioctl_func)
 		return -ENOTTY;
 
 	if (!media_devnode_is_registered(mdev))
 		return -EIO;
 
-	return mdev->fops->ioctl(filp, cmd, arg);
+	return ioctl_func(filp, cmd, arg);
+}
+
+static long media_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct media_devnode *mdev = media_devnode_data(filp);
+
+	return __media_ioctl(filp, cmd, arg, mdev->fops->ioctl);
 }
 
+#ifdef CONFIG_COMPAT
+
+static long media_compat_ioctl(struct file *filp, unsigned int cmd,
+			       unsigned long arg)
+{
+	struct media_devnode *mdev = media_devnode_data(filp);
+
+	return __media_ioctl(filp, cmd, arg, mdev->fops->compat_ioctl);
+}
+
+#endif /* CONFIG_COMPAT */
+
 /* Override for the open function */
 static int media_open(struct inode *inode, struct file *filp)
 {
@@ -188,6 +210,9 @@ static const struct file_operations media_devnode_fops = {
 	.write = media_write,
 	.open = media_open,
 	.unlocked_ioctl = media_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = media_compat_ioctl,
+#endif /* CONFIG_COMPAT */
 	.release = media_release,
 	.poll = media_poll,
 	.llseek = no_llseek,
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index f6caafc..3446af2 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -46,6 +46,7 @@ struct media_file_operations {
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	long (*ioctl) (struct file *, unsigned int, unsigned long);
+	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*open) (struct file *);
 	int (*release) (struct file *);
 };
-- 
1.7.10.4

