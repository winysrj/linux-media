Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AABC5CFFE
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 21:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 525A5204FD
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 21:20:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 525A5204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbeLJVUj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 16:20:39 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59436 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728123AbeLJVUi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 16:20:38 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 9679E634C85;
        Mon, 10 Dec 2018 23:20:32 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com
Subject: [v4l-utils PATCH 2/2] v4l2-compliance: Add support for metadata output
Date:   Mon, 10 Dec 2018 23:20:36 +0200
Message-Id: <20181210212036.16643-3-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181210212036.16643-1-sakari.ailus@linux.intel.com>
References: <20181210212036.16643-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Yong Zhi <yong.zhi@intel.com>

Add support for metadata output video nodes, in other words,
V4L2_CAP_META_OUTPUT and V4L2_BUF_TYPE_META_OUTPUT.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/common/v4l-helpers.h                  | 14 +++++++++++++-
 utils/common/v4l2-info.cpp                  |  4 ++++
 utils/v4l2-compliance/v4l2-compliance.cpp   |  7 ++++---
 utils/v4l2-compliance/v4l2-compliance.h     |  2 +-
 utils/v4l2-compliance/v4l2-test-formats.cpp |  7 +++++++
 5 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/utils/common/v4l-helpers.h b/utils/common/v4l-helpers.h
index fc4f91ed..a4739cb4 100644
--- a/utils/common/v4l-helpers.h
+++ b/utils/common/v4l-helpers.h
@@ -392,6 +392,11 @@ static inline bool v4l_has_meta_cap(const struct v4l_fd *f)
 	return v4l_g_caps(f) & V4L2_CAP_META_CAPTURE;
 }
 
+static inline bool v4l_has_meta_out(const struct v4l_fd *f)
+{
+	return v4l_g_caps(f) & V4L2_CAP_META_OUTPUT;
+}
+
 static inline bool v4l_has_touch(const struct v4l_fd *f)
 {
 	return v4l_g_caps(f) & V4L2_CAP_TOUCH;
@@ -440,6 +445,9 @@ static inline __u32 v4l_determine_type(const struct v4l_fd *f)
 		return V4L2_BUF_TYPE_SDR_OUTPUT;
 	if (v4l_has_meta_cap(f))
 		return V4L2_BUF_TYPE_META_CAPTURE;
+	if (v4l_has_meta_out(f))
+		return V4L2_BUF_TYPE_META_OUTPUT;
+
 	return 0;
 }
 
@@ -672,6 +680,7 @@ static inline void v4l_format_s_pixelformat(struct v4l2_format *fmt, __u32 pixel
 		fmt->fmt.vbi.sample_format = pixelformat;
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		fmt->fmt.meta.dataformat = pixelformat;
 		break;
 	}
@@ -693,6 +702,7 @@ static inline __u32 v4l_format_g_pixelformat(const struct v4l2_format *fmt)
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
 		return fmt->fmt.vbi.sample_format;
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		return fmt->fmt.meta.dataformat;
 	default:
 		return 0;
@@ -1031,6 +1041,7 @@ v4l_format_g_sizeimage(const struct v4l2_format *fmt, unsigned plane)
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
 		return plane ? 0 : fmt->fmt.sdr.buffersize;
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		return plane ? 0 : fmt->fmt.meta.buffersize;
 	default:
 		return 0;
@@ -1152,7 +1163,8 @@ static inline bool v4l_type_is_sdr(unsigned type)
 
 static inline bool v4l_type_is_meta(unsigned type)
 {
-       return type == V4L2_BUF_TYPE_META_CAPTURE;
+	return type == V4L2_BUF_TYPE_META_CAPTURE ||
+	       type == V4L2_BUF_TYPE_META_OUTPUT;
 }
 
 static inline unsigned v4l_type_invert(unsigned type)
diff --git a/utils/common/v4l2-info.cpp b/utils/common/v4l2-info.cpp
index c0a4ba40..c49e23cc 100644
--- a/utils/common/v4l2-info.cpp
+++ b/utils/common/v4l2-info.cpp
@@ -95,6 +95,8 @@ static std::string cap2s(unsigned cap)
 		s += "\t\tSDR Output\n";
 	if (cap & V4L2_CAP_META_CAPTURE)
 		s += "\t\tMetadata Capture\n";
+	if (cap & V4L2_CAP_META_OUTPUT)
+		s += "\t\tMetadata Output\n";
 	if (cap & V4L2_CAP_TUNER)
 		s += "\t\tTuner\n";
 	if (cap & V4L2_CAP_TOUCH)
@@ -188,6 +190,8 @@ std::string buftype2s(int type)
 		return "SDR Output";
 	case V4L2_BUF_TYPE_META_CAPTURE:
 		return "Metadata Capture";
+	case V4L2_BUF_TYPE_META_OUTPUT:
+		return "Metadata Output";
 	case V4L2_BUF_TYPE_PRIVATE:
 		return "Private";
 	default:
