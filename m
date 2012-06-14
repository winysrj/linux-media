Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545Ab2FNUiy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 16:38:54 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5EKcsDC017489
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 16:38:54 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 07/10] [media] b2c2: break it into common/pci/usb directories
Date: Thu, 14 Jun 2012 17:35:58 -0300
Message-Id: <1339706161-22713-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
References: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

b2c2 is, in fact, 2 drivers: one for PCI and one for USB, plus
a common bus-independent code. Break it accordingly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig                              |    4 +-
 drivers/media/common/Kconfig                       |    2 +
 drivers/media/common/Makefile                      |    2 +-
 drivers/media/common/b2c2/Kconfig                  |   31 ++++++++++++++++
 drivers/media/common/b2c2/Makefile                 |    7 ++++
 .../media/{pci => common}/b2c2/flexcop-common.h    |    0
 .../media/{pci => common}/b2c2/flexcop-eeprom.c    |    0
 .../media/{pci => common}/b2c2/flexcop-fe-tuner.c  |    0
 .../media/{pci => common}/b2c2/flexcop-hw-filter.c |    0
 drivers/media/{pci => common}/b2c2/flexcop-i2c.c   |    0
 drivers/media/{pci => common}/b2c2/flexcop-misc.c  |    0
 drivers/media/{pci => common}/b2c2/flexcop-reg.h   |    0
 drivers/media/{pci => common}/b2c2/flexcop-sram.c  |    0
 drivers/media/{pci => common}/b2c2/flexcop.c       |    0
 drivers/media/{pci => common}/b2c2/flexcop.h       |    0
 .../{pci => common}/b2c2/flexcop_ibi_value_be.h    |    0
 .../{pci => common}/b2c2/flexcop_ibi_value_le.h    |    0
 drivers/media/pci/Kconfig                          |   21 +++--------
 drivers/media/pci/Makefile                         |    3 +-
 drivers/media/pci/b2c2/Kconfig                     |   39 --------------------
 drivers/media/pci/b2c2/Makefile                    |   13 ++-----
 drivers/media/usb/Kconfig                          |    1 +
 drivers/media/usb/Makefile                         |    2 +-
 drivers/media/usb/b2c2/Kconfig                     |    6 +++
 drivers/media/usb/b2c2/Makefile                    |    7 ++++
 drivers/media/{pci => usb}/b2c2/flexcop-usb.c      |    0
 drivers/media/{pci => usb}/b2c2/flexcop-usb.h      |    0
 27 files changed, 71 insertions(+), 67 deletions(-)
 create mode 100644 drivers/media/common/b2c2/Kconfig
 create mode 100644 drivers/media/common/b2c2/Makefile
 rename drivers/media/{pci => common}/b2c2/flexcop-common.h (100%)
 rename drivers/media/{pci => common}/b2c2/flexcop-eeprom.c (100%)
 rename drivers/media/{pci => common}/b2c2/flexcop-fe-tuner.c (100%)
 rename drivers/media/{pci => common}/b2c2/flexcop-hw-filter.c (100%)
 rename drivers/media/{pci => common}/b2c2/flexcop-i2c.c (100%)
 rename drivers/media/{pci => common}/b2c2/flexcop-misc.c (100%)
 rename drivers/media/{pci => common}/b2c2/flexcop-reg.h (100%)
 rename drivers/media/{pci => common}/b2c2/flexcop-sram.c (100%)
 rename drivers/media/{pci => common}/b2c2/flexcop.c (100%)
 rename drivers/media/{pci => common}/b2c2/flexcop.h (100%)
 rename drivers/media/{pci => common}/b2c2/flexcop_ibi_value_be.h (100%)
 rename drivers/media/{pci => common}/b2c2/flexcop_ibi_value_le.h (100%)
 create mode 100644 drivers/media/usb/b2c2/Kconfig
 create mode 100644 drivers/media/usb/b2c2/Makefile
 rename drivers/media/{pci => usb}/b2c2/flexcop-usb.c (100%)
 rename drivers/media/{pci => usb}/b2c2/flexcop-usb.h (100%)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index bd415c4..efc3055 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -141,7 +141,6 @@ config DVB_NET
 	  You may want to disable the network support on embedded devices. If
 	  unsure say Y.
 
-source "drivers/media/common/Kconfig"
 source "drivers/media/rc/Kconfig"
 
 #
