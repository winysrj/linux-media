Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:12161 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965193Ab2JYJHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 05:07:25 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCF001D9YO8PZV0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Oct 2012 18:07:23 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MCF00BEOYNNJEH0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Oct 2012 18:07:22 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-fimc: Fix platform entities registration
Date: Thu, 25 Oct 2012 11:06:56 +0200
Message-id: <1351156016-10970-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure there is no v4l2_device_unregister_subdev() call
on a subdev which wasn't registered.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   25 ++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 715b258..a69f053 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -345,24 +345,23 @@ static int fimc_register_callback(struct device *dev, void *p)
 	struct fimc_dev *fimc = dev_get_drvdata(dev);
 	struct v4l2_subdev *sd = &fimc->vid_cap.subdev;
 	struct fimc_md *fmd = p;
-	int ret = 0;
+	int ret;
 
-	if (!fimc || !fimc->pdev)
+	if (fimc == NULL)
 		return 0;
 
-	if (fimc->pdev->id < 0 || fimc->pdev->id >= FIMC_MAX_DEVS)
+	if (fimc->id >= FIMC_MAX_DEVS)
 		return 0;
 
 	fimc->pipeline_ops = &fimc_pipeline_ops;
-	fmd->fimc[fimc->pdev->id] = fimc;
 	sd->grp_id = FIMC_GROUP_ID;
 
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
-	if (ret) {
+	if (!ret)
+		fmd->fimc[fimc->id] = fimc;
+	else
 		v4l2_err(&fmd->v4l2_dev, "Failed to register FIMC.%d (%d)\n",
 			 fimc->id, ret);
-	}
-
 	return ret;
 }
 
@@ -380,15 +379,15 @@ static int fimc_lite_register_callback(struct device *dev, void *p)
 		return 0;
 
 	fimc->pipeline_ops = &fimc_pipeline_ops;
-	fmd->fimc_lite[fimc->index] = fimc;
 	sd->grp_id = FLITE_GROUP_ID;
 
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
-	if (ret) {
+	if (!ret)
+		fmd->fimc_lite[fimc->index] = fimc;
+	else
 		v4l2_err(&fmd->v4l2_dev,
 			 "Failed to register FIMC-LITE.%d (%d)\n",
 			 fimc->index, ret);
-	}
 	return ret;
 }
 
@@ -407,10 +406,12 @@ static int csis_register_callback(struct device *dev, void *p)
 	v4l2_info(sd, "csis%d sd: %s\n", pdev->id, sd->name);
 
 	id = pdev->id < 0 ? 0 : pdev->id;
-	fmd->csis[id].sd = sd;
+
 	sd->grp_id = CSIS_GROUP_ID;
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
-	if (ret)
+	if (!ret)
+		fmd->csis[id].sd = sd;
+	else
 		v4l2_err(&fmd->v4l2_dev,
 			 "Failed to register CSIS subdevice: %d\n", ret);
 	return ret;
-- 
1.7.9.5

