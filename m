Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:40335 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752360AbdHHNbB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 09:31:01 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 20/21] camss: Use optimal clock frequency rates
Date: Tue,  8 Aug 2017 16:30:17 +0300
Message-Id: <1502199018-28250-21-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use standard V4L2 control to get pixel clock rate from a sensor
linked in the media controller pipeline. Then calculate clock
rates on CSIPHY, CSID and VFE to use the lowest possible.

If the currnet pixel clock rate of the sensor cannot be read then
use the highest possible. This case covers also the CSID test
generator usage.

If VFE is already powered on by another pipeline, check that the
current VFE clock rate is high enough for the new pipeline.
If not return busy error code as VFE clock rate cannot be changed
while VFE is running.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 .../media/platform/qcom/camss-8x16/camss-csid.c    | 139 ++++++++--
 .../media/platform/qcom/camss-8x16/camss-csid.h    |   2 +-
 .../media/platform/qcom/camss-8x16/camss-csiphy.c  | 113 ++++++--
 .../media/platform/qcom/camss-8x16/camss-csiphy.h  |   2 +-
 .../media/platform/qcom/camss-8x16/camss-ispif.c   |  23 +-
 .../media/platform/qcom/camss-8x16/camss-ispif.h   |   4 +-
 drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 289 ++++++++++++++++++---
 drivers/media/platform/qcom/camss-8x16/camss-vfe.h |   2 +-
 drivers/media/platform/qcom/camss-8x16/camss.c     |  67 ++++-
 drivers/media/platform/qcom/camss-8x16/camss.h     |  15 +-
 10 files changed, 547 insertions(+), 109 deletions(-)

diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csid.c b/drivers/media/platform/qcom/camss-8x16/camss-csid.c
index 5c09e83..792c14a 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-csid.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-csid.c
@@ -69,6 +69,7 @@ struct csid_fmts {
 	u8 data_type;
 	u8 decode_format;
 	u8 bpp;
+	u8 spp; /* bus samples per pixel */
 };
 
 static const struct csid_fmts csid_input_fmts[] = {
@@ -76,97 +77,113 @@ static const struct csid_fmts csid_input_fmts[] = {
 		MEDIA_BUS_FMT_UYVY8_2X8,
 		DATA_TYPE_YUV422_8BIT,
 		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
-		16,
+		8,
+		2,
 	},
 	{
 		MEDIA_BUS_FMT_VYUY8_2X8,
 		DATA_TYPE_YUV422_8BIT,
 		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
-		16,
+		8,
+		2,
 	},
 	{
 		MEDIA_BUS_FMT_YUYV8_2X8,
 		DATA_TYPE_YUV422_8BIT,
 		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
-		16,
+		8,
+		2,
 	},
 	{
 		MEDIA_BUS_FMT_YVYU8_2X8,
 		DATA_TYPE_YUV422_8BIT,
 		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
-		16,
+		8,
+		2,
 	},
 	{
 		MEDIA_BUS_FMT_SBGGR8_1X8,
 		DATA_TYPE_RAW_8BIT,
 		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
 		8,
+		1,
 	},
 	{
 		MEDIA_BUS_FMT_SGBRG8_1X8,
 		DATA_TYPE_RAW_8BIT,
 		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
 		8,
+		1,
 	},
 	{
 		MEDIA_BUS_FMT_SGRBG8_1X8,
 		DATA_TYPE_RAW_8BIT,
 		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
 		8,
+		1,
 	},
 	{
 		MEDIA_BUS_FMT_SRGGB8_1X8,
 		DATA_TYPE_RAW_8BIT,
 		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
 		8,
+		1,
 	},
 	{
 		MEDIA_BUS_FMT_SBGGR10_1X10,
 		DATA_TYPE_RAW_10BIT,
 		DECODE_FORMAT_UNCOMPRESSED_10_BIT,
 		10,
+		1,
 	},
 	{
 		MEDIA_BUS_FMT_SGBRG10_1X10,
 		DATA_TYPE_RAW_10BIT,
 		DECODE_FORMAT_UNCOMPRESSED_10_BIT,
 		10,
+		1,
 	},
 	{
 		MEDIA_BUS_FMT_SGRBG10_1X10,
 		DATA_TYPE_RAW_10BIT,
 		DECODE_FORMAT_UNCOMPRESSED_10_BIT,
 		10,
+		1,
 	},
 	{
 		MEDIA_BUS_FMT_SRGGB10_1X10,
 		DATA_TYPE_RAW_10BIT,
 		DECODE_FORMAT_UNCOMPRESSED_10_BIT,
 		10,
+		1,
 	},
 	{
 		MEDIA_BUS_FMT_SBGGR12_1X12,
 		DATA_TYPE_RAW_12BIT,
 		DECODE_FORMAT_UNCOMPRESSED_12_BIT,
 		12,
+		1,
 	},
 	{
 		MEDIA_BUS_FMT_SGBRG12_1X12,
 		DATA_TYPE_RAW_12BIT,
 		DECODE_FORMAT_UNCOMPRESSED_12_BIT,
 		12,
+		1,
 	},
 	{
 		MEDIA_BUS_FMT_SGRBG12_1X12,
 		DATA_TYPE_RAW_12BIT,
 		DECODE_FORMAT_UNCOMPRESSED_12_BIT,
 		12,
+		1,
 	},
 	{
 		MEDIA_BUS_FMT_SRGGB12_1X12,
 		DATA_TYPE_RAW_12BIT,
 		DECODE_FORMAT_UNCOMPRESSED_12_BIT,
 		12,
+		1,
 	}
 };
 
