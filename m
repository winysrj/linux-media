Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:42718 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbcDTUsO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 16:48:14 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: fix media_open() to not release lock too soon
Date: Wed, 20 Apr 2016 14:48:10 -0600
Message-Id: <1461185290-6540-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media_open() releases media_devnode_lock before open is complete. Hold
the lock to call mdev->fops->open and release at the end.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-devnode.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 29409f4..0934789 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -155,7 +155,7 @@ static long media_compat_ioctl(struct file *filp, unsigned int cmd,
 static int media_open(struct inode *inode, struct file *filp)
 {
 	struct media_devnode *mdev;
-	int ret;
+	int ret = 0;
 
 	/* Check if the media device is available. This needs to be done with
 	 * the media_devnode_lock held to prevent an open/unregister race:
@@ -173,7 +173,6 @@ static int media_open(struct inode *inode, struct file *filp)
 	}
 	/* and increase the device refcount */
 	get_device(&mdev->dev);
-	mutex_unlock(&media_devnode_lock);
 
 	filp->private_data = mdev;
 
@@ -182,11 +181,12 @@ static int media_open(struct inode *inode, struct file *filp)
 		if (ret) {
 			put_device(&mdev->dev);
 			filp->private_data = NULL;
-			return ret;
+			goto done;
 		}
 	}
-
-	return 0;
+done:
+	mutex_unlock(&media_devnode_lock);
+	return ret;
 }
 
 /* Override for the release function */
-- 
2.5.0

