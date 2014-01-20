Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:42524 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbaATWKm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 17:10:42 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/4] [media] iguanair: simplify tx loop
Date: Mon, 20 Jan 2014 22:10:39 +0000
Message-Id: <1390255840-21786-2-git-send-email-sean@mess.org>
In-Reply-To: <1390255840-21786-1-git-send-email-sean@mess.org>
References: <1390255840-21786-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 99a3a5a..a83519a 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -364,20 +364,14 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 			rc = -EINVAL;
 			goto out;
 		}
-		while (periods > 127) {
-			ir->packet->payload[size++] = 127 | space;
-			periods -= 127;
+		while (periods) {
+			unsigned p = min(periods, 127u);
+			ir->packet->payload[size++] = p | space;
+			periods -= p;
 		}
-
-		ir->packet->payload[size++] = periods | space;
 		space ^= 0x80;
 	}
 
-	if (count == 0) {
-		rc = -EINVAL;
-		goto out;
-	}
-
 	ir->packet->header.start = 0;
 	ir->packet->header.direction = DIR_OUT;
 	ir->packet->header.cmd = CMD_SEND;
-- 
1.8.4.2

