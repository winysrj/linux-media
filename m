Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab2HONsZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 09:48:25 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7FDmPbi004119
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 09:48:25 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/12] [media] move the remaining PCI devices to drivers/media/pci
Date: Wed, 15 Aug 2012 10:48:14 -0300
Message-Id: <1345038500-28734-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345038500-28734-1-git-send-email-mchehab@redhat.com>
References: <502AC079.50902@gmail.com>
 <1345038500-28734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move meye and sta2x11_vip into the drivers/media/pci subdirs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/Kconfig                          |  6 +++
 drivers/media/pci/Makefile                         |  2 +
 drivers/media/pci/meye/Kconfig                     | 13 +++++++
 drivers/media/pci/meye/Makefile                    |  1 +
 drivers/media/{video => pci/meye}/meye.c           |  0
 drivers/media/{video => pci/meye}/meye.h           |  0
 drivers/media/pci/sta2x11/Kconfig                  | 12 ++++++
 drivers/media/pci/sta2x11/Makefile                 |  1 +
 drivers/media/{video => pci/sta2x11}/sta2x11_vip.c |  0
 drivers/media/{video => pci/sta2x11}/sta2x11_vip.h |  0
 drivers/media/video/Kconfig                        | 45 ----------------------
 drivers/media/video/Makefile                       |  2 -
 12 files changed, 35 insertions(+), 47 deletions(-)
 create mode 100644 drivers/media/pci/meye/Kconfig
 create mode 100644 drivers/media/pci/meye/Makefile
 rename drivers/media/{video => pci/meye}/meye.c (100%)
 rename drivers/media/{video => pci/meye}/meye.h (100%)
 create mode 100644 drivers/media/pci/sta2x11/Kconfig
 create mode 100644 drivers/media/pci/sta2x11/Makefile
 rename drivers/media/{video => pci/sta2x11}/sta2x11_vip.c (100%)
 rename drivers/media/{video => pci/sta2x11}/sta2x11_vip.h (100%)

diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index e1a9e1a..4243d5d 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -5,6 +5,12 @@
 menu "Media PCI Adapters"
 	visible if PCI && MEDIA_SUPPORT
 
+if MEDIA_CAMERA_SUPPORT
+	comment "Media capture support"
+source "drivers/media/pci/meye/Kconfig"
+source "drivers/media/pci/sta2x11/Kconfig"
+endif
+
 if MEDIA_ANALOG_TV_SUPPORT
 	comment "Media capture/analog TV support"
 source "drivers/media/pci/ivtv/Kconfig"
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index bb71e30..c8dc6c7 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -22,3 +22,5 @@ obj-$(CONFIG_VIDEO_CX88) += cx88/
 obj-$(CONFIG_VIDEO_BT848) += bt8xx/
 obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
 obj-$(CONFIG_VIDEO_SAA7164) += saa7164/
