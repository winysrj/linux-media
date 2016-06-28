Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbcF1Otn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 10:49:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Jiri Slaby <jslaby@suse.cz>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Benoit Parrot <bparrot@ti.com>, Kamil Debski <kamil@wypas.org>,
	Simon Horman <simon.horman@netronome.com>,
	=?UTF-8?q?Niklas=20S=C3=83=C2=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>, devel@driverdev.osuosl.org
Subject: [PATCH 1/2] [media] move s5p-cec to staging
Date: Tue, 28 Jun 2016 11:49:33 -0300
Message-Id: <78fc853b5532b22639e691357fd59aa19833d81a.1467125336.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the CEC core is currently at staging, it doesn't make any sense
to put a dependent driver outside staging. So, move it also to
staging.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 MAINTAINERS                                                    |  2 +-
 drivers/media/platform/Kconfig                                 | 10 ----------
 drivers/media/platform/Makefile                                |  1 -
 drivers/staging/media/Kconfig                                  |  2 ++
 drivers/staging/media/Makefile                                 |  1 +
 drivers/staging/media/s5p-cec/Kconfig                          |  9 +++++++++
 drivers/{media/platform => staging/media}/s5p-cec/Makefile     |  0
 drivers/staging/media/s5p-cec/TODO                             |  3 +++
 .../platform => staging/media}/s5p-cec/exynos_hdmi_cec.h       |  0
 .../platform => staging/media}/s5p-cec/exynos_hdmi_cecctrl.c   |  0
 drivers/{media/platform => staging/media}/s5p-cec/regs-cec.h   |  0
 drivers/{media/platform => staging/media}/s5p-cec/s5p_cec.c    |  0
 drivers/{media/platform => staging/media}/s5p-cec/s5p_cec.h    |  0
 13 files changed, 16 insertions(+), 12 deletions(-)
 create mode 100644 drivers/staging/media/s5p-cec/Kconfig
 rename drivers/{media/platform => staging/media}/s5p-cec/Makefile (100%)
 create mode 100644 drivers/staging/media/s5p-cec/TODO
 rename drivers/{media/platform => staging/media}/s5p-cec/exynos_hdmi_cec.h (100%)
 rename drivers/{media/platform => staging/media}/s5p-cec/exynos_hdmi_cecctrl.c (100%)
 rename drivers/{media/platform => staging/media}/s5p-cec/regs-cec.h (100%)
 rename drivers/{media/platform => staging/media}/s5p-cec/s5p_cec.c (100%)
 rename drivers/{media/platform => staging/media}/s5p-cec/s5p_cec.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f76a3bf069f..962c5b0d2a3d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1647,7 +1647,7 @@ M:	Kyungmin Park <kyungmin.park@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	drivers/media/platform/s5p-cec/
+F:	drivers/staging/media/platform/s5p-cec/
 
 ARM/SAMSUNG S5P SERIES JPEG CODEC SUPPORT
 M:	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 567717583246..382f3937379e 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -108,16 +108,6 @@ config VIDEO_S3C_CAMIF
 source "drivers/media/platform/soc_camera/Kconfig"
 source "drivers/media/platform/exynos4-is/Kconfig"
 source "drivers/media/platform/s5p-tv/Kconfig"
-
-config VIDEO_SAMSUNG_S5P_CEC
-	tristate "Samsung S5P CEC driver"
-	depends on VIDEO_DEV && MEDIA_CEC && (PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST)
-	---help---
-	  This is a driver for Samsung S5P HDMI CEC interface. It uses the
-	  generic CEC framework interface.
-	  CEC bus is present in the HDMI connector and enables communication
-	  between compatible devices.
-
 source "drivers/media/platform/am437x/Kconfig"
 source "drivers/media/platform/xilinx/Kconfig"
 source "drivers/media/platform/rcar-vin/Kconfig"
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 9a2fe9513282..99cf31542f54 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -28,7 +28,6 @@ obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
 
 obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+= s3c-camif/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS4_IS) 	+= exynos4-is/
-obj-$(CONFIG_VIDEO_SAMSUNG_S5P_CEC)	+= s5p-cec/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 7ce679eb87e1..567078986c94 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -31,6 +31,8 @@ source "drivers/staging/media/omap4iss/Kconfig"
 
 source "drivers/staging/media/tw686x-kh/Kconfig"
 
+source "drivers/staging/media/s5p-cec/Kconfig"
+
 # Keep LIRC at the end, as it has sub-menus
 source "drivers/staging/media/lirc/Kconfig"
 
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 2d213dd54bc3..989c844f4996 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_MEDIA_CEC)		+= cec/
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_CEC) += s5p-cec/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
diff --git a/drivers/staging/media/s5p-cec/Kconfig b/drivers/staging/media/s5p-cec/Kconfig
new file mode 100644
index 000000000000..0315fd7ad0f1
--- /dev/null
+++ b/drivers/staging/media/s5p-cec/Kconfig
@@ -0,0 +1,9 @@
+config VIDEO_SAMSUNG_S5P_CEC
+       tristate "Samsung S5P CEC driver"
+       depends on VIDEO_DEV && MEDIA_CEC && (PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST)
+       ---help---
+         This is a driver for Samsung S5P HDMI CEC interface. It uses the
+         generic CEC framework interface.
+         CEC bus is present in the HDMI connector and enables communication
+         between compatible devices.
+
diff --git a/drivers/media/platform/s5p-cec/Makefile b/drivers/staging/media/s5p-cec/Makefile
similarity index 100%
rename from drivers/media/platform/s5p-cec/Makefile
rename to drivers/staging/media/s5p-cec/Makefile
diff --git a/drivers/staging/media/s5p-cec/TODO b/drivers/staging/media/s5p-cec/TODO
new file mode 100644
index 000000000000..7162f9ae0d26
--- /dev/null
+++ b/drivers/staging/media/s5p-cec/TODO
@@ -0,0 +1,3 @@
+There's nothing wrong on this driver, except that it depends on
+the media staging core, that it is currently at staging. So,
+this should be kept here while the core is not promoted.
diff --git a/drivers/media/platform/s5p-cec/exynos_hdmi_cec.h b/drivers/staging/media/s5p-cec/exynos_hdmi_cec.h
similarity index 100%
rename from drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
rename to drivers/staging/media/s5p-cec/exynos_hdmi_cec.h
diff --git a/drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c b/drivers/staging/media/s5p-cec/exynos_hdmi_cecctrl.c
similarity index 100%
rename from drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
rename to drivers/staging/media/s5p-cec/exynos_hdmi_cecctrl.c
diff --git a/drivers/media/platform/s5p-cec/regs-cec.h b/drivers/staging/media/s5p-cec/regs-cec.h
similarity index 100%
rename from drivers/media/platform/s5p-cec/regs-cec.h
rename to drivers/staging/media/s5p-cec/regs-cec.h
diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/staging/media/s5p-cec/s5p_cec.c
similarity index 100%
rename from drivers/media/platform/s5p-cec/s5p_cec.c
rename to drivers/staging/media/s5p-cec/s5p_cec.c
diff --git a/drivers/media/platform/s5p-cec/s5p_cec.h b/drivers/staging/media/s5p-cec/s5p_cec.h
similarity index 100%
rename from drivers/media/platform/s5p-cec/s5p_cec.h
rename to drivers/staging/media/s5p-cec/s5p_cec.h
-- 
2.7.4

