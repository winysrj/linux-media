Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:37892 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3HBM1o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 08:27:44 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQW0044VLA28SZ0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 02 Aug 2013 21:27:43 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] V4L: Drop meaningless video_is_registered() call in v4l2_open()
Date: Fri, 02 Aug 2013 14:27:29 +0200
Message-id: <1375446449-27066-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As it currently stands this code doesn't protect against any races
between video device open() and its unregistration. Races could be
avoided by doing the video_is_registered() check protected by the
core mutex, while the video device unregistration is also done with
this mutex held.

The history of this code is that the second video_is_registered()
call has been added in commit ee6869afc922a9849979e49bb3bbcad7948
"V4L/DVB: v4l2: add core serialization lock" together with addition
of the core mutex support in fops:

        mutex_unlock(&videodev_lock);
-       if (vdev->fops->open)
-               ret = vdev->fops->open(filp);
+       if (vdev->fops->open) {
+               if (vdev->lock)
+                       mutex_lock(vdev->lock);
+               if (video_is_registered(vdev))
+                       ret = vdev->fops->open(filp);
+               else
+                       ret = -ENODEV;
+               if (vdev->lock)
+                       mutex_unlock(vdev->lock);
+       }

While commit cf5337358548b813479b58478539fc20ee86556c
"[media] v4l2-dev: remove V4L2_FL_LOCK_ALL_FOPS"
removed only code touching the mutex:

        mutex_unlock(&videodev_lock);
        if (vdev->fops->open) {
-               if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags) &&
-                   mutex_lock_interruptible(vdev->lock)) {
-                       ret = -ERESTARTSYS;
-                       goto err;
-               }
                if (video_is_registered(vdev))
                        ret = vdev->fops->open(filp);
                else
                        ret = -ENODEV;
-               if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
-                       mutex_unlock(vdev->lock);
        }

Remove the remaining video_is_registered() call as it doesn't provide
any real protection and just adds unnecessary overhead.

The drivers need to perform the unregistration check themselves inside
their file operation handlers, while holding respective mutex.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/v4l2-dev.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index c8859d6..1743119 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -444,13 +444,9 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	/* and increase the device refcount */
 	video_get(vdev);
 	mutex_unlock(&videodev_lock);
-	if (vdev->fops->open) {
-		if (video_is_registered(vdev))
-			ret = vdev->fops->open(filp);
-		else
-			ret = -ENODEV;
-	}

+	if (vdev->fops->open)
+		ret = vdev->fops->open(filp);
 	if (vdev->debug)
 		printk(KERN_DEBUG "%s: open (%d)\n",
 			video_device_node_name(vdev), ret);
--
1.7.9.5

