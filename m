Return-path: <linux-media-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1441 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbZFYFNn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 01:13:43 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stelian Pop <stelian@popies.net>, linux-media@vger.kernel.org
Subject: [PATCH 06/19] drivers/media: Use PCI_VDEVICE
Date: Wed, 24 Jun 2009 22:13:22 -0700
Message-Id: <1ddf60bd631911577e0b075b6457e39ec87416ae.1245906152.git.joe@perches.com>
In-Reply-To: <cover.1245906151.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/bt8xx/bttv-driver.c |   12 ++++--------
 drivers/media/video/meye.c              |    3 +--
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 5eb1464..d8d3e1d 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -4591,14 +4591,10 @@ static int bttv_resume(struct pci_dev *pci_dev)
 #endif
 
 static struct pci_device_id bttv_pci_tbl[] = {
-	{PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT848,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT849,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT878,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT879,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VDEVICE(BROOKTREE, PCI_DEVICE_ID_BT848), 0},
+	{PCI_VDEVICE(BROOKTREE, PCI_DEVICE_ID_BT849), 0},
+	{PCI_VDEVICE(BROOKTREE, PCI_DEVICE_ID_BT878), 0},
+	{PCI_VDEVICE(BROOKTREE, PCI_DEVICE_ID_BT879), 0},
 	{0,}
 };
 
diff --git a/drivers/media/video/meye.c b/drivers/media/video/meye.c
index 1d66855..d0765be 100644
--- a/drivers/media/video/meye.c
+++ b/drivers/media/video/meye.c
@@ -1915,8 +1915,7 @@ static void __devexit meye_remove(struct pci_dev *pcidev)
 }
 
 static struct pci_device_id meye_pci_tbl[] = {
-	{ PCI_VENDOR_ID_KAWASAKI, PCI_DEVICE_ID_MCHIP_KL5A72002,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VDEVICE(KAWASAKI, PCI_DEVICE_ID_MCHIP_KL5A72002), 0 },
 	{ }
 };
 
-- 
1.6.3.1.10.g659a0.dirty

