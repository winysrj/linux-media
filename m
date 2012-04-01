Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:40791 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2DAPyD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 11:54:03 -0400
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Cc: "Steinar H. Gunderson" <sesse@samfundet.no>
Subject: [PATCH 01/11] Don't reset IRQ0 if it's not already set.
Date: Sun,  1 Apr 2012 17:53:41 +0200
Message-Id: <1333295631-31866-1-git-send-email-sgunderson@bigfoot.com>
In-Reply-To: <20120401155330.GA31901@uio.no>
References: <20120401155330.GA31901@uio.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Steinar H. Gunderson" <sesse@samfundet.no>

By Marko Ristola; see http://patchwork.linuxtv.org/patch/8776/ .

Signed-off-by: Steinar H. Gunderson <sesse@samfundet.no>
---
 drivers/media/dvb/mantis/mantis_cards.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/dvb/mantis/mantis_cards.c
index c2bb90b..c6c51bd 100644
--- a/drivers/media/dvb/mantis/mantis_cards.c
+++ b/drivers/media/dvb/mantis/mantis_cards.c
@@ -73,7 +73,7 @@ static char *label[10] = {
 
 static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
 {
-	u32 stat = 0, mask = 0, lstat = 0;
+	u32 stat = 0, mask = 0;
 	u32 rst_stat = 0, rst_mask = 0;
 
 	struct mantis_pci *mantis;
@@ -88,19 +88,9 @@ static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
 
 	stat = mmread(MANTIS_INT_STAT);
 	mask = mmread(MANTIS_INT_MASK);
-	lstat = stat & ~MANTIS_INT_RISCSTAT;
 	if (!(stat & mask))
 		return IRQ_NONE;
 
-	rst_mask  = MANTIS_GPIF_WRACK  |
-		    MANTIS_GPIF_OTHERR |
-		    MANTIS_SBUF_WSTO   |
-		    MANTIS_GPIF_EXTIRQ;
-
-	rst_stat  = mmread(MANTIS_GPIF_STATUS);
-	rst_stat &= rst_mask;
-	mmwrite(rst_stat, MANTIS_GPIF_STATUS);
-
 	mantis->mantis_int_stat = stat;
 	mantis->mantis_int_mask = mask;
 	dprintk(MANTIS_DEBUG, 0, "\n-- Stat=<%02x> Mask=<%02x> --", stat, mask);
@@ -109,6 +99,15 @@ static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
 	}
 	if (stat & MANTIS_INT_IRQ0) {
 		dprintk(MANTIS_DEBUG, 0, "<%s>", label[1]);
+
+		rst_mask  = MANTIS_GPIF_WRACK  |
+			MANTIS_GPIF_OTHERR |
+			MANTIS_SBUF_WSTO   |
+			MANTIS_GPIF_EXTIRQ;
+
+		rst_stat  = mmread(MANTIS_GPIF_STATUS);
+		mmwrite(rst_stat & rst_mask, MANTIS_GPIF_STATUS);
+
 		mantis->gpif_status = rst_stat;
 		wake_up(&ca->hif_write_wq);
 		schedule_work(&ca->hif_evm_work);
-- 
1.7.9.5

