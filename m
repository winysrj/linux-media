Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:42226 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbbALXXe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 18:23:34 -0500
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] mn88473: simplify bandwidth registers setting code
Date: Tue, 13 Jan 2015 00:23:26 +0100
Message-Id: <1421105006-22437-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1421105006-22437-1-git-send-email-benjamin@southpole.se>
References: <1421105006-22437-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88473/mn88473.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/media/mn88473/mn88473.c b/drivers/staging/media/mn88473/mn88473.c
index b65e519..994294c 100644
--- a/drivers/staging/media/mn88473/mn88473.c
+++ b/drivers/staging/media/mn88473/mn88473.c
@@ -59,28 +59,13 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	switch (c->delivery_system) {
-	case SYS_DVBT:
-	case SYS_DVBT2:
-		if (c->bandwidth_hz <= 6000000) {
-			/* IF 3570000 Hz, BW 6000000 Hz */
-			memcpy(bw_val, "\xe9\x55\x55\x1c\x29\x1c\x29", 7);
-		} else if (c->bandwidth_hz <= 7000000) {
-			/* IF 4570000 Hz, BW 7000000 Hz */
-			memcpy(bw_val, "\xc8\x00\x00\x17\x0a\x17\x0a", 7);
-		} else if (c->bandwidth_hz <= 8000000) {
-			/* IF 4570000 Hz, BW 8000000 Hz */
-			memcpy(bw_val, "\xaf\x00\x00\x11\xec\x11\xec", 7);
-		} else {
-			ret = -EINVAL;
-			goto err;
-		}
-		break;
-	case SYS_DVBC_ANNEX_A:
-		/* IF 5070000 Hz, BW 8000000 Hz */
+	if (c->bandwidth_hz <= 6000000) {
+		memcpy(bw_val, "\xe9\x55\x55\x1c\x29\x1c\x29", 7);
+	} else if (c->bandwidth_hz <= 7000000) {
+		memcpy(bw_val, "\xc8\x00\x00\x17\x0a\x17\x0a", 7);
+	} else if (c->bandwidth_hz <= 8000000) {
 		memcpy(bw_val, "\xaf\x00\x00\x11\xec\x11\xec", 7);
-		break;
-	default:
+	} else {
 		ret = -EINVAL;
 		goto err;
 	}
-- 
2.1.0

