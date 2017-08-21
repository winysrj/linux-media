Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41446 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdHUHzn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 03:55:43 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: tfiga@chromium.org, yong.zhi@intel.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH v3 2/2] v4l2-compliance: Add support for metadata output
Date: Mon, 21 Aug 2017 10:55:24 +0300
Message-Id: <20170821075524.21048-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20170821075524.21048-1-sakari.ailus@linux.intel.com>
References: <20170821075524.21048-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for metadata output video nodes, in other words,
V4L2_CAP_META_OUTPUT and V4L2_BUF_TYPE_META_OUTPUT.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/v4l2-compliance/v4l2-compliance.cpp   | 11 ++++++++---
 utils/v4l2-compliance/v4l2-compliance.h     |  2 +-
 utils/v4l2-compliance/v4l2-test-formats.cpp |  8 +++++++-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/utils/v4l2-compliance/v4l2-compliance.cpp b/utils/v4l2-compliance/v4l2-compliance.cpp
index c40e3bd78..539c8c34b 100644
--- a/utils/v4l2-compliance/v4l2-compliance.cpp
+++ b/utils/v4l2-compliance/v4l2-compliance.cpp
@@ -216,6 +216,8 @@ std::string cap2s(unsigned cap)
 		s += "\t\tSDR Output\n";
 	if (cap & V4L2_CAP_META_CAPTURE)
 		s += "\t\tMetadata Capture\n";
+	if (cap & V4L2_CAP_META_OUTPUT)
+		s += "\t\tMetadata Output\n";
 	if (cap & V4L2_CAP_TOUCH)
 		s += "\t\tTouch Device\n";
 	if (cap & V4L2_CAP_TUNER)
@@ -283,6 +285,8 @@ std::string buftype2s(int type)
 		return "SDR Output";
 	case V4L2_BUF_TYPE_META_CAPTURE:
 		return "Metadata Capture";
+	case V4L2_BUF_TYPE_META_OUTPUT:
+		return "Metadata Output";
 	case V4L2_BUF_TYPE_PRIVATE:
 		return "Private";
 	default:
@@ -525,7 +529,7 @@ static int testCap(struct node *node)
 	const __u32 output_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OUTPUT_MPLANE |
 			V4L2_CAP_VIDEO_OUTPUT_OVERLAY | V4L2_CAP_VBI_OUTPUT |
 			V4L2_CAP_SDR_OUTPUT | V4L2_CAP_SLICED_VBI_OUTPUT |
-			V4L2_CAP_MODULATOR;
+			V4L2_CAP_MODULATOR | V4L2_CAP_META_OUTPUT;
 	const __u32 overlay_caps = V4L2_CAP_VIDEO_OVERLAY | V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
 	const __u32 m2m_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_VIDEO_M2M_MPLANE;
 	const __u32 io_caps = V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
@@ -1005,12 +1009,13 @@ int main(int argc, char **argv)
 	if (node.g_caps() & (V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VBI_OUTPUT |
 			 V4L2_CAP_VIDEO_OUTPUT_MPLANE | V4L2_CAP_VIDEO_M2M_MPLANE |
 			 V4L2_CAP_VIDEO_M2M | V4L2_CAP_SLICED_VBI_OUTPUT |
-			 V4L2_CAP_RDS_OUTPUT | V4L2_CAP_SDR_OUTPUT))
+			 V4L2_CAP_RDS_OUTPUT | V4L2_CAP_SDR_OUTPUT |
+			 V4L2_CAP_META_OUTPUT))
 		node.can_output = true;
 	if (node.g_caps() & (V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE |
 			 V4L2_CAP_VIDEO_M2M_MPLANE))
 		node.is_planar = true;
