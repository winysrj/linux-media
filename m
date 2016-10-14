Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59194 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757075AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        GEORGE <geoubuntu@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sean Young <sean@mess.org>
Subject: [PATCH 17/57] [media] saa7134: don't break long lines
Date: Fri, 14 Oct 2016 17:20:05 -0300
Message-Id: <959ada437c22e8b5022ef9c91e563fc45cb1a9e8.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/saa7134/saa7134-alsa.c  |  3 +--
 drivers/media/pci/saa7134/saa7134-cards.c |  6 ++----
 drivers/media/pci/saa7134/saa7134-core.c  | 29 +++++++++--------------------
 drivers/media/pci/saa7134/saa7134-dvb.c   | 24 ++++++++----------------
 drivers/media/pci/saa7134/saa7134-input.c | 12 ++++--------
 5 files changed, 24 insertions(+), 50 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index dc0e2fc5f68b..8a35ecfb75e3 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -813,8 +813,7 @@ static int snd_card_saa7134_capture_open(struct snd_pcm_substream * substream)
 	int amux, err;
 
 	if (!saa7134) {
-		pr_err("BUG: saa7134 can't find device struct."
-				" Can't proceed with open\n");
+		pr_err("BUG: saa7134 can't find device struct. Can't proceed with open\n");
 		return -ENODEV;
 	}
 	dev = saa7134->dev;
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index c480a7e87593..803abe8e53f6 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -7341,8 +7341,7 @@ static void hauppauge_eeprom(struct saa7134_dev *dev, u8 *eeprom_data)
 	case 67659: /* WinTV-HVR1110 (OEM, no IR, hybrid, FM, SVid/Comp, RCA aud) */
 		break;
 	default:
-		pr_warn("%s: warning: "
-		       "unknown hauppauge model #%d\n", dev->name, tv.model);
+		pr_warn("%s: warning: unknown hauppauge model #%d\n", dev->name, tv.model);
 		break;
 	}
 
@@ -7920,8 +7919,7 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 		msg.addr = 0x0b;
 		msg.len = 1;
 		if (1 != i2c_transfer(&dev->i2c_adap, &msg, 1)) {
-			pr_warn("%s: send wake up byte to pic16C505"
-					"(IR chip) failed\n", dev->name);
+			pr_warn("%s: send wake up byte to pic16C505(IR chip) failed\n", dev->name);
 		} else {
 			msg.flags = I2C_M_RD;
 			rc = i2c_transfer(&dev->i2c_adap, &msg, 1);
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index ffb66a9ae23e..757bc9acb148 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -66,8 +66,7 @@ MODULE_PARM_DESC(latency,"pci latency timer");
 
 int saa7134_no_overlay=-1;
 module_param_named(no_overlay, saa7134_no_overlay, int, 0444);
-MODULE_PARM_DESC(no_overlay,"allow override overlay default (0 disables, 1 enables)"
-		" [some VIA/SIS chipsets are known to have problem with overlay]");
+MODULE_PARM_DESC(no_overlay,"allow override overlay default (0 disables, 1 enables) [some VIA/SIS chipsets are known to have problem with overlay]");
 
 bool saa7134_userptr;
 module_param(saa7134_userptr, bool, 0644);
@@ -619,25 +618,21 @@ static irqreturn_t saa7134_irq(int irq, void *dev_id)
 		print_irqstatus(dev,loop,report,status);
 		if (report & SAA7134_IRQ_REPORT_PE) {
 			/* disable all parity error */
-			pr_warn("%s/irq: looping -- "
-			       "clearing PE (parity error!) enable bit\n",dev->name);
+			pr_warn("%s/irq: looping -- clearing PE (parity error!) enable bit\n",dev->name);
 			saa_clearl(SAA7134_IRQ2,SAA7134_IRQ2_INTE_PE);
 		} else if (report & SAA7134_IRQ_REPORT_GPIO16) {
 			/* disable gpio16 IRQ */
-			pr_warn("%s/irq: looping -- "
-			       "clearing GPIO16 enable bit\n",dev->name);
+			pr_warn("%s/irq: looping -- clearing GPIO16 enable bit\n",dev->name);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO16_P);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO16_N);
 		} else if (report & SAA7134_IRQ_REPORT_GPIO18) {
 			/* disable gpio18 IRQs */
-			pr_warn("%s/irq: looping -- "
-			       "clearing GPIO18 enable bit\n",dev->name);
+			pr_warn("%s/irq: looping -- clearing GPIO18 enable bit\n",dev->name);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_P);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_N);
 		} else {
 			/* disable all irqs */
-			pr_warn("%s/irq: looping -- "
-			       "clearing all enable bits\n",dev->name);
+			pr_warn("%s/irq: looping -- clearing all enable bits\n",dev->name);
 			saa_writel(SAA7134_IRQ1,0);
 			saa_writel(SAA7134_IRQ2,0);
 		}
