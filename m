Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:49419 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750950AbeEKQoC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 12:44:02 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        MJPEG-tools user list <mjpeg-users@lists.sourceforge.net>,
        Bernhard Praschinger <shadowlord@utanet.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] zoran: move to staging in preparation for removal
Message-ID: <88277632-a786-ca2e-4cee-f6cdb419dff7@xs4all.nl>
Date: Fri, 11 May 2018 18:43:57 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver hasn't been tested in a long, long time. The hardware is
ancient and pretty much obsolete. This driver also needs to be converted
to newer media frameworks (vb2!) but due to the lack of time and interest
that is unlikely to happen.

So this driver is a prime candidate for removal. If someone is interested
in working on this driver to prevent its removal, then please contact the
linux-media mailinglist.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS                                               | 2 +-
 drivers/media/pci/Kconfig                                 | 1 -
 drivers/media/pci/Makefile                                | 1 -
 drivers/staging/media/Kconfig                             | 2 ++
 drivers/staging/media/Makefile                            | 1 +
 drivers/{media/pci => staging/media}/zoran/Kconfig        | 2 +-
 drivers/{media/pci => staging/media}/zoran/Makefile       | 0
 drivers/staging/media/zoran/TODO                          | 4 ++++
 drivers/{media/pci => staging/media}/zoran/videocodec.c   | 0
 drivers/{media/pci => staging/media}/zoran/videocodec.h   | 0
 drivers/{media/pci => staging/media}/zoran/zoran.h        | 0
 drivers/{media/pci => staging/media}/zoran/zoran_card.c   | 0
 drivers/{media/pci => staging/media}/zoran/zoran_card.h   | 0
 drivers/{media/pci => staging/media}/zoran/zoran_device.c | 0
 drivers/{media/pci => staging/media}/zoran/zoran_device.h | 0
 drivers/{media/pci => staging/media}/zoran/zoran_driver.c | 0
 drivers/{media/pci => staging/media}/zoran/zoran_procfs.c | 0
 drivers/{media/pci => staging/media}/zoran/zoran_procfs.h | 0
 drivers/{media/pci => staging/media}/zoran/zr36016.c      | 0
 drivers/{media/pci => staging/media}/zoran/zr36016.h      | 0
 drivers/{media/pci => staging/media}/zoran/zr36050.c      | 0
 drivers/{media/pci => staging/media}/zoran/zr36050.h      | 0
 drivers/{media/pci => staging/media}/zoran/zr36057.h      | 0
 drivers/{media/pci => staging/media}/zoran/zr36060.c      | 0
 drivers/{media/pci => staging/media}/zoran/zr36060.h      | 0
 25 files changed, 9 insertions(+), 4 deletions(-)
 rename drivers/{media/pci => staging/media}/zoran/Kconfig (97%)
 rename drivers/{media/pci => staging/media}/zoran/Makefile (100%)
 create mode 100644 drivers/staging/media/zoran/TODO
 rename drivers/{media/pci => staging/media}/zoran/videocodec.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/videocodec.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran_card.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran_card.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran_device.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran_device.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran_driver.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran_procfs.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran_procfs.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zr36016.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/zr36016.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zr36050.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/zr36050.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zr36057.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zr36060.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/zr36060.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 49003f77cedd..236069716388 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15609,7 +15609,7 @@ L:	linux-media@vger.kernel.org
 W:	http://mjpeg.sourceforge.net/driver-zoran/
 T:	hg https://linuxtv.org/hg/v4l-dvb
 S:	Odd Fixes
-F:	drivers/media/pci/zoran/
+F:	drivers/staging/media/zoran/

 ZRAM COMPRESSED RAM BLOCK DEVICE DRVIER
 M:	Minchan Kim <minchan@kernel.org>
diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index 5932e225f9c0..1f09123e2bf9 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -16,7 +16,6 @@ source "drivers/media/pci/sta2x11/Kconfig"
 source "drivers/media/pci/tw5864/Kconfig"
 source "drivers/media/pci/tw68/Kconfig"
 source "drivers/media/pci/tw686x/Kconfig"
-source "drivers/media/pci/zoran/Kconfig"
 endif

 if MEDIA_ANALOG_TV_SUPPORT
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index 1c5ab07a8cff..984fa247096d 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -18,7 +18,6 @@ obj-y        +=	ttpci/		\
 		intel/

 obj-$(CONFIG_VIDEO_IVTV) += ivtv/
-obj-$(CONFIG_VIDEO_ZORAN) += zoran/
 obj-$(CONFIG_VIDEO_CX18) += cx18/
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 obj-$(CONFIG_VIDEO_CX25821) += cx25821/
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 4c495a10025c..67a7a60cea5a 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -35,4 +35,6 @@ source "drivers/staging/media/omap4iss/Kconfig"

 source "drivers/staging/media/tegra-vde/Kconfig"

+source "drivers/staging/media/zoran/Kconfig"
+
 endif
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 61a5765cb98f..75dcb7f5c3f8 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_INTEL_ATOMISP)     += atomisp/
 obj-$(CONFIG_TEGRA_VDE)		+= tegra-vde/
+obj-$(CONFIG_VIDEO_ZORAN)	+= zoran/
diff --git a/drivers/media/pci/zoran/Kconfig b/drivers/staging/media/zoran/Kconfig
similarity index 97%
rename from drivers/media/pci/zoran/Kconfig
rename to drivers/staging/media/zoran/Kconfig
index 39ec35bd21a5..63df5de5068d 100644
--- a/drivers/media/pci/zoran/Kconfig
+++ b/drivers/staging/media/zoran/Kconfig
@@ -1,5 +1,5 @@
 config VIDEO_ZORAN
