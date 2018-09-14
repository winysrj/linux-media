Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:45544 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728231AbeINH0h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 03:26:37 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 2/3] rcar-vin: add support for UDS (Up Down Scaler)
Date: Fri, 14 Sep 2018 04:13:44 +0200
Message-Id: <20180914021345.9277-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180914021345.9277-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180914021345.9277-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some VIN instances have access to a Up Down Scaler (UDS). The UDS are on
most SoCs shared between two VINs, the UDS can of course only be used by
one VIN at a time.

Add support to configure the UDS registers which are mapped to both VINs
sharing the UDS address-space. While validations the format at stream
start make sure the companion VIN is not already using the scaler. If
the scaler already is in use return -EBUSY.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 134 ++++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-vin.h |  24 ++++
 2 files changed, 152 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 92323310f7352147..673034f0f735dbb0 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -74,6 +74,10 @@
 
 /* Register offsets specific for Gen3 */
 #define VNCSI_IFMD_REG		0x20 /* Video n CSI2 Interface Mode Register */
+#define VNUDS_CTRL_REG		0x80 /* Video n scaling control register */
+#define VNUDS_SCALE_REG		0x84 /* Video n scaling factor register */
+#define VNUDS_PASS_BWIDTH_REG	0x90 /* Video n passband register */
+#define VNUDS_CLIP_SIZE_REG	0xa4 /* Video n UDS output size clipping reg */
 
 /* Register bit fields for R-Car VIN */
 /* Video n Main Control Register bits */
@@ -129,6 +133,9 @@
 #define VNCSI_IFMD_CSI_CHSEL(n) (((n) & 0xf) << 0)
 #define VNCSI_IFMD_CSI_CHSEL_MASK 0xf
 
+/* Video n scaling control register (Gen3) */
+#define VNUDS_CTRL_AMD		(1 << 30)
+
 struct rvin_buffer {
 	struct vb2_v4l2_buffer vb;
 	struct list_head list;
@@ -572,6 +579,78 @@ static void rvin_crop_scale_comp_gen2(struct rvin_dev *vin)
 		0, 0);
 }
 
+static unsigned int rvin_scale_ratio(unsigned int in, unsigned int out)
+{
+	unsigned int ratio;
+
+	ratio = in * 4096 / out;
+	return ratio >= 0x10000 ? 0xffff : ratio;
+}
+
+static unsigned int rvin_ratio_to_bwidth(unsigned int ratio)
+{
+	unsigned int mant, frac;
+
+	mant = (ratio & 0xF000) >> 12;
+	frac = ratio & 0x0FFF;
+	if (mant)
+		return 64 * 4096 * mant / (4096 * mant + frac);
+
+	return 64;
+}
+
+static bool rvin_gen3_need_scaling(struct rvin_dev *vin)
+{
+	if (vin->info->model != RCAR_GEN3)
+		return false;
+
+	return vin->crop.width != vin->format.width ||
+		vin->crop.height != vin->format.height;
+}
+
+static void rvin_crop_scale_comp_gen3(struct rvin_dev *vin)
+{
+	unsigned int ratio_h, ratio_v;
+	unsigned int bwidth_h, bwidth_v;
+	u32 vnmc, clip_size;
+
+	if (!rvin_gen3_need_scaling(vin))
+		return;
+
+	ratio_h = rvin_scale_ratio(vin->crop.width, vin->format.width);
+	bwidth_h = rvin_ratio_to_bwidth(ratio_h);
+
+	ratio_v = rvin_scale_ratio(vin->crop.height, vin->format.height);
+	bwidth_v = rvin_ratio_to_bwidth(ratio_v);
+
+	clip_size = vin->format.width << 16;
+
+	switch (vin->format.field) {
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+	case V4L2_FIELD_INTERLACED:
+	case V4L2_FIELD_SEQ_TB:
+	case V4L2_FIELD_SEQ_BT:
+		clip_size |= vin->format.height / 2;
+		break;
+	default:
+		clip_size |= vin->format.height;
+		break;
+	}
+
+	vnmc = rvin_read(vin, VNMC_REG);
+	rvin_write(vin, (vnmc & ~VNMC_VUP) | VNMC_SCLE, VNMC_REG);
+	rvin_write(vin, VNUDS_CTRL_AMD, VNUDS_CTRL_REG);
+	rvin_write(vin, (ratio_h << 16) | ratio_v, VNUDS_SCALE_REG);
+	rvin_write(vin, (bwidth_h << 16) | bwidth_v, VNUDS_PASS_BWIDTH_REG);
+	rvin_write(vin, clip_size, VNUDS_CLIP_SIZE_REG);
+	rvin_write(vin, vnmc, VNMC_REG);
+
+	vin_dbg(vin, "Pre-Clip: %ux%u@%u:%u Post-Clip: %ux%u@%u:%u\n",
+		vin->crop.width, vin->crop.height, vin->crop.left,
+		vin->crop.top, vin->format.width, vin->format.height, 0, 0);
+}
+
 void rvin_crop_scale_comp(struct rvin_dev *vin)
 {
 	/* Set Start/End Pixel/Line Pre-Clip */
@@ -593,8 +672,9 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
 		break;
 	}
 
