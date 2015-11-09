Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57856 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbbKIN0p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Nov 2015 08:26:45 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 3/4] libv4l2subdev: Add a function to list library supported pixel codes
Date: Mon,  9 Nov 2015 15:25:24 +0200
Message-Id: <1447075525-32321-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1447075525-32321-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1447075525-32321-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also mark which format definitions are compat definitions for the
pre-existing codes. This way we don't end up listing the same formats
twice.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/libv4l2subdev.c | 63 +++++++++++++++++++++++------------------
 utils/media-ctl/v4l2subdev.h    | 11 +++++++
 2 files changed, 47 insertions(+), 27 deletions(-)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 607e943..7e0da46 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -718,35 +718,36 @@ int v4l2_subdev_parse_setup_formats(struct media_device *media, const char *p)
 static struct {
 	const char *name;
 	enum v4l2_mbus_pixelcode code;
+	bool compat;
 } mbus_formats[] = {
 #include "media-bus-formats.h"
-	{ "Y8", MEDIA_BUS_FMT_Y8_1X8},
-	{ "Y10", MEDIA_BUS_FMT_Y10_1X10 },
-	{ "Y12", MEDIA_BUS_FMT_Y12_1X12 },
-	{ "YUYV", MEDIA_BUS_FMT_YUYV8_1X16 },
-	{ "YUYV1_5X8", MEDIA_BUS_FMT_YUYV8_1_5X8 },
-	{ "YUYV2X8", MEDIA_BUS_FMT_YUYV8_2X8 },
-	{ "UYVY", MEDIA_BUS_FMT_UYVY8_1X16 },
-	{ "UYVY1_5X8", MEDIA_BUS_FMT_UYVY8_1_5X8 },
-	{ "UYVY2X8", MEDIA_BUS_FMT_UYVY8_2X8 },
-	{ "SBGGR8", MEDIA_BUS_FMT_SBGGR8_1X8 },
-	{ "SGBRG8", MEDIA_BUS_FMT_SGBRG8_1X8 },
-	{ "SGRBG8", MEDIA_BUS_FMT_SGRBG8_1X8 },
-	{ "SRGGB8", MEDIA_BUS_FMT_SRGGB8_1X8 },
-	{ "SBGGR10", MEDIA_BUS_FMT_SBGGR10_1X10 },
-	{ "SGBRG10", MEDIA_BUS_FMT_SGBRG10_1X10 },
-	{ "SGRBG10", MEDIA_BUS_FMT_SGRBG10_1X10 },
-	{ "SRGGB10", MEDIA_BUS_FMT_SRGGB10_1X10 },
-	{ "SBGGR10_DPCM8", MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8 },
-	{ "SGBRG10_DPCM8", MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8 },
-	{ "SGRBG10_DPCM8", MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8 },
-	{ "SRGGB10_DPCM8", MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8 },
-	{ "SBGGR12", MEDIA_BUS_FMT_SBGGR12_1X12 },
-	{ "SGBRG12", MEDIA_BUS_FMT_SGBRG12_1X12 },
-	{ "SGRBG12", MEDIA_BUS_FMT_SGRBG12_1X12 },
-	{ "SRGGB12", MEDIA_BUS_FMT_SRGGB12_1X12 },
-	{ "AYUV32", MEDIA_BUS_FMT_AYUV8_1X32 },
-	{ "ARGB32", MEDIA_BUS_FMT_ARGB8888_1X32 },
+	{ "Y8", MEDIA_BUS_FMT_Y8_1X8, true },
+	{ "Y10", MEDIA_BUS_FMT_Y10_1X10, true },
+	{ "Y12", MEDIA_BUS_FMT_Y12_1X12, true },
+	{ "YUYV", MEDIA_BUS_FMT_YUYV8_1X16, true },
+	{ "YUYV1_5X8", MEDIA_BUS_FMT_YUYV8_1_5X8, true },
+	{ "YUYV2X8", MEDIA_BUS_FMT_YUYV8_2X8, true },
+	{ "UYVY", MEDIA_BUS_FMT_UYVY8_1X16, true },
+	{ "UYVY1_5X8", MEDIA_BUS_FMT_UYVY8_1_5X8, true },
+	{ "UYVY2X8", MEDIA_BUS_FMT_UYVY8_2X8, true },
+	{ "SBGGR8", MEDIA_BUS_FMT_SBGGR8_1X8, true },
+	{ "SGBRG8", MEDIA_BUS_FMT_SGBRG8_1X8, true },
+	{ "SGRBG8", MEDIA_BUS_FMT_SGRBG8_1X8, true },
+	{ "SRGGB8", MEDIA_BUS_FMT_SRGGB8_1X8, true },
+	{ "SBGGR10", MEDIA_BUS_FMT_SBGGR10_1X10, true },
+	{ "SGBRG10", MEDIA_BUS_FMT_SGBRG10_1X10, true },
+	{ "SGRBG10", MEDIA_BUS_FMT_SGRBG10_1X10, true },
+	{ "SRGGB10", MEDIA_BUS_FMT_SRGGB10_1X10, true },
+	{ "SBGGR10_DPCM8", MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8, true },
+	{ "SGBRG10_DPCM8", MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8, true },
+	{ "SGRBG10_DPCM8", MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8, true },
+	{ "SRGGB10_DPCM8", MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8, true },
+	{ "SBGGR12", MEDIA_BUS_FMT_SBGGR12_1X12, true },
+	{ "SGBRG12", MEDIA_BUS_FMT_SGBRG12_1X12, true },
+	{ "SGRBG12", MEDIA_BUS_FMT_SGRBG12_1X12, true },
+	{ "SRGGB12", MEDIA_BUS_FMT_SRGGB12_1X12, true },
+	{ "AYUV32", MEDIA_BUS_FMT_AYUV8_1X32, true },
+	{ "ARGB32", MEDIA_BUS_FMT_ARGB8888_1X32, true },
 };
 
 const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code)
@@ -820,3 +821,11 @@ enum v4l2_field v4l2_subdev_string_to_field(const char *string,
 
 	return fields[i].field;
 }
+
+enum v4l2_mbus_pixelcode v4l2_subdev_pixelcode_list(unsigned int i)
+{
+	if (i >= ARRAY_SIZE(mbus_formats) || mbus_formats[i].compat)
+		return (enum v4l2_mbus_pixelcode)-1;
+
+	return mbus_formats[i].code;
+}
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 104e420..ef8ef95 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -279,4 +279,15 @@ const char *v4l2_subdev_field_to_string(enum v4l2_field field);
 enum v4l2_field v4l2_subdev_string_to_field(const char *string,
 					    unsigned int length);
 
+/**
+ * @brief Enumerate library supported media bus pixel codes.
+ * @param i - index starting from zero
+ *
+ * Enumerate pixel codes supported by libv4l2subdev starting from
+ * index 0.
+ *
+ * @return media bus pixelcode on success, -1 on failure.
+ */
+enum v4l2_mbus_pixelcode v4l2_subdev_pixelcode_list(unsigned int i);
+
 #endif
-- 
2.1.0.231.g7484e3b

