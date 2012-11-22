Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:57726 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2KVSlR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 13:41:17 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDV00BGOX15U7S0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 19:27:20 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MDV00FPGX1ACB60@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 19:27:20 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-fimc: Prevent race conditions during subdevs registration
Date: Thu, 22 Nov 2012 11:27:07 +0100
Message-id: <1353580027-19671-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure when fimc and fimc-lite capture video node is registered
it has valid pipeline_ops assigned to it. Otherwise when a video
node is opened right after is was registered there, might be an
attempt to use ops that are just being assigned, after function
v4l2_device_register_subdev() returns.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |    7 ++++++-
 drivers/media/platform/s5p-fimc/fimc-lite.c    |    3 +++
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    4 ++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 3d39d97..3fc896b 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -1774,9 +1774,13 @@ static int fimc_capture_subdev_registered(struct v4l2_subdev *sd)
 	if (ret)
 		return ret;

+	fimc->pipeline_ops = v4l2_get_subdev_hostdata(sd);
+
 	ret = fimc_register_capture_device(fimc, sd->v4l2_dev);
-	if (ret)
+	if (ret) {
 		fimc_unregister_m2m_device(fimc);
+		fimc->pipeline_ops = NULL;
+	}

 	return ret;
 }
@@ -1793,6 +1797,7 @@ static void fimc_capture_subdev_unregistered(struct v4l2_subdev *sd)
 	if (video_is_registered(&fimc->vid_cap.vfd)) {
 		video_unregister_device(&fimc->vid_cap.vfd);
 		media_entity_cleanup(&fimc->vid_cap.vfd.entity);
+		fimc->pipeline_ops = NULL;
 	}
 	kfree(fimc->vid_cap.ctx);
 	fimc->vid_cap.ctx = NULL;
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 9db246b..23f203e 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -1263,10 +1263,12 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 		return ret;

 	video_set_drvdata(vfd, fimc);
+	fimc->pipeline_ops = v4l2_get_subdev_hostdata(sd);

 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
 		media_entity_cleanup(&vfd->entity);
+		fimc->pipeline_ops = NULL;
 		return ret;
 	}

@@ -1285,6 +1287,7 @@ static void fimc_lite_subdev_unregistered(struct v4l2_subdev *sd)
 	if (video_is_registered(&fimc->vfd)) {
 		video_unregister_device(&fimc->vfd);
 		media_entity_cleanup(&fimc->vfd.entity);
+		fimc->pipeline_ops = NULL;
 	}
 }

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 38ea4d1..df6e6ef 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -352,6 +352,7 @@ static int fimc_register_callback(struct device *dev, void *p)

 	sd = &fimc->vid_cap.subdev;
 	sd->grp_id = FIMC_GROUP_ID;
+	v4l2_set_subdev_hostdata(sd, &fimc_pipeline_ops);

 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
 	if (ret) {
@@ -360,7 +361,6 @@ static int fimc_register_callback(struct device *dev, void *p)
 		return ret;
 	}

-	fimc->pipeline_ops = &fimc_pipeline_ops;
 	fmd->fimc[fimc->id] = fimc;
 	return 0;
 }
@@ -375,6 +375,7 @@ static int fimc_lite_register_callback(struct device *dev, void *p)
 		return 0;

 	fimc->subdev.grp_id = FLITE_GROUP_ID;
+	v4l2_set_subdev_hostdata(&fimc->subdev, &fimc_pipeline_ops);

 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, &fimc->subdev);
 	if (ret) {
@@ -384,7 +385,6 @@ static int fimc_lite_register_callback(struct device *dev, void *p)
 		return ret;
 	}

-	fimc->pipeline_ops = &fimc_pipeline_ops;
 	fmd->fimc_lite[fimc->index] = fimc;
 	return 0;
 }
--
1.7.9.5