-	if (node.g_caps() & V4L2_CAP_META_CAPTURE) {
+	if (node.g_caps() & (V4L2_CAP_META_CAPTURE | V4L2_CAP_META_OUTPUT)) {
 		node.is_video = false;
 		node.is_meta = true;
 	}
diff --git a/utils/v4l2-compliance/v4l2-compliance.h b/utils/v4l2-compliance/v4l2-compliance.h
index 53ea5d5e6..e00128b57 100644
--- a/utils/v4l2-compliance/v4l2-compliance.h
+++ b/utils/v4l2-compliance/v4l2-compliance.h
@@ -61,7 +61,7 @@ typedef std::map<__u32, unsigned> frmsizes_count_map;
 
 struct base_node;
 
-#define V4L2_BUF_TYPE_LAST V4L2_BUF_TYPE_META_CAPTURE
+#define V4L2_BUF_TYPE_LAST V4L2_BUF_TYPE_META_OUTPUT
 
 struct base_node {
 	bool is_video;
diff --git a/utils/v4l2-compliance/v4l2-test-formats.cpp b/utils/v4l2-compliance/v4l2-test-formats.cpp
index b7a32fe38..9da7436e8 100644
--- a/utils/v4l2-compliance/v4l2-test-formats.cpp
+++ b/utils/v4l2-compliance/v4l2-test-formats.cpp
@@ -46,7 +46,7 @@ static const __u32 buftype2cap[] = {
 	V4L2_CAP_VIDEO_OUTPUT_MPLANE | V4L2_CAP_VIDEO_M2M_MPLANE,
 	V4L2_CAP_SDR_CAPTURE,
 	V4L2_CAP_SDR_OUTPUT,
-	V4L2_CAP_META_CAPTURE,
+	V4L2_CAP_META_CAPTURE | V4L2_CAP_META_OUTPUT,
 };
 
 static int testEnumFrameIntervals(struct node *node, __u32 pixfmt,
@@ -298,6 +298,7 @@ int testEnumFormats(struct node *node)
 		case V4L2_BUF_TYPE_SDR_CAPTURE:
 		case V4L2_BUF_TYPE_SDR_OUTPUT:
 		case V4L2_BUF_TYPE_META_CAPTURE:
+		case V4L2_BUF_TYPE_META_OUTPUT:
 			if (ret && (node->g_caps() & buftype2cap[type]))
 				return fail("%s cap set, but no %s formats defined\n",
 						buftype2s(type).c_str(), buftype2s(type).c_str());
@@ -546,6 +547,7 @@ static int testFormatsType(struct node *node, int ret,  unsigned type, struct v4
 		fail_on_test(check_0(sdr.reserved, sizeof(sdr.reserved)));
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		if (map.find(meta.dataformat) == map.end())
 			return fail("dataformat %08x (%s) for buftype %d not reported by ENUM_FMT\n",
 					meta.dataformat, fcc2s(meta.dataformat).c_str(), type);
@@ -585,6 +587,7 @@ int testGetFormats(struct node *node)
 		case V4L2_BUF_TYPE_SDR_CAPTURE:
 		case V4L2_BUF_TYPE_SDR_OUTPUT:
 		case V4L2_BUF_TYPE_META_CAPTURE:
+		case V4L2_BUF_TYPE_META_OUTPUT:
 			if (ret && (node->g_caps() & buftype2cap[type]))
 				return fail("%s cap set, but no %s formats defined\n",
 					buftype2s(type).c_str(), buftype2s(type).c_str());
@@ -641,6 +644,7 @@ static bool matchFormats(const struct v4l2_format &f1, const struct v4l2_format
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
 		return !memcmp(&f1.fmt.sdr, &f2.fmt.sdr, sizeof(f1.fmt.sdr));
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		return !memcmp(&f1.fmt.meta, &f2.fmt.meta, sizeof(f1.fmt.meta));
 
 	}
@@ -718,6 +722,7 @@ int testTryFormats(struct node *node)
 				pixelformat = fmt.fmt.sdr.pixelformat;
 				break;
 			case V4L2_BUF_TYPE_META_CAPTURE:
+			case V4L2_BUF_TYPE_META_OUTPUT:
 				pixelformat = fmt.fmt.meta.dataformat;
 				break;
 			case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
@@ -970,6 +975,7 @@ int testSetFormats(struct node *node)
 
 			switch (type) {
 			case V4L2_BUF_TYPE_META_CAPTURE:
+			case V4L2_BUF_TYPE_META_OUTPUT:
 				pixelformat = fmt_set.fmt.meta.dataformat;
 				break;
 			case V4L2_BUF_TYPE_SDR_CAPTURE:
-- 
2.11.0
