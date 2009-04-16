Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by mail.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <markus.o.hahn@gmx.de>) id 1LuWeM-0007ZR-Co
	for linux-dvb@linuxtv.org; Thu, 16 Apr 2009 20:49:27 +0200
Content-Type: multipart/mixed; boundary="========GMX31170123990773117447"
Date: Thu, 16 Apr 2009 20:48:51 +0200
From: "Markus Oliver Hahn" <markus.o.hahn@gmx.de>
In-Reply-To: <20090416090916.118390@gmx.net>
Message-ID: <20090416184851.311700@gmx.net>
MIME-Version: 1.0
References: <20090416090916.118390@gmx.net>
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] tt budget(_ci)  S2 - 1600
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--========GMX31170123990773117447
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

it seems the driver is running 
I just copied an pasted all from 
budget_ci.c to budget.c 


budget_core            18052  1 budget
saa7146                24584  2 budget,budget_core
ttpci_eeprom           10240  1 budget_core
dvb_core               94336  2 budget,budget_core
i2c_core               31892  7 i2c_dev,isl6423,stv6110x,stv090x,budget,budget_core,ttpci_eeprom


eading channels from file '/root/.szap/channels.conf'
zapping to 10 'MFTS E2E':
sat 0, frequency = 10861 MHz H, symbolrate 22000000, vpid = 0x0000, apid = 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal ff9c | snr 0000 | ber 0000000a | unc fffffffe |
status 1e | signal ff9c | snr 0000 | ber 0000000a | unc fffffffe | FE_HAS_LOCK
status 1e | signal ff9c | snr 0000 | ber 0000000a | unc fffffffe | FE_HAS_LOCK



patches attached 

cheers markus
-- 
Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonanschluss für nur 17,95 Euro/mtl.!* http://dslspecial.gmx.de/freedsl-surfflat/?ac=OM.AD.PD003K11308T4569a

--========GMX31170123990773117447
Content-Type: text/x-patch; charset="iso-8859-15"; name="budget.c.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="budget.c.diff"

--- budget.c.orig	2009-04-16 19:39:36.000000000 +0200
+++ budget.c	2009-04-16 20:04:31.000000000 +0200
@@ -47,6 +47,11 @@
 #include "bsru6.h"
 #include "bsbe1.h"
 #include "tdhd1.h"
+#include "stv6110x.h"
+#include "stv090x.h"
+#include "isl6423.h"
+
+
 
 static int diseqc_method;
 module_param(diseqc_method, int, 0444);
@@ -401,6 +406,49 @@
 }
 
 
+static struct stv090x_config tt1600_stv090x_config = {
+        .device                 = STV0903,
+        .demod_mode             = STV090x_SINGLE,
+        .clk_mode               = STV090x_CLK_EXT,
+
+        .xtal                   = 27000000,
+        .address                = 0x68,
+        .ref_clk                = 27000000,
+
+        .ts1_mode               = STV090x_TSMODE_PARALLEL_PUNCTURED,
+        .ts2_mode               = STV090x_TSMODE_SERIAL_PUNCTURED,
+
+        .repeater_level         = STV090x_RPTLEVEL_16,
+
+        .tuner_init             = NULL,
+        .tuner_set_mode         = NULL,
+        .tuner_set_frequency    = NULL,
+        .tuner_get_frequency    = NULL,
+        .tuner_set_bandwidth    = NULL,
+        .tuner_get_bandwidth    = NULL,
+        .tuner_set_bbgain       = NULL,
+        .tuner_get_bbgain       = NULL,
+        .tuner_set_refclk       = NULL,
+        .tuner_get_status       = NULL,
+};
+
+static struct stv6110x_config tt1600_stv6110x_config = {
+        .addr                   = 0x60,
+        .refclk                 = 27000000,
+};
+
+
+
+static struct isl6423_config tt1600_isl6423_config = {
+        .current_max            = SEC_CURRENT_515m,
+        .curlim                 = SEC_CURRENT_LIM_ON,
+        .mod_extern             = 1,
+        .addr                   = 0x08,
+};
+
+
+
+
 static int i2c_readreg(struct i2c_adapter *i2c, u8 adr, u8 reg)
 {
 	u8 val;
@@ -475,6 +523,50 @@
 		}
 		break;
 
