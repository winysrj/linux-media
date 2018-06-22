Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:46552 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933994AbeFVPeJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:34:09 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 25/32] media: camss: Format configuration per hardware version
Date: Fri, 22 Jun 2018 18:33:34 +0300
Message-Id: <1529681621-9682-26-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
References: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the 8x16 and 8x96 support different formats, separate the
arrays which contain the supported formats. For the VFE also
add separate arrays for RDI and PIX subdevices.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-csid.c   | 196 +++++++++++++++++++----
 drivers/media/platform/qcom/camss/camss-csid.h   |   2 +
 drivers/media/platform/qcom/camss/camss-csiphy.c | 145 ++++++++---------
 drivers/media/platform/qcom/camss/camss-csiphy.h |   2 +
 drivers/media/platform/qcom/camss/camss-ispif.c  |  43 ++++-
 drivers/media/platform/qcom/camss/camss-ispif.h  |   2 +
 drivers/media/platform/qcom/camss/camss-vfe.c    | 189 ++++++++++++----------
 drivers/media/platform/qcom/camss/camss-vfe.h    |   2 +
 drivers/media/platform/qcom/camss/camss-video.c  |  97 ++++++++++-
 9 files changed, 467 insertions(+), 211 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
index ff0e0d5..18420e3 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -62,7 +62,7 @@
 
 #define CSID_RESET_TIMEOUT_MS 500
 
