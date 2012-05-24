Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42148 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab2EXPQC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 11:16:02 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4J00F68931GT80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:16:13 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4J00ASV92NOE@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:15:59 +0100 (BST)
Date: Thu, 24 May 2012 17:15:51 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/7] s5p-fimc: Don't create multiple active links to same sink
 entity
In-reply-to: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1337872556-26406-3-git-send-email-s.nawrocki@samsung.com>
References: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver is supposed to create active media link from sensor N
(or its corresponding s5p-mipi-csis entity) to FIMC.N by default.
Instead s5p-mipi-csis.N entity gets  always connected by a default
active link to FIMC.N, regardless of there are parallel bus sensor
entities already connected to FIMC.N. Correct this.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <s.nawrocki@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 7450dcd..dffe4da 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -502,12 +502,12 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
  * @source: the source entity to create links to all fimc entities from
  * @sensor: sensor subdev linked to FIMC[fimc_id] entity, may be null
  * @pad: the source entity pad index
- * @fimc_id: index of the fimc device for which link should be enabled
+ * @link_mask: bitmask of the fimc devices for which link should be enabled
  */
 static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 					    struct media_entity *source,
 					    struct v4l2_subdev *sensor,
-					    int pad, int fimc_id)
+					    int pad, int link_mask)
 {
 	struct fimc_sensor_info *s_info;
 	struct media_entity *sink;
@@ -524,7 +524,7 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 		if (!fmd->fimc[i]->variant->has_cam_if)
 			continue;
 
-		flags = (i == fimc_id) ? MEDIA_LNK_FL_ENABLED : 0;
+		flags = ((1 << i) & link_mask) ? MEDIA_LNK_FL_ENABLED : 0;
 
 		sink = &fmd->fimc[i]->vid_cap.subdev.entity;
 		ret = media_entity_create_link(source, pad, sink,
@@ -556,7 +556,10 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 		if (!fmd->fimc_lite[i])
 			continue;
 
-		flags = (i == fimc_id) ? MEDIA_LNK_FL_ENABLED : 0;
+		if (link_mask & (1 << (i + FIMC_MAX_DEVS)))
+			flags = MEDIA_LNK_FL_ENABLED;
+		else
+			flags = 0;
 
 		sink = &fmd->fimc_lite[i]->subdev.entity;
 		ret = media_entity_create_link(source, pad, sink,
@@ -618,9 +621,8 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 	struct s5p_fimc_isp_info *pdata;
 	struct fimc_sensor_info *s_info;
 	struct media_entity *source, *sink;
-	int i, pad, fimc_id = 0;
-	int ret = 0;
-	u32 flags;
+	int i, pad, fimc_id = 0, ret = 0;
+	u32 flags, link_mask = 0;
 
 	for (i = 0; i < fmd->num_sensors; i++) {
 		if (fmd->sensor[i].subdev == NULL)
@@ -672,19 +674,20 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 		if (source == NULL)
 			continue;
 
+		link_mask = 1 << fimc_id++;
 		ret = __fimc_md_create_fimc_sink_links(fmd, source, sensor,
-						       pad, fimc_id++);
+						       pad, link_mask);
 	}
 
-	fimc_id = 0;
 	for (i = 0; i < ARRAY_SIZE(fmd->csis); i++) {
 		if (fmd->csis[i].sd == NULL)
 			continue;
 		source = &fmd->csis[i].sd->entity;
 		pad = CSIS_PAD_SOURCE;
 
+		link_mask = 1 << fimc_id++;
 		ret = __fimc_md_create_fimc_sink_links(fmd, source, NULL,
-						       pad, fimc_id++);
+						       pad, link_mask);
 	}
 
 	/* Create immutable links between each FIMC's subdev and video node */
-- 
1.7.10

