Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34888 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751417AbeECNgc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 09:36:32 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 06/11] media: vsp1: Provide VSP1 feature helper macro
Date: Thu,  3 May 2018 14:36:17 +0100
Message-Id: <c9def3055aa8acf4a45c3a17b1da2c2468d35cca.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VSP1 devices define their specific capabilities through features
marked in their device info structure. Various parts of the code read
this info structure to infer if the features are available.

Wrap this into a more readable vsp1_feature(vsp1, f) macro to ensure
that usage is consistent throughout the driver.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h     |  2 ++
 drivers/media/platform/vsp1/vsp1_drv.c | 16 ++++++++--------
 drivers/media/platform/vsp1/vsp1_wpf.c |  6 +++---
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 33f632331474..f0d21cc8e9ab 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -68,6 +68,8 @@ struct vsp1_device_info {
 	bool uapi;
 };
 
+#define vsp1_feature(vsp1, f) ((vsp1)->info->features & (f))
+
 struct vsp1_device {
 	struct device *dev;
 	const struct vsp1_device_info *info;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index d29f9c4baebe..0fc388bf5a33 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -265,7 +265,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	}
 
 	/* Instantiate all the entities. */
-	if (vsp1->info->features & VSP1_HAS_BRS) {
+	if (vsp1_feature(vsp1, VSP1_HAS_BRS)) {
 		vsp1->brs = vsp1_brx_create(vsp1, VSP1_ENTITY_BRS);
 		if (IS_ERR(vsp1->brs)) {
 			ret = PTR_ERR(vsp1->brs);
@@ -275,7 +275,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		list_add_tail(&vsp1->brs->entity.list_dev, &vsp1->entities);
 	}
 
-	if (vsp1->info->features & VSP1_HAS_BRU) {
+	if (vsp1_feature(vsp1, VSP1_HAS_BRU)) {
 		vsp1->bru = vsp1_brx_create(vsp1, VSP1_ENTITY_BRU);
 		if (IS_ERR(vsp1->bru)) {
 			ret = PTR_ERR(vsp1->bru);
@@ -285,7 +285,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		list_add_tail(&vsp1->bru->entity.list_dev, &vsp1->entities);
 	}
 
-	if (vsp1->info->features & VSP1_HAS_CLU) {
+	if (vsp1_feature(vsp1, VSP1_HAS_CLU)) {
 		vsp1->clu = vsp1_clu_create(vsp1);
 		if (IS_ERR(vsp1->clu)) {
 			ret = PTR_ERR(vsp1->clu);
@@ -311,7 +311,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 	list_add_tail(&vsp1->hst->entity.list_dev, &vsp1->entities);
 
-	if (vsp1->info->features & VSP1_HAS_HGO && vsp1->info->uapi) {
+	if (vsp1_feature(vsp1, VSP1_HAS_HGO) && vsp1->info->uapi) {
 		vsp1->hgo = vsp1_hgo_create(vsp1);
 		if (IS_ERR(vsp1->hgo)) {
 			ret = PTR_ERR(vsp1->hgo);
@@ -322,7 +322,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 			      &vsp1->entities);
 	}
 
-	if (vsp1->info->features & VSP1_HAS_HGT && vsp1->info->uapi) {
+	if (vsp1_feature(vsp1, VSP1_HAS_HGT) && vsp1->info->uapi) {
 		vsp1->hgt = vsp1_hgt_create(vsp1);
 		if (IS_ERR(vsp1->hgt)) {
 			ret = PTR_ERR(vsp1->hgt);
@@ -353,7 +353,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		}
 	}
 
-	if (vsp1->info->features & VSP1_HAS_LUT) {
+	if (vsp1_feature(vsp1, VSP1_HAS_LUT)) {
 		vsp1->lut = vsp1_lut_create(vsp1);
 		if (IS_ERR(vsp1->lut)) {
 			ret = PTR_ERR(vsp1->lut);
@@ -387,7 +387,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		}
 	}
 
-	if (vsp1->info->features & VSP1_HAS_SRU) {
+	if (vsp1_feature(vsp1, VSP1_HAS_SRU)) {
 		vsp1->sru = vsp1_sru_create(vsp1);
 		if (IS_ERR(vsp1->sru)) {
 			ret = PTR_ERR(vsp1->sru);
@@ -537,7 +537,7 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 	vsp1_write(vsp1, VI6_DPR_HSI_ROUTE, VI6_DPR_NODE_UNUSED);
 	vsp1_write(vsp1, VI6_DPR_BRU_ROUTE, VI6_DPR_NODE_UNUSED);
 
-	if (vsp1->info->features & VSP1_HAS_BRS)
+	if (vsp1_feature(vsp1, VSP1_HAS_BRS))
 		vsp1_write(vsp1, VI6_DPR_ILV_BRS_ROUTE, VI6_DPR_NODE_UNUSED);
 
 	vsp1_write(vsp1, VI6_DPR_HGO_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 2edea361eee4..ea1d226371b2 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -141,13 +141,13 @@ static int wpf_init_controls(struct vsp1_rwpf *wpf)
 	if (wpf->entity.index != 0) {
 		/* Only WPF0 supports flipping. */
 		num_flip_ctrls = 0;
-	} else if (vsp1->info->features & VSP1_HAS_WPF_HFLIP) {
+	} else if (vsp1_feature(vsp1, VSP1_HAS_WPF_HFLIP)) {
 		/*
 		 * When horizontal flip is supported the WPF implements three
 		 * controls (horizontal flip, vertical flip and rotation).
 		 */
 		num_flip_ctrls = 3;
-	} else if (vsp1->info->features & VSP1_HAS_WPF_VFLIP) {
+	} else if (vsp1_feature(vsp1, VSP1_HAS_WPF_VFLIP)) {
 		/*
 		 * When only vertical flip is supported the WPF implements a
 		 * single control (vertical flip).
@@ -276,7 +276,7 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
 
 		vsp1_wpf_write(wpf, dlb, VI6_WPF_DSWAP, fmtinfo->swap);
 
-		if (vsp1->info->features & VSP1_HAS_WPF_HFLIP &&
+		if (vsp1_feature(vsp1, VSP1_HAS_WPF_HFLIP) &&
 		    wpf->entity.index == 0)
 			vsp1_wpf_write(wpf, dlb, VI6_WPF_ROT_CTRL,
 				       VI6_WPF_ROT_CTRL_LN16 |
-- 
git-series 0.9.1
