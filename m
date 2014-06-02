Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41755 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaFBPJp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jun 2014 11:09:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] media-ctl: Move flags printing code to a new print_flags function
Date: Mon,  2 Jun 2014 17:10:03 +0200
Message-Id: <1401721804-30133-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401721804-30133-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401721804-30133-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will allow reusing the flag printing code for the DV timings flags.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 utils/media-ctl/media-ctl.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
index d48969f..44c9644 100644
--- a/utils/media-ctl/media-ctl.c
+++ b/utils/media-ctl/media-ctl.c
@@ -48,6 +48,33 @@
  * Printing
  */
 
+struct flag_name {
+	__u32 flag;
+	char *name;
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
 static void v4l2_subdev_print_format(struct media_entity *entity,
 	unsigned int pad, enum v4l2_subdev_format_whence which)
 {
@@ -255,10 +282,7 @@ static void media_print_topology_dot(struct media_device *media)
 
 static void media_print_topology_text(struct media_device *media)
 {
-	static const struct {
-		__u32 flag;
-		char *name;
-	} link_flags[] = {
+	static const struct flag_name link_flags[] = {
 		{ MEDIA_LNK_FL_ENABLED, "ENABLED" },
 		{ MEDIA_LNK_FL_IMMUTABLE, "IMMUTABLE" },
 		{ MEDIA_LNK_FL_DYNAMIC, "DYNAMIC" },
@@ -299,8 +323,6 @@ static void media_print_topology_text(struct media_device *media)
 				const struct media_link *link = media_entity_get_link(entity, k);
 				const struct media_pad *source = link->source;
 				const struct media_pad *sink = link->sink;
-				bool first = true;
-				unsigned int i;
 
 				if (source->entity == entity && source->index == j)
 					printf("\t\t-> \"%s\":%u [",
@@ -313,14 +335,7 @@ static void media_print_topology_text(struct media_device *media)
 				else
 					continue;
 
-				for (i = 0; i < ARRAY_SIZE(link_flags); i++) {
-					if (!(link->flags & link_flags[i].flag))
-						continue;
-					if (!first)
-						printf(",");
-					printf("%s", link_flags[i].name);
-					first = false;
-				}
+				print_flags(link_flags, ARRAY_SIZE(link_flags), link->flags);
 
 				printf("]\n");
 			}
-- 
1.8.5.5

