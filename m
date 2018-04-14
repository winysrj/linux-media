Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:47229 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbeDNMBB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Apr 2018 08:01:01 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v14 19/33] rcar-vin: enable Gen3 hardware configuration
Date: Sat, 14 Apr 2018 13:57:12 +0200
Message-Id: <20180414115726.5075-20-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180414115726.5075-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180414115726.5075-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the register needed to work with Gen3 hardware. This patch adds
the logic for how to work with the Gen3 hardware. More work is required
to enable the subdevice structure needed to configure capturing.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---

* Changes since v13
- Remove VNCSI_IFMD_DES2 define as the later versions of the datasheet
  have been updated to remove the register as pointed out by Koji
  Matsuoka.
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 93 ++++++++++++++++++++----------
 drivers/media/platform/rcar-vin/rcar-vin.h |  1 +
 2 files changed, 63 insertions(+), 31 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 41907a200037d5d5..482d89bae657a88e 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -33,21 +33,23 @@
 #define VNELPRC_REG	0x10	/* Video n End Line Pre-Clip Register */
 #define VNSPPRC_REG	0x14	/* Video n Start Pixel Pre-Clip Register */
 #define VNEPPRC_REG	0x18	/* Video n End Pixel Pre-Clip Register */
-#define VNSLPOC_REG	0x1C	/* Video n Start Line Post-Clip Register */
-#define VNELPOC_REG	0x20	/* Video n End Line Post-Clip Register */
-#define VNSPPOC_REG	0x24	/* Video n Start Pixel Post-Clip Register */
-#define VNEPPOC_REG	0x28	/* Video n End Pixel Post-Clip Register */
 #define VNIS_REG	0x2C	/* Video n Image Stride Register */
 #define VNMB_REG(m)	(0x30 + ((m) << 2)) /* Video n Memory Base m Register */
 #define VNIE_REG	0x40	/* Video n Interrupt Enable Register */
 #define VNINTS_REG	0x44	/* Video n Interrupt Status Register */
 #define VNSI_REG	0x48	/* Video n Scanline Interrupt Register */
 #define VNMTC_REG	0x4C	/* Video n Memory Transfer Control Register */
-#define VNYS_REG	0x50	/* Video n Y Scale Register */
-#define VNXS_REG	0x54	/* Video n X Scale Register */
 #define VNDMR_REG	0x58	/* Video n Data Mode Register */
 #define VNDMR2_REG	0x5C	/* Video n Data Mode Register 2 */
 #define VNUVAOF_REG	0x60	/* Video n UV Address Offset Register */
+
+/* Register offsets specific for Gen2 */
+#define VNSLPOC_REG	0x1C	/* Video n Start Line Post-Clip Register */
+#define VNELPOC_REG	0x20	/* Video n End Line Post-Clip Register */
+#define VNSPPOC_REG	0x24	/* Video n Start Pixel Post-Clip Register */
+#define VNEPPOC_REG	0x28	/* Video n End Pixel Post-Clip Register */
+#define VNYS_REG	0x50	/* Video n Y Scale Register */
+#define VNXS_REG	0x54	/* Video n X Scale Register */
 #define VNC1A_REG	0x80	/* Video n Coefficient Set C1A Register */
 #define VNC1B_REG	0x84	/* Video n Coefficient Set C1B Register */
 #define VNC1C_REG	0x88	/* Video n Coefficient Set C1C Register */
@@ -73,9 +75,13 @@
 #define VNC8B_REG	0xF4	/* Video n Coefficient Set C8B Register */
 #define VNC8C_REG	0xF8	/* Video n Coefficient Set C8C Register */
 
+/* Register offsets specific for Gen3 */
+#define VNCSI_IFMD_REG		0x20 /* Video n CSI2 Interface Mode Register */
 
 /* Register bit fields for R-Car VIN */
 /* Video n Main Control Register bits */
+#define VNMC_DPINE		(1 << 27) /* Gen3 specific */
+#define VNMC_SCLE		(1 << 26) /* Gen3 specific */
 #define VNMC_FOC		(1 << 21)
 #define VNMC_YCAL		(1 << 19)
 #define VNMC_INF_YUV8_BT656	(0 << 16)
@@ -119,6 +125,12 @@
 #define VNDMR2_FTEV		(1 << 17)
 #define VNDMR2_VLV(n)		((n & 0xf) << 12)
 
+/* Video n CSI2 Interface Mode Register (Gen3) */
+#define VNCSI_IFMD_DES1		(1 << 26)
+#define VNCSI_IFMD_DES0		(1 << 25)
+#define VNCSI_IFMD_CSI_CHSEL(n) (((n) & 0xf) << 0)
+#define VNCSI_IFMD_CSI_CHSEL_MASK 0xf
+
 struct rvin_buffer {
 	struct vb2_v4l2_buffer vb;
 	struct list_head list;
@@ -514,28 +526,10 @@ static void rvin_set_coeff(struct rvin_dev *vin, unsigned short xs)
 	rvin_write(vin, p_set->coeff_set[23], VNC8C_REG);
 }
 
