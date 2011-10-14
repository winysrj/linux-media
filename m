Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:54807 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab1JNQCf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 12:02:35 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 1/1] Several printout fixes.
Date: Fri, 14 Oct 2011 19:05:33 +0300
Message-Id: <1318608333-9136-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- There are sink and source pads, not input and output.
- Print also DYNAMIC flag.
- Don't print "pad" before pad number in some cases. The strings are more
  usable for link parsing now.
- Don't print extra commas afterlink flags.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/main.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/src/main.c b/src/main.c
index c04e12f..3c5fcb8 100644
--- a/src/main.c
+++ b/src/main.c
@@ -129,8 +129,8 @@ static const char *media_pad_type_to_string(unsigned flag)
 		__u32 flag;
 		const char *name;
 	} flags[] = {
-		{ MEDIA_PAD_FL_SINK, "Input" },
-		{ MEDIA_PAD_FL_SOURCE, "Output" },
+		{ MEDIA_PAD_FL_SINK, "Sink" },
+		{ MEDIA_PAD_FL_SOURCE, "Source" },
 	};
 
 	unsigned int i;
@@ -251,20 +251,33 @@ static void media_print_topology_text(struct media_device *media)
 				struct media_link *link = &entity->links[k];
 				struct media_pad *source = link->source;
 				struct media_pad *sink = link->sink;
+				int i, flags = link->flags;
+				struct {
+					int flag;
+					char *str;
+				} tbl[] = {
+					{ MEDIA_LNK_FL_ENABLED, "ENABLED" },
+					{ MEDIA_LNK_FL_IMMUTABLE, "IMMUTABLE" },
+					{ MEDIA_LNK_FL_DYNAMIC, "DYNAMIC" },
+				};
 
 				if (source->entity == entity && source->index == j)
-					printf("\t\t-> '%s':pad%u [",
+					printf("\t\t-> \"%s\":%u [",
 						sink->entity->info.name, sink->index);
 				else if (sink->entity == entity && sink->index == j)
-					printf("\t\t<- '%s':pad%u [",
+					printf("\t\t<- \"%s\":%u [",
 						source->entity->info.name, source->index);
 				else
 					continue;
 
-				if (link->flags & MEDIA_LNK_FL_IMMUTABLE)
-					printf("IMMUTABLE,");
-				if (link->flags & MEDIA_LNK_FL_ENABLED)
-					printf("ACTIVE");
+				for (i = 0; i < ARRAY_SIZE(tbl); i++) {
+					if (!(flags & tbl[i].flag))
+						continue;
+					if (link->flags != flags)
+						printf(",");
+					printf("%s", tbl[i].str);
+					flags &= ~tbl[i].flag;
+				}
 
 				printf("]\n");
 			}
-- 
1.7.2.5

