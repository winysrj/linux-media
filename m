Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:12622 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab3EIPhy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 11:37:54 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ00C2GFF5A8B0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 May 2013 00:37:53 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, dh09.lee@samsung.com, a.hajda@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 11/13] exynos4-is: Fix sensor subdev -> FIMC notification setup
Date: Thu, 09 May 2013 17:36:43 +0200
Message-id: <1368113805-20233-12-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
References: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure the v4l2_device notifications from sensor subdev works
also after the media links reconfiguration.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |   47 ++++++++++++++++---------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index f8bd823..bf932d7 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1,8 +1,8 @@
 /*
  * S5P/EXYNOS4 SoC series camera host interface media device driver
  *
- * Copyright (C) 2011 - 2012 Samsung Electronics Co., Ltd.
- * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ * Copyright (C) 2011 - 2013 Samsung Electronics Co., Ltd.
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published
@@ -39,6 +39,26 @@
 static int __fimc_md_set_camclk(struct fimc_md *fmd,
 				struct fimc_source_info *si,
 				bool on);
+
+/* Set up image sensor subdev -> FIMC capture node notifications. */
+static void __setup_sensor_notification(struct fimc_md *fmd,
+					struct v4l2_subdev *sensor,
+					struct v4l2_subdev *fimc_sd)
+{
+	struct fimc_source_info *src_inf;
+	struct fimc_sensor_info *md_si;
+	unsigned long flags;
+
+	src_inf = v4l2_get_subdev_hostdata(sensor);
+	if (!src_inf || WARN_ON(fmd == NULL))
+		return;
+
+	md_si = source_to_sensor_info(src_inf);
+	spin_lock_irqsave(&fmd->slock, flags);
+	md_si->host = v4l2_get_subdevdata(fimc_sd);
+	spin_unlock_irqrestore(&fmd->slock, flags);
+}
+
 /**
  * fimc_pipeline_prepare - update pipeline information with subdevice pointers
  * @me: media entity terminating the pipeline
@@ -48,7 +68,9 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 static void fimc_pipeline_prepare(struct fimc_pipeline *p,
 					struct media_entity *me)
 {
+	struct fimc_md *fmd = entity_to_fimc_mdev(me);
 	struct v4l2_subdev *sd;
+	struct v4l2_subdev *sensor = NULL;
 	int i;
 
 	for (i = 0; i < IDX_MAX; i++)
@@ -73,8 +95,10 @@ static void fimc_pipeline_prepare(struct fimc_pipeline *p,
 		sd = media_entity_to_v4l2_subdev(pad->entity);
 
 		switch (sd->grp_id) {
-		case GRP_ID_FIMC_IS_SENSOR:
 		case GRP_ID_SENSOR:
+			sensor = sd;
+			/* fall through */
+		case GRP_ID_FIMC_IS_SENSOR:
 			p->subdevs[IDX_SENSOR] = sd;
 			break;
 		case GRP_ID_CSIS:
@@ -84,7 +108,7 @@ static void fimc_pipeline_prepare(struct fimc_pipeline *p,
 			p->subdevs[IDX_FLITE] = sd;
 			break;
 		case GRP_ID_FIMC:
-			/* No need to control FIMC subdev through subdev ops */
+			p->subdevs[IDX_FIMC] = sd;
 			break;
 		case GRP_ID_FIMC_IS:
 			p->subdevs[IDX_IS_ISP] = sd;
@@ -96,6 +120,9 @@ static void fimc_pipeline_prepare(struct fimc_pipeline *p,
 		if (me->num_pads == 1)
 			break;
 	}
+
+	if (sensor && p->subdevs[IDX_FIMC])
+		__setup_sensor_notification(fmd, sensor, p->subdevs[IDX_FIMC]);
 }
 
 /**
@@ -923,18 +950,6 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 
 		v4l2_info(&fmd->v4l2_dev, "created link [%s] %c> [%s]\n",
 			  source->name, flags ? '=' : '-', sink->name);
-
-		if (flags == 0 || sensor == NULL)
-			continue;
-
-		if (!WARN_ON(si == NULL)) {
-			unsigned long irq_flags;
-			struct fimc_sensor_info *inf = source_to_sensor_info(si);
-
-			spin_lock_irqsave(&fmd->slock, irq_flags);
-			inf->host = fmd->fimc[i];
-			spin_unlock_irqrestore(&fmd->slock, irq_flags);
-		}
 	}
 
 	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
-- 
1.7.9.5

