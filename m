Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:64830 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab3DBQGx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 12:06:53 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: yhwan.joo@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 7/7] exynos4-is: Create media links for the FIMC-IS entities
Date: Tue, 02 Apr 2013 18:03:39 +0200
Message-id: <1364918619-9118-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364918619-9118-1-git-send-email-s.nawrocki@samsung.com>
References: <1364918619-9118-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create disabled links from the FIMC-LITE subdevs to the FIMC-IS-ISP
subdev and from FIMC-IS-ISP to all FIMC subdevs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |   79 +++++++++++++++++++------
 1 file changed, 60 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 597648e..44d6c1d 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -838,12 +838,19 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 					    struct v4l2_subdev *sensor,
 					    int pad, int link_mask)
 {
-	struct fimc_sensor_info *s_info = NULL;
+	struct fimc_sensor_info *si = NULL;
 	struct media_entity *sink;
 	unsigned int flags = 0;
-	int ret, i;
+	int i, ret = 0;
 
-	for (i = 0; i < FIMC_MAX_DEVS; i++) {
+	if (sensor) {
+		si = v4l2_get_subdev_hostdata(sensor);
+		/* Skip direct FIMC links in the logical FIMC-IS sensor path */
+		if (si && si->pdata.fimc_bus_type == FIMC_BUS_TYPE_ISP_WRITEBACK)
+			ret = 1;
+	}
+
+	for (i = 0; !ret && i < FIMC_MAX_DEVS; i++) {
 		if (!fmd->fimc[i])
 			continue;
 		/*
@@ -872,11 +879,11 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 
 		if (flags == 0 || sensor == NULL)
 			continue;
-		s_info = v4l2_get_subdev_hostdata(sensor);
-		if (!WARN_ON(s_info == NULL)) {
+
+		if (!WARN_ON(si == NULL)) {
 			unsigned long irq_flags;
 			spin_lock_irqsave(&fmd->slock, irq_flags);
-			s_info->host = fmd->fimc[i];
+			si->host = fmd->fimc[i];
 			spin_unlock_irqrestore(&fmd->slock, irq_flags);
 		}
 	}
@@ -885,25 +892,20 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 		if (!fmd->fimc_lite[i])
 			continue;
 
-		if (link_mask & (1 << (i + FIMC_MAX_DEVS)))
-			flags = MEDIA_LNK_FL_ENABLED;
-		else
-			flags = 0;
-
 		sink = &fmd->fimc_lite[i]->subdev.entity;
 		ret = media_entity_create_link(source, pad, sink,
-					       FLITE_SD_PAD_SINK, flags);
+					       FLITE_SD_PAD_SINK, 0);
 		if (ret)
 			return ret;
 
 		/* Notify FIMC-LITE subdev entity */
 		ret = media_entity_call(sink, link_setup, &sink->pads[0],
-					&source->pads[pad], flags);
+					&source->pads[pad], 0);
 		if (ret)
 			break;
 
-		v4l2_info(&fmd->v4l2_dev, "created link [%s] %c> [%s]\n",
-			  source->name, flags ? '=' : '-', sink->name);
+		v4l2_info(&fmd->v4l2_dev, "created link [%s] -> [%s]\n",
+			  source->name, sink->name);
 	}
 	return 0;
 }
@@ -912,21 +914,50 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 static int __fimc_md_create_flite_source_links(struct fimc_md *fmd)
 {
 	struct media_entity *source, *sink;
-	unsigned int flags = MEDIA_LNK_FL_ENABLED;
 	int i, ret = 0;
 
 	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
 		struct fimc_lite *fimc = fmd->fimc_lite[i];
+
 		if (fimc == NULL)
 			continue;
+
 		source = &fimc->subdev.entity;
 		sink = &fimc->vfd.entity;
 		/* FIMC-LITE's subdev and video node */
 		ret = media_entity_create_link(source, FLITE_SD_PAD_SOURCE_DMA,
-					       sink, 0, flags);
+					       sink, 0, 0);
+		if (ret)
+			break;
+		/* Link from FIMC-LITE to IS-ISP subdev */
+		sink = &fmd->fimc_is->isp.subdev.entity;
+		ret = media_entity_create_link(source, FLITE_SD_PAD_SOURCE_ISP,
+					       sink, 0, 0);
 		if (ret)
 			break;
-		/* TODO: create links to other entities */
+	}
+
+	return ret;
+}
+
+/* Create FIMC-IS links */
+static int __fimc_md_create_fimc_is_links(struct fimc_md *fmd)
+{
+	struct media_entity *source, *sink;
+	int i, ret;
+
+	source = &fmd->fimc_is->isp.subdev.entity;
+
+	for (i = 0; i < FIMC_MAX_DEVS; i++) {
+		if (fmd->fimc[i] == NULL)
+			continue;
+
+		/* Link from IS-ISP subdev to FIMC */
+		sink = &fmd->fimc[i]->vid_cap.subdev.entity;
+		ret = media_entity_create_link(source, FIMC_ISP_SD_PAD_SRC_FIFO,
+					       sink, FIMC_SD_PAD_SINK_FIFO, 0);
+		if (ret)
+			return ret;
 	}
 
 	return ret;
@@ -1014,6 +1045,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 	for (i = 0; i < CSIS_MAX_ENTITIES; i++) {
 		if (fmd->csis[i].sd == NULL)
 			continue;
+
 		source = &fmd->csis[i].sd->entity;
 		pad = CSIS_PAD_SOURCE;
 		sensor = csi_sensors[i];
@@ -1028,15 +1060,24 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 	for (i = 0; i < FIMC_MAX_DEVS; i++) {
 		if (!fmd->fimc[i])
 			continue;
+
 		source = &fmd->fimc[i]->vid_cap.subdev.entity;
 		sink = &fmd->fimc[i]->vid_cap.vfd.entity;
+
 		ret = media_entity_create_link(source, FIMC_SD_PAD_SOURCE,
 					      sink, 0, flags);
 		if (ret)
 			break;
 	}
 
-	return __fimc_md_create_flite_source_links(fmd);
+	ret = __fimc_md_create_flite_source_links(fmd);
+	if (ret < 0)
+		return ret;
+
+	if (fmd->use_isp)
+		ret = __fimc_md_create_fimc_is_links(fmd);
+
+	return ret;
 }
 
 /*
-- 
1.7.9.5

