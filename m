Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab2HONs0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 09:48:26 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7FDmQnx012639
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 09:48:26 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 11/12] [media] move soc_camera i2c drivers into its own dir
Date: Wed, 15 Aug 2012 10:48:19 -0300
Message-Id: <1345038500-28734-12-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345038500-28734-1-git-send-email-mchehab@redhat.com>
References: <502AC079.50902@gmail.com>
 <1345038500-28734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move all soc_camera i2c drivers into drivers/media/i2c/soc_camera/.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/i2c/Kconfig                          |  4 +
 drivers/media/i2c/Makefile                         |  1 +
 drivers/media/i2c/soc_camera/Kconfig               | 89 ++++++++++++++++++++++
 drivers/media/i2c/soc_camera/Makefile              | 14 ++++
 drivers/media/{video => i2c/soc_camera}/imx074.c   |  0
 drivers/media/{video => i2c/soc_camera}/mt9m001.c  |  0
 drivers/media/{video => i2c/soc_camera}/mt9m111.c  |  0
 drivers/media/{video => i2c/soc_camera}/mt9t031.c  |  0
 drivers/media/{video => i2c/soc_camera}/mt9t112.c  |  0
 drivers/media/{video => i2c/soc_camera}/mt9v022.c  |  0
 drivers/media/{video => i2c/soc_camera}/ov2640.c   |  0
 drivers/media/{video => i2c/soc_camera}/ov5642.c   |  0
 drivers/media/{video => i2c/soc_camera}/ov6650.c   |  0
 drivers/media/{video => i2c/soc_camera}/ov772x.c   |  0
 drivers/media/{video => i2c/soc_camera}/ov9640.c   |  0
 drivers/media/{video => i2c/soc_camera}/ov9640.h   |  0
 drivers/media/{video => i2c/soc_camera}/ov9740.c   |  0
 .../media/{video => i2c/soc_camera}/rj54n1cb0c.c   |  0
 .../{video => i2c/soc_camera}/sh_mobile_csi2.c     |  0
 drivers/media/{video => i2c/soc_camera}/tw9910.c   |  0
 drivers/media/video/Kconfig                        | 87 ---------------------
 drivers/media/video/Makefile                       | 16 +---
 22 files changed, 109 insertions(+), 102 deletions(-)
 create mode 100644 drivers/media/i2c/soc_camera/Kconfig
 create mode 100644 drivers/media/i2c/soc_camera/Makefile
 rename drivers/media/{video => i2c/soc_camera}/imx074.c (100%)
 rename drivers/media/{video => i2c/soc_camera}/mt9m001.c (100%)
 rename drivers/media/{video => i2c/soc_camera}/mt9m111.c (100%)
 rename drivers/media/{video => i2c/soc_camera}/mt9t031.c (100%)
 rename drivers/media/{video => i2c/soc_camera}/mt9t112.c (100%)
 rename drivers/media/{video => i2c/soc_camera}/mt9v022.c (100%)
 rename drivers/media/{video => i2c/soc_camera}/ov2640.c (100%)
 rename drivers/media/{video => i2c/soc_camera}/ov5642.c (100%)
 rename drivers/media/{video => i2c/soc_camera}/ov6650.c (100%)
 rename drivers/media/{video => i2c/soc_camera}/ov772x.c (100%)
 rename drivers/media/{video => i2c/soc_camera}/ov9640.c (100%)
 rename drivers/media/{video => i2c/soc_camera}/ov9640.h (100%)
 rename drivers/media/{video => i2c/soc_camera}/ov9740.c (100%)
 rename drivers/media/{video => i2c/soc_camera}/rj54n1cb0c.c (100%)
 rename drivers/media/{video => i2c/soc_camera}/sh_mobile_csi2.c (100%)
 rename drivers/media/{video => i2c/soc_camera}/tw9910.c (100%)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 1c677f5..7fe4acf 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -562,5 +562,9 @@ config VIDEO_M52790
 	 To compile this driver as a module, choose M here: the
 	 module will be called m52790.
 
