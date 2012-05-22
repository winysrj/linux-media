Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:35903 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab2EVWbK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 18:31:10 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH v3 1/4] New, more flexible syntax for format
Date: Wed, 23 May 2012 01:30:57 +0300
Message-Id: <1337725860-11048-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4FBC1396.9090109@iki.fi>
References: <4FBC1396.9090109@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

More flexible and extensible syntax for format which allows better usage
of the selection API.

Continue supporting the old syntax but remove the documentation for it. It
was not supported in an official release and its use is thus deprecated.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/main.c       |   17 +++++++--
 src/options.c    |   27 +++++++++-----
 src/v4l2subdev.c |   97 ++++++++++++++++++++++++++++++++++++------------------
 3 files changed, 95 insertions(+), 46 deletions(-)

diff --git a/src/main.c b/src/main.c
index 53964e4..5d88b46 100644
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
+		printf("\n\t\t crop.bounds:(%u,%u)/%ux%u", rect.left, rect.top,
+		       rect.width, rect.height);
 
 	ret = v4l2_subdev_get_selection(entity, &rect, pad,
 					V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL,
 					which);
 	if (ret == 0)
-		printf(" (%u,%u)/%ux%u", rect.left, rect.top,
+		printf("\n\t\t crop:(%u,%u)/%ux%u", rect.left, rect.top,
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
index 60cf6d5..46f6bef 100644
--- a/src/options.c
+++ b/src/options.c
@@ -37,8 +37,8 @@ static void usage(const char *argv0, int verbose)
 	printf("%s [options] device\n", argv0);
 	printf("-d, --device dev	Media device name (default: %s)\n", MEDIA_DEVNAME_DEFAULT);
 	printf("-e, --entity name	Print the device name associated with the given entity\n");
-	printf("-f, --set-format	Comma-separated list of formats to setup\n");
-	printf("    --get-format pad	Print the active format on a given pad\n");
+	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to setup\n");
+	printf("    --get-v4l2 pad	Print the active format on a given pad\n");
 	printf("-h, --help		Show verbose help and exit\n");
 	printf("-i, --interactive	Modify links interactively\n");
 	printf("-l, --links		Comma-separated list of links descriptors to setup\n");
@@ -52,13 +52,17 @@ static void usage(const char *argv0, int verbose)
 
 	printf("\n");
 	printf("Links and formats are defined as\n");
-	printf("\tlink            = pad, '->', pad, '[', flags, ']' ;\n");
-	printf("\tformat          = pad, '[', fcc, ' ', size, [ ' ', crop ], [ ' ', '@', frame interval ], ']' ;\n");
-	printf("\tpad             = entity, ':', pad number ;\n");
-	printf("\tentity          = entity number | ( '\"', entity name, '\"' ) ;\n");
-	printf("\tsize            = width, 'x', height ;\n");
-	printf("\tcrop            = '(', left, ',', top, ')', '/', size ;\n");
-	printf("\tframe interval  = numerator, '/', denominator ;\n");
+	printf("\tlink                = pad, '->', pad, '[', flags, ']' ;\n");
+	printf("\tv4l2                = pad, '[', v4l2-cfgs ']' ;\n");
+	printf("\tv4l2-cfgs           = v4l2-cfg [ ',' v4l2-cfg ] ;\n");
+	printf("\tv4l2-cfg            = v4l2-mbusfmt | v4l2-crop\n");
+	printf("\t                      | v4l2 frame interval ;\n");
+	printf("\tv4l2-mbusfmt        = 'fmt:', fcc, '/', size ;\n");
+	printf("\tpad                 = entity, ':', pad number ;\n");
+	printf("\tentity              = entity number | ( '\"', entity name, '\"' ) ;\n");
+	printf("\tsize                = width, 'x', height ;\n");
+	printf("\tv4l2-crop           = 'crop:(', left, ',', top, ')/', size ;\n");
+	printf("\tv4l2 frame interval = '@', numerator, '/', denominator ;\n");
 	printf("where the fields are\n");
 	printf("\tentity number   Entity numeric identifier\n");
 	printf("\tentity name     Entity name (string) \n");
@@ -77,7 +81,9 @@ static void usage(const char *argv0, int verbose)
 static struct option opts[] = {
 	{"device", 1, 0, 'd'},
 	{"entity", 1, 0, 'e'},
+	{"set-v4l2", 1, 0, 'V'},
 	{"set-format", 1, 0, 'f'},
+	{"get-v4l2", 1, 0, OPT_GET_FORMAT},
 	{"get-format", 1, 0, OPT_GET_FORMAT},
 	{"help", 0, 0, 'h'},
 	{"interactive", 0, 0, 'i'},
@@ -98,7 +104,7 @@ int parse_cmdline(int argc, char **argv)
 	}
 
 	/* parse options */
-	while ((opt = getopt_long(argc, argv, "d:e:f:hil:prv", opts, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, "d:e:V:f:hil:prv", opts, NULL)) != -1) {
 		switch (opt) {
 		case 'd':
 			media_opts.devname = optarg;
@@ -108,6 +114,7 @@ int parse_cmdline(int argc, char **argv)
 			media_opts.entity = optarg;
 			break;
 
+		case 'V':
 		case 'f':
 			media_opts.formats = optarg;
 			break;
diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index a2ab0c4..cf7c1ca 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -232,14 +232,19 @@ static int v4l2_subdev_parse_format(struct v4l2_mbus_framefmt *format,
 	unsigned int width, height;
 	char *end;
 
+	/*
+	 * Compatibility with the old syntax: consider space as valid
+	 * separator between the media bus pixel code and the size.
+	 */
 	for (; isspace(*p); ++p);
-	for (end = (char *)p; !isspace(*end) && *end != '\0'; ++end);
+	for (end = (char *)p;
+	     *end != '/' && *end != ' ' && *end != '\0'; ++end);
 
 	code = v4l2_subdev_string_to_pixelcode(p, end - p);
 	if (code == (enum v4l2_mbus_pixelcode)-1)
 		return -EINVAL;
 
-	for (p = end; isspace(*p); ++p);
+	p = end + 1;
 	width = strtoul(p, &end, 10);
 	if (*end != 'x')
 		return -EINVAL;
@@ -256,32 +261,32 @@ static int v4l2_subdev_parse_format(struct v4l2_mbus_framefmt *format,
 	return 0;
 }
 
-static int v4l2_subdev_parse_crop(
-	struct v4l2_rect *crop, const char *p, char **endp)
+static int v4l2_subdev_parse_rectangle(
+	struct v4l2_rect *r, const char *p, char **endp)
 {
 	char *end;
 
 	if (*p++ != '(')
 		return -EINVAL;
 
-	crop->left = strtoul(p, &end, 10);
+	r->left = strtoul(p, &end, 10);
 	if (*end != ',')
 		return -EINVAL;
 
 	p = end + 1;
-	crop->top = strtoul(p, &end, 10);
+	r->top = strtoul(p, &end, 10);
 	if (*end++ != ')')
 		return -EINVAL;
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
@@ -307,6 +312,17 @@ static int v4l2_subdev_parse_frame_interval(struct v4l2_fract *interval,
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
@@ -326,30 +342,47 @@ static struct media_pad *v4l2_subdev_parse_pad_format(
 	if (*p++ != '[')
 		return NULL;
 
-	for (; isspace(*p); ++p);
+	for (;;) {
+		for (; isspace(*p); p++);
 
-	if (isalnum(*p)) {
-		ret = v4l2_subdev_parse_format(format, p, &end);
-		if (ret < 0)
-			return NULL;
+		/*
+		 * Let users specify crop either explictly or
+		 * implicitly using the old syntax.
+		 */
+		if (!strhazit("crop:", &p) || *p == '(') {
+			ret = v4l2_subdev_parse_rectangle(crop, p, &end);
+			if (ret < 0)
+				return NULL;
 
-		for (p = end; isspace(*p); p++);
-	}
+			p = end;
+			continue;
+		}
 
-	if (*p == '(') {
-		ret = v4l2_subdev_parse_crop(crop, p, &end);
-		if (ret < 0)
-			return NULL;
+		/*
+		 * Continue providing compatibility interface for
+		 * users who use the old syntax: consider anything
+		 * beginning with capital letter media bus pixel code.
+		 */
+		if (!strhazit("fmt:", &p)
+		    || (*p >= 'A' && *p <= 'Z')) {
+			ret = v4l2_subdev_parse_format(format, p, &end);
+			if (ret < 0)
+				return NULL;
+
+			p = end;
+			continue;
+		}
 
-		for (p = end; isspace(*p); p++);
-	}
+		if (*p == '@') {
+			ret = v4l2_subdev_parse_frame_interval(interval, ++p, &end);
+			if (ret < 0)
+				return NULL;
 
-	if (*p == '@') {
-		ret = v4l2_subdev_parse_frame_interval(interval, ++p, &end);
-		if (ret < 0)
-			return NULL;
+			p = end;
+			continue;
+		}
 
-		for (p = end; isspace(*p); p++);
+		break;
 	}
 
 	if (*p != ']')
-- 
1.7.2.5

