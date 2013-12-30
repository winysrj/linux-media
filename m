Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:49092 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3L3Mtc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 07:49:32 -0500
Received: by mail-ee0-f49.google.com with SMTP id c41so5057096eek.36
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 04:49:31 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 11/18] libdvbv5: cleanup coding style
Date: Mon, 30 Dec 2013 13:48:44 +0100
Message-Id: <1388407731-24369-11-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/descriptors.c          | 2 +-
 lib/libdvbv5/descriptors/mpeg_pes.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 226349e..f46aa4a 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -1359,6 +1359,6 @@ void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned c
 		for (i = strlen(hex); i < 49; i++)
 			strncat(spaces, " ", sizeof(spaces));
 		ascii[j] = '\0';
-		dvb_log("%s %s %s %s", prefix, hex, spaces, ascii);
+		dvb_log("%s%s %s %s", prefix, hex, spaces, ascii);
 	}
 }
diff --git a/lib/libdvbv5/descriptors/mpeg_pes.c b/lib/libdvbv5/descriptors/mpeg_pes.c
index 1b518a3..98364a3 100644
--- a/lib/libdvbv5/descriptors/mpeg_pes.c
+++ b/lib/libdvbv5/descriptors/mpeg_pes.c
@@ -33,7 +33,7 @@ void dvb_mpeg_pes_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_
 	bswap32(pes->bitfield);
 	bswap16(pes->length);
 
-	if (pes->sync != 0x000001 ) {
+	if (pes->sync != 0x000001) {
 		dvb_logerr("mpeg pes invalid");
 		return;
 	}
-- 
1.8.3.2

