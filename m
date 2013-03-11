Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45917 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab3CKTpn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:45:43 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 8/8] s5p-fimc: Create media links for the FIMC-IS entities
Date: Mon, 11 Mar 2013 20:44:52 +0100
Message-id: <1363031092-29950-9-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com>
References: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create disabled links from the FIMC-LITE subdevs to the FIMC-IS-ISP
subdev and from FIMC-IS-ISP to all FIMC subdevs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   78 +++++++++++++++++++-----
 1 file changed, 62 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 1521dec..5304da5 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -807,9 +807,17 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 	struct fimc_sensor_info *s_info = NULL;
 	struct media_entity *sink;
 	unsigned int flags = 0;
-	int ret, i;
+	int i, ret = 0;
 
-	for (i = 0; i < FIMC_MAX_DEVS; i++) {
+	if (sensor) {
+		s_info = v4l2_get_subdev_hostdata(sensor);
+		/* Skip direct FIMC links in the logical FIMC-IS sensor path */
+		if (s_info && s_info->pdata.fimc_bus_type ==
+		    FIMC_BUS_TYPE_ISP_WRITEBACK)
+			ret = 1;
+	}
+
+	for (i = 0; !ret && i < FIMC_MAX_DEVS; i++) {
 		if (!fmd->fimc[i])
 			continue;
 		/*
@@ -838,7 +846,7 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 
 		if (flags == 0 || sensor == NULL)
 			continue;
-		s_info = v4l2_get_subdev_hostdata(sensor);
+
 		if (!WARN_ON(s_info == NULL)) {
 			unsigned long irq_flags;
 			spin_lock_irqsave(&fmd->slock, irq_flags);
@@ -851,25 +859,20 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
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
@@ -878,26 +881,59 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
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
 	}
 
 	return ret;
 }
 
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
+		ret = media_entity_create_link(source, FIMC_IS_SD_PAD_SRC_FIFO,
+					       sink, FIMC_SD_PAD_SINK_FIFO, 0);
+		if (ret)
+			return ret;
+	}
+
+	/* Link from IS-ISP subdev to is.isp capture video node */
+	sink = &fmd->fimc_is->isp.vfd.entity;
+	ret = media_entity_create_link(source, FIMC_IS_SD_PAD_SRC_DMA,
+					       sink, 0, 0);
+	return ret;
+}
+
 /**
  * fimc_md_create_links - create default links between registered entities
  *
@@ -980,6 +1016,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 	for (i = 0; i < CSIS_MAX_ENTITIES; i++) {
 		if (fmd->csis[i].sd == NULL)
 			continue;
+
 		source = &fmd->csis[i].sd->entity;
 		pad = CSIS_PAD_SOURCE;
 		sensor = csi_sensors[i];
@@ -994,15 +1031,24 @@ static int fimc_md_create_links(struct fimc_md *fmd)
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

