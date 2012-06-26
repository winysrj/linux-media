Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37295 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab2FZNpl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 09:45:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Enrico <ebutera@users.berlios.de>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Abhishek Reddy Kondaveeti <areddykondaveeti@aptina.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 3/6] omap3isp: csi2: Add V4L2_MBUS_FMT_YUYV8_2X8 support
Date: Tue, 26 Jun 2012 15:45:36 +0200
Message-Id: <1340718339-29915-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1340718339-29915-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1340718339-29915-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ivaylo Petrov <ivpetrov@mm-sol.com>

Tested with ov9740 and

struct isp_csi2_platform_data {
	.interface = ISP_INTERFACE_CSI2A_PHY2,
	.bus = {
		.csi2 = {
			.crc		= 1,
			.vpclk_div	= 1,
		}
	},
}

Signed-off-by: Ivaylo Petrov <ivpetrov@mm-sol.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispcsi2.c |   27 +++++++++++++++++++++++++--
 1 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispcsi2.c b/drivers/media/video/omap3isp/ispcsi2.c
index a172436..6a3ff79 100644
--- a/drivers/media/video/omap3isp/ispcsi2.c
+++ b/drivers/media/video/omap3isp/ispcsi2.c
@@ -96,11 +96,12 @@ static const unsigned int csi2_input_fmts[] = {
 	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8,
 	V4L2_MBUS_FMT_SGBRG10_1X10,
 	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8,
+	V4L2_MBUS_FMT_YUYV8_2X8,
 };
 
 /* To set the format on the CSI2 requires a mapping function that takes
  * the following inputs:
- * - 2 different formats (at this time)
+ * - 3 different formats (at this time)
  * - 2 destinations (mem, vp+mem) (vp only handled separately)
  * - 2 decompression options (on, off)
  * - 2 isp revisions (certain format must be handled differently on OMAP3630)
@@ -108,7 +109,7 @@ static const unsigned int csi2_input_fmts[] = {
  * Array indices as follows: [format][dest][decompr][is_3630]
  * Not all combinations are valid. 0 means invalid.
  */
-static const u16 __csi2_fmt_map[2][2][2][2] = {
+static const u16 __csi2_fmt_map[3][2][2][2] = {
 	/* RAW10 formats */
 	{
 		/* Output to memory */
@@ -147,6 +148,25 @@ static const u16 __csi2_fmt_map[2][2][2][2] = {
 			  CSI2_USERDEF_8BIT_DATA1_DPCM10_VP },
 		},
 	},
+	/* YUYV8 2X8 formats */
+	{
+		/* Output to memory */
+		{
+			/* No DPCM decompression */
+			{ CSI2_PIX_FMT_YUV422_8BIT,
+			  CSI2_PIX_FMT_YUV422_8BIT },
+			/* DPCM decompression */
+			{ 0, 0 },
+		},
+		/* Output to both */
+		{
+			/* No DPCM decompression */
+			{ CSI2_PIX_FMT_YUV422_8BIT_VP,
+			  CSI2_PIX_FMT_YUV422_8BIT_VP },
+			/* DPCM decompression */
+			{ 0, 0 },
+		},
+	},
 };
 
 /*
@@ -173,6 +193,9 @@ static u16 csi2_ctx_map_format(struct isp_csi2_device *csi2)
 	case V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8:
 		fmtidx = 1;
 		break;
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+		fmtidx = 2;
+		break;
 	default:
 		WARN(1, KERN_ERR "CSI2: pixel format %08x unsupported!\n",
 		     fmt->code);
-- 
1.7.3.4

