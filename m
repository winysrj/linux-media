Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39873 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3EHN16 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 09:27:58 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/2] Print more detailed parse error messages
Date: Wed,  8 May 2013 15:27:53 +0200
Message-Id: <1368019674-25761-2-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1368019674-25761-1-git-send-email-s.hauer@pengutronix.de>
References: <1368019674-25761-1-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following errors usually resulted in the same 'Unable to parse link'
message:

- one of the given entities does not exist
- one of the pads of a given entity does not exist
- No link exists between given pads
- syntax error in link description

Add more detailed error messages to give the user a clue what is going wrong.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 src/mediactl.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/src/mediactl.c b/src/mediactl.c
index 4783a58..c65de50 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -537,31 +537,42 @@ struct media_pad *media_parse_pad(struct media_device *media,
 
 	if (*p == '"') {
 		for (end = (char *)p + 1; *end && *end != '"'; ++end);
-		if (*end != '"')
+		if (*end != '"') {
+			media_dbg(media, "missing matching '\"'\n");
 			return NULL;
+		}
 
 		entity = media_get_entity_by_name(media, p + 1, end - p - 1);
-		if (entity == NULL)
+		if (entity == NULL) {
+			media_dbg(media, "no such entity \"%.*s\"\n", end - p - 1, p + 1);
 			return NULL;
+		}
 
 		++end;
 	} else {
 		entity_id = strtoul(p, &end, 10);
 		entity = media_get_entity_by_id(media, entity_id);
-		if (entity == NULL)
+		if (entity == NULL) {
+			media_dbg(media, "no such entity %d\n", entity_id);
 			return NULL;
+		}
 	}
 	for (; isspace(*end); ++end);
 
-	if (*end != ':')
+	if (*end != ':') {
+		media_dbg(media, "Expected ':'\n", *end);
 		return NULL;
+	}
+
 	for (p = end + 1; isspace(*p); ++p);
 
 	pad = strtoul(p, &end, 10);
-	for (p = end; isspace(*p); ++p);
 
-	if (pad >= entity->info.pads)
+	if (pad >= entity->info.pads) {
+		media_dbg(media, "No pad '%d' on entity \"%s\". Maximum pad number is %d\n",
+				pad, entity->info.name, entity->info.pads - 1);
 		return NULL;
+	}
 
 	for (p = end; isspace(*p); ++p);
 	if (endp)
@@ -583,8 +594,11 @@ struct media_link *media_parse_link(struct media_device *media,
 	if (source == NULL)
 		return NULL;
 
-	if (end[0] != '-' || end[1] != '>')
+	if (end[0] != '-' || end[1] != '>') {
+		media_dbg(media, "Expected '->'\n");
 		return NULL;
+	}
+
 	p = end + 2;
 
 	sink = media_parse_pad(media, p, &end);
@@ -600,6 +614,9 @@ struct media_link *media_parse_link(struct media_device *media,
 			return link;
 	}
 
+	media_dbg(media, "No link between \"%s\":%d and \"%s\":%d\n",
+			source->entity->info.name, source->index,
+			sink->entity->info.name, sink->index);
 	return NULL;
 }
 
@@ -619,14 +636,14 @@ int media_parse_setup_link(struct media_device *media,
 
 	p = end;
 	if (*p++ != '[') {
-		media_dbg(media, "Unable to parse link flags\n");
+		media_dbg(media, "Unable to parse link flags: expected '['.\n");
 		return -EINVAL;
 	}
 
 	flags = strtoul(p, &end, 10);
 	for (p = end; isspace(*p); p++);
 	if (*p++ != ']') {
-		media_dbg(media, "Unable to parse link flags\n");
+		media_dbg(media, "Unable to parse link flags: expected ']'.\n");
 		return -EINVAL;
 	}
 
-- 
1.8.2.rc2

