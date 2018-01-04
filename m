Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54042 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751580AbeADDsY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 22:48:24 -0500
From: tian.shu.qiu@intel.com
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Qiu@vger.kernel.org, Tianshu <tian.shu.qiu@intel.com>
Subject: [MAIN PATCH v1 1/2] Update headers from upstream kernel
Date: Thu,  4 Jan 2018 11:47:44 +0800
Message-Id: <1515037666-29281-2-git-send-email-tian.shu.qiu@intel.com>
In-Reply-To: <1515037666-29281-1-git-send-email-tian.shu.qiu@intel.com>
References: <1515037666-29281-1-git-send-email-tian.shu.qiu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tianshu Qiu <tian.shu.qiu@intel.com>

Upstream commit 6f0e5fd39143a59c22d60e7befc4f33f22aeed2f

Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
---
 include/linux/videodev2.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index b1e36ee553da..afa4d09c59a3 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: ((GPL-2.0+ WITH Linux-syscall-note) OR BSD-3-Clause) */
 /*
  *  Video for Linux Two header file
  *
@@ -599,6 +600,11 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SGBRG12 v4l2_fourcc('G', 'B', '1', '2') /* 12  GBGB.. RGRG.. */
 #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
 #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
+	/* 12bit raw bayer packed, 6 bytes for every 4 pixels */
+#define V4L2_PIX_FMT_SBGGR12P v4l2_fourcc('p', 'B', 'C', 'C')
+#define V4L2_PIX_FMT_SGBRG12P v4l2_fourcc('p', 'G', 'C', 'C')
+#define V4L2_PIX_FMT_SGRBG12P v4l2_fourcc('p', 'g', 'C', 'C')
+#define V4L2_PIX_FMT_SRGGB12P v4l2_fourcc('p', 'R', 'C', 'C')
 #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
 #define V4L2_PIX_FMT_SGBRG16 v4l2_fourcc('G', 'B', '1', '6') /* 16  GBGB.. RGRG.. */
 #define V4L2_PIX_FMT_SGRBG16 v4l2_fourcc('G', 'R', '1', '6') /* 16  GRGR.. BGBG.. */
@@ -659,12 +665,21 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_MT21C    v4l2_fourcc('M', 'T', '2', '1') /* Mediatek compressed block mode  */
 #define V4L2_PIX_FMT_INZI     v4l2_fourcc('I', 'N', 'Z', 'I') /* Intel Planar Greyscale 10-bit and Depth 16-bit */
 
+/* 10bit raw bayer packed, 32 bytes for every 25 pixels, last LSB 6 bits unused */
+#define V4L2_PIX_FMT_IPU3_SBGGR10	v4l2_fourcc('i', 'p', '3', 'b') /* IPU3 packed 10-bit BGGR bayer */
+#define V4L2_PIX_FMT_IPU3_SGBRG10	v4l2_fourcc('i', 'p', '3', 'g') /* IPU3 packed 10-bit GBRG bayer */
+#define V4L2_PIX_FMT_IPU3_SGRBG10	v4l2_fourcc('i', 'p', '3', 'G') /* IPU3 packed 10-bit GRBG bayer */
+#define V4L2_PIX_FMT_IPU3_SRGGB10	v4l2_fourcc('i', 'p', '3', 'r') /* IPU3 packed 10-bit RGGB bayer */
+
 /* SDR formats - used only for Software Defined Radio devices */
 #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */
 #define V4L2_SDR_FMT_CU16LE       v4l2_fourcc('C', 'U', '1', '6') /* IQ u16le */
 #define V4L2_SDR_FMT_CS8          v4l2_fourcc('C', 'S', '0', '8') /* complex s8 */
 #define V4L2_SDR_FMT_CS14LE       v4l2_fourcc('C', 'S', '1', '4') /* complex s14le */
 #define V4L2_SDR_FMT_RU12LE       v4l2_fourcc('R', 'U', '1', '2') /* real u12le */
+#define V4L2_SDR_FMT_PCU16BE	  v4l2_fourcc('P', 'C', '1', '6') /* planar complex u16be */
+#define V4L2_SDR_FMT_PCU18BE	  v4l2_fourcc('P', 'C', '1', '8') /* planar complex u18be */
+#define V4L2_SDR_FMT_PCU20BE	  v4l2_fourcc('P', 'C', '2', '0') /* planar complex u20be */
 
 /* Touch formats - used for Touch devices */
 #define V4L2_TCH_FMT_DELTA_TD16	v4l2_fourcc('T', 'D', '1', '6') /* 16-bit signed deltas */
-- 
2.7.4
