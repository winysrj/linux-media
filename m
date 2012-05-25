Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:51039 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab2EYKIB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 06:08:01 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH v3.1 2/4] Compose rectangle support for libv4l2subdev
Date: Fri, 25 May 2012 13:12:05 +0300
Message-Id: <1337940725-17045-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1337725860-11048-2-git-send-email-sakari.ailus@iki.fi>
References: <1337725860-11048-2-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/main.c       |   14 ++++++++++++++
 src/options.c    |    6 ++++--
 src/v4l2subdev.c |   32 +++++++++++++++++++++++---------
 3 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/src/main.c b/src/main.c
index 5d88b46..0b94f2a 100644
--- a/src/main.c
+++ b/src/main.c
@@ -77,6 +77,20 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
 		printf("\n\t\t crop:(%u,%u)/%ux%u", rect.left, rect.top,
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
+		printf("\n\t\t compose:%u,%u/%ux%u",
+		       rect.left, rect.top, rect.width, rect.height);
+
 	printf("]");
 }
 
diff --git a/src/options.c b/src/options.c
index 46f6bef..8e80bd0 100644
--- a/src/options.c
+++ b/src/options.c
@@ -56,12 +56,14 @@ static void usage(const char *argv0, int verbose)
 	printf("\tv4l2                = pad, '[', v4l2-cfgs ']' ;\n");
 	printf("\tv4l2-cfgs           = v4l2-cfg [ ',' v4l2-cfg ] ;\n");
 	printf("\tv4l2-cfg            = v4l2-mbusfmt | v4l2-crop\n");
-	printf("\t                      | v4l2 frame interval ;\n");
+	printf("\t                      | v4l2-compose | v4l2 frame interval ;\n");
 	printf("\tv4l2-mbusfmt        = 'fmt:', fcc, '/', size ;\n");
 	printf("\tpad                 = entity, ':', pad number ;\n");
 	printf("\tentity              = entity number | ( '\"', entity name, '\"' ) ;\n");
 	printf("\tsize                = width, 'x', height ;\n");
-	printf("\tv4l2-crop           = 'crop:(', left, ',', top, ')/', size ;\n");
+	printf("\tv4l2-crop           = 'crop:', v4l2-rectangle ;\n");
+	printf("\tv4l2-compose        = 'compose:', v4l2-rectangle ;\n");
+	printf("\tv4l2-rectangle      = '(', left, ',', top, ')/', size ;\n");
 	printf("\tv4l2 frame interval = '@', numerator, '/', denominator ;\n");
 	printf("where the fields are\n");
 	printf("\tentity number   Entity numeric identifier\n");
diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index 2b4a923..a29614f 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -325,8 +325,8 @@ static int icanhasstr(const char *str, const char **p)
 
 static struct media_pad *v4l2_subdev_parse_pad_format(
 	struct media_device *media, struct v4l2_mbus_framefmt *format,
-	struct v4l2_rect *crop, struct v4l2_fract *interval, const char *p,
-	char **endp)
+	struct v4l2_rect *crop, struct v4l2_rect *compose,
+	struct v4l2_fract *interval, const char *p, char **endp)
 {
 	struct media_pad *pad;
 	char *end;
@@ -373,6 +373,15 @@ static struct media_pad *v4l2_subdev_parse_pad_format(
 			continue;
 		}
 
+		if (!icanhasstr("compose:", &p)) {
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
@@ -486,30 +495,35 @@ static int v4l2_subdev_parse_setup_format(struct media_device *media,
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
 	}
 
-	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
-		ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL, &crop);
+	if (pad->flags & MEDIA_PAD_FL_SINK) {
+		ret = set_format(pad, &format);
 		if (ret < 0)
 			return ret;
 	}
 
-	ret = set_format(pad, &format);
+	ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL, &crop);
 	if (ret < 0)
 		return ret;
 
-	if (pad->flags & MEDIA_PAD_FL_SINK) {
-		ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL, &crop);
+	ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL, &compose);
+	if (ret < 0)
+		return ret;
+
+	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
+		ret = set_format(pad, &format);
 		if (ret < 0)
 			return ret;
 	}
-- 
1.7.2.5

