Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59240 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab2GZL7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 07:59:17 -0400
Received: by ghrr11 with SMTP id r11so1849047ghr.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 04:59:16 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH for v3.6] v4l2-dev.c: Move video_put() after debug printk
Date: Thu, 26 Jul 2012 08:59:04 -0300
Message-Id: <1343303944-2652-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is possible that video_put() releases video_device struct,
provoking a panic when debug printk wants to get video_device node name.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/v4l2-dev.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index af70f93..3210fd5 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -478,12 +478,12 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	}
 
 err:
-	/* decrease the refcount in case of an error */
-	if (ret)
-		video_put(vdev);
 	if (vdev->debug)
 		printk(KERN_DEBUG "%s: open (%d)\n",
 			video_device_node_name(vdev), ret);
+	/* decrease the refcount in case of an error */
+	if (ret)
+		video_put(vdev);
 	return ret;
 }
 
@@ -500,12 +500,12 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 		if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 			mutex_unlock(vdev->lock);
 	}
-	/* decrease the refcount unconditionally since the release()
-	   return value is ignored. */
-	video_put(vdev);
 	if (vdev->debug)
 		printk(KERN_DEBUG "%s: release\n",
 			video_device_node_name(vdev));
+	/* decrease the refcount unconditionally since the release()
+	   return value is ignored. */
+	video_put(vdev);
 	return ret;
 }
 
-- 
1.7.4.4