+if SOC_CAMERA
+	source "drivers/media/i2c/soc_camera/Kconfig"
+endif
+
 endmenu
 endif
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 93e8c14..088a460 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
 obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp/
 obj-$(CONFIG_VIDEO_CX25840) += cx25840/
 obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
+obj-y				+= soc_camera/
 
 obj-$(CONFIG_VIDEO_APTINA_PLL) += aptina-pll.o
 obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
diff --git a/drivers/media/i2c/soc_camera/Kconfig b/drivers/media/i2c/soc_camera/Kconfig
new file mode 100644
index 0000000..73fe21d
--- /dev/null
+++ b/drivers/media/i2c/soc_camera/Kconfig
@@ -0,0 +1,89 @@
+comment "soc_camera sensor drivers"
+
+config SOC_CAMERA_IMX074
+	tristate "imx074 support"
+	depends on SOC_CAMERA && I2C
+	help
+	  This driver supports IMX074 cameras from Sony
+
+config SOC_CAMERA_MT9M001
+	tristate "mt9m001 support"
+	depends on SOC_CAMERA && I2C
+	select GPIO_PCA953X if MT9M001_PCA9536_SWITCH
+	help
+	  This driver supports MT9M001 cameras from Micron, monochrome
+	  and colour models.
+
+config SOC_CAMERA_MT9M111
+	tristate "mt9m111, mt9m112 and mt9m131 support"
+	depends on SOC_CAMERA && I2C
+	help
+	  This driver supports MT9M111, MT9M112 and MT9M131 cameras from
+	  Micron/Aptina
+
+config SOC_CAMERA_MT9T031
+	tristate "mt9t031 support"
+	depends on SOC_CAMERA && I2C
+	help
+	  This driver supports MT9T031 cameras from Micron.
+
+config SOC_CAMERA_MT9T112
+	tristate "mt9t112 support"
+	depends on SOC_CAMERA && I2C
+	help
+	  This driver supports MT9T112 cameras from Aptina.
+
+config SOC_CAMERA_MT9V022
+	tristate "mt9v022 support"
+	depends on SOC_CAMERA && I2C
+	select GPIO_PCA953X if MT9V022_PCA9536_SWITCH
+	help
+	  This driver supports MT9V022 cameras from Micron
+
+config SOC_CAMERA_OV2640
+	tristate "ov2640 camera support"
+	depends on SOC_CAMERA && I2C
+	help
+	  This is a ov2640 camera driver
+
+config SOC_CAMERA_OV5642
+	tristate "ov5642 camera support"
+	depends on SOC_CAMERA && I2C
+	help
+	  This is a V4L2 camera driver for the OmniVision OV5642 sensor
+
+config SOC_CAMERA_OV6650
+	tristate "ov6650 sensor support"
+	depends on SOC_CAMERA && I2C
+	---help---
+	  This is a V4L2 SoC camera driver for the OmniVision OV6650 sensor
+
+config SOC_CAMERA_OV772X
+	tristate "ov772x camera support"
+	depends on SOC_CAMERA && I2C
+	help
+	  This is a ov772x camera driver
+
+config SOC_CAMERA_OV9640
+	tristate "ov9640 camera support"
+	depends on SOC_CAMERA && I2C
+	help
+	  This is a ov9640 camera driver
+
+config SOC_CAMERA_OV9740
+	tristate "ov9740 camera support"
+	depends on SOC_CAMERA && I2C
+	help
+	  This is a ov9740 camera driver
+
+config SOC_CAMERA_RJ54N1
+	tristate "rj54n1cb0c support"
+	depends on SOC_CAMERA && I2C
+	help
+	  This is a rj54n1cb0c video driver
+
+config SOC_CAMERA_TW9910
+	tristate "tw9910 support"
+	depends on SOC_CAMERA && I2C
+	help
+	  This is a tw9910 video driver
diff --git a/drivers/media/i2c/soc_camera/Makefile b/drivers/media/i2c/soc_camera/Makefile
new file mode 100644
index 0000000..d0421fe
--- /dev/null
+++ b/drivers/media/i2c/soc_camera/Makefile
@@ -0,0 +1,14 @@
+obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
+obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
+obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
+obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
+obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= mt9t112.o
+obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
+obj-$(CONFIG_SOC_CAMERA_OV2640)		+= ov2640.o
+obj-$(CONFIG_SOC_CAMERA_OV5642)		+= ov5642.o
+obj-$(CONFIG_SOC_CAMERA_OV6650)		+= ov6650.o
+obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
+obj-$(CONFIG_SOC_CAMERA_OV9640)		+= ov9640.o
+obj-$(CONFIG_SOC_CAMERA_OV9740)		+= ov9740.o
+obj-$(CONFIG_SOC_CAMERA_RJ54N1)		+= rj54n1cb0c.o
+obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
diff --git a/drivers/media/video/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
similarity index 100%
rename from drivers/media/video/imx074.c
rename to drivers/media/i2c/soc_camera/imx074.c
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
similarity index 100%
rename from drivers/media/video/mt9m001.c
rename to drivers/media/i2c/soc_camera/mt9m001.c
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
similarity index 100%
rename from drivers/media/video/mt9m111.c
rename to drivers/media/i2c/soc_camera/mt9m111.c
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
similarity index 100%
rename from drivers/media/video/mt9t031.c
rename to drivers/media/i2c/soc_camera/mt9t031.c
diff --git a/drivers/media/video/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
similarity index 100%
rename from drivers/media/video/mt9t112.c
rename to drivers/media/i2c/soc_camera/mt9t112.c
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
similarity index 100%
rename from drivers/media/video/mt9v022.c
rename to drivers/media/i2c/soc_camera/mt9v022.c
diff --git a/drivers/media/video/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
similarity index 100%
rename from drivers/media/video/ov2640.c
rename to drivers/media/i2c/soc_camera/ov2640.c
diff --git a/drivers/media/video/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
similarity index 100%
rename from drivers/media/video/ov5642.c
rename to drivers/media/i2c/soc_camera/ov5642.c
diff --git a/drivers/media/video/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
similarity index 100%
rename from drivers/media/video/ov6650.c
rename to drivers/media/i2c/soc_camera/ov6650.c
diff --git a/drivers/media/video/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
similarity index 100%
rename from drivers/media/video/ov772x.c
rename to drivers/media/i2c/soc_camera/ov772x.c
diff --git a/drivers/media/video/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
similarity index 100%
rename from drivers/media/video/ov9640.c
rename to drivers/media/i2c/soc_camera/ov9640.c
diff --git a/drivers/media/video/ov9640.h b/drivers/media/i2c/soc_camera/ov9640.h
similarity index 100%
rename from drivers/media/video/ov9640.h
rename to drivers/media/i2c/soc_camera/ov9640.h
diff --git a/drivers/media/video/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
similarity index 100%
rename from drivers/media/video/ov9740.c
rename to drivers/media/i2c/soc_camera/ov9740.c
diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
similarity index 100%
rename from drivers/media/video/rj54n1cb0c.c
rename to drivers/media/i2c/soc_camera/rj54n1cb0c.c
diff --git a/drivers/media/video/sh_mobile_csi2.c b/drivers/media/i2c/soc_camera/sh_mobile_csi2.c
similarity index 100%
rename from drivers/media/video/sh_mobile_csi2.c
rename to drivers/media/i2c/soc_camera/sh_mobile_csi2.c
diff --git a/drivers/media/video/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
similarity index 100%
rename from drivers/media/video/tw9910.c
rename to drivers/media/i2c/soc_camera/tw9910.c
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f2171e7..28b25bf 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -127,57 +127,6 @@ config SOC_CAMERA
 	  over a bus like PCI or USB. For example some i2c camera connected
 	  directly to the data bus of an SoC.
 
