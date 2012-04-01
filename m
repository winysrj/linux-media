Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:40853 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab2DAPyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 11:54:04 -0400
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Cc: "Steinar H. Gunderson" <sesse@samfundet.no>
Subject: [PATCH 08/11] Remove some unused structure members.
Date: Sun,  1 Apr 2012 17:53:48 +0200
Message-Id: <1333295631-31866-8-git-send-email-sgunderson@bigfoot.com>
In-Reply-To: <20120401155330.GA31901@uio.no>
References: <20120401155330.GA31901@uio.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Steinar H. Gunderson" <sesse@samfundet.no>

Signed-off-by: Steinar H. Gunderson <sesse@samfundet.no>
---
 drivers/media/dvb/mantis/mantis_evm.c  |   12 ++++--------
 drivers/media/dvb/mantis/mantis_link.h |    8 --------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_evm.c b/drivers/media/dvb/mantis/mantis_evm.c
index 0fdf51c..e6012cf 100644
--- a/drivers/media/dvb/mantis/mantis_evm.c
+++ b/drivers/media/dvb/mantis/mantis_evm.c
@@ -42,10 +42,7 @@ static void mantis_hifevm_work(struct work_struct *work)
 	struct mantis_ca *ca = container_of(work, struct mantis_ca, hif_evm_work);
 	struct mantis_pci *mantis = ca->ca_priv;
 
-	u32 gpif_stat, gpif_mask;
-
-	gpif_stat = mmread(MANTIS_GPIF_STATUS);
-	gpif_mask = mmread(MANTIS_GPIF_IRQCFG);
+	u32 gpif_stat = mmread(MANTIS_GPIF_STATUS);
 
 	if (gpif_stat & MANTIS_GPIF_DETSTAT) {
 		if (gpif_stat & MANTIS_CARD_PLUGIN) {
@@ -67,13 +64,13 @@ static void mantis_hifevm_work(struct work_struct *work)
 		}
 	}
 
-	if (mantis->gpif_status & MANTIS_GPIF_EXTIRQ)
+	if (gpif_stat & MANTIS_GPIF_EXTIRQ)
 		dprintk(MANTIS_DEBUG, 1, "Event Mgr: Adapter(%d) Slot(0): Ext IRQ", mantis->num);
 
-	if (mantis->gpif_status & MANTIS_SBUF_WSTO)
+	if (gpif_stat & MANTIS_SBUF_WSTO)
 		dprintk(MANTIS_DEBUG, 1, "Event Mgr: Adapter(%d) Slot(0): Smart Buffer Timeout", mantis->num);
 
-	if (mantis->gpif_status & MANTIS_GPIF_OTHERR)
+	if (gpif_stat & MANTIS_GPIF_OTHERR)
 		dprintk(MANTIS_DEBUG, 1, "Event Mgr: Adapter(%d) Slot(0): Alignment Error", mantis->num);
 
 	if (gpif_stat & MANTIS_SBUF_OVFLW)
@@ -92,7 +89,6 @@ static void mantis_hifevm_work(struct work_struct *work)
 		dprintk(MANTIS_DEBUG, 1, "Event Mgr: Adapter(%d) Slot(0): Smart Buffer operation complete", mantis->num);
 
 	if (gpif_stat & MANTIS_SBUF_OPDONE) {
-		ca->sbuf_status = MANTIS_SBUF_DATA_AVAIL;
 		if (test_and_set_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event)) {
 			dprintk(MANTIS_NOTICE, 1, "Operation done, but SBUF_OPDONE bit was already set!");
 		}
diff --git a/drivers/media/dvb/mantis/mantis_link.h b/drivers/media/dvb/mantis/mantis_link.h
index d8fefdf..a0f1428 100644
--- a/drivers/media/dvb/mantis/mantis_link.h
+++ b/drivers/media/dvb/mantis/mantis_link.h
@@ -25,12 +25,6 @@
 #include <linux/workqueue.h>
 #include "dvb_ca_en50221.h"
 
-enum mantis_sbuf_status {
-	MANTIS_SBUF_DATA_AVAIL		= 1,
-	MANTIS_SBUF_DATA_EMPTY		= 2,
-	MANTIS_SBUF_DATA_OVFLW		= 3
-};
-
 struct mantis_slot {
 	u32				timeout;
 	u32				slave_cfg;
@@ -54,8 +48,6 @@ struct mantis_ca {
 	wait_queue_head_t		hif_data_wq;
 	wait_queue_head_t		hif_write_wq; /* HIF Write op */
 
-	enum mantis_sbuf_status		sbuf_status;
-
 	enum mantis_slot_state		slot_state;
 
 	void				*ca_priv;
-- 
1.7.9.5

