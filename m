Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:58778 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab1LNJqM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 04:46:12 -0500
Message-ID: <4EE8705F.30609@kolumbus.fi>
Date: Wed, 14 Dec 2011 11:46:07 +0200
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Manu Abraham <abraham.manu@gmail.com>
Subject: [PATCH] Mantis and Hopper: Fix CAM hangup caused by losing GPIF status
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Mantis and Hopper drivers: Fix CAM hangup problem,
where interrupt handler clears GPIF status, even though
GPIF interrupt isn't active.

Manuel  reported that this patch fixes his problem:
http://www.spinics.net/lists/linux-media/msg41473.html
(CAM hangs up about once per 20 minutes, each hangup takes about 3-5s.)

Signed-off-by: Marko Ristola <Marko.Ristola@kolumbus.fi>

diff --git a/drivers/media/dvb/mantis/hopper_cards.c b/drivers/media/dvb/mantis/hopper_cards.c
index 71622f6..c2084e9 100644
--- a/drivers/media/dvb/mantis/hopper_cards.c
+++ b/drivers/media/dvb/mantis/hopper_cards.c
@@ -84,15 +84,6 @@ static irqreturn_t hopper_irq_handler(int irq, void *dev_id)
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
@@ -101,6 +92,16 @@ static irqreturn_t hopper_irq_handler(int irq, void *dev_id)
  	}
  	if (stat & MANTIS_INT_IRQ0) {
  		dprintk(MANTIS_DEBUG, 0, "<%s>", label[1]);
+
+		rst_mask  = MANTIS_GPIF_WRACK  |
+			    MANTIS_GPIF_OTHERR |
+			    MANTIS_SBUF_WSTO   |
+			    MANTIS_GPIF_EXTIRQ;
+
+		rst_stat  = mmread(MANTIS_GPIF_STATUS);
+		rst_stat &= rst_mask;
+		mmwrite(rst_stat, MANTIS_GPIF_STATUS);
+
  		mantis->gpif_status = rst_stat;
  		wake_up(&ca->hif_write_wq);
  		schedule_work(&ca->hif_evm_work);
diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/dvb/mantis/mantis_cards.c
index c2bb90b..109a5fb 100644
--- a/drivers/media/dvb/mantis/mantis_cards.c
+++ b/drivers/media/dvb/mantis/mantis_cards.c
@@ -92,15 +92,6 @@ static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
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
@@ -109,6 +100,15 @@ static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
  	}
  	if (stat & MANTIS_INT_IRQ0) {
  		dprintk(MANTIS_DEBUG, 0, "<%s>", label[1]);
+		rst_mask  = MANTIS_GPIF_WRACK  |
+			    MANTIS_GPIF_OTHERR |
+			    MANTIS_SBUF_WSTO   |
+			    MANTIS_GPIF_EXTIRQ;
+
+		rst_stat  = mmread(MANTIS_GPIF_STATUS);
+		rst_stat &= rst_mask;
+		mmwrite(rst_stat, MANTIS_GPIF_STATUS);
+
  		mantis->gpif_status = rst_stat;
  		wake_up(&ca->hif_write_wq);
  		schedule_work(&ca->hif_evm_work);
