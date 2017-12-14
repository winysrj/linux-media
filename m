Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:34994 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754233AbdLNTKG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 14:10:06 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [RFC 2/2] v4l2-ctl: add ROUTING get and set options
Date: Thu, 14 Dec 2017 20:09:43 +0100
Message-Id: <20171214190943.8179-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171214190943.8179-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171214190943.8179-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 utils/v4l2-ctl/Android.mk           |   2 +-
 utils/v4l2-ctl/Makefile.am          |   2 +-
 utils/v4l2-ctl/v4l2-ctl-routing.cpp | 154 ++++++++++++++++++++++++++++++++++++
 utils/v4l2-ctl/v4l2-ctl.cpp         |  10 +++
 utils/v4l2-ctl/v4l2-ctl.h           |   9 +++
 5 files changed, 175 insertions(+), 2 deletions(-)
 create mode 100644 utils/v4l2-ctl/v4l2-ctl-routing.cpp

diff --git a/utils/v4l2-ctl/Android.mk b/utils/v4l2-ctl/Android.mk
index 707895026f88962d..f83347e04ff477c7 100644
--- a/utils/v4l2-ctl/Android.mk
+++ b/utils/v4l2-ctl/Android.mk
@@ -21,5 +21,5 @@ LOCAL_SRC_FILES := \
     v4l2-ctl-io.cpp v4l2-ctl-stds.cpp v4l2-ctl-vidcap.cpp v4l2-ctl-vidout.cpp \
     v4l2-ctl-overlay.cpp v4l2-ctl-vbi.cpp v4l2-ctl-selection.cpp v4l2-ctl-misc.cpp \
     v4l2-ctl-streaming.cpp v4l2-ctl-sdr.cpp v4l2-ctl-edid.cpp v4l2-ctl-modes.cpp \
-    v4l2-tpg-colors.c v4l2-tpg-core.c v4l-stream.c
+    v4l2-tpg-colors.c v4l2-tpg-core.c v4l-stream.c v4l2-ctl-routing.cpp
 include $(BUILD_EXECUTABLE)
diff --git a/utils/v4l2-ctl/Makefile.am b/utils/v4l2-ctl/Makefile.am
index cae4e747a0afa047..69bf466e89bbf72e 100644
--- a/utils/v4l2-ctl/Makefile.am
+++ b/utils/v4l2-ctl/Makefile.am
@@ -6,7 +6,7 @@ v4l2_ctl_SOURCES = v4l2-ctl.cpp v4l2-ctl.h v4l2-ctl-common.cpp v4l2-ctl-tuner.cp
 	v4l2-ctl-io.cpp v4l2-ctl-stds.cpp v4l2-ctl-vidcap.cpp v4l2-ctl-vidout.cpp \
 	v4l2-ctl-overlay.cpp v4l2-ctl-vbi.cpp v4l2-ctl-selection.cpp v4l2-ctl-misc.cpp \
 	v4l2-ctl-streaming.cpp v4l2-ctl-sdr.cpp v4l2-ctl-edid.cpp v4l2-ctl-modes.cpp \
-	v4l2-tpg-colors.c v4l2-tpg-core.c v4l-stream.c v4l2-ctl-meta.cpp
+	v4l2-tpg-colors.c v4l2-tpg-core.c v4l-stream.c v4l2-ctl-meta.cpp v4l2-ctl-routing.cpp
 v4l2_ctl_CPPFLAGS = -I$(top_srcdir)/utils/common
 
 if WITH_LIBV4L
