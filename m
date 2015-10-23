Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23281 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbbJWJ75 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2015 05:59:57 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH 1/1] libv4l2subdev: Add support for interlacing in format
Date: Fri, 23 Oct 2015 12:59:25 +0300
Message-Id: <1445594365-13501-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use '=' to tell the interlacing type in format. This is optional to
maintain compatibility with existing users.

For instance, the following can be used to select interlaced SGRBG8 format
using size 1024x768:

	media-ctl -V 'entity:pad [fmt:SGRBG8=INTERLACED/1024x768]'

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi folks,

What's missing so far is printing the field in media-ctl test program.
Conversion functions could be added to libv4l2subdev API if needed, I'm
not sure they are.

 utils/media-ctl/libv4l2subdev.c | 44 +++++++++++++++++++++++++++++++++++++++--
 utils/media-ctl/options.c       |  5 ++++-
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 8015330..84551d0 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -307,7 +307,7 @@ static int v4l2_subdev_parse_format(struct media_device *media,
 				    const char *p, char **endp)
 {
 	enum v4l2_mbus_pixelcode code;
-	unsigned int width, height;
+	unsigned int width, height, field;
 	char *end;
 
 	/*
@@ -316,7 +316,7 @@ static int v4l2_subdev_parse_format(struct media_device *media,
 	 */
 	for (; isspace(*p); ++p);
 	for (end = (char *)p;
-	     *end != '/' && *end != ' ' && *end != '\0'; ++end);
+	     *end != '=' && *end != '/' && *end != ' ' && *end != '\0'; ++end);
 
 	code = v4l2_subdev_string_to_pixelcode(p, end - p);
 	if (code == (enum v4l2_mbus_pixelcode)-1) {
@@ -324,6 +324,45 @@ static int v4l2_subdev_parse_format(struct media_device *media,
 		return -EINVAL;
 	}
 
+	/* Parse interlacing */
+	if (*end == '=') {
+		static const struct {
+			unsigned int field;
+			char *str;
+		} __f[] = {
+			{ V4L2_FIELD_ANY, "ANY", },
+			{ V4L2_FIELD_NONE, "NONE", },
+			{ V4L2_FIELD_TOP, "TOP", },
+			{ V4L2_FIELD_BOTTOM, "BOTTOM", },
+			{ V4L2_FIELD_INTERLACED, "INTERLACED", },
+			{ V4L2_FIELD_SEQ_TB, "SEQ_TB", },
+			{ V4L2_FIELD_SEQ_BT, "SEQ_BT", },
+			{ V4L2_FIELD_ALTERNATE, "ALTERNATE", },
+			{ V4L2_FIELD_INTERLACED_TB, "INTERLACED_TB", },
+			{ V4L2_FIELD_INTERLACED_BT, "INTERLACED_BT", },
+			{ 0 },
+		}, *f = __f;
+
+
+		p = end + 1;
+		for (end = (char *)p;
+		     *end != '/' && *end != ' ' && *end != '\0'; ++end);
+
+		for (; f->str; f++) {
+			if (strlen(f->str) != end - p ||
+			    strncasecmp(f->str, p, end - p))
+				continue;
+			field = f->field;
+			break;
+		}
+
+		if (!f->str) {
+			media_dbg(media, "Invalid interlacing '%.*s'\n",
+				  end - p, p);
+			return -EINVAL;
+		}
+	}
+
 	p = end + 1;
 	width = strtoul(p, &end, 10);
 	if (*end != 'x') {
@@ -339,6 +378,7 @@ static int v4l2_subdev_parse_format(struct media_device *media,
 	format->width = width;
 	format->height = height;
 	format->code = code;
+	format->field = field;
 
 	return 0;
 }
diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
index ffaffcd..a241699 100644
--- a/utils/media-ctl/options.c
+++ b/utils/media-ctl/options.c
@@ -58,10 +58,13 @@ static void usage(const char *argv0)
 	printf("\tv4l2-properties = v4l2-property { ',' v4l2-property } ;\n");
 	printf("\tv4l2-property   = v4l2-mbusfmt | v4l2-crop | v4l2-interval\n");
 	printf("\t                | v4l2-compose | v4l2-interval ;\n");
-	printf("\tv4l2-mbusfmt    = 'fmt:' fcc '/' size ;\n");
+	printf("\tv4l2-mbusfmt    = 'fmt:' fcc { '=' v4l2-interlace } '/' size ;\n");
 	printf("\tv4l2-crop       = 'crop:' rectangle ;\n");
 	printf("\tv4l2-compose    = 'compose:' rectangle ;\n");
 	printf("\tv4l2-interval   = '@' numerator '/' denominator ;\n");
+	printf("\tv4l2-interlace  = 'ANY' | 'NONE' | 'TOP' | 'BOTTOM' | 'INTERLACED'\n");
+	printf("\t                | 'SEQ_TB' | 'SEQ_BT' | 'ALTERNATE'\n");
+	printf("\t                | 'INTERLACED_TB' | 'INTERLACED_BT'\n");
 	printf("\n");
 	printf("\trectangle       = '(' left ',' top, ')' '/' size ;\n");
 	printf("\tsize            = width 'x' height ;\n");
-- 
2.1.0.231.g7484e3b

