Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:56103 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752111AbdFSO4u (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 10:56:50 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v2 19/19] camss: Use optimal clock frequency rates
Date: Mon, 19 Jun 2017 17:48:39 +0300
Message-Id: <1497883719-12410-20-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
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
 drivers/media/platform/qcom/camss-8x16/camss.c  | 114 +++++++++-
 drivers/media/platform/qcom/camss-8x16/camss.h  |  15 +-
 drivers/media/platform/qcom/camss-8x16/csid.c   | 243 ++++++++++++--------
 drivers/media/platform/qcom/camss-8x16/csid.h   |   2 +-
 drivers/media/platform/qcom/camss-8x16/csiphy.c | 211 ++++++++++++++----
 drivers/media/platform/qcom/camss-8x16/csiphy.h |   2 +-
 drivers/media/platform/qcom/camss-8x16/ispif.c  |  23 +-
 drivers/media/platform/qcom/camss-8x16/ispif.h  |   4 +-
 drivers/media/platform/qcom/camss-8x16/vfe.c    | 282 +++++++++++++++++++++---
 drivers/media/platform/qcom/camss-8x16/vfe.h    |   2 +-
 10 files changed, 712 insertions(+), 186 deletions(-)

diff --git a/drivers/media/platform/qcom/camss-8x16/camss.c b/drivers/media/platform/qcom/camss-8x16/camss.c
index a8798d1..8c72222 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss.c
@@ -17,10 +17,12 @@
  */
 #include <linux/clk.h>
 #include <linux/media-bus-format.h>
+#include <linux/media.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/slab.h>
+#include <linux/videodev2.h>
 
 #include <media/media-device.h>
 #include <media/v4l2-async.h>
@@ -36,7 +38,10 @@
 		.regulator = { NULL },
 		.clock = { "camss_top_ahb_clk", "ispif_ahb_clk",
 			   "camss_ahb_clk", "csiphy0_timer_clk" },
-		.clock_rate = { 0, 0, 0, 200000000 },
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 0 },
+				{ 100000000, 200000000 } },
 		.reg = { "csiphy0", "csiphy0_clk_mux" },
 		.interrupt = { "csiphy0" }
 	},
@@ -46,7 +51,10 @@
 		.regulator = { NULL },
 		.clock = { "camss_top_ahb_clk", "ispif_ahb_clk",
 			   "camss_ahb_clk", "csiphy1_timer_clk" },
-		.clock_rate = { 0, 0, 0, 200000000 },
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 0 },
+				{ 100000000, 200000000 } },
 		.reg = { "csiphy1", "csiphy1_clk_mux" },
 		.interrupt = { "csiphy1" }
 	}
@@ -60,7 +68,14 @@
 			   "csi0_ahb_clk", "camss_ahb_clk",
 			   "csi0_clk", "csi0_phy_clk",
 			   "csi0_pix_clk", "csi0_rdi_clk" },
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
@@ -72,7 +87,14 @@
 			   "csi1_ahb_clk", "camss_ahb_clk",
 			   "csi1_clk", "csi1_phy_clk",
 			   "csi1_pix_clk", "csi1_rdi_clk" },
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
@@ -95,7 +117,17 @@
 	.clock = { "camss_top_ahb_clk", "camss_vfe_vfe_clk",
 		   "camss_csi_vfe_clk", "iface_clk",
 		   "bus_clk", "camss_ahb_clk" },
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
@@ -108,13 +140,14 @@
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
 			dev_err(dev, "clock enable failed\n");
 			goto error;
@@ -125,7 +158,7 @@ int camss_enable_clocks(int nclocks, struct clk **clock, struct device *dev)
 
 error:
 	for (i--; i >= 0; i--)
-		clk_disable_unprepare(clock[i]);
+		clk_disable_unprepare(clock[i].clk);
 
 	return ret;
 }
