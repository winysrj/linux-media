Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:40836 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab2DAPyF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 11:54:05 -0400
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Cc: "Steinar H. Gunderson" <sesse@samfundet.no>
Subject: [PATCH 06/11] Replace ca_lock by a slightly more general int_stat_lock.
Date: Sun,  1 Apr 2012 17:53:46 +0200
Message-Id: <1333295631-31866-6-git-send-email-sgunderson@bigfoot.com>
In-Reply-To: <20120401155330.GA31901@uio.no>
References: <20120401155330.GA31901@uio.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Steinar H. Gunderson" <sesse@samfundet.no>

This lock is ideally held when banging on MANTIS_INT_STAT.
(I have no hardware documentation, so I'm afraid I don't
really know the specifics here.)

Signed-off-by: Steinar H. Gunderson <sesse@samfundet.no>
---
 drivers/media/dvb/mantis/mantis_ca.c     |    2 --
 drivers/media/dvb/mantis/mantis_cards.c  |    1 +
 drivers/media/dvb/mantis/mantis_common.h |    1 +
 drivers/media/dvb/mantis/mantis_hif.c    |   32 +++++++++++++++---------------
 drivers/media/dvb/mantis/mantis_i2c.c    |    4 ++++
 drivers/media/dvb/mantis/mantis_link.h   |    1 -
 6 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_ca.c b/drivers/media/dvb/mantis/mantis_ca.c
index 3d70469..0f8efc7 100644
--- a/drivers/media/dvb/mantis/mantis_ca.c
+++ b/drivers/media/dvb/mantis/mantis_ca.c
@@ -172,8 +172,6 @@ int mantis_ca_init(struct mantis_pci *mantis)
 	ca->en50221.poll_slot_status	= mantis_slot_status;
 	ca->en50221.data		= ca;
 
-	mutex_init(&ca->ca_lock);
-
 	init_waitqueue_head(&ca->hif_data_wq);
 	init_waitqueue_head(&ca->hif_opdone_wq);
 	init_waitqueue_head(&ca->hif_write_wq);
diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/dvb/mantis/mantis_cards.c
index 8e12801..1503e40 100644
--- a/drivers/media/dvb/mantis/mantis_cards.c
+++ b/drivers/media/dvb/mantis/mantis_cards.c
@@ -179,6 +179,7 @@ static int __devinit mantis_pci_probe(struct pci_dev *pdev, const struct pci_dev
 	config			= (struct mantis_hwconfig *) pci_id->driver_data;
 	config->irq_handler	= &mantis_irq_handler;
 	mantis->hwconfig	= config;
+	mutex_init(&mantis->int_stat_lock);
 
 	err = mantis_pci_init(mantis);
 	if (err) {
diff --git a/drivers/media/dvb/mantis/mantis_common.h b/drivers/media/dvb/mantis/mantis_common.h
index f2410cf..9058d9d 100644
--- a/drivers/media/dvb/mantis/mantis_common.h
+++ b/drivers/media/dvb/mantis/mantis_common.h
@@ -164,6 +164,7 @@ struct mantis_pci {
 	u32			gpif_status;
 
 	struct mantis_ca	*mantis_ca;
+	struct mutex		int_stat_lock;
 
 	wait_queue_head_t	uart_wq;
 	struct work_struct	uart_work;
diff --git a/drivers/media/dvb/mantis/mantis_hif.c b/drivers/media/dvb/mantis/mantis_hif.c
index 1210cda..c1e456c 100644
--- a/drivers/media/dvb/mantis/mantis_hif.c
+++ b/drivers/media/dvb/mantis/mantis_hif.c
@@ -92,7 +92,7 @@ int mantis_hif_read_mem(struct mantis_ca *ca, u32 addr)
 	u32 hif_addr = 0, data, count = 4;
 
 	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF Mem Read of 0x%x", mantis->num, addr);
-	mutex_lock(&ca->ca_lock);
+	mutex_lock(&mantis->int_stat_lock);
 
 	hif_addr &= ~MANTIS_GPIF_PCMCIAREG;
 	hif_addr &= ~MANTIS_GPIF_PCMCIAIOM;
@@ -106,11 +106,11 @@ int mantis_hif_read_mem(struct mantis_ca *ca, u32 addr)
 
 	if (mantis_hif_sbuf_opdone_wait(ca) != 0) {
 		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): GPIF Smart Buffer operation failed", mantis->num);
-		mutex_unlock(&ca->ca_lock);
+		mutex_unlock(&mantis->int_stat_lock);
 		return -EREMOTEIO;
 	}
 	data = mmread(MANTIS_GPIF_DIN);
-	mutex_unlock(&ca->ca_lock);
+	mutex_unlock(&mantis->int_stat_lock);
 	dprintk(MANTIS_DEBUG, 1, "Mem Read: 0x%02x from 0x%02x", data, addr);
 	return (data >> 24) & 0xff;
 }
@@ -122,7 +122,7 @@ int mantis_hif_write_mem(struct mantis_ca *ca, u32 addr, u8 data)
 	u32 hif_addr = 0;
 
 	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF Mem Write", mantis->num);
-	mutex_lock(&ca->ca_lock);
+	mutex_lock(&mantis->int_stat_lock);
 	hif_addr &= ~MANTIS_GPIF_HIFRDWRN;
 	hif_addr &= ~MANTIS_GPIF_PCMCIAREG;
 	hif_addr &= ~MANTIS_GPIF_PCMCIAIOM;
@@ -135,11 +135,11 @@ int mantis_hif_write_mem(struct mantis_ca *ca, u32 addr, u8 data)
 
 	if (mantis_hif_write_wait(ca) != 0) {
 		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): HIF Smart Buffer operation failed", mantis->num);
-		mutex_unlock(&ca->ca_lock);
+		mutex_unlock(&mantis->int_stat_lock);
 		return -EREMOTEIO;
 	}
 	dprintk(MANTIS_DEBUG, 1, "Mem Write: (0x%02x to 0x%02x)", data, addr);
