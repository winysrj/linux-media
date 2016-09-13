Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49348 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751967AbcIMI30 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 04:29:26 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [v4l-utils PATCH 2/2] media-ctl: Print information related to a single entity
Date: Tue, 13 Sep 2016 11:28:16 +0300
Message-Id: <1473755296-14109-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473755296-14109-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473755296-14109-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an optional argument to the -p option that allows printing all
information related to a given entity. This may be handy sometimes if only
a single entity is of interest and there are many entities.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/media-ctl.c | 26 +++++++++++++++-----------
 utils/media-ctl/options.c   |  9 ++++++---
 utils/media-ctl/options.h   |  1 +
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
index 0499008..fdd2449 100644
--- a/utils/media-ctl/media-ctl.c
+++ b/utils/media-ctl/media-ctl.c
@@ -504,14 +504,6 @@ static void media_print_topology_text(struct media_device *media)
 			media, media_get_entity(media, i));
 }
 
-void media_print_topology(struct media_device *media, int dot)
-{
-	if (dot)
-		media_print_topology_dot(media);
-	else
-		media_print_topology_text(media);
-}
-
 int main(int argc, char **argv)
 {
 	struct media_device *media;
@@ -611,9 +603,21 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (media_opts.print || media_opts.print_dot) {
-		media_print_topology(media, media_opts.print_dot);
-		printf("\n");
+	if (media_opts.print_dot) {
+		media_print_topology_dot(media);
+	} else if (media_opts.print_entity) {
+		struct media_entity *entity = NULL;
+
+		entity = media_get_entity_by_name(media,
+						  media_opts.print_entity);
+		if (entity == NULL) {
+			printf("Entity '%s' not found\n",
+			       media_opts.print_entity);
+			goto out;
+		}
+		media_print_topology_text_entity(media, entity);
+	} else if (media_opts.print) {
+		media_print_topology_text(media);
 	}
 
 	if (media_opts.reset) {
diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
index a288a1b..3352626 100644
--- a/utils/media-ctl/options.c
+++ b/utils/media-ctl/options.c
@@ -51,7 +51,9 @@ static void usage(const char *argv0)
 	printf("-i, --interactive	Modify links interactively\n");
 	printf("-l, --links links	Comma-separated list of link descriptors to setup\n");
 	printf("    --known-mbus-fmts	List known media bus formats and their numeric values\n");
-	printf("-p, --print-topology	Print the device topology\n");
+	printf("-p, --print-topology [name] Print the device topology\n");
+	printf("			If entity name is specified, information to that entity\n");
+	printf("			only is printed.\n");
 	printf("    --print-dot		Print the device topology as a dot graph\n");
 	printf("-r, --reset		Reset all links to inactive\n");
 	printf("-v, --verbose		Be verbose\n");
@@ -109,7 +111,7 @@ static struct option opts[] = {
 	{"links", 1, 0, 'l'},
 	{"known-mbus-fmts", 0, 0, OPT_LIST_KNOWN_MBUS_FMTS},
 	{"print-dot", 0, 0, OPT_PRINT_DOT},
-	{"print-topology", 0, 0, 'p'},
+	{"print-topology", 2, 0, 'p'},
 	{"reset", 0, 0, 'r'},
 	{"verbose", 0, 0, 'v'},
 	{ },
@@ -146,7 +148,7 @@ int parse_cmdline(int argc, char **argv)
 	}
 
 	/* parse options */
-	while ((opt = getopt_long(argc, argv, "d:e:f:hil:prvV:",
+	while ((opt = getopt_long(argc, argv, "d:e:f:hil:p::rvV:",
 				  opts, NULL)) != -1) {
 		switch (opt) {
 		case 'd':
@@ -182,6 +184,7 @@ int parse_cmdline(int argc, char **argv)
 
 		case 'p':
 			media_opts.print = 1;
+			media_opts.print_entity = optarg;
 			break;
 
 		case 'r':
diff --git a/utils/media-ctl/options.h b/utils/media-ctl/options.h
index 9b5f314..ff9dfdf 100644
--- a/utils/media-ctl/options.h
+++ b/utils/media-ctl/options.h
@@ -30,6 +30,7 @@ struct media_options
 		     print_dot:1,
 		     reset:1,
 		     verbose:1;
+	const char *print_entity;
 	const char *entity;
 	const char *formats;
 	const char *links;
-- 
2.7.4

