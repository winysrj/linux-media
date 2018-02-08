Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:51277 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbeBHTx3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Feb 2018 14:53:29 -0500
Received: by mail-wm0-f66.google.com with SMTP id r71so11642348wmd.1
        for <linux-media@vger.kernel.org>; Thu, 08 Feb 2018 11:53:28 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH 6/7] [media] cxd2099: move driver out of staging into dvb-frontends
Date: Thu,  8 Feb 2018 20:53:17 +0100
Message-Id: <20180208195318.612-7-d.scheller.oss@gmail.com>
In-Reply-To: <20180208195318.612-1-d.scheller.oss@gmail.com>
References: <20180208195318.612-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

According to the TODO file, this driver only landed in staging because of
the way device nodes and data transfers are handled. Besides that this way
(use of secX devices) has become sort of standard to date (ie. VDR
supports this literally since ages via the ddci plugin, TVHeadend received
this functionality lately, and minisatip being currently worked on
regarding this), most importantly this I2C client only driver isn't even
responsible for setting up device nodes, not for handling data
transfer and so on, but only serves as interface for the dvb_ca_en50221
subsystem, just like every other DVB card out in the wild, with hard-wired
or such flexible CA interfaces. And, it would even work with cards having
the cxd2099 controller hard-wired.

Also, this driver received quite some love and even is a proper I2C client
driver by now. So, as this driver acts as a EN50221 frontend device, move
it to dvb-frontends. There is no need to keep it buried in staging.

This commit also updates all affected Kconfig and Makefile's, and adds
MEDIA_AUTOSELECT depends to ddbridge and ngene.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-frontends/Kconfig                          | 12 ++++++++++++
 drivers/media/dvb-frontends/Makefile                         |  1 +
 .../{staging/media/cxd2099 => media/dvb-frontends}/cxd2099.c |  0
 .../{staging/media/cxd2099 => media/dvb-frontends}/cxd2099.h |  0
 drivers/media/pci/ddbridge/Kconfig                           |  1 +
 drivers/media/pci/ddbridge/Makefile                          |  3 ---
 drivers/media/pci/ngene/Kconfig                              |  1 +
 drivers/media/pci/ngene/Makefile                             |  3 ---
 drivers/staging/media/Kconfig                                |  2 --
 drivers/staging/media/Makefile                               |  1 -
 drivers/staging/media/cxd2099/Kconfig                        | 12 ------------
 drivers/staging/media/cxd2099/Makefile                       |  4 ----
 drivers/staging/media/cxd2099/TODO                           | 12 ------------
 13 files changed, 15 insertions(+), 37 deletions(-)
 rename drivers/{staging/media/cxd2099 => media/dvb-frontends}/cxd2099.c (100%)
 rename drivers/{staging/media/cxd2099 => media/dvb-frontends}/cxd2099.h (100%)
 delete mode 100644 drivers/staging/media/cxd2099/Kconfig
 delete mode 100644 drivers/staging/media/cxd2099/Makefile
 delete mode 100644 drivers/staging/media/cxd2099/TODO

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index d17722eb4456..ca8c7ed079dd 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -904,6 +904,18 @@ config DVB_HELENE
 	help
 	  Say Y when you want to support this frontend.
 
+comment "Common Interface (EN50221) controller drivers"
+	depends on DVB_CORE
+
+config DVB_CXD2099
+	tristate "CXD2099AR Common Interface driver"
+	depends on DVB_CORE && I2C
+	---help---
+	  A driver for the CI controller currently found mostly on
+	  Digital Devices DuoFlex CI (single) addon modules.
+
+	  Say Y when you want to support these devices.
+
 comment "Tools to develop new frontends"
 
 config DVB_DUMMY_FE
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index 4be59fed4536..abbd76ede540 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -129,3 +129,4 @@ obj-$(CONFIG_DVB_HORUS3A) += horus3a.o
 obj-$(CONFIG_DVB_ASCOT2E) += ascot2e.o
 obj-$(CONFIG_DVB_HELENE) += helene.o
 obj-$(CONFIG_DVB_ZD1301_DEMOD) += zd1301_demod.o
+obj-$(CONFIG_DVB_CXD2099) += cxd2099.o
diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/media/dvb-frontends/cxd2099.c
similarity index 100%
rename from drivers/staging/media/cxd2099/cxd2099.c
rename to drivers/media/dvb-frontends/cxd2099.c
diff --git a/drivers/staging/media/cxd2099/cxd2099.h b/drivers/media/dvb-frontends/cxd2099.h
similarity index 100%
rename from drivers/staging/media/cxd2099/cxd2099.h
rename to drivers/media/dvb-frontends/cxd2099.h
diff --git a/drivers/media/pci/ddbridge/Kconfig b/drivers/media/pci/ddbridge/Kconfig
index f43d0b83fc0c..a422dde2f34a 100644
--- a/drivers/media/pci/ddbridge/Kconfig
+++ b/drivers/media/pci/ddbridge/Kconfig
@@ -13,6 +13,7 @@ config DVB_DDBRIDGE
 	select DVB_LNBH25 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_MXL5XX if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CXD2099 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for cards with the Digital Devices PCI express bridge:
 	  - Octopus PCIe Bridge
diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index f58fdec50eab..745b37d07558 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -10,6 +10,3 @@ obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
 ccflags-y += -Idrivers/media/dvb-frontends/
 ccflags-y += -Idrivers/media/tuners/
-
-# For the staging CI driver cxd2099
-ccflags-y += -Idrivers/staging/media/cxd2099/
diff --git a/drivers/media/pci/ngene/Kconfig b/drivers/media/pci/ngene/Kconfig
index 637d506b23c5..390ed75fe438 100644
--- a/drivers/media/pci/ngene/Kconfig
+++ b/drivers/media/pci/ngene/Kconfig
@@ -8,6 +8,7 @@ config DVB_NGENE
 	select DVB_DRXK if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2131 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CXD2099 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for Micronas PCI express cards with nGene bridge.
 
diff --git a/drivers/media/pci/ngene/Makefile b/drivers/media/pci/ngene/Makefile
index e4208f5ed215..ec450ad19281 100644
--- a/drivers/media/pci/ngene/Makefile
+++ b/drivers/media/pci/ngene/Makefile
@@ -9,6 +9,3 @@ obj-$(CONFIG_DVB_NGENE) += ngene.o
 
 ccflags-y += -Idrivers/media/dvb-frontends/
 ccflags-y += -Idrivers/media/tuners/
-
-# For the staging CI driver cxd2099
-ccflags-y += -Idrivers/staging/media/cxd2099/
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index e68e1d343d53..7eaf4d4f9786 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -23,8 +23,6 @@ source "drivers/staging/media/atomisp/Kconfig"
 
 source "drivers/staging/media/bcm2048/Kconfig"
 
-source "drivers/staging/media/cxd2099/Kconfig"
-
 source "drivers/staging/media/davinci_vpfe/Kconfig"
 
 source "drivers/staging/media/imx/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 59a47f69884f..830b8578c1b5 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
-obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_VIDEO_IMX_MEDIA)	+= imx/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
diff --git a/drivers/staging/media/cxd2099/Kconfig b/drivers/staging/media/cxd2099/Kconfig
deleted file mode 100644
index b48aefddc84c..000000000000
--- a/drivers/staging/media/cxd2099/Kconfig
+++ /dev/null
@@ -1,12 +0,0 @@
-config DVB_CXD2099
-	tristate "CXD2099AR Common Interface driver"
-	depends on DVB_CORE && PCI && I2C
-	---help---
-	  Support for the CI module found on cards based on
-	  - Micronas ngene PCIe bridge: cineS2 etc.
-	  - Digital Devices PCIe bridge: Octopus series
-
-	  For now, data is passed through '/dev/dvb/adapterX/sec0':
-	    - Encrypted data must be written to 'sec0'.
-	    - Decrypted data can be read from 'sec0'.
-	    - Setup the CAM using device 'ca0'.
diff --git a/drivers/staging/media/cxd2099/Makefile b/drivers/staging/media/cxd2099/Makefile
deleted file mode 100644
index 30432c9aabc4..000000000000
--- a/drivers/staging/media/cxd2099/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-obj-$(CONFIG_DVB_CXD2099) += cxd2099.o
-
-ccflags-y += -Idrivers/media/dvb-frontends/
-ccflags-y += -Idrivers/media/tuners/
diff --git a/drivers/staging/media/cxd2099/TODO b/drivers/staging/media/cxd2099/TODO
deleted file mode 100644
index 375bb6f8ee2c..000000000000
--- a/drivers/staging/media/cxd2099/TODO
+++ /dev/null
@@ -1,12 +0,0 @@
-For now, data is passed through '/dev/dvb/adapterX/sec0':
- - Encrypted data must be written to 'sec0'.
- - Decrypted data can be read from 'sec0'.
- - Setup the CAM using device 'ca0'.
-
-But this is wrong. There are some discussions about the proper way for
-doing it, as seen at:
-	http://www.mail-archive.com/linux-media@vger.kernel.org/msg22196.html
-
-While there's no proper fix for it, the driver should be kept in staging.
-
-Patches should be submitted to: linux-media@vger.kernel.org.
-- 
2.13.6
