Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34980 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab3GZJdH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 05:33:07 -0400
Received: by mail-pd0-f176.google.com with SMTP id 14so1417765pdc.7
        for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 02:33:07 -0700 (PDT)
From: Katsuya Matsubara <matsu@igel.co.jp>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Katsuya Matsubara <matsu@igel.co.jp>
Subject: [PATCH 5/7] [media] vsp1: Introduce bit operations for the DPR route registers
Date: Fri, 26 Jul 2013 18:32:15 +0900
Message-Id: <1374831137-9219-6-git-send-email-matsu@igel.co.jp>
In-Reply-To: <1374831137-9219-1-git-send-email-matsu@igel.co.jp>
References: <1374831137-9219-1-git-send-email-matsu@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change allows support for H/W IPs in which multiple DPR route
registers are combined into one.

Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
---
 drivers/media/platform/vsp1/vsp1.h       |    1 +
 drivers/media/platform/vsp1/vsp1_drv.c   |   94 +++++++++++++++++++-----------
 drivers/media/platform/vsp1/vsp1_video.c |   23 +++++---
 3 files changed, 77 insertions(+), 41 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 4d9b6c8..31c24a3 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -39,6 +39,7 @@ struct vsp1_uds;
 struct vsp1_dpr_route {
 	unsigned int id;
 	int reg;
+	int shift;
 };
 
 struct vsp1_device {
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 920edb1..ca05431 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -240,6 +240,7 @@ static void vsp1_device_init(struct vsp1_device *vsp1)
 	unsigned int i;
 	u32 status;
 	u32 route_unused = vsp1->routes[VI6_DPR_NODE_UNUSED].id;
+	u32 val;
 
 	/* Reset any channel that might be running. */
 	status = vsp1_read(vsp1, VI6_STATUS);
@@ -266,18 +267,43 @@ static void vsp1_device_init(struct vsp1_device *vsp1)
 	vsp1_write(vsp1, VI6_CLK_DCSWT, (8 << VI6_CLK_DCSWT_CSTPW_SHIFT) |
 		   (8 << VI6_CLK_DCSWT_CSTRW_SHIFT));
 
-	for (i = 0; i < vsp1->pdata->rpf_count; ++i)
-		vsp1_write(vsp1, VI6_DPR_RPF_ROUTE0 + i, route_unused);
+	for (i = 0; i < vsp1->pdata->rpf_count; ++i) {
+		val = vsp1_read(vsp1, VI6_DPR_RPF_ROUTE0 + i);
+		val |= route_unused
+			<< vsp1->routes[VI6_DPR_NODE_RPF0 + i].shift;
+		vsp1_write(vsp1, VI6_DPR_RPF_ROUTE0 + i, val);
+	}
+
+	for (i = 0; i < vsp1->pdata->uds_count; ++i) {
+		val = vsp1_read(vsp1, VI6_DPR_UDS_ROUTE0 + i);
+		val |= route_unused
+			<< vsp1->routes[VI6_DPR_NODE_UDS0 + i].shift;
+		vsp1_write(vsp1, VI6_DPR_UDS_ROUTE0 + i, val);
+	}
+
+	val = vsp1_read(vsp1, VI6_DPR_SRU_ROUTE);
+	val |= route_unused << vsp1->routes[VI6_DPR_NODE_SRU].shift;
+	vsp1_write(vsp1, VI6_DPR_SRU_ROUTE, val);
+
+	val = vsp1_read(vsp1, VI6_DPR_LUT_ROUTE);
+	val |= route_unused << vsp1->routes[VI6_DPR_NODE_LUT].shift;
+	vsp1_write(vsp1, VI6_DPR_LUT_ROUTE, val);
+
+	val = vsp1_read(vsp1, VI6_DPR_CLU_ROUTE);
+	val |= route_unused << vsp1->routes[VI6_DPR_NODE_CLU].shift;
+	vsp1_write(vsp1, VI6_DPR_CLU_ROUTE, val);
+
+	val = vsp1_read(vsp1, VI6_DPR_HST_ROUTE);
+	val |= route_unused << vsp1->routes[VI6_DPR_NODE_HST].shift;
+	vsp1_write(vsp1, VI6_DPR_HST_ROUTE, val);
 
-	for (i = 0; i < vsp1->pdata->uds_count; ++i)
-		vsp1_write(vsp1, VI6_DPR_UDS_ROUTE0 + i, route_unused);
+	val = vsp1_read(vsp1, VI6_DPR_HSI_ROUTE);
+	val |= route_unused << vsp1->routes[VI6_DPR_NODE_HSI].shift;
+	vsp1_write(vsp1, VI6_DPR_HSI_ROUTE, val);
 
-	vsp1_write(vsp1, VI6_DPR_SRU_ROUTE, route_unused);
-	vsp1_write(vsp1, VI6_DPR_LUT_ROUTE, route_unused);
-	vsp1_write(vsp1, VI6_DPR_CLU_ROUTE, route_unused);
-	vsp1_write(vsp1, VI6_DPR_HST_ROUTE, route_unused);
-	vsp1_write(vsp1, VI6_DPR_HSI_ROUTE, route_unused);
-	vsp1_write(vsp1, VI6_DPR_BRU_ROUTE, route_unused);
+	val = vsp1_read(vsp1, VI6_DPR_BRU_ROUTE);
+	val |= route_unused << vsp1->routes[VI6_DPR_NODE_BRU_OUT].shift;
+	vsp1_write(vsp1, VI6_DPR_BRU_ROUTE, val);
 
 	vsp1_write(vsp1, VI6_DPR_HGO_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
 		   (route_unused << VI6_DPR_SMPPT_PT_SHIFT));
@@ -590,30 +616,30 @@ static const unsigned int vsp1_reg_offs[] = {
 };
 
 static const struct vsp1_dpr_route vsp1_routes[] = {
-	[VI6_DPR_NODE_RPF0]	= {  0, VI6_DPR_RPF_ROUTE0  },
-	[VI6_DPR_NODE_RPF1]	= {  1, VI6_DPR_RPF_ROUTE0 + 1 },
-	[VI6_DPR_NODE_RPF2]	= {  2, VI6_DPR_RPF_ROUTE0 + 2 },
-	[VI6_DPR_NODE_RPF3]	= {  3, VI6_DPR_RPF_ROUTE0 + 3 },
-	[VI6_DPR_NODE_RPF4]	= {  4, VI6_DPR_RPF_ROUTE0 + 4 },
-	[VI6_DPR_NODE_SRU]	= { 16, VI6_DPR_SRU_ROUTE },
-	[VI6_DPR_NODE_UDS0]	= { 17, VI6_DPR_UDS_ROUTE0 },
-	[VI6_DPR_NODE_UDS1]	= { 18, VI6_DPR_UDS_ROUTE0 + 1 },
-	[VI6_DPR_NODE_UDS2]	= { 19, VI6_DPR_UDS_ROUTE0 + 2 },
-	[VI6_DPR_NODE_LUT]	= { 22, VI6_DPR_LUT_ROUTE },
-	[VI6_DPR_NODE_BRU_IN0]	= { 23, 0 },
-	[VI6_DPR_NODE_BRU_IN1]	= { 24, 0 },
-	[VI6_DPR_NODE_BRU_IN2]	= { 25, 0 },
-	[VI6_DPR_NODE_BRU_IN3]	= { 26, 0 },
-	[VI6_DPR_NODE_BRU_OUT]	= { 27, VI6_DPR_BRU_ROUTE },
-	[VI6_DPR_NODE_CLU]	= { 29, VI6_DPR_CLU_ROUTE },
-	[VI6_DPR_NODE_HST]	= { 30, VI6_DPR_HST_ROUTE },
-	[VI6_DPR_NODE_HSI]	= { 31, VI6_DPR_HSI_ROUTE },
-	[VI6_DPR_NODE_LIF]	= { 55, 0 },
-	[VI6_DPR_NODE_WPF0]	= { 56, 0 },
-	[VI6_DPR_NODE_WPF1]	= { 57, 0 },
-	[VI6_DPR_NODE_WPF2]	= { 58, 0 },
-	[VI6_DPR_NODE_WPF3]	= { 59, 0 },
-	[VI6_DPR_NODE_UNUSED]	= { 63, 0 },
+	[VI6_DPR_NODE_RPF0]	= {  0, VI6_DPR_RPF_ROUTE0, 0  },
+	[VI6_DPR_NODE_RPF1]	= {  1, VI6_DPR_RPF_ROUTE0 + 1, 0 },
+	[VI6_DPR_NODE_RPF2]	= {  2, VI6_DPR_RPF_ROUTE0 + 2, 0 },
+	[VI6_DPR_NODE_RPF3]	= {  3, VI6_DPR_RPF_ROUTE0 + 3, 0 },
+	[VI6_DPR_NODE_RPF4]	= {  4, VI6_DPR_RPF_ROUTE0 + 4, 0 },
+	[VI6_DPR_NODE_SRU]	= { 16, VI6_DPR_SRU_ROUTE, 0 },
+	[VI6_DPR_NODE_UDS0]	= { 17, VI6_DPR_UDS_ROUTE0, 0 },
+	[VI6_DPR_NODE_UDS1]	= { 18, VI6_DPR_UDS_ROUTE0 + 1, 0 },
+	[VI6_DPR_NODE_UDS2]	= { 19, VI6_DPR_UDS_ROUTE0 + 2, 0 },
+	[VI6_DPR_NODE_LUT]	= { 22, VI6_DPR_LUT_ROUTE, 0 },
+	[VI6_DPR_NODE_BRU_IN0]	= { 23, 0, 0 },
+	[VI6_DPR_NODE_BRU_IN1]	= { 24, 0, 0 },
+	[VI6_DPR_NODE_BRU_IN2]	= { 25, 0, 0 },
+	[VI6_DPR_NODE_BRU_IN3]	= { 26, 0, 0 },
+	[VI6_DPR_NODE_BRU_OUT]	= { 27, VI6_DPR_BRU_ROUTE, 0 },
+	[VI6_DPR_NODE_CLU]	= { 29, VI6_DPR_CLU_ROUTE, 0 },
+	[VI6_DPR_NODE_HST]	= { 30, VI6_DPR_HST_ROUTE, 0 },
+	[VI6_DPR_NODE_HSI]	= { 31, VI6_DPR_HSI_ROUTE, 0 },
+	[VI6_DPR_NODE_LIF]	= { 55, 0, 0 },
+	[VI6_DPR_NODE_WPF0]	= { 56, 0, 0 },
+	[VI6_DPR_NODE_WPF1]	= { 57, 0, 0 },
+	[VI6_DPR_NODE_WPF2]	= { 58, 0, 0 },
+	[VI6_DPR_NODE_WPF3]	= { 59, 0, 0 },
+	[VI6_DPR_NODE_UNUSED]	= { 63, 0, 0 },
 };
 
 static int vsp1_probe(struct platform_device *pdev)
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index aa71ba8..304a809 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -370,11 +370,16 @@ static int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		const struct vsp1_dpr_route *routes = entity->vsp1->routes;
+		int route_index = entity->route_index;
 
-		if (routes[entity->route_index].reg)
-			vsp1_write(entity->vsp1,
-				   routes[entity->route_index].reg,
-				   routes[VI6_DPR_NODE_UNUSED].id);
+		if (routes[route_index].reg) {
+			u32 val;
+
+			val = vsp1_read(entity->vsp1, routes[route_index].reg);
+			val |= routes[VI6_DPR_NODE_UNUSED].id
+				<< routes[route_index].shift;
+			vsp1_write(entity->vsp1, routes[route_index].reg, val);
+		}
 
 		v4l2_subdev_call(&entity->subdev, video, s_stream, 0);
 	}
@@ -573,13 +578,17 @@ static void vsp1_entity_route_setup(struct vsp1_entity *source)
 {
 	struct vsp1_entity *sink;
 	const struct vsp1_dpr_route *routes = source->vsp1->routes;
+	int route_index = source->route_index;
+	u32 val;
 
-	if (routes[source->route_index].reg == 0)
+	if (routes[route_index].reg == 0)
 		return;
 
 	sink = container_of(source->sink, struct vsp1_entity, subdev.entity);
-	vsp1_write(source->vsp1, routes[source->route_index].reg,
-		   routes[sink->route_index].id);
+	val = vsp1_read(source->vsp1, routes[route_index].reg);
+	val &= ~(routes[VI6_DPR_NODE_UNUSED].id << routes[route_index].shift);
+	val |= routes[sink->route_index].id << routes[route_index].shift;
+	vsp1_write(source->vsp1, routes[route_index].reg, val);
 }
 
 static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
-- 
1.7.9.5

