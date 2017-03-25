Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:54631 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751286AbdCYMC6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Mar 2017 08:02:58 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/8] [media] staging: sir: use usleep_range() rather than busy looping
Date: Sat, 25 Mar 2017 12:02:22 +0000
Message-Id: <9a3863eae759ed3f4d97872b7063712552078e7e.1490443026.git.sean@mess.org>
In-Reply-To: <cover.1490443026.git.sean@mess.org>
References: <cover.1490443026.git.sean@mess.org>
In-Reply-To: <cover.1490443026.git.sean@mess.org>
References: <cover.1490443026.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usleep_range() is perfect for this.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/staging/media/lirc/lirc_sir.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 3a2bac9..9b09c25 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -90,21 +90,6 @@ static inline void soutp(int offset, int value)
 	outb(value, io + offset);
 }
 
-#ifndef MAX_UDELAY_MS
-#define MAX_UDELAY_US 5000
-#else
-#define MAX_UDELAY_US (MAX_UDELAY_MS * 1000)
-#endif
-
-static void safe_udelay(unsigned long usecs)
-{
-	while (usecs > MAX_UDELAY_US) {
-		udelay(MAX_UDELAY_US);
-		usecs -= MAX_UDELAY_US;
-	}
-	udelay(usecs);
-}
-
 /* SECTION: Communication with user-space */
 static int sir_tx_ir(struct rc_dev *dev, unsigned int *tx_buf,
 		     unsigned int count)
@@ -294,7 +279,7 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
 
 static void send_space(unsigned long len)
 {
-	safe_udelay(len);
+	usleep_range(len, len + 25);
 }
 
 static void send_pulse(unsigned long len)
-- 
2.9.3
