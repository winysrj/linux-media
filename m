Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61284 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764841Ab3DDVbQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Apr 2013 17:31:16 -0400
Received: from mailout-de.gmx.net ([10.1.76.35]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LxZpd-1Uhgz21MRX-017HaE for
 <linux-media@vger.kernel.org>; Thu, 04 Apr 2013 23:31:15 +0200
Message-ID: <515DF24C.2050000@gmx.de>
Date: Thu, 04 Apr 2013 23:36:12 +0200
From: Peter Wiese <peter.wiese@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] budget.c SAA7146 / BSRU6 additional SAT CARD support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Peter Wiese<peter.wiese@gmx.de>
Committer: Peter Wiese <peter.wiese@gmx.de>

modified:   drivers/media/pci/ttpci/budget.c

added support for Philips Semiconductor (now NXP) SAA7146
reference design DVB Sat card, using ALPS BSRU6 tuner
3 changes in budget.c driver to enable proper detection of the
card and load the tuner driver

---

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
     have the right to submit it under the open source license
     indicated in the file; or

(b) The contribution is based upon previous work that, to the best
     of my knowledge, is covered under an appropriate open source
     license and I have the right under that license to submit that
     work with modifications, whether created in whole or in part
     by me, under the same open source license (unless I am
     permitted to submit under a different license), as indicated
     in the file; or

(c) The contribution was provided directly to me by some other
     person who certified (a), (b) or (c) and I have not modified
     it.

(d) I understand and agree that this project and the contribution
     are public and that a record of the contribution (including all
     personal information I submit with it, including my sign-off) is
     maintained indefinitely and may be redistributed consistent with
     this project or the open source license(s) involved.

---
diff --git a/drivers/media/pci/ttpci/budget.c 
b/drivers/media/pci/ttpci/budget.c
index 7e6e43a..2a03bf0 100644
--- a/drivers/media/pci/ttpci/budget.c
+++ b/drivers/media/pci/ttpci/budget.c
@@ -13,6 +13,9 @@
   *           Oliver Endriss <o.endriss@gmx.de> and
   *           Andreas 'randy' Weinberger
   *
+ * 02mar2013 Support for Philips Semiconductors Sylt SAA7146 cards 
(Alps tuner)
+ *           Peter Wiese <peter.wiese@gmx.de>
+ *
   * This program is free software; you can redistribute it and/or
   * modify it under the terms of the GNU General Public License
   * as published by the Free Software Foundation; either version 2
@@ -537,6 +540,16 @@ static void frontend_init(struct budget *budget)
          }
          break;

+    case 0x4f52: /* Cards based on Philips Semi Sylt PCI ref. design */
+        budget->dvb_frontend = dvb_attach(stv0299_attach, 
&alps_bsru6_config, &budget->i2c_adap);
+        if (budget->dvb_frontend) {
+            printk(KERN_INFO "budget: tuner ALPS BSRU6 in Philips Semi. 
Sylt detected\n");
+            budget->dvb_frontend->ops.tuner_ops.set_params = 
alps_bsru6_tuner_set_params;
+            budget->dvb_frontend->tuner_priv = &budget->i2c_adap;
+            break;
+        }
+        break;
+
      case 0x4f60: /* Fujitsu Siemens Activy Budget-S PCI rev AL 
(stv0299/tsa5059) */
      {
          int subtype = i2c_readreg(&budget->i2c_adap, 0x50, 0x67);
@@ -818,6 +831,7 @@ MAKE_BUDGET_INFO(fsacs1, "Fujitsu Siemens Activy 
Budget-S PCI (rev AL/alps front
  MAKE_BUDGET_INFO(fsact,     "Fujitsu Siemens Activy Budget-T PCI (rev 
GR/Grundig frontend)", BUDGET_FS_ACTIVY);
  MAKE_BUDGET_INFO(fsact1, "Fujitsu Siemens Activy Budget-T PCI (rev 
AL/ALPS TDHD1-204A)", BUDGET_FS_ACTIVY);
  MAKE_BUDGET_INFO(omicom, "Omicom S2 PCI", BUDGET_TT);
+MAKE_BUDGET_INFO(sylt,    "Philips Semi Sylt PCI", BUDGET_TT_HW_DISEQC);

  static struct pci_device_id pci_tbl[] = {
      MAKE_EXTENSION_PCI(ttbs,  0x13c2, 0x1003),
@@ -832,6 +846,7 @@ static struct pci_device_id pci_tbl[] = {
      MAKE_EXTENSION_PCI(fsact1, 0x1131, 0x5f60),
      MAKE_EXTENSION_PCI(fsact, 0x1131, 0x5f61),
      MAKE_EXTENSION_PCI(omicom, 0x14c4, 0x1020),
+    MAKE_EXTENSION_PCI(sylt, 0x1131, 0x4f52),
      {
          .vendor    = 0,
      }