@@ -175,4 +174,7 @@ comment "Supported DVB Frontends"
 	depends on DVB_CORE
 source "drivers/media/dvb-frontends/Kconfig"
 
+# Common drivers
+source "drivers/media/common/Kconfig"
+
 endif # MEDIA_SUPPORT
diff --git a/drivers/media/common/Kconfig b/drivers/media/common/Kconfig
index 769c6f8..4672f7d 100644
--- a/drivers/media/common/Kconfig
+++ b/drivers/media/common/Kconfig
@@ -7,3 +7,5 @@ config VIDEO_SAA7146_VV
 	depends on VIDEO_V4L2
 	select VIDEOBUF_DMA_SG
 	select VIDEO_SAA7146
+
+source "drivers/media/common/b2c2/Kconfig"
diff --git a/drivers/media/common/Makefile b/drivers/media/common/Makefile
index e3ec963..d0512d7 100644
--- a/drivers/media/common/Makefile
+++ b/drivers/media/common/Makefile
@@ -1,6 +1,6 @@
 saa7146-objs    := saa7146_i2c.o saa7146_core.o
 saa7146_vv-objs := saa7146_fops.o saa7146_video.o saa7146_hlp.o saa7146_vbi.o
 
-obj-y += tuners/
+obj-y += tuners/ b2c2/
 obj-$(CONFIG_VIDEO_SAA7146) += saa7146.o
 obj-$(CONFIG_VIDEO_SAA7146_VV) += saa7146_vv.o
