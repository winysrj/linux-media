Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:64932 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab2K1TSc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 14:18:32 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME7009ROPMTF440@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:18:31 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0ME700C69PML0A30@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:18:31 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 11/12] s5p-fimc: Add sensor group ids for fimc-is
Date: Wed, 28 Nov 2012 20:18:17 +0100
Message-id: <1354130298-3071-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1354130298-3071-1-git-send-email-s.nawrocki@samsung.com>
References: <1354130298-3071-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add subdev group id definition for FIMC-IS ISP and sensor subdev.
While at it rename all group id definitions to start with GRP_ID.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   21 +++++++++++----------
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |   12 +++++++-----
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 66ae862..2c2d5f3 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -62,16 +62,17 @@ static void fimc_pipeline_prepare(struct fimc_pipeline *p,
 		sd = media_entity_to_v4l2_subdev(pad->entity);
 
 		switch (sd->grp_id) {
-		case SENSOR_GROUP_ID:
+		case GRP_ID_FIMC_IS_SENSOR:
+		case GRP_ID_SENSOR:
 			p->subdevs[IDX_SENSOR] = sd;
 			break;
-		case CSIS_GROUP_ID:
+		case GRP_ID_CSIS:
 			p->subdevs[IDX_CSIS] = sd;
 			break;
-		case FLITE_GROUP_ID:
+		case GRP_ID_FLITE:
 			p->subdevs[IDX_FLITE] = sd;
 			break;
-		case FIMC_GROUP_ID:
+		case GRP_ID_FIMC:
 			/* No need to control FIMC subdev through subdev ops */
 			break;
 		default:
@@ -269,7 +270,7 @@ static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 	v4l2_set_subdev_hostdata(sd, s_info);
-	sd->grp_id = SENSOR_GROUP_ID;
+	sd->grp_id = GRP_ID_SENSOR;
 
 	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice %s\n",
 		  s_info->pdata.board_info->type);
@@ -351,7 +352,7 @@ static int fimc_register_callback(struct device *dev, void *p)
 		return 0;
 
 	sd = &fimc->vid_cap.subdev;
-	sd->grp_id = FIMC_GROUP_ID;
+	sd->grp_id = GRP_ID_FIMC;
 	v4l2_set_subdev_hostdata(sd, (void *)&fimc_pipeline_ops);
 
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
@@ -374,7 +375,7 @@ static int fimc_lite_register_callback(struct device *dev, void *p)
 	if (fimc == NULL || fimc->index >= FIMC_LITE_MAX_DEVS)
 		return 0;
 
-	fimc->subdev.grp_id = FLITE_GROUP_ID;
+	fimc->subdev.grp_id = GRP_ID_FLITE;
 	v4l2_set_subdev_hostdata(&fimc->subdev, (void *)&fimc_pipeline_ops);
 
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, &fimc->subdev);
@@ -404,7 +405,7 @@ static int csis_register_callback(struct device *dev, void *p)
 	v4l2_info(sd, "csis%d sd: %s\n", pdev->id, sd->name);
 
 	id = pdev->id < 0 ? 0 : pdev->id;
-	sd->grp_id = CSIS_GROUP_ID;
+	sd->grp_id = GRP_ID_CSIS;
 
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
 	if (!ret)
@@ -829,11 +830,11 @@ static int fimc_md_link_notify(struct media_pad *source,
 	sd = media_entity_to_v4l2_subdev(sink->entity);
 
 	switch (sd->grp_id) {
-	case FLITE_GROUP_ID:
+	case GRP_ID_FLITE:
 		fimc_lite = v4l2_get_subdevdata(sd);
 		pipeline = &fimc_lite->pipeline;
 		break;
-	case FIMC_GROUP_ID:
+	case GRP_ID_FIMC:
 		fimc = v4l2_get_subdevdata(sd);
 		pipeline = &fimc->pipeline;
 		break;
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
index 2d8d41d..da7d992 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
@@ -22,11 +22,13 @@
 #include "mipi-csis.h"
 
 /* Group IDs of sensor, MIPI-CSIS, FIMC-LITE and the writeback subdevs. */
-#define SENSOR_GROUP_ID		(1 << 8)
-#define CSIS_GROUP_ID		(1 << 9)
-#define WRITEBACK_GROUP_ID	(1 << 10)
-#define FIMC_GROUP_ID		(1 << 11)
-#define FLITE_GROUP_ID		(1 << 12)
+#define GRP_ID_SENSOR		(1 << 8)
+#define GRP_ID_FIMC_IS_SENSOR	(1 << 9)
+#define GRP_ID_WRITEBACK	(1 << 10)
+#define GRP_ID_CSIS		(1 << 11)
+#define GRP_ID_FIMC		(1 << 12)
+#define GRP_ID_FLITE		(1 << 13)
+#define GRP_ID_FIMC_IS		(1 << 14)
 
 #define FIMC_MAX_SENSORS	8
 #define FIMC_MAX_CAMCLKS	2
-- 
1.7.9.5