diff --git a/utils/v4l2-ctl/v4l2-ctl-routing.cpp b/utils/v4l2-ctl/v4l2-ctl-routing.cpp
new file mode 100644
index 0000000000000000..55a2e44949785015
--- /dev/null
+++ b/utils/v4l2-ctl/v4l2-ctl-routing.cpp
@@ -0,0 +1,154 @@
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <inttypes.h>
+#include <fcntl.h>
+#include <ctype.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+
+#include "v4l2-ctl.h"
+
+#include <linux/v4l2-subdev.h>
+
+/*
+ * The max value comes from a check in the kernel source code
+ * drivers/media/v4l2-core/v4l2-ioctl.c check_array_args()
+ */
+#define NUM_ROUTES_MAX 256
+
+#define ARRAY_SIZE(array) (sizeof(array) / sizeof((array)[0]))
+
+struct v4l2_subdev_routing routing;
+struct v4l2_subdev_route routes[NUM_ROUTES_MAX];
+
+struct flag_name {
+	__u32 flag;
+	const char *name;
+};
+
+static void print_flags(const struct flag_name *flag_names, unsigned int num_entries, __u32 flags)
+{
+	bool first = true;
+	unsigned int i;
+
+	for (i = 0; i < num_entries; i++) {
+		if (!(flags & flag_names[i].flag))
+			continue;
+		if (!first)
+			printf(",");
+		printf("%s", flag_names[i].name);
+		flags &= ~flag_names[i].flag;
+		first = false;
+	}
+
+	if (flags) {
+		if (!first)
+			printf(",");
+		printf("0x%x", flags);
+	}
+}
+
+static void print_routes(const struct v4l2_subdev_routing *r)
+{
+	unsigned int i;
+
+	static const struct flag_name route_flags[] = {
+		{ V4L2_SUBDEV_ROUTE_FL_ACTIVE, "ENABLED" },
+		{ V4L2_SUBDEV_ROUTE_FL_IMMUTABLE, "IMMUTABLE" },
+	};
+
+	for (i = 0; i < r->num_routes; i++) {
+		printf("%d/%d -> %d/%d [",
+		       r->routes[i].sink_pad, r->routes[i].sink_stream,
+		       r->routes[i].source_pad, r->routes[i].source_stream);
+		print_flags(route_flags, ARRAY_SIZE(route_flags), r->routes[i].flags);
+		printf("]\n");
+	}
+}
+
+void routing_usage(void)
+{
+	printf("\nRoute options:\n"
+	       "  --get-routing		Print the route topology\n"
+	       "  --set-routing routes	Comma-separated list of route descriptors to setup\n"
+	       "\n"
+	       "Routes are defined as\n"
+	       "	routes		= route { ',' route } ;\n"
+	       "	route		= sink '->' source '[' flags ']' ;\n"
+	       "	sink		= sink-pad '/' sink-stream ;\n"
+	       "	source		= source-pad '/' source-stream ;\n"
+	       "\n"
+	       "where the fields are\n"
+	       "	sink-pad	= Pad numeric identifier for sink\n"
+	       "	sink-stream	= Stream numeric identifier for sink\n"
+	       "	source-pad	= Pad numeric identifier for source\n"
+	       "	source-stream	= Stream numeric identifier for source\n"
+	       "	flags		= Route flags (0: inactive, 1: active)\n"
+	       );
+}
+
+/******************************************************/
+
+void routing_cmd(int ch, char *optarg)
+{
+	struct v4l2_subdev_route *r;
+	char *end, *ref, *tok;
+	unsigned int flags;
+
+	switch (ch) {
+	case OptSetRouting:
+		memset(&routing, 0, sizeof(routing));
+		memset(routes, 0, sizeof(routes[0]) * NUM_ROUTES_MAX);
+		routing.num_routes = 0;
+		routing.routes = routes;
+
+		if (!optarg)
+			break;
+
+		r = routing.routes;
+		ref = end = strdup(optarg);
+		while ((tok = strsep(&end, ",")) != NULL) {
+			if (sscanf(tok, "%u/%u -> %u/%u [%u]",
+				   &r->sink_pad, &r->sink_stream,
+				   &r->source_pad, &r->source_stream,
+				   &flags) != 5 || (flags != 0 && flags != 1)) {
+				free(ref);
+				fprintf(stderr, "Invalid route information specified\n");
+				routing_usage();
+				exit(1);
+			}
+
+			if (flags == 1)
+				r->flags = V4L2_SUBDEV_ROUTE_FL_ACTIVE;
+
+			r++;
+			routing.num_routes++;
+		}
+		free(ref);
+
+		break;
+	}
+}
+
+void routing_set(int fd)
+{
+	if (options[OptSetRouting]) {
+		if (doioctl(fd, VIDIOC_SUBDEV_S_ROUTING, &routing) == 0)
+			printf("Routing set\n");
+	}
+}
+
+void routing_get(int fd)
+{
+	if (options[OptGetRouting]) {
+		memset(&routing, 0, sizeof(routing));
+		memset(routes, 0, sizeof(routes[0]) * NUM_ROUTES_MAX);
+		routing.num_routes = NUM_ROUTES_MAX;
+		routing.routes = routes;
+
+		if (doioctl(fd, VIDIOC_SUBDEV_G_ROUTING, &routing) == 0)
+			print_routes(&routing);
+	}
+}
diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index e02dc7563e50bd1d..718d5d175fd86364 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -87,6 +87,7 @@ static struct option long_options[] = {
 	{"help-misc", no_argument, 0, OptHelpMisc},
 	{"help-streaming", no_argument, 0, OptHelpStreaming},
 	{"help-edid", no_argument, 0, OptHelpEdid},
+	{"help-routing", no_argument, 0, OptHelpRouting},
 	{"help-all", no_argument, 0, OptHelpAll},
 #ifndef NO_LIBV4L2
 	{"wrapper", no_argument, 0, OptUseWrapper},
@@ -210,6 +211,8 @@ static struct option long_options[] = {
 	{"get-edid", optional_argument, 0, OptGetEdid},
 	{"info-edid", optional_argument, 0, OptInfoEdid},
 	{"fix-edid-checksums", no_argument, 0, OptFixEdidChecksums},
+	{"set-routing", required_argument, 0, OptSetRouting},
+	{"get-routing", no_argument, 0, OptGetRouting},
 	{"tuner-index", required_argument, 0, OptTunerIndex},
 	{"list-buffers", no_argument, 0, OptListBuffers},
 	{"list-buffers-out", no_argument, 0, OptListBuffersOut},
@@ -271,6 +274,7 @@ static void usage_all(void)
        misc_usage();
        streaming_usage();
        edid_usage();
+       routing_usage();
 }
 
 static int test_open(const char *file, int oflag)
@@ -1286,6 +1290,9 @@ int main(int argc, char **argv)
 		case OptHelpEdid:
 			edid_usage();
 			return 0;
+		case OptHelpRouting:
+			routing_usage();
+			return 0;
 		case OptHelpAll:
 			usage_all();
 			return 0;
@@ -1345,6 +1352,7 @@ int main(int argc, char **argv)
 			misc_cmd(ch, optarg);
 			streaming_cmd(ch, optarg);
 			edid_cmd(ch, optarg);
+			routing_cmd(ch, optarg);
 			break;
 		}
 	}
