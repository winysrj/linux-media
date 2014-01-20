Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:34052 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaATWKl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 17:10:41 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/4] [media] iguanair: explain tx carrier setup
Date: Mon, 20 Jan 2014 22:10:38 +0000
Message-Id: <1390255840-21786-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index fdae05c..99a3a5a 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -286,10 +286,10 @@ static int iguanair_receiver(struct iguanair *ir, bool enable)
 }
 
 /*
- * The iguana ir creates the carrier by busy spinning after each pulse or
- * space. This is counted in CPU cycles, with the CPU running at 24MHz. It is
+ * The iguanair creates the carrier by busy spinning after each half period.
+ * This is counted in CPU cycles, with the CPU running at 24MHz. It is
  * broken down into 7-cycles and 4-cyles delays, with a preference for
- * 4-cycle delays.
+ * 4-cycle delays, minus the overhead of the loop itself (cycle_overhead).
  */
 static int iguanair_set_tx_carrier(struct rc_dev *dev, uint32_t carrier)
 {
@@ -316,7 +316,14 @@ static int iguanair_set_tx_carrier(struct rc_dev *dev, uint32_t carrier)
 		sevens = (4 - cycles) & 3;
 		fours = (cycles - sevens * 7) / 4;
 
-		/* magic happens here */
+		/*
+		 * The firmware interprets these values as a relative offset
+		 * for a branch. Immediately following the branches, there
+		 * 4 instructions of 7 cycles (2 bytes each) and 110
+		 * instructions of 4 cycles (1 byte each). A relative branch
+		 * of 0 will execute all of them, branch further for less
+		 * cycle burning.
+		 */
 		ir->packet->busy7 = (4 - sevens) * 2;
 		ir->packet->busy4 = 110 - fours;
 	}
-- 
1.8.4.2

