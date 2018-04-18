Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38905 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751942AbeDRKxt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 06:53:49 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4l-utils] media-ctl: add --get-dv option
Date: Wed, 18 Apr 2018 12:53:39 +0200
Message-Id: <20180418105339.24143-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Printing the queried and current DV timings is already supported as part
of the --print-topology option. Add a --get-dv option to print DV
timings of an individual entitiy, to complement --set-dv.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 utils/media-ctl/media-ctl.c | 12 ++++++++++++
 utils/media-ctl/options.c   |  7 +++++++
 utils/media-ctl/options.h   |  1 +
 3 files changed, 20 insertions(+)

diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
index a9417a3a..51da7f8a 100644
--- a/utils/media-ctl/media-ctl.c
+++ b/utils/media-ctl/media-ctl.c
@@ -604,6 +604,18 @@ int main(int argc, char **argv)
 					 V4L2_SUBDEV_FORMAT_ACTIVE);
 	}
 
+	if (media_opts.get_dv_pad) {
+		struct media_pad *pad;
+
+		pad = media_parse_pad(media, media_opts.get_dv_pad, NULL);
+		if (pad == NULL) {
+			printf("Pad '%s' not found\n", media_opts.get_dv_pad);
+			goto out;
+		}
+
+		v4l2_subdev_print_subdev_dv(pad->entity);
+	}
+
 	if (media_opts.dv_pad) {
 		struct v4l2_dv_timings timings;
 		struct media_pad *pad;
diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
index 83ca1cac..16367857 100644
--- a/utils/media-ctl/options.c
+++ b/utils/media-ctl/options.c
@@ -46,6 +46,7 @@ static void usage(const char *argv0)
 	printf("-e, --entity name	Print the device name associated with the given entity\n");
 	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to setup\n");
 	printf("    --get-v4l2 pad	Print the active format on a given pad\n");
+	printf("    --get-dv pad        Print detected and current DV timings on a given pad\n");
 	printf("    --set-dv pad	Configure DV timings on a given pad\n");
 	printf("-h, --help		Show verbose help and exit\n");
 	printf("-i, --interactive	Modify links interactively\n");
@@ -117,6 +118,7 @@ static void usage(const char *argv0)
 #define OPT_GET_FORMAT			257
 #define OPT_SET_DV			258
 #define OPT_LIST_KNOWN_MBUS_FMTS	259
+#define OPT_GET_DV			260
 
 static struct option opts[] = {
 	{"device", 1, 0, 'd'},
@@ -125,6 +127,7 @@ static struct option opts[] = {
 	{"set-v4l2", 1, 0, 'V'},
 	{"get-format", 1, 0, OPT_GET_FORMAT},
 	{"get-v4l2", 1, 0, OPT_GET_FORMAT},
+	{"get-dv", 1, 0, OPT_GET_DV},
 	{"set-dv", 1, 0, OPT_SET_DV},
 	{"help", 0, 0, 'h'},
 	{"interactive", 0, 0, 'i'},
@@ -222,6 +225,10 @@ int parse_cmdline(int argc, char **argv)
 			media_opts.fmt_pad = optarg;
 			break;
 
+		case OPT_GET_DV:
+			media_opts.get_dv_pad = optarg;
+			break;
+
 		case OPT_SET_DV:
 			media_opts.dv_pad = optarg;
 			break;
diff --git a/utils/media-ctl/options.h b/utils/media-ctl/options.h
index 9b5f314e..7e0556fc 100644
--- a/utils/media-ctl/options.h
+++ b/utils/media-ctl/options.h
@@ -34,6 +34,7 @@ struct media_options
 	const char *formats;
 	const char *links;
 	const char *fmt_pad;
+	const char *get_dv_pad;
 	const char *dv_pad;
 };
 
-- 
2.16.3
