Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:35267 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3F0VLq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 17:11:46 -0400
Received: by mail-ee0-f52.google.com with SMTP id c50so655808eek.25
        for <linux-media@vger.kernel.org>; Thu, 27 Jun 2013 14:11:45 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 2/2] keytable: Always check if strtok return value is null
Date: Thu, 27 Jun 2013 23:11:31 +0200
Message-Id: <1372367491-13187-3-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1372367491-13187-1-git-send-email-gjasny@googlemail.com>
References: <1372367491-13187-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Mayhem Team found a crash caused by a nullptr.
Details are here:
http://www.forallsecure.com/bug-reports/567323cd26f180910beb03ae26afb40c432a0c6a/

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 utils/keytable/keytable.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 06b3d95..8bcd5c4 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -207,13 +207,19 @@ static error_t parse_keyfile(char *fname, char **table)
 			p++;
 			p = strtok(p, "\n\t =:");
 			do {
+				if (!p)
+					goto err_einval;
 				if (!strcmp(p, "table")) {
 					p = strtok(NULL,"\n, ");
+					if (!p)
+						goto err_einval;
 					*table = malloc(strlen(p) + 1);
 					strcpy(*table, p);
 				} else if (!strcmp(p, "type")) {
 					p = strtok(NULL, " ,\n");
 					do {
+						if (!p)
+							goto err_einval;
 						if (!strcasecmp(p,"rc5") || !strcasecmp(p,"rc-5"))
 							ch_proto |= RC_5;
 						else if (!strcasecmp(p,"rc6") || !strcasecmp(p,"rc-6"))
@@ -447,6 +453,8 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 	case 'p':
 		p = strtok(arg, ",;");
 		do {
+			if (!p)
+				goto err_inval;
 			if (!strcasecmp(p,"rc5") || !strcasecmp(p,"rc-5"))
 				ch_proto |= RC_5;
 			else if (!strcasecmp(p,"rc6") || !strcasecmp(p,"rc-6"))
@@ -813,14 +821,19 @@ static int v1_get_sw_enabled_protocol(char *dirname)
 		return 0;
 	}
 
-	p = strtok(buf, " \n");
-	rc = atoi(p);
-
 	if (fclose(fp)) {
 		perror(name);
 		return errno;
 	}
 
+	p = strtok(buf, " \n");
+	if (!p) {
+		fprintf(stderr, "%s has invalid content: '%s'\n", name, buf);
+		return 0;
+	}
+
+	rc = atoi(p);
+
 	if (debug)
 		fprintf(stderr, "protocol %s is %s\n",
 			name, rc? "enabled" : "disabled");
-- 
1.8.3.1

