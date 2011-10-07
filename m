Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:34395 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab1JGPfM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Oct 2011 11:35:12 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 3/7] Move V4L2 subdev format parsing from main.c to subdev.c
Date: Fri,  7 Oct 2011 18:38:04 +0300
Message-Id: <1318001888-18689-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111007153443.GC8908@valkosipuli.localdomain>
References: <20111007153443.GC8908@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes format parsing a part of the libv4l2subdev and thus available on
all who use the library.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/main.c       |  340 +-----------------------------------------------------
 src/v4l2subdev.c |  343 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/v4l2subdev.h |   37 ++++++
 3 files changed, 382 insertions(+), 338 deletions(-)

diff --git a/src/main.c b/src/main.c
index 02cdecd..0d68ff6 100644
--- a/src/main.c
+++ b/src/main.c
@@ -45,61 +45,6 @@
  * Printing
  */
 
-static struct {
-	const char *name;
-	enum v4l2_mbus_pixelcode code;
-} mbus_formats[] = {
-	{ "Y8", V4L2_MBUS_FMT_Y8_1X8},
-	{ "Y10", V4L2_MBUS_FMT_Y10_1X10 },
-	{ "Y12", V4L2_MBUS_FMT_Y12_1X12 },
-	{ "YUYV", V4L2_MBUS_FMT_YUYV8_1X16 },
-	{ "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
-	{ "SBGGR8", V4L2_MBUS_FMT_SBGGR8_1X8 },
-	{ "SGBRG8", V4L2_MBUS_FMT_SGBRG8_1X8 },
-	{ "SGRBG8", V4L2_MBUS_FMT_SGRBG8_1X8 },
-	{ "SRGGB8", V4L2_MBUS_FMT_SRGGB8_1X8 },
-	{ "SBGGR10", V4L2_MBUS_FMT_SBGGR10_1X10 },
-	{ "SGBRG10", V4L2_MBUS_FMT_SGBRG10_1X10 },
-	{ "SGRBG10", V4L2_MBUS_FMT_SGRBG10_1X10 },
-	{ "SRGGB10", V4L2_MBUS_FMT_SRGGB10_1X10 },
-	{ "SBGGR10_DPCM8", V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 },
-	{ "SGBRG10_DPCM8", V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8 },
-	{ "SGRBG10_DPCM8", V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 },
-	{ "SRGGB10_DPCM8", V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8 },
-	{ "SBGGR12", V4L2_MBUS_FMT_SBGGR12_1X12 },
-	{ "SGBRG12", V4L2_MBUS_FMT_SGBRG12_1X12 },
-	{ "SGRBG12", V4L2_MBUS_FMT_SGRBG12_1X12 },
-	{ "SRGGB12", V4L2_MBUS_FMT_SRGGB12_1X12 },
-};
-
-static const char *pixelcode_to_string(enum v4l2_mbus_pixelcode code)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(mbus_formats); ++i) {
-		if (mbus_formats[i].code == code)
-			return mbus_formats[i].name;
-	}
-
-	return "unknown";
-}
-
-static enum v4l2_mbus_pixelcode string_to_pixelcode(const char *string,
-					     unsigned int length)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(mbus_formats); ++i) {
-		if (strncmp(mbus_formats[i].name, string, length) == 0)
-			break;
-	}
-
-	if (i == ARRAY_SIZE(mbus_formats))
-		return (enum v4l2_mbus_pixelcode)-1;
-
-	return mbus_formats[i].code;
-}
-
 static void v4l2_subdev_print_format(struct media_entity *entity,
 	unsigned int pad, enum v4l2_subdev_format_whence which)
 {
@@ -111,7 +56,7 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
 	if (ret != 0)
 		return;
 
-	printf("[%s %ux%u", pixelcode_to_string(format.code),
+	printf("[%s %ux%u", v4l2_subdev_pixelcode_to_string(format.code),
 	       format.width, format.height);
 
 	ret = v4l2_subdev_get_crop(entity, &rect, pad, which);
@@ -334,287 +279,6 @@ void media_print_topology(struct media_device *media, int dot)
 		media_print_topology_text(media);
 }
 
-/* -----------------------------------------------------------------------------
- * Formats setup
- */
-
-static int parse_format(struct v4l2_mbus_framefmt *format, const char *p, char **endp)
-{
-	enum v4l2_mbus_pixelcode code;
-	unsigned int width, height;
-	char *end;
-
-	for (; isspace(*p); ++p);
-	for (end = (char *)p; !isspace(*end) && *end != '\0'; ++end);
-
-	code = string_to_pixelcode(p, end - p);
-	if (code == (enum v4l2_mbus_pixelcode)-1)
-		return -EINVAL;
-
-	for (p = end; isspace(*p); ++p);
-	width = strtoul(p, &end, 10);
-	if (*end != 'x')
-		return -EINVAL;
-
-	p = end + 1;
-	height = strtoul(p, &end, 10);
-	*endp = end;
-
-	memset(format, 0, sizeof(*format));
-	format->width = width;
-	format->height = height;
-	format->code = code;
-
-	return 0;
-}
-
-static int parse_crop(struct v4l2_rect *crop, const char *p, char **endp)
-{
-	char *end;
-
-	if (*p++ != '(')
-		return -EINVAL;
-
-	crop->left = strtoul(p, &end, 10);
-	if (*end != ',')
-		return -EINVAL;
-
-	p = end + 1;
-	crop->top = strtoul(p, &end, 10);
-	if (*end++ != ')')
-		return -EINVAL;
-	if (*end != '/')
-		return -EINVAL;
-
-	p = end + 1;
-	crop->width = strtoul(p, &end, 10);
-	if (*end != 'x')
-		return -EINVAL;
-
-	p = end + 1;
-	crop->height = strtoul(p, &end, 10);
-	*endp = end;
-
-	return 0;
-}
-
-static int parse_frame_interval(struct v4l2_fract *interval, const char *p, char **endp)
-{
-	char *end;
-
-	for (; isspace(*p); ++p);
-
-	interval->numerator = strtoul(p, &end, 10);
-
-	for (p = end; isspace(*p); ++p);
-	if (*p++ != '/')
-		return -EINVAL;
-
-	for (; isspace(*p); ++p);
-	interval->denominator = strtoul(p, &end, 10);
-
-	*endp = end;
-	return 0;
-}
-
-static struct media_pad *parse_pad_format(struct media_device *media,
-	struct v4l2_mbus_framefmt *format, struct v4l2_rect *crop,
-	struct v4l2_fract *interval, const char *p, char **endp)
-{
-	struct media_pad *pad;
-	char *end;
-	int ret;
-
-	for (; isspace(*p); ++p);
-
-	pad = media_parse_pad(media, p, &end);
-	if (pad == NULL)
-		return NULL;
-
-	for (p = end; isspace(*p); ++p);
-	if (*p++ != '[')
-		return NULL;
-
-	for (; isspace(*p); ++p);
-
-	if (isalnum(*p)) {
-		ret = parse_format(format, p, &end);
-		if (ret < 0)
-			return NULL;
-
-		for (p = end; isspace(*p); p++);
-	}
-
-	if (*p == '(') {
-		ret = parse_crop(crop, p, &end);
-		if (ret < 0)
-			return NULL;
-
-		for (p = end; isspace(*p); p++);
-	}
-
-	if (*p == '@') {
-		ret = parse_frame_interval(interval, ++p, &end);
-		if (ret < 0)
-			return NULL;
-
-		for (p = end; isspace(*p); p++);
-	}
-
-	if (*p != ']')
-		return NULL;
-
-	*endp = (char *)p + 1;
-	return pad;
-}
-
-static int set_format(struct media_pad *pad, struct v4l2_mbus_framefmt *format)
-{
-	int ret;
-
-	if (format->width == 0 || format->height == 0)
-		return 0;
-
-	printf("Setting up format %s %ux%u on pad %s/%u\n",
-		pixelcode_to_string(format->code), format->width, format->height,
-		pad->entity->info.name, pad->index);
-
-	ret = v4l2_subdev_set_format(pad->entity, format, pad->index,
-				     V4L2_SUBDEV_FORMAT_ACTIVE);
-	if (ret < 0) {
-		printf("Unable to set format: %s (%d)\n", strerror(-ret), ret);
-		return ret;
-	}
-
-	printf("Format set: %s %ux%u\n",
-		pixelcode_to_string(format->code), format->width, format->height);
-
-	return 0;
-}
-
-static int set_crop(struct media_pad *pad, struct v4l2_rect *crop)
-{
-	int ret;
-
-	if (crop->left == -1 || crop->top == -1)
-		return 0;
-
-	printf("Setting up crop rectangle (%u,%u)/%ux%u on pad %s/%u\n",
-		crop->left, crop->top, crop->width, crop->height,
-		pad->entity->info.name, pad->index);
-
-	ret = v4l2_subdev_set_crop(pad->entity, crop, pad->index,
-				   V4L2_SUBDEV_FORMAT_ACTIVE);
-	if (ret < 0) {
-		printf("Unable to set crop rectangle: %s (%d)\n", strerror(-ret), ret);
-		return ret;
-	}
-
-	printf("Crop rectangle set: (%u,%u)/%ux%u\n",
-		crop->left, crop->top, crop->width, crop->height);
-
-	return 0;
-}
-
-static int set_frame_interval(struct media_entity *entity, struct v4l2_fract *interval)
-{
-	int ret;
-
-	if (interval->numerator == 0)
-		return 0;
-
-	printf("Setting up frame interval %u/%u on entity %s\n",
-		interval->numerator, interval->denominator, entity->info.name);
-
-	ret = v4l2_subdev_set_frame_interval(entity, interval);
-	if (ret < 0) {
-		printf("Unable to set frame interval: %s (%d)", strerror(-ret), ret);
-		return ret;
-	}
-
-	printf("Frame interval set: %u/%u\n",
-		interval->numerator, interval->denominator);
-
-	return 0;
-}
-
-
-static int setup_format(struct media_device *media, const char *p, char **endp)
-{
-	struct v4l2_mbus_framefmt format = { 0, 0, 0 };
-	struct media_pad *pad;
-	struct v4l2_rect crop = { -1, -1, -1, -1 };
-	struct v4l2_fract interval = { 0, 0 };
-	unsigned int i;
-	char *end;
-	int ret;
-
-	pad = parse_pad_format(media, &format, &crop, &interval, p, &end);
-	if (pad == NULL) {
-		printf("Unable to parse format\n");
-		return -EINVAL;
-	}
-
-	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
-		ret = set_crop(pad, &crop);
-		if (ret < 0)
-			return ret;
-	}
-
-	ret = set_format(pad, &format);
-	if (ret < 0)
-		return ret;
-
-	if (pad->flags & MEDIA_PAD_FL_SINK) {
-		ret = set_crop(pad, &crop);
-		if (ret < 0)
-			return ret;
-	}
-
-	ret = set_frame_interval(pad->entity, &interval);
-	if (ret < 0)
-		return ret;
-
-
-	/* If the pad is an output pad, automatically set the same format on
-	 * the remote subdev input pads, if any.
-	 */
-	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
-		for (i = 0; i < pad->entity->num_links; ++i) {
-			struct media_link *link = &pad->entity->links[i];
-			struct v4l2_mbus_framefmt remote_format;
-
-			if (!(link->flags & MEDIA_LNK_FL_ENABLED))
-				continue;
-
-			if (link->source == pad &&
-			    link->sink->entity->info.type == MEDIA_ENT_T_V4L2_SUBDEV) {
-				remote_format = format;
-				set_format(link->sink, &remote_format);
-			}
-		}
-	}
-
-	*endp = end;
-	return 0;
-}
-
-static int setup_formats(struct media_device *media, const char *p)
-{
-	char *end;
-	int ret;
-
-	do {
-		ret = setup_format(media, p, &end);
-		if (ret < 0)
-			return ret;
-
-		p = end + 1;
-	} while (*end == ',');
-
-	return *end ? -EINVAL : 0;
-}
-
 int main(int argc, char **argv)
 {
 	struct media_device *media;
@@ -669,7 +333,7 @@ int main(int argc, char **argv)
 		media_parse_setup_links(media, media_opts.links);
 
 	if (media_opts.formats)
-		setup_formats(media, media_opts.formats);
+		v4l2_subdev_parse_setup_formats(media, media_opts.formats);
 
 	if (media_opts.interactive) {
 		while (1) {
diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index 785209b..0b4793d 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -186,3 +186,346 @@ int v4l2_subdev_set_frame_interval(struct media_entity *entity,
 	*interval = ival.interval;
 	return 0;
 }
+
+static int v4l2_subdev_parse_format(struct v4l2_mbus_framefmt *format,
+				    const char *p, char **endp)
+{
+	enum v4l2_mbus_pixelcode code;
+	unsigned int width, height;
+	char *end;
+
+	for (; isspace(*p); ++p);
+	for (end = (char *)p; !isspace(*end) && *end != '\0'; ++end);
+
+	code = v4l2_subdev_string_to_pixelcode(p, end - p);
+	if (code == (enum v4l2_mbus_pixelcode)-1)
+		return -EINVAL;
+
+	for (p = end; isspace(*p); ++p);
+	width = strtoul(p, &end, 10);
+	if (*end != 'x')
+		return -EINVAL;
+
+	p = end + 1;
+	height = strtoul(p, &end, 10);
+	*endp = end;
+
+	memset(format, 0, sizeof(*format));
+	format->width = width;
+	format->height = height;
+	format->code = code;
+
+	return 0;
+}
+
+static int v4l2_subdev_parse_crop(
+	struct v4l2_rect *crop, const char *p, char **endp)
+{
+	char *end;
+
+	if (*p++ != '(')
+		return -EINVAL;
+
+	crop->left = strtoul(p, &end, 10);
+	if (*end != ',')
+		return -EINVAL;
+
+	p = end + 1;
+	crop->top = strtoul(p, &end, 10);
+	if (*end++ != ')')
+		return -EINVAL;
+	if (*end != '/')
+		return -EINVAL;
+
+	p = end + 1;
+	crop->width = strtoul(p, &end, 10);
+	if (*end != 'x')
+		return -EINVAL;
+
+	p = end + 1;
+	crop->height = strtoul(p, &end, 10);
+	*endp = end;
+
+	return 0;
+}
+
+static int v4l2_subdev_parse_frame_interval(struct v4l2_fract *interval,
+					    const char *p, char **endp)
+{
+	char *end;
+
+	for (; isspace(*p); ++p);
+
+	interval->numerator = strtoul(p, &end, 10);
+
+	for (p = end; isspace(*p); ++p);
+	if (*p++ != '/')
+		return -EINVAL;
+
+	for (; isspace(*p); ++p);
+	interval->denominator = strtoul(p, &end, 10);
+
+	*endp = end;
+	return 0;
+}
+
+static struct media_pad *v4l2_subdev_parse_pad_format(
+	struct media_device *media, struct v4l2_mbus_framefmt *format,
+	struct v4l2_rect *crop, struct v4l2_fract *interval, const char *p,
+	char **endp)
+{
+	struct media_pad *pad;
+	char *end;
+	int ret;
+
+	for (; isspace(*p); ++p);
+
+	pad = media_parse_pad(media, p, &end);
+	if (pad == NULL)
+		return NULL;
+
+	for (p = end; isspace(*p); ++p);
+	if (*p++ != '[')
+		return NULL;
+
+	for (; isspace(*p); ++p);
+
+	if (isalnum(*p)) {
+		ret = v4l2_subdev_parse_format(format, p, &end);
+		if (ret < 0)
+			return NULL;
+
+		for (p = end; isspace(*p); p++);
+	}
+
+	if (*p == '(') {
+		ret = v4l2_subdev_parse_crop(crop, p, &end);
+		if (ret < 0)
+			return NULL;
+
+		for (p = end; isspace(*p); p++);
+	}
+
+	if (*p == '@') {
+		ret = v4l2_subdev_parse_frame_interval(interval, ++p, &end);
+		if (ret < 0)
+			return NULL;
+
+		for (p = end; isspace(*p); p++);
+	}
+
+	if (*p != ']')
+		return NULL;
+
+	*endp = (char *)p + 1;
+	return pad;
+}
+
+static int set_format(struct media_pad *pad,
+		      struct v4l2_mbus_framefmt *format)
+{
+	int ret;
+
+	if (format->width == 0 || format->height == 0)
+		return 0;
+
+	printf("Setting up format %s %ux%u on pad %s/%u\n",
+	       v4l2_subdev_pixelcode_to_string(format->code),
+	       format->width, format->height,
+	       pad->entity->info.name, pad->index);
+
+	ret = v4l2_subdev_set_format(pad->entity, format, pad->index,
+				     V4L2_SUBDEV_FORMAT_ACTIVE);
+	if (ret < 0) {
+		printf("Unable to set format: %s (%d)\n", strerror(-ret), ret);
+		return ret;
+	}
+
+	printf("Format set: %s %ux%u\n",
+	       v4l2_subdev_pixelcode_to_string(format->code),
+	       format->width, format->height);
+
+	return 0;
+}
+
+static int set_crop(struct media_pad *pad, struct v4l2_rect *crop)
+{
+	int ret;
+
+	if (crop->left == -1 || crop->top == -1)
+		return 0;
+
+	printf("Setting up crop rectangle (%u,%u)/%ux%u on pad %s/%u\n",
+		crop->left, crop->top, crop->width, crop->height,
+		pad->entity->info.name, pad->index);
+
+	ret = v4l2_subdev_set_crop(pad->entity, crop, pad->index,
+				   V4L2_SUBDEV_FORMAT_ACTIVE);
+	if (ret < 0) {
+		printf("Unable to set crop rectangle: %s (%d)\n", strerror(-ret), ret);
+		return ret;
+	}
+
+	printf("Crop rectangle set: (%u,%u)/%ux%u\n",
+		crop->left, crop->top, crop->width, crop->height);
+
+	return 0;
+}
+
+static int set_frame_interval(struct media_entity *entity,
+			      struct v4l2_fract *interval)
+{
+	int ret;
+
+	if (interval->numerator == 0)
+		return 0;
+
+	printf("Setting up frame interval %u/%u on entity %s\n",
+		interval->numerator, interval->denominator, entity->info.name);
+
+	ret = v4l2_subdev_set_frame_interval(entity, interval);
+	if (ret < 0) {
+		printf("Unable to set frame interval: %s (%d)", strerror(-ret), ret);
+		return ret;
+	}
+
+	printf("Frame interval set: %u/%u\n",
+		interval->numerator, interval->denominator);
+
+	return 0;
+}
+
+
+static int v4l2_subdev_parse_setup_format(struct media_device *media,
+					  const char *p, char **endp)
+{
+	struct v4l2_mbus_framefmt format = { 0, 0, 0 };
+	struct media_pad *pad;
+	struct v4l2_rect crop = { -1, -1, -1, -1 };
+	struct v4l2_fract interval = { 0, 0 };
+	unsigned int i;
+	char *end;
+	int ret;
+
+	pad = v4l2_subdev_parse_pad_format(media, &format, &crop, &interval,
+					   p, &end);
+	if (pad == NULL) {
+		printf("Unable to parse format\n");
+		return -EINVAL;
+	}
+
+	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
+		ret = set_crop(pad, &crop);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = set_format(pad, &format);
+	if (ret < 0)
+		return ret;
+
+	if (pad->flags & MEDIA_PAD_FL_SINK) {
+		ret = set_crop(pad, &crop);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = set_frame_interval(pad->entity, &interval);
+	if (ret < 0)
+		return ret;
+
+
+	/* If the pad is an output pad, automatically set the same format on
+	 * the remote subdev input pads, if any.
+	 */
+	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
+		for (i = 0; i < pad->entity->num_links; ++i) {
+			struct media_link *link = &pad->entity->links[i];
+			struct v4l2_mbus_framefmt remote_format;
+
+			if (!(link->flags & MEDIA_LNK_FL_ENABLED))
+				continue;
+
+			if (link->source == pad &&
+			    link->sink->entity->info.type == MEDIA_ENT_T_V4L2_SUBDEV) {
+				remote_format = format;
+				set_format(link->sink, &remote_format);
+			}
+		}
+	}
+
+	*endp = end;
+	return 0;
+}
+
+int v4l2_subdev_parse_setup_formats(struct media_device *media, const char *p)
+{
+	char *end;
+	int ret;
+
+	do {
+		ret = v4l2_subdev_parse_setup_format(media, p, &end);
+		if (ret < 0)
+			return ret;
+
+		p = end + 1;
+	} while (*end == ',');
+
+	return *end ? -EINVAL : 0;
+}
+
+static struct {
+	const char *name;
+	enum v4l2_mbus_pixelcode code;
+} mbus_formats[] = {
+	{ "Y8", V4L2_MBUS_FMT_Y8_1X8},
+	{ "Y10", V4L2_MBUS_FMT_Y10_1X10 },
+	{ "Y12", V4L2_MBUS_FMT_Y12_1X12 },
+	{ "YUYV", V4L2_MBUS_FMT_YUYV8_1X16 },
+	{ "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
+	{ "SBGGR8", V4L2_MBUS_FMT_SBGGR8_1X8 },
+	{ "SGBRG8", V4L2_MBUS_FMT_SGBRG8_1X8 },
+	{ "SGRBG8", V4L2_MBUS_FMT_SGRBG8_1X8 },
+	{ "SRGGB8", V4L2_MBUS_FMT_SRGGB8_1X8 },
+	{ "SBGGR10", V4L2_MBUS_FMT_SBGGR10_1X10 },
+	{ "SGBRG10", V4L2_MBUS_FMT_SGBRG10_1X10 },
+	{ "SGRBG10", V4L2_MBUS_FMT_SGRBG10_1X10 },
+	{ "SRGGB10", V4L2_MBUS_FMT_SRGGB10_1X10 },
+	{ "SBGGR10_DPCM8", V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 },
+	{ "SGBRG10_DPCM8", V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8 },
+	{ "SGRBG10_DPCM8", V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 },
+	{ "SRGGB10_DPCM8", V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8 },
+	{ "SBGGR12", V4L2_MBUS_FMT_SBGGR12_1X12 },
+	{ "SGBRG12", V4L2_MBUS_FMT_SGBRG12_1X12 },
+	{ "SGRBG12", V4L2_MBUS_FMT_SGRBG12_1X12 },
+	{ "SRGGB12", V4L2_MBUS_FMT_SRGGB12_1X12 },
+};
+
+const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(mbus_formats); ++i) {
+		if (mbus_formats[i].code == code)
+			return mbus_formats[i].name;
+	}
+
+	return "unknown";
+}
+
+enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char *string,
+							 unsigned int length)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(mbus_formats); ++i) {
+		if (strncmp(mbus_formats[i].name, string, length) == 0)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(mbus_formats))
+		return (enum v4l2_mbus_pixelcode)-1;
+
+	return mbus_formats[i].code;
+}
+
diff --git a/src/v4l2subdev.h b/src/v4l2subdev.h
index b5772e0..db85491 100644
--- a/src/v4l2subdev.h
+++ b/src/v4l2subdev.h
@@ -158,5 +158,42 @@ int v4l2_subdev_get_frame_interval(struct media_entity *entity,
 int v4l2_subdev_set_frame_interval(struct media_entity *entity,
 	struct v4l2_fract *interval);
 
+/**
+ * @brief Parse a string and apply format, crop and frame interval settings.
+ * @param media - media device.
+ * @param p - input string
+ * @param endp - pointer to string p where parsing ended (return)
+ *
+ * Parse string @a p and apply format, crop and frame interval settings to a
+ * subdev pad specified in @a p. @a endp will be written a pointer where
+ * parsing of @a p ended.
+ *
+ * Format strings are separeted by commas (,).
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_parse_setup_formats(struct media_device *media, const char *p);
+
+/**
+ * @brief Convert media bus pixel code to string.
+ * @param code - input string
+ *
+ * Convert media bus pixel code @a code to a human-readable string.
+ *
+ * @return A pointer to a string on success, NULL on failure.
+ */
+const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code);
+
+/**
+ * @brief Parse string to media bus pixel code.
+ * @param string - input string
+ * @param lenght - length of the string
+ *
+ * Parse human readable string @a string to an media bus pixel code.
+ *
+ * @return media bus pixelcode on success, -1 on failure.
+ */
+enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char *string,
+							 unsigned int length);
 #endif
 
-- 
1.7.2.5

