Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:40018 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388213AbeGWMEs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 08:04:48 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v3 32/35] media: camss: Add support for 10-bit grayscale formats
Date: Mon, 23 Jul 2018 14:02:49 +0300
Message-Id: <1532343772-27382-33-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for 10-bit packed V4L2_PIX_FMT_Y10P (on 8x16 and 8x96)
and unpacked V4L2_PIX_FMT_Y10 (on 8x96 only) pixel formats.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-csid.c   | 50 +++++++++++++++++++-----
 drivers/media/platform/qcom/camss/camss-csiphy.c |  2 +
 drivers/media/platform/qcom/camss/camss-ispif.c  |  6 ++-
 drivers/media/platform/qcom/camss/camss-vfe.c    |  3 ++
 drivers/media/platform/qcom/camss/camss-video.c  |  6 +++
 5 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
index 0b7f90d..a581377 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -193,7 +193,14 @@ static const struct csid_format csid_formats_8x16[] = {
 		DECODE_FORMAT_UNCOMPRESSED_12_BIT,
 		12,
 		1,
-	}
+	},
+	{
+		MEDIA_BUS_FMT_Y10_1X10,
+		DATA_TYPE_RAW_10BIT,
+		DECODE_FORMAT_UNCOMPRESSED_10_BIT,
+		10,
+		1,
+	},
 };
 
 static const struct csid_format csid_formats_8x96[] = {
@@ -336,7 +343,14 @@ static const struct csid_format csid_formats_8x96[] = {
 		DECODE_FORMAT_UNCOMPRESSED_14_BIT,
 		14,
 		1,
-	}
+	},
+	{
+		MEDIA_BUS_FMT_Y10_1X10,
+		DATA_TYPE_RAW_10BIT,
+		DECODE_FORMAT_UNCOMPRESSED_10_BIT,
+		10,
+		1,
+	},
 };
 
 static u32 csid_find_code(u32 *code, unsigned int n_code,
@@ -379,6 +393,16 @@ static u32 csid_src_pad_code(struct csid_device *csid, u32 sink_code,
 			return csid_find_code(src_code, ARRAY_SIZE(src_code),
 					      index, src_req_code);
 		}
+		case MEDIA_BUS_FMT_Y10_1X10:
+		{
+			u32 src_code[] = {
+				MEDIA_BUS_FMT_Y10_1X10,
+				MEDIA_BUS_FMT_Y10_2X8_PADHI_LE,
+			};
+
+			return csid_find_code(src_code, ARRAY_SIZE(src_code),
+					      index, src_req_code);
+		}
 		default:
 			if (index > 0)
 				return 0;
@@ -682,15 +706,21 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 		val |= CAMSS_CSID_CID_n_CFG_RDI_EN;
 		val |= df << CAMSS_CSID_CID_n_CFG_DECODE_FORMAT_SHIFT;
 		val |= CAMSS_CSID_CID_n_CFG_RDI_MODE_RAW_DUMP;
-		if (csid->camss->version == CAMSS_8x96 &&
-			csid->fmt[MSM_CSID_PAD_SINK].code ==
-					MEDIA_BUS_FMT_SBGGR10_1X10 &&
-			csid->fmt[MSM_CSID_PAD_SRC].code ==
-					MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE) {
-			val |= CAMSS_CSID_CID_n_CFG_RDI_MODE_PLAIN_PACKING;
-			val |= CAMSS_CSID_CID_n_CFG_PLAIN_FORMAT_16;
-			val |= CAMSS_CSID_CID_n_CFG_PLAIN_ALIGNMENT_LSB;
+
+		if (csid->camss->version == CAMSS_8x96) {
+			u32 sink_code = csid->fmt[MSM_CSID_PAD_SINK].code;
+			u32 src_code = csid->fmt[MSM_CSID_PAD_SRC].code;
+
+			if ((sink_code == MEDIA_BUS_FMT_SBGGR10_1X10 &&
+			     src_code == MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE) ||
+			    (sink_code == MEDIA_BUS_FMT_Y10_1X10 &&
+			     src_code == MEDIA_BUS_FMT_Y10_2X8_PADHI_LE)) {
+				val |= CAMSS_CSID_CID_n_CFG_RDI_MODE_PLAIN_PACKING;
+				val |= CAMSS_CSID_CID_n_CFG_PLAIN_FORMAT_16;
+				val |= CAMSS_CSID_CID_n_CFG_PLAIN_ALIGNMENT_LSB;
+			}
 		}
+
 		writel_relaxed(val, csid->base +
 			       CAMSS_CSID_CID_n_CFG(ver, cid));
 
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
index 0b7bf1e..924f854 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
@@ -48,6 +48,7 @@ static const struct csiphy_format csiphy_formats_8x16[] = {
 	{ MEDIA_BUS_FMT_SGBRG12_1X12, 12 },
 	{ MEDIA_BUS_FMT_SGRBG12_1X12, 12 },
 	{ MEDIA_BUS_FMT_SRGGB12_1X12, 12 },
+	{ MEDIA_BUS_FMT_Y10_1X10, 10 },
 };
 
 static const struct csiphy_format csiphy_formats_8x96[] = {
@@ -71,6 +72,7 @@ static const struct csiphy_format csiphy_formats_8x96[] = {
 	{ MEDIA_BUS_FMT_SGBRG14_1X14, 14 },
 	{ MEDIA_BUS_FMT_SGRBG14_1X14, 14 },
 	{ MEDIA_BUS_FMT_SRGGB14_1X14, 14 },
+	{ MEDIA_BUS_FMT_Y10_1X10, 10 },
 };
 
 /*
diff --git a/drivers/media/platform/qcom/camss/camss-ispif.c b/drivers/media/platform/qcom/camss/camss-ispif.c
index 649596a..02f84bc 100644
--- a/drivers/media/platform/qcom/camss/camss-ispif.c
+++ b/drivers/media/platform/qcom/camss/camss-ispif.c
@@ -120,6 +120,7 @@ static const u32 ispif_formats_8x16[] = {
 	MEDIA_BUS_FMT_SGBRG12_1X12,
 	MEDIA_BUS_FMT_SGRBG12_1X12,
 	MEDIA_BUS_FMT_SRGGB12_1X12,
+	MEDIA_BUS_FMT_Y10_1X10,
 };
 
 static const u32 ispif_formats_8x96[] = {
@@ -144,6 +145,8 @@ static const u32 ispif_formats_8x96[] = {
 	MEDIA_BUS_FMT_SGBRG14_1X14,
 	MEDIA_BUS_FMT_SGRBG14_1X14,
 	MEDIA_BUS_FMT_SRGGB14_1X14,
+	MEDIA_BUS_FMT_Y10_1X10,
+	MEDIA_BUS_FMT_Y10_2X8_PADHI_LE,
 };
 
 /*
@@ -687,7 +690,8 @@ static void ispif_config_pack(struct ispif_device *ispif, u32 code,
 {
 	u32 addr, val;
 
-	if (code != MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE)
+	if (code != MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE &&
+	    code != MEDIA_BUS_FMT_Y10_2X8_PADHI_LE)
 		return;
 
 	switch (intf) {
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 269b7c8..053e55d 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -70,6 +70,7 @@ static const struct vfe_format formats_rdi_8x16[] = {
 	{ MEDIA_BUS_FMT_SGBRG12_1X12, 12 },
 	{ MEDIA_BUS_FMT_SGRBG12_1X12, 12 },
 	{ MEDIA_BUS_FMT_SRGGB12_1X12, 12 },
+	{ MEDIA_BUS_FMT_Y10_1X10, 10 },
 };
 
 static const struct vfe_format formats_pix_8x16[] = {
@@ -101,6 +102,8 @@ static const struct vfe_format formats_rdi_8x96[] = {
 	{ MEDIA_BUS_FMT_SGBRG14_1X14, 14 },
 	{ MEDIA_BUS_FMT_SGRBG14_1X14, 14 },
 	{ MEDIA_BUS_FMT_SRGGB14_1X14, 14 },
+	{ MEDIA_BUS_FMT_Y10_1X10, 10 },
+	{ MEDIA_BUS_FMT_Y10_2X8_PADHI_LE, 16 },
 };
 
 static const struct vfe_format formats_pix_8x96[] = {
diff --git a/drivers/media/platform/qcom/camss/camss-video.c b/drivers/media/platform/qcom/camss/camss-video.c
index 2e19bc8..c9bb0d0 100644
--- a/drivers/media/platform/qcom/camss/camss-video.c
+++ b/drivers/media/platform/qcom/camss/camss-video.c
@@ -74,6 +74,8 @@ static const struct camss_format_info formats_rdi_8x16[] = {
 	  { { 1, 1 } }, { { 1, 1 } }, { 12 } },
 	{ MEDIA_BUS_FMT_SRGGB12_1X12, V4L2_PIX_FMT_SRGGB12P, 1,
 	  { { 1, 1 } }, { { 1, 1 } }, { 12 } },
+	{ MEDIA_BUS_FMT_Y10_1X10, V4L2_PIX_FMT_Y10P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 10 } },
 };
 
 static const struct camss_format_info formats_rdi_8x96[] = {
@@ -119,6 +121,10 @@ static const struct camss_format_info formats_rdi_8x96[] = {
 	  { { 1, 1 } }, { { 1, 1 } }, { 14 } },
 	{ MEDIA_BUS_FMT_SRGGB14_1X14, V4L2_PIX_FMT_SRGGB14P, 1,
 	  { { 1, 1 } }, { { 1, 1 } }, { 14 } },
+	{ MEDIA_BUS_FMT_Y10_1X10, V4L2_PIX_FMT_Y10P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 10 } },
+	{ MEDIA_BUS_FMT_Y10_2X8_PADHI_LE, V4L2_PIX_FMT_Y10, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
 };
 
 static const struct camss_format_info formats_pix_8x16[] = {
-- 
2.7.4
