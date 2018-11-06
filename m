Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:53657 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389422AbeKGCm6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 21:42:58 -0500
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, hans.verkuil@cisco.com
Cc: sakari.ailus@linux.intel.com, rajmohan.mani@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH] [v4l-utils] libv4l2subdev: Add MEDIA_BUS_FMT_FIXED to mbus_formats[]
Date: Tue,  6 Nov 2018 09:12:56 -0800
Message-Id: <1541524376-27795-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also add V4L2_COLORSPACE_RAW to the colorspaces[].

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 utils/media-ctl/libv4l2subdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index a989efb..46668eb 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -855,6 +855,7 @@ static const struct {
 	enum v4l2_mbus_pixelcode code;
 } mbus_formats[] = {
 #include "media-bus-format-names.h"
+	{ "FIXED", MEDIA_BUS_FMT_FIXED},
 	{ "Y8", MEDIA_BUS_FMT_Y8_1X8},
 	{ "Y10", MEDIA_BUS_FMT_Y10_1X10 },
 	{ "Y12", MEDIA_BUS_FMT_Y12_1X12 },
@@ -965,7 +966,9 @@ static struct {
 	{ "srgb", V4L2_COLORSPACE_SRGB },
 	{ "oprgb", V4L2_COLORSPACE_OPRGB },
 	{ "bt2020", V4L2_COLORSPACE_BT2020 },
+	{ "raw", V4L2_COLORSPACE_RAW },
 	{ "dcip3", V4L2_COLORSPACE_DCI_P3 },
+
 };
 
 const char *v4l2_subdev_colorspace_to_string(enum v4l2_colorspace colorspace)
-- 
2.7.4