-	mutex_unlock(&ca->ca_lock);
+	mutex_unlock(&mantis->int_stat_lock);
 
 	return 0;
 }
@@ -150,7 +150,7 @@ int mantis_hif_read_iom(struct mantis_ca *ca, u32 addr)
 	u32 data, hif_addr = 0;
 
 	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF I/O Read of 0x%x", mantis->num, addr);
-	mutex_lock(&ca->ca_lock);
+	mutex_lock(&mantis->int_stat_lock);
 	hif_addr &= ~MANTIS_GPIF_PCMCIAREG;
 	hif_addr |=  MANTIS_GPIF_PCMCIAIOM;
 	hif_addr |=  MANTIS_HIF_STATUS;
@@ -163,13 +163,13 @@ int mantis_hif_read_iom(struct mantis_ca *ca, u32 addr)
 
 	if (mantis_hif_sbuf_opdone_wait(ca) != 0) {
 		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): HIF Smart Buffer operation failed", mantis->num);
-		mutex_unlock(&ca->ca_lock);
+		mutex_unlock(&mantis->int_stat_lock);
 		return -EREMOTEIO;
 	}
 	data = mmread(MANTIS_GPIF_DIN);
 	dprintk(MANTIS_DEBUG, 1, "I/O Read: 0x%02x from 0x%02x", data, addr);
 	udelay(50);
-	mutex_unlock(&ca->ca_lock);
+	mutex_unlock(&mantis->int_stat_lock);
 
 	return (u8) data;
 }
@@ -180,7 +180,7 @@ int mantis_hif_write_iom(struct mantis_ca *ca, u32 addr, u8 data)
 	u32 hif_addr = 0;
 
 	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF I/O Write", mantis->num);
-	mutex_lock(&ca->ca_lock);
+	mutex_lock(&mantis->int_stat_lock);
 	hif_addr &= ~MANTIS_GPIF_PCMCIAREG;
 	hif_addr &= ~MANTIS_GPIF_HIFRDWRN;
 	hif_addr |=  MANTIS_GPIF_PCMCIAIOM;
@@ -192,11 +192,11 @@ int mantis_hif_write_iom(struct mantis_ca *ca, u32 addr, u8 data)
 
 	if (mantis_hif_write_wait(ca) != 0) {
 		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): HIF Smart Buffer operation failed", mantis->num);
-		mutex_unlock(&ca->ca_lock);
+		mutex_unlock(&mantis->int_stat_lock);
 		return -EREMOTEIO;
 	}
 	dprintk(MANTIS_DEBUG, 1, "I/O Write: (0x%02x to 0x%02x)", data, addr);
