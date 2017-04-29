Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:43999 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936774AbdD2XfG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Apr 2017 19:35:06 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH 1/3] [media] videodev2.h, v4l2-ioctl: add IPU3 raw10 color format
Date: Sat, 29 Apr 2017 18:34:34 -0500
Message-Id: <2c2cbc1df3f81dba37e7bd31c3d23fd2df2295af.1493479141.git.yong.zhi@intel.com>
In-Reply-To: <cover.1493479141.git.yong.zhi@intel.com>
References: <cover.1493479141.git.yong.zhi@intel.com>
In-Reply-To: <cover.1493479141.git.yong.zhi@intel.com>
References: <cover.1493479141.git.yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add IPU3 specific formats:

    V4L2_PIX_FMT_IPU3_SBGGR10
    V4L2_PIX_FMT_IPU3_SGBRG10
    V4L2_PIX_FMT_IPU3_SGRBG10
    V4L2_PIX_FMT_IPU3_SRGGB10

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++++
 include/uapi/linux/videodev2.h       | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index e5a2187..fb1387f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1202,6 +1202,10 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_SGBRG10P:	descr = "10-bit Bayer GBGB/RGRG Packed"; break;
 	case V4L2_PIX_FMT_SGRBG10P:	descr = "10-bit Bayer GRGR/BGBG Packed"; break;
 	case V4L2_PIX_FMT_SRGGB10P:	descr = "10-bit Bayer RGRG/GBGB Packed"; break;
+	case V4L2_PIX_FMT_IPU3_SBGGR10: descr = "10-bit bayer BGGR IPU3 Packed"; break;
+	case V4L2_PIX_FMT_IPU3_SGBRG10: descr = "10-bit bayer GBRG IPU3 Packed"; break;
+	case V4L2_PIX_FMT_IPU3_SGRBG10: descr = "10-bit bayer GRBG IPU3 Packed"; break;
+	case V4L2_PIX_FMT_IPU3_SRGGB10: descr = "10-bit bayer RGGB IPU3 Packed"; break;
 	case V4L2_PIX_FMT_SBGGR10ALAW8:	descr = "8-bit Bayer BGBG/GRGR (A-law)"; break;
 	case V4L2_PIX_FMT_SGBRG10ALAW8:	descr = "8-bit Bayer GBGB/RGRG (A-law)"; break;
 	case V4L2_PIX_FMT_SGRBG10ALAW8:	descr = "8-bit Bayer GRGR/BGBG (A-law)"; break;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 2b8feb8..7dddbc9 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -662,6 +662,10 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /* Depth data 16-bit */
 #define V4L2_PIX_FMT_MT21C    v4l2_fourcc('M', 'T', '2', '1') /* Mediatek compressed block mode  */
 #define V4L2_PIX_FMT_INZI     v4l2_fourcc('I', 'N', 'Z', 'I') /* Intel Planar Greyscale 10-bit and Depth 16-bit */
+#define V4L2_PIX_FMT_IPU3_SBGGR10	v4l2_fourcc('i', 'p', '3', 'b') /* IPU3 packed 10-bit BGGR bayer */
+#define V4L2_PIX_FMT_IPU3_SGBRG10	v4l2_fourcc('i', 'p', '3', 'g') /* IPU3 packed 10-bit GBRG bayer */
+#define V4L2_PIX_FMT_IPU3_SGRBG10	v4l2_fourcc('i', 'p', '3', 'G') /* IPU3 packed 10-bit GRBG bayer */
+#define V4L2_PIX_FMT_IPU3_SRGGB10	v4l2_fourcc('i', 'p', '3', 'r') /* IPU3 packed 10-bit RGGB bayer */
 
 /* SDR formats - used only for Software Defined Radio devices */
 #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */
-- 
2.7.4
