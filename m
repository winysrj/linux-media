Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:43697 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753528Ab1C2Ujm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 16:39:42 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: linux-media@vger.kernel.org
Subject: [PATCH] budget-ci: Add support for TT S-1500 with BSBE1-D01A tuner
Date: Tue, 29 Mar 2011 22:37:00 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103292237.00915@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add support for TT S-1500 with BSBE1-D01A tuner.

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/media/dvb/frontends/bsbe1-d01a.h |  146 ++++++++++++++++++++++++++++++
 drivers/media/dvb/ttpci/Kconfig          |    2 +
 drivers/media/dvb/ttpci/budget-ci.c      |   21 +++++
 3 files changed, 169 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/bsbe1-d01a.h

diff --git a/drivers/media/dvb/frontends/bsbe1-d01a.h b/drivers/media/dvb/frontends/bsbe1-d01a.h
new file mode 100644
index 0000000..7ed3c42
--- /dev/null
+++ b/drivers/media/dvb/frontends/bsbe1-d01a.h
@@ -0,0 +1,146 @@
+/*
+ * bsbe1-d01a.h - ALPS BSBE1-D01A tuner support
+ *
+ * Copyright (C) 2011 Oliver Endriss <o.endriss@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
+ *
+ *
+ * the project's page is at http://www.linuxtv.org
+ */
+
+#ifndef BSBE1_D01A_H
+#define BSBE1_D01A_H
+
+#include "stb6000.h"
+#include "stv0288.h"
+
+static u8 stv0288_bsbe1_d01a_inittab[] = {
+	0x01, 0x15,
+	0x02, 0x20,
+	0x09, 0x0,
+	0x0a, 0x4,
+	0x0b, 0x0,
+	0x0c, 0x0,
+	0x0d, 0x0,
+	0x0e, 0xd4,
+	0x0f, 0x30,
+	0x11, 0x80,
+	0x12, 0x03,
+	0x13, 0x48,
+	0x14, 0x84,
+	0x15, 0x45,
+	0x16, 0xb7,
+	0x17, 0x9c,
+	0x18, 0x0,
+	0x19, 0xa6,
+	0x1a, 0x88,
+	0x1b, 0x8f,
+	0x1c, 0xf0,
+	0x20, 0x0b,
+	0x21, 0x54,
+	0x22, 0x0,
+	0x23, 0x0,
+	0x2b, 0xff,
+	0x2c, 0xf7,
+	0x30, 0x0,
+	0x31, 0x1e,
+	0x32, 0x14,
+	0x33, 0x0f,
+	0x34, 0x09,
+	0x35, 0x0c,
+	0x36, 0x05,
+	0x37, 0x2f,
+	0x38, 0x16,
+	0x39, 0xbd,
+	0x3a, 0x03,
+	0x3b, 0x13,
+	0x3c, 0x11,
+	0x3d, 0x30,
+	0x40, 0x63,
+	0x41, 0x04,
+	0x42, 0x60,
+	0x43, 0x00,
+	0x44, 0x00,
+	0x45, 0x00,
+	0x46, 0x00,
+	0x47, 0x00,
+	0x4a, 0x00,
+	0x50, 0x10,
+	0x51, 0x36,
+	0x52, 0x09,
+	0x53, 0x94,
+	0x54, 0x62,
+	0x55, 0x29,
+	0x56, 0x64,
+	0x57, 0x2b,
+	0x58, 0x54,
+	0x59, 0x86,
+	0x5a, 0x0,
+	0x5b, 0x9b,
+	0x5c, 0x08,
+	0x5d, 0x7f,
+	0x5e, 0x0,
+	0x5f, 0xff,
+	0x70, 0x0,
+	0x71, 0x0,
+	0x72, 0x0,
+	0x74, 0x0,
+	0x75, 0x0,
+	0x76, 0x0,
+	0x81, 0x0,
+	0x82, 0x3f,
+	0x83, 0x3f,
+	0x84, 0x0,
+	0x85, 0x0,
+	0x88, 0x0,
+	0x89, 0x0,
+	0x8a, 0x0,
+	0x8b, 0x0,
+	0x8c, 0x0,
+	0x90, 0x0,
+	0x91, 0x0,
+	0x92, 0x0,
+	0x93, 0x0,
+	0x94, 0x1c,
+	0x97, 0x0,
+	0xa0, 0x48,
+	0xa1, 0x0,
+	0xb0, 0xb8,
+	0xb1, 0x3a,
+	0xb2, 0x10,
+	0xb3, 0x82,
+	0xb4, 0x80,
+	0xb5, 0x82,
+	0xb6, 0x82,
+	0xb7, 0x82,
+	0xb8, 0x20,
+	0xb9, 0x0,
+	0xf0, 0x0,
+	0xf1, 0x0,
+	0xf2, 0xc0,
+	0xff, 0xff,
+};
+
+static struct stv0288_config stv0288_bsbe1_d01a_config = {
+	.demod_address = 0x68,
+	.min_delay_ms = 100,
+	.inittab = stv0288_bsbe1_d01a_inittab,
+};
+
+#endif
diff --git a/drivers/media/dvb/ttpci/Kconfig b/drivers/media/dvb/ttpci/Kconfig
index 44afab2..9d83ced 100644
--- a/drivers/media/dvb/ttpci/Kconfig
+++ b/drivers/media/dvb/ttpci/Kconfig
@@ -95,6 +95,8 @@ config DVB_BUDGET_CI
 	select DVB_STB0899 if !DVB_FE_CUSTOMISE
 	select DVB_STB6100 if !DVB_FE_CUSTOMISE
 	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
