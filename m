Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:38451 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbcBYVzG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2016 16:55:06 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH v5.1 4/4] media-ctl: List supported media bus formats
Date: Thu, 25 Feb 2016 23:52:59 +0200
Message-Id: <1456437179-3914-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <20160225215211.GF11084@valkosipuli.retiisi.org.uk>
References: <20160225215211.GF11084@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new topic option for -h to allow listing supported media bus codes
in conversion functions. This is useful in figuring out which media bus
codes are actually supported by the library. The numeric values of the
codes are listed as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 utils/media-ctl/options.c | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
index 0afc9c2..a288a1b 100644
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
 
@@ -48,6 +50,7 @@ static void usage(const char *argv0)
 	printf("-h, --help		Show verbose help and exit\n");
 	printf("-i, --interactive	Modify links interactively\n");
 	printf("-l, --links links	Comma-separated list of link descriptors to setup\n");
+	printf("    --known-mbus-fmts	List known media bus formats and their numeric values\n");
 	printf("-p, --print-topology	Print the device topology\n");
 	printf("    --print-dot		Print the device topology as a dot graph\n");
 	printf("-r, --reset		Reset all links to inactive\n");
@@ -88,9 +91,10 @@ static void usage(const char *argv0)
 		       v4l2_subdev_field_to_string(i));
 }
 
-#define OPT_PRINT_DOT		256
-#define OPT_GET_FORMAT		257
-#define OPT_SET_DV		258
+#define OPT_PRINT_DOT			256
+#define OPT_GET_FORMAT			257
+#define OPT_SET_DV			258
+#define OPT_LIST_KNOWN_MBUS_FMTS	259
 
 static struct option opts[] = {
 	{"device", 1, 0, 'd'},
@@ -103,6 +107,7 @@ static struct option opts[] = {
 	{"help", 0, 0, 'h'},
 	{"interactive", 0, 0, 'i'},
 	{"links", 1, 0, 'l'},
+	{"known-mbus-fmts", 0, 0, OPT_LIST_KNOWN_MBUS_FMTS},
 	{"print-dot", 0, 0, OPT_PRINT_DOT},
 	{"print-topology", 0, 0, 'p'},
 	{"reset", 0, 0, 'r'},
@@ -110,6 +115,27 @@ static struct option opts[] = {
 	{ },
 };
 
+static void list_known_mbus_formats(void)
+{
+	unsigned int ncodes;
+	const unsigned int *code = v4l2_subdev_pixelcode_list(&ncodes);
+
+	while (ncodes--) {
+		const char *str = v4l2_subdev_pixelcode_to_string(*code);
+		int spaces = 30 - (int)strlen(str);
+
+		if (*code == 0)
+			break;
+
+		if (spaces < 0)
+			spaces = 0;
+
+		printf("%s %*c 0x%4.4x\n", str, spaces, ' ', *code);
+
+		code++;
+	}
+}
+
 int parse_cmdline(int argc, char **argv)
 {
 	int opt;
@@ -120,7 +146,8 @@ int parse_cmdline(int argc, char **argv)
 	}
 
 	/* parse options */
-	while ((opt = getopt_long(argc, argv, "d:e:f:hil:prvV:", opts, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, "d:e:f:hil:prvV:",
+				  opts, NULL)) != -1) {
 		switch (opt) {
 		case 'd':
 			media_opts.devname = optarg;
@@ -177,6 +204,10 @@ int parse_cmdline(int argc, char **argv)
 			media_opts.dv_pad = optarg;
 			break;
 
+		case OPT_LIST_KNOWN_MBUS_FMTS:
+			list_known_mbus_formats();
+			exit(0);
+
 		default:
 			printf("Invalid option -%c\n", opt);
 			printf("Run %s -h for help.\n", argv[0]);
-- 
2.1.0.231.g7484e3b

