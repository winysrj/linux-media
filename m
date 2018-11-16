Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:52985 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727567AbeKPT7h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 14:59:37 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils] keytable: match every entry in rc_maps.cfg, not just the first
Date: Fri, 16 Nov 2018 09:48:02 +0000
Message-Id: <20181116094802.18500-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/keytable.c | 71 ++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 35 deletions(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index e15440de..df9cfc49 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -634,14 +634,13 @@ static error_t parse_keyfile(char *fname, char **table)
 		return parse_plain_keyfile(fname, table);
 }
 
-struct cfgfile *nextcfg = &cfg;
-
 static error_t parse_cfgfile(char *fname)
 {
 	FILE *fin;
 	int line = 0;
 	char s[2048];
 	char *driver, *table, *filename;
+	struct cfgfile *nextcfg = &cfg;
 
 	if (debug)
 		fprintf(stderr, _("Parsing %s config file\n"), fname);
@@ -2142,55 +2141,57 @@ int main(int argc, char *argv[])
 		struct cfgfile *cur;
 		char *fname, *name;
 		int rc;
+		int matches = 0;
 
 		for (cur = &cfg; cur->next; cur = cur->next) {
 			if ((!rc_dev.drv_name || strcasecmp(cur->driver, rc_dev.drv_name)) && strcasecmp(cur->driver, "*"))
 				continue;
 			if ((!rc_dev.keytable_name || strcasecmp(cur->table, rc_dev.keytable_name)) && strcasecmp(cur->table, "*"))
 				continue;
-			break;
-		}
 
-		if (!cur->next) {
 			if (debug)
-				fprintf(stderr, _("Table for %s, %s not found. Keep as-is\n"),
-				       rc_dev.drv_name, rc_dev.keytable_name);
-			return 0;
-		}
-		if (debug)
-			fprintf(stderr, _("Table for %s, %s is on %s file.\n"),
-				rc_dev.drv_name, rc_dev.keytable_name,
-				cur->fname);
-		if (cur->fname[0] == '/' || ((cur->fname[0] == '.') && strchr(cur->fname, '/'))) {
-			fname = cur->fname;
-			rc = parse_keyfile(fname, &name);
-			if (rc < 0) {
-				fprintf(stderr, _("Can't load %s table\n"), fname);
-				return -1;
-			}
-		} else {
-			fname = malloc(strlen(cur->fname) + strlen(IR_KEYTABLE_USER_DIR) + 2);
-			strcpy(fname, IR_KEYTABLE_USER_DIR);
-			strcat(fname, "/");
-			strcat(fname, cur->fname);
-			rc = parse_keyfile(fname, &name);
-			if (rc != 0) {
-				fname = malloc(strlen(cur->fname) + strlen(IR_KEYTABLE_SYSTEM_DIR) + 2);
-				strcpy(fname, IR_KEYTABLE_SYSTEM_DIR);
+				fprintf(stderr, _("Table for %s, %s is on %s file.\n"),
+					rc_dev.drv_name, rc_dev.keytable_name,
+					cur->fname);
+			if (cur->fname[0] == '/' || ((cur->fname[0] == '.') && strchr(cur->fname, '/'))) {
+				fname = cur->fname;
+				rc = parse_keyfile(fname, &name);
+				if (rc < 0) {
+					fprintf(stderr, _("Can't load %s table\n"), fname);
+					return -1;
+				}
+			} else {
+				fname = malloc(strlen(cur->fname) + strlen(IR_KEYTABLE_USER_DIR) + 2);
+				strcpy(fname, IR_KEYTABLE_USER_DIR);
 				strcat(fname, "/");
 				strcat(fname, cur->fname);
 				rc = parse_keyfile(fname, &name);
+				if (rc != 0) {
+					fname = malloc(strlen(cur->fname) + strlen(IR_KEYTABLE_SYSTEM_DIR) + 2);
+					strcpy(fname, IR_KEYTABLE_SYSTEM_DIR);
+					strcat(fname, "/");
+					strcat(fname, cur->fname);
+					rc = parse_keyfile(fname, &name);
+				}
+				if (rc != 0) {
+					fprintf(stderr, _("Can't load %s table from %s or %s\n"), cur->fname, IR_KEYTABLE_USER_DIR, IR_KEYTABLE_SYSTEM_DIR);
+					return -1;
+				}
 			}
-			if (rc != 0) {
-				fprintf(stderr, _("Can't load %s table from %s or %s\n"), cur->fname, IR_KEYTABLE_USER_DIR, IR_KEYTABLE_SYSTEM_DIR);
+			if (!keytable) {
+				fprintf(stderr, _("Empty table %s\n"), fname);
 				return -1;
 			}
+			clear = 1;
+			matches++;
 		}
-		if (!keytable) {
-			fprintf(stderr, _("Empty table %s\n"), fname);
-			return -1;
+
+		if (!matches) {
+			if (debug)
+				fprintf(stderr, _("Table for %s, %s not found. Keep as-is\n"),
+				       rc_dev.drv_name, rc_dev.keytable_name);
+			return 0;
 		}
-		clear = 1;
 	}
 
 	if (debug)
-- 
2.19.1
