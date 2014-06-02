Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41755 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaFBPJq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jun 2014 11:09:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/3] media-ctl: Add DV timings support
Date: Mon,  2 Jun 2014 17:10:04 +0200
Message-Id: <1401721804-30133-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401721804-30133-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401721804-30133-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support printing (with -p) and setting (with --set-dv) DV timings at the
pad level.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 utils/media-ctl/media-ctl.c | 179 ++++++++++++++++++++++++++++++++++++++++++--
 utils/media-ctl/options.c   |   9 ++-
 utils/media-ctl/options.h   |   3 +-
 3 files changed, 184 insertions(+), 7 deletions(-)

diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
index 44c9644..319aa5d 100644
--- a/utils/media-ctl/media-ctl.c
+++ b/utils/media-ctl/media-ctl.c
@@ -121,6 +121,140 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
 	printf("]\n");
 }
 
+static const char *v4l2_dv_type_to_string(unsigned int type)
+{
+	static const struct {
+		__u32 type;
+		const char *name;
+	} types[] = {
+		{ V4L2_DV_BT_656_1120, "BT.656/1120" },
+	};
+
+	static char unknown[20];
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(types); i++) {
+		if (types[i].type == type)
+			return types[i].name;
+	}
+
+	sprintf(unknown, "Unknown (%u)", type);
+	return unknown;
+}
+
+static const struct flag_name bt_standards[] = {
+	{ V4L2_DV_BT_STD_CEA861, "CEA-861" },
+	{ V4L2_DV_BT_STD_DMT, "DMT" },
+	{ V4L2_DV_BT_STD_CVT, "CVT" },
+	{ V4L2_DV_BT_STD_GTF, "GTF" },
+};
+
+static const struct flag_name bt_capabilities[] = {
+	{ V4L2_DV_BT_CAP_INTERLACED, "interlaced" },
+	{ V4L2_DV_BT_CAP_PROGRESSIVE, "progressive" },
+	{ V4L2_DV_BT_CAP_REDUCED_BLANKING, "reduced-blanking" },
+	{ V4L2_DV_BT_CAP_CUSTOM, "custom" },
+};
+
+static const struct flag_name bt_flags[] = {
+	{ V4L2_DV_FL_REDUCED_BLANKING, "reduced-blanking" },
+	{ V4L2_DV_FL_CAN_REDUCE_FPS, "can-reduce-fps" },
+	{ V4L2_DV_FL_REDUCED_FPS, "reduced-fps" },
+	{ V4L2_DV_FL_HALF_LINE, "half-line" },
+};
+
+static void v4l2_subdev_print_dv_timings(const struct v4l2_dv_timings *timings,
+					 const char *name)
+{
+	printf("\t\t[dv.%s:%s", name, v4l2_dv_type_to_string(timings->type));
+
+	switch (timings->type) {
+	case V4L2_DV_BT_656_1120: {
+		const struct v4l2_bt_timings *bt = &timings->bt;
+		unsigned int htotal, vtotal;
+
+		htotal = V4L2_DV_BT_FRAME_WIDTH(bt);
+		vtotal = V4L2_DV_BT_FRAME_HEIGHT(bt);
+
+		printf(" %ux%u%s%llu (%ux%u)",
+		       bt->width, bt->height, bt->interlaced ? "i" : "p",
+		       (htotal * vtotal) > 0 ? (bt->pixelclock / (htotal * vtotal)) : 0,
+		       htotal, vtotal);
+
+		printf(" stds:");
+		print_flags(bt_standards, ARRAY_SIZE(bt_standards),
+			    bt->standards);
+		printf(" flags:");
+		print_flags(bt_flags, ARRAY_SIZE(bt_flags),
+			    bt->flags);
+
+		break;
+	}
+	}
+
+	printf("]\n");
+}
+
+static void v4l2_subdev_print_pad_dv(struct media_entity *entity,
+	unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	struct v4l2_dv_timings_cap caps;
+	int ret;
+
+	caps.pad = pad;
+	ret = v4l2_subdev_get_dv_timings_caps(entity, &caps);
+	if (ret != 0)
+		return;
+
+	printf("\t\t[dv.caps:%s", v4l2_dv_type_to_string(caps.type));
+
+	switch (caps.type) {
+	case V4L2_DV_BT_656_1120:
+		printf(" min:%ux%u@%llu max:%ux%u@%llu",
+		       caps.bt.min_width, caps.bt.min_height, caps.bt.min_pixelclock,
+		       caps.bt.max_width, caps.bt.max_height, caps.bt.max_pixelclock);
+
+		printf(" stds:");
+		print_flags(bt_standards, ARRAY_SIZE(bt_standards),
+			    caps.bt.standards);
+		printf(" caps:");
+		print_flags(bt_capabilities, ARRAY_SIZE(bt_capabilities),
+			    caps.bt.capabilities);
+
+		break;
+	}
+
+	printf("]\n");
+}
+
+static void v4l2_subdev_print_subdev_dv(struct media_entity *entity)
+{
+	struct v4l2_dv_timings timings;
+	int ret;
+
+	ret = v4l2_subdev_query_dv_timings(entity, &timings);
+	switch (ret) {
+	case -ENOLINK:
+		printf("\t\t[dv.query:no-link]\n");
+		break;
+	case -ENOLCK:
+		printf("\t\t[dv.query:no-lock]\n");
+		break;
+	case -ERANGE:
+		printf("\t\t[dv.query:out-of-range]\n");
+		break;
+	case 0:
+		v4l2_subdev_print_dv_timings(&timings, "detect");
+		break;
+	default:
+		return;
+	}
+
+	ret = v4l2_subdev_get_dv_timings(entity, &timings);
+	if (ret == 0)
+		v4l2_subdev_print_dv_timings(&timings, "current");
+}
+
 static const char *media_entity_type_to_string(unsigned type)
 {
 	static const struct {
@@ -280,6 +414,19 @@ static void media_print_topology_dot(struct media_device *media)
 	printf("}\n");
 }
 
+static void media_print_pad_text(struct media_entity *entity,
+				 const struct media_pad *pad)
+{
+	if (media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+		return;
+
+	v4l2_subdev_print_format(entity, pad->index, V4L2_SUBDEV_FORMAT_ACTIVE);
+	v4l2_subdev_print_pad_dv(entity, pad->index, V4L2_SUBDEV_FORMAT_ACTIVE);
+
+	if (pad->flags & MEDIA_PAD_FL_SOURCE)
+		v4l2_subdev_print_subdev_dv(entity);
+}
+
 static void media_print_topology_text(struct media_device *media)
 {
 	static const struct flag_name link_flags[] = {
@@ -316,8 +463,7 @@ static void media_print_topology_text(struct media_device *media)
 
 			printf("\tpad%u: %s\n", j, media_pad_type_to_string(pad->flags));
 
-			if (media_entity_type(entity) == MEDIA_ENT_T_V4L2_SUBDEV)
-				v4l2_subdev_print_format(entity, j, V4L2_SUBDEV_FORMAT_ACTIVE);
+			media_print_pad_text(entity, pad);
 
 			for (k = 0; k < num_links; k++) {
 				const struct media_link *link = media_entity_get_link(entity, k);
@@ -413,12 +559,12 @@ int main(int argc, char **argv)
 		printf("%s\n", media_entity_get_devname(entity));
 	}
 
-	if (media_opts.pad) {
+	if (media_opts.fmt_pad) {
 		struct media_pad *pad;
 
-		pad = media_parse_pad(media, media_opts.pad, NULL);
+		pad = media_parse_pad(media, media_opts.fmt_pad, NULL);
 		if (pad == NULL) {
-			printf("Pad '%s' not found\n", media_opts.pad);
+			printf("Pad '%s' not found\n", media_opts.fmt_pad);
 			goto out;
 		}
 
@@ -426,6 +572,29 @@ int main(int argc, char **argv)
 					 V4L2_SUBDEV_FORMAT_ACTIVE);
 	}
 
+	if (media_opts.dv_pad) {
+		struct v4l2_dv_timings timings;
+		struct media_pad *pad;
+
+		pad = media_parse_pad(media, media_opts.dv_pad, NULL);
+		if (pad == NULL) {
+			printf("Pad '%s' not found\n", media_opts.dv_pad);
+			goto out;
+		}
+
+		ret = v4l2_subdev_query_dv_timings(pad->entity, &timings);
+		if (ret < 0) {
+			printf("Failed to query DV timings: %s\n", strerror(ret));
+			goto out;
+		}
+
+		ret = v4l2_subdev_set_dv_timings(pad->entity, &timings);
+		if (ret < 0) {
+			printf("Failed to set DV timings: %s\n", strerror(ret));
+			goto out;
+		}
+	}
+
 	if (media_opts.print || media_opts.print_dot) {
 		media_print_topology(media, media_opts.print_dot);
 		printf("\n");
diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
index 90d9316..e8aa0e2 100644
--- a/utils/media-ctl/options.c
+++ b/utils/media-ctl/options.c
@@ -39,6 +39,7 @@ static void usage(const char *argv0)
 	printf("-e, --entity name	Print the device name associated with the given entity\n");
 	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to setup\n");
 	printf("    --get-v4l2 pad	Print the active format on a given pad\n");
+	printf("    --set-dv pad	Configure DV timings on a given pad\n");
 	printf("-h, --help		Show verbose help and exit\n");
 	printf("-i, --interactive	Modify links interactively\n");
 	printf("-l, --links links	Comma-separated list of link descriptors to setup\n");
@@ -79,6 +80,7 @@ static void usage(const char *argv0)
 
 #define OPT_PRINT_DOT		256
 #define OPT_GET_FORMAT		257
+#define OPT_SET_DV		258
 
 static struct option opts[] = {
 	{"device", 1, 0, 'd'},
@@ -87,6 +89,7 @@ static struct option opts[] = {
 	{"set-v4l2", 1, 0, 'V'},
 	{"get-format", 1, 0, OPT_GET_FORMAT},
 	{"get-v4l2", 1, 0, OPT_GET_FORMAT},
+	{"set-dv", 1, 0, OPT_SET_DV},
 	{"help", 0, 0, 'h'},
 	{"interactive", 0, 0, 'i'},
 	{"links", 1, 0, 'l'},
@@ -155,7 +158,11 @@ int parse_cmdline(int argc, char **argv)
 			break;
 
 		case OPT_GET_FORMAT:
-			media_opts.pad = optarg;
+			media_opts.fmt_pad = optarg;
+			break;
+
+		case OPT_SET_DV:
+			media_opts.dv_pad = optarg;
 			break;
 
 		default:
diff --git a/utils/media-ctl/options.h b/utils/media-ctl/options.h
index 9d514ea..9b5f314 100644
--- a/utils/media-ctl/options.h
+++ b/utils/media-ctl/options.h
@@ -33,7 +33,8 @@ struct media_options
 	const char *entity;
 	const char *formats;
 	const char *links;
-	const char *pad;
+	const char *fmt_pad;
+	const char *dv_pad;
 };
 
 extern struct media_options media_opts;
-- 
1.8.5.5

