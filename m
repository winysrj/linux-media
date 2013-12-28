Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:46376 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab3L1Pq1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 10:46:27 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so4475678eaj.29
        for <linux-media@vger.kernel.org>; Sat, 28 Dec 2013 07:46:26 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 10/13] libdvbv5: cleanup coding style
Date: Sat, 28 Dec 2013 16:45:58 +0100
Message-Id: <1388245561-8751-10-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
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
index 6df8b8b..b5bc9b2 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -1358,6 +1358,6 @@ void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned c
 		for (i = strlen(hex); i < 49; i++)
 			strncat(spaces, " ", sizeof(spaces));
 		ascii[j] = '\0';
-		dvb_log("%s %s %s %s", prefix, hex, spaces, ascii);
+		dvb_log("%s%s %s %s", prefix, hex, spaces, ascii);
 	}
 }
diff --git a/lib/libdvbv5/descriptors/mpeg_pes.c b/lib/libdvbv5/descriptors/mpeg_pes.c
index c717297..0f0cde0 100644
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

