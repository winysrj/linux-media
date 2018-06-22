Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:46550 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933989AbeFVPeI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:34:08 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 21/32] media: camss: csid: Add support for 8x96
Date: Fri, 22 Jun 2018 18:33:30 +0300
Message-Id: <1529681621-9682-22-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
References: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CSID hardware modules on 8x16 and 8x96 are similar. There is no
need to duplicate the code by adding separate versions. Just
update the register macros to return the correct register
addresses.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-csid.c | 60 ++++++++++++++++----------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
index ea2b0ba..ff0e0d5 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -27,21 +27,26 @@
 #define CAMSS_CSID_HW_VERSION		0x0
 #define CAMSS_CSID_CORE_CTRL_0		0x004
 #define CAMSS_CSID_CORE_CTRL_1		0x008
-#define CAMSS_CSID_RST_CMD		0x00c
-#define CAMSS_CSID_CID_LUT_VC_n(n)	(0x010 + 0x4 * (n))
-#define CAMSS_CSID_CID_n_CFG(n)		(0x020 + 0x4 * (n))
-#define CAMSS_CSID_IRQ_CLEAR_CMD	0x060
-#define CAMSS_CSID_IRQ_MASK		0x064
-#define CAMSS_CSID_IRQ_STATUS		0x068
-#define CAMSS_CSID_TG_CTRL		0x0a0
+#define CAMSS_CSID_RST_CMD(v)		((v) == CAMSS_8x16 ? 0x00c : 0x010)
+#define CAMSS_CSID_CID_LUT_VC_n(v, n)	\
+			(((v) == CAMSS_8x16 ? 0x010 : 0x014) + 0x4 * (n))
+#define CAMSS_CSID_CID_n_CFG(v, n)	\
+			(((v) == CAMSS_8x16 ? 0x020 : 0x024) + 0x4 * (n))
+#define CAMSS_CSID_IRQ_CLEAR_CMD(v)	((v) == CAMSS_8x16 ? 0x060 : 0x064)
+#define CAMSS_CSID_IRQ_MASK(v)		((v) == CAMSS_8x16 ? 0x064 : 0x068)
+#define CAMSS_CSID_IRQ_STATUS(v)	((v) == CAMSS_8x16 ? 0x068 : 0x06c)
+#define CAMSS_CSID_TG_CTRL(v)		((v) == CAMSS_8x16 ? 0x0a0 : 0x0a8)
 #define CAMSS_CSID_TG_CTRL_DISABLE	0xa06436
 #define CAMSS_CSID_TG_CTRL_ENABLE	0xa06437
-#define CAMSS_CSID_TG_VC_CFG		0x0a4
+#define CAMSS_CSID_TG_VC_CFG(v)		((v) == CAMSS_8x16 ? 0x0a4 : 0x0ac)
 #define CAMSS_CSID_TG_VC_CFG_H_BLANKING		0x3ff
 #define CAMSS_CSID_TG_VC_CFG_V_BLANKING		0x7f
-#define CAMSS_CSID_TG_DT_n_CGG_0(n)	(0x0ac + 0xc * (n))
-#define CAMSS_CSID_TG_DT_n_CGG_1(n)	(0x0b0 + 0xc * (n))
-#define CAMSS_CSID_TG_DT_n_CGG_2(n)	(0x0b4 + 0xc * (n))
+#define CAMSS_CSID_TG_DT_n_CGG_0(v, n)	\
+			(((v) == CAMSS_8x16 ? 0x0ac : 0x0b4) + 0xc * (n))
+#define CAMSS_CSID_TG_DT_n_CGG_1(v, n)	\
+			(((v) == CAMSS_8x16 ? 0x0b0 : 0x0b8) + 0xc * (n))
+#define CAMSS_CSID_TG_DT_n_CGG_2(v, n)	\
+			(((v) == CAMSS_8x16 ? 0x0b4 : 0x0bc) + 0xc * (n))
 
 #define DATA_TYPE_EMBEDDED_DATA_8BIT	0x12
 #define DATA_TYPE_YUV422_8BIT		0x1e
