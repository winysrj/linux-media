Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:40880 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2DAPyG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 11:54:06 -0400
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Cc: "Steinar H. Gunderson" <sesse@samfundet.no>
Subject: [PATCH 11/11] Enable Mantis CA support.
Date: Sun,  1 Apr 2012 17:53:51 +0200
Message-Id: <1333295631-31866-11-git-send-email-sgunderson@bigfoot.com>
In-Reply-To: <20120401155330.GA31901@uio.no>
References: <20120401155330.GA31901@uio.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Steinar H. Gunderson" <sesse@samfundet.no>

Not my patch originally; picked up from verbal descriptions on
the linux-media list, and fixed up slightly.

Signed-off-by: Steinar H. Gunderson <sesse@samfundet.no>
---
 drivers/media/dvb/mantis/mantis_ca.c   |    4 +++-
 drivers/media/dvb/mantis/mantis_core.c |   20 --------------------
 drivers/media/dvb/mantis/mantis_dvb.c  |    4 +++-
 drivers/media/dvb/mantis/mantis_pci.c  |   23 +++++++++++++++++++++++
 drivers/media/dvb/mantis/mantis_pci.h  |    2 ++
 5 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_ca.c b/drivers/media/dvb/mantis/mantis_ca.c
index cdff4b7..cb3be63 100644
--- a/drivers/media/dvb/mantis/mantis_ca.c
+++ b/drivers/media/dvb/mantis/mantis_ca.c
@@ -34,6 +34,7 @@
 #include "mantis_link.h"
 #include "mantis_hif.h"
 #include "mantis_reg.h"
+#include "mantis_pci.h"
 
 #include "mantis_ca.h"
 
@@ -125,6 +126,7 @@ static int mantis_ca_slot_shutdown(struct dvb_ca_en50221 *en50221, int slot)
 	struct mantis_pci *mantis = ca->ca_priv;
 
 	dprintk(MANTIS_DEBUG, 1, "Slot(%d): Slot shutdown", slot);
+	mantis_set_direction(mantis, 0);  /* Disable TS through CAM */
 
 	return 0;
 }
@@ -135,7 +137,7 @@ static int mantis_ts_control(struct dvb_ca_en50221 *en50221, int slot)
 	struct mantis_pci *mantis = ca->ca_priv;
 
 	dprintk(MANTIS_DEBUG, 1, "Slot(%d): TS control", slot);
-/*	mantis_set_direction(mantis, 1); */ /* Enable TS through CAM */
+	mantis_set_direction(mantis, 1);  /* Enable TS through CAM */
 
 	return 0;
 }
diff --git a/drivers/media/dvb/mantis/mantis_core.c b/drivers/media/dvb/mantis/mantis_core.c
index 22524a8..2efacac 100644
--- a/drivers/media/dvb/mantis/mantis_core.c
+++ b/drivers/media/dvb/mantis/mantis_core.c
@@ -213,23 +213,3 @@ void gpio_set_bits(struct mantis_pci *mantis, u32 bitpos, u8 value)
 	udelay(100);
 }
 
-/* direction = 0 , no CI passthrough ; 1 , CI passthrough */
-void mantis_set_direction(struct mantis_pci *mantis, int direction)
-{
-	u32 reg;
-
-	reg = mmread(0x28);
-	dprintk(verbose, MANTIS_DEBUG, 1, "TS direction setup");
-	if (direction == 0x01) {
-		/* to CI */
-		reg |= 0x04;
-		mmwrite(reg, 0x28);
-		reg &= 0xff - 0x04;
-		mmwrite(reg, 0x28);
-	} else {
-		reg &= 0xff - 0x04;
-		mmwrite(reg, 0x28);
-		reg |= 0x04;
-		mmwrite(reg, 0x28);
-	}
-}
diff --git a/drivers/media/dvb/mantis/mantis_dvb.c b/drivers/media/dvb/mantis/mantis_dvb.c
index e5180e4..8c38c0b 100644
--- a/drivers/media/dvb/mantis/mantis_dvb.c
+++ b/drivers/media/dvb/mantis/mantis_dvb.c
@@ -239,6 +239,8 @@ int __devinit mantis_dvb_init(struct mantis_pci *mantis)
 				mantis->fe = NULL;
 				goto err5;
 			}
