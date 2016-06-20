Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52953 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933025AbcFTTN7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:13:59 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 22/24] v4l: vsp1: wpf: Add flipping support
Date: Mon, 20 Jun 2016 22:10:40 +0300
Message-Id: <1466449842-29502-23-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vertical flipping is available on both Gen2 and Gen3, while horizontal
flipping is only available on Gen3.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h      |   2 +
 drivers/media/platform/vsp1/vsp1_drv.c  |  15 ++--
 drivers/media/platform/vsp1/vsp1_regs.h |   7 ++
 drivers/media/platform/vsp1/vsp1_rpf.c  |   2 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c |   4 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h |  11 ++-
 drivers/media/platform/vsp1/vsp1_wpf.c  | 143 ++++++++++++++++++++++++++++++--
 7 files changed, 167 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index f5e58cea36cc..a9b1d251f71a 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -50,6 +50,8 @@ struct vsp1_uds;
 #define VSP1_HAS_BRU		(1 << 3)
 #define VSP1_HAS_HGO		(1 << 4)
 #define VSP1_HAS_CLU		(1 << 5)
+#define VSP1_HAS_WPF_VFLIP	(1 << 6)
+#define VSP1_HAS_WPF_HFLIP	(1 << 7)
 
 struct vsp1_device_info {
 	u32 version;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 7e5bd48db2d6..dae1fa47acd7 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -585,7 +585,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPS_H2,
 		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
-			  | VSP1_HAS_LUT | VSP1_HAS_SRU,
+			  | VSP1_HAS_LUT | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
 		.uds_count = 3,
 		.wpf_count = 4,
@@ -594,7 +594,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPR_H2,
 		.gen = 2,
-		.features = VSP1_HAS_BRU | VSP1_HAS_SRU,
+		.features = VSP1_HAS_BRU | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
 		.uds_count = 3,
 		.wpf_count = 4,
@@ -614,7 +614,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPS_M2,
 		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
-			  | VSP1_HAS_LUT | VSP1_HAS_SRU,
+			  | VSP1_HAS_LUT | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
 		.uds_count = 1,
 		.wpf_count = 4,
@@ -624,7 +624,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPI_GEN3,
 		.gen = 3,
 		.features = VSP1_HAS_CLU | VSP1_HAS_HGO | VSP1_HAS_LUT
-			  | VSP1_HAS_SRU,
+			  | VSP1_HAS_SRU | VSP1_HAS_WPF_HFLIP
+			  | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 1,
 		.uds_count = 1,
 		.wpf_count = 1,
@@ -632,7 +633,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPBD_GEN3,
 		.gen = 3,
-		.features = VSP1_HAS_BRU,
+		.features = VSP1_HAS_BRU | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
 		.wpf_count = 1,
 		.num_bru_inputs = 5,
@@ -641,7 +642,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPBC_GEN3,
 		.gen = 3,
 		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
-			  | VSP1_HAS_LUT,
+			  | VSP1_HAS_LUT | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
 		.wpf_count = 1,
 		.num_bru_inputs = 5,
@@ -649,7 +650,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
 		.gen = 3,
-		.features = VSP1_HAS_BRU | VSP1_HAS_LIF,
+		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
 		.wpf_count = 2,
 		.num_bru_inputs = 5,
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 517a2a6606a3..d8213481edbe 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -255,6 +255,8 @@
 #define VI6_WPF_OUTFMT_PDV_MASK		(0xff << 24)
 #define VI6_WPF_OUTFMT_PDV_SHIFT	24
 #define VI6_WPF_OUTFMT_PXA		(1 << 23)
+#define VI6_WPF_OUTFMT_ROT		(1 << 18)
+#define VI6_WPF_OUTFMT_HFLP		(1 << 17)
 #define VI6_WPF_OUTFMT_FLP		(1 << 16)
 #define VI6_WPF_OUTFMT_SPYCS		(1 << 15)
 #define VI6_WPF_OUTFMT_SPUVS		(1 << 14)
@@ -289,6 +291,11 @@
 #define VI6_WPF_RNDCTRL_CLMD_EXT	(2 << 12)
 #define VI6_WPF_RNDCTRL_CLMD_MASK	(3 << 12)
 
+#define VI6_WPF_ROT_CTRL		0x1018
+#define VI6_WPF_ROT_CTRL_LN16		(1 << 17)
+#define VI6_WPF_ROT_CTRL_LMEM_WD_MASK	(0x1fff << 0)
+#define VI6_WPF_ROT_CTRL_LMEM_WD_SHIFT	0
+
 #define VI6_WPF_DSTM_STRIDE_Y		0x101c
 #define VI6_WPF_DSTM_STRIDE_C		0x1020
 #define VI6_WPF_DSTM_ADDR_Y		0x1024
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 39b0580878ce..a4bf6e1bcaea 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -247,7 +247,7 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 		return ERR_PTR(ret);
 
 	/* Initialize the control handler. */
-	ret = vsp1_rwpf_init_ctrls(rpf);
+	ret = vsp1_rwpf_init_ctrls(rpf, 0);
 	if (ret < 0) {
 		dev_err(vsp1->dev, "rpf%u: failed to initialize controls\n",
 			index);
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index cd3562d1d9cf..8d461b375e91 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -241,9 +241,9 @@ static const struct v4l2_ctrl_ops vsp1_rwpf_ctrl_ops = {
 	.s_ctrl = vsp1_rwpf_s_ctrl,
 };
 
-int vsp1_rwpf_init_ctrls(struct vsp1_rwpf *rwpf)
+int vsp1_rwpf_init_ctrls(struct vsp1_rwpf *rwpf, unsigned int ncontrols)
 {
-	v4l2_ctrl_handler_init(&rwpf->ctrls, 1);
+	v4l2_ctrl_handler_init(&rwpf->ctrls, ncontrols + 1);
 	v4l2_ctrl_new_std(&rwpf->ctrls, &vsp1_rwpf_ctrl_ops,
 			  V4L2_CID_ALPHA_COMPONENT, 0, 255, 1, 255);
 
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 801cacc12e07..cb20484e80da 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -13,6 +13,8 @@
 #ifndef __VSP1_RWPF_H__
 #define __VSP1_RWPF_H__
 
+#include <linux/spinlock.h>
+
 #include <media/media-entity.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
@@ -52,6 +54,13 @@ struct vsp1_rwpf {
 	u32 mult_alpha;
 	u32 outfmt;
 
+	struct {
+		spinlock_t lock;
+		struct v4l2_ctrl *ctrls[2];
+		unsigned int pending;
+		unsigned int active;
+	} flip;
+
 	unsigned int offsets[2];
 	struct vsp1_rwpf_memory mem;
 
@@ -71,7 +80,7 @@ static inline struct vsp1_rwpf *entity_to_rwpf(struct vsp1_entity *entity)
 struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index);
 struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index);
 
-int vsp1_rwpf_init_ctrls(struct vsp1_rwpf *rwpf);
+int vsp1_rwpf_init_ctrls(struct vsp1_rwpf *rwpf, unsigned int ncontrols);
 
 extern const struct v4l2_subdev_pad_ops vsp1_rwpf_pad_ops;
 
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index dab902c2e676..1281ab3fa59c 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -37,6 +37,95 @@ static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf,
 }
 
 /* -----------------------------------------------------------------------------
+ * Controls
+ */
+
+enum wpf_flip_ctrl {
+	WPF_CTRL_VFLIP = 0,
+	WPF_CTRL_HFLIP = 1,
+	WPF_CTRL_MAX,
+};
+
+static int vsp1_wpf_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vsp1_rwpf *wpf =
+		container_of(ctrl->handler, struct vsp1_rwpf, ctrls);
+	unsigned int i;
+	u32 flip = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+	case V4L2_CID_VFLIP:
+		for (i = 0; i < WPF_CTRL_MAX; ++i) {
+			if (wpf->flip.ctrls[i])
+				flip |= wpf->flip.ctrls[i]->val ? BIT(i) : 0;
+		}
+
+		spin_lock_irq(&wpf->flip.lock);
+		wpf->flip.pending = flip;
+		spin_unlock_irq(&wpf->flip.lock);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops vsp1_wpf_ctrl_ops = {
+	.s_ctrl = vsp1_wpf_s_ctrl,
+};
+
+static int wpf_init_controls(struct vsp1_rwpf *wpf)
+{
+	struct vsp1_device *vsp1 = wpf->entity.vsp1;
+	unsigned int num_flip_ctrls;
+
+	if (wpf->entity.index != 0) {
+		/* Only WPF0 supports flipping. */
+		num_flip_ctrls = 0;
+	} else if (vsp1->info->features & VSP1_HAS_WPF_HFLIP) {
+		/* When horizontal flip is supported the WPF implements two
+		 * controls (horizontal flip and vertical flip).
+		 */
+		num_flip_ctrls = 2;
+	} else if (vsp1->info->features & VSP1_HAS_WPF_VFLIP) {
+		/* When only vertical flip is supported the WPF implements a
+		 * single control (vertical flip).
+		 */
+		num_flip_ctrls = 1;
+	} else {
+		/* Otherwise flipping is not supported. */
+		num_flip_ctrls = 0;
+	}
+
+	vsp1_rwpf_init_ctrls(wpf, num_flip_ctrls);
+
+	if (num_flip_ctrls >= 1) {
+		wpf->flip.ctrls[WPF_CTRL_VFLIP] =
+			v4l2_ctrl_new_std(&wpf->ctrls, &vsp1_wpf_ctrl_ops,
+					  V4L2_CID_VFLIP, 0, 1, 1, 0);
+	}
+
+	if (num_flip_ctrls == 2) {
+		wpf->flip.ctrls[WPF_CTRL_HFLIP] =
+			v4l2_ctrl_new_std(&wpf->ctrls, &vsp1_wpf_ctrl_ops,
+					  V4L2_CID_HFLIP, 0, 1, 1, 0);
+
+		v4l2_ctrl_cluster(2, wpf->flip.ctrls);
+	}
+
+	if (wpf->ctrls.error) {
+		dev_err(vsp1->dev, "wpf%u: failed to initialize controls\n",
+			wpf->entity.index);
+		return wpf->ctrls.error;
+	}
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
  * V4L2 Subdevice Core Operations
  */
 
@@ -85,10 +174,32 @@ static void vsp1_wpf_destroy(struct vsp1_entity *entity)
 static void wpf_set_memory(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 {
 	struct vsp1_rwpf *wpf = entity_to_rwpf(entity);
+	const struct v4l2_pix_format_mplane *format = &wpf->format;
+	struct vsp1_rwpf_memory mem = wpf->mem;
+	unsigned int flip = wpf->flip.active;
+	unsigned int offset;
+
+	/* Update the memory offsets based on flipping configuration. The
+	 * destination addresses point to the locations where the VSP starts
+	 * writing to memory, which can be different corners of the image
+	 * depending on vertical flipping. Horizontal flipping is handled
+	 * through a line buffer and doesn't modify the start address.
+	 */
+	if (flip & BIT(WPF_CTRL_VFLIP)) {
+		mem.addr[0] += (format->height - 1)
+			     * format->plane_fmt[0].bytesperline;
+
+		if (format->num_planes > 1) {
+			offset = (format->height / wpf->fmtinfo->vsub - 1)
+			       * format->plane_fmt[1].bytesperline;
+			mem.addr[1] += offset;
+			mem.addr[2] += offset;
+		}
+	}
 
-	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_Y, wpf->mem.addr[0]);
-	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C0, wpf->mem.addr[1]);
-	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C1, wpf->mem.addr[2]);
+	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_Y, mem.addr[0]);
+	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C0, mem.addr[1]);
+	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C1, mem.addr[2]);
 }
 
 static void wpf_configure(struct vsp1_entity *entity,
@@ -105,8 +216,22 @@ static void wpf_configure(struct vsp1_entity *entity,
 	u32 srcrpf = 0;
 
 	if (!full) {
-		vsp1_wpf_write(wpf, dl, VI6_WPF_OUTFMT, wpf->outfmt |
-			       (wpf->alpha << VI6_WPF_OUTFMT_PDV_SHIFT));
+		const unsigned int mask = BIT(WPF_CTRL_VFLIP)
+					| BIT(WPF_CTRL_HFLIP);
+
+		spin_lock(&wpf->flip.lock);
+		wpf->flip.active = (wpf->flip.active & ~mask)
+				 | (wpf->flip.pending & mask);
+		spin_unlock(&wpf->flip.lock);
+
+		outfmt = (wpf->alpha << VI6_WPF_OUTFMT_PDV_SHIFT) | wpf->outfmt;
+
+		if (wpf->flip.active & BIT(WPF_CTRL_VFLIP))
+			outfmt |= VI6_WPF_OUTFMT_FLP;
+		if (wpf->flip.active & BIT(WPF_CTRL_HFLIP))
+			outfmt |= VI6_WPF_OUTFMT_HFLP;
+
+		vsp1_wpf_write(wpf, dl, VI6_WPF_OUTFMT, outfmt);
 		return;
 	}
 
@@ -149,6 +274,12 @@ static void wpf_configure(struct vsp1_entity *entity,
 				       format->plane_fmt[1].bytesperline);
 
 		vsp1_wpf_write(wpf, dl, VI6_WPF_DSWAP, fmtinfo->swap);
+
+		if (vsp1->info->features & VSP1_HAS_WPF_HFLIP &&
+		    wpf->entity.index == 0)
+			vsp1_wpf_write(wpf, dl, VI6_WPF_ROT_CTRL,
+				       VI6_WPF_ROT_CTRL_LN16 |
+				       (256 << VI6_WPF_ROT_CTRL_LMEM_WD_SHIFT));
 	}
 
 	if (sink_format->code != source_format->code)
@@ -234,7 +365,7 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	}
 
 	/* Initialize the control handler. */
-	ret = vsp1_rwpf_init_ctrls(wpf);
+	ret = wpf_init_controls(wpf);
 	if (ret < 0) {
 		dev_err(vsp1->dev, "wpf%u: failed to initialize controls\n",
 			index);
-- 
Regards,

Laurent Pinchart

