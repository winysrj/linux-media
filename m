Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:35603 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730075AbeGYRv2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 13:51:28 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 30/34] media: camss: csid: MIPI10 to Plain16 format conversion
Date: Wed, 25 Jul 2018 19:38:39 +0300
Message-Id: <1532536723-19062-31-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
References: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the PRDI mode on 8x96 to allow to configure RAW MIPI10
to Plain16 format conversion.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-csid.c  | 33 ++++++++++++-
 drivers/media/platform/qcom/camss/camss-ispif.c | 64 +++++++++++++++++++++++++
 drivers/media/platform/qcom/camss/camss-vfe.c   |  1 +
 drivers/media/platform/qcom/camss/camss-video.c |  2 +
 4 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
index cf543fa..0715a8e 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -32,6 +32,15 @@
 			(((v) == CAMSS_8x16 ? 0x010 : 0x014) + 0x4 * (n))
 #define CAMSS_CSID_CID_n_CFG(v, n)	\
 			(((v) == CAMSS_8x16 ? 0x020 : 0x024) + 0x4 * (n))
+#define CAMSS_CSID_CID_n_CFG_ISPIF_EN	BIT(0)
+#define CAMSS_CSID_CID_n_CFG_RDI_EN	BIT(1)
+#define CAMSS_CSID_CID_n_CFG_DECODE_FORMAT_SHIFT	4
+#define CAMSS_CSID_CID_n_CFG_PLAIN_FORMAT_8		(0 << 8)
+#define CAMSS_CSID_CID_n_CFG_PLAIN_FORMAT_16		(1 << 8)
+#define CAMSS_CSID_CID_n_CFG_PLAIN_ALIGNMENT_LSB	(0 << 9)
+#define CAMSS_CSID_CID_n_CFG_PLAIN_ALIGNMENT_MSB	(1 << 9)
+#define CAMSS_CSID_CID_n_CFG_RDI_MODE_RAW_DUMP		(0 << 10)
+#define CAMSS_CSID_CID_n_CFG_RDI_MODE_PLAIN_PACKING	(1 << 10)
 #define CAMSS_CSID_IRQ_CLEAR_CMD(v)	((v) == CAMSS_8x16 ? 0x060 : 0x064)
 #define CAMSS_CSID_IRQ_MASK(v)		((v) == CAMSS_8x16 ? 0x064 : 0x068)
 #define CAMSS_CSID_IRQ_STATUS(v)	((v) == CAMSS_8x16 ? 0x068 : 0x06c)