+
+			mantis_ca_init(mantis);
 		}
 	}
 
@@ -274,7 +276,6 @@ int __devexit mantis_dvb_exit(struct mantis_pci *mantis)
 	int err;
 
 	if (mantis->fe) {
-		/* mantis_ca_exit(mantis); */
 		err = mantis_frontend_shutdown(mantis);
 		if (err != 0)
 			dprintk(MANTIS_ERROR, 1, "Frontend exit while POWER ON! <%d>", err);
@@ -282,6 +283,7 @@ int __devexit mantis_dvb_exit(struct mantis_pci *mantis)
 		dvb_frontend_detach(mantis->fe);
 	}
 
+	mantis_ca_exit(mantis);
 	tasklet_kill(&mantis->tasklet);
 	dvb_net_release(&mantis->dvbnet);
 
diff --git a/drivers/media/dvb/mantis/mantis_pci.c b/drivers/media/dvb/mantis/mantis_pci.c
index 371558a..9c60240 100644
--- a/drivers/media/dvb/mantis/mantis_pci.c
+++ b/drivers/media/dvb/mantis/mantis_pci.c
@@ -97,6 +97,7 @@ int __devinit mantis_pci_init(struct mantis_pci *mantis)
 	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &latency);
 	mantis->latency = latency;
 	mantis->revision = pdev->revision;
+	mantis_set_direction(mantis, 0);
 
 	dprintk(MANTIS_ERROR, 0, "    Mantis Rev %d [%04x:%04x], ",
 		mantis->revision,
@@ -110,6 +111,7 @@ int __devinit mantis_pci_init(struct mantis_pci *mantis)
 		mantis->mantis_addr,
 		mantis->mmio);
 
+	mmwrite(0x00, MANTIS_INT_MASK);
 	err = request_irq(pdev->irq,
 			  config->irq_handler,
 			  IRQF_SHARED,
@@ -165,6 +167,27 @@ void mantis_pci_exit(struct mantis_pci *mantis)
 }
 EXPORT_SYMBOL_GPL(mantis_pci_exit);
 
+/* direction = 0 , no CI passthrough ; 1 , CI passthrough */
+void mantis_set_direction(struct mantis_pci *mantis, int direction)
+{
+	u32 reg;
+
+	reg = mmread(0x28);
+	dprintk(MANTIS_DEBUG, 1, "TS direction setup");
+	if (direction == 0x01) {
+		/* to CI */
+		reg |= 0x04;
+		mmwrite(reg, 0x28);
+		reg &= 0xff - 0x04;
+		mmwrite(reg, 0x28);
+	} else {
+		reg &= 0xff - 0x04;
+		mmwrite(reg, 0x28);
+		reg |= 0x04;
+		mmwrite(reg, 0x28);
+	}
+}
+
 MODULE_DESCRIPTION("Mantis PCI DTV bridge driver");
 MODULE_AUTHOR("Manu Abraham");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/mantis/mantis_pci.h b/drivers/media/dvb/mantis/mantis_pci.h
index 65f0045..37c0672 100644
--- a/drivers/media/dvb/mantis/mantis_pci.h
+++ b/drivers/media/dvb/mantis/mantis_pci.h
@@ -24,4 +24,6 @@
 extern int mantis_pci_init(struct mantis_pci *mantis);
 extern void mantis_pci_exit(struct mantis_pci *mantis);
 
+void mantis_set_direction(struct mantis_pci *mantis, int direction);
+
 #endif /* __MANTIS_PCI_H */
-- 
1.7.9.5