-config SOC_CAMERA_IMX074
-	tristate "imx074 support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This driver supports IMX074 cameras from Sony
-
-config SOC_CAMERA_MT9M001
-	tristate "mt9m001 support"
-	depends on SOC_CAMERA && I2C
-	select GPIO_PCA953X if MT9M001_PCA9536_SWITCH
-	help
-	  This driver supports MT9M001 cameras from Micron, monochrome
-	  and colour models.
-
-config SOC_CAMERA_MT9M111
-	tristate "mt9m111, mt9m112 and mt9m131 support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This driver supports MT9M111, MT9M112 and MT9M131 cameras from
-	  Micron/Aptina
-
-config SOC_CAMERA_MT9T031
-	tristate "mt9t031 support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This driver supports MT9T031 cameras from Micron.
-
-config SOC_CAMERA_MT9T112
-	tristate "mt9t112 support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This driver supports MT9T112 cameras from Aptina.
-
-config SOC_CAMERA_MT9V022
-	tristate "mt9v022 support"
-	depends on SOC_CAMERA && I2C
-	select GPIO_PCA953X if MT9V022_PCA9536_SWITCH
-	help
-	  This driver supports MT9V022 cameras from Micron
-
-config SOC_CAMERA_RJ54N1
-	tristate "rj54n1cb0c support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This is a rj54n1cb0c video driver
-
-config SOC_CAMERA_TW9910
-	tristate "tw9910 support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This is a tw9910 video driver
 
 config SOC_CAMERA_PLATFORM
 	tristate "platform camera support"
