Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:42916 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751170AbdH0M0O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 08:26:14 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, xpert-reactos@gmx.de,
        Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH] cx23885: Explicitly list Hauppauge model numbers of HVR-4400 and HVR-5500
Date: Sun, 27 Aug 2017 14:26:07 +0200
Message-Id: <20170827122607.3738-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add two new model numbers to suppress this message in kernel log:
  cx23885: cx23885[0]: warning: unknown hauppauge model #121029

Add these model numbers:
* Model 121019 - WinTV-HVR4400
* Model 121029 - WinTV-HVR5500

For WinTV-HVR4400 the documentation and my hardware differ:

Documentation says it supports DVB-S/S2 and DVB-T,
but my hardware also supports DVB-C.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/pci/cx23885/cx23885-cards.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index c48fa8e25a70..78a8836d03e4 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -1278,6 +1278,12 @@ static void hauppauge_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
 	case 85721:
 		/* WinTV-HVR1290 (PCIe, OEM, RCA in, IR,
 			Dual channel ATSC and Basic analog */
+	case 121019:
+		/* WinTV-HVR4400 (PCIe, DVB-S2, DVB-C/T) */
+		break;
+	case 121029:
+		/* WinTV-HVR5500 (PCIe, DVB-S2, DVB-C/T) */
+		break;
 	case 150329:
 		/* WinTV-HVR5525 (PCIe, DVB-S/S2, DVB-T/T2/C) */
 		break;
-- 
2.14.1