-struct csid_fmts {
+struct csid_format {
 	u32 code;
 	u8 data_type;
 	u8 decode_format;
@@ -70,7 +70,7 @@ struct csid_fmts {
 	u8 spp; /* bus samples per pixel */
 };
 
-static const struct csid_fmts csid_input_fmts[] = {
+static const struct csid_format csid_formats_8x16[] = {
 	{
 		MEDIA_BUS_FMT_UYVY8_2X8,
 		DATA_TYPE_YUV422_8BIT,
@@ -185,17 +185,135 @@ static const struct csid_fmts csid_input_fmts[] = {
 	}
 };
 
-static const struct csid_fmts *csid_get_fmt_entry(u32 code)
+static const struct csid_format csid_formats_8x96[] = {
+	{
+		MEDIA_BUS_FMT_UYVY8_2X8,
+		DATA_TYPE_YUV422_8BIT,
+		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
+		8,
+		2,
+	},
+	{
+		MEDIA_BUS_FMT_VYUY8_2X8,
+		DATA_TYPE_YUV422_8BIT,
+		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
+		8,
+		2,
+	},
+	{
+		MEDIA_BUS_FMT_YUYV8_2X8,
+		DATA_TYPE_YUV422_8BIT,
+		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
+		8,
+		2,
+	},
+	{
+		MEDIA_BUS_FMT_YVYU8_2X8,
+		DATA_TYPE_YUV422_8BIT,
+		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
+		8,
+		2,
+	},
+	{
+		MEDIA_BUS_FMT_SBGGR8_1X8,
+		DATA_TYPE_RAW_8BIT,
+		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
+		8,
+		1,
+	},
+	{
+		MEDIA_BUS_FMT_SGBRG8_1X8,
+		DATA_TYPE_RAW_8BIT,
+		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
+		8,
+		1,
+	},
+	{
+		MEDIA_BUS_FMT_SGRBG8_1X8,
+		DATA_TYPE_RAW_8BIT,
+		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
+		8,
+		1,
+	},
+	{
+		MEDIA_BUS_FMT_SRGGB8_1X8,
+		DATA_TYPE_RAW_8BIT,
+		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
+		8,
+		1,
+	},
+	{
+		MEDIA_BUS_FMT_SBGGR10_1X10,
+		DATA_TYPE_RAW_10BIT,
+		DECODE_FORMAT_UNCOMPRESSED_10_BIT,
+		10,
+		1,
+	},
+	{
+		MEDIA_BUS_FMT_SGBRG10_1X10,
+		DATA_TYPE_RAW_10BIT,
+		DECODE_FORMAT_UNCOMPRESSED_10_BIT,
+		10,
+		1,
+	},
+	{
+		MEDIA_BUS_FMT_SGRBG10_1X10,
+		DATA_TYPE_RAW_10BIT,
+		DECODE_FORMAT_UNCOMPRESSED_10_BIT,
+		10,
+		1,
+	},
+	{
+		MEDIA_BUS_FMT_SRGGB10_1X10,
+		DATA_TYPE_RAW_10BIT,
+		DECODE_FORMAT_UNCOMPRESSED_10_BIT,
+		10,
+		1,
+	},
+	{
+		MEDIA_BUS_FMT_SBGGR12_1X12,
+		DATA_TYPE_RAW_12BIT,
+		DECODE_FORMAT_UNCOMPRESSED_12_BIT,
+		12,
+		1,
+	},
+	{
+		MEDIA_BUS_FMT_SGBRG12_1X12,
+		DATA_TYPE_RAW_12BIT,
+		DECODE_FORMAT_UNCOMPRESSED_12_BIT,
+		12,
+		1,
+	},
+	{
+		MEDIA_BUS_FMT_SGRBG12_1X12,
+		DATA_TYPE_RAW_12BIT,
+		DECODE_FORMAT_UNCOMPRESSED_12_BIT,
+		12,
+		1,
+	},
+	{
+		MEDIA_BUS_FMT_SRGGB12_1X12,
+		DATA_TYPE_RAW_12BIT,
+		DECODE_FORMAT_UNCOMPRESSED_12_BIT,
+		12,
+		1,
+	}
+};
+
+static const struct csid_format *csid_get_fmt_entry(
+					const struct csid_format *formats,
+					unsigned int nformat,
+					u32 code)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
-		if (code == csid_input_fmts[i].code)
-			return &csid_input_fmts[i];
+	for (i = 0; i < nformat; i++)
+		if (code == formats[i].code)
+			return &formats[i];
 
 	WARN(1, "Unknown format\n");
 
-	return &csid_input_fmts[0];
+	return &formats[0];
 }
 
 /*
@@ -242,10 +360,13 @@ static int csid_set_clock_rates(struct csid_device *csid)
 		    !strcmp(clock->name, "csi1") ||
 		    !strcmp(clock->name, "csi2") ||
 		    !strcmp(clock->name, "csi3")) {
-			u8 bpp = csid_get_fmt_entry(
-				csid->fmt[MSM_CSIPHY_PAD_SINK].code)->bpp;
+			const struct csid_format *f = csid_get_fmt_entry(
+				csid->formats,
+				csid->nformats,
+				csid->fmt[MSM_CSIPHY_PAD_SINK].code);
 			u8 num_lanes = csid->phy.lane_cnt;
-			u64 min_rate = pixel_clock * bpp / (2 * num_lanes * 4);
+			u64 min_rate = pixel_clock * f->bpp /
+							(2 * num_lanes * 4);
 			long rate;
 
 			camss_add_clock_margin(&min_rate);
@@ -401,9 +522,10 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 			/* Config Test Generator */
 			struct v4l2_mbus_framefmt *f =
 					&csid->fmt[MSM_CSID_PAD_SRC];
-			u8 bpp = csid_get_fmt_entry(f->code)->bpp;
-			u8 spp = csid_get_fmt_entry(f->code)->spp;
-			u32 num_bytes_per_line = f->width * bpp * spp / 8;
+			const struct csid_format *format = csid_get_fmt_entry(
+					csid->formats, csid->nformats, f->code);
+			u32 num_bytes_per_line =
+				f->width * format->bpp * format->spp / 8;
 			u32 num_lines = f->height;
 
 			/* 31:24 V blank, 23:13 H blank, 3:2 num of active DT */
@@ -419,8 +541,7 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 			writel_relaxed(val, csid->base +
 				       CAMSS_CSID_TG_DT_n_CGG_0(ver, 0));
 
-			dt = csid_get_fmt_entry(
-				csid->fmt[MSM_CSID_PAD_SRC].code)->data_type;
+			dt = format->data_type;
 
 			/* 5:0 data type */
 			val = dt;
@@ -432,9 +553,12 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 			writel_relaxed(val, csid->base +
 				       CAMSS_CSID_TG_DT_n_CGG_2(ver, 0));
 
-			df = csid_get_fmt_entry(
-				csid->fmt[MSM_CSID_PAD_SRC].code)->decode_format;
+			df = format->decode_format;
 		} else {
+			struct v4l2_mbus_framefmt *f =
+					&csid->fmt[MSM_CSID_PAD_SINK];
+			const struct csid_format *format = csid_get_fmt_entry(
+					csid->formats, csid->nformats, f->code);
 			struct csid_phy_config *phy = &csid->phy;
 
 			val = phy->lane_cnt - 1;
@@ -449,10 +573,8 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 			writel_relaxed(val,
 				       csid->base + CAMSS_CSID_CORE_CTRL_1);
 
-			dt = csid_get_fmt_entry(
-				csid->fmt[MSM_CSID_PAD_SINK].code)->data_type;
-			df = csid_get_fmt_entry(
-				csid->fmt[MSM_CSID_PAD_SINK].code)->decode_format;
+			dt = format->data_type;
+			df = format->decode_format;
 		}
 
 		/* Config LUT */
@@ -527,12 +649,12 @@ static void csid_try_format(struct csid_device *csid,
 	case MSM_CSID_PAD_SINK:
 		/* Set format on sink pad */
 
-		for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
-			if (fmt->code == csid_input_fmts[i].code)
+		for (i = 0; i < csid->nformats; i++)
+			if (fmt->code == csid->formats[i].code)
 				break;
 
 		/* If not found, use UYVY as default */
-		if (i >= ARRAY_SIZE(csid_input_fmts))
+		if (i >= csid->nformats)
 			fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 
 		fmt->width = clamp_t(u32, fmt->width, 1, 8191);
@@ -556,12 +678,12 @@ static void csid_try_format(struct csid_device *csid,
 			/* Test generator is enabled, set format on source*/
 			/* pad to allow test generator usage */
 
-			for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
-				if (csid_input_fmts[i].code == fmt->code)
+			for (i = 0; i < csid->nformats; i++)
+				if (csid->formats[i].code == fmt->code)
 					break;
 
 			/* If not found, use UYVY as default */
-			if (i >= ARRAY_SIZE(csid_input_fmts))
+			if (i >= csid->nformats)
 				fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 
 			fmt->width = clamp_t(u32, fmt->width, 1, 8191);
@@ -590,10 +712,10 @@ static int csid_enum_mbus_code(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *format;
 
 	if (code->pad == MSM_CSID_PAD_SINK) {
-		if (code->index >= ARRAY_SIZE(csid_input_fmts))
+		if (code->index >= csid->nformats)
 			return -EINVAL;
 
-		code->code = csid_input_fmts[code->index].code;
+		code->code = csid->formats[code->index].code;
 	} else {
 		if (csid->testgen_mode->cur.val == 0) {
 			if (code->index > 0)
@@ -604,10 +726,10 @@ static int csid_enum_mbus_code(struct v4l2_subdev *sd,
 
 			code->code = format->code;
 		} else {
-			if (code->index >= ARRAY_SIZE(csid_input_fmts))
+			if (code->index >= csid->nformats)
 				return -EINVAL;
 
-			code->code = csid_input_fmts[code->index].code;
+			code->code = csid->formats[code->index].code;
 		}
 	}
 
@@ -827,6 +949,18 @@ int msm_csid_subdev_init(struct camss *camss, struct csid_device *csid,
 	csid->camss = camss;
 	csid->id = id;
 
+	if (camss->version == CAMSS_8x16) {
+		csid->formats = csid_formats_8x16;
+		csid->nformats =
+				ARRAY_SIZE(csid_formats_8x16);
+	} else if (camss->version == CAMSS_8x96) {
+		csid->formats = csid_formats_8x96;
+		csid->nformats =
+				ARRAY_SIZE(csid_formats_8x96);
+	} else {
+		return -EINVAL;
+	}
+
 	/* Memory */
 
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, res->reg[0]);
diff --git a/drivers/media/platform/qcom/camss/camss-csid.h b/drivers/media/platform/qcom/camss/camss-csid.h
index ed605fd..1824b37 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.h
+++ b/drivers/media/platform/qcom/camss/camss-csid.h
@@ -58,6 +58,8 @@ struct csid_device {
 	struct v4l2_mbus_framefmt fmt[MSM_CSID_PADS_NUM];
 	struct v4l2_ctrl_handler ctrls;
 	struct v4l2_ctrl *testgen_mode;
+	const struct csid_format *formats;
+	unsigned int nformats;
 };
 
 struct resources;
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
index 2ee572a..8d2bcaa 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
@@ -26,93 +26,69 @@
 extern struct csiphy_hw_ops csiphy_ops_2ph_1_0;
 extern struct csiphy_hw_ops csiphy_ops_3ph_1_0;
 
-static const struct {
+struct csiphy_format {
 	u32 code;
 	u8 bpp;
-} csiphy_formats[] = {
-	{
-		MEDIA_BUS_FMT_UYVY8_2X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_VYUY8_2X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_YUYV8_2X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_YVYU8_2X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_SBGGR8_1X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_SGBRG8_1X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_SGRBG8_1X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_SRGGB8_1X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_SBGGR10_1X10,
-		10,
-	},
-	{
-		MEDIA_BUS_FMT_SGBRG10_1X10,
-		10,
-	},
-	{
-		MEDIA_BUS_FMT_SGRBG10_1X10,
-		10,
-	},
-	{
-		MEDIA_BUS_FMT_SRGGB10_1X10,
-		10,
-	},
-	{
-		MEDIA_BUS_FMT_SBGGR12_1X12,
-		12,
-	},
-	{
-		MEDIA_BUS_FMT_SGBRG12_1X12,
-		12,
-	},
-	{
-		MEDIA_BUS_FMT_SGRBG12_1X12,
-		12,
-	},
-	{
-		MEDIA_BUS_FMT_SRGGB12_1X12,
-		12,
-	}
+};
+
+static const struct csiphy_format csiphy_formats_8x16[] = {
+	{ MEDIA_BUS_FMT_UYVY8_2X8, 8 },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, 8 },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, 8 },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, 8 },
+	{ MEDIA_BUS_FMT_SBGGR8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SGBRG8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SGRBG8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SRGGB8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SBGGR10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SGBRG10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SGRBG10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SRGGB10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SBGGR12_1X12, 12 },
+	{ MEDIA_BUS_FMT_SGBRG12_1X12, 12 },
+	{ MEDIA_BUS_FMT_SGRBG12_1X12, 12 },
+	{ MEDIA_BUS_FMT_SRGGB12_1X12, 12 },
+};
+
+static const struct csiphy_format csiphy_formats_8x96[] = {
+	{ MEDIA_BUS_FMT_UYVY8_2X8, 8 },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, 8 },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, 8 },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, 8 },
+	{ MEDIA_BUS_FMT_SBGGR8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SGBRG8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SGRBG8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SRGGB8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SBGGR10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SGBRG10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SGRBG10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SRGGB10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SBGGR12_1X12, 12 },
+	{ MEDIA_BUS_FMT_SGBRG12_1X12, 12 },
+	{ MEDIA_BUS_FMT_SGRBG12_1X12, 12 },
+	{ MEDIA_BUS_FMT_SRGGB12_1X12, 12 },
 };
 
 /*
  * csiphy_get_bpp - map media bus format to bits per pixel
+ * @formats: supported media bus formats array
+ * @nformats: size of @formats array
  * @code: media bus format code
  *
  * Return number of bits per pixel
  */
-static u8 csiphy_get_bpp(u32 code)
+static u8 csiphy_get_bpp(const struct csiphy_format *formats,
+			 unsigned int nformats, u32 code)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(csiphy_formats); i++)
-		if (code == csiphy_formats[i].code)
-			return csiphy_formats[i].bpp;
+	for (i = 0; i < nformats; i++)
+		if (code == formats[i].code)
+			return formats[i].bpp;
 
 	WARN(1, "Unknown format\n");
 
