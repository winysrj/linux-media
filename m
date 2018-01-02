Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6255 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753775AbeABDDM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Jan 2018 22:03:12 -0500
From: tian.shu.qiu@intel.com
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Qiu@vger.kernel.org, Tianshu <tian.shu.qiu@intel.com>
Subject: [PATCH] yavta: Add support for intel ipu3 specific raw formats
Date: Tue,  2 Jan 2018 11:02:37 +0800
Message-Id: <1514862157-4584-1-git-send-email-tian.shu.qiu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tianshu Qiu <tian.shu.qiu@intel.com>

Add support for these pixel formats:

V4L2_PIX_FMT_IPU3_SBGGR10
V4L2_PIX_FMT_IPU3_SGBRG10
V4L2_PIX_FMT_IPU3_SGRBG10
V4L2_PIX_FMT_IPU3_SRGGB10

Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
---
 include/linux/videodev2.h | 5 +++++
 yavta.c                   | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index b1e36ee553da..6f7cd9622ea8 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -659,6 +659,11 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_MT21C    v4l2_fourcc('M', 'T', '2', '1') /* Mediatek compressed block mode  */
 #define V4L2_PIX_FMT_INZI     v4l2_fourcc('I', 'N', 'Z', 'I') /* Intel Planar Greyscale 10-bit and Depth 16-bit */
 
+#define V4L2_PIX_FMT_IPU3_SBGGR10   v4l2_fourcc('i', 'p', '3', 'b') /* IPU3 packed 10-bit BGGR bayer */
+#define V4L2_PIX_FMT_IPU3_SGBRG10   v4l2_fourcc('i', 'p', '3', 'g') /* IPU3 packed 10-bit GBRG bayer */
+#define V4L2_PIX_FMT_IPU3_SGRBG10   v4l2_fourcc('i', 'p', '3', 'G') /* IPU3 packed 10-bit GRBG bayer */
+#define V4L2_PIX_FMT_IPU3_SRGGB10   v4l2_fourcc('i', 'p', '3', 'r') /* IPU3 packed 10-bit RGGB bayer */
+
 /* SDR formats - used only for Software Defined Radio devices */
 #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */
 #define V4L2_SDR_FMT_CU16LE       v4l2_fourcc('C', 'U', '1', '6') /* IQ u16le */
diff --git a/yavta.c b/yavta.c
index afe96331a520..524e549efd08 100644
--- a/yavta.c
+++ b/yavta.c
@@ -220,6 +220,10 @@ static struct v4l2_format_info {
 	{ "SGBRG10P", V4L2_PIX_FMT_SGBRG10P, 1 },
 	{ "SGRBG10P", V4L2_PIX_FMT_SGRBG10P, 1 },
 	{ "SRGGB10P", V4L2_PIX_FMT_SRGGB10P, 1 },
+	{ "IPU3_GRBG10", V4L2_PIX_FMT_IPU3_SGRBG10, 1 },
+	{ "IPU3_RGGB10", V4L2_PIX_FMT_IPU3_SRGGB10, 1 },
+	{ "IPU3_BGGR10", V4L2_PIX_FMT_IPU3_SBGGR10, 1 },
+	{ "IPU3_GBRG10", V4L2_PIX_FMT_IPU3_SGBRG10, 1 },
 	{ "SBGGR12", V4L2_PIX_FMT_SBGGR12, 1 },
 	{ "SGBRG12", V4L2_PIX_FMT_SGBRG12, 1 },
 	{ "SGRBG12", V4L2_PIX_FMT_SGRBG12, 1 },
-- 
2.7.4
