Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:42065 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab3KCWN7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Nov 2013 17:13:59 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] iguanair: simplify calculation of carrier delay cycles
Date: Sun,  3 Nov 2013 22:13:57 +0000
Message-Id: <1383516837-2433-1-git-send-email-sean@mess.org>
In-Reply-To: <20131103221004.GA2248@pequod.mess.org>
References: <20131103221004.GA2248@pequod.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 19632b1..7f05e19 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -308,22 +308,12 @@ static int iguanair_set_tx_carrier(struct rc_dev *dev, uint32_t carrier)
 		cycles = DIV_ROUND_CLOSEST(24000000, carrier * 2) -
 							ir->cycle_overhead;
 
-		/*  make up the the remainer of 4-cycle blocks */
-		switch (cycles & 3) {
-		case 0:
-			sevens = 0;
-			break;
-		case 1:
-			sevens = 3;
-			break;
-		case 2:
-			sevens = 2;
-			break;
-		case 3:
-			sevens = 1;
-			break;
-		}
-
+		/*
+		 * Calculate minimum number of 7 cycles needed so
+		 * we are left with a multiple of 4; so we want to have
+		 * (sevens * 7) & 3 == cycles & 3
+		 */
+		sevens = (4 - cycles) & 3;
 		fours = (cycles - sevens * 7) / 4;
 
 		/* magic happens here */
-- 
1.8.3.1

