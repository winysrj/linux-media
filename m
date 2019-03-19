Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D701C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D03BB217F9
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbfCSV60 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:58:26 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:37289 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727902AbfCSV60 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:58:26 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id ACC3FC0008;
        Tue, 19 Mar 2019 21:58:21 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [RFC PATCH 20/20] media: sun6i: Convert to the image format API
Date:   Tue, 19 Mar 2019 22:57:25 +0100
Message-Id: <e3dea8728ab535a8d855861ff07bc74a3e506842.1553032382.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The image format API allows us to remove some of the computation we need to
handle the various video formats.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 88 +++------------
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h | 46 +--------
 2 files changed, 22 insertions(+), 112 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index 6950585edb5a..d4693efb9e02 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -466,72 +466,27 @@ static void sun6i_csi_set_format(struct sun6i_csi_dev *sdev)
 static void sun6i_csi_set_window(struct sun6i_csi_dev *sdev)
 {
 	struct sun6i_csi_config *config = &sdev->csi.config;
-	u32 bytesperline_y;
-	u32 bytesperline_c;
+	const struct image_format_info *info =
+		image_format_v4l2_lookup(config->pixelformat);
 	int *planar_offset = sdev->planar_offset;
-	u32 width = config->width;
-	u32 height = config->height;
-	u32 hor_len = width;
+	u32 bytesperline_y = image_format_plane_stride(info, config->width, 0);
+	u32 bytesperline_c = image_format_plane_stride(info, config->width, 1);
+	unsigned int i;
 
-	switch (config->pixelformat) {
-	case V4L2_PIX_FMT_YUYV:
-	case V4L2_PIX_FMT_YVYU:
-	case V4L2_PIX_FMT_UYVY:
-	case V4L2_PIX_FMT_VYUY:
-		dev_dbg(sdev->dev,
-			"Horizontal length should be 2 times of width for packed YUV formats!\n");
-		hor_len = width * 2;
-		break;
-	default:
-		break;
+	offset = 0;
+	for (i = 0; i < info->num_planes; i++) {
+		planar_offset[i] = offset;
+
+		offset += info_format_plane_size(info, config->width,
+						 config->height, i);
 	}
 
 	regmap_write(sdev->regmap, CSI_CH_HSIZE_REG,
-		     CSI_CH_HSIZE_HOR_LEN(hor_len) |
+		     CSI_CH_HSIZE_HOR_LEN(bytesperline_c) |
 		     CSI_CH_HSIZE_HOR_START(0));
 	regmap_write(sdev->regmap, CSI_CH_VSIZE_REG,
-		     CSI_CH_VSIZE_VER_LEN(height) |
+		     CSI_CH_VSIZE_VER_LEN(config->height) |
 		     CSI_CH_VSIZE_VER_START(0));
-
-	planar_offset[0] = 0;
-	switch (config->pixelformat) {
-	case V4L2_PIX_FMT_HM12:
-	case V4L2_PIX_FMT_NV12:
-	case V4L2_PIX_FMT_NV21:
-	case V4L2_PIX_FMT_NV16:
-	case V4L2_PIX_FMT_NV61:
-		bytesperline_y = width;
-		bytesperline_c = width;
-		planar_offset[1] = bytesperline_y * height;
-		planar_offset[2] = -1;
-		break;
-	case V4L2_PIX_FMT_YUV420:
-	case V4L2_PIX_FMT_YVU420:
-		bytesperline_y = width;
-		bytesperline_c = width / 2;
-		planar_offset[1] = bytesperline_y * height;
-		planar_offset[2] = planar_offset[1] +
-				bytesperline_c * height / 2;
-		break;
-	case V4L2_PIX_FMT_YUV422P:
-		bytesperline_y = width;
-		bytesperline_c = width / 2;
-		planar_offset[1] = bytesperline_y * height;
-		planar_offset[2] = planar_offset[1] +
-				bytesperline_c * height;
-		break;
-	default: /* raw */
-		dev_dbg(sdev->dev,
-			"Calculating pixelformat(0x%x)'s bytesperline as a packed format\n",
-			config->pixelformat);
-		bytesperline_y = (sun6i_csi_get_bpp(config->pixelformat) *
-				  config->width) / 8;
-		bytesperline_c = 0;
-		planar_offset[1] = -1;
-		planar_offset[2] = -1;
-		break;
-	}
-
 	regmap_write(sdev->regmap, CSI_CH_BUF_LEN_REG,
 		     CSI_CH_BUF_LEN_BUF_LEN_C(bytesperline_c) |
 		     CSI_CH_BUF_LEN_BUF_LEN_Y(bytesperline_y));
@@ -557,15 +512,16 @@ int sun6i_csi_update_config(struct sun6i_csi *csi,
 void sun6i_csi_update_buf_addr(struct sun6i_csi *csi, dma_addr_t addr)
 {
 	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
+	struct sun6i_csi_config *config = &sdev->csi.config;
+	const struct image_format_info *info =
+		image_format_v4l2_lookup(config->pixelformat);
+	unsigned int i;
+
+	for (i = 0; i < info->num_planes; i++) {
+		regmap_write(sdev->regmap, CSI_CH_BUF_REG(i, 0),
+			     (addr + sdev->planar_offset[i]) >> 2);
 
-	regmap_write(sdev->regmap, CSI_CH_F0_BUFA_REG,
-		     (addr + sdev->planar_offset[0]) >> 2);
-	if (sdev->planar_offset[1] != -1)
-		regmap_write(sdev->regmap, CSI_CH_F1_BUFA_REG,
-			     (addr + sdev->planar_offset[1]) >> 2);
-	if (sdev->planar_offset[2] != -1)
-		regmap_write(sdev->regmap, CSI_CH_F2_BUFA_REG,
-			     (addr + sdev->planar_offset[2]) >> 2);
+	}
 }
 
 void sun6i_csi_set_stream(struct sun6i_csi *csi, bool enable)
diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
index 0bb000712c33..3c57ec89b108 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
@@ -86,50 +86,4 @@ void sun6i_csi_update_buf_addr(struct sun6i_csi *csi, dma_addr_t addr);
  */
 void sun6i_csi_set_stream(struct sun6i_csi *csi, bool enable);
 
-/* get bpp form v4l2 pixformat */
-static inline int sun6i_csi_get_bpp(unsigned int pixformat)
-{
-	switch (pixformat) {
-	case V4L2_PIX_FMT_SBGGR8:
-	case V4L2_PIX_FMT_SGBRG8:
-	case V4L2_PIX_FMT_SGRBG8:
-	case V4L2_PIX_FMT_SRGGB8:
-		return 8;
-	case V4L2_PIX_FMT_SBGGR10:
-	case V4L2_PIX_FMT_SGBRG10:
-	case V4L2_PIX_FMT_SGRBG10:
-	case V4L2_PIX_FMT_SRGGB10:
-		return 10;
-	case V4L2_PIX_FMT_SBGGR12:
-	case V4L2_PIX_FMT_SGBRG12:
-	case V4L2_PIX_FMT_SGRBG12:
-	case V4L2_PIX_FMT_SRGGB12:
-	case V4L2_PIX_FMT_HM12:
-	case V4L2_PIX_FMT_NV12:
-	case V4L2_PIX_FMT_NV21:
-	case V4L2_PIX_FMT_YUV420:
-	case V4L2_PIX_FMT_YVU420:
-		return 12;
-	case V4L2_PIX_FMT_YUYV:
-	case V4L2_PIX_FMT_YVYU:
-	case V4L2_PIX_FMT_UYVY:
-	case V4L2_PIX_FMT_VYUY:
-	case V4L2_PIX_FMT_NV16:
-	case V4L2_PIX_FMT_NV61:
-	case V4L2_PIX_FMT_YUV422P:
-		return 16;
-	case V4L2_PIX_FMT_RGB24:
-	case V4L2_PIX_FMT_BGR24:
-		return 24;
-	case V4L2_PIX_FMT_RGB32:
-	case V4L2_PIX_FMT_BGR32:
-		return 32;
-	default:
-		WARN(1, "Unsupported pixformat: 0x%x\n", pixformat);
-		break;
-	}
-
-	return 0;
-}
-
 #endif /* __SUN6I_CSI_H__ */
-- 
git-series 0.9.1