@@ -135,12 +168,73 @@ int camss_enable_clocks(int nclocks, struct clk **clock, struct device *dev)
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
+}
+
+/*
+ * camss_find_sensor - Find a linked media entity which represents a sensor
+ * @entity: Media entity to start searching from
+ *
+ * Return a pointer to sensor media entity or NULL if not found
+ */
+static struct media_entity *camss_find_sensor(struct media_entity *entity)
+{
+	struct media_pad *pad;
+
+	while (1) {
+		pad = &entity->pads[0];
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			return NULL;
+
+		pad = media_entity_remote_pad(pad);
+		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
+			return NULL;
+
+		entity = pad->entity;
+
+		if (entity->function == MEDIA_ENT_F_CAM_SENSOR)
+			return entity;
+	}
+}
+
+/*
+ * camss_get_pixel_clock - Get pixel clock rate from sensor
+ * @entity: Media entity in the current pipeline
+ * @pixel_clock: Received pixel clock value
+ *
+ * Return 0 on success or a negative error code otherwise
+ */
+int camss_get_pixel_clock(struct media_entity *entity, u32 *pixel_clock)
+{
+	struct media_entity *sensor;
+	struct v4l2_subdev *subdev;
+	struct v4l2_ext_controls ctrls = { { 0 } };
+	struct v4l2_ext_control ctrl = { 0 };
+	int ret;
+
+	sensor = camss_find_sensor(entity);
+	if (!sensor)
+		return -ENODEV;
+
+	subdev = media_entity_to_v4l2_subdev(sensor);
+
+	ctrl.id = V4L2_CID_PIXEL_RATE;
+
+	ctrls.count = 1;
+	ctrls.controls = &ctrl;
+
+	ret = v4l2_g_ext_ctrls(subdev->ctrl_handler, &ctrls);
+	if (ret < 0)
+		return ret;
+
+	*pixel_clock = ctrl.value64;
+
+	return 0;
 }
 
 /*
diff --git a/drivers/media/platform/qcom/camss-8x16/camss.h b/drivers/media/platform/qcom/camss-8x16/camss.h
index e1a8b90..5ad14e3 100644
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
+int camss_enable_clocks(int nclocks, struct camss_clock *clock,
+			struct device *dev);
+void camss_disable_clocks(int nclocks, struct camss_clock *clock);
+int camss_get_pixel_clock(struct media_entity *entity, u32 *pixel_clock);
 void camss_delete(struct camss *camss);
 
 #endif /* QC_MSM_CAMSS_H */
