Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20710 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755463AbcIMI31 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 04:29:27 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [v4l-utils PATCH 1/2] media-ctl: Split off printing information related to a single entity
Date: Tue, 13 Sep 2016 11:28:15 +0300
Message-Id: <1473755296-14109-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473755296-14109-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473755296-14109-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As a result, a function that can be used to print information on a given
entity only is provided.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/media-ctl.c | 93 ++++++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 44 deletions(-)

diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
index 2f049c6..0499008 100644
--- a/utils/media-ctl/media-ctl.c
+++ b/utils/media-ctl/media-ctl.c
@@ -436,67 +436,72 @@ static void media_print_pad_text(struct media_entity *entity,
 		v4l2_subdev_print_subdev_dv(entity);
 }
 
-static void media_print_topology_text(struct media_device *media)
+static void media_print_topology_text_entity(struct media_device *media,
+					     struct media_entity *entity)
 {
 	static const struct flag_name link_flags[] = {
 		{ MEDIA_LNK_FL_ENABLED, "ENABLED" },
 		{ MEDIA_LNK_FL_IMMUTABLE, "IMMUTABLE" },
 		{ MEDIA_LNK_FL_DYNAMIC, "DYNAMIC" },
 	};
-
-	unsigned int nents = media_get_entities_count(media);
-	unsigned int i, j, k;
+	const struct media_entity_desc *info = media_entity_get_info(entity);
+	const char *devname = media_entity_get_devname(entity);
+	unsigned int num_links = media_entity_get_links_count(entity);
+	unsigned int j, k;
 	unsigned int padding;
 
-	printf("Device topology\n");
-
-	for (i = 0; i < nents; ++i) {
-		struct media_entity *entity = media_get_entity(media, i);
-		const struct media_entity_desc *info = media_entity_get_info(entity);
-		const char *devname = media_entity_get_devname(entity);
-		unsigned int num_links = media_entity_get_links_count(entity);
-
-		padding = printf("- entity %u: ", info->id);
-		printf("%s (%u pad%s, %u link%s)\n", info->name,
-			info->pads, info->pads > 1 ? "s" : "",
-			num_links, num_links > 1 ? "s" : "");
-		printf("%*ctype %s subtype %s flags %x\n", padding, ' ',
-			media_entity_type_to_string(info->type),
-			media_entity_subtype_to_string(info->type),
-			info->flags);
-		if (devname)
-			printf("%*cdevice node name %s\n", padding, ' ', devname);
+	padding = printf("- entity %u: ", info->id);
+	printf("%s (%u pad%s, %u link%s)\n", info->name,
+	       info->pads, info->pads > 1 ? "s" : "",
+	       num_links, num_links > 1 ? "s" : "");
+	printf("%*ctype %s subtype %s flags %x\n", padding, ' ',
+	       media_entity_type_to_string(info->type),
+	       media_entity_subtype_to_string(info->type),
+	       info->flags);
+	if (devname)
+		printf("%*cdevice node name %s\n", padding, ' ', devname);
 
-		for (j = 0; j < info->pads; j++) {
-			const struct media_pad *pad = media_entity_get_pad(entity, j);
+	for (j = 0; j < info->pads; j++) {
+		const struct media_pad *pad = media_entity_get_pad(entity, j);
 
-			printf("\tpad%u: %s\n", j, media_pad_type_to_string(pad->flags));
+		printf("\tpad%u: %s\n", j, media_pad_type_to_string(pad->flags));
 
-			media_print_pad_text(entity, pad);
+		media_print_pad_text(entity, pad);
 
-			for (k = 0; k < num_links; k++) {
-				const struct media_link *link = media_entity_get_link(entity, k);
-				const struct media_pad *source = link->source;
-				const struct media_pad *sink = link->sink;
+		for (k = 0; k < num_links; k++) {
+			const struct media_link *link = media_entity_get_link(entity, k);
+			const struct media_pad *source = link->source;
+			const struct media_pad *sink = link->sink;
 
-				if (source->entity == entity && source->index == j)
-					printf("\t\t-> \"%s\":%u [",
-						media_entity_get_info(sink->entity)->name,
-						sink->index);
-				else if (sink->entity == entity && sink->index == j)
-					printf("\t\t<- \"%s\":%u [",
-						media_entity_get_info(source->entity)->name,
-						source->index);
-				else
-					continue;
+			if (source->entity == entity && source->index == j)
+				printf("\t\t-> \"%s\":%u [",
+				       media_entity_get_info(sink->entity)->name,
+				       sink->index);
+			else if (sink->entity == entity && sink->index == j)
+				printf("\t\t<- \"%s\":%u [",
+				       media_entity_get_info(source->entity)->name,
+				       source->index);
+			else
+				continue;
 
-				print_flags(link_flags, ARRAY_SIZE(link_flags), link->flags);
+			print_flags(link_flags, ARRAY_SIZE(link_flags), link->flags);
 
-				printf("]\n");
-			}
+			printf("]\n");
 		}
-		printf("\n");
 	}
+	printf("\n");
+}
+
+static void media_print_topology_text(struct media_device *media)
+{
+	unsigned int nents = media_get_entities_count(media);
+	unsigned int i;
+
+	printf("Device topology\n");
+
+	for (i = 0; i < nents; ++i)
+		media_print_topology_text_entity(
+			media, media_get_entity(media, i));
 }
 
 void media_print_topology(struct media_device *media, int dot)
-- 
2.7.4

