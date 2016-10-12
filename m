Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49979 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933254AbcJLOiT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:38:19 -0400
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OEX01FZBV7FY8A0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Oct 2016 23:35:45 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v4l-utils v7 5/7] mediactl: libv4l2subdev: Add colorspace
 logging
Date: Wed, 12 Oct 2016 16:35:20 +0200
Message-id: <1476282922-11544-6-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a function for obtaining colorspace name by id.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libv4l2subdev.c | 32 ++++++++++++++++++++++++++++++++
 utils/media-ctl/v4l2subdev.h    | 10 ++++++++++
 2 files changed, 42 insertions(+)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 4f8ee7f..31393bb 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -33,6 +33,7 @@
 #include <unistd.h>
 
 #include <linux/v4l2-subdev.h>
+#include <linux/videodev2.h>
 
 #include "mediactl.h"
 #include "mediactl-priv.h"
@@ -831,6 +832,37 @@ const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code)
 	return "unknown";
 }
 
+static struct {
+	const char *name;
+	enum v4l2_colorspace cs;
+} colorspaces[] = {
+        { "DEFAULT", V4L2_COLORSPACE_DEFAULT },
+        { "SMPTE170M", V4L2_COLORSPACE_SMPTE170M },
+        { "SMPTE240M", V4L2_COLORSPACE_SMPTE240M },
+        { "REC709", V4L2_COLORSPACE_REC709 },
+        { "BT878", V4L2_COLORSPACE_BT878 },
+        { "470_SYSTEM_M", V4L2_COLORSPACE_470_SYSTEM_M },
+        { "470_SYSTEM_BG", V4L2_COLORSPACE_470_SYSTEM_BG },
+        { "JPEG", V4L2_COLORSPACE_JPEG },
+        { "SRGB", V4L2_COLORSPACE_SRGB },
+        { "ADOBERGB", V4L2_COLORSPACE_ADOBERGB },
+        { "BT2020", V4L2_COLORSPACE_BT2020 },
+        { "RAW", V4L2_COLORSPACE_RAW },
+        { "DCI_P3", V4L2_COLORSPACE_DCI_P3 },
+};
+
+const char *v4l2_subdev_colorspace_to_string(enum v4l2_colorspace cs)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(colorspaces); ++i) {
+		if (colorspaces[i].cs == cs)
+			return colorspaces[i].name;
+	}
+
+	return "unknown";
+}
+
 enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char *string)
 {
 	unsigned int i;
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 4dee6b1..cf1250d 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -278,6 +278,16 @@ int v4l2_subdev_parse_setup_formats(struct media_device *media, const char *p);
 const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code);
 
 /**
+ * @brief Convert colorspace to string.
+ * @param code - input string
+ *
+ * Convert colorspace @a to a human-readable string.
+ *
+ * @return A pointer to a string on success, NULL on failure.
+ */
+const char *v4l2_subdev_colorspace_to_string(enum v4l2_colorspace cs);
+
+/**
  * @brief Parse string to media bus pixel code.
  * @param string - nul terminalted string, textual media bus pixel code
  *
-- 
1.9.1

