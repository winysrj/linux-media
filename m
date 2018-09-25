Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:51528 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbeIYQWA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 12:22:00 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, tfiga@chromium.org, bingbu.cao@intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        tian.shu.qiu@intel.com, ricardo.ribalda@gmail.com,
        grundler@chromium.org, ping-chung.chen@intel.com,
        andy.yeh@intel.com, jim.lai@intel.com, helmut.grohne@intenta.de,
        laurent.pinchart@ideasonboard.com, snawrocki@kernel.org
Subject: [PATCH 2/5] v4l: controls: Add support for exponential bases, prefixes and units
Date: Tue, 25 Sep 2018 13:14:31 +0300
Message-Id: <20180925101434.20327-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
References: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for exponential bases, prefixes as well as units for V4L2
controls. This makes it possible to convey information on the relation
between the control value and the hardware feature being controlled.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/uapi/linux/videodev2.h | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index ae083978988f1..23b02f2db85a1 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1652,6 +1652,32 @@ struct v4l2_queryctrl {
 	__u32		     reserved[2];
 };
 
+/* V4L2 control exponential bases */
+#define V4L2_CTRL_BASE_UNDEFINED	0
+#define V4L2_CTRL_BASE_LINEAR		1
+#define V4L2_CTRL_BASE_2		2
+#define V4L2_CTRL_BASE_10		10
+
+/* V4L2 control unit prefixes */
+#define V4L2_CTRL_PREFIX_NANO		-9
+#define V4L2_CTRL_PREFIX_MICRO		-6
+#define V4L2_CTRL_PREFIX_MILLI		-3
+#define V4L2_CTRL_PREFIX_1		0
+#define V4L2_CTRL_PREFIX_KILO		3
+#define V4L2_CTRL_PREFIX_MEGA		6
+#define V4L2_CTRL_PREFIX_GIGA		9
+
+/* V4L2 control units */
+#define V4L2_CTRL_UNIT_UNDEFINED	0
+#define V4L2_CTRL_UNIT_NONE		1
+#define V4L2_CTRL_UNIT_SECOND		2
+#define V4L2_CTRL_UNIT_AMPERE		3
+#define V4L2_CTRL_UNIT_LINE		4
+#define V4L2_CTRL_UNIT_PIXEL		5
+#define V4L2_CTRL_UNIT_PIXELS_PER_SEC	6
+#define V4L2_CTRL_UNIT_HZ		7
+
+
 /*  Used in the VIDIOC_QUERY_EXT_CTRL ioctl for querying extended controls */
 struct v4l2_query_ext_ctrl {
 	__u32		     id;
@@ -1666,7 +1692,10 @@ struct v4l2_query_ext_ctrl {
 	__u32                elems;
 	__u32                nr_of_dims;
 	__u32                dims[V4L2_CTRL_MAX_DIMS];
-	__u32		     reserved[32];
+	__u8		     base;
+	__s8		     prefix;
+	__u16		     unit;
+	__u32		     reserved[31];
 };
 
 /*  Used in the VIDIOC_QUERYMENU ioctl for querying menu items */
@@ -1692,6 +1721,7 @@ struct v4l2_querymenu {
 #define V4L2_CTRL_FLAG_HAS_PAYLOAD	0x00000100
 #define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE	0x00000200
 #define V4L2_CTRL_FLAG_MODIFY_LAYOUT	0x00000400
+#define V4L2_CTRL_FLAG_EXPONENTIAL	0x00000800
 
 /*  Query flags, to be ORed with the control ID */
 #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
-- 
2.11.0
