Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:37976 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbbACAuv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 19:50:51 -0500
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] mn88472: simplify bandwidth registers setting code
Date: Sat,  3 Jan 2015 01:50:44 +0100
Message-Id: <1420246244-6031-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88472/mn88472.c | 41 +++++++++++----------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index 33604dc..ee933c3 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -58,35 +58,22 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	switch (c->delivery_system) {
-	case SYS_DVBT:
-	case SYS_DVBT2:
-		if (c->bandwidth_hz <= 5000000) {
-			memcpy(bw_val, "\xe5\x99\x9a\x1b\xa9\x1b\xa9", 7);
-			bw_val2 = 0x03;
-		} else if (c->bandwidth_hz <= 6000000) {
-			/* IF 3570000 Hz, BW 6000000 Hz */
-			memcpy(bw_val, "\xbf\x55\x55\x15\x6b\x15\x6b", 7);
-			bw_val2 = 0x02;
-		} else if (c->bandwidth_hz <= 7000000) {
-			/* IF 4570000 Hz, BW 7000000 Hz */
-			memcpy(bw_val, "\xa4\x00\x00\x0f\x2c\x0f\x2c", 7);
-			bw_val2 = 0x01;
-		} else if (c->bandwidth_hz <= 8000000) {
-			/* IF 4570000 Hz, BW 8000000 Hz */
-			memcpy(bw_val, "\x8f\x80\x00\x08\xee\x08\xee", 7);
-			bw_val2 = 0x00;
-		} else {
-			ret = -EINVAL;
-			goto err;
-		}
-		break;
-	case SYS_DVBC_ANNEX_A:
-		/* IF 5070000 Hz, BW 8000000 Hz */
+	if (c->bandwidth_hz <= 5000000) {
+		memcpy(bw_val, "\xe5\x99\x9a\x1b\xa9\x1b\xa9", 7);
+		bw_val2 = 0x03;
+	} else if (c->bandwidth_hz <= 6000000) {
+		/* IF 3570000 Hz, BW 6000000 Hz */
+		memcpy(bw_val, "\xbf\x55\x55\x15\x6b\x15\x6b", 7);
+		bw_val2 = 0x02;
+	} else if (c->bandwidth_hz <= 7000000) {
+		/* IF 4570000 Hz, BW 7000000 Hz */
+		memcpy(bw_val, "\xa4\x00\x00\x0f\x2c\x0f\x2c", 7);
+		bw_val2 = 0x01;
+	} else if (c->bandwidth_hz <= 8000000) {
+		/* IF 4570000 Hz, BW 8000000 Hz */
 		memcpy(bw_val, "\x8f\x80\x00\x08\xee\x08\xee", 7);
 		bw_val2 = 0x00;
-		break;
-	default:
+	} else {
 		ret = -EINVAL;
 		goto err;
 	}
-- 
1.9.1