@@ -203,10 +208,11 @@ static const struct csid_fmts *csid_get_fmt_entry(u32 code)
 static irqreturn_t csid_isr(int irq, void *dev)
 {
 	struct csid_device *csid = dev;
+	enum camss_version ver = csid->camss->version;
 	u32 value;
 
-	value = readl_relaxed(csid->base + CAMSS_CSID_IRQ_STATUS);
-	writel_relaxed(value, csid->base + CAMSS_CSID_IRQ_CLEAR_CMD);
+	value = readl_relaxed(csid->base + CAMSS_CSID_IRQ_STATUS(ver));
+	writel_relaxed(value, csid->base + CAMSS_CSID_IRQ_CLEAR_CMD(ver));
 
 	if ((value >> 11) & 0x1)
 		complete(&csid->reset_complete);
@@ -289,7 +295,8 @@ static int csid_reset(struct csid_device *csid)
 
 	reinit_completion(&csid->reset_complete);
 
-	writel_relaxed(0x7fff, csid->base + CAMSS_CSID_RST_CMD);
+	writel_relaxed(0x7fff, csid->base +
+		       CAMSS_CSID_RST_CMD(csid->camss->version));
 
 	time = wait_for_completion_timeout(&csid->reset_complete,
 		msecs_to_jiffies(CSID_RESET_TIMEOUT_MS));
@@ -370,6 +377,7 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct csid_device *csid = v4l2_get_subdevdata(sd);
 	struct csid_testgen_config *tg = &csid->testgen;
+	enum camss_version ver = csid->camss->version;
 	u32 val;
 
 	if (enable) {
@@ -402,13 +410,14 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 			/* 1:0 VC */
 			val = ((CAMSS_CSID_TG_VC_CFG_V_BLANKING & 0xff) << 24) |
 			      ((CAMSS_CSID_TG_VC_CFG_H_BLANKING & 0x7ff) << 13);
-			writel_relaxed(val, csid->base + CAMSS_CSID_TG_VC_CFG);
+			writel_relaxed(val, csid->base +
+				       CAMSS_CSID_TG_VC_CFG(ver));
 
 			/* 28:16 bytes per lines, 12:0 num of lines */
 			val = ((num_bytes_per_line & 0x1fff) << 16) |
 			      (num_lines & 0x1fff);
 			writel_relaxed(val, csid->base +
-				       CAMSS_CSID_TG_DT_n_CGG_0(0));
+				       CAMSS_CSID_TG_DT_n_CGG_0(ver, 0));
 
 			dt = csid_get_fmt_entry(
 				csid->fmt[MSM_CSID_PAD_SRC].code)->data_type;
@@ -416,12 +425,12 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 			/* 5:0 data type */
 			val = dt;
 			writel_relaxed(val, csid->base +
-				       CAMSS_CSID_TG_DT_n_CGG_1(0));
+				       CAMSS_CSID_TG_DT_n_CGG_1(ver, 0));
 
 			/* 2:0 output test pattern */
 			val = tg->payload_mode;
 			writel_relaxed(val, csid->base +
-				       CAMSS_CSID_TG_DT_n_CGG_2(0));
+				       CAMSS_CSID_TG_DT_n_CGG_2(ver, 0));
 
 			df = csid_get_fmt_entry(
 				csid->fmt[MSM_CSID_PAD_SRC].code)->decode_format;
@@ -450,22 +459,27 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 
 		dt_shift = (cid % 4) * 8;
 
-		val = readl_relaxed(csid->base + CAMSS_CSID_CID_LUT_VC_n(vc));
+		val = readl_relaxed(csid->base +
+				    CAMSS_CSID_CID_LUT_VC_n(ver, vc));
 		val &= ~(0xff << dt_shift);
 		val |= dt << dt_shift;
-		writel_relaxed(val, csid->base + CAMSS_CSID_CID_LUT_VC_n(vc));
+		writel_relaxed(val, csid->base +
+			       CAMSS_CSID_CID_LUT_VC_n(ver, vc));
 
 		val = (df << 4) | 0x3;
-		writel_relaxed(val, csid->base + CAMSS_CSID_CID_n_CFG(cid));
+		writel_relaxed(val, csid->base +
+			       CAMSS_CSID_CID_n_CFG(ver, cid));
 
 		if (tg->enabled) {
 			val = CAMSS_CSID_TG_CTRL_ENABLE;
-			writel_relaxed(val, csid->base + CAMSS_CSID_TG_CTRL);
+			writel_relaxed(val, csid->base +
+				       CAMSS_CSID_TG_CTRL(ver));
 		}
 	} else {
 		if (tg->enabled) {
 			val = CAMSS_CSID_TG_CTRL_DISABLE;
-			writel_relaxed(val, csid->base + CAMSS_CSID_TG_CTRL);
+			writel_relaxed(val, csid->base +
+				       CAMSS_CSID_TG_CTRL(ver));
 		}
 	}
 
-- 
2.7.4
