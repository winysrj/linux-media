Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9033 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751308AbdLBEdA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 23:33:00 -0500
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        hyungwoo.yang@intel.com, chiranjeevi.rapolu@intel.com,
        jerry.w.hu@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v5 01/12] v4l: Add Intel IPU3 meta buffer formats
Date: Fri,  1 Dec 2017 22:32:11 -0600
Message-Id: <1512189142-19863-2-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1512189142-19863-1-git-send-email-yong.zhi@intel.com>
References: <1512189142-19863-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add IPU3-specific meta formats for parameter
processing and 3A, DVS statistics:

  V4L2_META_FMT_IPU3_PARAMS
  V4L2_META_FMT_IPU3_STAT_3A
  V4L2_META_FMT_IPU3_STAT_DVS

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 3 +++
 include/uapi/linux/videodev2.h       | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index aa4cbddbc064..425720dd9432 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1256,6 +1256,9 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_TCH_FMT_TU08:		descr = "8-bit unsigned touch data"; break;
 	case V4L2_META_FMT_VSP1_HGO:	descr = "R-Car VSP1 1-D Histogram"; break;
 	case V4L2_META_FMT_VSP1_HGT:	descr = "R-Car VSP1 2-D Histogram"; break;
+	case V4L2_META_FMT_IPU3_PARAMS:	descr = "IPU3 processing parameters"; break;
+	case V4L2_META_FMT_IPU3_STAT_3A:	descr = "IPU3 3A statistics"; break;
+	case V4L2_META_FMT_IPU3_STAT_DVS:	descr = "IPU3 DVS statistics"; break;
 
 	default:
 		/* Compressed formats */
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 76c14cf9436f..51f607b23e80 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -697,6 +697,11 @@ struct v4l2_pix_format {
 #define V4L2_META_FMT_VSP1_HGO    v4l2_fourcc('V', 'S', 'P', 'H') /* R-Car VSP1 1-D Histogram */
 #define V4L2_META_FMT_VSP1_HGT    v4l2_fourcc('V', 'S', 'P', 'T') /* R-Car VSP1 2-D Histogram */
 
+/* Vendor specific - used for IPU3 camera sub-system */
+#define V4L2_META_FMT_IPU3_PARAMS	v4l2_fourcc('i', 'p', '3', 'p') /* IPU3 params */
+#define V4L2_META_FMT_IPU3_STAT_3A	v4l2_fourcc('i', 'p', '3', 's') /* IPU3 3A statistics */
+#define V4L2_META_FMT_IPU3_STAT_DVS	v4l2_fourcc('i', 'p', '3', 'd') /* IPU3 DVS statistics */
+
 /* priv field value to indicates that subsequent fields are valid. */
 #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
 
-- 
2.7.4
