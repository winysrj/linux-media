Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward5h.mail.yandex.net ([84.201.186.23]:52355 "EHLO
	forward5h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2GNVuM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jul 2012 17:50:12 -0400
Received: from web25h.yandex.ru (web25h.yandex.ru [84.201.187.159])
	by forward5h.mail.yandex.net (Yandex) with ESMTP id C3778D020A1
	for <linux-media@vger.kernel.org>; Sun, 15 Jul 2012 01:40:08 +0400 (MSK)
From: CrazyCat <crazycat69@yandex.ru>
To: linux-media@vger.kernel.org
Subject: [PATCH]Omicom S2 PCI support
MIME-Version: 1.0
Message-Id: <1128921342302008@web25h.yandex.ru>
Date: Sun, 15 Jul 2012 00:40:08 +0300
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for yet another SAA7146-based budget card (very similar to TT S2-1600, but use LNBH23 instead ISL6423).
diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c
index b21bcce..1774c53 100644
--- a/drivers/media/dvb/ttpci/budget.c
+++ b/drivers/media/dvb/ttpci/budget.c
@@ -50,6 +50,8 @@
 #include "stv6110x.h"
 #include "stv090x.h"
 #include "isl6423.h"
+#include "lnbh24.h"
+
 
 static int diseqc_method;
 module_param(diseqc_method, int, 0444);
@@ -679,6 +681,63 @@ static void frontend_init(struct budget *budget)
 			}
 		}
 		break;
+
+	case 0x1020: { /* Omicom S2 */
+			struct stv6110x_devctl *ctl;
+			saa7146_setgpio(budget->dev, 2, SAA7146_GPIO_OUTLO);
+			msleep(50);
+			saa7146_setgpio(budget->dev, 2, SAA7146_GPIO_OUTHI);
+			msleep(250);
+
+			budget->dvb_frontend = dvb_attach(stv090x_attach,
+							  &tt1600_stv090x_config,
+							  &budget->i2c_adap,
+							  STV090x_DEMODULATOR_0);
+
+			if (budget->dvb_frontend) {
+				printk(KERN_INFO "budget: Omicom S2 detected\n");
+
+				ctl = dvb_attach(stv6110x_attach,
+						 budget->dvb_frontend,
+						 &tt1600_stv6110x_config,
+						 &budget->i2c_adap);
+
+				if (ctl) {
+					tt1600_stv090x_config.tuner_init	  = ctl->tuner_init;
+					tt1600_stv090x_config.tuner_sleep	  = ctl->tuner_sleep;
+					tt1600_stv090x_config.tuner_set_mode	  = ctl->tuner_set_mode;
+					tt1600_stv090x_config.tuner_set_frequency = ctl->tuner_set_frequency;
+					tt1600_stv090x_config.tuner_get_frequency = ctl->tuner_get_frequency;
+					tt1600_stv090x_config.tuner_set_bandwidth = ctl->tuner_set_bandwidth;
+					tt1600_stv090x_config.tuner_get_bandwidth = ctl->tuner_get_bandwidth;
+					tt1600_stv090x_config.tuner_set_bbgain	  = ctl->tuner_set_bbgain;
+					tt1600_stv090x_config.tuner_get_bbgain	  = ctl->tuner_get_bbgain;
+					tt1600_stv090x_config.tuner_set_refclk	  = ctl->tuner_set_refclk;
+					tt1600_stv090x_config.tuner_get_status	  = ctl->tuner_get_status;
+
+					/* call the init function once to initialize
+					   tuner's clock output divider and demod's
+					   master clock */
+					if (budget->dvb_frontend->ops.init)
+						budget->dvb_frontend->ops.init(budget->dvb_frontend);
+
+					if (dvb_attach(lnbh24_attach,
+							budget->dvb_frontend,
+							&budget->i2c_adap,
+							LNBH24_PCL | LNBH24_TTX,
+							LNBH24_TEN, 0x14>>1) == NULL)
+					{
+						printk(KERN_ERR
+						"No LNBH24 found!\n");
+						goto error_out;
+					}
+				} else {
+					printk(KERN_ERR "%s: No STV6110(A) Silicon Tuner found!\n", __func__);
+					goto error_out;
+				}
+			}
+		}
+		break;
 	}
 
 	if (budget->dvb_frontend == NULL) {
@@ -759,6 +818,7 @@ MAKE_BUDGET_INFO(fsacs0, "Fujitsu Siemens Activy Budget-S PCI (rev GR/grundig fr
 MAKE_BUDGET_INFO(fsacs1, "Fujitsu Siemens Activy Budget-S PCI (rev AL/alps frontend)", BUDGET_FS_ACTIVY);
 MAKE_BUDGET_INFO(fsact,	 "Fujitsu Siemens Activy Budget-T PCI (rev GR/Grundig frontend)", BUDGET_FS_ACTIVY);
 MAKE_BUDGET_INFO(fsact1, "Fujitsu Siemens Activy Budget-T PCI (rev AL/ALPS TDHD1-204A)", BUDGET_FS_ACTIVY);
+MAKE_BUDGET_INFO(omicom, "Omicom S2 PCI", BUDGET_TT);
 
 static struct pci_device_id pci_tbl[] = {
 	MAKE_EXTENSION_PCI(ttbs,  0x13c2, 0x1003),
@@ -772,6 +832,7 @@ static struct pci_device_id pci_tbl[] = {
 	MAKE_EXTENSION_PCI(fsacs0,0x1131, 0x4f61),
 	MAKE_EXTENSION_PCI(fsact1, 0x1131, 0x5f60),
 	MAKE_EXTENSION_PCI(fsact, 0x1131, 0x5f61),
+	MAKE_EXTENSION_PCI(omicom, 0x14c4, 0x1020),
 	{
 		.vendor    = 0,
 	}
