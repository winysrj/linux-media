Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:3542 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbcBUVcF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 16:32:05 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 3/4] libv4l2subdev: Add a function to list library supported pixel codes
Date: Sun, 21 Feb 2016 23:29:46 +0200
Message-Id: <1456090187-1191-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1456090187-1191-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1456090187-1191-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also mark which format definitions are compat definitions for the
pre-existing codes. This way we don't end up listing the same formats
twice.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/.gitignore      |  1 +
 utils/media-ctl/Makefile.am     |  6 +++-
 utils/media-ctl/libv4l2subdev.c | 72 ++++++++++++++++++++++++-----------------
 utils/media-ctl/v4l2subdev.h    | 11 +++++++
 4 files changed, 59 insertions(+), 31 deletions(-)

diff --git a/utils/media-ctl/.gitignore b/utils/media-ctl/.gitignore
index 799ab33..5354fec 100644
--- a/utils/media-ctl/.gitignore
+++ b/utils/media-ctl/.gitignore
@@ -1,2 +1,3 @@
 media-ctl
 media-bus-format-names.h
+media-bus-format-codes.h
diff --git a/utils/media-ctl/Makefile.am b/utils/media-ctl/Makefile.am
index 23ad90b..ee7dcc9 100644
--- a/utils/media-ctl/Makefile.am
+++ b/utils/media-ctl/Makefile.am
@@ -8,7 +8,11 @@ media-bus-format-names.h: ../../include/linux/media-bus-format.h
 	sed -e '/#define MEDIA_BUS_FMT/ ! d; s/.*FMT_//; /FIXED/ d; s/\t.*//; s/.*/{ \"&\", MEDIA_BUS_FMT_& },/;' \
 	< $< > $@
 
-BUILT_SOURCES = media-bus-format-names.h
+media-bus-format-codes.h: ../../include/linux/media-bus-format.h
+	sed -e '/#define MEDIA_BUS_FMT/ ! d; s/.*#define //; /FIXED/ d; s/\t.*//; s/.*/ &,/;' \
+	< $< > $@
+
+BUILT_SOURCES = media-bus-format-names.h media-bus-format-codes.h
 CLEANFILES = $(BUILT_SOURCES)
 
 nodist_libv4l2subdev_la_SOURCES = $(BUILT_SOURCES)
diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index f3c0a9a..20d95b4 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -718,38 +718,43 @@ int v4l2_subdev_parse_setup_formats(struct media_device *media, const char *p)
 static const struct {
 	const char *name;
 	enum v4l2_mbus_pixelcode code;
+	bool compat;
 } mbus_formats[] = {
 #include "media-bus-format-names.h"
-	{ "Y8", MEDIA_BUS_FMT_Y8_1X8},
-	{ "Y10", MEDIA_BUS_FMT_Y10_1X10 },
-	{ "Y12", MEDIA_BUS_FMT_Y12_1X12 },
-	{ "YUYV", MEDIA_BUS_FMT_YUYV8_1X16 },
-	{ "YUYV1_5X8", MEDIA_BUS_FMT_YUYV8_1_5X8 },
-	{ "YUYV2X8", MEDIA_BUS_FMT_YUYV8_2X8 },
-	{ "UYVY", MEDIA_BUS_FMT_UYVY8_1X16 },
-	{ "UYVY1_5X8", MEDIA_BUS_FMT_UYVY8_1_5X8 },
-	{ "UYVY2X8", MEDIA_BUS_FMT_UYVY8_2X8 },
-	{ "VUY24", MEDIA_BUS_FMT_VUY8_1X24 },
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
-	{ "RBG24", MEDIA_BUS_FMT_RBG888_1X24 },
-	{ "RGB32", MEDIA_BUS_FMT_RGB888_1X32_PADHI },
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
+	{ "VUY24", MEDIA_BUS_FMT_VUY8_1X24, true },
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
+	{ "RBG24", MEDIA_BUS_FMT_RBG888_1X24, true },
+	{ "RGB32", MEDIA_BUS_FMT_RGB888_1X32_PADHI, true },
+	{ "ARGB32", MEDIA_BUS_FMT_ARGB8888_1X32, true },
+};
+
+static const enum v4l2_mbus_pixelcode mbus_codes[] = {
+#include "media-bus-format-codes.h"
 };
 
 const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code)
@@ -821,3 +826,10 @@ enum v4l2_field v4l2_subdev_string_to_field(const char *string,
 
 	return fields[i].field;
 }
+
+const enum v4l2_mbus_pixelcode *v4l2_subdev_pixelcode_list(unsigned int *length)
+{
+	*length = ARRAY_SIZE(mbus_codes);
+
+	return mbus_codes;
+}
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 104e420..97f46a8 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -279,4 +279,15 @@ const char *v4l2_subdev_field_to_string(enum v4l2_field field);
 enum v4l2_field v4l2_subdev_string_to_field(const char *string,
 					    unsigned int length);
 
+/**
+ * @brief Enumerate library supported media bus pixel codes.
+ * @param length - the number of the supported pixel codes
+ *
+ * Obtain pixel codes supported by libv4l2subdev.
+ *
+ * @return A pointer to the pixel code array
+ */
+const enum v4l2_mbus_pixelcode *v4l2_subdev_pixelcode_list(
+	unsigned int *length);
+
 #endif
-- 
2.1.0.231.g7484e3b

