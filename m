Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756872Ab2HULS0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 07:18:26 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7LBIPhd021184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 21 Aug 2012 07:18:25 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] Add missing help for some menuconfig items
Date: Tue, 21 Aug 2012 08:18:22 -0300
Message-Id: <1345547902-30846-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Help was missing during some items reorganization. Add them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/i2c/Kconfig     | 2 +-
 drivers/media/parport/Kconfig | 5 ++++-
 drivers/media/pci/Kconfig     | 3 +++
 drivers/media/usb/Kconfig     | 3 +++
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index d41dc0a..9a5a059 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -549,7 +549,7 @@ config VIDEO_M52790
 	 To compile this driver as a module, choose M here: the
 	 module will be called m52790.
 endmenu
-	 
+
 menu "Sensors used on soc_camera driver"
 
 if SOC_CAMERA
diff --git a/drivers/media/parport/Kconfig b/drivers/media/parport/Kconfig
index a1c7853..ece13dc 100644
--- a/drivers/media/parport/Kconfig
+++ b/drivers/media/parport/Kconfig
@@ -1,6 +1,9 @@
 menuconfig MEDIA_PARPORT_SUPPORT
-	bool "V4L ISA and parallel port devices"
+	bool "ISA and parallel port devices"
 	depends on (ISA || PARPORT) && MEDIA_CAMERA_SUPPORT
+	help
+	  Enables drivers for ISA and parallel port bus. If you
+	  need media drivers using those legacy buses, say Y.
 
 if MEDIA_PARPORT_SUPPORT
 config VIDEO_BWQCAM
diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index 083b62f..d4e2ed3 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -1,6 +1,9 @@
 menuconfig MEDIA_PCI_SUPPORT
 	bool "Media PCI Adapters"
 	depends on PCI && MEDIA_SUPPORT
+	help
+	  Enable media drivers for PCI/PCIe bus.
+	  If you have such devices, say Y.
 
 if MEDIA_PCI_SUPPORT
 
diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index f960e7ca4..6746994 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -1,6 +1,9 @@
 menuconfig MEDIA_USB_SUPPORT
 	bool "Media USB Adapters"
 	depends on USB && MEDIA_SUPPORT
+	help
+	  Enable media drivers for USB bus.
+	  If you have such devices, say Y.
 
 if MEDIA_USB_SUPPORT
 
-- 
1.7.11.4

