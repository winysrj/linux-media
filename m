Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58637 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965176AbbLHPS0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2015 10:18:26 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH v2 3/3] media-ctl: List supported media bus formats
Date: Tue,  8 Dec 2015 17:15:16 +0200
Message-Id: <1449587716-22954-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1449587716-22954-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1449587716-22954-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new topic option for -h to allow listing supported media bus codes
in conversion functions. This is useful in figuring out which media bus
codes are actually supported by the library. The numeric values of the
codes are listed as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/options.c | 42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
index 0afc9c2..5902aed 100644
--- a/utils/media-ctl/options.c
+++ b/utils/media-ctl/options.c
@@ -22,7 +22,9 @@
 #include <getopt.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <unistd.h>
+#include <v4l2subdev.h>
 
 #include <linux/videodev2.h>
 
@@ -45,7 +47,8 @@ static void usage(const char *argv0)
 	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to setup\n");
 	printf("    --get-v4l2 pad	Print the active format on a given pad\n");
 	printf("    --set-dv pad	Configure DV timings on a given pad\n");
-	printf("-h, --help		Show verbose help and exit\n");
+	printf("-h, --help[=topic]	Show verbose help and exit\n");
+	printf("			topics:	mbus-fmt: List supported media bus pixel codes\n");
 	printf("-i, --interactive	Modify links interactively\n");
 	printf("-l, --links links	Comma-separated list of link descriptors to setup\n");
 	printf("-p, --print-topology	Print the device topology\n");
@@ -100,7 +103,7 @@ static struct option opts[] = {
 	{"get-format", 1, 0, OPT_GET_FORMAT},
 	{"get-v4l2", 1, 0, OPT_GET_FORMAT},
 	{"set-dv", 1, 0, OPT_SET_DV},
-	{"help", 0, 0, 'h'},
+	{"help", 2, 0, 'h'},
 	{"interactive", 0, 0, 'i'},
 	{"links", 1, 0, 'l'},
 	{"print-dot", 0, 0, OPT_PRINT_DOT},
@@ -110,6 +113,27 @@ static struct option opts[] = {
 	{ },
 };
 
+void list_mbus_formats(void)
+{
+	unsigned int i;
+
+	printf("Supported media bus pixel codes\n");
+
+	for (i = 0; ; i++) {
+		unsigned int code = v4l2_subdev_pixelcode_list(i);
+		const char *str = v4l2_subdev_pixelcode_to_string(code);
+		int spaces = 30 - (int)strlen(str);
+
+		if (code == -1)
+			break;
+
+		if (spaces < 0)
+			spaces = 0;
+
+		printf("\t%s %*c (0x%8.8x)\n", str, spaces, ' ', code);
+	}
+}
+
 int parse_cmdline(int argc, char **argv)
 {
 	int opt;
@@ -120,7 +144,8 @@ int parse_cmdline(int argc, char **argv)
 	}
 
 	/* parse options */
-	while ((opt = getopt_long(argc, argv, "d:e:f:hil:prvV:", opts, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, "d:e:f:h::il:prvV:",
+				  opts, NULL)) != -1) {
 		switch (opt) {
 		case 'd':
 			media_opts.devname = optarg;
@@ -142,7 +167,16 @@ int parse_cmdline(int argc, char **argv)
 			break;
 
 		case 'h':
-			usage(argv[0]);
+			if (optarg) {
+				if (!strcmp(optarg, "mbus-fmt"))
+					list_mbus_formats();
+				else
+					fprintf(stderr,
+						"Unknown topic \"%s\"\n",
+						optarg);
+			} else {
+				usage(argv[0]);
+			}
 			exit(0);
 
 		case 'i':
-- 
2.1.0.231.g7484e3b

