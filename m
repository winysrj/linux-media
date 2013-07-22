Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:14802 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab3GVSFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 14:05:40 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQC00H80NLEP9J0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Jul 2013 03:05:38 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 4/5] V4L2: Rename subdev field of struct v4l2_async_notifier
Date: Mon, 22 Jul 2013 20:04:46 +0200
Message-id: <1374516287-7638-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a purely cosmetic change. Since the 'subdev' member
points to an array of subdevs it seems more intuitive to name
it in plural form.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/soc_camera/soc_camera.c |    2 +-
 drivers/media/v4l2-core/v4l2-async.c           |    2 +-
 include/media/v4l2-async.h                     |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 8af572b..4b42572 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1501,7 +1501,7 @@ static int scan_async_group(struct soc_camera_host *ici,
 		return -ENOMEM;
 	}
 
-	sasc->notifier.subdev = asd;
+	sasc->notifier.subdevs = asd;
 	sasc->notifier.num_subdevs = size;
 	sasc->notifier.bound = soc_camera_async_bound;
 	sasc->notifier.unbind = soc_camera_async_unbind;
diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 9f91013..ed31a65 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -147,7 +147,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 	INIT_LIST_HEAD(&notifier->done);
 
 	for (i = 0; i < notifier->num_subdevs; i++) {
-		asd = notifier->subdev[i];
+		asd = notifier->subdevs[i];
 
 		switch (asd->match_type) {
 		case V4L2_ASYNC_MATCH_CUSTOM:
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 295782e..4e7834a 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -77,7 +77,7 @@ struct v4l2_async_subdev_list {
 /**
  * v4l2_async_notifier - v4l2_device notifier data
  * @num_subdevs:number of subdevices
- * @subdev:	array of pointers to subdevice descriptors
+ * @subdevs:	array of pointers to subdevice descriptors
  * @v4l2_dev:	pointer to struct v4l2_device
  * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
  * @done:	list of struct v4l2_async_subdev_list, already probed
@@ -88,7 +88,7 @@ struct v4l2_async_subdev_list {
  */
 struct v4l2_async_notifier {
 	unsigned int num_subdevs;
-	struct v4l2_async_subdev **subdev;
+	struct v4l2_async_subdev **subdevs;
 	struct v4l2_device *v4l2_dev;
 	struct list_head waiting;
 	struct list_head done;
-- 
1.7.9.5

