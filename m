Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47880 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759748AbdJRDsO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 23:48:14 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, jerry.w.hu@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v4 01/12] videodev2.h, v4l2-ioctl: add IPU3 meta buffer format
Date: Tue, 17 Oct 2017 22:48:01 -0500
Message-Id: <1508298481-25869-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the IPU3 specific processing parameter format
V4L2_META_FMT_IPU3_PARAMS and metadata formats
for 3A and other statistics:

  V4L2_META_FMT_IPU3_PARAMS
  V4L2_META_FMT_IPU3_STAT_3A
  V4L2_META_FMT_IPU3_STAT_DVS
  V4L2_META_FMT_IPU3_STAT_LACE

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++++
 include/uapi/linux/videodev2.h       | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index aa4cbddbc064..638e5d54f21e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1256,6 +1256,10 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_TCH_FMT_TU08:		descr = "8-bit unsigned touch data"; break;
 	case V4L2_META_FMT_VSP1_HGO:	descr = "R-Car VSP1 1-D Histogram"; break;
 	case V4L2_META_FMT_VSP1_HGT:	descr = "R-Car VSP1 2-D Histogram"; break;
+	case V4L2_META_FMT_IPU3_PARAMS:	descr = "IPU3 processing parameters"; break;
+	case V4L2_META_FMT_IPU3_STAT_3A:	descr = "IPU3 3A statistics"; break;
+	case V4L2_META_FMT_IPU3_STAT_DVS:	descr = "IPU3 DVS statistics"; break;
+	case V4L2_META_FMT_IPU3_STAT_LACE:	descr = "IPU3 LACE statistics"; break;
 
 	default:
 		/* Compressed formats */
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 3d694b179a16..036f8a44d3e8 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -696,6 +696,12 @@ struct v4l2_pix_format {
 #define V4L2_META_FMT_VSP1_HGO    v4l2_fourcc('V', 'S', 'P', 'H') /* R-Car VSP1 1-D Histogram */
 #define V4L2_META_FMT_VSP1_HGT    v4l2_fourcc('V', 'S', 'P', 'T') /* R-Car VSP1 2-D Histogram */
 
+/* Vendor specific - used for IPU3 camera sub-system */
+#define V4L2_META_FMT_IPU3_PARAMS	v4l2_fourcc('i', 'p', '3', 'p') /* IPU3 params */
+#define V4L2_META_FMT_IPU3_STAT_3A	v4l2_fourcc('i', 'p', '3', 's') /* IPU3 3A statistics */
+#define V4L2_META_FMT_IPU3_STAT_DVS	v4l2_fourcc('i', 'p', '3', 'd') /* IPU3 DVS statistics */
+#define V4L2_META_FMT_IPU3_STAT_LACE	v4l2_fourcc('i', 'p', '3', 'l') /* IPU3 LACE statistics */
+
 /* priv field value to indicates that subsequent fields are valid. */
 #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
 
-- 
2.7.4
