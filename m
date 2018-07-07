Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f46.google.com ([209.85.208.46]:39228 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753552AbeGGLVK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2018 07:21:10 -0400
Received: by mail-ed1-f46.google.com with SMTP id w14-v6so10451465eds.6
        for <linux-media@vger.kernel.org>; Sat, 07 Jul 2018 04:21:09 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 3/4] libdvbv5: fix parsing EIT extended event descriptor
Date: Sat,  7 Jul 2018 13:20:56 +0200
Message-Id: <20180707112057.7235-3-neolynx@gmail.com>
In-Reply-To: <20180707112057.7235-1-neolynx@gmail.com>
References: <20180707112057.7235-1-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

correctly parse, print and free the extended event descriptor list
of description/item pairs.

also fixes a typo in short event descriptor.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/desc_event_extended.h     |  9 +++
 lib/libdvbv5/descriptors/desc_event_extended.c | 83 ++++++++++++++++++++------
 lib/libdvbv5/descriptors/desc_event_short.c    |  2 +-
 3 files changed, 74 insertions(+), 20 deletions(-)

diff --git a/lib/include/libdvbv5/desc_event_extended.h b/lib/include/libdvbv5/desc_event_extended.h
index 7e6ac9cd..46ef3276 100644
--- a/lib/include/libdvbv5/desc_event_extended.h
+++ b/lib/include/libdvbv5/desc_event_extended.h
@@ -39,6 +39,12 @@
 
 #include <libdvbv5/descriptors.h>
 
+struct dvb_desc_event_extended_item {
+	char *description;
+	char *description_emph;
+	char *item;
+	char *item_emph;
+};
 
 /**
  * @struct dvb_desc_event_extended
@@ -58,6 +64,7 @@
  * The emphasis text is the one that uses asterisks. For example, in the text:
  *	"the quick *fox* jumps over the lazy table" the emphasis would be "fox".
  */
+
 struct dvb_desc_event_extended {
 	uint8_t type;
 	uint8_t length;
@@ -74,6 +81,8 @@ struct dvb_desc_event_extended {
 	unsigned char language[4];
 	char *text;
 	char *text_emph;
+	struct dvb_desc_event_extended_item *items;
+	int num_items;
 } __attribute__((packed));
 
 struct dvb_v5_fe_parms;
diff --git a/lib/libdvbv5/descriptors/desc_event_extended.c b/lib/libdvbv5/descriptors/desc_event_extended.c
index 200657ad..624ac01c 100644
--- a/lib/libdvbv5/descriptors/desc_event_extended.c
+++ b/lib/libdvbv5/descriptors/desc_event_extended.c
@@ -22,57 +22,102 @@
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
 
+#ifdef ENABLE_NLS
+# include "gettext.h"
+# include <libintl.h>
+# define _(string) dgettext(LIBDVBV5_DOMAIN, string)
+#else
+# define _(string) string
+#endif
+
 int dvb_desc_event_extended_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_event_extended *event = (struct dvb_desc_event_extended *) desc;
-	uint8_t len;  /* the length of the string in the input data */
-	uint8_t len1; /* the lenght of the output strings */
-
-	/*dvb_hexdump(parms, "event extended desc: ", buf - 2, desc->length + 2);*/
+	uint8_t len, size_items;
+	const uint8_t *buf_start;
+	int first = 1;
+	struct dvb_desc_event_extended_item *item;
 
 	event->ids = buf[0];
+
 	event->language[0] = buf[1];
 	event->language[1] = buf[2];
 	event->language[2] = buf[3];
 	event->language[3] = '\0';
 
-	uint8_t items = buf[4];
+	size_items = buf[4];
 	buf += 5;
 
-	int i;
-	for (i = 0; i < items; i++) {
-		dvb_logwarn("dvb_desc_event_extended: items not implemented");
-		uint8_t desc_len = *buf;
+	event->items = NULL;
+	event->num_items = 0;
+	buf_start = buf;
+	while (buf - buf_start < size_items) {
+		if (first) {
+			first = 0;
+			event->num_items = 1;
+			event->items = calloc(sizeof(struct dvb_desc_event_extended_item), event->num_items);
+			if (!event->items) {
+				dvb_logerr(_("%s: out of memory"), __func__);
+				return -1;
+			}
+			item = event->items;
+		} else {
+			event->num_items++;
+			event->items = realloc(event->items, sizeof(struct dvb_desc_event_extended_item) * (event->num_items));
+			item = event->items + (event->num_items - 1);
+		}
+		len = *buf;
 		buf++;
+		item->description = NULL;
+		item->description_emph = NULL;
+		dvb_parse_string(parms, &item->description, &item->description_emph, buf, len);
+		buf += len;
 
-		buf += desc_len;
-
-		uint8_t item_len = *buf;
+		len = *buf;
 		buf++;
-
-		buf += item_len;
+		item->item = NULL;
+		item->item_emph = NULL;
+		dvb_parse_string(parms, &item->item, &item->item_emph, buf, len);
+		buf += len;
 	}
 
-	event->text = NULL;
-	event->text_emph = NULL;
+
 	len = *buf;
-	len1 = len;
 	buf++;
-	dvb_parse_string(parms, &event->text, &event->text_emph, buf, len1);
-	buf += len;
+
+	if (len) {
+		event->text = NULL;
+		event->text_emph = NULL;
+		dvb_parse_string(parms, &event->text, &event->text_emph, buf, len);
+		buf += len;
+	}
+
 	return 0;
 }
 
 void dvb_desc_event_extended_free(struct dvb_desc *desc)
 {
 	struct dvb_desc_event_extended *event = (struct dvb_desc_event_extended *) desc;
+	int i;
 	free(event->text);
 	free(event->text_emph);
+	for (i = 0; i < event->num_items; i++) {
+		free(event->items[i].description);
+		free(event->items[i].description_emph);
+		free(event->items[i].item);
+		free(event->items[i].item_emph);
+	}
+	free(event->items);
 }
 
 void dvb_desc_event_extended_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_event_extended *event = (const struct dvb_desc_event_extended *) desc;
+	int i;
 	dvb_loginfo("|           '%s'", event->text);
+	for (i = 0; i < event->num_items; i++) {
+		dvb_loginfo("|              description   '%s'", event->items[i].description);
+		dvb_loginfo("|              item          '%s'", event->items[i].item);
+	}
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_event_short.c b/lib/libdvbv5/descriptors/desc_event_short.c
index 3bdcb89b..881e6d45 100644
--- a/lib/libdvbv5/descriptors/desc_event_short.c
+++ b/lib/libdvbv5/descriptors/desc_event_short.c
@@ -68,6 +68,6 @@ void dvb_desc_event_short_print(struct dvb_v5_fe_parms *parms, const struct dvb_
 	const struct dvb_desc_event_short *event = (const struct dvb_desc_event_short *) desc;
 	dvb_loginfo("|           name          '%s'", event->name);
 	dvb_loginfo("|           language      '%s'", event->language);
-	dvb_loginfo("|           sescription   '%s'", event->text);
+	dvb_loginfo("|           description   '%s'", event->text);
 }
 
-- 
2.14.1
