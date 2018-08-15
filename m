Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34883 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbeHONNy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 09:13:54 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] Remove unnecessary if
Date: Wed, 15 Aug 2018 11:22:18 +0100
Message-Id: <20180815102219.4587-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index 59555a13..ddd93068 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -175,19 +175,17 @@ static bool strtoscancode(const char *p, unsigned *ret)
 static unsigned parse_emitters(char *p)
 {
 	unsigned emit = 0;
-	const char *sep = " ,;:";
+	static const char *sep = " ,;:";
 	char *saveptr, *q;
 
 	q = strtok_r(p, sep, &saveptr);
 	while (q) {
-		if (*q) {
-			char *endptr;
-			long e = strtol(q, &endptr, 10);
-			if ((endptr && *endptr) || e <= 0 || e > 32)
-				return 0;
+		char *endptr;
+		long e = strtol(q, &endptr, 10);
+		if ((endptr && *endptr) || e <= 0 || e > 32)
+			return 0;
 
-			emit |= 1 << (e - 1);
-		}
+		emit |= 1 << (e - 1);
 		q = strtok_r(NULL, sep, &saveptr);
 	}
 
@@ -200,7 +198,7 @@ static struct file *read_file(struct arguments *args, const char *fname)
 	int lineno = 0, lastspace = 0;
 	char line[1024];
 	int len = 0;
-	const char *whitespace = " \n\r\t";
+	static const char *whitespace = " \n\r\t";
 	struct file *f;
 
 	FILE *input = fopen(fname, "r");
-- 
2.17.1
