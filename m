Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:41712 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965083AbcA0Xtj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 18:49:39 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: Fix media_open() to clear filp->private_data in error leg
Date: Wed, 27 Jan 2016 16:49:33 -0700
Message-Id: <1453938573-13093-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix media_open() to clear filp->private_data when file open
fails.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-devnode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index cea35bf..29409f4 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -181,6 +181,7 @@ static int media_open(struct inode *inode, struct file *filp)
 		ret = mdev->fops->open(filp);
 		if (ret) {
 			put_device(&mdev->dev);
+			filp->private_data = NULL;
 			return ret;
 		}
 	}
-- 
2.5.0

