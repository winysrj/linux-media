Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab2HTSWT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 14:22:19 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7KIMJT3031560
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 20 Aug 2012 14:22:19 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/6] [media] Kconfig: use menuconfig instead of menu
Date: Mon, 20 Aug 2012 15:22:14 -0300
Message-Id: <1345486935-18002-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345486935-18002-1-git-send-email-mchehab@redhat.com>
References: <1345486935-18002-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows disabling all drivers of a certain type as a hole

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/parport/Kconfig |  8 +++++---
 drivers/media/pci/Kconfig     | 11 +++++------
 drivers/media/usb/Kconfig     | 12 +++++-------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/media/parport/Kconfig b/drivers/media/parport/Kconfig
index 48138fe..a1c7853 100644
--- a/drivers/media/parport/Kconfig
+++ b/drivers/media/parport/Kconfig
@@ -1,6 +1,8 @@
-menu "V4L ISA and parallel port devices"
-	visible if (ISA || PARPORT) && MEDIA_CAMERA_SUPPORT
+menuconfig MEDIA_PARPORT_SUPPORT
+	bool "V4L ISA and parallel port devices"
+	depends on (ISA || PARPORT) && MEDIA_CAMERA_SUPPORT
 
+if MEDIA_PARPORT_SUPPORT
 config VIDEO_BWQCAM
 	tristate "Quickcam BW Video For Linux"
 	depends on PARPORT && VIDEO_V4L2
@@ -44,4 +46,4 @@ config VIDEO_W9966
 
 	  Check out <file:Documentation/video4linux/w9966.txt> for more
 	  information.
-endmenu
+endif
diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index 4243d5d..083b62f 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -1,9 +1,8 @@
-#
-# DVB device configuration
-#
+menuconfig MEDIA_PCI_SUPPORT
+	bool "Media PCI Adapters"
+	depends on PCI && MEDIA_SUPPORT
 
-menu "Media PCI Adapters"
-	visible if PCI && MEDIA_SUPPORT
+if MEDIA_PCI_SUPPORT
 
 if MEDIA_CAMERA_SUPPORT
 	comment "Media capture support"
@@ -42,4 +41,4 @@ source "drivers/media/pci/ngene/Kconfig"
 source "drivers/media/pci/ddbridge/Kconfig"
 endif
 
-endmenu
+endif #MEDIA_PCI_SUPPORT
diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index 069a3c1..f960e7ca4 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -1,9 +1,8 @@
-#
-# USB media device configuration
-#
+menuconfig MEDIA_USB_SUPPORT
+	bool "Media USB Adapters"
+	depends on USB && MEDIA_SUPPORT
 
-menu "Media USB Adapters"
-	visible if USB && MEDIA_SUPPORT
+if MEDIA_USB_SUPPORT
 
 if MEDIA_CAMERA_SUPPORT
 	comment "Webcam devices"
@@ -25,7 +24,6 @@ source "drivers/media/usb/hdpvr/Kconfig"
 source "drivers/media/usb/tlg2300/Kconfig"
 source "drivers/media/usb/usbvision/Kconfig"
 source "drivers/media/usb/stk1160/Kconfig"
-
 endif
 
 if (MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT)
@@ -50,4 +48,4 @@ if (MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT)
 source "drivers/media/usb/em28xx/Kconfig"
 endif
 
-endmenu
+endif #MEDIA_USB_SUPPORT
-- 
1.7.11.4