@@ -185,42 +134,6 @@ config SOC_CAMERA_PLATFORM
 	help
 	  This is a generic SoC camera platform driver, useful for testing
 
-config SOC_CAMERA_OV2640
-	tristate "ov2640 camera support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This is a ov2640 camera driver
-
-config SOC_CAMERA_OV5642
-	tristate "ov5642 camera support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This is a V4L2 camera driver for the OmniVision OV5642 sensor
-
-config SOC_CAMERA_OV6650
-	tristate "ov6650 sensor support"
-	depends on SOC_CAMERA && I2C
-	---help---
-	  This is a V4L2 SoC camera driver for the OmniVision OV6650 sensor
-
-config SOC_CAMERA_OV772X
-	tristate "ov772x camera support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This is a ov772x camera driver
-
-config SOC_CAMERA_OV9640
-	tristate "ov9640 camera support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This is a ov9640 camera driver
-
-config SOC_CAMERA_OV9740
-	tristate "ov9740 camera support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This is a ov9740 camera driver
-
 config MX1_VIDEO
 	bool
 
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 52a04fa..b3effdc 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -6,21 +6,6 @@ omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
 obj-$(CONFIG_VIDEO_VINO) += indycam.o
 
-obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
-obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
-obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
-obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
-obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= mt9t112.o
-obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
-obj-$(CONFIG_SOC_CAMERA_OV2640)		+= ov2640.o
-obj-$(CONFIG_SOC_CAMERA_OV5642)		+= ov5642.o
-obj-$(CONFIG_SOC_CAMERA_OV6650)		+= ov6650.o
-obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
-obj-$(CONFIG_SOC_CAMERA_OV9640)		+= ov9640.o
-obj-$(CONFIG_SOC_CAMERA_OV9740)		+= ov9740.o
-obj-$(CONFIG_SOC_CAMERA_RJ54N1)		+= rj54n1cb0c.o
-obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
-
 obj-$(CONFIG_VIDEO_VINO) += vino.o
 obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
 
@@ -78,3 +63,4 @@ obj-$(CONFIG_ARCH_OMAP)	+= omap/
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 ccflags-y += -I$(srctree)/drivers/media/tuners
+ccflags-y += -I$(srctree)/drivers/media/i2c/soc_camera
-- 
1.7.11.2

