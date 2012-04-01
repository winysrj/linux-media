Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:40850 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab2DAPyF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 11:54:05 -0400
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Cc: "Steinar H. Gunderson" <sesse@samfundet.no>
Subject: [PATCH 07/11] Fix a ton of SMP-unsafe accesses.
Date: Sun,  1 Apr 2012 17:53:47 +0200
Message-Id: <1333295631-31866-7-git-send-email-sgunderson@bigfoot.com>
In-Reply-To: <20120401155330.GA31901@uio.no>
References: <20120401155330.GA31901@uio.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Steinar H. Gunderson" <sesse@samfundet.no>

Basically a lot of the members of mantis_ca were accessed from several threads
without a mutex, which is a big no-no; I've mostly changed to using atomic
operations here, although I also added some locks were it made sense
(e.g. when resetting the CAM).
---
 drivers/media/dvb/mantis/mantis_ca.c     |   14 ++++++++++++++
 drivers/media/dvb/mantis/mantis_common.h |    2 +-
 drivers/media/dvb/mantis/mantis_evm.c    |    9 +++++++--
 drivers/media/dvb/mantis/mantis_hif.c    |   25 ++++++++++++++++++++-----
 drivers/media/dvb/mantis/mantis_link.h   |    2 +-
 drivers/media/dvb/mantis/mantis_reg.h    |    6 ++++--
 6 files changed, 47 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_ca.c b/drivers/media/dvb/mantis/mantis_ca.c
index 0f8efc7..cdff4b7 100644
--- a/drivers/media/dvb/mantis/mantis_ca.c
+++ b/drivers/media/dvb/mantis/mantis_ca.c
@@ -95,11 +95,25 @@ static int mantis_ca_slot_reset(struct dvb_ca_en50221 *en50221, int slot)
 	struct mantis_pci *mantis = ca->ca_priv;
 
 	dprintk(MANTIS_DEBUG, 1, "Slot(%d): Slot RESET", slot);
+	mutex_lock(&mantis->int_stat_lock);
+	if (test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event)) {
+		dprintk(MANTIS_NOTICE, 1, "Slot(%d): Reset operation done before it started!", slot);
+	}
 	udelay(500); /* Wait.. */
 	mmwrite(0xda, MANTIS_PCMCIA_RESET); /* Leading edge assert */
 	udelay(500);
 	mmwrite(0x00, MANTIS_PCMCIA_RESET); /* Trailing edge deassert */
 	msleep(1000);
+
+	if (wait_event_timeout(ca->hif_opdone_wq,
+			       test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event),
+			       msecs_to_jiffies(500)) == -ERESTARTSYS) {
+
+		dprintk(MANTIS_ERROR, 1, "Slot(%d): Reset timeout!", slot);
+	} else {
+		dprintk(MANTIS_DEBUG, 1, "Slot(%d): Reset complete", slot);
+	}
+	mutex_unlock(&mantis->int_stat_lock);
 	dvb_ca_en50221_camready_irq(&ca->en50221, 0);
 
 	return 0;
