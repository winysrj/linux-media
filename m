Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41755 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753158AbeCMSFr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 14:05:47 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 06/11] media: vsp1: Provide VSP1 feature helper macro
Date: Tue, 13 Mar 2018 19:05:22 +0100
Message-Id: <fbb2b73d14dc8051bf86a8e452965b3b400dd007.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
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
index 78ef838416b3..1c080538c993 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -69,6 +69,8 @@ struct vsp1_device_info {
 	bool uapi;
 };
 
+#define vsp1_feature(vsp1, f) ((vsp1)->info->features & (f))
+
 struct vsp1_device {
 	struct device *dev;
 	const struct vsp1_device_info *info;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index eed9516e25e1..6fa0019ffc6e 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -268,7 +268,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	}
 
 	/* Instantiate all the entities. */
-	if (vsp1->info->features & VSP1_HAS_BRS) {
+	if (vsp1_feature(vsp1, VSP1_HAS_BRS)) {
 		vsp1->brs = vsp1_bru_create(vsp1, VSP1_ENTITY_BRS);
 		if (IS_ERR(vsp1->brs)) {
 			ret = PTR_ERR(vsp1->brs);
@@ -278,7 +278,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		list_add_tail(&vsp1->brs->entity.list_dev, &vsp1->entities);
 	}
 
-	if (vsp1->info->features & VSP1_HAS_BRU) {
+	if (vsp1_feature(vsp1, VSP1_HAS_BRU)) {
 		vsp1->bru = vsp1_bru_create(vsp1, VSP1_ENTITY_BRU);
 		if (IS_ERR(vsp1->bru)) {
 			ret = PTR_ERR(vsp1->bru);
@@ -288,7 +288,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		list_add_tail(&vsp1->bru->entity.list_dev, &vsp1->entities);
 	}
 
-	if (vsp1->info->features & VSP1_HAS_CLU) {
+	if (vsp1_feature(vsp1, VSP1_HAS_CLU)) {
 		vsp1->clu = vsp1_clu_create(vsp1);
 		if (IS_ERR(vsp1->clu)) {
 			ret = PTR_ERR(vsp1->clu);
@@ -314,7 +314,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 	list_add_tail(&vsp1->hst->entity.list_dev, &vsp1->entities);
 
-	if (vsp1->info->features & VSP1_HAS_HGO && vsp1->info->uapi) {
+	if (vsp1_feature(vsp1, VSP1_HAS_HGO) && vsp1->info->uapi) {
 		vsp1->hgo = vsp1_hgo_create(vsp1);
 		if (IS_ERR(vsp1->hgo)) {
 			ret = PTR_ERR(vsp1->hgo);
@@ -325,7 +325,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 			      &vsp1->entities);
 	}
 
-	if (vsp1->info->features & VSP1_HAS_HGT && vsp1->info->uapi) {
+	if (vsp1_feature(vsp1, VSP1_HAS_HGT) && vsp1->info->uapi) {
 		vsp1->hgt = vsp1_hgt_create(vsp1);
 		if (IS_ERR(vsp1->hgt)) {
 			ret = PTR_ERR(vsp1->hgt);
@@ -356,7 +356,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		}
 	}
 
-	if (vsp1->info->features & VSP1_HAS_LUT) {
+	if (vsp1_feature(vsp1, VSP1_HAS_LUT)) {
 		vsp1->lut = vsp1_lut_create(vsp1);
 		if (IS_ERR(vsp1->lut)) {
 			ret = PTR_ERR(vsp1->lut);
@@ -390,7 +390,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		}
 	}
 
-	if (vsp1->info->features & VSP1_HAS_SRU) {
+	if (vsp1_feature(vsp1, VSP1_HAS_SRU)) {
 		vsp1->sru = vsp1_sru_create(vsp1);
 		if (IS_ERR(vsp1->sru)) {
 			ret = PTR_ERR(vsp1->sru);
@@ -524,7 +524,7 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 	vsp1_write(vsp1, VI6_DPR_HSI_ROUTE, VI6_DPR_NODE_UNUSED);
 	vsp1_write(vsp1, VI6_DPR_BRU_ROUTE, VI6_DPR_NODE_UNUSED);
 
-	if (vsp1->info->features & VSP1_HAS_BRS)
+	if (vsp1_feature(vsp1, VSP1_HAS_BRS))
 		vsp1_write(vsp1, VI6_DPR_ILV_BRS_ROUTE, VI6_DPR_NODE_UNUSED);
 
 	vsp1_write(vsp1, VI6_DPR_HGO_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 68218625549e..f90e474cf2cc 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -146,13 +146,13 @@ static int wpf_init_controls(struct vsp1_rwpf *wpf)
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
@@ -281,7 +281,7 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
 
 		vsp1_wpf_write(wpf, dlb, VI6_WPF_DSWAP, fmtinfo->swap);
 
-		if (vsp1->info->features & VSP1_HAS_WPF_HFLIP &&
+		if (vsp1_feature(vsp1, VSP1_HAS_WPF_HFLIP) &&
 		    wpf->entity.index == 0)
 			vsp1_wpf_write(wpf, dlb, VI6_WPF_ROT_CTRL,
 				       VI6_WPF_ROT_CTRL_LN16 |
-- 
git-series 0.9.1