-void rvin_crop_scale_comp(struct rvin_dev *vin)
+static void rvin_crop_scale_comp_gen2(struct rvin_dev *vin)
 {
 	u32 xs, ys;
 
-	/* Set Start/End Pixel/Line Pre-Clip */
-	rvin_write(vin, vin->crop.left, VNSPPRC_REG);
-	rvin_write(vin, vin->crop.left + vin->crop.width - 1, VNEPPRC_REG);
-	switch (vin->format.field) {
-	case V4L2_FIELD_INTERLACED:
-	case V4L2_FIELD_INTERLACED_TB:
-	case V4L2_FIELD_INTERLACED_BT:
-		rvin_write(vin, vin->crop.top / 2, VNSLPRC_REG);
-		rvin_write(vin, (vin->crop.top + vin->crop.height) / 2 - 1,
-			   VNELPRC_REG);
-		break;
-	default:
-		rvin_write(vin, vin->crop.top, VNSLPRC_REG);
-		rvin_write(vin, vin->crop.top + vin->crop.height - 1,
-			   VNELPRC_REG);
-		break;
-	}
-
 	/* Set scaling coefficient */
 	ys = 0;
 	if (vin->crop.height != vin->compose.height)
@@ -573,11 +567,6 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
 		break;
 	}
 
-	if (vin->format.pixelformat == V4L2_PIX_FMT_NV16)
-		rvin_write(vin, ALIGN(vin->format.width, 0x20), VNIS_REG);
-	else
-		rvin_write(vin, ALIGN(vin->format.width, 0x10), VNIS_REG);
-
 	vin_dbg(vin,
 		"Pre-Clip: %ux%u@%u:%u YS: %d XS: %d Post-Clip: %ux%u@%u:%u\n",
 		vin->crop.width, vin->crop.height, vin->crop.left,
@@ -585,6 +574,37 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
 		0, 0);
 }
 
+void rvin_crop_scale_comp(struct rvin_dev *vin)
+{
+	/* Set Start/End Pixel/Line Pre-Clip */
+	rvin_write(vin, vin->crop.left, VNSPPRC_REG);
+	rvin_write(vin, vin->crop.left + vin->crop.width - 1, VNEPPRC_REG);
+
+	switch (vin->format.field) {
+	case V4L2_FIELD_INTERLACED:
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+		rvin_write(vin, vin->crop.top / 2, VNSLPRC_REG);
+		rvin_write(vin, (vin->crop.top + vin->crop.height) / 2 - 1,
+			   VNELPRC_REG);
+		break;
+	default:
+		rvin_write(vin, vin->crop.top, VNSLPRC_REG);
+		rvin_write(vin, vin->crop.top + vin->crop.height - 1,
+			   VNELPRC_REG);
+		break;
+	}
+
+	/* TODO: Add support for the UDS scaler. */
+	if (vin->info->model != RCAR_GEN3)
+		rvin_crop_scale_comp_gen2(vin);
+
+	if (vin->format.pixelformat == V4L2_PIX_FMT_NV16)
+		rvin_write(vin, ALIGN(vin->format.width, 0x20), VNIS_REG);
+	else
+		rvin_write(vin, ALIGN(vin->format.width, 0x10), VNIS_REG);
+}
+
 /* -----------------------------------------------------------------------------
  * Hardware setup
  */
@@ -652,7 +672,10 @@ static int rvin_setup(struct rvin_dev *vin)
 	}
 
 	/* Enable VSYNC Field Toogle mode after one VSYNC input */
-	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
+	if (vin->info->model == RCAR_GEN3)
+		dmr2 = VNDMR2_FTEV;
+	else
+		dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
 
 	/* Hsync Signal Polarity Select */
 	if (!(vin->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
@@ -704,6 +727,14 @@ static int rvin_setup(struct rvin_dev *vin)
 	if (input_is_yuv == output_is_yuv)
 		vnmc |= VNMC_BPS;
 
+	if (vin->info->model == RCAR_GEN3) {
+		/* Select between CSI-2 and Digital input */
+		if (vin->mbus_cfg.type == V4L2_MBUS_CSI2)
+			vnmc &= ~VNMC_DPINE;
+		else
+			vnmc |= VNMC_DPINE;
+	}
+
 	/* Progressive or interlaced mode */
 	interrupts = progressive ? VNIE_FIE : VNIE_EFE;
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 952d57f32873388d..321283f1618ae0b9 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -33,6 +33,7 @@ enum model_id {
 	RCAR_H1,
 	RCAR_M1,
 	RCAR_GEN2,
+	RCAR_GEN3,
 };
 
 /**
-- 
2.16.2