-	return csiphy_formats[0].bpp;
+	return formats[0].bpp;
 }
 
 /*
@@ -136,7 +112,8 @@ static int csiphy_set_clock_rates(struct csiphy_device *csiphy)
 		if (!strcmp(clock->name, "csiphy0_timer") ||
 		    !strcmp(clock->name, "csiphy1_timer") ||
 		    !strcmp(clock->name, "csiphy2_timer")) {
-			u8 bpp = csiphy_get_bpp(
+			u8 bpp = csiphy_get_bpp(csiphy->formats,
+					csiphy->nformats,
 					csiphy->fmt[MSM_CSIPHY_PAD_SINK].code);
 			u8 num_lanes = csiphy->cfg.csi2->lane_cfg.num_data;
 			u64 min_rate = pixel_clock * bpp / (2 * num_lanes * 4);
@@ -253,7 +230,8 @@ static int csiphy_stream_on(struct csiphy_device *csiphy)
 	struct csiphy_config *cfg = &csiphy->cfg;
 	u32 pixel_clock;
 	u8 lane_mask = csiphy_get_lane_mask(&cfg->csi2->lane_cfg);
-	u8 bpp = csiphy_get_bpp(csiphy->fmt[MSM_CSIPHY_PAD_SINK].code);
+	u8 bpp = csiphy_get_bpp(csiphy->formats, csiphy->nformats,
+				csiphy->fmt[MSM_CSIPHY_PAD_SINK].code);
 	u8 val;
 	int ret;
 
@@ -358,12 +336,12 @@ static void csiphy_try_format(struct csiphy_device *csiphy,
 	case MSM_CSIPHY_PAD_SINK:
 		/* Set format on sink pad */
 
