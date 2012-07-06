Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50302 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2GFTXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 15:23:54 -0400
Received: by werb14 with SMTP id b14so6568003wer.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 12:23:53 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 1/5] libdvbv5: Fix dvb-file USER CMD
Date: Fri,  6 Jul 2012 21:23:08 +0200
Message-Id: <1341602592-29508-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/dvb-file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index 5ab0d97..ea9caa0 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -387,7 +387,7 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
 			break;
 	}
 	if (i < ARRAY_SIZE(dvb_v5_name)) {
-		const char * const *attr_name = dvb_v5_attr_names[i];
+		const char * const *attr_name = dvb_attr_names(i);
 		n_prop = entry->n_props;
 		entry->props[n_prop].cmd = i;
 		if (!attr_name || !*attr_name)
@@ -412,7 +412,7 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
 			break;
 	}
 	if (i < ARRAY_SIZE(dvb_user_name)) {
-		const char * const *attr_name = dvb_user_attr_names[i];
+		const char * const *attr_name = dvb_attr_names(i);
 		n_prop = entry->n_props;
 		entry->props[n_prop].cmd = i + DTV_USER_COMMAND_START;
 		if (!attr_name || !*attr_name)
-- 
1.7.2.5

