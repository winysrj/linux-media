Return-Path: <SRS0=0n2Q=QK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEEB5C282DA
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 16:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9732620821
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 16:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbfBCQEE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Feb 2019 11:04:04 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:33242 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727901AbfBCQEE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Feb 2019 11:04:04 -0500
Received: by wens.csie.org (Postfix, from userid 1000)
        id A7ED85FD40; Mon,  4 Feb 2019 00:04:01 +0800 (CST)
From:   Chen-Yu Tsai <wens@csie.org>
To:     Yong Deng <yong.deng@magewell.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] media: sun6i: Add support for RGB565 formats
Date:   Mon,  4 Feb 2019 00:03:57 +0800
Message-Id: <20190203160358.21050-3-wens@csie.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190203160358.21050-1-wens@csie.org>
References: <20190203160358.21050-1-wens@csie.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The CSI controller can take raw data from the data bus and output RGB565
format. The controller does not distinguish between RGB565 LE and BE.
Instead this is determined by the media bus format, i.e. the format or
order the sensor is sending data in.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 .../platform/sunxi/sun6i-csi/sun6i_csi.c      | 19 +++++++++++++++++--
 .../platform/sunxi/sun6i-csi/sun6i_csi.h      |  2 ++
 .../platform/sunxi/sun6i-csi/sun6i_video.c    |  2 ++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index 332cf81a7ecf..969762db30dd 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -143,6 +143,12 @@ bool sun6i_csi_is_format_supported(struct sun6i_csi *csi,
 			break;
 		}
 		break;
+
+	case V4L2_PIX_FMT_RGB565:
+		return (mbus_code == MEDIA_BUS_FMT_RGB565_2X8_LE);
+	case V4L2_PIX_FMT_RGB565X:
+		return (mbus_code == MEDIA_BUS_FMT_RGB565_2X8_BE);
+
 	default:
 		dev_dbg(sdev->dev, "Unsupported pixformat: 0x%x\n", pixformat);
 		break;
@@ -198,8 +204,8 @@ int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
 static enum csi_input_fmt get_csi_input_format(struct sun6i_csi_dev *sdev,
 					       u32 mbus_code, u32 pixformat)
 {
-	/* bayer */
-	if ((mbus_code & 0xF000) == 0x3000)
+	/* non-YUV */
+	if ((mbus_code & 0xF000) != 0x2000)
 		return CSI_INPUT_FORMAT_RAW;
 
 	switch (pixformat) {
@@ -268,6 +274,11 @@ static enum csi_output_fmt get_csi_output_format(struct sun6i_csi_dev *sdev,
 	case V4L2_PIX_FMT_YUV422P:
 		return buf_interlaced ? CSI_FRAME_PLANAR_YUV422 :
 					CSI_FIELD_PLANAR_YUV422;
+
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_RGB565X:
+		return buf_interlaced ? CSI_FRAME_RGB565 : CSI_FIELD_RGB565;
+
 	default:
 		dev_warn(sdev->dev, "Unsupported pixformat: 0x%x\n", pixformat);
 		break;
@@ -279,6 +290,10 @@ static enum csi_output_fmt get_csi_output_format(struct sun6i_csi_dev *sdev,
 static enum csi_input_seq get_csi_input_seq(struct sun6i_csi_dev *sdev,
 					    u32 mbus_code, u32 pixformat)
 {
+	/* Input sequence does not apply to non-YUV formats */
+	if ((mbus_code & 0xF000) != 0x2000)
+		return 0;
+
 	switch (pixformat) {
 	case V4L2_PIX_FMT_HM12:
 	case V4L2_PIX_FMT_NV12:
diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
index 0bb000712c33..585cd9669417 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
@@ -117,6 +117,8 @@ static inline int sun6i_csi_get_bpp(unsigned int pixformat)
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV61:
 	case V4L2_PIX_FMT_YUV422P:
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_RGB565X:
 		return 16;
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_BGR24:
diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
index b04300c3811f..bff6fe832803 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
@@ -56,6 +56,8 @@ static const u32 supported_pixformats[] = {
 	V4L2_PIX_FMT_NV16,
 	V4L2_PIX_FMT_NV61,
 	V4L2_PIX_FMT_YUV422P,
+	V4L2_PIX_FMT_RGB565,
+	V4L2_PIX_FMT_RGB565X,
 };
 
 static bool is_pixformat_valid(unsigned int pixformat)
-- 
2.20.1