-		for (i = 0; i < ARRAY_SIZE(csiphy_formats); i++)
-			if (fmt->code == csiphy_formats[i].code)
+		for (i = 0; i < csiphy->nformats; i++)
+			if (fmt->code == csiphy->formats[i].code)
 				break;
 
 		/* If not found, use UYVY as default */
-		if (i >= ARRAY_SIZE(csiphy_formats))
+		if (i >= csiphy->nformats)
 			fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 
 		fmt->width = clamp_t(u32, fmt->width, 1, 8191);
@@ -399,10 +377,10 @@ static int csiphy_enum_mbus_code(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *format;
 
 	if (code->pad == MSM_CSIPHY_PAD_SINK) {
-		if (code->index >= ARRAY_SIZE(csiphy_formats))
+		if (code->index >= csiphy->nformats)
 			return -EINVAL;
 
-		code->code = csiphy_formats[code->index].code;
+		code->code = csiphy->formats[code->index].code;
 	} else {
 		if (code->index > 0)
 			return -EINVAL;
@@ -560,12 +538,17 @@ int msm_csiphy_subdev_init(struct camss *camss,
 	csiphy->id = id;
 	csiphy->cfg.combo_mode = 0;
 
-	if (camss->version == CAMSS_8x16)
+	if (camss->version == CAMSS_8x16) {
 		csiphy->ops = &csiphy_ops_2ph_1_0;
-	else if (camss->version == CAMSS_8x96)
+		csiphy->formats = csiphy_formats_8x16;
+		csiphy->nformats = ARRAY_SIZE(csiphy_formats_8x16);
+	} else if (camss->version == CAMSS_8x96) {
 		csiphy->ops = &csiphy_ops_3ph_1_0;
-	else
+		csiphy->formats = csiphy_formats_8x96;
+		csiphy->nformats = ARRAY_SIZE(csiphy_formats_8x96);
+	} else {
 		return -EINVAL;
+	}
 
 	/* Memory */
 
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.h b/drivers/media/platform/qcom/camss/camss-csiphy.h
index 07e5906..97834ac 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.h
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.h
@@ -71,6 +71,8 @@ struct csiphy_device {
 	struct csiphy_config cfg;
 	struct v4l2_mbus_framefmt fmt[MSM_CSIPHY_PADS_NUM];
 	struct csiphy_hw_ops *ops;
+	const struct csiphy_format *formats;
+	unsigned int nformats;
 };
 
 struct resources;
diff --git a/drivers/media/platform/qcom/camss/camss-ispif.c b/drivers/media/platform/qcom/camss/camss-ispif.c
index b124cd3..ed1cca0 100644
--- a/drivers/media/platform/qcom/camss/camss-ispif.c
+++ b/drivers/media/platform/qcom/camss/camss-ispif.c
@@ -96,7 +96,26 @@ enum ispif_intf_cmd {
 	CMD_ALL_NO_CHANGE = 0xffffffff,
 };
 
-static const u32 ispif_formats[] = {
+static const u32 ispif_formats_8x16[] = {
+	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_VYUY8_2X8,
+	MEDIA_BUS_FMT_YUYV8_2X8,
+	MEDIA_BUS_FMT_YVYU8_2X8,
+	MEDIA_BUS_FMT_SBGGR8_1X8,
+	MEDIA_BUS_FMT_SGBRG8_1X8,
+	MEDIA_BUS_FMT_SGRBG8_1X8,
+	MEDIA_BUS_FMT_SRGGB8_1X8,
+	MEDIA_BUS_FMT_SBGGR10_1X10,
+	MEDIA_BUS_FMT_SGBRG10_1X10,
+	MEDIA_BUS_FMT_SGRBG10_1X10,
+	MEDIA_BUS_FMT_SRGGB10_1X10,
+	MEDIA_BUS_FMT_SBGGR12_1X12,
+	MEDIA_BUS_FMT_SGBRG12_1X12,
+	MEDIA_BUS_FMT_SGRBG12_1X12,
+	MEDIA_BUS_FMT_SRGGB12_1X12,
+};
+
+static const u32 ispif_formats_8x96[] = {
 	MEDIA_BUS_FMT_UYVY8_2X8,
 	MEDIA_BUS_FMT_VYUY8_2X8,
 	MEDIA_BUS_FMT_YUYV8_2X8,
@@ -775,12 +794,12 @@ static void ispif_try_format(struct ispif_line *line,
 	case MSM_ISPIF_PAD_SINK:
 		/* Set format on sink pad */
 
-		for (i = 0; i < ARRAY_SIZE(ispif_formats); i++)
-			if (fmt->code == ispif_formats[i])
+		for (i = 0; i < line->nformats; i++)
+			if (fmt->code == line->formats[i])
 				break;
 
 		/* If not found, use UYVY as default */
-		if (i >= ARRAY_SIZE(ispif_formats))
+		if (i >= line->nformats)
 			fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 
 		fmt->width = clamp_t(u32, fmt->width, 1, 8191);
@@ -818,10 +837,10 @@ static int ispif_enum_mbus_code(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *format;
 
 	if (code->pad == MSM_ISPIF_PAD_SINK) {
-		if (code->index >= ARRAY_SIZE(ispif_formats))
+		if (code->index >= line->nformats)
 			return -EINVAL;
 
-		code->code = ispif_formats[code->index];
+		code->code = line->formats[code->index];
 	} else {
 		if (code->index > 0)
 			return -EINVAL;
@@ -988,6 +1007,18 @@ int msm_ispif_subdev_init(struct ispif_device *ispif,
 	for (i = 0; i < ispif->line_num; i++) {
 		ispif->line[i].ispif = ispif;
 		ispif->line[i].id = i;
+
+		if (to_camss(ispif)->version == CAMSS_8x16) {
+			ispif->line[i].formats = ispif_formats_8x16;
+			ispif->line[i].nformats =
+					ARRAY_SIZE(ispif_formats_8x16);
+		} else if (to_camss(ispif)->version == CAMSS_8x96) {
+			ispif->line[i].formats = ispif_formats_8x96;
+			ispif->line[i].nformats =
+					ARRAY_SIZE(ispif_formats_8x96);
+		} else {
+			return -EINVAL;
+		}
 	}
 
 	/* Memory */
diff --git a/drivers/media/platform/qcom/camss/camss-ispif.h b/drivers/media/platform/qcom/camss/camss-ispif.h
index 5800510..5aa9884 100644
--- a/drivers/media/platform/qcom/camss/camss-ispif.h
+++ b/drivers/media/platform/qcom/camss/camss-ispif.h
@@ -43,6 +43,8 @@ struct ispif_line {
 	struct v4l2_subdev subdev;
 	struct media_pad pads[MSM_ISPIF_PADS_NUM];
 	struct v4l2_mbus_framefmt fmt[MSM_ISPIF_PADS_NUM];
+	const u32 *formats;
+	unsigned int nformats;
 };
 
 struct ispif_device {
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 7356a81..6fc2be5 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -48,93 +48,83 @@
 extern struct vfe_hw_ops vfe_ops_4_1;
 extern struct vfe_hw_ops vfe_ops_4_7;
 
-static const struct {
+struct vfe_format {
 	u32 code;
 	u8 bpp;
-} vfe_formats[] = {
-	{
-		MEDIA_BUS_FMT_UYVY8_2X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_VYUY8_2X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_YUYV8_2X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_YVYU8_2X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_SBGGR8_1X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_SGBRG8_1X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_SGRBG8_1X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_SRGGB8_1X8,
-		8,
-	},
-	{
-		MEDIA_BUS_FMT_SBGGR10_1X10,
-		10,
-	},
-	{
-		MEDIA_BUS_FMT_SGBRG10_1X10,
-		10,
-	},
-	{
-		MEDIA_BUS_FMT_SGRBG10_1X10,
-		10,
-	},
-	{
-		MEDIA_BUS_FMT_SRGGB10_1X10,
-		10,
-	},
-	{
-		MEDIA_BUS_FMT_SBGGR12_1X12,
-		12,
-	},
-	{
-		MEDIA_BUS_FMT_SGBRG12_1X12,
-		12,
-	},
-	{
-		MEDIA_BUS_FMT_SGRBG12_1X12,
-		12,
-	},
-	{
-		MEDIA_BUS_FMT_SRGGB12_1X12,
-		12,
-	}
+};
+
+static const struct vfe_format formats_rdi_8x16[] = {
+	{ MEDIA_BUS_FMT_UYVY8_2X8, 8 },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, 8 },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, 8 },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, 8 },
+	{ MEDIA_BUS_FMT_SBGGR8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SGBRG8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SGRBG8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SRGGB8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SBGGR10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SGBRG10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SGRBG10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SRGGB10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SBGGR12_1X12, 12 },
+	{ MEDIA_BUS_FMT_SGBRG12_1X12, 12 },
+	{ MEDIA_BUS_FMT_SGRBG12_1X12, 12 },
+	{ MEDIA_BUS_FMT_SRGGB12_1X12, 12 },
+};
+
+static const struct vfe_format formats_pix_8x16[] = {
+	{ MEDIA_BUS_FMT_UYVY8_2X8, 8 },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, 8 },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, 8 },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, 8 },
+};
+
+static const struct vfe_format formats_rdi_8x96[] = {
+	{ MEDIA_BUS_FMT_UYVY8_2X8, 8 },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, 8 },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, 8 },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, 8 },
+	{ MEDIA_BUS_FMT_SBGGR8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SGBRG8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SGRBG8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SRGGB8_1X8, 8 },
+	{ MEDIA_BUS_FMT_SBGGR10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SGBRG10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SGRBG10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SRGGB10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SBGGR12_1X12, 12 },
+	{ MEDIA_BUS_FMT_SGBRG12_1X12, 12 },
+	{ MEDIA_BUS_FMT_SGRBG12_1X12, 12 },
+	{ MEDIA_BUS_FMT_SRGGB12_1X12, 12 },
+};
+
+static const struct vfe_format formats_pix_8x96[] = {
+	{ MEDIA_BUS_FMT_UYVY8_2X8, 8 },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, 8 },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, 8 },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, 8 },
 };
 
 /*
  * vfe_get_bpp - map media bus format to bits per pixel
+ * @formats: supported media bus formats array
+ * @nformats: size of @formats array
  * @code: media bus format code
  *
  * Return number of bits per pixel
  */
