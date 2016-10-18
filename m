Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51635 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935537AbcJRUqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        GEORGE <geoubuntu@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sean Young <sean@mess.org>
Subject: [PATCH v2 15/58] saa7134: don't break long lines
Date: Tue, 18 Oct 2016 18:45:27 -0200
Message-Id: <db7ab5192ff3c847a4985248a4e230f64b4fb8cb.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/saa7134/saa7134-alsa.c  |  3 +--
 drivers/media/pci/saa7134/saa7134-cards.c |  8 +++----
 drivers/media/pci/saa7134/saa7134-core.c  | 39 ++++++++++++++-----------------
 drivers/media/pci/saa7134/saa7134-dvb.c   | 32 ++++++++++++-------------
 drivers/media/pci/saa7134/saa7134-input.c | 13 ++++-------
 5 files changed, 43 insertions(+), 52 deletions(-)

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
index c480a7e87593..2b60af493de4 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -7341,8 +7341,8 @@ static void hauppauge_eeprom(struct saa7134_dev *dev, u8 *eeprom_data)
 	case 67659: /* WinTV-HVR1110 (OEM, no IR, hybrid, FM, SVid/Comp, RCA aud) */
 		break;
 	default:
-		pr_warn("%s: warning: "
-		       "unknown hauppauge model #%d\n", dev->name, tv.model);
+		pr_warn("%s: warning: unknown hauppauge model #%d\n",
+			dev->name, tv.model);
 		break;
 	}
 
@@ -7920,8 +7920,8 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 		msg.addr = 0x0b;
 		msg.len = 1;
 		if (1 != i2c_transfer(&dev->i2c_adap, &msg, 1)) {
-			pr_warn("%s: send wake up byte to pic16C505"
-					"(IR chip) failed\n", dev->name);
+			pr_warn("%s: send wake up byte to pic16C505(IR chip) failed\n",
+				dev->name);
 		} else {
 			msg.flags = I2C_M_RD;
 			rc = i2c_transfer(&dev->i2c_adap, &msg, 1);
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index ffb66a9ae23e..133389ea218d 100644
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
@@ -619,25 +618,25 @@ static irqreturn_t saa7134_irq(int irq, void *dev_id)
 		print_irqstatus(dev,loop,report,status);
 		if (report & SAA7134_IRQ_REPORT_PE) {
 			/* disable all parity error */
-			pr_warn("%s/irq: looping -- "
-			       "clearing PE (parity error!) enable bit\n",dev->name);
+			pr_warn("%s/irq: looping -- clearing PE (parity error!) enable bit\n",
+				dev->name);
 			saa_clearl(SAA7134_IRQ2,SAA7134_IRQ2_INTE_PE);
 		} else if (report & SAA7134_IRQ_REPORT_GPIO16) {
 			/* disable gpio16 IRQ */
-			pr_warn("%s/irq: looping -- "
-			       "clearing GPIO16 enable bit\n",dev->name);
+			pr_warn("%s/irq: looping -- clearing GPIO16 enable bit\n",
+				dev->name);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO16_P);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO16_N);
 		} else if (report & SAA7134_IRQ_REPORT_GPIO18) {
 			/* disable gpio18 IRQs */
-			pr_warn("%s/irq: looping -- "
-			       "clearing GPIO18 enable bit\n",dev->name);
+			pr_warn("%s/irq: looping -- clearing GPIO18 enable bit\n",
+				dev->name);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_P);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_N);
 		} else {
 			/* disable all irqs */
-			pr_warn("%s/irq: looping -- "
-			       "clearing all enable bits\n",dev->name);
+			pr_warn("%s/irq: looping -- clearing all enable bits\n",
+				dev->name);
 			saa_writel(SAA7134_IRQ1,0);
 			saa_writel(SAA7134_IRQ2,0);
 		}
