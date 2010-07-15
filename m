Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47905 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934317Ab0GOTIg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jul 2010 15:08:36 -0400
From: Peter Huewe <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 24/25] video/ivtv: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 21:08:26 +0200
Cc: Andy Walls <awalls@md.metrocast.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ian Armstrong <ian@iarmst.demon.co.uk>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	Steven Toth <stoth@kernellabs.com>, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152108.27175.PeterHuewe@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Huewe <peterhuewe@gmx.de>

This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
.subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
PCI_VDEVICE macro, and thus improves readability.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/media/video/ivtv/ivtv-driver.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 90daa6e..8e73ab9 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -69,10 +69,8 @@ int ivtv_first_minor;
 
 /* add your revision and whatnot here */
 static struct pci_device_id ivtv_pci_tbl[] __devinitdata = {
-	{PCI_VENDOR_ID_ICOMP, PCI_DEVICE_ID_IVTV15,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_ICOMP, PCI_DEVICE_ID_IVTV16,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VDEVICE(ICOMP, PCI_DEVICE_ID_IVTV15), 0},
+	{PCI_VDEVICE(ICOMP, PCI_DEVICE_ID_IVTV16), 0},
 	{0,}
 };
 
-- 
1.7.1