diff --git a/drivers/media/platform/qcom/camss-8x16/csid.c b/drivers/media/platform/qcom/camss-8x16/csid.c
index c637d78..8f47fdf 100644
--- a/drivers/media/platform/qcom/camss-8x16/csid.c
+++ b/drivers/media/platform/qcom/camss-8x16/csid.c
@@ -184,6 +184,74 @@
 };
 
 /*
+ * csid_get_uncompressed - map media bus format to uncompressed media bus format
+ * @code: media bus format code
+ *
+ * Return uncompressed media bus format code
+ */
+static u32 csid_get_uncompressed(u32 code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
+		if (code == csid_input_fmts[i].code)
+			break;
+
+	return csid_input_fmts[i].uncompressed;
+}
+
+/*
+ * csid_get_data_type - map media bus format to data type
+ * @code: media bus format code
+ *
+ * Return data type code
+ */
+static u8 csid_get_data_type(u32 code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
+		if (code == csid_input_fmts[i].code)
+			break;
+
+	return csid_input_fmts[i].data_type;
+}
+
+/*
+ * csid_get_decode_format - map media bus format to decode format
+ * @code: media bus format code
+ *
+ * Return decode format code
+ */
+static u8 csid_get_decode_format(u32 code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
+		if (code == csid_input_fmts[i].code)
+			break;
+
+	return csid_input_fmts[i].decode_format;
+}
+
+/*
+ * csid_get_bpp - map media bus format to bits per pixel
+ * @code: media bus format code
+ *
+ * Return number of bits per pixel
+ */
+static u8 csid_get_bpp(u32 code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
+		if (code == csid_input_fmts[i].uncompressed)
+			break;
+
+	return csid_input_fmts[i].uncompr_bpp;
+}
+
+/*
  * csid_isr - CSID module interrupt handler
  * @irq: Interrupt line
  * @dev: CSID device
@@ -205,6 +273,64 @@ static irqreturn_t csid_isr(int irq, void *dev)
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
+		if (!strcmp(clock->name, "csi0_clk") ||
+			!strcmp(clock->name, "csi1_clk")) {
+			u8 bpp = csid_get_bpp(
+					csid->fmt[MSM_CSIPHY_PAD_SINK].code);
+			u8 num_lanes = csid->phy.lane_cnt;
+			u32 min_rate = pixel_clock * bpp / (2 * num_lanes * 4);
+			unsigned long rate;
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
+				dev_err(dev, "clk round rate failed\n");
+				return -EINVAL;
+			}
+
+			ret = clk_set_rate(clock->clk, rate);
+			if (ret < 0) {
+				dev_err(dev, "clk set rate failed\n");
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
@@ -249,6 +375,12 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
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
@@ -277,74 +409,6 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
 }
 
 /*
- * csid_get_uncompressed - map media bus format to uncompressed media bus format
- * @code: media bus format code
- *
- * Return uncompressed media bus format code
- */
-static u32 csid_get_uncompressed(u32 code)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
-		if (code == csid_input_fmts[i].code)
-			break;
-
-	return csid_input_fmts[i].uncompressed;
-}
-
-/*
- * csid_get_data_type - map media bus format to data type
- * @code: media bus format code
- *
- * Return data type code
- */
-static u8 csid_get_data_type(u32 code)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
-		if (code == csid_input_fmts[i].code)
-			break;
-
-	return csid_input_fmts[i].data_type;
-}
-
-/*
- * csid_get_decode_format - map media bus format to decode format
- * @code: media bus format code
- *
- * Return decode format code
- */
-static u8 csid_get_decode_format(u32 code)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
-		if (code == csid_input_fmts[i].code)
-			break;
-
-	return csid_input_fmts[i].decode_format;
-}
-
-/*
- * csid_get_bpp - map media bus format to bits per pixel
- * @code: media bus format code
- *
- * Return number of bits per pixel
- */
-static u8 csid_get_bpp(u32 code)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
-		if (code == csid_input_fmts[i].uncompressed)
-			break;
-
-	return csid_input_fmts[i].uncompr_bpp;
-}
-
-/*
  * csid_set_stream - Enable/disable streaming on CSID module
  * @sd: CSID V4L2 subdevice
  * @enable: Requested streaming state
@@ -786,7 +850,7 @@ int msm_csid_subdev_init(struct csid_device *csid,
 	struct platform_device *pdev = container_of(dev, struct platform_device,
 						    dev);
 	struct resource *r;
-	int i;
+	int i, j;
 	int ret;
 
 	csid->id = id;
@@ -833,25 +897,30 @@ int msm_csid_subdev_init(struct csid_device *csid,
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
-					"clk round rate failed\n");
-				return -EINVAL;
-			}
-			ret = clk_set_rate(csid->clock[i], clk_rate);
-			if (ret < 0) {
-				dev_err(to_device_index(csid, csid->id),
-					"clk set rate failed\n");
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
diff --git a/drivers/media/platform/qcom/camss-8x16/csid.h b/drivers/media/platform/qcom/camss-8x16/csid.h
index 3875d5d..ea3a187 100644
--- a/drivers/media/platform/qcom/camss-8x16/csid.h
+++ b/drivers/media/platform/qcom/camss-8x16/csid.h
@@ -56,7 +56,7 @@ struct csid_device {
 	void __iomem *base;
 	u32 irq;
 	char irq_name[30];
-	struct clk **clock;
+	struct camss_clock *clock;
 	int nclocks;
 	struct regulator *vdda;
 	struct completion reset_complete;
diff --git a/drivers/media/platform/qcom/camss-8x16/csiphy.c b/drivers/media/platform/qcom/camss-8x16/csiphy.c
index b9d47ca..9724f09 100644
--- a/drivers/media/platform/qcom/camss-8x16/csiphy.c
+++ b/drivers/media/platform/qcom/camss-8x16/csiphy.c
@@ -42,26 +42,94 @@
 #define CAMSS_CSI_PHY_GLBL_T_INIT_CFG0		0x1ec
 #define CAMSS_CSI_PHY_T_WAKEUP_CFG0		0x1f4
 
-static const u32 csiphy_formats[] = {
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
+} csiphy_formats[] = {
+	{
+		MEDIA_BUS_FMT_UYVY8_2X8,
+		16,
+	},
+	{
+		MEDIA_BUS_FMT_VYUY8_2X8,
+		16,
+	},
+	{
+		MEDIA_BUS_FMT_YUYV8_2X8,
+		16,
+	},
+	{
+		MEDIA_BUS_FMT_YVYU8_2X8,
+		16,
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
 
 /*
+ * csiphy_get_bpp - map media bus format to bits per pixel
+ * @code: media bus format code
+ *
+ * Return number of bits per pixel
+ */
+static u8 csiphy_get_bpp(u32 code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(csiphy_formats); i++)
+		if (code == csiphy_formats[i].code)
+			break;
+
+	return csiphy_formats[i].bpp;
+}
+
+/*
  * csiphy_isr - CSIPHY module interrupt handler
  * @irq: Interrupt line
  * @dev: CSIPHY device
@@ -88,6 +156,64 @@ static irqreturn_t csiphy_isr(int irq, void *dev)
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
+		if (!strcmp(clock->name, "csiphy0_timer_clk") ||
+			!strcmp(clock->name, "csiphy1_timer_clk")) {
+			u8 bpp = csiphy_get_bpp(
+					csiphy->fmt[MSM_CSIPHY_PAD_SINK].code);
+			u8 num_lanes = csiphy->cfg.csi2->lane_cfg.num_data;
+			u32 min_rate = pixel_clock * bpp / (2 * num_lanes * 4);
+			unsigned long rate;
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
+			rate = clk_round_rate(clock->clk, clock->freq[j]);
+			if (rate < 0) {
+				dev_err(dev, "clk round rate failed\n");
+				return -EINVAL;
+			}
+
+			ret = clk_set_rate(clock->clk, rate);
+			if (ret < 0) {
+				dev_err(dev, "clk set rate failed\n");
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
@@ -114,6 +240,10 @@ static int csiphy_set_power(struct v4l2_subdev *sd, int on)
 	if (on) {
 		u8 hw_version;
 
+		ret = csiphy_set_clock_rates(csiphy);
+		if (ret < 0)
+			return ret;
+
 		ret = camss_enable_clocks(csiphy->nclocks, csiphy->clock, dev);
 		if (ret < 0)
 			return ret;
@@ -291,7 +421,7 @@ static void csiphy_try_format(struct csiphy_device *csiphy,
 		/* Set format on sink pad */
 
 		for (i = 0; i < ARRAY_SIZE(csiphy_formats); i++)
