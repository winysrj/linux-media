Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:37085 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbeHAU7z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 16:59:55 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
Subject: [PATCH v3 03/14] gpu: ipu-csi: Swap fields according to input/output field types
Date: Wed,  1 Aug 2018 12:12:16 -0700
Message-Id: <1533150747-30677-4-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function ipu_csi_init_interface() was inverting the F-bit for
NTSC case, in the CCIR_CODE_1/2 registers. The result being that
for NTSC bottom-top field order, the CSI would swap fields and
capture in top-bottom order.

Instead, base field swap on the field order of the input to the CSI,
and the field order of the requested output. If the input/output
fields are sequential but different, swap fields, otherwise do
not swap. This requires passing both the input and output mbus
frame formats to ipu_csi_init_interface().

Move this code to a new private function ipu_csi_set_bt_interlaced_codes()
that programs the CCIR_CODE_1/2 registers for interlaced BT.656 (and
possibly interlaced BT.1120 in the future).

When detecting input video standard from the input frame width/height,
make sure to double height if input field type is alternate, since
in that case input height only includes lines for one field.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-csi.c              | 133 +++++++++++++++++++++---------
 drivers/staging/media/imx/imx-media-csi.c |  13 +--
 include/video/imx-ipu-v3.h                |   3 +-
 3 files changed, 98 insertions(+), 51 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
index 5450a2d..7a845c9 100644
--- a/drivers/gpu/ipu-v3/ipu-csi.c
+++ b/drivers/gpu/ipu-v3/ipu-csi.c
@@ -315,6 +315,15 @@ static int mbus_code_to_bus_cfg(struct ipu_csi_bus_config *cfg, u32 mbus_code)
 	return 0;
 }
 
+/* translate alternate field mode based on given standard */
+static inline enum v4l2_field
+ipu_csi_translate_field(enum v4l2_field field, v4l2_std_id std)
+{
+	return (field != V4L2_FIELD_ALTERNATE) ? field :
+		((std & V4L2_STD_525_60) ?
+		 V4L2_FIELD_SEQ_BT : V4L2_FIELD_SEQ_TB);
+}
+
 /*
  * Fill a CSI bus config struct from mbus_config and mbus_framefmt.
  */
@@ -358,19 +367,73 @@ static void fill_csi_bus_cfg(struct ipu_csi_bus_config *csicfg,
 	}
 }
 
