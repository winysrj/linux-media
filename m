Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61078 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932383AbbLHPMz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2015 10:12:55 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH RESEND 2/2] media-ctl: Add field support for the media bus format
Date: Tue,  8 Dec 2015 17:09:23 +0200
Message-Id: <1449587363-22731-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1449587363-22731-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1449587363-22731-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Use strncasecmp() instead of strncmp() when comparing field names and add
documentation on setting the field value. Wrap a few lines as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/libv4l2subdev.c | 64 +++++++++++++++++++++++++++++++++++++++++
 utils/media-ctl/media-ctl.c     |  3 ++
 utils/media-ctl/options.c       | 12 +++++++-
 utils/media-ctl/v4l2subdev.h    | 25 +++++++++++++++-
 4 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 16aa530..33c1ee6 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -473,6 +473,26 @@ static struct media_pad *v4l2_subdev_parse_pad_format(
 			continue;
 		}
 
+		if (strhazit("field:", &p)) {
+			enum v4l2_field field;
+
+			for (end = (char *)p; isalpha(*end) || *end == '-';
+			     ++end);
+
+			field = v4l2_subdev_string_to_field(p, end - p);
+			if (field == (enum v4l2_field)-1) {
+				media_dbg(media, "Invalid field value '%*s'\n",
+					  end - p, p);
+				*endp = (char *)p;
+				return NULL;
+			}
+
+			format->field = field;
+
+			p = end;
+			continue;
+		}
+
 		/*
 		 * Backward compatibility: crop rectangles can be specified
 		 * implicitly without the 'crop:' property name.
@@ -758,3 +778,47 @@ enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char *string,
 
 	return mbus_formats[i].code;
 }
+
+static struct {
+	const char *name;
+	enum v4l2_field field;
+} fields[] = {
+	{ "any", V4L2_FIELD_ANY },
+	{ "none", V4L2_FIELD_NONE },
+	{ "top", V4L2_FIELD_TOP },
+	{ "bottom", V4L2_FIELD_BOTTOM },
+	{ "interlaced", V4L2_FIELD_INTERLACED },
+	{ "seq-tb", V4L2_FIELD_SEQ_TB },
+	{ "seq-bt", V4L2_FIELD_SEQ_BT },
+	{ "alternate", V4L2_FIELD_ALTERNATE },
+	{ "interlaced-tb", V4L2_FIELD_INTERLACED_TB },
+	{ "interlaced-bt", V4L2_FIELD_INTERLACED_BT },
+};
+
+const char *v4l2_subdev_field_to_string(enum v4l2_field field)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(fields); ++i) {
+		if (fields[i].field == field)
+			return fields[i].name;
+	}
+
+	return "unknown";
+}
+
+enum v4l2_field v4l2_subdev_string_to_field(const char *string,
+					    unsigned int length)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(fields); ++i) {
+		if (strncasecmp(fields[i].name, string, length) == 0)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(fields))
+		return (enum v4l2_field)-1;
+
+	return fields[i].field;
+}
diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
index d3f6e04..3002fb7 100644
--- a/utils/media-ctl/media-ctl.c
+++ b/utils/media-ctl/media-ctl.c
@@ -90,6 +90,9 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
 	       v4l2_subdev_pixelcode_to_string(format.code),
 	       format.width, format.height);
 
+	if (format.field)
+		printf(" field:%s", v4l2_subdev_field_to_string(format.field));
+
 	ret = v4l2_subdev_get_selection(entity, &rect, pad,
 					V4L2_SEL_TGT_CROP_BOUNDS,
 					which);
diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
index 2751e6e..0afc9c2 100644
--- a/utils/media-ctl/options.c
+++ b/utils/media-ctl/options.c
@@ -24,7 +24,10 @@
 #include <stdlib.h>
 #include <unistd.h>
 
+#include <linux/videodev2.h>
+
 #include "options.h"
+#include "v4l2subdev.h"
 
 #define MEDIA_DEVNAME_DEFAULT		"/dev/media0"
 
@@ -34,6 +37,8 @@ struct media_options media_opts = {
 
 static void usage(const char *argv0)
 {
+	unsigned int i;
+
 	printf("%s [options]\n", argv0);
 	printf("-d, --device dev	Media device name (default: %s)\n", MEDIA_DEVNAME_DEFAULT);
 	printf("-e, --entity name	Print the device name associated with the given entity\n");
@@ -58,7 +63,7 @@ static void usage(const char *argv0)
 	printf("\tv4l2-properties = v4l2-property { ',' v4l2-property } ;\n");
 	printf("\tv4l2-property   = v4l2-mbusfmt | v4l2-crop | v4l2-interval\n");
 	printf("\t                | v4l2-compose | v4l2-interval ;\n");
-	printf("\tv4l2-mbusfmt    = 'fmt:' fcc '/' size ;\n");
+	printf("\tv4l2-mbusfmt    = 'fmt:' fcc '/' size ; { 'field:' v4l2-field ; }\n");
 	printf("\tv4l2-crop       = 'crop:' rectangle ;\n");
 	printf("\tv4l2-compose    = 'compose:' rectangle ;\n");
 	printf("\tv4l2-interval   = '@' numerator '/' denominator ;\n");
@@ -76,6 +81,11 @@ static void usage(const char *argv0)
 	printf("\theight          Image height in pixels\n");
 	printf("\tnumerator       Frame interval numerator\n");
 	printf("\tdenominator     Frame interval denominator\n");
+	printf("\tv4l2-field      One of the following:\n");
+
+	for (i = V4L2_FIELD_ANY; i <= V4L2_FIELD_INTERLACED_BT; i++)
+		printf("\t                %s\n",
+		       v4l2_subdev_field_to_string(i));
 }
 
 #define OPT_PRINT_DOT		256
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 4961308..104e420 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -248,7 +248,7 @@ const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code);
 /**
  * @brief Parse string to media bus pixel code.
  * @param string - input string
- * @param lenght - length of the string
+ * @param length - length of the string
  *
  * Parse human readable string @a string to an media bus pixel code.
  *
@@ -256,4 +256,27 @@ const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code);
  */
 enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char *string,
 							 unsigned int length);
+
+/**
+ * @brief Convert a field order to string.
+ * @param field - field order
+ *
+ * Convert field order @a field to a human-readable string.
+ *
+ * @return A pointer to a string on success, NULL on failure.
+ */
+const char *v4l2_subdev_field_to_string(enum v4l2_field field);
+
+/**
+ * @brief Parse string to field order.
+ * @param string - input string
+ * @param length - length of the string
+ *
+ * Parse human readable string @a string to field order.
+ *
+ * @return field order on success, -1 on failure.
+ */
+enum v4l2_field v4l2_subdev_string_to_field(const char *string,
+					    unsigned int length);
+
 #endif
-- 
2.1.0.231.g7484e3b