diff --git a/drivers/media/dvb/mantis/mantis_common.h b/drivers/media/dvb/mantis/mantis_common.h
index 9058d9d..0967103 100644
--- a/drivers/media/dvb/mantis/mantis_common.h
+++ b/drivers/media/dvb/mantis/mantis_common.h
@@ -161,7 +161,7 @@ struct mantis_pci {
 	 /*	A12 A13 A14		*/
 	u32			gpio_status;
 
-	u32			gpif_status;
+	volatile unsigned long	gpif_status;
 
 	struct mantis_ca	*mantis_ca;
 	struct mutex		int_stat_lock;
diff --git a/drivers/media/dvb/mantis/mantis_evm.c b/drivers/media/dvb/mantis/mantis_evm.c
index 36f2256..0fdf51c 100644
--- a/drivers/media/dvb/mantis/mantis_evm.c
+++ b/drivers/media/dvb/mantis/mantis_evm.c
@@ -20,6 +20,7 @@
 
 #include <linux/kernel.h>
 
+#include <linux/atomic.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
@@ -87,10 +88,14 @@ static void mantis_hifevm_work(struct work_struct *work)
 	if (gpif_stat & MANTIS_SBUF_EMPTY)
 		dprintk(MANTIS_DEBUG, 1, "Event Mgr: Adapter(%d) Slot(0): Smart Buffer Empty", mantis->num);
 
-	if (gpif_stat & MANTIS_SBUF_OPDONE) {
+	if (gpif_stat & MANTIS_SBUF_OPDONE)
 		dprintk(MANTIS_DEBUG, 1, "Event Mgr: Adapter(%d) Slot(0): Smart Buffer operation complete", mantis->num);
+
+	if (gpif_stat & MANTIS_SBUF_OPDONE) {
 		ca->sbuf_status = MANTIS_SBUF_DATA_AVAIL;
-		ca->hif_event = MANTIS_SBUF_OPDONE;
+		if (test_and_set_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event)) {
+			dprintk(MANTIS_NOTICE, 1, "Operation done, but SBUF_OPDONE bit was already set!");
+		}
 		wake_up(&ca->hif_opdone_wq);
 	}
 }
diff --git a/drivers/media/dvb/mantis/mantis_hif.c b/drivers/media/dvb/mantis/mantis_hif.c
index c1e456c..6d42f73 100644
--- a/drivers/media/dvb/mantis/mantis_hif.c
+++ b/drivers/media/dvb/mantis/mantis_hif.c
@@ -22,6 +22,7 @@
 #include <linux/signal.h>
 #include <linux/sched.h>
 
+#include <linux/atomic.h>
 #include <linux/interrupt.h>
 #include <asm/io.h>
 
@@ -45,25 +46,23 @@ static int mantis_hif_sbuf_opdone_wait(struct mantis_ca *ca)
 	int rc = 0;
 
 	if (wait_event_timeout(ca->hif_opdone_wq,
-			       ca->hif_event & MANTIS_SBUF_OPDONE,
+			       test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event),
 			       msecs_to_jiffies(500)) == -ERESTARTSYS) {
 
 		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): Smart buffer operation timeout !", mantis->num);
 		rc = -EREMOTEIO;
 	}
 	dprintk(MANTIS_DEBUG, 1, "Smart Buffer Operation complete");
-	ca->hif_event &= ~MANTIS_SBUF_OPDONE;
 	return rc;
 }
 
 static int mantis_hif_write_wait(struct mantis_ca *ca)
 {
 	struct mantis_pci *mantis = ca->ca_priv;
-	u32 opdone = 0, timeout = 0;
 	int rc = 0;
 
 	if (wait_event_timeout(ca->hif_write_wq,
-			       mantis->gpif_status & MANTIS_GPIF_WRACK,
+			       test_and_clear_bit(MANTIS_GPIF_WRACK_BIT, &mantis->gpif_status),
 			       msecs_to_jiffies(500)) == -ERESTARTSYS) {
 
 		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): Write ACK timed out !", mantis->num);
@@ -81,7 +80,10 @@ static int mantis_hif_write_wait(struct mantis_ca *ca)
 			break;
 		}
 	}
-	dprintk(MANTIS_DEBUG, 1, "HIF Write success");
+	if (mantis_hif_sbuf_opdone_wait(ca) != 0) {
+		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): Write operation timeout !", mantis->num);
+		rc = -ETIMEDOUT;
+	}
 	return rc;
 }
 
@@ -94,6 +96,10 @@ int mantis_hif_read_mem(struct mantis_ca *ca, u32 addr)
 	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF Mem Read of 0x%x", mantis->num, addr);
 	mutex_lock(&mantis->int_stat_lock);
 
+	if (test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event)) {
+		dprintk(MANTIS_NOTICE, 1, "Adapter(%d) Slot(0): Read operation done before it started!", mantis->num);
+	}
+
 	hif_addr &= ~MANTIS_GPIF_PCMCIAREG;
 	hif_addr &= ~MANTIS_GPIF_PCMCIAIOM;
 	hif_addr |=  MANTIS_HIF_STATUS;
