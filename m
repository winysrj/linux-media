Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754064AbdEGWE3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:04:29 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com, jasmin@anw.at
Subject: [PATCH 11/11] [media] dvb-core/dvb_ca_en50221.c: Fixed wrong EXPORT_SYMBOL order
Date: Sun,  7 May 2017 23:23:34 +0200
Message-Id: <1494192214-20082-12-git-send-email-jasmin@anw.at>
In-Reply-To: <1494192214-20082-1-git-send-email-jasmin@anw.at>
References: <1494192214-20082-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index ec9d63e..f4b87a0 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -922,7 +922,6 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 exitnowrite:
 	return status;
 }
-EXPORT_SYMBOL(dvb_ca_en50221_camchange_irq);
 
 
 
@@ -931,7 +930,7 @@ EXPORT_SYMBOL(dvb_ca_en50221_camchange_irq);
 
 
 /**
- * dvb_ca_en50221_camready_irq - A CAM has been removed => shut it down.
+ * dvb_ca_en50221_slot_shutdown - A CAM has been removed => shut it down.
  *
  * @ca: CA instance.
  * @slot: Slot to shut down.
@@ -953,11 +952,10 @@ static int dvb_ca_en50221_slot_shutdown(struct dvb_ca_private *ca, int slot)
 	/* success */
 	return 0;
 }
-EXPORT_SYMBOL(dvb_ca_en50221_camready_irq);
 
 
 /**
- * dvb_ca_en50221_camready_irq - A CAMCHANGE IRQ has occurred.
+ * dvb_ca_en50221_camchange_irq - A CAMCHANGE IRQ has occurred.
  *
  * @ca: CA instance.
  * @slot: Slot concerned.
@@ -984,7 +982,7 @@ void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221 *pubca, int slot,
 	atomic_inc(&sl->camchange_count);
 	dvb_ca_en50221_thread_wakeup(ca);
 }
-EXPORT_SYMBOL(dvb_ca_en50221_frda_irq);
+EXPORT_SYMBOL(dvb_ca_en50221_camchange_irq);
 
 
 /**
@@ -1005,10 +1003,11 @@ void dvb_ca_en50221_camready_irq(struct dvb_ca_en50221 *pubca, int slot)
 		dvb_ca_en50221_thread_wakeup(ca);
 	}
 }
+EXPORT_SYMBOL(dvb_ca_en50221_camready_irq);
 
 
 /**
- * An FR or DA IRQ has occurred.
+ * dvb_ca_en50221_frda_irq - An FR or DA IRQ has occurred.
  *
  * @ca: CA instance.
  * @slot: Slot concerned.
@@ -1036,7 +1035,7 @@ void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *pubca, int slot)
 		break;
 	}
 }
-
+EXPORT_SYMBOL(dvb_ca_en50221_frda_irq);
 
 
 /* ************************************************************************** */
-- 
2.7.4
