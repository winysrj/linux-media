Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43302 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab3KENDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:51 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sean Young <sean@mess.org>
Subject: [PATCH v3 06/29] [media] iguanair: simplify calculation of carrier delay cycles
Date: Tue,  5 Nov 2013 08:01:19 -0200
Message-Id: <1383645702-30636-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sean Young <sean@mess.org>

Simplify the logic that calculates the carrier, and removes a warning
on avr32 arch:
	drivers/media/rc/iguanair.c: In function 'iguanair_set_tx_carrier':
	drivers/media/rc/iguanair.c:304: warning: 'sevens' may be used uninitialized in this function

Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/rc/iguanair.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 19632b1c2190..7f05e197680b 100644
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

