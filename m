Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39877 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab3EHN2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 09:28:06 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/2] Print parser position on error
Date: Wed,  8 May 2013 15:27:54 +0200
Message-Id: <1368019674-25761-3-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1368019674-25761-1-git-send-email-s.hauer@pengutronix.de>
References: <1368019674-25761-1-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most parser functions take a **endp argument to indicate the caller
where parsing has stopped. This is currently only used after parsing
something successfully. This patch sets **endp to the erroneous
position in the error case and prints its position after an error
has occured.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 src/mediactl.c | 48 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/src/mediactl.c b/src/mediactl.c
index c65de50..04ade15 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -40,6 +40,22 @@
 #include "mediactl.h"
 #include "tools.h"
 
+void media_print_streampos(struct media_device *media, const char *p, const char *end)
+{
+	int pos;
+
+	pos = end - p + 1;
+
+	if (pos < 0)
+		pos = 0;
+	if (pos > strlen(p))
+		pos = strlen(p);
+
+	media_dbg(media, "\n");
+	media_dbg(media, " %s\n", p);
+	media_dbg(media, " %*s\n", pos, "^");
+}
+
 struct media_pad *media_entity_remote_source(struct media_pad *pad)
 {
 	unsigned int i;
@@ -538,12 +554,16 @@ struct media_pad *media_parse_pad(struct media_device *media,
 	if (*p == '"') {
 		for (end = (char *)p + 1; *end && *end != '"'; ++end);
 		if (*end != '"') {
+			if (endp)
+				*endp = (char *)end;
 			media_dbg(media, "missing matching '\"'\n");
 			return NULL;
 		}
 
 		entity = media_get_entity_by_name(media, p + 1, end - p - 1);
 		if (entity == NULL) {
+			if (endp)
+				*endp = (char *)p + 1;
 			media_dbg(media, "no such entity \"%.*s\"\n", end - p - 1, p + 1);
 			return NULL;
 		}
@@ -553,6 +573,8 @@ struct media_pad *media_parse_pad(struct media_device *media,
 		entity_id = strtoul(p, &end, 10);
 		entity = media_get_entity_by_id(media, entity_id);
 		if (entity == NULL) {
+			if (endp)
+				*endp = (char *)p;
 			media_dbg(media, "no such entity %d\n", entity_id);
 			return NULL;
 		}
@@ -560,6 +582,8 @@ struct media_pad *media_parse_pad(struct media_device *media,
 	for (; isspace(*end); ++end);
 
 	if (*end != ':') {
+		if (endp)
+			*endp = end;
 		media_dbg(media, "Expected ':'\n", *end);
 		return NULL;
 	}
@@ -569,6 +593,8 @@ struct media_pad *media_parse_pad(struct media_device *media,
 	pad = strtoul(p, &end, 10);
 
 	if (pad >= entity->info.pads) {
+		if (endp)
+			*endp = (char *)p;
 		media_dbg(media, "No pad '%d' on entity \"%s\". Maximum pad number is %d\n",
 				pad, entity->info.name, entity->info.pads - 1);
 		return NULL;
@@ -591,10 +617,15 @@ struct media_link *media_parse_link(struct media_device *media,
 	char *end;
 
 	source = media_parse_pad(media, p, &end);
-	if (source == NULL)
+	if (source == NULL) {
+		if (endp)
+			*endp = end;
 		return NULL;
+	}
 
 	if (end[0] != '-' || end[1] != '>') {
+		if (endp)
+			*endp = end;
 		media_dbg(media, "Expected '->'\n");
 		return NULL;
 	}
@@ -602,8 +633,11 @@ struct media_link *media_parse_link(struct media_device *media,
 	p = end + 2;
 
 	sink = media_parse_pad(media, p, &end);
-	if (sink == NULL)
+	if (sink == NULL) {
+		if (endp)
+			*endp = end;
 		return NULL;
+	}
 
 	*endp = end;
 
@@ -629,6 +663,8 @@ int media_parse_setup_link(struct media_device *media,
 
 	link = media_parse_link(media, p, &end);
 	if (link == NULL) {
+		if (endp)
+			*endp = end;
 		media_dbg(media,
 			  "%s: Unable to parse link\n", __func__);
 		return -EINVAL;
@@ -636,6 +672,8 @@ int media_parse_setup_link(struct media_device *media,
 
 	p = end;
 	if (*p++ != '[') {
+		if (endp)
+			*endp = (char *)p - 1;
 		media_dbg(media, "Unable to parse link flags: expected '['.\n");
 		return -EINVAL;
 	}
@@ -643,6 +681,8 @@ int media_parse_setup_link(struct media_device *media,
 	flags = strtoul(p, &end, 10);
 	for (p = end; isspace(*p); p++);
 	if (*p++ != ']') {
+		if (endp)
+			*endp = (char *)p - 1;
 		media_dbg(media, "Unable to parse link flags: expected ']'.\n");
 		return -EINVAL;
 	}
@@ -666,8 +706,10 @@ int media_parse_setup_links(struct media_device *media, const char *p)
 
 	do {
 		ret = media_parse_setup_link(media, p, &end);
-		if (ret < 0)
+		if (ret < 0) {
+			media_print_streampos(media, p, end);
 			return ret;
+		}
 
 		p = end + 1;
 	} while (*end == ',');
-- 
1.8.2.rc2

