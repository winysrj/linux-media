Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:35164 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab2EDIUm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 May 2012 04:20:42 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 2/3] New, more flexible syntax for media-ctl
Date: Fri,  4 May 2012 11:24:42 +0300
Message-Id: <1336119883-14978-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1336119883-14978-1-git-send-email-sakari.ailus@iki.fi>
References: <1336119883-14978-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

More flexible and extensible syntax for media-ctl which allows better usage
of the selection API.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/main.c       |   17 +++++++++---
 src/options.c    |    9 ++++--
 src/v4l2subdev.c |   73 +++++++++++++++++++++++++++++++----------------------
 3 files changed, 62 insertions(+), 37 deletions(-)

diff --git a/src/main.c b/src/main.c
index 53964e4..6de1031 100644
--- a/src/main.c
+++ b/src/main.c
@@ -59,15 +59,24 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
 	if (ret != 0)
 		return;
 
-	printf("[%s %ux%u", v4l2_subdev_pixelcode_to_string(format.code),
-	       format.width, format.height);
+	printf("\t\t[fmt:%s/%ux%u",
+	       v4l2_subdev_pixelcode_to_string(format.code),
+ 	       format.width, format.height);
+
+	ret = v4l2_subdev_get_selection(entity, &rect, pad,
+					V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS,
+					which);
+	if (ret == 0)
+		printf("\n\t\t crop.bounds:%u,%u/%ux%u", rect.left, rect.top,
+		       rect.width, rect.height);
 
 	ret = v4l2_subdev_get_selection(entity, &rect, pad,
 					V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL,
 					which);
 	if (ret == 0)
-		printf(" (%u,%u)/%ux%u", rect.left, rect.top,
+		printf("\n\t\t crop.actual:%u,%u/%ux%u", rect.left, rect.top,
 		       rect.width, rect.height);
+
 	printf("]");
 }
 
