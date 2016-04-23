Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35898 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbcDWXtv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2016 19:49:51 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 06/13] v4l: vsp1: Add output node value to routing table
Date: Sun, 24 Apr 2016 02:49:53 +0300
Message-Id: <1461455400-28767-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The output node value indicates the value to be used in a sampling point
register to use the node as the source of histogram data.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_entity.c | 52 ++++++++++++++++++++-----------
 drivers/media/platform/vsp1/vsp1_entity.h |  6 +++-
 2 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 3d070bcc6053..6a96ea77de69 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -274,28 +274,44 @@ int vsp1_entity_link_setup(struct media_entity *entity,
  * Initialization
  */
 
+#define VSP1_ENTITY_ROUTE(ent)						\
+	{ VSP1_ENTITY_##ent, 0, VI6_DPR_##ent##_ROUTE,			\
+	  { VI6_DPR_NODE_##ent }, VI6_DPR_NODE_##ent }
+
+#define VSP1_ENTITY_ROUTE_RPF(idx)					\
+	{ VSP1_ENTITY_RPF, idx, VI6_DPR_RPF_ROUTE(idx),			\
+	  { 0, }, VI6_DPR_NODE_RPF(idx) }
+
+#define VSP1_ENTITY_ROUTE_UDS(idx)					\
+	{ VSP1_ENTITY_UDS, idx, VI6_DPR_UDS_ROUTE(idx),			\
+	  { VI6_DPR_NODE_UDS(idx) }, VI6_DPR_NODE_UDS(idx) }
+
+#define VSP1_ENTITY_ROUTE_WPF(idx)					\
+	{ VSP1_ENTITY_WPF, idx, 0,					\
+	  { VI6_DPR_NODE_WPF(idx) }, VI6_DPR_NODE_WPF(idx) }
+
 static const struct vsp1_route vsp1_routes[] = {
 	{ VSP1_ENTITY_BRU, 0, VI6_DPR_BRU_ROUTE,
 	  { VI6_DPR_NODE_BRU_IN(0), VI6_DPR_NODE_BRU_IN(1),
 	    VI6_DPR_NODE_BRU_IN(2), VI6_DPR_NODE_BRU_IN(3),
-	    VI6_DPR_NODE_BRU_IN(4) } },
-	{ VSP1_ENTITY_HSI, 0, VI6_DPR_HSI_ROUTE, { VI6_DPR_NODE_HSI, } },
-	{ VSP1_ENTITY_HST, 0, VI6_DPR_HST_ROUTE, { VI6_DPR_NODE_HST, } },
-	{ VSP1_ENTITY_LIF, 0, 0, { VI6_DPR_NODE_LIF, } },
-	{ VSP1_ENTITY_LUT, 0, VI6_DPR_LUT_ROUTE, { VI6_DPR_NODE_LUT, } },
-	{ VSP1_ENTITY_RPF, 0, VI6_DPR_RPF_ROUTE(0), { 0, } },
-	{ VSP1_ENTITY_RPF, 1, VI6_DPR_RPF_ROUTE(1), { 0, } },
-	{ VSP1_ENTITY_RPF, 2, VI6_DPR_RPF_ROUTE(2), { 0, } },
-	{ VSP1_ENTITY_RPF, 3, VI6_DPR_RPF_ROUTE(3), { 0, } },
-	{ VSP1_ENTITY_RPF, 4, VI6_DPR_RPF_ROUTE(4), { 0, } },
-	{ VSP1_ENTITY_SRU, 0, VI6_DPR_SRU_ROUTE, { VI6_DPR_NODE_SRU, } },
-	{ VSP1_ENTITY_UDS, 0, VI6_DPR_UDS_ROUTE(0), { VI6_DPR_NODE_UDS(0), } },
-	{ VSP1_ENTITY_UDS, 1, VI6_DPR_UDS_ROUTE(1), { VI6_DPR_NODE_UDS(1), } },
-	{ VSP1_ENTITY_UDS, 2, VI6_DPR_UDS_ROUTE(2), { VI6_DPR_NODE_UDS(2), } },
-	{ VSP1_ENTITY_WPF, 0, 0, { VI6_DPR_NODE_WPF(0), } },
-	{ VSP1_ENTITY_WPF, 1, 0, { VI6_DPR_NODE_WPF(1), } },
-	{ VSP1_ENTITY_WPF, 2, 0, { VI6_DPR_NODE_WPF(2), } },
-	{ VSP1_ENTITY_WPF, 3, 0, { VI6_DPR_NODE_WPF(3), } },
+	    VI6_DPR_NODE_BRU_IN(4) }, VI6_DPR_NODE_BRU_OUT },
+	VSP1_ENTITY_ROUTE(HSI),
+	VSP1_ENTITY_ROUTE(HST),
+	{ VSP1_ENTITY_LIF, 0, 0, { VI6_DPR_NODE_LIF, }, VI6_DPR_NODE_LIF },
+	VSP1_ENTITY_ROUTE(LUT),
+	VSP1_ENTITY_ROUTE_RPF(0),
+	VSP1_ENTITY_ROUTE_RPF(1),
+	VSP1_ENTITY_ROUTE_RPF(2),
+	VSP1_ENTITY_ROUTE_RPF(3),
+	VSP1_ENTITY_ROUTE_RPF(4),
+	VSP1_ENTITY_ROUTE(SRU),
+	VSP1_ENTITY_ROUTE_UDS(0),
+	VSP1_ENTITY_ROUTE_UDS(1),
+	VSP1_ENTITY_ROUTE_UDS(2),
+	VSP1_ENTITY_ROUTE_WPF(0),
+	VSP1_ENTITY_ROUTE_WPF(1),
+	VSP1_ENTITY_ROUTE_WPF(2),
+	VSP1_ENTITY_ROUTE_WPF(3),
 };
 
 int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 69eff4e17350..aaab05f4952c 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -42,17 +42,21 @@ enum vsp1_entity_type {
  * @index: Entity index this routing entry is associated with
  * @reg: Output routing configuration register
  * @inputs: Target node value for each input
+ * @output: Target node value for entity output
  *
  * Each $vsp1_route entry describes routing configuration for the entity
  * specified by the entry's @type and @index. @reg indicates the register that
  * holds output routing configuration for the entity, and the @inputs array
- * store the target node value for each input of the entity.
+ * store the target node value for each input of the entity. The @output field
+ * stores the target node value of the entity output when used as a source for
+ * histogram generation.
  */
 struct vsp1_route {
 	enum vsp1_entity_type type;
 	unsigned int index;
 	unsigned int reg;
 	unsigned int inputs[VSP1_ENTITY_MAX_INPUTS];
+	unsigned int output;
 };
 
 /**
-- 
2.7.3