-static u8 vfe_get_bpp(u32 code)
+static u8 vfe_get_bpp(const struct vfe_format *formats,
+		      unsigned int nformats, u32 code)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(vfe_formats); i++)
-		if (code == vfe_formats[i].code)
-			return vfe_formats[i].bpp;
+	for (i = 0; i < nformats; i++)
+		if (code == formats[i].code)
+			return formats[i].bpp;
 
 	WARN(1, "Unknown format\n");
 
-	return vfe_formats[0].bpp;
+	return formats[0].bpp;
 }
 
 /*
@@ -981,8 +971,11 @@ static int vfe_set_clock_rates(struct vfe_device *vfe)
 				if (j == VFE_LINE_PIX) {
 					tmp = pixel_clock[j];
 				} else {
-					bpp = vfe_get_bpp(vfe->line[j].
-						fmt[MSM_VFE_PAD_SINK].code);
+					struct vfe_line *l = &vfe->line[j];
+
+					bpp = vfe_get_bpp(l->formats,
+						l->nformats,
+						l->fmt[MSM_VFE_PAD_SINK].code);
 					tmp = pixel_clock[j] * bpp / 64;
 				}
 
@@ -1060,8 +1053,11 @@ static int vfe_check_clock_rates(struct vfe_device *vfe)
 				if (j == VFE_LINE_PIX) {
 					tmp = pixel_clock[j];
 				} else {
-					bpp = vfe_get_bpp(vfe->line[j].
-						fmt[MSM_VFE_PAD_SINK].code);
+					struct vfe_line *l = &vfe->line[j];
+
+					bpp = vfe_get_bpp(l->formats,
+						l->nformats,
+						l->fmt[MSM_VFE_PAD_SINK].code);
 					tmp = pixel_clock[j] * bpp / 64;
 				}
 
@@ -1373,12 +1369,12 @@ static void vfe_try_format(struct vfe_line *line,
 	case MSM_VFE_PAD_SINK:
 		/* Set format on sink pad */
 