@@ -330,6 +339,16 @@ static u32 csid_src_pad_code(struct csid_device *csid, u32 sink_code,
 		return sink_code;
 	} else if (csid->camss->version == CAMSS_8x96) {
 		switch (sink_code) {
+		case MEDIA_BUS_FMT_SBGGR10_1X10:
+		{
+			u32 src_code[] = {
+				MEDIA_BUS_FMT_SBGGR10_1X10,
+				MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE,
+			};
+
+			return csid_find_code(src_code, ARRAY_SIZE(src_code),
+					      index, src_req_code);
+		}
 		default:
 			if (index > 0)
 				return 0;
@@ -636,7 +655,19 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 		writel_relaxed(val, csid->base +
 			       CAMSS_CSID_CID_LUT_VC_n(ver, vc));
 
-		val = (df << 4) | 0x3;
+		val = CAMSS_CSID_CID_n_CFG_ISPIF_EN;
+		val |= CAMSS_CSID_CID_n_CFG_RDI_EN;
+		val |= df << CAMSS_CSID_CID_n_CFG_DECODE_FORMAT_SHIFT;
+		val |= CAMSS_CSID_CID_n_CFG_RDI_MODE_RAW_DUMP;
+		if (csid->camss->version == CAMSS_8x96 &&
+			csid->fmt[MSM_CSID_PAD_SINK].code ==
+					MEDIA_BUS_FMT_SBGGR10_1X10 &&
+			csid->fmt[MSM_CSID_PAD_SRC].code ==
+					MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE) {
+			val |= CAMSS_CSID_CID_n_CFG_RDI_MODE_PLAIN_PACKING;
+			val |= CAMSS_CSID_CID_n_CFG_PLAIN_FORMAT_16;
+			val |= CAMSS_CSID_CID_n_CFG_PLAIN_ALIGNMENT_LSB;
+		}
 		writel_relaxed(val, csid->base +
 			       CAMSS_CSID_CID_n_CFG(ver, cid));
 
diff --git a/drivers/media/platform/qcom/camss/camss-ispif.c b/drivers/media/platform/qcom/camss/camss-ispif.c
index 146d5d2..81d6351 100644
--- a/drivers/media/platform/qcom/camss/camss-ispif.c
+++ b/drivers/media/platform/qcom/camss/camss-ispif.c
@@ -76,6 +76,13 @@
 					(0x254 + 0x200 * (m) + 0x4 * (n))
 #define ISPIF_VFE_m_RDI_INTF_n_CID_MASK(m, n)	\
 					(0x264 + 0x200 * (m) + 0x4 * (n))
+/* PACK_CFG registers are 8x96 only */
+#define ISPIF_VFE_m_RDI_INTF_n_PACK_CFG_0(m, n)	\
+					(0x270 + 0x200 * (m) + 0x4 * (n))
+#define ISPIF_VFE_m_RDI_INTF_n_PACK_CFG_1(m, n)	\
+					(0x27c + 0x200 * (m) + 0x4 * (n))
+#define ISPIF_VFE_m_RDI_INTF_n_PACK_CFG_0_CID_c_PLAIN(c)	\
+					(1 << ((cid % 8) * 4))
 #define ISPIF_VFE_m_PIX_INTF_n_STATUS(m, n)	\
 					(0x2c0 + 0x200 * (m) + 0x4 * (n))
 #define ISPIF_VFE_m_RDI_INTF_n_STATUS(m, n)	\
@@ -128,6 +135,7 @@ static const u32 ispif_formats_8x96[] = {
 	MEDIA_BUS_FMT_SGBRG10_1X10,
 	MEDIA_BUS_FMT_SGRBG10_1X10,
 	MEDIA_BUS_FMT_SRGGB10_1X10,
+	MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE,
 	MEDIA_BUS_FMT_SBGGR12_1X12,
 	MEDIA_BUS_FMT_SGBRG12_1X12,
 	MEDIA_BUS_FMT_SGRBG12_1X12,
@@ -667,6 +675,54 @@ static void ispif_config_irq(struct ispif_device *ispif, enum ispif_intf intf,
 }
 
 /*
+ * ispif_config_pack - Config packing for PRDI mode
+ * @ispif: ISPIF device
+ * @code: media bus format code
+ * @intf: VFE interface
+ * @cid: desired CID to handle
+ * @vfe: VFE HW module id
+ * @enable: enable or disable
+ */
+static void ispif_config_pack(struct ispif_device *ispif, u32 code,
+			      enum ispif_intf intf, u8 cid, u8 vfe, u8 enable)
+{
+	u32 addr, val;
+
+	if (code != MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE)
+		return;
+
+	switch (intf) {
+	case RDI0:
+		if (cid < 8)
+			addr = ISPIF_VFE_m_RDI_INTF_n_PACK_CFG_0(vfe, 0);
+		else
+			addr = ISPIF_VFE_m_RDI_INTF_n_PACK_CFG_1(vfe, 0);
+		break;
+	case RDI1:
+		if (cid < 8)
+			addr = ISPIF_VFE_m_RDI_INTF_n_PACK_CFG_0(vfe, 1);
+		else
+			addr = ISPIF_VFE_m_RDI_INTF_n_PACK_CFG_1(vfe, 1);
+		break;
+	case RDI2:
+		if (cid < 8)
+			addr = ISPIF_VFE_m_RDI_INTF_n_PACK_CFG_0(vfe, 2);
+		else
+			addr = ISPIF_VFE_m_RDI_INTF_n_PACK_CFG_1(vfe, 2);
+		break;
+	default:
+		return;
+	}
+
+	if (enable)
+		val = ISPIF_VFE_m_RDI_INTF_n_PACK_CFG_0_CID_c_PLAIN(cid);
+	else
+		val = 0;
+
+	writel_relaxed(val, ispif->base + addr);
+}
+
+/*
  * ispif_set_intf_cmd - Set command to enable/disable interface
  * @ispif: ISPIF device
  * @cmd: interface command
@@ -734,6 +790,10 @@ static int ispif_set_stream(struct v4l2_subdev *sd, int enable)
 		ispif_select_csid(ispif, intf, csid, vfe, 1);
 		ispif_select_cid(ispif, intf, cid, vfe, 1);
 		ispif_config_irq(ispif, intf, vfe, 1);
+		if (to_camss(ispif)->version == CAMSS_8x96)
+			ispif_config_pack(ispif,
+					  line->fmt[MSM_ISPIF_PAD_SINK].code,
+					  intf, cid, vfe, 1);
 		ispif_set_intf_cmd(ispif, CMD_ENABLE_FRAME_BOUNDARY,
 				   intf, vfe, vc);
 	} else {
@@ -747,6 +807,10 @@ static int ispif_set_stream(struct v4l2_subdev *sd, int enable)
 			return ret;
 
 		mutex_lock(&ispif->config_lock);
+		if (to_camss(ispif)->version == CAMSS_8x96)
+			ispif_config_pack(ispif,
+					  line->fmt[MSM_ISPIF_PAD_SINK].code,
+					  intf, cid, vfe, 0);
 		ispif_config_irq(ispif, intf, vfe, 0);
 		ispif_select_cid(ispif, intf, cid, vfe, 0);
 		ispif_select_csid(ispif, intf, csid, vfe, 0);
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index d85d663..11d37b7 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -89,6 +89,7 @@ static const struct vfe_format formats_rdi_8x96[] = {
 	{ MEDIA_BUS_FMT_SGBRG10_1X10, 10 },
 	{ MEDIA_BUS_FMT_SGRBG10_1X10, 10 },
 	{ MEDIA_BUS_FMT_SRGGB10_1X10, 10 },
+	{ MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE, 16 },
 	{ MEDIA_BUS_FMT_SBGGR12_1X12, 12 },
 	{ MEDIA_BUS_FMT_SGBRG12_1X12, 12 },
 	{ MEDIA_BUS_FMT_SGRBG12_1X12, 12 },
diff --git a/drivers/media/platform/qcom/camss/camss-video.c b/drivers/media/platform/qcom/camss/camss-video.c
index e6e114a..28d53bf 100644
--- a/drivers/media/platform/qcom/camss/camss-video.c
+++ b/drivers/media/platform/qcom/camss/camss-video.c
@@ -101,6 +101,8 @@ static const struct camss_format_info formats_rdi_8x96[] = {
 	  { { 1, 1 } }, { { 1, 1 } }, { 10 } },
 	{ MEDIA_BUS_FMT_SRGGB10_1X10, V4L2_PIX_FMT_SRGGB10P, 1,
 	  { { 1, 1 } }, { { 1, 1 } }, { 10 } },
+	{ MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE, V4L2_PIX_FMT_SBGGR10, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
 	{ MEDIA_BUS_FMT_SBGGR12_1X12, V4L2_PIX_FMT_SBGGR12P, 1,
 	  { { 1, 1 } }, { { 1, 1 } }, { 12 } },
 	{ MEDIA_BUS_FMT_SGBRG12_1X12, V4L2_PIX_FMT_SGBRG12P, 1,
-- 
2.7.4
