Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:47207 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab2EDIUl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 May 2012 04:20:41 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 3/3] Compose rectangle support for media-ctl
Date: Fri,  4 May 2012 11:24:43 +0300
Message-Id: <1336119883-14978-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1336119883-14978-1-git-send-email-sakari.ailus@iki.fi>
References: <1336119883-14978-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/main.c       |   14 ++++++++++++++
 src/options.c    |    6 ++++--
 src/v4l2subdev.c |   22 ++++++++++++++++++----
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/src/main.c b/src/main.c
index 6de1031..6362f3e 100644
--- a/src/main.c
+++ b/src/main.c
@@ -77,6 +77,20 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
 		printf("\n\t\t crop.actual:%u,%u/%ux%u", rect.left, rect.top,
 		       rect.width, rect.height);
 
+	ret = v4l2_subdev_get_selection(entity, &rect, pad,
+					V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS,
+					which);
+	if (ret == 0)
+		printf("\n\t\t compose.bounds:%u,%u/%ux%u",
+		       rect.left, rect.top, rect.width, rect.height);
+
+	ret = v4l2_subdev_get_selection(entity, &rect, pad,
+					V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL,
+					which);
+	if (ret == 0)
+		printf("\n\t\t compose.actual:%u,%u/%ux%u",
+		       rect.left, rect.top, rect.width, rect.height);
+
 	printf("]");
 }
 
diff --git a/src/options.c b/src/options.c
index 4d9d48f..c0b3d3b 100644
--- a/src/options.c
+++ b/src/options.c
@@ -55,13 +55,15 @@ static void usage(const char *argv0, int verbose)
 	printf("\tlink            = pad, '->', pad, '[', flags, ']' ;\n");
 	printf("\tformat          = pad, '[', formats ']' ;\n");
 	printf("\tformats         = formats ',' formats ;\n");
-	printf("\tformats         = fmt | crop | frame interval ;\n");
+	printf("\tformats         = fmt | crop | compose | frame interval ;\n");
 	printf("\fmt              = 'fmt:', fcc, '/', size ;\n");
 	printf("\tpad             = entity, ':', pad number ;\n");
 	printf("\tentity          = entity number | ( '\"', entity name, '\"' ) ;\n");
 	printf("\tsize            = width, 'x', height ;\n");
-	printf("\tcrop            = 'crop.actual:', left, ',', top, '/', size ;\n");
+	printf("\tcrop            = 'crop.actual:', window ;\n");
+	printf("\tcompose         = 'compose.actual:', window ;\n");
 	printf("\tframe interval  = '@', numerator, '/', denominator ;\n");
+	printf("\twindow          = left, ',', top, '/', size ;\n");
 	printf("where the fields are\n");
 	printf("\tentity number   Entity numeric identifier\n");
 	printf("\tentity name     Entity name (string) \n");
diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index 87b22fc..8e3a447 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -317,8 +317,8 @@ static int strhazit(const char *str, const char **p)
 
 static struct media_pad *v4l2_subdev_parse_pad_format(
 	struct media_device *media, struct v4l2_mbus_framefmt *format,
-	struct v4l2_rect *crop, struct v4l2_fract *interval, const char *p,
-	char **endp)
+	struct v4l2_rect *crop, struct v4l2_rect *compose,
+	struct v4l2_fract *interval, const char *p, char **endp)
 {
 	struct media_pad *pad;
 	char *end;
@@ -355,6 +355,15 @@ static struct media_pad *v4l2_subdev_parse_pad_format(
 			continue;
 		}
 
+		if (!strhazit("compose.actual:", &p)) {
+			ret = v4l2_subdev_parse_rectangle(compose, p, &end);
+			if (ret < 0)
+				return NULL;
+
+			for (p = end; isspace(*p); p++);
+			continue;
+		}
+
 		if (*p == '@') {
 			ret = v4l2_subdev_parse_frame_interval(interval, ++p, &end);
 			if (ret < 0)
@@ -468,13 +477,14 @@ static int v4l2_subdev_parse_setup_format(struct media_device *media,
 	struct v4l2_mbus_framefmt format = { 0, 0, 0 };
 	struct media_pad *pad;
 	struct v4l2_rect crop = { -1, -1, -1, -1 };
+	struct v4l2_rect compose = crop;
 	struct v4l2_fract interval = { 0, 0 };
 	unsigned int i;
 	char *end;
 	int ret;
 
-	pad = v4l2_subdev_parse_pad_format(media, &format, &crop, &interval,
-					   p, &end);
+	pad = v4l2_subdev_parse_pad_format(media, &format, &crop, &compose,
+					   &interval, p, &end);
 	if (pad == NULL) {
 		media_dbg(media, "Unable to parse format\n");
 		return -EINVAL;
@@ -490,6 +500,10 @@ static int v4l2_subdev_parse_setup_format(struct media_device *media,
 	if (ret < 0)
 		return ret;
 
+	ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL, &compose);
+	if (ret < 0)
+		return ret;
+
 	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
 		ret = set_format(pad, &format);
 		if (ret < 0)
-- 
1.7.2.5