+static int ipu_csi_set_bt_interlaced_codes(struct ipu_csi *csi,
+					   struct v4l2_mbus_framefmt *infmt,
+					   struct v4l2_mbus_framefmt *outfmt,
+					   v4l2_std_id std)
+{
+	enum v4l2_field infield, outfield;
+	bool swap_fields;
+
+	/* get translated field type of input and output */
+	infield = ipu_csi_translate_field(infmt->field, std);
+	outfield = ipu_csi_translate_field(outfmt->field, std);
+
+	/*
+	 * Write the H-V-F codes the CSI will match against the
+	 * incoming data for start/end of active and blanking
+	 * field intervals. If input and output field types are
+	 * sequential but not the same (one is SEQ_BT and the other
+	 * is SEQ_TB), swap the F-bit so that the CSI will capture
+	 * field 1 lines before field 0 lines.
+	 */
+	swap_fields = (V4L2_FIELD_IS_SEQUENTIAL(infield) &&
+		       V4L2_FIELD_IS_SEQUENTIAL(outfield) &&
+		       infield != outfield);
+
+	if (!swap_fields) {
+		/*
+		 * Field0BlankEnd  = 110, Field0BlankStart  = 010
+		 * Field0ActiveEnd = 100, Field0ActiveStart = 000
+		 * Field1BlankEnd  = 111, Field1BlankStart  = 011
+		 * Field1ActiveEnd = 101, Field1ActiveStart = 001
+		 */
+		ipu_csi_write(csi, 0x40596 | CSI_CCIR_ERR_DET_EN,
+			      CSI_CCIR_CODE_1);
+		ipu_csi_write(csi, 0xD07DF, CSI_CCIR_CODE_2);
+	} else {
+		dev_dbg(csi->ipu->dev, "capture field swap\n");
+
+		/* same as above but with F-bit inverted */
+		ipu_csi_write(csi, 0xD07DF | CSI_CCIR_ERR_DET_EN,
+			      CSI_CCIR_CODE_1);
+		ipu_csi_write(csi, 0x40596, CSI_CCIR_CODE_2);
+	}
+
+	ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
+
+	return 0;
+}
+
+
 int ipu_csi_init_interface(struct ipu_csi *csi,
 			   struct v4l2_mbus_config *mbus_cfg,
-			   struct v4l2_mbus_framefmt *mbus_fmt)
+			   struct v4l2_mbus_framefmt *infmt,
+			   struct v4l2_mbus_framefmt *outfmt)
 {
 	struct ipu_csi_bus_config cfg;
 	unsigned long flags;
 	u32 width, height, data = 0;
+	v4l2_std_id std;
+	int ret = 0;
 
-	fill_csi_bus_cfg(&cfg, mbus_cfg, mbus_fmt);
+	fill_csi_bus_cfg(&cfg, mbus_cfg, infmt);
 
 	/* set default sensor frame width and height */
-	width = mbus_fmt->width;
-	height = mbus_fmt->height;
+	width = infmt->width;
+	height = infmt->height;
+	if (infmt->field == V4L2_FIELD_ALTERNATE)
+		height *= 2;
 
 	/* Set the CSI_SENS_CONF register remaining fields */
 	data |= cfg.data_width << CSI_SENS_CONF_DATA_WIDTH_SHIFT |
@@ -397,42 +460,33 @@ int ipu_csi_init_interface(struct ipu_csi *csi,
 		ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
 		break;
 	case IPU_CSI_CLK_MODE_CCIR656_INTERLACED:
-		if (mbus_fmt->width == 720 && mbus_fmt->height == 576) {
-			/*
-			 * PAL case
-			 *
-			 * Field0BlankEnd = 0x6, Field0BlankStart = 0x2,
-			 * Field0ActiveEnd = 0x4, Field0ActiveStart = 0
-			 * Field1BlankEnd = 0x7, Field1BlankStart = 0x3,
-			 * Field1ActiveEnd = 0x5, Field1ActiveStart = 0x1
-			 */
-			height = 625; /* framelines for PAL */
-
-			ipu_csi_write(csi, 0x40596 | CSI_CCIR_ERR_DET_EN,
-					  CSI_CCIR_CODE_1);
-			ipu_csi_write(csi, 0xD07DF, CSI_CCIR_CODE_2);
-			ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
-		} else if (mbus_fmt->width == 720 && mbus_fmt->height == 480) {
-			/*
-			 * NTSC case
-			 *
-			 * Field0BlankEnd = 0x7, Field0BlankStart = 0x3,
-			 * Field0ActiveEnd = 0x5, Field0ActiveStart = 0x1
-			 * Field1BlankEnd = 0x6, Field1BlankStart = 0x2,
-			 * Field1ActiveEnd = 0x4, Field1ActiveStart = 0
-			 */
-			height = 525; /* framelines for NTSC */
-
-			ipu_csi_write(csi, 0xD07DF | CSI_CCIR_ERR_DET_EN,
-					  CSI_CCIR_CODE_1);
-			ipu_csi_write(csi, 0x40596, CSI_CCIR_CODE_2);
-			ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
-		} else {
+		std = V4L2_STD_UNKNOWN;
+		if (width == 720) {
+			switch (height) {
+			case 480:
+				std = V4L2_STD_NTSC;
+				break;
+			case 576:
+				std = V4L2_STD_PAL;
+				break;
+			default:
+				break;
+			}
+		}
+
+		if (std == V4L2_STD_UNKNOWN) {
 			dev_err(csi->ipu->dev,
-				"Unsupported CCIR656 interlaced video mode\n");
-			spin_unlock_irqrestore(&csi->lock, flags);
-			return -EINVAL;
+				"Unsupported interlaced video mode\n");
+			ret = -EINVAL;
+			goto out_unlock;
 		}
+
+		ret = ipu_csi_set_bt_interlaced_codes(csi, infmt, outfmt, std);
+		if (ret)
+			goto out_unlock;
+
+		/* framelines for NTSC / PAL */
+		height = (std & V4L2_STD_525_60) ? 525 : 625;
 		break;
 	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_DDR:
 	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_SDR:
@@ -457,9 +511,10 @@ int ipu_csi_init_interface(struct ipu_csi *csi,
 	dev_dbg(csi->ipu->dev, "CSI_ACT_FRM_SIZE = 0x%08X\n",
 		ipu_csi_read(csi, CSI_ACT_FRM_SIZE));
 
+out_unlock:
 	spin_unlock_irqrestore(&csi->lock, flags);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(ipu_csi_init_interface);
 
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 4647206..2fdd21d 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -663,7 +663,6 @@ static int csi_setup(struct csi_priv *priv)
 	struct v4l2_mbus_framefmt *infmt, *outfmt;
 	const struct imx_media_pixfmt *incc;
 	struct v4l2_mbus_config mbus_cfg;
-	struct v4l2_mbus_framefmt if_fmt;
 	struct v4l2_rect crop;
 
 	infmt = &priv->format_mbus[CSI_SINK_PAD];
@@ -676,22 +675,14 @@ static int csi_setup(struct csi_priv *priv)
 		priv->upstream_ep.bus.parallel.flags :
 		priv->upstream_ep.bus.mipi_csi2.flags;
 
-	/*
-	 * we need to pass input frame to CSI interface, but
-	 * with translated field type from output format
-	 */
-	if_fmt = *infmt;
-	if_fmt.field = outfmt->field;
 	crop = priv->crop;
 
 	/*
 	 * if cycles is set, we need to handle this over multiple cycles as
 	 * generic/bayer data
 	 */
-	if (is_parallel_bus(&priv->upstream_ep) && incc->cycles) {
-		if_fmt.width *= incc->cycles;
+	if (is_parallel_bus(&priv->upstream_ep) && incc->cycles)
 		crop.width *= incc->cycles;
-	}
 
 	ipu_csi_set_window(priv->csi, &crop);
 
@@ -699,7 +690,7 @@ static int csi_setup(struct csi_priv *priv)
 			     priv->crop.width == 2 * priv->compose.width,
 			     priv->crop.height == 2 * priv->compose.height);
 
-	ipu_csi_init_interface(priv->csi, &mbus_cfg, &if_fmt);
+	ipu_csi_init_interface(priv->csi, &mbus_cfg, infmt, outfmt);
 
 	ipu_csi_set_dest(priv->csi, priv->dest);
 
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index abbad94..f44a351 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -352,7 +352,8 @@ int ipu_prg_channel_configure(struct ipuv3_channel *ipu_chan,
 struct ipu_csi;
 int ipu_csi_init_interface(struct ipu_csi *csi,
 			   struct v4l2_mbus_config *mbus_cfg,
-			   struct v4l2_mbus_framefmt *mbus_fmt);
+			   struct v4l2_mbus_framefmt *infmt,
+			   struct v4l2_mbus_framefmt *outfmt);
 bool ipu_csi_is_interlaced(struct ipu_csi *csi);
 void ipu_csi_get_window(struct ipu_csi *csi, struct v4l2_rect *w);
 void ipu_csi_set_window(struct ipu_csi *csi, struct v4l2_rect *w);
-- 
2.7.4
