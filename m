Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52896 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725802AbeLDNpK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Dec 2018 08:45:10 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: bingbu.cao@intel.com
Subject: [PATCH 1/1] v4l uapi: Make "Vertical Colour Bars" menu item a little more generic
Date: Tue,  4 Dec 2018 15:45:06 +0200
Message-Id: <20181204134506.21529-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The test pattern could contain a different number of colour bars than
eight, make the entry more useful by removing "Eight " from the name.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/uapi/linux/v4l2-controls.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index acb2a57fa5d6..88f2759c2ce4 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -1016,7 +1016,7 @@ enum v4l2_jpeg_chroma_subsampling {
 #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
 #define V4L2_TEST_PATTERN_DISABLED		"Disabled"
 #define V4L2_TEST_PATTERN_SOLID_COLOUR		"Solid Colour"
-#define V4L2_TEST_PATTERN_VERT_COLOUR_BARS	"Eight Vertical Colour Bars"
+#define V4L2_TEST_PATTERN_VERT_COLOUR_BARS	"Vertical Colour Bars"
 #define V4L2_TEST_PATTERN_VERT_COLOUR_BARS_FADE_TO_GREY "Colour Bars With Fade to Grey"
 #define V4L2_TEST_PATTERN_PN9			"Pseudorandom Sequence (PN9)"
 #define V4L2_CID_DEINTERLACING_MODE		(V4L2_CID_IMAGE_PROC_CLASS_BASE + 4)
-- 
2.11.0