+
+          case 0x101c: { /* TT S2-1600 */
+                        struct stv6110x_devctl *ctl;
+                        /* TODO! must verify with Andreas */
+                        saa7146_setgpio(budget->dev, 2, SAA7146_GPIO_OUTLO);
+                        msleep(50);
+                        saa7146_setgpio(budget->dev, 2, SAA7146_GPIO_OUTHI);
+                        msleep(250);
+
+                        budget->dvb_frontend = dvb_attach(stv090x_attach,
+                                                                    &tt1600_stv090x_config,
+                                                                    &budget->i2c_adap,
+                                                                    STV090x_DEMODULATOR_0);
+
+                        if (budget->dvb_frontend) {
+
+                                ctl = dvb_attach(stv6110x_attach,
+                                                 budget->dvb_frontend,
+                                                 &tt1600_stv6110x_config,
+                                                 &budget->i2c_adap);
+
+                                tt1600_stv090x_config.tuner_init          = ctl->tuner_init;
+                                tt1600_stv090x_config.tuner_set_mode      = ctl->tuner_set_mode;
+                                tt1600_stv090x_config.tuner_set_frequency = ctl->tuner_set_frequency;
+                                tt1600_stv090x_config.tuner_get_frequency = ctl->tuner_get_frequency;
+                                tt1600_stv090x_config.tuner_set_bandwidth = ctl->tuner_set_bandwidth;
+                                tt1600_stv090x_config.tuner_get_bandwidth = ctl->tuner_get_bandwidth;
+                                tt1600_stv090x_config.tuner_set_bbgain    = ctl->tuner_set_bbgain;
+                                tt1600_stv090x_config.tuner_get_bbgain    = ctl->tuner_get_bbgain;
+                                tt1600_stv090x_config.tuner_set_refclk    = ctl->tuner_set_refclk;
+                                tt1600_stv090x_config.tuner_get_status    = ctl->tuner_get_status;
+
+                                dvb_attach(isl6423_attach,
+                                        budget->dvb_frontend,
+                                        &budget->i2c_adap,
+                                        &tt1600_isl6423_config);
+
+                        } else {
+                                dvb_frontend_detach(budget->dvb_frontend);
+                                budget->dvb_frontend = NULL;
+                        }
+                }
+		break;
+
 	case 0x4f60: /* Fujitsu Siemens Activy Budget-S PCI rev AL (stv0299/tsa5059) */
 	{
 		int subtype = i2c_readreg(&budget->i2c_adap, 0x50, 0x67);
@@ -641,22 +733,24 @@
 MAKE_BUDGET_INFO(ttbt,	"TT-Budget/WinTV-NOVA-T  PCI",	BUDGET_TT);
 MAKE_BUDGET_INFO(satel,	"SATELCO Multimedia PCI",	BUDGET_TT_HW_DISEQC);
 MAKE_BUDGET_INFO(ttbs1401, "TT-Budget-S-1401 PCI", BUDGET_TT);
+MAKE_BUDGET_INFO(tt1600, "TT-Budget S2-1600 PCI", BUDGET_TT);
 MAKE_BUDGET_INFO(fsacs0, "Fujitsu Siemens Activy Budget-S PCI (rev GR/grundig frontend)", BUDGET_FS_ACTIVY);
 MAKE_BUDGET_INFO(fsacs1, "Fujitsu Siemens Activy Budget-S PCI (rev AL/alps frontend)", BUDGET_FS_ACTIVY);
 MAKE_BUDGET_INFO(fsact,	 "Fujitsu Siemens Activy Budget-T PCI (rev GR/Grundig frontend)", BUDGET_FS_ACTIVY);
 MAKE_BUDGET_INFO(fsact1, "Fujitsu Siemens Activy Budget-T PCI (rev AL/ALPS TDHD1-204A)", BUDGET_FS_ACTIVY);
 
 static struct pci_device_id pci_tbl[] = {
-	MAKE_EXTENSION_PCI(ttbs,  0x13c2, 0x1003),
-	MAKE_EXTENSION_PCI(ttbc,  0x13c2, 0x1004),
-	MAKE_EXTENSION_PCI(ttbt,  0x13c2, 0x1005),
-	MAKE_EXTENSION_PCI(satel, 0x13c2, 0x1013),
-	MAKE_EXTENSION_PCI(ttbs,  0x13c2, 0x1016),
-	MAKE_EXTENSION_PCI(ttbs1401, 0x13c2, 0x1018),
-	MAKE_EXTENSION_PCI(fsacs1,0x1131, 0x4f60),
-	MAKE_EXTENSION_PCI(fsacs0,0x1131, 0x4f61),
-	MAKE_EXTENSION_PCI(fsact1, 0x1131, 0x5f60),
-	MAKE_EXTENSION_PCI(fsact, 0x1131, 0x5f61),
+	MAKE_EXTENSION_PCI(ttbs,    0x13c2, 0x1003),
+	MAKE_EXTENSION_PCI(ttbc,    0x13c2, 0x1004),
+	MAKE_EXTENSION_PCI(ttbt,    0x13c2, 0x1005),
+	MAKE_EXTENSION_PCI(satel,   0x13c2, 0x1013),
+	MAKE_EXTENSION_PCI(ttbs,    0x13c2, 0x1016),
+ 	MAKE_EXTENSION_PCI(tt1600,  0x13c2, 0x101c),
+	MAKE_EXTENSION_PCI(ttbs1401,0x13c2, 0x1018),
+	MAKE_EXTENSION_PCI(fsacs1,  0x1131, 0x4f60),
+	MAKE_EXTENSION_PCI(fsacs0,  0x1131, 0x4f61),
+	MAKE_EXTENSION_PCI(fsact1,  0x1131, 0x5f60),
+	MAKE_EXTENSION_PCI(fsact,   0x1131, 0x5f61),
 	{
 		.vendor    = 0,
 	}

--========GMX31170123990773117447
Content-Type: text/x-patch; charset="iso-8859-15"; name="budget-ci.c.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="budget-ci.c.diff"

--- budget-ci.c.orig	2009-04-16 19:39:25.000000000 +0200
+++ budget-ci.c	2009-04-16 20:04:39.000000000 +0200
@@ -57,9 +57,12 @@
 #include "bsru6.h"
 #include "tda1002x.h"
 #include "tda827x.h"
+
+/*
 #include "stv6110x.h"
 #include "stv090x.h"
 #include "isl6423.h"
+*/ 
 
 /*
  * Regarding DEBIADDR_IR:
@@ -1357,6 +1360,7 @@
 	.refclock	= 27000000,
 };
 
+#if 0
 static struct stv090x_config tt1600_stv090x_config = {
 	.device			= STV0903,
 	.demod_mode		= STV090x_SINGLE,
@@ -1394,6 +1398,7 @@
 	.mod_extern		= 1,
 	.addr			= 0x08,
 };
+#endif 
 
 static void frontend_init(struct budget_ci *budget_ci)
 {
@@ -1514,6 +1519,7 @@
 		}
 		break;
 
+#if 0
 	case 0x101c: { /* TT S2-1600 */
 			struct stv6110x_devctl *ctl;
 			/* TODO! must verify with Andreas */
@@ -1556,6 +1562,7 @@
 			}
 		}
 		break;
