Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [213.161.191.158] (helo=patton.snap.tv)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sigmund@snap.tv>) id 1K3sot-0005uF-3C
	for linux-dvb@linuxtv.org; Wed, 04 Jun 2008 15:14:27 +0200
Received: from [10.0.0.4] (89.80-203-124.nextgentel.com [80.203.124.89])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by patton.snap.tv (Postfix) with ESMTP id 7BB33F14006
	for <linux-dvb@linuxtv.org>; Wed,  4 Jun 2008 15:14:23 +0200 (CEST)
From: Sigmund Augdal <sigmund@snap.tv>
To: linux-dvb <linux-dvb@linuxtv.org>
Content-Type: multipart/mixed; boundary="=-xaiwaA8Vvk6Lkt5oepan"
Date: Wed, 04 Jun 2008 15:14:31 +0200
Message-Id: <1212585271.32385.41.camel@pascal>
Mime-Version: 1.0
Subject: [linux-dvb] [PATCH] experimental support for C-1501
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


--=-xaiwaA8Vvk6Lkt5oepan
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The following experimental patch adds support for the technotrend budget
C-1501 dvb-c card. The parameters used to configure the tda10023 demod
chip are largely determined experimentally, but works quite for me in my
initial tests.

Signed-Off-By: Sigmund Augdal <sigmund@snap.tv>

--=-xaiwaA8Vvk6Lkt5oepan
Content-Disposition: attachment; filename=c-1501.patch
Content-Type: text/x-patch; name=c-1501.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r 6541620a09b7 linux/drivers/media/dvb/ttpci/budget-ci.c
--- a/linux/drivers/media/dvb/ttpci/budget-ci.c	Tue Jun 03 10:32:16 2008 -0300
+++ b/linux/drivers/media/dvb/ttpci/budget-ci.c	Wed Jun 04 15:03:45 2008 +0200
@@ -46,6 +46,8 @@
 #include "lnbp21.h"
 #include "bsbe1.h"
 #include "bsru6.h"
+#include "tda1002x.h"
+#include "tda827x.h"
 
 /*
  * Regarding DEBIADDR_IR:
@@ -1069,6 +1071,32 @@
 
 
 
+static struct tda10023_config tda10023_config = {
+	.demod_address = 0xc,
+	.invert = 0,
+	.xtal = 16000000,
+	.pll_m = 11,
+	.pll_p = 3,
+	.pll_n = 1,
+	.deltaf = 0xA511,
+};
+
+static u8 read_pwm(struct budget_ci *budget_ci)
+{
+	u8 b = 0xff;
+	u8 pwm;
+	struct i2c_msg msg[] = { {.addr = 0x50,.flags = 0,.buf = &b,.len = 1},
+	{.addr = 0x50,.flags = I2C_M_RD,.buf = &pwm,.len = 1}
+	};
+
+	if ((i2c_transfer(&budget_ci->budget.i2c_adap, msg, 2) != 2)
+	    || (pwm == 0xff))
+		pwm = 0x48;
+
+	return pwm;
+}
+
+
 static void frontend_init(struct budget_ci *budget_ci)
 {
 	switch (budget_ci->budget.dev->pci->subsystem_device) {
@@ -1138,6 +1166,17 @@
 		}
 
 		break;
+	case 0x101a: // TT Budget-C-1501 (philips tda10023/philips tda8274A)
+		budget_ci->budget.dvb_frontend = dvb_attach(tda10023_attach,
+							    &tda10023_config, &budget_ci->budget.i2c_adap, read_pwm(budget_ci));
+		if (budget_ci->budget.dvb_frontend) {
+			if (dvb_attach(tda827x_attach, budget_ci->budget.dvb_frontend, 0x61,
+				       &budget_ci->budget.i2c_adap, 0) == NULL)
+				printk("%s: No tda827x found!\n", __FUNCTION__);
+			break;
+		}
+		break;
+         
 	}
 
 	if (budget_ci->budget.dvb_frontend == NULL) {
@@ -1226,6 +1265,7 @@
 MAKE_BUDGET_INFO(ttbt2, "TT-Budget/WinTV-NOVA-T	 PCI", BUDGET_TT);
 MAKE_BUDGET_INFO(ttbtci, "TT-Budget-T-CI PCI", BUDGET_TT);
 MAKE_BUDGET_INFO(ttbcci, "TT-Budget-C-CI PCI", BUDGET_TT);
+MAKE_BUDGET_INFO(ttc1501, "TT-Budget C-1501 PCI", BUDGET_TT);
 
 static struct pci_device_id pci_tbl[] = {
 	MAKE_EXTENSION_PCI(ttbci, 0x13c2, 0x100c),
@@ -1234,6 +1274,7 @@
 	MAKE_EXTENSION_PCI(ttbt2, 0x13c2, 0x1011),
 	MAKE_EXTENSION_PCI(ttbtci, 0x13c2, 0x1012),
 	MAKE_EXTENSION_PCI(ttbs2, 0x13c2, 0x1017),
+	MAKE_EXTENSION_PCI(ttc1501, 0x13c2, 0x101A),
 	{
 	 .vendor = 0,
 	 }

--=-xaiwaA8Vvk6Lkt5oepan
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-xaiwaA8Vvk6Lkt5oepan--
