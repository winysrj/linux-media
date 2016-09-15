Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13289 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933287AbcIOGmQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 02:42:16 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [v4l-utils PATCH v1.3 2/2] media-ctl: Print information related to a single entity
Date: Thu, 15 Sep 2016 09:40:39 +0300
Message-Id: <1473921639-6544-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <163775066.40INlWgSp9@avalon>
References: <163775066.40INlWgSp9@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a possibility to printing all information related to a given entity by
using both -p and -e options. This may be handy sometimes if only a single
entity is of interest and there are many entities.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/media-ctl.c | 32 ++++++++++++++------------------
 utils/media-ctl/options.c   |  4 +++-
 2 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
index 0499008..b60d297 100644
--- a/utils/media-ctl/media-ctl.c
+++ b/utils/media-ctl/media-ctl.c
@@ -504,19 +504,11 @@ static void media_print_topology_text(struct media_device *media)
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
+	struct media_entity *entity = NULL;
 	int ret = -1;
-	const char *devname;
 
 	if (parse_cmdline(argc, argv))
 		return EXIT_FAILURE;
@@ -562,17 +554,11 @@ int main(int argc, char **argv)
 	}
 
 	if (media_opts.entity) {
-		struct media_entity *entity;
-
 		entity = media_get_entity_by_name(media, media_opts.entity);
 		if (entity == NULL) {
 			printf("Entity '%s' not found\n", media_opts.entity);
 			goto out;
 		}
-
-		devname = media_entity_get_devname(entity);
-		if (devname)
-			printf("%s\n", devname);
 	}
 
 	if (media_opts.fmt_pad) {
@@ -611,9 +597,19 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (media_opts.print || media_opts.print_dot) {
-		media_print_topology(media, media_opts.print_dot);
-		printf("\n");
+	if (media_opts.print_dot) {
+		media_print_topology_dot(media);
+	} else if (media_opts.print) {
+		if (entity)
+			media_print_topology_text_entity(media, entity);
+		else
+			media_print_topology_text(media);
+	} else if (entity) {
+		const char *devname;
+
+		devname = media_entity_get_devname(entity);
+		if (devname)
+			printf("%s\n", devname);
 	}
 
 	if (media_opts.reset) {
diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
index a288a1b..77d1a51 100644
--- a/utils/media-ctl/options.c
+++ b/utils/media-ctl/options.c
@@ -51,7 +51,9 @@ static void usage(const char *argv0)
 	printf("-i, --interactive	Modify links interactively\n");
 	printf("-l, --links links	Comma-separated list of link descriptors to setup\n");
 	printf("    --known-mbus-fmts	List known media bus formats and their numeric values\n");
-	printf("-p, --print-topology	Print the device topology\n");
+	printf("-p, --print-topology	Print the device topology. If an entity\n");
+	printf("			is specified through the -e option, print\n");
+	printf("			information for that entity only.\n);
 	printf("    --print-dot		Print the device topology as a dot graph\n");
 	printf("-r, --reset		Reset all links to inactive\n");
 	printf("-v, --verbose		Be verbose\n");
-- 
2.7.4