-	mutex_unlock(&ca->ca_lock);
+	mutex_unlock(&mantis->int_stat_lock);
 	udelay(50);
 
 	return 0;
@@ -211,7 +211,7 @@ int mantis_hif_init(struct mantis_ca *ca)
 	slot[0].slave_cfg = 0x70773028;
 	dprintk(MANTIS_ERROR, 1, "Adapter(%d) Initializing Mantis Host Interface", mantis->num);
 
-	mutex_lock(&ca->ca_lock);
+	mutex_lock(&mantis->int_stat_lock);
 	irqcfg = mmread(MANTIS_GPIF_IRQCFG);
 	irqcfg = MANTIS_MASK_BRRDY	|
 		 MANTIS_MASK_WRACK	|
@@ -221,7 +221,7 @@ int mantis_hif_init(struct mantis_ca *ca)
 		 MANTIS_MASK_OVFLW;
 
 	mmwrite(irqcfg, MANTIS_GPIF_IRQCFG);
-	mutex_unlock(&ca->ca_lock);
+	mutex_unlock(&mantis->int_stat_lock);
 
 	return 0;
 }
@@ -232,9 +232,9 @@ void mantis_hif_exit(struct mantis_ca *ca)
 	u32 irqcfg;
 
 	dprintk(MANTIS_ERROR, 1, "Adapter(%d) Exiting Mantis Host Interface", mantis->num);
-	mutex_lock(&ca->ca_lock);
+	mutex_lock(&mantis->int_stat_lock);
 	irqcfg = mmread(MANTIS_GPIF_IRQCFG);
 	irqcfg &= ~MANTIS_MASK_BRRDY;
 	mmwrite(irqcfg, MANTIS_GPIF_IRQCFG);
-	mutex_unlock(&ca->ca_lock);
+	mutex_unlock(&mantis->int_stat_lock);
 }
diff --git a/drivers/media/dvb/mantis/mantis_i2c.c b/drivers/media/dvb/mantis/mantis_i2c.c
index ddd1922..5d2ad98 100644
--- a/drivers/media/dvb/mantis/mantis_i2c.c
+++ b/drivers/media/dvb/mantis/mantis_i2c.c
@@ -263,12 +263,14 @@ int __devinit mantis_i2c_init(struct mantis_pci *mantis)
 
 	dprintk(MANTIS_DEBUG, 1, "Initializing I2C ..");
 
+	mutex_lock(&mantis->int_stat_lock);
 	intstat = mmread(MANTIS_INT_STAT);
 	intmask = mmread(MANTIS_INT_MASK);
 	mmwrite(intstat, MANTIS_INT_STAT);
 	dprintk(MANTIS_DEBUG, 1, "Disabling I2C interrupt");
 	intmask = mmread(MANTIS_INT_MASK);
 	mmwrite((intmask & ~MANTIS_INT_I2CDONE), MANTIS_INT_MASK);
+	mutex_unlock(&mantis->int_stat_lock);
 
 	return 0;
 }
@@ -279,8 +281,10 @@ int mantis_i2c_exit(struct mantis_pci *mantis)
 	u32 intmask;
 
 	dprintk(MANTIS_DEBUG, 1, "Disabling I2C interrupt");
+	mutex_lock(&mantis->int_stat_lock);
 	intmask = mmread(MANTIS_INT_MASK);
 	mmwrite((intmask & ~MANTIS_INT_I2CDONE), MANTIS_INT_MASK);
+	mutex_unlock(&mantis->int_stat_lock);
 
 	dprintk(MANTIS_DEBUG, 1, "Removing I2C adapter");
 	return i2c_del_adapter(&mantis->adapter);
diff --git a/drivers/media/dvb/mantis/mantis_link.h b/drivers/media/dvb/mantis/mantis_link.h
index 2a81477..c59602d 100644
--- a/drivers/media/dvb/mantis/mantis_link.h
+++ b/drivers/media/dvb/mantis/mantis_link.h
@@ -61,7 +61,6 @@ struct mantis_ca {
 	void				*ca_priv;
 
 	struct dvb_ca_en50221		en50221;
-	struct mutex			ca_lock;
 };
 
 /* CA */
-- 
1.7.9.5