+obj-$(CONFIG_VIDEO_MEYE) += meye/
+obj-$(CONFIG_STA2X11_VIP) += sta2x11/
diff --git a/drivers/media/pci/meye/Kconfig b/drivers/media/pci/meye/Kconfig
new file mode 100644
index 0000000..b4bf848
--- /dev/null
+++ b/drivers/media/pci/meye/Kconfig
@@ -0,0 +1,13 @@
+config VIDEO_MEYE
+	tristate "Sony Vaio Picturebook Motion Eye Video For Linux"
+	depends on PCI && SONY_LAPTOP && VIDEO_V4L2
+	---help---
+	  This is the video4linux driver for the Motion Eye camera found
+	  in the Vaio Picturebook laptops. Please read the material in
+	  <file:Documentation/video4linux/meye.txt> for more information.
+
+	  If you say Y or M here, you need to say Y or M to "Sony Laptop
+	  Extras" in the misc device section.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called meye.
diff --git a/drivers/media/pci/meye/Makefile b/drivers/media/pci/meye/Makefile
new file mode 100644
index 0000000..4938851
--- /dev/null
+++ b/drivers/media/pci/meye/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_MEYE) += meye.o
diff --git a/drivers/media/video/meye.c b/drivers/media/pci/meye/meye.c
similarity index 100%
rename from drivers/media/video/meye.c
rename to drivers/media/pci/meye/meye.c
diff --git a/drivers/media/video/meye.h b/drivers/media/pci/meye/meye.h
similarity index 100%
rename from drivers/media/video/meye.h
rename to drivers/media/pci/meye/meye.h
diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
new file mode 100644
index 0000000..04a82cb
--- /dev/null
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -0,0 +1,12 @@
+config STA2X11_VIP
+	tristate "STA2X11 VIP Video For Linux"
+	depends on STA2X11
+	select VIDEO_ADV7180 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEOBUF_DMA_CONTIG
+	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
+	help
+	  Say Y for support for STA2X11 VIP (Video Input Port) capture
+	  device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sta2x11_vip.
diff --git a/drivers/media/pci/sta2x11/Makefile b/drivers/media/pci/sta2x11/Makefile
new file mode 100644
index 0000000..d6c471d
--- /dev/null
+++ b/drivers/media/pci/sta2x11/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_STA2X11_VIP) += sta2x11_vip.o
diff --git a/drivers/media/video/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
similarity index 100%
rename from drivers/media/video/sta2x11_vip.c
rename to drivers/media/pci/sta2x11/sta2x11_vip.c
diff --git a/drivers/media/video/sta2x11_vip.h b/drivers/media/pci/sta2x11/sta2x11_vip.h
similarity index 100%
rename from drivers/media/video/sta2x11_vip.h
rename to drivers/media/pci/sta2x11/sta2x11_vip.h
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 4d79dfd..d545d93 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -606,51 +606,6 @@ config VIDEO_VIVI
 	  In doubt, say N.
 
 #
-# PCI drivers configuration - No devices here are for webcams
-#
-
-menuconfig V4L_PCI_DRIVERS
-	bool "V4L PCI(e) devices"
-	depends on PCI
-	depends on MEDIA_ANALOG_TV_SUPPORT
-	default y
-	---help---
-	  Say Y here to enable support for these PCI(e) drivers.
-
-if V4L_PCI_DRIVERS
-
-config VIDEO_MEYE
-	tristate "Sony Vaio Picturebook Motion Eye Video For Linux"
-	depends on PCI && SONY_LAPTOP && VIDEO_V4L2
-	---help---
-	  This is the video4linux driver for the Motion Eye camera found
-	  in the Vaio Picturebook laptops. Please read the material in
-	  <file:Documentation/video4linux/meye.txt> for more information.
-
-	  If you say Y or M here, you need to say Y or M to "Sony Laptop
-	  Extras" in the misc device section.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called meye.
-
-
-
-config STA2X11_VIP
-	tristate "STA2X11 VIP Video For Linux"
-	depends on STA2X11
-	select VIDEO_ADV7180 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEOBUF_DMA_CONTIG
-	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
-	help
-	  Say Y for support for STA2X11 VIP (Video Input Port) capture
-	  device.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called sta2x11_vip.
-
-endif # V4L_PCI_DRIVERS
-
-#
 # ISA & parallel port drivers configuration
 #	All devices here are webcam or grabber devices
 #
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 8df694d..f212af3 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -92,8 +92,6 @@ obj-$(CONFIG_VIDEO_BWQCAM) += bw-qcam.o
 obj-$(CONFIG_VIDEO_W9966) += w9966.o
 obj-$(CONFIG_VIDEO_PMS) += pms.o
 obj-$(CONFIG_VIDEO_VINO) += vino.o
-obj-$(CONFIG_VIDEO_MEYE) += meye.o
-obj-$(CONFIG_STA2X11_VIP) += sta2x11_vip.o
 obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
 
 obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
-- 
1.7.11.2