diff --git a/utils/v4l2-compliance/v4l2-compliance.cpp b/utils/v4l2-compliance/v4l2-compliance.cpp
index a53fcc50..80f02042 100644
--- a/utils/v4l2-compliance/v4l2-compliance.cpp
+++ b/utils/v4l2-compliance/v4l2-compliance.cpp
@@ -476,7 +476,7 @@ static int testCap(struct node *node)
 	const __u32 output_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OUTPUT_MPLANE |
 			V4L2_CAP_VIDEO_OUTPUT_OVERLAY | V4L2_CAP_VBI_OUTPUT |
 			V4L2_CAP_SDR_OUTPUT | V4L2_CAP_SLICED_VBI_OUTPUT |
-			V4L2_CAP_MODULATOR;
+			V4L2_CAP_MODULATOR | V4L2_CAP_META_OUTPUT;
 	const __u32 overlay_caps = V4L2_CAP_VIDEO_OVERLAY | V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
 	const __u32 m2m_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_VIDEO_M2M_MPLANE;
 	const __u32 io_caps = V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
@@ -702,12 +702,13 @@ void testNode(struct node &node, struct node &expbuf_node, media_type type,
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
index a12faeee..9b48e3d1 100644
--- a/utils/v4l2-compliance/v4l2-compliance.h
+++ b/utils/v4l2-compliance/v4l2-compliance.h
@@ -69,7 +69,7 @@ typedef std::map<__u32, unsigned> frmsizes_count_map;
 
 struct base_node;
 
-#define V4L2_BUF_TYPE_LAST V4L2_BUF_TYPE_META_CAPTURE
+#define V4L2_BUF_TYPE_LAST V4L2_BUF_TYPE_META_OUTPUT
 
 struct base_node {
 	bool is_video;
diff --git a/utils/v4l2-compliance/v4l2-test-formats.cpp b/utils/v4l2-compliance/v4l2-test-formats.cpp
index 006cc322..b68ba969 100644
--- a/utils/v4l2-compliance/v4l2-test-formats.cpp
+++ b/utils/v4l2-compliance/v4l2-test-formats.cpp
@@ -47,6 +47,7 @@ static const __u32 buftype2cap[] = {
 	V4L2_CAP_SDR_CAPTURE,
 	V4L2_CAP_SDR_OUTPUT,
 	V4L2_CAP_META_CAPTURE,
+	V4L2_CAP_META_OUTPUT,
 };
 
 static int testEnumFrameIntervals(struct node *node, __u32 pixfmt,
@@ -298,6 +299,7 @@ int testEnumFormats(struct node *node)
 		case V4L2_BUF_TYPE_SDR_CAPTURE:
 		case V4L2_BUF_TYPE_SDR_OUTPUT:
 		case V4L2_BUF_TYPE_META_CAPTURE:
+		case V4L2_BUF_TYPE_META_OUTPUT:
 			if (ret && (node->g_caps() & buftype2cap[type]))
 				return fail("%s cap set, but no %s formats defined\n",
 						buftype2s(type).c_str(), buftype2s(type).c_str());
@@ -545,6 +547,7 @@ static int testFormatsType(struct node *node, int ret,  unsigned type, struct v4
 		fail_on_test(check_0(sdr.reserved, sizeof(sdr.reserved)));
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		if (map.find(meta.dataformat) == map.end())
 			return fail("dataformat %08x (%s) for buftype %d not reported by ENUM_FMT\n",
 					meta.dataformat, fcc2s(meta.dataformat).c_str(), type);
@@ -584,6 +587,7 @@ int testGetFormats(struct node *node)
 		case V4L2_BUF_TYPE_SDR_CAPTURE:
 		case V4L2_BUF_TYPE_SDR_OUTPUT:
 		case V4L2_BUF_TYPE_META_CAPTURE:
+		case V4L2_BUF_TYPE_META_OUTPUT:
 			if (ret && (node->g_caps() & buftype2cap[type]))
 				return fail("%s cap set, but no %s formats defined\n",
 					buftype2s(type).c_str(), buftype2s(type).c_str());
@@ -640,6 +644,7 @@ static bool matchFormats(const struct v4l2_format &f1, const struct v4l2_format
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
 		return !memcmp(&f1.fmt.sdr, &f2.fmt.sdr, sizeof(f1.fmt.sdr));
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		return !memcmp(&f1.fmt.meta, &f2.fmt.meta, sizeof(f1.fmt.meta));
 
 	}
@@ -717,6 +722,7 @@ int testTryFormats(struct node *node)
 				pixelformat = fmt.fmt.sdr.pixelformat;
 				break;
 			case V4L2_BUF_TYPE_META_CAPTURE:
+			case V4L2_BUF_TYPE_META_OUTPUT:
 				pixelformat = fmt.fmt.meta.dataformat;
 				break;
 			case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
@@ -968,6 +974,7 @@ int testSetFormats(struct node *node)
 
 			switch (type) {
 			case V4L2_BUF_TYPE_META_CAPTURE:
+			case V4L2_BUF_TYPE_META_OUTPUT:
 				pixelformat = fmt_set.fmt.meta.dataformat;
 				break;
 			case V4L2_BUF_TYPE_SDR_CAPTURE:
-- 
2.11.0