+#endif 
 
 	}
 
@@ -1648,7 +1655,7 @@
 MAKE_BUDGET_INFO(ttbcci, "TT-Budget-C-CI PCI", BUDGET_TT);
 MAKE_BUDGET_INFO(ttc1501, "TT-Budget C-1501 PCI", BUDGET_TT);
 MAKE_BUDGET_INFO(tt3200, "TT-Budget S2-3200 PCI", BUDGET_TT);
-MAKE_BUDGET_INFO(tt1600, "TT-Budget S2-1600 PCI", BUDGET_TT);
+//MAKE_BUDGET_INFO(tt1600, "TT-Budget S2-1600 PCI", BUDGET_TT);
 
 static struct pci_device_id pci_tbl[] = {
 	MAKE_EXTENSION_PCI(ttbci, 0x13c2, 0x100c),
@@ -1659,7 +1666,7 @@
 	MAKE_EXTENSION_PCI(ttbs2, 0x13c2, 0x1017),
 	MAKE_EXTENSION_PCI(ttc1501, 0x13c2, 0x101a),
 	MAKE_EXTENSION_PCI(tt3200, 0x13c2, 0x1019),
-	MAKE_EXTENSION_PCI(tt1600, 0x13c2, 0x101c),
+	//MAKE_EXTENSION_PCI(tt1600, 0x13c2, 0x101c),
 	{
 	 .vendor = 0,
 	 }

--========GMX31170123990773117447
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--========GMX31170123990773117447--