@@ -123,6 +129,9 @@ int mantis_hif_write_mem(struct mantis_ca *ca, u32 addr, u8 data)
 
 	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF Mem Write", mantis->num);
 	mutex_lock(&mantis->int_stat_lock);
+	if (test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event)) {
+		dprintk(MANTIS_NOTICE, 1, "Adapter(%d) Slot(0): Write operation done before it started!", mantis->num);
+	}
 	hif_addr &= ~MANTIS_GPIF_HIFRDWRN;
 	hif_addr &= ~MANTIS_GPIF_PCMCIAREG;
 	hif_addr &= ~MANTIS_GPIF_PCMCIAIOM;
@@ -151,6 +160,9 @@ int mantis_hif_read_iom(struct mantis_ca *ca, u32 addr)
 
 	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF I/O Read of 0x%x", mantis->num, addr);
 	mutex_lock(&mantis->int_stat_lock);
+	if (test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event)) {
+		dprintk(MANTIS_NOTICE, 1, "Adapter(%d) Slot(0): I/O read operation done before it started!", mantis->num);
+	}
 	hif_addr &= ~MANTIS_GPIF_PCMCIAREG;
 	hif_addr |=  MANTIS_GPIF_PCMCIAIOM;
 	hif_addr |=  MANTIS_HIF_STATUS;
@@ -181,6 +193,9 @@ int mantis_hif_write_iom(struct mantis_ca *ca, u32 addr, u8 data)
 
 	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF I/O Write", mantis->num);
 	mutex_lock(&mantis->int_stat_lock);
+	if (test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event)) {
+		dprintk(MANTIS_NOTICE, 1, "Adapter(%d) Slot(0): I/O write operation done before it started!", mantis->num);
+	}
 	hif_addr &= ~MANTIS_GPIF_PCMCIAREG;
 	hif_addr &= ~MANTIS_GPIF_HIFRDWRN;
 	hif_addr |=  MANTIS_GPIF_PCMCIAIOM;
diff --git a/drivers/media/dvb/mantis/mantis_link.h b/drivers/media/dvb/mantis/mantis_link.h
index c59602d..d8fefdf 100644
--- a/drivers/media/dvb/mantis/mantis_link.h
+++ b/drivers/media/dvb/mantis/mantis_link.h
@@ -48,7 +48,7 @@ struct mantis_ca {
 
 	struct work_struct		hif_evm_work;
 
-	u32				hif_event;
+	volatile unsigned long 		hif_event;
 	wait_queue_head_t		hif_opdone_wq;
 	wait_queue_head_t		hif_brrdyw_wq;
 	wait_queue_head_t		hif_data_wq;
diff --git a/drivers/media/dvb/mantis/mantis_reg.h b/drivers/media/dvb/mantis/mantis_reg.h
index 7761f9d..be57b78 100644
--- a/drivers/media/dvb/mantis/mantis_reg.h
+++ b/drivers/media/dvb/mantis/mantis_reg.h
@@ -152,11 +152,13 @@
 
 #define MANTIS_GPIF_STATUS		0x9c
 #define MANTIS_SBUF_KILLOP		(0x01 << 15)
-#define MANTIS_SBUF_OPDONE		(0x01 << 14)
+#define MANTIS_SBUF_OPDONE_BIT		14
+#define MANTIS_SBUF_OPDONE		(0x01 << MANTIS_SBUF_OPDONE_BIT)
 #define MANTIS_SBUF_EMPTY		(0x01 << 13)
 #define MANTIS_GPIF_DETSTAT		(0x01 <<  9)
 #define MANTIS_GPIF_INTSTAT		(0x01 <<  8)
-#define MANTIS_GPIF_WRACK		(0x01 <<  7)
+#define MANTIS_GPIF_WRACK_BIT		7
+#define MANTIS_GPIF_WRACK		(0x01 <<  MANTIS_GPIF_WRACK_BIT)
 #define MANTIS_GPIF_BRRDY		(0x01 <<  6)
 #define MANTIS_SBUF_OVFLW		(0x01 <<  5)
 #define MANTIS_GPIF_OTHERR		(0x01 <<  4)
-- 
1.7.9.5