@@ -1081,18 +1080,14 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 		}
 #endif
 		if (pci_pci_problems & (PCIPCI_FAIL|PCIAGP_FAIL)) {
-			pr_info("%s: quirk: this driver and your "
-					"chipset may not work together"
-					" in overlay mode.\n",dev->name);
+			pr_info("%s: quirk: this driver and your chipset may not work together in overlay mode.\n",
+				dev->name);
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
@@ -1106,10 +1101,10 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	/* print pci info */
 	dev->pci_rev = pci_dev->revision;
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER,  &dev->pci_lat);
-	pr_info("%s: found at %s, rev: %d, irq: %d, "
-	       "latency: %d, mmio: 0x%llx\n", dev->name,
-	       pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
-	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
+	pr_info("%s: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
+		dev->name,
+	        pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
+	        dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
 	pci_set_master(pci_dev);
 	err = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
 	if (err) {
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index 59a4b5f7724e..598b8bbfe726 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -1449,8 +1449,8 @@ static int dvb_init(struct saa7134_dev *dev)
 
 				if (dvb_attach(tda826x_attach, fe0->dvb.frontend,
 						0x60, &dev->i2c_adap, 0) == NULL) {
-					pr_warn("%s: Medion Quadro, no tda826x "
-						"found !\n", __func__);
+					pr_warn("%s: Medion Quadro, no tda826x found !\n",
+						__func__);
 					goto detach_frontend;
 				}
 				if (dev_id != 0x08) {
@@ -1458,8 +1458,8 @@ static int dvb_init(struct saa7134_dev *dev)
 					fe->ops.i2c_gate_ctrl(fe, 1);
 					if (dvb_attach(isl6405_attach, fe,
 							&dev->i2c_adap, 0x08, 0, 0) == NULL) {
-						pr_warn("%s: Medion Quadro, no ISL6405 "
-							"found !\n", __func__);
+						pr_warn("%s: Medion Quadro, no ISL6405 found !\n",
+							__func__);
 						goto detach_frontend;
 					}
 					if (dev_id == 0x07) {
@@ -1629,8 +1629,8 @@ static int dvb_init(struct saa7134_dev *dev)
 			struct dvb_frontend *fe;
 			if (dvb_attach(dvb_pll_attach, fe0->dvb.frontend, 0x60,
 				  &dev->i2c_adap, DVB_PLL_PHILIPS_SD1878_TDA8261) == NULL) {
-				pr_warn("%s: MD7134 DVB-S, no SD1878 "
-					"found !\n", __func__);
+				pr_warn("%s: MD7134 DVB-S, no SD1878 found !\n",
+					__func__);
 				goto detach_frontend;
 			}
 			/* we need to open the i2c gate (we know it exists) */
@@ -1638,8 +1638,8 @@ static int dvb_init(struct saa7134_dev *dev)
 			fe->ops.i2c_gate_ctrl(fe, 1);
 			if (dvb_attach(isl6405_attach, fe,
 					&dev->i2c_adap, 0x08, 0, 0) == NULL) {
-				pr_warn("%s: MD7134 DVB-S, no ISL6405 "
-					"found !\n", __func__);
+				pr_warn("%s: MD7134 DVB-S, no ISL6405 found !\n",
+					__func__);
 				goto detach_frontend;
 			}
 			fe->ops.i2c_gate_ctrl(fe, 0);
@@ -1670,14 +1670,14 @@ static int dvb_init(struct saa7134_dev *dev)
 				if (dvb_attach(tda826x_attach,
 						fe0->dvb.frontend, 0x60,
 						&dev->i2c_adap, 0) == NULL) {
-					pr_warn("%s: Asus Tiger 3in1, no "
-						"tda826x found!\n", __func__);
+					pr_warn("%s: Asus Tiger 3in1, no tda826x found!\n",
+						__func__);
 					goto detach_frontend;
 				}
 				if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
 						&dev->i2c_adap, 0, 0) == NULL) {
-					pr_warn("%s: Asus Tiger 3in1, no lnbp21"
-						" found!\n", __func__);
+					pr_warn("%s: Asus Tiger 3in1, no lnbp21 found!\n",
+						__func__);
 					goto detach_frontend;
 			       }
 		       }
@@ -1695,14 +1695,14 @@ static int dvb_init(struct saa7134_dev *dev)
 				if (dvb_attach(tda826x_attach,
 					       fe0->dvb.frontend, 0x60,
 					       &dev->i2c_adap, 0) == NULL) {
-					pr_warn("%s: Asus My Cinema PS3-100, no "
-						"tda826x found!\n", __func__);
+					pr_warn("%s: Asus My Cinema PS3-100, no tda826x found!\n",
+						__func__);
 					goto detach_frontend;
 				}
 				if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
 					       &dev->i2c_adap, 0, 0) == NULL) {
-					pr_warn("%s: Asus My Cinema PS3-100, no lnbp21"
-						" found!\n", __func__);
+					pr_warn("%s: Asus My Cinema PS3-100, no lnbp21 found!\n",
+						__func__);
 					goto detach_frontend;
 				}
 			}
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index eff52bbbfd66..823b75ed47e1 100644
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
 
@@ -150,8 +149,8 @@ static int get_key_flydvb_trio(struct IR_i2c *ir, enum rc_type *protocol,
 			msleep(10);
 			continue;
 		}
-		ir_dbg(ir, "send wake up byte to pic16C505 (IR chip)"
-			   "failed %dx\n", attempt);
+		ir_dbg(ir, "send wake up byte to pic16C505 (IR chip)failed %dx\n",
+		       attempt);
 		return -EIO;
 	}
 	if (1 != i2c_master_recv(ir->c, &b, 1)) {
@@ -174,8 +173,7 @@ static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, enum rc_type *protocol
 	/* <dev> is needed to access GPIO. Used by the saa_readl macro. */
 	struct saa7134_dev *dev = ir->c->adapter->algo_data;
 	if (dev == NULL) {
-		ir_dbg(ir, "get_key_msi_tvanywhere_plus: "
-			   "ir->c->adapter->algo_data is NULL!\n");
+		ir_dbg(ir, "get_key_msi_tvanywhere_plus: ir->c->adapter->algo_data is NULL!\n");
 		return -EIO;
 	}
 
@@ -223,8 +221,7 @@ static int get_key_kworld_pc150u(struct IR_i2c *ir, enum rc_type *protocol,
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