-		for (i = 0; i < ARRAY_SIZE(vfe_formats); i++)
-			if (fmt->code == vfe_formats[i].code)
+		for (i = 0; i < line->nformats; i++)
+			if (fmt->code == line->formats[i].code)
 				break;
 
 		/* If not found, use UYVY as default */
-		if (i >= ARRAY_SIZE(vfe_formats))
+		if (i >= line->nformats)
 			fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 
 		fmt->width = clamp_t(u32, fmt->width, 1, 8191);
@@ -1538,10 +1534,10 @@ static int vfe_enum_mbus_code(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *format;
 
 	if (code->pad == MSM_VFE_PAD_SINK) {
-		if (code->index >= ARRAY_SIZE(vfe_formats))
+		if (code->index >= line->nformats)
 			return -EINVAL;
 
-		code->code = vfe_formats[code->index].code;
+		code->code = line->formats[code->index].code;
 	} else {
 		if (code->index > 0)
 			return -EINVAL;
@@ -1942,12 +1938,33 @@ int msm_vfe_subdev_init(struct camss *camss, struct vfe_device *vfe,
 	vfe->reg_update = 0;
 
 	for (i = VFE_LINE_RDI0; i <= VFE_LINE_PIX; i++) {
-		vfe->line[i].video_out.type =
-					V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-		vfe->line[i].video_out.camss = camss;
-		vfe->line[i].id = i;
-		init_completion(&vfe->line[i].output.sof);
-		init_completion(&vfe->line[i].output.reg_update);
+		struct vfe_line *l = &vfe->line[i];
+
+		l->video_out.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		l->video_out.camss = camss;
+		l->id = i;
+		init_completion(&l->output.sof);
+		init_completion(&l->output.reg_update);
+
+		if (camss->version == CAMSS_8x16) {
+			if (i == VFE_LINE_PIX) {
+				l->formats = formats_pix_8x16;
+				l->nformats = ARRAY_SIZE(formats_pix_8x16);
+			} else {
+				l->formats = formats_rdi_8x16;
+				l->nformats = ARRAY_SIZE(formats_rdi_8x16);
+			}
+		} else if (camss->version == CAMSS_8x96) {
+			if (i == VFE_LINE_PIX) {
+				l->formats = formats_pix_8x96;
+				l->nformats = ARRAY_SIZE(formats_pix_8x96);
+			} else {
+				l->formats = formats_rdi_8x96;
+				l->nformats = ARRAY_SIZE(formats_rdi_8x96);
+			}
+		} else {
+			return -EINVAL;
+		}
 	}
 
 	init_completion(&vfe->reset_complete);
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.h b/drivers/media/platform/qcom/camss/camss-vfe.h
index bb09ed9..764b734 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.h
+++ b/drivers/media/platform/qcom/camss/camss-vfe.h
@@ -71,6 +71,8 @@ struct vfe_line {
 	struct v4l2_rect crop;
 	struct camss_video video_out;
 	struct vfe_output output;
+	const struct vfe_format *formats;
+	unsigned int nformats;
 };
 
 struct vfe_device;
diff --git a/drivers/media/platform/qcom/camss/camss-video.c b/drivers/media/platform/qcom/camss/camss-video.c
index 16e74b2..ba7d0c4 100644
--- a/drivers/media/platform/qcom/camss/camss-video.c
+++ b/drivers/media/platform/qcom/camss/camss-video.c
@@ -41,7 +41,7 @@ struct camss_format_info {
 	unsigned int bpp[3];
 };
 
-static const struct camss_format_info formats_rdi[] = {
+static const struct camss_format_info formats_rdi_8x16[] = {
 	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_PIX_FMT_UYVY, 1,
 	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
 	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_PIX_FMT_VYUY, 1,
@@ -76,7 +76,77 @@ static const struct camss_format_info formats_rdi[] = {
 	  { { 1, 1 } }, { { 1, 1 } }, { 12 } },
 };
 
-static const struct camss_format_info formats_pix[] = {
+static const struct camss_format_info formats_rdi_8x96[] = {
+	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_PIX_FMT_UYVY, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_PIX_FMT_VYUY, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_PIX_FMT_YUYV, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_PIX_FMT_YVYU, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
+	{ MEDIA_BUS_FMT_SBGGR8_1X8, V4L2_PIX_FMT_SBGGR8, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 8 } },
+	{ MEDIA_BUS_FMT_SGBRG8_1X8, V4L2_PIX_FMT_SGBRG8, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 8 } },
+	{ MEDIA_BUS_FMT_SGRBG8_1X8, V4L2_PIX_FMT_SGRBG8, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 8 } },
+	{ MEDIA_BUS_FMT_SRGGB8_1X8, V4L2_PIX_FMT_SRGGB8, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 8 } },
+	{ MEDIA_BUS_FMT_SBGGR10_1X10, V4L2_PIX_FMT_SBGGR10P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 10 } },
+	{ MEDIA_BUS_FMT_SGBRG10_1X10, V4L2_PIX_FMT_SGBRG10P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 10 } },
+	{ MEDIA_BUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 10 } },
+	{ MEDIA_BUS_FMT_SRGGB10_1X10, V4L2_PIX_FMT_SRGGB10P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 10 } },
+	{ MEDIA_BUS_FMT_SBGGR12_1X12, V4L2_PIX_FMT_SBGGR12P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 12 } },
+	{ MEDIA_BUS_FMT_SGBRG12_1X12, V4L2_PIX_FMT_SGBRG12P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 12 } },
+	{ MEDIA_BUS_FMT_SGRBG12_1X12, V4L2_PIX_FMT_SGRBG12P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 12 } },
+	{ MEDIA_BUS_FMT_SRGGB12_1X12, V4L2_PIX_FMT_SRGGB12P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 12 } },
+};
+
+static const struct camss_format_info formats_pix_8x16[] = {
+	{ MEDIA_BUS_FMT_YUYV8_1_5X8, V4L2_PIX_FMT_NV12, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_YVYU8_1_5X8, V4L2_PIX_FMT_NV12, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_UYVY8_1_5X8, V4L2_PIX_FMT_NV12, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_VYUY8_1_5X8, V4L2_PIX_FMT_NV12, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_YUYV8_1_5X8, V4L2_PIX_FMT_NV21, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_YVYU8_1_5X8, V4L2_PIX_FMT_NV21, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_UYVY8_1_5X8, V4L2_PIX_FMT_NV21, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_VYUY8_1_5X8, V4L2_PIX_FMT_NV21, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_PIX_FMT_NV16, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_PIX_FMT_NV16, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_PIX_FMT_NV16, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_PIX_FMT_NV16, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_PIX_FMT_NV61, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_PIX_FMT_NV61, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_PIX_FMT_NV61, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_PIX_FMT_NV61, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+};
+
+static const struct camss_format_info formats_pix_8x96[] = {
 	{ MEDIA_BUS_FMT_YUYV8_1_5X8, V4L2_PIX_FMT_NV12, 1,
 	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
 	{ MEDIA_BUS_FMT_YVYU8_1_5X8, V4L2_PIX_FMT_NV12, 1,
@@ -790,11 +860,24 @@ int msm_video_register(struct camss_video *video, struct v4l2_device *v4l2_dev,
 
 	mutex_init(&video->lock);
 
-	video->formats = formats_rdi;
-	video->nformats = ARRAY_SIZE(formats_rdi);
-	if (is_pix) {
-		video->formats = formats_pix;
-		video->nformats = ARRAY_SIZE(formats_pix);
+	if (video->camss->version == CAMSS_8x16) {
+		if (is_pix) {
+			video->formats = formats_pix_8x16;
+			video->nformats = ARRAY_SIZE(formats_pix_8x16);
+		} else {
+			video->formats = formats_rdi_8x16;
+			video->nformats = ARRAY_SIZE(formats_rdi_8x16);
+		}
+	} else if (video->camss->version == CAMSS_8x96) {
+		if (is_pix) {
+			video->formats = formats_pix_8x96;
+			video->nformats = ARRAY_SIZE(formats_pix_8x96);
+		} else {
+			video->formats = formats_rdi_8x96;
+			video->nformats = ARRAY_SIZE(formats_rdi_8x96);
+		}
+	} else {
+		goto error_video_register;
 	}
 
 	ret = msm_video_init_format(video);
-- 
2.7.4
