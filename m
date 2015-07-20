Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:36570 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbbGTSyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 14:54:04 -0400
Received: by qgy5 with SMTP id 5so77063547qgy.3
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2015 11:54:03 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] tw68: Move PCI vendor and device IDs to pci_ids.h
Date: Mon, 20 Jul 2015 15:49:55 -0300
Message-Id: <1437418195-2897-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commits moves the Intersil/Techwell PCI vendor ID, and
the device IDs for the TW68 PCI video capture cards.

This will allow to support future Intersil/Techwell devices
without duplicating the IDs.

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/pci/tw68/tw68-core.c | 15 ++++++++-------
 drivers/media/pci/tw68/tw68.h      | 16 ----------------
 include/linux/pci_ids.h            |  9 +++++++++
 3 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/media/pci/tw68/tw68-core.c b/drivers/media/pci/tw68/tw68-core.c
index c135165..93ebefd 100644
--- a/drivers/media/pci/tw68/tw68-core.c
+++ b/drivers/media/pci/tw68/tw68-core.c
@@ -37,6 +37,7 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/dma-mapping.h>
+#include <linux/pci_ids.h>
 #include <linux/pm.h>
 
 #include <media/v4l2-dev.h>
@@ -70,13 +71,13 @@ static atomic_t tw68_instance = ATOMIC_INIT(0);
  * added under vendor 0x1797 (Techwell Inc.) as subsystem IDs.
  */
 static const struct pci_device_id tw68_pci_tbl[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6800)},
-	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6801)},
-	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6804)},
-	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6816_1)},
-	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6816_2)},
-	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6816_3)},
-	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6816_4)},
+	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_TECHWELL_6800)},
+	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_TECHWELL_6801)},
+	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_TECHWELL_6804)},
+	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_TECHWELL_6816_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_TECHWELL_6816_2)},
+	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_TECHWELL_6816_3)},
+	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_TECHWELL_6816_4)},
 	{0,}
 };
 
diff --git a/drivers/media/pci/tw68/tw68.h b/drivers/media/pci/tw68/tw68.h
index 93f2335..ef51e4d 100644
--- a/drivers/media/pci/tw68/tw68.h
+++ b/drivers/media/pci/tw68/tw68.h
@@ -42,22 +42,6 @@
 
 #define	UNSET	(-1U)
 
-/* system vendor and device ID's */
-#define	PCI_VENDOR_ID_TECHWELL	0x1797
-#define	PCI_DEVICE_ID_6800	0x6800
-#define	PCI_DEVICE_ID_6801	0x6801
-#define	PCI_DEVICE_ID_AUDIO2	0x6802
-#define	PCI_DEVICE_ID_TS3	0x6803
-#define	PCI_DEVICE_ID_6804	0x6804
-#define	PCI_DEVICE_ID_AUDIO5	0x6805
-#define	PCI_DEVICE_ID_TS6	0x6806
-
-/* tw6816 based cards */
-#define	PCI_DEVICE_ID_6816_1   0x6810
-#define	PCI_DEVICE_ID_6816_2   0x6811
-#define	PCI_DEVICE_ID_6816_3   0x6812
-#define	PCI_DEVICE_ID_6816_4   0x6813
-
 #define TW68_NORMS ( \
 	V4L2_STD_NTSC    | V4L2_STD_PAL       | V4L2_STD_SECAM    | \
 	V4L2_STD_PAL_M   | V4L2_STD_PAL_Nc    | V4L2_STD_PAL_60)
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index fcff8f8..d9ba49c 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2332,6 +2332,15 @@
 
 #define PCI_VENDOR_ID_CAVIUM		0x177d
 
+#define PCI_VENDOR_ID_TECHWELL		0x1797
+#define PCI_DEVICE_ID_TECHWELL_6800	0x6800
+#define PCI_DEVICE_ID_TECHWELL_6801	0x6801
+#define PCI_DEVICE_ID_TECHWELL_6804	0x6804
+#define PCI_DEVICE_ID_TECHWELL_6816_1	0x6810
+#define PCI_DEVICE_ID_TECHWELL_6816_2	0x6811
+#define PCI_DEVICE_ID_TECHWELL_6816_3	0x6812
+#define PCI_DEVICE_ID_TECHWELL_6816_4	0x6813
+
 #define PCI_VENDOR_ID_BELKIN		0x1799
 #define PCI_DEVICE_ID_BELKIN_F5D7010V7	0x701f
 
-- 
2.4.3

