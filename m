Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:45328 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933753AbbDYPnl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 11:43:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/12] dt3155: move out of staging into drivers/media/pci
Date: Sat, 25 Apr 2015 17:42:51 +0200
Message-Id: <1429976571-34872-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
References: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The dt3155 code is now in good shape, so move it out of staging into
drivers/media/pci. Mark in MAINTAINERS that I'll do Odd Fixes for this
driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS                                                       | 8 ++++++++
 drivers/media/pci/Kconfig                                         | 1 +
 drivers/media/pci/Makefile                                        | 1 +
 drivers/{staging/media/dt3155v4l => media/pci/dt3155}/Kconfig     | 4 ++--
 drivers/media/pci/dt3155/Makefile                                 | 1 +
 .../media/dt3155v4l/dt3155v4l.c => media/pci/dt3155/dt3155.c}     | 2 +-
 .../media/dt3155v4l/dt3155v4l.h => media/pci/dt3155/dt3155.h}     | 4 ++--
 drivers/staging/media/Kconfig                                     | 2 --
 drivers/staging/media/Makefile                                    | 1 -
 drivers/staging/media/dt3155v4l/Makefile                          | 1 -
 10 files changed, 16 insertions(+), 9 deletions(-)
 rename drivers/{staging/media/dt3155v4l => media/pci/dt3155}/Kconfig (78%)
 create mode 100644 drivers/media/pci/dt3155/Makefile
 rename drivers/{staging/media/dt3155v4l/dt3155v4l.c => media/pci/dt3155/dt3155.c} (99%)
 rename drivers/{staging/media/dt3155v4l/dt3155v4l.h => media/pci/dt3155/dt3155.h} (99%)
 delete mode 100644 drivers/staging/media/dt3155v4l/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 30e7e38..a010eca 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3394,6 +3394,14 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wan/dscc4.c
 
+DT3155 MEDIA DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Odd Fixes
+F:	drivers/media/pci/dt3155/
+
 DVB_USB_AF9015 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index 218144a..fd359fb 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -21,6 +21,7 @@ source "drivers/media/pci/zoran/Kconfig"
 source "drivers/media/pci/saa7146/Kconfig"
 source "drivers/media/pci/solo6x10/Kconfig"
 source "drivers/media/pci/tw68/Kconfig"
+source "drivers/media/pci/dt3155/Kconfig"
 endif
 
 if MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index 0baf0d2..3471ab6 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_VIDEO_BT848) += bt8xx/
 obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
 obj-$(CONFIG_VIDEO_SAA7164) += saa7164/
 obj-$(CONFIG_VIDEO_TW68) += tw68/
+obj-$(CONFIG_VIDEO_DT3155) += dt3155/
 obj-$(CONFIG_VIDEO_MEYE) += meye/
 obj-$(CONFIG_STA2X11_VIP) += sta2x11/
 obj-$(CONFIG_VIDEO_SOLO6X10) += solo6x10/
diff --git a/drivers/staging/media/dt3155v4l/Kconfig b/drivers/media/pci/dt3155/Kconfig
similarity index 78%
rename from drivers/staging/media/dt3155v4l/Kconfig
rename to drivers/media/pci/dt3155/Kconfig
index fcbcba6..5145e0d 100644
--- a/drivers/staging/media/dt3155v4l/Kconfig
+++ b/drivers/media/pci/dt3155/Kconfig
@@ -1,5 +1,5 @@
 config VIDEO_DT3155
-	tristate "DT3155 frame grabber, Video4Linux interface"
+	tristate "DT3155 frame grabber"
 	depends on PCI && VIDEO_DEV && VIDEO_V4L2
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
@@ -10,4 +10,4 @@ config VIDEO_DT3155
 	  In doubt, say N.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called dt3155v4l.
+	  module will be called dt3155.
diff --git a/drivers/media/pci/dt3155/Makefile b/drivers/media/pci/dt3155/Makefile
new file mode 100644
index 0000000..89fa637
--- /dev/null
+++ b/drivers/media/pci/dt3155/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_DT3155)	+= dt3155.o
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/media/pci/dt3155/dt3155.c
similarity index 99%
rename from drivers/staging/media/dt3155v4l/dt3155v4l.c
rename to drivers/media/pci/dt3155/dt3155.c
index 43c9e0f..3131c2e 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -25,7 +25,7 @@
 #include <media/v4l2-common.h>
 #include <media/videobuf2-dma-contig.h>
 
-#include "dt3155v4l.h"
+#include "dt3155.h"
 
 #define DT3155_DEVICE_ID 0x1223
 
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.h b/drivers/media/pci/dt3155/dt3155.h
similarity index 99%
rename from drivers/staging/media/dt3155v4l/dt3155v4l.h
rename to drivers/media/pci/dt3155/dt3155.h
index bcf7b5e..4e1f4d5 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.h
+++ b/drivers/media/pci/dt3155/dt3155.h
@@ -24,8 +24,8 @@
 #include <media/v4l2-dev.h>
 
 #define DT3155_NAME "dt3155"
-#define DT3155_VER_MAJ 1
-#define DT3155_VER_MIN 1
+#define DT3155_VER_MAJ 2
+#define DT3155_VER_MIN 0
 #define DT3155_VER_EXT 0
 #define DT3155_VERSION  __stringify(DT3155_VER_MAJ)	"."		\
 			__stringify(DT3155_VER_MIN)	"."		\
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 96498b7..1469768 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -25,8 +25,6 @@ source "drivers/staging/media/cxd2099/Kconfig"
 
 source "drivers/staging/media/davinci_vpfe/Kconfig"
 
-source "drivers/staging/media/dt3155v4l/Kconfig"
-
 source "drivers/staging/media/mn88472/Kconfig"
 
 source "drivers/staging/media/mn88473/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index a9006bc..34c557b 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,7 +1,6 @@
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
-obj-$(CONFIG_VIDEO_DT3155)	+= dt3155v4l/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_DVB_MN88472)       += mn88472/
diff --git a/drivers/staging/media/dt3155v4l/Makefile b/drivers/staging/media/dt3155v4l/Makefile
deleted file mode 100644
index ce7a3ec..0000000
--- a/drivers/staging/media/dt3155v4l/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_VIDEO_DT3155)	+= dt3155v4l.o
-- 
2.1.4