+	select DVB_STV0288 if !DVB_FE_CUSTOMISE
+	select DVB_STB6000 if !DVB_FE_CUSTOMISE
 	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_TDA827X if !MEDIA_TUNER_CUSTOMISE
 	depends on RC_CORE
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 1d79ada..926f299 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -52,6 +52,7 @@
 #include "bsru6.h"
 #include "tda1002x.h"
 #include "tda827x.h"
+#include "bsbe1-d01a.h"
 
 #define MODULE_NAME "budget_ci"
 
@@ -224,6 +225,7 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	case 0x1017:
 	case 0x1019:
 	case 0x101a:
+	case 0x101b:
 		/* for the Technotrend 1500 bundled remote */
 		dev->map_name = RC_MAP_TT_1500;
 		break;
@@ -1388,6 +1390,23 @@ static void frontend_init(struct budget_ci *budget_ci)
 		}
 		break;
 
+	case 0x101b: /* TT S-1500B (BSBE1-D01A - STV0288/STB6000/LNBP21) */
+		budget_ci->budget.dvb_frontend = dvb_attach(stv0288_attach, &stv0288_bsbe1_d01a_config, &budget_ci->budget.i2c_adap);
+		if (budget_ci->budget.dvb_frontend) {
+			if (dvb_attach(stb6000_attach, budget_ci->budget.dvb_frontend, 0x63, &budget_ci->budget.i2c_adap)) {
+				if (!dvb_attach(lnbp21_attach, budget_ci->budget.dvb_frontend, &budget_ci->budget.i2c_adap, 0, 0)) {
+					printk(KERN_ERR "%s: No LNBP21 found!\n", __func__);
+					dvb_frontend_detach(budget_ci->budget.dvb_frontend);
+					budget_ci->budget.dvb_frontend = NULL;
+				}
+			} else {
+				printk(KERN_ERR "%s: No STB6000 found!\n", __func__);
+				dvb_frontend_detach(budget_ci->budget.dvb_frontend);
+				budget_ci->budget.dvb_frontend = NULL;
+			}
+		}
+		break;
+
 	case 0x1019:		// TT S2-3200 PCI
 		/*
 		 * NOTE! on some STB0899 versions, the internal PLL takes a longer time
@@ -1518,6 +1537,7 @@ MAKE_BUDGET_INFO(ttbtci, "TT-Budget-T-CI PCI", BUDGET_TT);
 MAKE_BUDGET_INFO(ttbcci, "TT-Budget-C-CI PCI", BUDGET_TT);
 MAKE_BUDGET_INFO(ttc1501, "TT-Budget C-1501 PCI", BUDGET_TT);
 MAKE_BUDGET_INFO(tt3200, "TT-Budget S2-3200 PCI", BUDGET_TT);
+MAKE_BUDGET_INFO(ttbs1500b, "TT-Budget S-1500B PCI", BUDGET_TT);
 
 static struct pci_device_id pci_tbl[] = {
 	MAKE_EXTENSION_PCI(ttbci, 0x13c2, 0x100c),
@@ -1528,6 +1548,7 @@ static struct pci_device_id pci_tbl[] = {
 	MAKE_EXTENSION_PCI(ttbs2, 0x13c2, 0x1017),
 	MAKE_EXTENSION_PCI(ttc1501, 0x13c2, 0x101a),
 	MAKE_EXTENSION_PCI(tt3200, 0x13c2, 0x1019),
+	MAKE_EXTENSION_PCI(ttbs1500b, 0x13c2, 0x101b),
 	{
 	 .vendor = 0,
 	 }
-- 
1.6.5.3

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
