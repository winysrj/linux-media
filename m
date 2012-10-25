Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:63371 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab2JYOHU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 10:07:20 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCG00GVDCK6QU10@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Oct 2012 23:07:18 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MCG004C2CJX1A80@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Oct 2012 23:07:18 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-fimc: Fix platform entities registration
Date: Thu, 25 Oct 2012 16:07:06 +0200
Message-id: <1351174026-29859-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1351156016-10970-1-git-send-email-s.nawrocki@samsung.com>
References: <1351156016-10970-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure the platform sub-devices are registered to the media
device driver only when v4l2_device_unregister_subdev() succeeds.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   33 ++++++++++++------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 715b258..0ffde5b 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -345,25 +345,23 @@ static int fimc_register_callback(struct device *dev, void *p)
 	struct fimc_dev *fimc = dev_get_drvdata(dev);
 	struct v4l2_subdev *sd = &fimc->vid_cap.subdev;
 	struct fimc_md *fmd = p;
-	int ret = 0;
-
-	if (!fimc || !fimc->pdev)
-		return 0;
+	int ret;
 
-	if (fimc->pdev->id < 0 || fimc->pdev->id >= FIMC_MAX_DEVS)
+	if (fimc == NULL || fimc->id >= FIMC_MAX_DEVS)
 		return 0;
 
-	fimc->pipeline_ops = &fimc_pipeline_ops;
-	fmd->fimc[fimc->pdev->id] = fimc;
 	sd->grp_id = FIMC_GROUP_ID;
 
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
 	if (ret) {
 		v4l2_err(&fmd->v4l2_dev, "Failed to register FIMC.%d (%d)\n",
 			 fimc->id, ret);
+		return ret;
 	}
 
-	return ret;
+	fimc->pipeline_ops = &fimc_pipeline_ops;
+	fmd->fimc[fimc->id] = fimc;
+	return 0;
 }
 
 static int fimc_lite_register_callback(struct device *dev, void *p)
@@ -373,14 +371,9 @@ static int fimc_lite_register_callback(struct device *dev, void *p)
 	struct fimc_md *fmd = p;
 	int ret;
 
-	if (fimc == NULL)
+	if (fimc == NULL || fimc->index >= FIMC_LITE_MAX_DEVS)
 		return 0;
 
-	if (fimc->index >= FIMC_LITE_MAX_DEVS)
-		return 0;
-
-	fimc->pipeline_ops = &fimc_pipeline_ops;
-	fmd->fimc_lite[fimc->index] = fimc;
 	sd->grp_id = FLITE_GROUP_ID;
 
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
@@ -388,8 +381,12 @@ static int fimc_lite_register_callback(struct device *dev, void *p)
 		v4l2_err(&fmd->v4l2_dev,
 			 "Failed to register FIMC-LITE.%d (%d)\n",
 			 fimc->index, ret);
+		return ret;
 	}
-	return ret;
+
+	fimc->pipeline_ops = &fimc_pipeline_ops;
+	fmd->fimc_lite[fimc->index] = fimc;
+	return 0;
 }
 
 static int csis_register_callback(struct device *dev, void *p)
@@ -407,10 +404,12 @@ static int csis_register_callback(struct device *dev, void *p)
 	v4l2_info(sd, "csis%d sd: %s\n", pdev->id, sd->name);
 
 	id = pdev->id < 0 ? 0 : pdev->id;
-	fmd->csis[id].sd = sd;
 	sd->grp_id = CSIS_GROUP_ID;
+
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

