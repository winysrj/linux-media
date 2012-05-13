Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:45154 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2EMMSM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 08:18:12 -0400
Received: by weyu7 with SMTP id u7so1236697wey.19
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 05:18:11 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 1/8] workaround fix for segfault with CHANNEL file
Date: Sun, 13 May 2012 14:17:23 +0200
Message-Id: <1336911450-23661-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 utils/dvb/dvb-file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/utils/dvb/dvb-file.c b/utils/dvb/dvb-file.c
index eb269b4..e1f2195 100644
--- a/utils/dvb/dvb-file.c
+++ b/utils/dvb/dvb-file.c
@@ -141,7 +141,7 @@ struct dvb_file *parse_format_oneline(const char *fname,
 			}
 			if (table->size) {
 				for (j = 0; j < table->size; j++)
-					if (!strcasecmp(table->table[j], p))
+					if (!table->table[j] || !strcasecmp(table->table[j], p))
 						break;
 				if (j == table->size) {
 					sprintf(err_msg, "parameter %s invalid: %s",
-- 
1.7.2.5