-			if (fmt->code == csiphy_formats[i])
+			if (fmt->code == csiphy_formats[i].code)
 				break;
 
 		/* If not found, use UYVY as default */
@@ -336,7 +466,7 @@ static int csiphy_enum_mbus_code(struct v4l2_subdev *sd,
 		if (code->index >= ARRAY_SIZE(csiphy_formats))
 			return -EINVAL;
 
-		code->code = csiphy_formats[code->index];
+		code->code = csiphy_formats[code->index].code;
 	} else {
 		if (code->index > 0)
 			return -EINVAL;
@@ -485,7 +615,7 @@ int msm_csiphy_subdev_init(struct csiphy_device *csiphy,
 	struct platform_device *pdev = container_of(dev,
 						struct platform_device, dev);
 	struct resource *r;
-	int i;
+	int i, j;
 	int ret;
 
 	csiphy->id = id;
@@ -540,25 +670,30 @@ int msm_csiphy_subdev_init(struct csiphy_device *csiphy,
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
-					"clk round rate failed\n");
-				return -EINVAL;
-			}
-			ret = clk_set_rate(csiphy->clock[i], clk_rate);
-			if (ret < 0) {
-				dev_err(to_device_index(csiphy, csiphy->id),
-					"clk set rate failed\n");
-				return ret;
-			}
+		struct camss_clock *clock = &csiphy->clock[i];
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
 
 	return 0;
diff --git a/drivers/media/platform/qcom/camss-8x16/csiphy.h b/drivers/media/platform/qcom/camss-8x16/csiphy.h
index 60330a8..bf52af6 100644
--- a/drivers/media/platform/qcom/camss-8x16/csiphy.h
+++ b/drivers/media/platform/qcom/camss-8x16/csiphy.h
@@ -58,7 +58,7 @@ struct csiphy_device {
 	void __iomem *base_clk_mux;
 	u32 irq;
 	char irq_name[30];
-	struct clk **clock;
+	struct camss_clock *clock;
 	int nclocks;
 	struct csiphy_config cfg;
 	struct v4l2_mbus_framefmt fmt[MSM_CSIPHY_PADS_NUM];
diff --git a/drivers/media/platform/qcom/camss-8x16/ispif.c b/drivers/media/platform/qcom/camss-8x16/ispif.c
index 4f3d8c3..c3d154d 100644
--- a/drivers/media/platform/qcom/camss-8x16/ispif.c
+++ b/drivers/media/platform/qcom/camss-8x16/ispif.c
@@ -927,9 +927,14 @@ int msm_ispif_subdev_init(struct ispif_device *ispif,
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
@@ -942,10 +947,14 @@ int msm_ispif_subdev_init(struct ispif_device *ispif,
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
 
 	init_completion(&ispif->reset_complete);
diff --git a/drivers/media/platform/qcom/camss-8x16/ispif.h b/drivers/media/platform/qcom/camss-8x16/ispif.h
index 935987f..1b3928d 100644
--- a/drivers/media/platform/qcom/camss-8x16/ispif.h
+++ b/drivers/media/platform/qcom/camss-8x16/ispif.h
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
diff --git a/drivers/media/platform/qcom/camss-8x16/vfe.c b/drivers/media/platform/qcom/camss-8x16/vfe.c
index 0241faa..d5b5531 100644
--- a/drivers/media/platform/qcom/camss-8x16/vfe.c
+++ b/drivers/media/platform/qcom/camss-8x16/vfe.c
@@ -222,25 +222,93 @@
 
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
+		16,
+	},
+	{
+		MEDIA_BUS_FMT_VYUY8_2X8,
+		16,
+	},
+	{
+		MEDIA_BUS_FMT_YUYV8_2X8,
+		16,
+	},
+	{
+		MEDIA_BUS_FMT_YVYU8_2X8,
+		16,
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
+			break;
+
+	return vfe_formats[i].bpp;
+}
+
 static inline void vfe_reg_clr(struct vfe_device *vfe, u32 reg, u32 clr_bits)
 {
 	u32 bits = readl_relaxed(vfe->base + reg);
@@ -1733,6 +1801,133 @@ static irqreturn_t vfe_isr(int irq, void *dev)
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
+		if (!strcmp(clock->name, "camss_vfe_vfe_clk")) {
+			u32 min_rate = 0;
+			unsigned long rate;
+
+			for (i = VFE_LINE_RDI0; i <= VFE_LINE_PIX; i++) {
+				u32 tmp;
+				u8 bpp;
+
+				if (i == VFE_LINE_PIX) {
+					tmp = pixel_clock[i] * 2;
+				} else {
+					bpp = vfe_get_bpp(vfe->line[i].
+						fmt[MSM_VFE_PAD_SINK].code);
+					tmp = pixel_clock[i] * bpp * 2 / 64;
+				}
+
+				if (min_rate < tmp)
+					min_rate = tmp;
+			}
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
+				dev_err(dev, "clk round rate failed\n");
+				return -EINVAL;
+			}
+
+			ret = clk_set_rate(clock->clk, rate);
+			if (ret < 0) {
+				dev_err(dev, "clk set rate failed\n");
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
+	int i;
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
+		if (!strcmp(clock->name, "camss_vfe_vfe_clk")) {
+			u32 min_rate = 0;
+			unsigned long rate;
+
+			for (i = VFE_LINE_RDI0; i <= VFE_LINE_PIX; i++) {
+				u32 tmp;
+				u8 bpp;
+
+				if (i == VFE_LINE_PIX) {
+					tmp = pixel_clock[i] * 2;
+				} else {
+					bpp = vfe_get_bpp(vfe->line[i].
+						fmt[MSM_VFE_PAD_SINK].code);
+					tmp = pixel_clock[i] * bpp * 2 / 64;
+				}
+
+				if (min_rate < tmp)
+					min_rate = tmp;
+			}
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
@@ -1745,6 +1940,10 @@ static int vfe_get(struct vfe_device *vfe)
 	mutex_lock(&vfe->power_lock);
 
 	if (vfe->power_count == 0) {
+		ret = vfe_set_clock_rates(vfe);
+		if (ret < 0)
+			goto error_clocks;
+
 		ret = camss_enable_clocks(vfe->nclocks, vfe->clock,
 					  to_device(vfe));
 		if (ret < 0)
@@ -1757,6 +1956,10 @@ static int vfe_get(struct vfe_device *vfe)
 		vfe_reset_output_maps(vfe);
 
 		vfe_init_outputs(vfe);
+	} else {
+		ret = vfe_check_clock_rates(vfe);
+		if (ret < 0)
+			goto error_clocks;
 	}
 	vfe->power_count++;
 
@@ -2040,7 +2243,7 @@ static void vfe_try_format(struct vfe_line *line,
 		/* Set format on sink pad */
 
 		for (i = 0; i < ARRAY_SIZE(vfe_formats); i++)
-			if (fmt->code == vfe_formats[i])
+			if (fmt->code == vfe_formats[i].code)
 				break;
 
 		/* If not found, use UYVY as default */
@@ -2212,7 +2415,7 @@ static int vfe_enum_mbus_code(struct v4l2_subdev *sd,
 		if (code->index >= ARRAY_SIZE(vfe_formats))
 			return -EINVAL;
 
-		code->code = vfe_formats[code->index];
+		code->code = vfe_formats[code->index].code;
 	} else {
 		if (code->index > 0)
 			return -EINVAL;
@@ -2515,7 +2718,7 @@ int msm_vfe_subdev_init(struct vfe_device *vfe, struct resources *res)
 	struct resource *r;
 	struct camss *camss = to_camss(vfe);
 
-	int i;
+	int i, j;
 	int ret;
 
 	mutex_init(&vfe->power_lock);
@@ -2578,23 +2781,30 @@ int msm_vfe_subdev_init(struct vfe_device *vfe, struct resources *res)
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
 
 	init_completion(&vfe->reset_complete);
diff --git a/drivers/media/platform/qcom/camss-8x16/vfe.h b/drivers/media/platform/qcom/camss-8x16/vfe.h
index 002e289c..ce2f488 100644
--- a/drivers/media/platform/qcom/camss-8x16/vfe.h
+++ b/drivers/media/platform/qcom/camss-8x16/vfe.h
@@ -91,7 +91,7 @@ struct vfe_device {
 	void __iomem *base;
 	u32 irq;
 	char irq_name[30];
-	struct clk **clock;
+	struct camss_clock *clock;
 	int nclocks;
 	struct completion reset_complete;
 	struct completion halt_complete;
-- 
1.9.1