diff --git a/drivers/media/common/b2c2/Kconfig b/drivers/media/common/b2c2/Kconfig
new file mode 100644
index 0000000..e270dd8
--- /dev/null
+++ b/drivers/media/common/b2c2/Kconfig
@@ -0,0 +1,31 @@
+config DVB_B2C2_FLEXCOP
+	tristate
+	depends on DVB_CORE && I2C
+	depends on DVB_B2C2_FLEXCOP_PCI || DVB_B2C2_FLEXCOP_USB
+	default y
+	select DVB_PLL if !DVB_FE_CUSTOMISE
+	select DVB_STV0299 if !DVB_FE_CUSTOMISE
+	select DVB_MT352 if !DVB_FE_CUSTOMISE
+	select DVB_MT312 if !DVB_FE_CUSTOMISE
+	select DVB_NXT200X if !DVB_FE_CUSTOMISE
+	select DVB_STV0297 if !DVB_FE_CUSTOMISE
+	select DVB_BCM3510 if !DVB_FE_CUSTOMISE
+	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
+	select DVB_S5H1420 if !DVB_FE_CUSTOMISE
+	select DVB_TUNER_ITD1000 if !DVB_FE_CUSTOMISE
+	select DVB_ISL6421 if !DVB_FE_CUSTOMISE
+	select DVB_CX24123 if !DVB_FE_CUSTOMISE
+	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
+	select DVB_TUNER_CX24113 if !DVB_FE_CUSTOMISE
+	help
+	  Support for the digital TV receiver chip made by B2C2 Inc. included in
+	  Technisats PCI cards and USB boxes.
+
+	  Say Y if you own such a device and want to use it.
+
+config DVB_B2C2_FLEXCOP_DEBUG
+	bool "Enable debug for the B2C2 FlexCop drivers"
+	depends on DVB_B2C2_FLEXCOP
+	help
+	  Say Y if you want to enable the module option to control debug messages
+	  of all B2C2 FlexCop drivers.
diff --git a/drivers/media/common/b2c2/Makefile b/drivers/media/common/b2c2/Makefile
new file mode 100644
index 0000000..377d051
--- /dev/null
+++ b/drivers/media/common/b2c2/Makefile
@@ -0,0 +1,7 @@
+b2c2-flexcop-objs = flexcop.o flexcop-fe-tuner.o flexcop-i2c.o \
+	flexcop-sram.o flexcop-eeprom.o flexcop-misc.o flexcop-hw-filter.o
+obj-$(CONFIG_DVB_B2C2_FLEXCOP) += b2c2-flexcop.o
+
+ccflags-y += -Idrivers/media/dvb-core/
+ccflags-y += -Idrivers/media/dvb-frontends/
+ccflags-y += -Idrivers/media/common/tuners/
diff --git a/drivers/media/pci/b2c2/flexcop-common.h b/drivers/media/common/b2c2/flexcop-common.h
similarity index 100%
rename from drivers/media/pci/b2c2/flexcop-common.h
rename to drivers/media/common/b2c2/flexcop-common.h
diff --git a/drivers/media/pci/b2c2/flexcop-eeprom.c b/drivers/media/common/b2c2/flexcop-eeprom.c
similarity index 100%
rename from drivers/media/pci/b2c2/flexcop-eeprom.c
rename to drivers/media/common/b2c2/flexcop-eeprom.c
diff --git a/drivers/media/pci/b2c2/flexcop-fe-tuner.c b/drivers/media/common/b2c2/flexcop-fe-tuner.c
similarity index 100%
rename from drivers/media/pci/b2c2/flexcop-fe-tuner.c
rename to drivers/media/common/b2c2/flexcop-fe-tuner.c
diff --git a/drivers/media/pci/b2c2/flexcop-hw-filter.c b/drivers/media/common/b2c2/flexcop-hw-filter.c
similarity index 100%
rename from drivers/media/pci/b2c2/flexcop-hw-filter.c
rename to drivers/media/common/b2c2/flexcop-hw-filter.c
diff --git a/drivers/media/pci/b2c2/flexcop-i2c.c b/drivers/media/common/b2c2/flexcop-i2c.c
similarity index 100%
rename from drivers/media/pci/b2c2/flexcop-i2c.c
rename to drivers/media/common/b2c2/flexcop-i2c.c
diff --git a/drivers/media/pci/b2c2/flexcop-misc.c b/drivers/media/common/b2c2/flexcop-misc.c
similarity index 100%
rename from drivers/media/pci/b2c2/flexcop-misc.c
rename to drivers/media/common/b2c2/flexcop-misc.c
diff --git a/drivers/media/pci/b2c2/flexcop-reg.h b/drivers/media/common/b2c2/flexcop-reg.h
similarity index 100%
rename from drivers/media/pci/b2c2/flexcop-reg.h
rename to drivers/media/common/b2c2/flexcop-reg.h
diff --git a/drivers/media/pci/b2c2/flexcop-sram.c b/drivers/media/common/b2c2/flexcop-sram.c
similarity index 100%
rename from drivers/media/pci/b2c2/flexcop-sram.c
rename to drivers/media/common/b2c2/flexcop-sram.c
diff --git a/drivers/media/pci/b2c2/flexcop.c b/drivers/media/common/b2c2/flexcop.c
similarity index 100%
rename from drivers/media/pci/b2c2/flexcop.c
rename to drivers/media/common/b2c2/flexcop.c
diff --git a/drivers/media/pci/b2c2/flexcop.h b/drivers/media/common/b2c2/flexcop.h
similarity index 100%
rename from drivers/media/pci/b2c2/flexcop.h
rename to drivers/media/common/b2c2/flexcop.h
diff --git a/drivers/media/pci/b2c2/flexcop_ibi_value_be.h b/drivers/media/common/b2c2/flexcop_ibi_value_be.h
similarity index 100%
rename from drivers/media/pci/b2c2/flexcop_ibi_value_be.h
rename to drivers/media/common/b2c2/flexcop_ibi_value_be.h
diff --git a/drivers/media/pci/b2c2/flexcop_ibi_value_le.h b/drivers/media/common/b2c2/flexcop_ibi_value_le.h
similarity index 100%
rename from drivers/media/pci/b2c2/flexcop_ibi_value_le.h
rename to drivers/media/common/b2c2/flexcop_ibi_value_le.h
diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index 3b9164a..b16529b 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -3,48 +3,39 @@
 #
 
 menuconfig DVB_CAPTURE_DRIVERS
-	bool "DVB/ATSC adapters"
+	bool "DVB/ATSC PCI adapters"
 	depends on DVB_CORE
 	default y
 	---help---
 	  Say Y to select Digital TV adapters
 
-if DVB_CAPTURE_DRIVERS && DVB_CORE
+if DVB_CAPTURE_DRIVERS && DVB_CORE && PCI && I2C
 
 comment "Supported SAA7146 based PCI Adapters"
-	depends on DVB_CORE && PCI && I2C
 source "drivers/media/pci/ttpci/Kconfig"
 