-	/* TODO: Add support for the UDS scaler. */
-	if (vin->info->model != RCAR_GEN3)
+	if (vin->info->model == RCAR_GEN3)
+		rvin_crop_scale_comp_gen3(vin);
+	else
 		rvin_crop_scale_comp_gen2(vin);
 
 	if (vin->format.pixelformat == V4L2_PIX_FMT_NV16)
@@ -751,6 +831,9 @@ static int rvin_setup(struct rvin_dev *vin)
 			vnmc |= VNMC_DPINE;
 	}
 
+	if (rvin_gen3_need_scaling(vin))
+		vnmc |= VNMC_SCLE;
+
 	/* Progressive or interlaced mode */
 	interrupts = progressive ? VNIE_FIE : VNIE_EFE;
 
@@ -1081,10 +1164,42 @@ static int rvin_mc_validate_format(struct rvin_dev *vin, struct v4l2_subdev *sd,
 		return -EPIPE;
 	}
 
-	if (fmt.format.width != vin->format.width ||
-	    fmt.format.height != vin->format.height ||
-	    fmt.format.code != vin->mbus_code)
-		return -EPIPE;
+	vin->crop.width = fmt.format.width;
+	vin->crop.height = fmt.format.height;
+
+	if (rvin_gen3_need_scaling(vin)) {
+		const struct rvin_group_scaler *scaler;
+		struct rvin_dev *companion;
+
+		if (fmt.format.code != vin->mbus_code)
+			return -EPIPE;
+
+		if (!vin->info->scalers)
+			return -EPIPE;
+
+		for (scaler = vin->info->scalers;
+		     scaler->vin || scaler->companion; scaler++)
+			if (scaler->vin == vin->id)
+				break;
+
+		/* No scaler found for VIN. */
+		if (!scaler->vin && !scaler->companion)
+			return -EPIPE;
+
+		/* Make sure companion not using scaler. */
+		if (scaler->companion != -1) {
+			companion = vin->group->vin[scaler->companion];
+			if (companion &&
+			    companion->state != STOPPED &&
+			    rvin_gen3_need_scaling(companion))
+				return -EBUSY;
+		}
+	} else {
+		if (fmt.format.width != vin->format.width ||
+		    fmt.format.height != vin->format.height ||
+		    fmt.format.code != vin->mbus_code)
+			return -EPIPE;
+	}
 
 	return 0;
 }
@@ -1192,6 +1307,7 @@ static void rvin_stop_streaming(struct vb2_queue *vq)
 	struct rvin_dev *vin = vb2_get_drv_priv(vq);
 	unsigned long flags;
 	int retries = 0;
+	u32 vnmc;
 
 	spin_lock_irqsave(&vin->qlock, flags);
 
@@ -1223,6 +1339,12 @@ static void rvin_stop_streaming(struct vb2_queue *vq)
 		vin->state = STOPPED;
 	}
 
+	/* Clear UDS usage after we have stopped */
+	if (vin->info->model == RCAR_GEN3) {
+		vnmc = rvin_read(vin, VNMC_REG) & ~(VNMC_SCLE | VNMC_VUP);
+		rvin_write(vin, vnmc, VNMC_REG);
+	}
+
 	/* Release all active buffers */
 	return_all_buffers(vin, VB2_BUF_STATE_ERROR);
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 0b13b34d03e3dce4..5a617a30ba8c9a5a 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -122,6 +122,28 @@ struct rvin_group_route {
 	unsigned int mask;
 };
 
+/**
+ * struct rvin_group_scaler - describes a scaler attached to a VIN
+ *
+ * @vin:	Numerical VIN id that have access to a UDS.
+ * @companion:  Numerical VIN id that @vin share the UDS with.
+ *
+ * -- note::
+ *	Some R-Car VIN instances have access to a Up Down Scaler (UDS).
+ *	If a VIN have a UDS attached it's almost always shared between
+ *	two VIN instances. The UDS can only be used by one VIN at a time,
+ *	so the companion relationship needs to be described as well.
+ *
+ *	There are at most two VINs sharing a UDS. For each UDS shared
+ *	between two VINs there needs to be two instances of struct
+ *	rvin_group_scaler describing each of the VINs individually. If
+ *	a VIN do not share its UDS set companion to -1.
+ */
+struct rvin_group_scaler {
+	int vin;
+	int companion;
+};
+
 /**
  * struct rvin_info - Information about the particular VIN implementation
  * @model:		VIN model
@@ -130,6 +152,7 @@ struct rvin_group_route {
  * @max_height:		max input height the VIN supports
  * @routes:		list of possible routes from the CSI-2 recivers to
  *			all VINs. The list mush be NULL terminated.
+ * @scalers:		List of available scalers, must be NULL terminated.
  */
 struct rvin_info {
 	enum model_id model;
@@ -138,6 +161,7 @@ struct rvin_info {
 	unsigned int max_width;
 	unsigned int max_height;
 	const struct rvin_group_route *routes;
+	const struct rvin_group_scaler *scalers;
 };
 
 /**
-- 
2.18.0