@@ -205,6 +222,67 @@ static irqreturn_t csid_isr(int irq, void *dev)
 }
 
 /*
+ * csid_set_clock_rates - Calculate and set clock rates on CSID module
+ * @csiphy: CSID device
+ */
+static int csid_set_clock_rates(struct csid_device *csid)
+{
+	struct device *dev = to_device_index(csid, csid->id);
+	u32 pixel_clock;
+	int i, j;
+	int ret;
+
+	ret = camss_get_pixel_clock(&csid->subdev.entity, &pixel_clock);
+	if (ret)
+		pixel_clock = 0;
+
+	for (i = 0; i < csid->nclocks; i++) {
+		struct camss_clock *clock = &csid->clock[i];
+
+		if (!strcmp(clock->name, "csi0") ||
+			!strcmp(clock->name, "csi1")) {
+			u8 bpp = csid_get_fmt_entry(
+				csid->fmt[MSM_CSIPHY_PAD_SINK].code)->bpp;
+			u8 num_lanes = csid->phy.lane_cnt;
+			u64 min_rate = pixel_clock * bpp / (2 * num_lanes * 4);
+			long rate;
+
+			camss_add_clock_margin(&min_rate);
+
+			for (j = 0; j < clock->nfreqs; j++)
+				if (min_rate < clock->freq[j])
+					break;
+
+			if (j == clock->nfreqs) {
+				dev_err(dev,
+					"Pixel clock is too high for CSID\n");
+				return -EINVAL;
+			}
+
+			/* if sensor pixel clock is not available */
+			/* set highest possible CSID clock rate */
+			if (min_rate == 0)
+				j = clock->nfreqs - 1;
+
+			rate = clk_round_rate(clock->clk, clock->freq[j]);
+			if (rate < 0) {
+				dev_err(dev, "clk round rate failed: %ld\n",
+					rate);
+				return -EINVAL;
+			}
+
+			ret = clk_set_rate(clock->clk, rate);
+			if (ret < 0) {
+				dev_err(dev, "clk set rate failed: %d\n", ret);
+				return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
  * csid_reset - Trigger reset on CSID module and wait to complete
  * @csid: CSID device
  *
@@ -249,6 +327,12 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
 		if (ret < 0)
 			return ret;
 
+		ret = csid_set_clock_rates(csid);
+		if (ret < 0) {
+			regulator_disable(csid->vdda);
+			return ret;
+		}
+
 		ret = camss_enable_clocks(csid->nclocks, csid->clock, dev);
 		if (ret < 0) {
 			regulator_disable(csid->vdda);
@@ -316,7 +400,8 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 			struct v4l2_mbus_framefmt *f =
 					&csid->fmt[MSM_CSID_PAD_SRC];
 			u8 bpp = csid_get_fmt_entry(f->code)->bpp;
-			u32 num_bytes_per_line = f->width * bpp / 8;
+			u8 spp = csid_get_fmt_entry(f->code)->spp;
+			u32 num_bytes_per_line = f->width * bpp * spp / 8;
 			u32 num_lines = f->height;
 
 			/* 31:24 V blank, 23:13 H blank, 3:2 num of active DT */
@@ -719,7 +804,7 @@ int msm_csid_subdev_init(struct csid_device *csid,
 	struct device *dev = to_device_index(csid, id);
 	struct platform_device *pdev = to_platform_device(dev);
 	struct resource *r;
-	int i;
+	int i, j;
 	int ret;
 
 	csid->id = id;
@@ -766,26 +851,30 @@ int msm_csid_subdev_init(struct csid_device *csid,
 		return -ENOMEM;
 
 	for (i = 0; i < csid->nclocks; i++) {
-		csid->clock[i] = devm_clk_get(dev, res->clock[i]);
-		if (IS_ERR(csid->clock[i]))
-			return PTR_ERR(csid->clock[i]);
-
-		if (res->clock_rate[i]) {
-			long clk_rate = clk_round_rate(csid->clock[i],
-						       res->clock_rate[i]);
-			if (clk_rate < 0) {
-				dev_err(to_device_index(csid, csid->id),
-					"clk round rate failed: %ld\n",
-					clk_rate);
-				return -EINVAL;
-			}
-			ret = clk_set_rate(csid->clock[i], clk_rate);
-			if (ret < 0) {
-				dev_err(to_device_index(csid, csid->id),
-					"clk set rate failed: %d\n", ret);
-				return ret;
-			}
+		struct camss_clock *clock = &csid->clock[i];
+
+		clock->clk = devm_clk_get(dev, res->clock[i]);
+		if (IS_ERR(clock->clk))
+			return PTR_ERR(clock->clk);
+
+		clock->name = res->clock[i];
+
+		clock->nfreqs = 0;
+		while (res->clock_rate[i][clock->nfreqs])
+			clock->nfreqs++;
+
+		if (!clock->nfreqs) {
+			clock->freq = NULL;
+			continue;
 		}
+
+		clock->freq = devm_kzalloc(dev, clock->nfreqs *
+					   sizeof(*clock->freq), GFP_KERNEL);
+		if (!clock->freq)
+			return -ENOMEM;
+
+		for (j = 0; j < clock->nfreqs; j++)
+			clock->freq[j] = res->clock_rate[i][j];
 	}
 
 	/* Regulator */
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csid.h b/drivers/media/platform/qcom/camss-8x16/camss-csid.h
index 3186c11..4df7018 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-csid.h
+++ b/drivers/media/platform/qcom/camss-8x16/camss-csid.h
@@ -56,7 +56,7 @@ struct csid_device {
 	void __iomem *base;
 	u32 irq;
 	char irq_name[30];
-	struct clk **clock;
+	struct camss_clock *clock;
 	int nclocks;
 	struct regulator *vdda;
 	struct completion reset_complete;
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csiphy.c b/drivers/media/platform/qcom/camss-8x16/camss-csiphy.c
index ed03775..e9040b1 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-csiphy.c
@@ -158,6 +158,69 @@ static irqreturn_t csiphy_isr(int irq, void *dev)
 }
 
 /*
+ * csiphy_set_clock_rates - Calculate and set clock rates on CSIPHY module
+ * @csiphy: CSIPHY device
+ */
+static int csiphy_set_clock_rates(struct csiphy_device *csiphy)
+{
+	struct device *dev = to_device_index(csiphy, csiphy->id);
+	u32 pixel_clock;
+	int i, j;
+	int ret;
+
+	ret = camss_get_pixel_clock(&csiphy->subdev.entity, &pixel_clock);
+	if (ret)
+		pixel_clock = 0;
+
+	for (i = 0; i < csiphy->nclocks; i++) {
+		struct camss_clock *clock = &csiphy->clock[i];
+
+		if (!strcmp(clock->name, "csiphy0_timer") ||
+			!strcmp(clock->name, "csiphy1_timer")) {
+			u8 bpp = csiphy_get_bpp(
+					csiphy->fmt[MSM_CSIPHY_PAD_SINK].code);
+			u8 num_lanes = csiphy->cfg.csi2->lane_cfg.num_data;
+			u64 min_rate = pixel_clock * bpp / (2 * num_lanes * 4);
+			long round_rate;
+
+			camss_add_clock_margin(&min_rate);
+
+			for (j = 0; j < clock->nfreqs; j++)
+				if (min_rate < clock->freq[j])
+					break;
+
+			if (j == clock->nfreqs) {
+				dev_err(dev,
+					"Pixel clock is too high for CSIPHY\n");
+				return -EINVAL;
+			}
+
+			/* if sensor pixel clock is not available */
+			/* set highest possible CSIPHY clock rate */
+			if (min_rate == 0)
+				j = clock->nfreqs - 1;
+
+			round_rate = clk_round_rate(clock->clk, clock->freq[j]);
+			if (round_rate < 0) {
+				dev_err(dev, "clk round rate failed: %ld\n",
+					round_rate);
+				return -EINVAL;
+			}
+
+			csiphy->timer_clk_rate = round_rate;
+
+			ret = clk_set_rate(clock->clk, csiphy->timer_clk_rate);
+			if (ret < 0) {
+				dev_err(dev, "clk set rate failed: %d\n", ret);
+				return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
  * csiphy_reset - Perform software reset on CSIPHY module
  * @csiphy: CSIPHY device
  */
@@ -184,6 +247,10 @@ static int csiphy_set_power(struct v4l2_subdev *sd, int on)
 		u8 hw_version;
 		int ret;
 
+		ret = csiphy_set_clock_rates(csiphy);
+		if (ret < 0)
+			return ret;
+
 		ret = camss_enable_clocks(csiphy->nclocks, csiphy->clock, dev);
 		if (ret < 0)
 			return ret;
@@ -616,7 +683,7 @@ int msm_csiphy_subdev_init(struct csiphy_device *csiphy,
 	struct device *dev = to_device_index(csiphy, id);
 	struct platform_device *pdev = to_platform_device(dev);
 	struct resource *r;
-	int i;
+	int i, j;
 	int ret;
 
 	csiphy->id = id;
@@ -671,30 +738,30 @@ int msm_csiphy_subdev_init(struct csiphy_device *csiphy,
 		return -ENOMEM;
 
 	for (i = 0; i < csiphy->nclocks; i++) {
-		csiphy->clock[i] = devm_clk_get(dev, res->clock[i]);
-		if (IS_ERR(csiphy->clock[i]))
-			return PTR_ERR(csiphy->clock[i]);
-
-		if (res->clock_rate[i]) {
-			long clk_rate = clk_round_rate(csiphy->clock[i],
-						       res->clock_rate[i]);
-			if (clk_rate < 0) {
-				dev_err(to_device_index(csiphy, csiphy->id),
-					"clk round rate failed: %ld\n",
-					clk_rate);
-				return -EINVAL;
-			}
-			ret = clk_set_rate(csiphy->clock[i], clk_rate);
-			if (ret < 0) {
-				dev_err(to_device_index(csiphy, csiphy->id),
-					"clk set rate failed: %d\n", ret);
-				return ret;
-			}
+		struct camss_clock *clock = &csiphy->clock[i];
 
-			if (!strcmp(res->clock[i], "csiphy0_timer") ||
-					!strcmp(res->clock[i], "csiphy1_timer"))
-				csiphy->timer_clk_rate = clk_rate;
+		clock->clk = devm_clk_get(dev, res->clock[i]);
+		if (IS_ERR(clock->clk))
+			return PTR_ERR(clock->clk);
+
+		clock->name = res->clock[i];
+
+		clock->nfreqs = 0;
+		while (res->clock_rate[i][clock->nfreqs])
+			clock->nfreqs++;
+
+		if (!clock->nfreqs) {
+			clock->freq = NULL;
+			continue;
 		}
+
+		clock->freq = devm_kzalloc(dev, clock->nfreqs *
+					   sizeof(*clock->freq), GFP_KERNEL);
+		if (!clock->freq)
+			return -ENOMEM;
+
+		for (j = 0; j < clock->nfreqs; j++)
+			clock->freq[j] = res->clock_rate[i][j];
 	}
 
 	return 0;
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csiphy.h b/drivers/media/platform/qcom/camss-8x16/camss-csiphy.h
index e886e6d..ba87811 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-csiphy.h
+++ b/drivers/media/platform/qcom/camss-8x16/camss-csiphy.h
@@ -57,7 +57,7 @@ struct csiphy_device {
 	void __iomem *base_clk_mux;
 	u32 irq;
 	char irq_name[30];
-	struct clk **clock;
+	struct camss_clock *clock;
 	int nclocks;
 	u32 timer_clk_rate;
 	struct csiphy_config cfg;
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-ispif.c b/drivers/media/platform/qcom/camss-8x16/camss-ispif.c
index 31e00e5..54d1946 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-ispif.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-ispif.c
@@ -954,9 +954,14 @@ int msm_ispif_subdev_init(struct ispif_device *ispif,
 		return -ENOMEM;
 
 	for (i = 0; i < ispif->nclocks; i++) {
-		ispif->clock[i] = devm_clk_get(dev, res->clock[i]);
-		if (IS_ERR(ispif->clock[i]))
-			return PTR_ERR(ispif->clock[i]);
+		struct camss_clock *clock = &ispif->clock[i];
+
+		clock->clk = devm_clk_get(dev, res->clock[i]);
+		if (IS_ERR(clock->clk))
+			return PTR_ERR(clock->clk);
+
+		clock->freq = NULL;
+		clock->nfreqs = 0;
 	}
 
 	ispif->nclocks_for_reset = 0;
@@ -969,10 +974,14 @@ int msm_ispif_subdev_init(struct ispif_device *ispif,
 		return -ENOMEM;
 
 	for (i = 0; i < ispif->nclocks_for_reset; i++) {
-		ispif->clock_for_reset[i] = devm_clk_get(dev,
-						res->clock_for_reset[i]);
-		if (IS_ERR(ispif->clock_for_reset[i]))
-			return PTR_ERR(ispif->clock_for_reset[i]);
+		struct camss_clock *clock = &ispif->clock_for_reset[i];
+
+		clock->clk = devm_clk_get(dev, res->clock_for_reset[i]);
+		if (IS_ERR(clock->clk))
+			return PTR_ERR(clock->clk);
+
+		clock->freq = NULL;
+		clock->nfreqs = 0;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(ispif->line); i++)
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-ispif.h b/drivers/media/platform/qcom/camss-8x16/camss-ispif.h
index 6a1c9bd..6659020 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-ispif.h
+++ b/drivers/media/platform/qcom/camss-8x16/camss-ispif.h
@@ -60,9 +60,9 @@ struct ispif_device {
 	void __iomem *base_clk_mux;
 	u32 irq;
 	char irq_name[30];
-	struct clk **clock;
+	struct camss_clock *clock;
 	int nclocks;
-	struct clk **clock_for_reset;
+	struct camss_clock  *clock_for_reset;
 	int nclocks_for_reset;
 	struct completion reset_complete;
 	int power_count;
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
index c62a1ba..1c86b10 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
@@ -243,25 +243,95 @@
 
 #define SCALER_RATIO_MAX 16
 
-static const u32 vfe_formats[] = {
-	MEDIA_BUS_FMT_UYVY8_2X8,
-	MEDIA_BUS_FMT_VYUY8_2X8,
-	MEDIA_BUS_FMT_YUYV8_2X8,
-	MEDIA_BUS_FMT_YVYU8_2X8,
-	MEDIA_BUS_FMT_SBGGR8_1X8,
-	MEDIA_BUS_FMT_SGBRG8_1X8,
-	MEDIA_BUS_FMT_SGRBG8_1X8,
-	MEDIA_BUS_FMT_SRGGB8_1X8,
-	MEDIA_BUS_FMT_SBGGR10_1X10,
-	MEDIA_BUS_FMT_SGBRG10_1X10,
-	MEDIA_BUS_FMT_SGRBG10_1X10,
-	MEDIA_BUS_FMT_SRGGB10_1X10,
-	MEDIA_BUS_FMT_SBGGR12_1X12,
-	MEDIA_BUS_FMT_SGBRG12_1X12,
-	MEDIA_BUS_FMT_SGRBG12_1X12,
-	MEDIA_BUS_FMT_SRGGB12_1X12,
+static const struct {
+	u32 code;
+	u8 bpp;
+} vfe_formats[] = {
+	{
+		MEDIA_BUS_FMT_UYVY8_2X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_VYUY8_2X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_YUYV8_2X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_YVYU8_2X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_SBGGR8_1X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_SGBRG8_1X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_SGRBG8_1X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_SRGGB8_1X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_SBGGR10_1X10,
+		10,
+	},
+	{
+		MEDIA_BUS_FMT_SGBRG10_1X10,
+		10,
+	},
+	{
+		MEDIA_BUS_FMT_SGRBG10_1X10,
+		10,
+	},
+	{
+		MEDIA_BUS_FMT_SRGGB10_1X10,
+		10,
+	},
+	{
+		MEDIA_BUS_FMT_SBGGR12_1X12,
+		12,
+	},
+	{
+		MEDIA_BUS_FMT_SGBRG12_1X12,
+		12,
+	},
+	{
+		MEDIA_BUS_FMT_SGRBG12_1X12,
+		12,
+	},
+	{
+		MEDIA_BUS_FMT_SRGGB12_1X12,
+		12,
+	}
 };
 
+/*
+ * vfe_get_bpp - map media bus format to bits per pixel
+ * @code: media bus format code
+ *
+ * Return number of bits per pixel
+ */
+static u8 vfe_get_bpp(u32 code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(vfe_formats); i++)
+		if (code == vfe_formats[i].code)
+			return vfe_formats[i].bpp;
+
+	WARN(1, "Unknown format\n");
+
+	return vfe_formats[0].bpp;
+}
+
 static inline void vfe_reg_clr(struct vfe_device *vfe, u32 reg, u32 clr_bits)
 {
 	u32 bits = readl_relaxed(vfe->base + reg);
@@ -1767,6 +1837,138 @@ static irqreturn_t vfe_isr(int irq, void *dev)
 }
 
 /*
+ * vfe_set_clock_rates - Calculate and set clock rates on VFE module
+ * @vfe: VFE device
+ *
+ * Return 0 on success or a negative error code otherwise
+ */
+static int vfe_set_clock_rates(struct vfe_device *vfe)
+{
+	struct device *dev = to_device(vfe);
+	u32 pixel_clock[MSM_VFE_LINE_NUM];
+	int i, j;
+	int ret;
+
+	for (i = VFE_LINE_RDI0; i <= VFE_LINE_PIX; i++) {
+		ret = camss_get_pixel_clock(&vfe->line[i].subdev.entity,
+					    &pixel_clock[i]);
+		if (ret)
+			pixel_clock[i] = 0;
+	}
+
+	for (i = 0; i < vfe->nclocks; i++) {
+		struct camss_clock *clock = &vfe->clock[i];
+
+		if (!strcmp(clock->name, "camss_vfe_vfe")) {
+			u64 min_rate = 0;
+			long rate;
+
+			for (j = VFE_LINE_RDI0; j <= VFE_LINE_PIX; j++) {
+				u32 tmp;
+				u8 bpp;
+
+				if (j == VFE_LINE_PIX) {
+					tmp = pixel_clock[j];
+				} else {
+					bpp = vfe_get_bpp(vfe->line[j].
+						fmt[MSM_VFE_PAD_SINK].code);
+					tmp = pixel_clock[j] * bpp / 64;
+				}
+
+				if (min_rate < tmp)
+					min_rate = tmp;
+			}
+
+			camss_add_clock_margin(&min_rate);
+
+			for (j = 0; j < clock->nfreqs; j++)
+				if (min_rate < clock->freq[j])
+					break;
+
+			if (j == clock->nfreqs) {
+				dev_err(dev,
+					"Pixel clock is too high for VFE");
+				return -EINVAL;
+			}
+
+			/* if sensor pixel clock is not available */
+			/* set highest possible VFE clock rate */
+			if (min_rate == 0)
+				j = clock->nfreqs - 1;
+
+			rate = clk_round_rate(clock->clk, clock->freq[j]);
+			if (rate < 0) {
+				dev_err(dev, "clk round rate failed: %ld\n",
+					rate);
+				return -EINVAL;
+			}
+
+			ret = clk_set_rate(clock->clk, rate);
+			if (ret < 0) {
+				dev_err(dev, "clk set rate failed: %d\n", ret);
+				return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * vfe_check_clock_rates - Check current clock rates on VFE module
+ * @vfe: VFE device
+ *
+ * Return 0 if current clock rates are suitable for a new pipeline
+ * or a negative error code otherwise
+ */
+static int vfe_check_clock_rates(struct vfe_device *vfe)
+{
+	u32 pixel_clock[MSM_VFE_LINE_NUM];
+	int i, j;
+	int ret;
+
+	for (i = VFE_LINE_RDI0; i <= VFE_LINE_PIX; i++) {
+		ret = camss_get_pixel_clock(&vfe->line[i].subdev.entity,
+					    &pixel_clock[i]);
+		if (ret)
+			pixel_clock[i] = 0;
+	}
+
+	for (i = 0; i < vfe->nclocks; i++) {
+		struct camss_clock *clock = &vfe->clock[i];
+
+		if (!strcmp(clock->name, "camss_vfe_vfe")) {
+			u64 min_rate = 0;
+			unsigned long rate;
+
+			for (j = VFE_LINE_RDI0; j <= VFE_LINE_PIX; j++) {
+				u32 tmp;
+				u8 bpp;
+
+				if (j == VFE_LINE_PIX) {
+					tmp = pixel_clock[j];
+				} else {
+					bpp = vfe_get_bpp(vfe->line[j].
+						fmt[MSM_VFE_PAD_SINK].code);
+					tmp = pixel_clock[j] * bpp / 64;
+				}
+
+				if (min_rate < tmp)
+					min_rate = tmp;
+			}
+
+			camss_add_clock_margin(&min_rate);
+
+			rate = clk_get_rate(clock->clk);
+			if (rate < min_rate)
+				return -EBUSY;
+		}
+	}
+
+	return 0;
+}
+
+/*
  * vfe_get - Power up and reset VFE module
  * @vfe: VFE Device
  *
@@ -1779,6 +1981,10 @@ static int vfe_get(struct vfe_device *vfe)
 	mutex_lock(&vfe->power_lock);
 
 	if (vfe->power_count == 0) {
+		ret = vfe_set_clock_rates(vfe);
+		if (ret < 0)
+			goto error_clocks;
+
 		ret = camss_enable_clocks(vfe->nclocks, vfe->clock,
 					  to_device(vfe));
 		if (ret < 0)
@@ -1791,6 +1997,10 @@ static int vfe_get(struct vfe_device *vfe)
 		vfe_reset_output_maps(vfe);
 
 		vfe_init_outputs(vfe);
+	} else {
+		ret = vfe_check_clock_rates(vfe);
+		if (ret < 0)
+			goto error_clocks;
 	}
 	vfe->power_count++;
 
@@ -2074,7 +2284,7 @@ static void vfe_try_format(struct vfe_line *line,
 		/* Set format on sink pad */
 
 		for (i = 0; i < ARRAY_SIZE(vfe_formats); i++)
-			if (fmt->code == vfe_formats[i])
+			if (fmt->code == vfe_formats[i].code)
 				break;
 
 		/* If not found, use UYVY as default */
@@ -2241,7 +2451,7 @@ static int vfe_enum_mbus_code(struct v4l2_subdev *sd,
 		if (code->index >= ARRAY_SIZE(vfe_formats))
 			return -EINVAL;
 
-		code->code = vfe_formats[code->index];
+		code->code = vfe_formats[code->index].code;
 	} else {
 		if (code->index > 0)
 			return -EINVAL;
@@ -2544,7 +2754,7 @@ int msm_vfe_subdev_init(struct vfe_device *vfe, const struct resources *res)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct resource *r;
 	struct camss *camss = to_camss(vfe);
-	int i;
+	int i, j;
 	int ret;
 
 	/* Memory */
@@ -2587,23 +2797,30 @@ int msm_vfe_subdev_init(struct vfe_device *vfe, const struct resources *res)
 		return -ENOMEM;
 
 	for (i = 0; i < vfe->nclocks; i++) {
-		vfe->clock[i] = devm_clk_get(dev, res->clock[i]);
-		if (IS_ERR(vfe->clock[i]))
-			return PTR_ERR(vfe->clock[i]);
-
-		if (res->clock_rate[i]) {
-			long clk_rate = clk_round_rate(vfe->clock[i],
-						       res->clock_rate[i]);
-			if (clk_rate < 0) {
-				dev_err(dev, "clk round rate failed\n");
-				return -EINVAL;
-			}
-			ret = clk_set_rate(vfe->clock[i], clk_rate);
-			if (ret < 0) {
-				dev_err(dev, "clk set rate failed\n");
-				return ret;
-			}
+		struct camss_clock *clock = &vfe->clock[i];
+
+		clock->clk = devm_clk_get(dev, res->clock[i]);
+		if (IS_ERR(clock->clk))
+			return PTR_ERR(clock->clk);
+
+		clock->name = res->clock[i];
+
+		clock->nfreqs = 0;
+		while (res->clock_rate[i][clock->nfreqs])
+			clock->nfreqs++;
+
+		if (!clock->nfreqs) {
+			clock->freq = NULL;
+			continue;
 		}
+
+		clock->freq = devm_kzalloc(dev, clock->nfreqs *
+					   sizeof(*clock->freq), GFP_KERNEL);
+		if (!clock->freq)
+			return -ENOMEM;
+
+		for (j = 0; j < clock->nfreqs; j++)
+			clock->freq[j] = res->clock_rate[i][j];
 	}
 
 	mutex_init(&vfe->power_lock);
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h b/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
index 3651ece..88c29d0 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
+++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
@@ -91,7 +91,7 @@ struct vfe_device {
 	void __iomem *base;
 	u32 irq;
 	char irq_name[30];
-	struct clk **clock;
+	struct camss_clock *clock;
 	int nclocks;
 	struct completion reset_complete;
 	struct completion halt_complete;
diff --git a/drivers/media/platform/qcom/camss-8x16/camss.c b/drivers/media/platform/qcom/camss-8x16/camss.c
index 2dee77a..a3760b5 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss.c
@@ -33,13 +33,19 @@
 
 #include "camss.h"
 
+#define CAMSS_CLOCK_MARGIN_NUMERATOR 105
+#define CAMSS_CLOCK_MARGIN_DENOMINATOR 100
+
 static const struct resources csiphy_res[] = {
 	/* CSIPHY0 */
 	{
 		.regulator = { NULL },
 		.clock = { "camss_top_ahb", "ispif_ahb",
 			   "camss_ahb", "csiphy0_timer" },
-		.clock_rate = { 0, 0, 0, 200000000 },
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 0 },
+				{ 100000000, 200000000 } },
 		.reg = { "csiphy0", "csiphy0_clk_mux" },
 		.interrupt = { "csiphy0" }
 	},
@@ -49,7 +55,10 @@ static const struct resources csiphy_res[] = {
 		.regulator = { NULL },
 		.clock = { "camss_top_ahb", "ispif_ahb",
 			   "camss_ahb", "csiphy1_timer" },
-		.clock_rate = { 0, 0, 0, 200000000 },
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 0 },
+				{ 100000000, 200000000 } },
 		.reg = { "csiphy1", "csiphy1_clk_mux" },
 		.interrupt = { "csiphy1" }
 	}
@@ -62,7 +71,14 @@ static const struct resources csid_res[] = {
 		.clock = { "camss_top_ahb", "ispif_ahb",
 			   "csi0_ahb", "camss_ahb",
 			   "csi0", "csi0_phy", "csi0_pix", "csi0_rdi" },
-		.clock_rate = { 0, 0, 0, 0, 200000000, 0, 0, 0 },
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 0 },
+				{ 0 },
+				{ 100000000, 200000000 },
+				{ 0 },
+				{ 0 },
+				{ 0 } },
 		.reg = { "csid0" },
 		.interrupt = { "csid0" }
 	},
@@ -73,7 +89,14 @@ static const struct resources csid_res[] = {
 		.clock = { "camss_top_ahb", "ispif_ahb",
 			   "csi1_ahb", "camss_ahb",
 			   "csi1", "csi1_phy", "csi1_pix", "csi1_rdi" },
-		.clock_rate = { 0, 0, 0, 0, 200000000, 0, 0, 0 },
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 0 },
+				{ 0 },
+				{ 100000000, 200000000 },
+				{ 0 },
+				{ 0 },
+				{ 0 } },
 		.reg = { "csid1" },
 		.interrupt = { "csid1" }
 	},
@@ -95,12 +118,35 @@ static const struct resources vfe_res = {
 	.regulator = { NULL },
 	.clock = { "camss_top_ahb", "camss_vfe_vfe", "camss_csi_vfe",
 		   "iface", "bus", "camss_ahb" },
-	.clock_rate = { 0, 320000000, 0, 0, 0, 0, 0, 0 },
+	.clock_rate = { { 0 },
+			{ 50000000, 80000000, 100000000, 160000000,
+			  177780000, 200000000, 266670000, 320000000,
+			  400000000, 465000000 },
+			{ 0 },
+			{ 0 },
+			{ 0 },
+			{ 0 },
+			{ 0 },
+			{ 0 },
+			{ 0 } },
 	.reg = { "vfe0" },
 	.interrupt = { "vfe0" }
 };
 
 /*
+ * camss_add_clock_margin - Add margin to clock frequency rate
+ * @rate: Clock frequency rate
+ *
+ * When making calculations with physical clock frequency values
+ * some safety margin must be added. Add it.
+ */
+inline void camss_add_clock_margin(u64 *rate)
+{
+	*rate *= CAMSS_CLOCK_MARGIN_NUMERATOR;
+	*rate = div_u64(*rate, CAMSS_CLOCK_MARGIN_DENOMINATOR);
+}
+
+/*
  * camss_enable_clocks - Enable multiple clocks
  * @nclocks: Number of clocks in clock array
  * @clock: Clock array
@@ -108,13 +154,14 @@ static const struct resources vfe_res = {
  *
  * Return 0 on success or a negative error code otherwise
  */
-int camss_enable_clocks(int nclocks, struct clk **clock, struct device *dev)
+int camss_enable_clocks(int nclocks, struct camss_clock *clock,
+			struct device *dev)
 {
 	int ret;
 	int i;
 
 	for (i = 0; i < nclocks; i++) {
-		ret = clk_prepare_enable(clock[i]);
+		ret = clk_prepare_enable(clock[i].clk);
 		if (ret) {
 			dev_err(dev, "clock enable failed: %d\n", ret);
 			goto error;
@@ -125,7 +172,7 @@ int camss_enable_clocks(int nclocks, struct clk **clock, struct device *dev)
 
 error:
 	for (i--; i >= 0; i--)
-		clk_disable_unprepare(clock[i]);
+		clk_disable_unprepare(clock[i].clk);
 
 	return ret;
 }
@@ -135,12 +182,12 @@ int camss_enable_clocks(int nclocks, struct clk **clock, struct device *dev)
  * @nclocks: Number of clocks in clock array
  * @clock: Clock array
  */
-void camss_disable_clocks(int nclocks, struct clk **clock)
+void camss_disable_clocks(int nclocks, struct camss_clock *clock)
 {
 	int i;
 
 	for (i = nclocks - 1; i >= 0; i--)
-		clk_disable_unprepare(clock[i]);
+		clk_disable_unprepare(clock[i].clk);
 }
 
 /*
diff --git a/drivers/media/platform/qcom/camss-8x16/camss.h b/drivers/media/platform/qcom/camss-8x16/camss.h
index 4619d7634..4ad2234 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss.h
+++ b/drivers/media/platform/qcom/camss-8x16/camss.h
@@ -55,7 +55,7 @@
 struct resources {
 	char *regulator[CAMSS_RES_MAX];
 	char *clock[CAMSS_RES_MAX];
-	s32 clock_rate[CAMSS_RES_MAX];
+	u32 clock_rate[CAMSS_RES_MAX][CAMSS_RES_MAX];
 	char *reg[CAMSS_RES_MAX];
 	char *interrupt[CAMSS_RES_MAX];
 };
@@ -89,8 +89,17 @@ struct camss_async_subdev {
 	struct v4l2_async_subdev asd;
 };
 
-int camss_enable_clocks(int nclocks, struct clk **clock, struct device *dev);
-void camss_disable_clocks(int nclocks, struct clk **clock);
+struct camss_clock {
+	struct clk *clk;
+	const char *name;
+	u32 *freq;
+	u32 nfreqs;
+};
+
+void camss_add_clock_margin(u64 *rate);
+int camss_enable_clocks(int nclocks, struct camss_clock *clock,
+			struct device *dev);
+void camss_disable_clocks(int nclocks, struct camss_clock *clock);
 int camss_get_pixel_clock(struct media_entity *entity, u32 *pixel_clock);
 void camss_delete(struct camss *camss);
 
-- 
2.7.4