-	tristate "Zoran ZR36057/36067 Video For Linux"
+	tristate "Zoran ZR36057/36067 Video For Linux (Deprecated)"
 	depends on PCI && I2C_ALGOBIT && VIDEO_V4L2 && VIRT_TO_BUS
 	depends on !ALPHA
 	help
diff --git a/drivers/media/pci/zoran/Makefile b/drivers/staging/media/zoran/Makefile
similarity index 100%
rename from drivers/media/pci/zoran/Makefile
rename to drivers/staging/media/zoran/Makefile
diff --git a/drivers/staging/media/zoran/TODO b/drivers/staging/media/zoran/TODO
new file mode 100644
index 000000000000..d57189c91a0a
--- /dev/null
+++ b/drivers/staging/media/zoran/TODO
@@ -0,0 +1,4 @@
+The zoran driver is marked deprecated. It will be removed
+around May 2019 unless somewhat is willing to update this
+driver to the latest V4L2 frameworks (especially the vb2
+framework).
diff --git a/drivers/media/pci/zoran/videocodec.c b/drivers/staging/media/zoran/videocodec.c
similarity index 100%
rename from drivers/media/pci/zoran/videocodec.c
rename to drivers/staging/media/zoran/videocodec.c
diff --git a/drivers/media/pci/zoran/videocodec.h b/drivers/staging/media/zoran/videocodec.h
similarity index 100%
rename from drivers/media/pci/zoran/videocodec.h
rename to drivers/staging/media/zoran/videocodec.h
diff --git a/drivers/media/pci/zoran/zoran.h b/drivers/staging/media/zoran/zoran.h
similarity index 100%
rename from drivers/media/pci/zoran/zoran.h
rename to drivers/staging/media/zoran/zoran.h
diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/staging/media/zoran/zoran_card.c
similarity index 100%
rename from drivers/media/pci/zoran/zoran_card.c
rename to drivers/staging/media/zoran/zoran_card.c
diff --git a/drivers/media/pci/zoran/zoran_card.h b/drivers/staging/media/zoran/zoran_card.h
similarity index 100%
rename from drivers/media/pci/zoran/zoran_card.h
rename to drivers/staging/media/zoran/zoran_card.h
diff --git a/drivers/media/pci/zoran/zoran_device.c b/drivers/staging/media/zoran/zoran_device.c
similarity index 100%
rename from drivers/media/pci/zoran/zoran_device.c
rename to drivers/staging/media/zoran/zoran_device.c
diff --git a/drivers/media/pci/zoran/zoran_device.h b/drivers/staging/media/zoran/zoran_device.h
similarity index 100%
rename from drivers/media/pci/zoran/zoran_device.h
rename to drivers/staging/media/zoran/zoran_device.h
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/staging/media/zoran/zoran_driver.c
similarity index 100%
rename from drivers/media/pci/zoran/zoran_driver.c
rename to drivers/staging/media/zoran/zoran_driver.c
diff --git a/drivers/media/pci/zoran/zoran_procfs.c b/drivers/staging/media/zoran/zoran_procfs.c
similarity index 100%
rename from drivers/media/pci/zoran/zoran_procfs.c
rename to drivers/staging/media/zoran/zoran_procfs.c
diff --git a/drivers/media/pci/zoran/zoran_procfs.h b/drivers/staging/media/zoran/zoran_procfs.h
similarity index 100%
rename from drivers/media/pci/zoran/zoran_procfs.h
rename to drivers/staging/media/zoran/zoran_procfs.h
diff --git a/drivers/media/pci/zoran/zr36016.c b/drivers/staging/media/zoran/zr36016.c
similarity index 100%
rename from drivers/media/pci/zoran/zr36016.c
rename to drivers/staging/media/zoran/zr36016.c
diff --git a/drivers/media/pci/zoran/zr36016.h b/drivers/staging/media/zoran/zr36016.h
similarity index 100%
rename from drivers/media/pci/zoran/zr36016.h
rename to drivers/staging/media/zoran/zr36016.h
diff --git a/drivers/media/pci/zoran/zr36050.c b/drivers/staging/media/zoran/zr36050.c
similarity index 100%
rename from drivers/media/pci/zoran/zr36050.c
rename to drivers/staging/media/zoran/zr36050.c
diff --git a/drivers/media/pci/zoran/zr36050.h b/drivers/staging/media/zoran/zr36050.h
similarity index 100%
rename from drivers/media/pci/zoran/zr36050.h
rename to drivers/staging/media/zoran/zr36050.h
diff --git a/drivers/media/pci/zoran/zr36057.h b/drivers/staging/media/zoran/zr36057.h
similarity index 100%
rename from drivers/media/pci/zoran/zr36057.h
rename to drivers/staging/media/zoran/zr36057.h
diff --git a/drivers/media/pci/zoran/zr36060.c b/drivers/staging/media/zoran/zr36060.c
similarity index 100%
rename from drivers/media/pci/zoran/zr36060.c
rename to drivers/staging/media/zoran/zr36060.c
diff --git a/drivers/media/pci/zoran/zr36060.h b/drivers/staging/media/zoran/zr36060.h
similarity index 100%
rename from drivers/media/pci/zoran/zr36060.h
rename to drivers/staging/media/zoran/zr36060.h
-- 
2.17.0