-comment "Supported FlexCopII (B2C2) Adapters"
-	depends on DVB_CORE && (PCI || USB) && I2C
+comment "Supported FlexCopII (B2C2) PCI Adapters"
 source "drivers/media/pci/b2c2/Kconfig"
 
 comment "Supported BT878 Adapters"
-	depends on DVB_CORE && PCI && I2C
 source "drivers/media/pci/bt8xx/Kconfig"
 
 comment "Supported Pluto2 Adapters"
-	depends on DVB_CORE && PCI && I2C
 source "drivers/media/pci/pluto2/Kconfig"
 
 comment "Supported SDMC DM1105 Adapters"
-	depends on DVB_CORE && PCI && I2C
 source "drivers/media/pci/dm1105/Kconfig"
 
 comment "Supported Earthsoft PT1 Adapters"
-	depends on DVB_CORE && PCI && I2C
 source "drivers/media/pci/pt1/Kconfig"
 
 comment "Supported Mantis Adapters"
-	depends on DVB_CORE && PCI && I2C
-	source "drivers/media/pci/mantis/Kconfig"
+source "drivers/media/pci/mantis/Kconfig"
 
 comment "Supported nGene Adapters"
-	depends on DVB_CORE && PCI && I2C
-	source "drivers/media/pci/ngene/Kconfig"
+source "drivers/media/pci/ngene/Kconfig"
 
 comment "Supported ddbridge ('Octopus') Adapters"
-	depends on DVB_CORE && PCI && I2C
-	source "drivers/media/pci/ddbridge/Kconfig"
+source "drivers/media/pci/ddbridge/Kconfig"
 
 endif # DVB_CAPTURE_DRIVERS
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index c5fa43a..1d44fbd 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -10,4 +10,5 @@ obj-y        :=	ttpci/		\
 		pt1/		\
 		mantis/		\
 		ngene/		\
-		ddbridge/
+		ddbridge/	\
+		b2c2/
diff --git a/drivers/media/pci/b2c2/Kconfig b/drivers/media/pci/b2c2/Kconfig
index 9e57814..aaa1f30 100644
--- a/drivers/media/pci/b2c2/Kconfig
+++ b/drivers/media/pci/b2c2/Kconfig
@@ -1,45 +1,6 @@
-config DVB_B2C2_FLEXCOP
-	tristate "Technisat/B2C2 FlexCopII(b) and FlexCopIII adapters"
-	depends on DVB_CORE && I2C
-	select DVB_PLL if !DVB_FE_CUSTOMISE
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_MT352 if !DVB_FE_CUSTOMISE
-	select DVB_MT312 if !DVB_FE_CUSTOMISE
-	select DVB_NXT200X if !DVB_FE_CUSTOMISE
-	select DVB_STV0297 if !DVB_FE_CUSTOMISE
-	select DVB_BCM3510 if !DVB_FE_CUSTOMISE
-	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
-	select DVB_S5H1420 if !DVB_FE_CUSTOMISE
-	select DVB_TUNER_ITD1000 if !DVB_FE_CUSTOMISE
-	select DVB_ISL6421 if !DVB_FE_CUSTOMISE
-	select DVB_CX24123 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
-	select DVB_TUNER_CX24113 if !DVB_FE_CUSTOMISE
-	help
-	  Support for the digital TV receiver chip made by B2C2 Inc. included in
-	  Technisats PCI cards and USB boxes.
-
-	  Say Y if you own such a device and want to use it.
-
 config DVB_B2C2_FLEXCOP_PCI
 	tristate "Technisat/B2C2 Air/Sky/Cable2PC PCI"
-	depends on DVB_B2C2_FLEXCOP && PCI && I2C
 	help
 	  Support for the Air/Sky/CableStar2 PCI card (DVB/ATSC) by Technisat/B2C2.
 
 	  Say Y if you own such a device and want to use it.
