Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:56304 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaLFV5d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Dec 2014 16:57:33 -0500
Received: from localhost.localdomain (92-244-23-216.customers.ownit.se [92.244.23.216])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id 54B1C48D5F
	for <linux-media@vger.kernel.org>; Sat,  6 Dec 2014 22:57:31 +0100 (CET)
From: Benjamin Larsson <benjamin@southpole.se>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] mn88472: add 5MHz dvb-t2 bandwitdh support
Date: Sat,  6 Dec 2014 22:57:31 +0100
Message-Id: <1417903051-22099-1-git-send-email-benjamin@southpole.se>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88472/mn88472.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index c6895ee..be8a6d5 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -61,7 +61,10 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 	switch (c->delivery_system) {
 	case SYS_DVBT:
 	case SYS_DVBT2:
-		if (c->bandwidth_hz <= 6000000) {
+		if (c->bandwidth_hz <= 5000000) {
+			memcpy(bw_val, "\xe5\x99\x9a\x1b\xa9\x1b\xa9", 7);
+			bw_val2 = 0x03;
+		} else if (c->bandwidth_hz <= 6000000) {
 			/* IF 3570000 Hz, BW 6000000 Hz */
 			memcpy(bw_val, "\xbf\x55\x55\x15\x6b\x15\x6b", 7);
 			bw_val2 = 0x02;
-- 
1.9.1