@@ -1484,6 +1492,7 @@ int main(int argc, char **argv)
 	streaming_set(fd, out_fd);
 	misc_set(fd);
 	edid_set(fd);
+	routing_set(fd);
 
 	/* Get options */
 
@@ -1500,6 +1509,7 @@ int main(int argc, char **argv)
 	selection_get(fd);
 	misc_get(fd);
 	edid_get(fd);
+	routing_get(fd);
 
 	/* List options */
 
diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
index 3b56d8a6cd6c3852..f1051ec61695b106 100644
--- a/utils/v4l2-ctl/v4l2-ctl.h
+++ b/utils/v4l2-ctl/v4l2-ctl.h
@@ -157,6 +157,8 @@ enum Option {
 	OptGetEdid,
 	OptInfoEdid,
 	OptFixEdidChecksums,
+	OptSetRouting,
+	OptGetRouting,
 	OptFreqSeek,
 	OptEncoderCmd,
 	OptTryEncoderCmd,
@@ -215,6 +217,7 @@ enum Option {
 	OptHelpMisc,
 	OptHelpStreaming,
 	OptHelpEdid,
+	OptHelpRouting,
 	OptHelpAll,
 	OptLast = 512
 };
@@ -371,6 +374,12 @@ void edid_cmd(int ch, char *optarg);
 void edid_set(int fd);
 void edid_get(int fd);
 
+// v4l2-ctl-routing.cpp
+void routing_usage(void);
+void routing_cmd(int ch, char *optarg);
+void routing_set(int fd);
+void routing_get(int fd);
+
 /* v4l2-ctl-modes.cpp */
 bool calc_cvt_modeline(int image_width, int image_height,
 		       int refresh_rate, int reduced_blanking,
-- 
2.14.2
