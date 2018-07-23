Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:40019 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388216AbeGWMEt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 08:04:49 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v3 35/35] media: v4l2-ioctl: Add format descriptions for packed Bayer raw14 pixel formats
Date: Mon, 23 Jul 2018 14:02:52 +0300
Message-Id: <1532343772-27382-36-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This removes warning "Unknown pixelformat" for the following formats:
        V4L2_PIX_FMT_SBGGR14P
        V4L2_PIX_FMT_SGBRG14P
        V4L2_PIX_FMT_SGRBG14P
        V4L2_PIX_FMT_SRGGB14P

CC: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 2e3b1f0..e8f7c89 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1260,6 +1260,10 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_SGBRG12P:	descr = "12-bit Bayer GBGB/RGRG Packed"; break;
 	case V4L2_PIX_FMT_SGRBG12P:	descr = "12-bit Bayer GRGR/BGBG Packed"; break;
 	case V4L2_PIX_FMT_SRGGB12P:	descr = "12-bit Bayer RGRG/GBGB Packed"; break;
+	case V4L2_PIX_FMT_SBGGR14P:	descr = "14-bit Bayer BGBG/GRGR Packed"; break;
+	case V4L2_PIX_FMT_SGBRG14P:	descr = "14-bit Bayer GBGB/RGRG Packed"; break;
+	case V4L2_PIX_FMT_SGRBG14P:	descr = "14-bit Bayer GRGR/BGBG Packed"; break;
+	case V4L2_PIX_FMT_SRGGB14P:	descr = "14-bit Bayer RGRG/GBGB Packed"; break;
 	case V4L2_PIX_FMT_SBGGR16:	descr = "16-bit Bayer BGBG/GRGR"; break;
 	case V4L2_PIX_FMT_SGBRG16:	descr = "16-bit Bayer GBGB/RGRG"; break;
 	case V4L2_PIX_FMT_SGRBG16:	descr = "16-bit Bayer GRGR/BGBG"; break;
-- 
2.7.4