@@ -1081,18 +1076,13 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 		}
 #endif
 		if (pci_pci_problems & (PCIPCI_FAIL|PCIAGP_FAIL)) {
-			pr_info("%s: quirk: this driver and your "
-					"chipset may not work together"
-					" in overlay mode.\n",dev->name);
+			pr_info("%s: quirk: this driver and your chipset may not work together in overlay mode.\n",dev->name);
 			if (!saa7134_no_overlay) {
-				pr_info("%s: quirk: overlay "
-						"mode will be disabled.\n",
+				pr_info("%s: quirk: overlay mode will be disabled.\n",
 						dev->name);
 				saa7134_no_overlay = 1;
 			} else {
-				pr_info("%s: quirk: overlay "
-						"mode will be forced. Use this"
-						" option at your own risk.\n",
+				pr_info("%s: quirk: overlay mode will be forced. Use this option at your own risk.\n",
 						dev->name);
 			}
 		}
@@ -1106,8 +1096,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	/* print pci info */
 	dev->pci_rev = pci_dev->revision;
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER,  &dev->pci_lat);
-	pr_info("%s: found at %s, rev: %d, irq: %d, "
-	       "latency: %d, mmio: 0x%llx\n", dev->name,
+	pr_info("%s: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n", dev->name,
 	       pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
 	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
 	pci_set_master(pci_dev);
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index 59a4b5f7724e..4d1338734d77 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -1449,8 +1449,7 @@ static int dvb_init(struct saa7134_dev *dev)
 
 				if (dvb_attach(tda826x_attach, fe0->dvb.frontend,
 						0x60, &dev->i2c_adap, 0) == NULL) {
-					pr_warn("%s: Medion Quadro, no tda826x "
-						"found !\n", __func__);
+					pr_warn("%s: Medion Quadro, no tda826x found !\n", __func__);
 					goto detach_frontend;
 				}
 				if (dev_id != 0x08) {
@@ -1458,8 +1457,7 @@ static int dvb_init(struct saa7134_dev *dev)
 					fe->ops.i2c_gate_ctrl(fe, 1);
 					if (dvb_attach(isl6405_attach, fe,
 							&dev->i2c_adap, 0x08, 0, 0) == NULL) {
-						pr_warn("%s: Medion Quadro, no ISL6405 "
-							"found !\n", __func__);
+						pr_warn("%s: Medion Quadro, no ISL6405 found !\n", __func__);
 						goto detach_frontend;
 					}
 					if (dev_id == 0x07) {
@@ -1629,8 +1627,7 @@ static int dvb_init(struct saa7134_dev *dev)
 			struct dvb_frontend *fe;
 			if (dvb_attach(dvb_pll_attach, fe0->dvb.frontend, 0x60,
 				  &dev->i2c_adap, DVB_PLL_PHILIPS_SD1878_TDA8261) == NULL) {
-				pr_warn("%s: MD7134 DVB-S, no SD1878 "
-					"found !\n", __func__);
+				pr_warn("%s: MD7134 DVB-S, no SD1878 found !\n", __func__);
 				goto detach_frontend;
 			}
 			/* we need to open the i2c gate (we know it exists) */
@@ -1638,8 +1635,7 @@ static int dvb_init(struct saa7134_dev *dev)
 			fe->ops.i2c_gate_ctrl(fe, 1);
 			if (dvb_attach(isl6405_attach, fe,
 					&dev->i2c_adap, 0x08, 0, 0) == NULL) {
-				pr_warn("%s: MD7134 DVB-S, no ISL6405 "
-					"found !\n", __func__);
+				pr_warn("%s: MD7134 DVB-S, no ISL6405 found !\n", __func__);
 				goto detach_frontend;
 			}
 			fe->ops.i2c_gate_ctrl(fe, 0);
@@ -1670,14 +1666,12 @@ static int dvb_init(struct saa7134_dev *dev)
 				if (dvb_attach(tda826x_attach,
 						fe0->dvb.frontend, 0x60,
 						&dev->i2c_adap, 0) == NULL) {
-					pr_warn("%s: Asus Tiger 3in1, no "
-						"tda826x found!\n", __func__);
+					pr_warn("%s: Asus Tiger 3in1, no tda826x found!\n", __func__);
 					goto detach_frontend;
 				}
 				if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
 						&dev->i2c_adap, 0, 0) == NULL) {
-					pr_warn("%s: Asus Tiger 3in1, no lnbp21"
-						" found!\n", __func__);
+					pr_warn("%s: Asus Tiger 3in1, no lnbp21 found!\n", __func__);
 					goto detach_frontend;
 			       }
 		       }
@@ -1695,14 +1689,12 @@ static int dvb_init(struct saa7134_dev *dev)
 				if (dvb_attach(tda826x_attach,
 					       fe0->dvb.frontend, 0x60,
 					       &dev->i2c_adap, 0) == NULL) {
-					pr_warn("%s: Asus My Cinema PS3-100, no "
-						"tda826x found!\n", __func__);
+					pr_warn("%s: Asus My Cinema PS3-100, no tda826x found!\n", __func__);
 					goto detach_frontend;
 				}
 				if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
 					       &dev->i2c_adap, 0, 0) == NULL) {
-					pr_warn("%s: Asus My Cinema PS3-100, no lnbp21"
-						" found!\n", __func__);
+					pr_warn("%s: Asus My Cinema PS3-100, no lnbp21 found!\n", __func__);
 					goto detach_frontend;
 				}
 			}
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index eff52bbbfd66..f7ad783f5bfa 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -123,8 +123,7 @@ static int get_key_flydvb_trio(struct IR_i2c *ir, enum rc_type *protocol,
 	struct saa7134_dev *dev = ir->c->adapter->algo_data;
 
 	if (dev == NULL) {
-		ir_dbg(ir, "get_key_flydvb_trio: "
-			   "ir->c->adapter->algo_data is NULL!\n");
+		ir_dbg(ir, "get_key_flydvb_trio: ir->c->adapter->algo_data is NULL!\n");
 		return -EIO;
 	}
 
@@ -150,8 +149,7 @@ static int get_key_flydvb_trio(struct IR_i2c *ir, enum rc_type *protocol,
 			msleep(10);
 			continue;
 		}
-		ir_dbg(ir, "send wake up byte to pic16C505 (IR chip)"
-			   "failed %dx\n", attempt);
+		ir_dbg(ir, "send wake up byte to pic16C505 (IR chip)failed %dx\n", attempt);
 		return -EIO;
 	}
 	if (1 != i2c_master_recv(ir->c, &b, 1)) {
@@ -174,8 +172,7 @@ static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, enum rc_type *protocol
 	/* <dev> is needed to access GPIO. Used by the saa_readl macro. */
 	struct saa7134_dev *dev = ir->c->adapter->algo_data;
 	if (dev == NULL) {
-		ir_dbg(ir, "get_key_msi_tvanywhere_plus: "
-			   "ir->c->adapter->algo_data is NULL!\n");
+		ir_dbg(ir, "get_key_msi_tvanywhere_plus: ir->c->adapter->algo_data is NULL!\n");
 		return -EIO;
 	}
 
@@ -223,8 +220,7 @@ static int get_key_kworld_pc150u(struct IR_i2c *ir, enum rc_type *protocol,
 	/* <dev> is needed to access GPIO. Used by the saa_readl macro. */
 	struct saa7134_dev *dev = ir->c->adapter->algo_data;
 	if (dev == NULL) {
-		ir_dbg(ir, "get_key_kworld_pc150u: "
-			   "ir->c->adapter->algo_data is NULL!\n");
+		ir_dbg(ir, "get_key_kworld_pc150u: ir->c->adapter->algo_data is NULL!\n");
 		return -EIO;
 	}
 
-- 
2.7.4