@@ -252,7 +261,7 @@ static void media_print_topology_text(struct media_device *media)
 		for (j = 0; j < entity->info.pads; j++) {
 			struct media_pad *pad = &entity->pads[j];
 
-			printf("\tpad%u: %s ", j, media_pad_type_to_string(pad->flags));
+			printf("\tpad%u: %s\n", j, media_pad_type_to_string(pad->flags));
 
 			if (media_entity_type(entity) == MEDIA_ENT_T_V4L2_SUBDEV)
 				v4l2_subdev_print_format(entity, j, V4L2_SUBDEV_FORMAT_ACTIVE);
diff --git a/src/options.c b/src/options.c
index 60cf6d5..4d9d48f 100644
--- a/src/options.c
+++ b/src/options.c
@@ -53,12 +53,15 @@ static void usage(const char *argv0, int verbose)
 	printf("\n");
 	printf("Links and formats are defined as\n");
 	printf("\tlink            = pad, '->', pad, '[', flags, ']' ;\n");
-	printf("\tformat          = pad, '[', fcc, ' ', size, [ ' ', crop ], [ ' ', '@', frame interval ], ']' ;\n");
+	printf("\tformat          = pad, '[', formats ']' ;\n");
+	printf("\tformats         = formats ',' formats ;\n");
+	printf("\tformats         = fmt | crop | frame interval ;\n");
+	printf("\fmt              = 'fmt:', fcc, '/', size ;\n");
 	printf("\tpad             = entity, ':', pad number ;\n");
 	printf("\tentity          = entity number | ( '\"', entity name, '\"' ) ;\n");
 	printf("\tsize            = width, 'x', height ;\n");
-	printf("\tcrop            = '(', left, ',', top, ')', '/', size ;\n");
-	printf("\tframe interval  = numerator, '/', denominator ;\n");
+	printf("\tcrop            = 'crop.actual:', left, ',', top, '/', size ;\n");
+	printf("\tframe interval  = '@', numerator, '/', denominator ;\n");
 	printf("where the fields are\n");
 	printf("\tentity number   Entity numeric identifier\n");
 	printf("\tentity name     Entity name (string) \n");
diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index 92360bb..87b22fc 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -235,13 +235,13 @@ static int v4l2_subdev_parse_format(struct v4l2_mbus_framefmt *format,
 	char *end;
 
 	for (; isspace(*p); ++p);
-	for (end = (char *)p; !isspace(*end) && *end != '\0'; ++end);
+	for (end = (char *)p; *end != '/' && *end != '\0'; ++end);
 
 	code = v4l2_subdev_string_to_pixelcode(p, end - p);
 	if (code == (enum v4l2_mbus_pixelcode)-1)
 		return -EINVAL;
 
-	for (p = end; isspace(*p); ++p);
+	p = end + 1;
 	width = strtoul(p, &end, 10);
 	if (*end != 'x')
 		return -EINVAL;
@@ -258,32 +258,27 @@ static int v4l2_subdev_parse_format(struct v4l2_mbus_framefmt *format,
 	return 0;
 }
 
-static int v4l2_subdev_parse_crop(
-	struct v4l2_rect *crop, const char *p, char **endp)
+static int v4l2_subdev_parse_rectangle(
+	struct v4l2_rect *r, const char *p, char **endp)
 {
 	char *end;
 
-	if (*p++ != '(')
-		return -EINVAL;
-
-	crop->left = strtoul(p, &end, 10);
+	r->left = strtoul(p, &end, 10);
 	if (*end != ',')
 		return -EINVAL;
 
 	p = end + 1;
-	crop->top = strtoul(p, &end, 10);
-	if (*end++ != ')')
-		return -EINVAL;
+	r->top = strtoul(p, &end, 10);
 	if (*end != '/')
 		return -EINVAL;
 
 	p = end + 1;
-	crop->width = strtoul(p, &end, 10);
+	r->width = strtoul(p, &end, 10);
 	if (*end != 'x')
 		return -EINVAL;
 
 	p = end + 1;
-	crop->height = strtoul(p, &end, 10);
+	r->height = strtoul(p, &end, 10);
 	*endp = end;
 
 	return 0;
@@ -309,6 +304,17 @@ static int v4l2_subdev_parse_frame_interval(struct v4l2_fract *interval,
 	return 0;
 }
 
+static int strhazit(const char *str, const char **p)
+{
+	int len = strlen(str);
+
+	if (strncmp(str, *p, len))
+		return -ENOENT;
+
+	*p += len;
+	return 0;
+}
+
 static struct media_pad *v4l2_subdev_parse_pad_format(
 	struct media_device *media, struct v4l2_mbus_framefmt *format,
 	struct v4l2_rect *crop, struct v4l2_fract *interval, const char *p,
@@ -330,28 +336,35 @@ static struct media_pad *v4l2_subdev_parse_pad_format(
 
 	for (; isspace(*p); ++p);
 
-	if (isalnum(*p)) {
-		ret = v4l2_subdev_parse_format(format, p, &end);
-		if (ret < 0)
-			return NULL;
+	for (;;) {
+		if (!strhazit("fmt:", &p)) {
+			ret = v4l2_subdev_parse_format(format, p, &end);
+			if (ret < 0)
+				return NULL;
 
-		for (p = end; isspace(*p); p++);
-	}
+			for (p = end; isspace(*p); p++);
+			continue;
+		}
 
-	if (*p == '(') {
-		ret = v4l2_subdev_parse_crop(crop, p, &end);
-		if (ret < 0)
-			return NULL;
+		if (!strhazit("crop.actual:", &p)) {
+			ret = v4l2_subdev_parse_rectangle(crop, p, &end);
+			if (ret < 0)
+				return NULL;
 
-		for (p = end; isspace(*p); p++);
-	}
+			for (p = end; isspace(*p); p++);
+			continue;
+		}
 
-	if (*p == '@') {
-		ret = v4l2_subdev_parse_frame_interval(interval, ++p, &end);
-		if (ret < 0)
-			return NULL;
+		if (*p == '@') {
+			ret = v4l2_subdev_parse_frame_interval(interval, ++p, &end);
+			if (ret < 0)
+				return NULL;
+
+			for (p = end; isspace(*p); p++);
+			continue;
+		}
 
-		for (p = end; isspace(*p); p++);
+		break;
 	}
 
 	if (*p != ']')
-- 
1.7.2.5

