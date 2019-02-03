Return-Path: <SRS0=0n2Q=QK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6FBC169C4
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 16:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A47120821
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 16:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbfBCQED (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Feb 2019 11:04:03 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:33254 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbfBCQED (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Feb 2019 11:04:03 -0500
Received: by wens.csie.org (Postfix, from userid 1000)
        id B2ADE5FD5E; Mon,  4 Feb 2019 00:04:01 +0800 (CST)
From:   Chen-Yu Tsai <wens@csie.org>
To:     Yong Deng <yong.deng@magewell.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] media: sun6i: Add support for JPEG media bus format
Date:   Mon,  4 Feb 2019 00:03:58 +0800
Message-Id: <20190203160358.21050-4-wens@csie.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190203160358.21050-1-wens@csie.org>
References: <20190203160358.21050-1-wens@csie.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The CSI controller can take raw data from the data bus and output it
directly to capture buffers. This can be used to support the JPEG media
bus format.

While the controller can report minimum and maximum bytes per line, it
has no way to report how many lines were captured in the last frame.
Thus, even when the on-bus data is framed correctly, we have no way to
accertain the actual amount of data captured, unless we scan the buffer
for JPEG EOI markers, or sequential zeros. For now we leave bytesused
alone, and leave it up to userspace applications to parse the data.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c   | 6 ++++++
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h   | 1 +
 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index 969762db30dd..c06776f652c8 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -149,6 +149,9 @@ bool sun6i_csi_is_format_supported(struct sun6i_csi *csi,
 	case V4L2_PIX_FMT_RGB565X:
 		return (mbus_code == MEDIA_BUS_FMT_RGB565_2X8_BE);
 
+	case V4L2_PIX_FMT_JPEG:
+		return (mbus_code == MEDIA_BUS_FMT_JPEG_1X8);
+
 	default:
 		dev_dbg(sdev->dev, "Unsupported pixformat: 0x%x\n", pixformat);
 		break;
@@ -279,6 +282,9 @@ static enum csi_output_fmt get_csi_output_format(struct sun6i_csi_dev *sdev,
 	case V4L2_PIX_FMT_RGB565X:
 		return buf_interlaced ? CSI_FRAME_RGB565 : CSI_FIELD_RGB565;
 
+	case V4L2_PIX_FMT_JPEG:
+		return buf_interlaced ? CSI_FRAME_RAW_8 : CSI_FIELD_RAW_8;
+
 	default:
 		dev_warn(sdev->dev, "Unsupported pixformat: 0x%x\n", pixformat);
 		break;
diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
index 585cd9669417..f30a210e9caa 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
@@ -94,6 +94,7 @@ static inline int sun6i_csi_get_bpp(unsigned int pixformat)
 	case V4L2_PIX_FMT_SGBRG8:
 	case V4L2_PIX_FMT_SGRBG8:
 	case V4L2_PIX_FMT_SRGGB8:
+	case V4L2_PIX_FMT_JPEG:
 		return 8;
 	case V4L2_PIX_FMT_SBGGR10:
 	case V4L2_PIX_FMT_SGBRG10:
diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
index bff6fe832803..1fd16861f111 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
@@ -58,6 +58,7 @@ static const u32 supported_pixformats[] = {
 	V4L2_PIX_FMT_YUV422P,
 	V4L2_PIX_FMT_RGB565,
 	V4L2_PIX_FMT_RGB565X,
+	V4L2_PIX_FMT_JPEG,
 };
 
 static bool is_pixformat_valid(unsigned int pixformat)
-- 
2.20.1