-
-config DVB_B2C2_FLEXCOP_USB
-	tristate "Technisat/B2C2 Air/Sky/Cable2PC USB"
-	depends on DVB_B2C2_FLEXCOP && USB && I2C
-	help
-	  Support for the Air/Sky/Cable2PC USB1.1 box (DVB/ATSC) by Technisat/B2C2,
-
-	  Say Y if you own such a device and want to use it.
-
-config DVB_B2C2_FLEXCOP_DEBUG
-	bool "Enable debug for the B2C2 FlexCop drivers"
-	depends on DVB_B2C2_FLEXCOP
-	help
-	  Say Y if you want to enable the module option to control debug messages
-	  of all B2C2 FlexCop drivers.
diff --git a/drivers/media/pci/b2c2/Makefile b/drivers/media/pci/b2c2/Makefile
index 7a1f5ce..e90e236 100644
--- a/drivers/media/pci/b2c2/Makefile
+++ b/drivers/media/pci/b2c2/Makefile
@@ -1,16 +1,11 @@
-b2c2-flexcop-objs = flexcop.o flexcop-fe-tuner.o flexcop-i2c.o \
-	flexcop-sram.o flexcop-eeprom.o flexcop-misc.o flexcop-hw-filter.o
-obj-$(CONFIG_DVB_B2C2_FLEXCOP) += b2c2-flexcop.o
-
 ifneq ($(CONFIG_DVB_B2C2_FLEXCOP_PCI),)
-b2c2-flexcop-objs += flexcop-dma.o
+b2c2-flexcop-pci-objs += flexcop-dma.o
 endif
 
 b2c2-flexcop-pci-objs = flexcop-pci.o
 obj-$(CONFIG_DVB_B2C2_FLEXCOP_PCI) += b2c2-flexcop-pci.o
 
-b2c2-flexcop-usb-objs = flexcop-usb.o
-obj-$(CONFIG_DVB_B2C2_FLEXCOP_USB) += b2c2-flexcop-usb.o
-
-ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends/
+ccflags-y += -Idrivers/media/dvb-core/
+ccflags-y += -Idrivers/media/dvb-frontends/
 ccflags-y += -Idrivers/media/common/tuners/
+ccflags-y += -Idrivers/media/common/b2c2/
diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index d8891ad..b6f348a 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -13,5 +13,6 @@ source "drivers/media/usb/dvb-usb/Kconfig"
 source "drivers/media/usb/ttusb-budget/Kconfig"
 source "drivers/media/usb/ttusb-dec/Kconfig"
 source "drivers/media/usb/siano/Kconfig"
+source "drivers/media/usb/b2c2/Kconfig"
 
 endif
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index b6c2229..669c48f 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -3,4 +3,4 @@
 #
 
 # DVB USB-only drivers
-obj-y := ttusb-dec/ ttusb-budget/ dvb-usb/ siano/
+obj-y := ttusb-dec/ ttusb-budget/ dvb-usb/ siano/ b2c2/
diff --git a/drivers/media/usb/b2c2/Kconfig b/drivers/media/usb/b2c2/Kconfig
new file mode 100644
index 0000000..3af7c41
--- /dev/null
+++ b/drivers/media/usb/b2c2/Kconfig
@@ -0,0 +1,6 @@
+config DVB_B2C2_FLEXCOP_USB
+	tristate "Technisat/B2C2 Air/Sky/Cable2PC USB"
+	help
+	  Support for the Air/Sky/Cable2PC USB1.1 box (DVB/ATSC) by Technisat/B2C2,
+
+	  Say Y if you own such a device and want to use it.
diff --git a/drivers/media/usb/b2c2/Makefile b/drivers/media/usb/b2c2/Makefile
new file mode 100644
index 0000000..9eaf208
--- /dev/null
+++ b/drivers/media/usb/b2c2/Makefile
@@ -0,0 +1,7 @@
+b2c2-flexcop-usb-objs = flexcop-usb.o
+obj-$(CONFIG_DVB_B2C2_FLEXCOP_USB) += b2c2-flexcop-usb.o
+
+ccflags-y += -Idrivers/media/dvb-core/
+ccflags-y += -Idrivers/media/dvb-frontends/
+ccflags-y += -Idrivers/media/common/tuners/
+ccflags-y += -Idrivers/media/common/b2c2/
diff --git a/drivers/media/pci/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
similarity index 100%
rename from drivers/media/pci/b2c2/flexcop-usb.c
rename to drivers/media/usb/b2c2/flexcop-usb.c
diff --git a/drivers/media/pci/b2c2/flexcop-usb.h b/drivers/media/usb/b2c2/flexcop-usb.h
similarity index 100%
rename from drivers/media/pci/b2c2/flexcop-usb.h
rename to drivers/media/usb/b2c2/flexcop-usb.h
-- 
1.7.10.2

