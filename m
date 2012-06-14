Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab2FNUix (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 16:38:53 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5EKcrcB027629
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 16:38:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 02/10] [media] dvb: move the dvb core one level up
Date: Thu, 14 Jun 2012 17:35:53 -0300
Message-Id: <1339706161-22713-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
References: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

just like the V4L2 core, move the DVB core to drivers/media, as the
intention is to get rid of both "video" and "dvb" directories.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig                             |    1 +
 drivers/media/Makefile                            |    2 +-
 drivers/media/common/tuners/Makefile              |    2 +-
 drivers/media/dvb-core/Kconfig                    |   29 +++++++++++++++++++++
 drivers/media/{dvb => }/dvb-core/Makefile         |    0
 drivers/media/{dvb => }/dvb-core/demux.h          |    0
 drivers/media/{dvb => }/dvb-core/dmxdev.c         |    0
 drivers/media/{dvb => }/dvb-core/dmxdev.h         |    0
 drivers/media/{dvb => }/dvb-core/dvb_ca_en50221.c |    0
 drivers/media/{dvb => }/dvb-core/dvb_ca_en50221.h |    0
 drivers/media/{dvb => }/dvb-core/dvb_demux.c      |    0
 drivers/media/{dvb => }/dvb-core/dvb_demux.h      |    0
 drivers/media/{dvb => }/dvb-core/dvb_filter.c     |    0
 drivers/media/{dvb => }/dvb-core/dvb_filter.h     |    0
 drivers/media/{dvb => }/dvb-core/dvb_frontend.c   |    0
 drivers/media/{dvb => }/dvb-core/dvb_frontend.h   |    0
 drivers/media/{dvb => }/dvb-core/dvb_math.c       |    0
 drivers/media/{dvb => }/dvb-core/dvb_math.h       |    0
 drivers/media/{dvb => }/dvb-core/dvb_net.c        |    0
 drivers/media/{dvb => }/dvb-core/dvb_net.h        |    0
 drivers/media/{dvb => }/dvb-core/dvb_ringbuffer.c |    0
 drivers/media/{dvb => }/dvb-core/dvb_ringbuffer.h |    0
 drivers/media/{dvb => }/dvb-core/dvbdev.c         |    0
 drivers/media/{dvb => }/dvb-core/dvbdev.h         |    0
 drivers/media/dvb/Kconfig                         |   26 ------------------
 drivers/media/dvb/Makefile                        |    3 +--
 drivers/media/dvb/b2c2/Makefile                   |    2 +-
 drivers/media/dvb/bt8xx/Makefile                  |    2 +-
 drivers/media/dvb/ddbridge/Makefile               |    2 +-
 drivers/media/dvb/dm1105/Makefile                 |    2 +-
 drivers/media/dvb/dvb-usb/Makefile                |    2 +-
 drivers/media/dvb/firewire/Makefile               |    2 +-
 drivers/media/dvb/frontends/Makefile              |    2 +-
 drivers/media/dvb/mantis/Makefile                 |    2 +-
 drivers/media/dvb/ngene/Makefile                  |    2 +-
 drivers/media/dvb/pluto2/Makefile                 |    2 +-
 drivers/media/dvb/pt1/Makefile                    |    2 +-
 drivers/media/dvb/siano/Makefile                  |    2 +-
 drivers/media/dvb/ttpci/Makefile                  |    2 +-
 drivers/media/dvb/ttusb-budget/Makefile           |    2 +-
 drivers/media/dvb/ttusb-dec/Makefile              |    2 +-
 drivers/media/v4l2-core/Makefile                  |    2 +-
 drivers/media/video/Makefile                      |    2 +-
 drivers/media/video/au0828/Makefile               |    2 +-
 drivers/media/video/bt8xx/Makefile                |    2 +-
 drivers/media/video/cx18/Makefile                 |    2 +-
 drivers/media/video/cx231xx/Makefile              |    2 +-
 drivers/media/video/cx23885/Makefile              |    2 +-
 drivers/media/video/cx25821/Makefile              |    2 +-
 drivers/media/video/cx88/Makefile                 |    2 +-
 drivers/media/video/em28xx/Makefile               |    2 +-
 drivers/media/video/ivtv/Makefile                 |    2 +-
 drivers/media/video/pvrusb2/Makefile              |    2 +-
 drivers/media/video/saa7134/Makefile              |    2 +-
 drivers/media/video/saa7164/Makefile              |    2 +-
 drivers/media/video/tlg2300/Makefile              |    2 +-
 drivers/media/video/tm6000/Makefile               |    2 +-
 drivers/staging/media/as102/Makefile              |    2 +-
 drivers/staging/media/cxd2099/Makefile            |    2 +-
 drivers/staging/media/go7007/Makefile             |    2 +-
 60 files changed, 67 insertions(+), 64 deletions(-)
 create mode 100644 drivers/media/dvb-core/Kconfig
 rename drivers/media/{dvb => }/dvb-core/Makefile (100%)
 rename drivers/media/{dvb => }/dvb-core/demux.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dmxdev.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dmxdev.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_ca_en50221.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_ca_en50221.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_demux.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_demux.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_filter.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_filter.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_frontend.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_frontend.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_math.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_math.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_net.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_net.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_ringbuffer.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_ringbuffer.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvbdev.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvbdev.h (100%)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 8bb3b66..e9159de 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -163,6 +163,7 @@ source "drivers/media/radio/Kconfig"
 # DVB adapters
 #
 
+source "drivers/media/dvb-core/Kconfig"
 source "drivers/media/dvb/Kconfig"
 
 endif # MEDIA_SUPPORT
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 2f9abaa..7f9f99a 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -11,4 +11,4 @@ endif
 obj-y += v4l2-core/ common/ rc/ video/
 
 obj-$(CONFIG_VIDEO_DEV) += radio/
-obj-$(CONFIG_DVB_CORE)  += dvb/
+obj-$(CONFIG_DVB_CORE)  += dvb-core/ dvb/
diff --git a/drivers/media/common/tuners/Makefile b/drivers/media/common/tuners/Makefile
index 891b80e..2ddbb2c 100644
--- a/drivers/media/common/tuners/Makefile
+++ b/drivers/media/common/tuners/Makefile
@@ -33,5 +33,5 @@ obj-$(CONFIG_MEDIA_TUNER_FC0011) += fc0011.o
 obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
 obj-$(CONFIG_MEDIA_TUNER_FC0013) += fc0013.o
 
-ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
+ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
diff --git a/drivers/media/dvb-core/Kconfig b/drivers/media/dvb-core/Kconfig
new file mode 100644
index 0000000..fa7a249
--- /dev/null
+++ b/drivers/media/dvb-core/Kconfig
@@ -0,0 +1,29 @@
+#
+# DVB device configuration
+#
+
+config DVB_MAX_ADAPTERS
+	int "maximum number of DVB/ATSC adapters"
+	depends on DVB_CORE
+	default 8
+	range 1 255
+	help
+	  Maximum number of DVB/ATSC adapters. Increasing this number
+	  increases the memory consumption of the DVB subsystem even
+	  if a much lower number of DVB/ATSC adapters is present.
+	  Only values in the range 4-32 are tested.
+
+	  If you are unsure about this, use the default value 8
+
+config DVB_DYNAMIC_MINORS
+	bool "Dynamic DVB minor allocation"
+	depends on DVB_CORE
+	default n
+	help
+	  If you say Y here, the DVB subsystem will use dynamic minor
+	  allocation for any device that uses the DVB major number.
+	  This means that you can have more than 4 of a single type
+	  of device (like demuxes and frontends) per adapter, but udev
+	  will be required to manage the device nodes.
+
+	  If you are unsure about this, say N here.
diff --git a/drivers/media/dvb/dvb-core/Makefile b/drivers/media/dvb-core/Makefile
similarity index 100%
rename from drivers/media/dvb/dvb-core/Makefile
rename to drivers/media/dvb-core/Makefile
diff --git a/drivers/media/dvb/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
similarity index 100%
rename from drivers/media/dvb/dvb-core/demux.h
rename to drivers/media/dvb-core/demux.h
diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
similarity index 100%
rename from drivers/media/dvb/dvb-core/dmxdev.c
rename to drivers/media/dvb-core/dmxdev.c
diff --git a/drivers/media/dvb/dvb-core/dmxdev.h b/drivers/media/dvb-core/dmxdev.h
similarity index 100%
rename from drivers/media/dvb/dvb-core/dmxdev.h
rename to drivers/media/dvb-core/dmxdev.h
diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvb_ca_en50221.c
rename to drivers/media/dvb-core/dvb_ca_en50221.c
diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.h b/drivers/media/dvb-core/dvb_ca_en50221.h
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvb_ca_en50221.h
rename to drivers/media/dvb-core/dvb_ca_en50221.h
diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvb_demux.c
rename to drivers/media/dvb-core/dvb_demux.c
diff --git a/drivers/media/dvb/dvb-core/dvb_demux.h b/drivers/media/dvb-core/dvb_demux.h
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvb_demux.h
rename to drivers/media/dvb-core/dvb_demux.h
diff --git a/drivers/media/dvb/dvb-core/dvb_filter.c b/drivers/media/dvb-core/dvb_filter.c
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvb_filter.c
rename to drivers/media/dvb-core/dvb_filter.c
diff --git a/drivers/media/dvb/dvb-core/dvb_filter.h b/drivers/media/dvb-core/dvb_filter.h
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvb_filter.h
rename to drivers/media/dvb-core/dvb_filter.h
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvb_frontend.c
rename to drivers/media/dvb-core/dvb_frontend.c
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvb_frontend.h
rename to drivers/media/dvb-core/dvb_frontend.h
diff --git a/drivers/media/dvb/dvb-core/dvb_math.c b/drivers/media/dvb-core/dvb_math.c
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvb_math.c
rename to drivers/media/dvb-core/dvb_math.c
diff --git a/drivers/media/dvb/dvb-core/dvb_math.h b/drivers/media/dvb-core/dvb_math.h
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvb_math.h
rename to drivers/media/dvb-core/dvb_math.h
diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvb_net.c
rename to drivers/media/dvb-core/dvb_net.c
diff --git a/drivers/media/dvb/dvb-core/dvb_net.h b/drivers/media/dvb-core/dvb_net.h
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvb_net.h
rename to drivers/media/dvb-core/dvb_net.h
diff --git a/drivers/media/dvb/dvb-core/dvb_ringbuffer.c b/drivers/media/dvb-core/dvb_ringbuffer.c
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvb_ringbuffer.c
rename to drivers/media/dvb-core/dvb_ringbuffer.c
diff --git a/drivers/media/dvb/dvb-core/dvb_ringbuffer.h b/drivers/media/dvb-core/dvb_ringbuffer.h
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvb_ringbuffer.h
rename to drivers/media/dvb-core/dvb_ringbuffer.h
diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvbdev.c
rename to drivers/media/dvb-core/dvbdev.c
diff --git a/drivers/media/dvb/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
similarity index 100%
rename from drivers/media/dvb/dvb-core/dvbdev.h
rename to drivers/media/dvb-core/dvbdev.h
diff --git a/drivers/media/dvb/Kconfig b/drivers/media/dvb/Kconfig
index f6e40b3..1b2ac47 100644
--- a/drivers/media/dvb/Kconfig
+++ b/drivers/media/dvb/Kconfig
@@ -2,32 +2,6 @@
 # DVB device configuration
 #
 
-config DVB_MAX_ADAPTERS
-	int "maximum number of DVB/ATSC adapters"
-	depends on DVB_CORE
-	default 8
-	range 1 255
-	help
-	  Maximum number of DVB/ATSC adapters. Increasing this number
-	  increases the memory consumption of the DVB subsystem even
-	  if a much lower number of DVB/ATSC adapters is present.
-	  Only values in the range 4-32 are tested.
-
-	  If you are unsure about this, use the default value 8
-
-config DVB_DYNAMIC_MINORS
-	bool "Dynamic DVB minor allocation"
-	depends on DVB_CORE
-	default n
-	help
-	  If you say Y here, the DVB subsystem will use dynamic minor
-	  allocation for any device that uses the DVB major number.
-	  This means that you can have more than 4 of a single type
-	  of device (like demuxes and frontends) per adapter, but udev
-	  will be required to manage the device nodes.
-
-	  If you are unsure about this, say N here.
-
 menuconfig DVB_CAPTURE_DRIVERS
 	bool "DVB/ATSC adapters"
 	depends on DVB_CORE
diff --git a/drivers/media/dvb/Makefile b/drivers/media/dvb/Makefile
index b2cefe6..4ac62b7 100644
--- a/drivers/media/dvb/Makefile
+++ b/drivers/media/dvb/Makefile
@@ -2,8 +2,7 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
-obj-y        := dvb-core/	\
-		frontends/	\
+obj-y        :=	frontends/	\
 		ttpci/		\
 		ttusb-dec/	\
 		ttusb-budget/	\
diff --git a/drivers/media/dvb/b2c2/Makefile b/drivers/media/dvb/b2c2/Makefile
index 3d04a8d..e4291e4 100644
--- a/drivers/media/dvb/b2c2/Makefile
+++ b/drivers/media/dvb/b2c2/Makefile
@@ -12,5 +12,5 @@ obj-$(CONFIG_DVB_B2C2_FLEXCOP_PCI) += b2c2-flexcop-pci.o
 b2c2-flexcop-usb-objs = flexcop-usb.o
 obj-$(CONFIG_DVB_B2C2_FLEXCOP_USB) += b2c2-flexcop-usb.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb/frontends/
 ccflags-y += -Idrivers/media/common/tuners/
diff --git a/drivers/media/dvb/bt8xx/Makefile b/drivers/media/dvb/bt8xx/Makefile
index 0713b3a..7c2dd04 100644
--- a/drivers/media/dvb/bt8xx/Makefile
+++ b/drivers/media/dvb/bt8xx/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o dst.o dst_ca.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
 ccflags-y += -Idrivers/media/video/bt8xx
 ccflags-y += -Idrivers/media/common/tuners
diff --git a/drivers/media/dvb/ddbridge/Makefile b/drivers/media/dvb/ddbridge/Makefile
index 38019ba..9eca27d 100644
--- a/drivers/media/dvb/ddbridge/Makefile
+++ b/drivers/media/dvb/ddbridge/Makefile
@@ -6,7 +6,7 @@ ddbridge-objs := ddbridge-core.o
 
 obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core/
+ccflags-y += -Idrivers/media/dvb-core/
 ccflags-y += -Idrivers/media/dvb/frontends/
 ccflags-y += -Idrivers/media/common/tuners/
 
diff --git a/drivers/media/dvb/dm1105/Makefile b/drivers/media/dvb/dm1105/Makefile
index 95a008b..0dc5963 100644
--- a/drivers/media/dvb/dm1105/Makefile
+++ b/drivers/media/dvb/dm1105/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_DVB_DM1105) += dm1105.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb/frontends
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index b667ac3..90deca2 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -113,7 +113,7 @@ obj-$(CONFIG_DVB_USB_RTL28XXU) += dvb-usb-rtl28xxu.o
 dvb-usb-af9035-objs = af9035.o
 obj-$(CONFIG_DVB_USB_AF9035) += dvb-usb-af9035.o
 
-ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
+ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb/frontends/
 # due to tuner-xc3028
 ccflags-y += -I$(srctree)/drivers/media/common/tuners
diff --git a/drivers/media/dvb/firewire/Makefile b/drivers/media/dvb/firewire/Makefile
index 357b3aa..f314813 100644
--- a/drivers/media/dvb/firewire/Makefile
+++ b/drivers/media/dvb/firewire/Makefile
@@ -3,4 +3,4 @@ obj-$(CONFIG_DVB_FIREDTV) += firedtv.o
 firedtv-y := firedtv-avc.o firedtv-ci.o firedtv-dvb.o firedtv-fe.o firedtv-fw.o
 firedtv-$(CONFIG_DVB_FIREDTV_INPUT)    += firedtv-rc.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
index cd1ac2f..28671c2 100644
--- a/drivers/media/dvb/frontends/Makefile
+++ b/drivers/media/dvb/frontends/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel DVB frontend device drivers.
 #
 
-ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core/
+ccflags-y += -I$(srctree)/drivers/media/dvb-core/
 ccflags-y += -I$(srctree)/drivers/media/common/tuners/
 
 stb0899-objs = stb0899_drv.o stb0899_algo.o
diff --git a/drivers/media/dvb/mantis/Makefile b/drivers/media/dvb/mantis/Makefile
index ec8116d..3384119 100644
--- a/drivers/media/dvb/mantis/Makefile
+++ b/drivers/media/dvb/mantis/Makefile
@@ -25,4 +25,4 @@ obj-$(CONFIG_MANTIS_CORE)	+= mantis_core.o
 obj-$(CONFIG_DVB_MANTIS)	+= mantis.o
 obj-$(CONFIG_DVB_HOPPER)	+= hopper.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb/frontends/
diff --git a/drivers/media/dvb/ngene/Makefile b/drivers/media/dvb/ngene/Makefile
index 13ebeff..dae7659 100644
--- a/drivers/media/dvb/ngene/Makefile
+++ b/drivers/media/dvb/ngene/Makefile
@@ -6,7 +6,7 @@ ngene-objs := ngene-core.o ngene-i2c.o ngene-cards.o ngene-dvb.o
 
 obj-$(CONFIG_DVB_NGENE) += ngene.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core/
+ccflags-y += -Idrivers/media/dvb-core/
 ccflags-y += -Idrivers/media/dvb/frontends/
 ccflags-y += -Idrivers/media/common/tuners/
 
diff --git a/drivers/media/dvb/pluto2/Makefile b/drivers/media/dvb/pluto2/Makefile
index 7008223..14fa578 100644
--- a/drivers/media/dvb/pluto2/Makefile
+++ b/drivers/media/dvb/pluto2/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_DVB_PLUTO2) += pluto2.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb/frontends/
diff --git a/drivers/media/dvb/pt1/Makefile b/drivers/media/dvb/pt1/Makefile
index d80d8e8..c80492a 100644
--- a/drivers/media/dvb/pt1/Makefile
+++ b/drivers/media/dvb/pt1/Makefile
@@ -2,4 +2,4 @@ earth-pt1-objs := pt1.o va1j5jf8007s.o va1j5jf8007t.o
 
 obj-$(CONFIG_DVB_PT1) += earth-pt1.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-core -Idrivers/media/dvb/frontends
diff --git a/drivers/media/dvb/siano/Makefile b/drivers/media/dvb/siano/Makefile
index f233b57..14756bd 100644
--- a/drivers/media/dvb/siano/Makefile
+++ b/drivers/media/dvb/siano/Makefile
@@ -5,7 +5,7 @@ obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o smsdvb.o
 obj-$(CONFIG_SMS_USB_DRV) += smsusb.o
 obj-$(CONFIG_SMS_SDIO_DRV) += smssdio.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
 
 ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
 
diff --git a/drivers/media/dvb/ttpci/Makefile b/drivers/media/dvb/ttpci/Makefile
index f6e8693..b0ddb45 100644
--- a/drivers/media/dvb/ttpci/Makefile
+++ b/drivers/media/dvb/ttpci/Makefile
@@ -17,5 +17,5 @@ obj-$(CONFIG_DVB_BUDGET_CI) += budget-ci.o
 obj-$(CONFIG_DVB_BUDGET_PATCH) += budget-patch.o
 obj-$(CONFIG_DVB_AV7110) += dvb-ttpci.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb/frontends/
 ccflags-y += -Idrivers/media/common/tuners
diff --git a/drivers/media/dvb/ttusb-budget/Makefile b/drivers/media/dvb/ttusb-budget/Makefile
index 8d6c4ac..c5abe78 100644
--- a/drivers/media/dvb/ttusb-budget/Makefile
+++ b/drivers/media/dvb/ttusb-budget/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_DVB_TTUSB_BUDGET) += dvb-ttusb-budget.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb/frontends
diff --git a/drivers/media/dvb/ttusb-dec/Makefile b/drivers/media/dvb/ttusb-dec/Makefile
index ed28b53..5352740 100644
--- a/drivers/media/dvb/ttusb-dec/Makefile
+++ b/drivers/media/dvb/ttusb-dec/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_DVB_TTUSB_DEC) += ttusb_dec.o ttusbdecfe.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core/
+ccflags-y += -Idrivers/media/dvb-core/
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 7319c27..f5036d1 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -29,7 +29,7 @@ obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
 obj-$(CONFIG_VIDEOBUF2_DMA_SG) += videobuf2-dma-sg.o
 
-ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
+ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
 ccflags-y += -I$(srctree)/drivers/media/common/tuners
 
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 088d834..d8ffba9 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -185,6 +185,6 @@ obj-y	+= davinci/
 
 obj-$(CONFIG_ARCH_OMAP)	+= omap/
 
-ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
+ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
 ccflags-y += -I$(srctree)/drivers/media/common/tuners
diff --git a/drivers/media/video/au0828/Makefile b/drivers/media/video/au0828/Makefile
index bd22223..59d15b3 100644
--- a/drivers/media/video/au0828/Makefile
+++ b/drivers/media/video/au0828/Makefile
@@ -3,7 +3,7 @@ au0828-objs	:= au0828-core.o au0828-i2c.o au0828-cards.o au0828-dvb.o au0828-vid
 obj-$(CONFIG_VIDEO_AU0828) += au0828.o
 
 ccflags-y += -Idrivers/media/common/tuners
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
 
 ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/video/bt8xx/Makefile b/drivers/media/video/bt8xx/Makefile
index 3f9a2b2..4cba4ef 100644
--- a/drivers/media/video/bt8xx/Makefile
+++ b/drivers/media/video/bt8xx/Makefile
@@ -10,4 +10,4 @@ obj-$(CONFIG_VIDEO_BT848) += bttv.o
 
 ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
diff --git a/drivers/media/video/cx18/Makefile b/drivers/media/video/cx18/Makefile
index a86bab5..e0701e9 100644
--- a/drivers/media/video/cx18/Makefile
+++ b/drivers/media/video/cx18/Makefile
@@ -8,6 +8,6 @@ cx18-alsa-objs := cx18-alsa-main.o cx18-alsa-pcm.o
 obj-$(CONFIG_VIDEO_CX18) += cx18.o
 obj-$(CONFIG_VIDEO_CX18_ALSA) += cx18-alsa.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
 ccflags-y += -Idrivers/media/common/tuners
diff --git a/drivers/media/video/cx231xx/Makefile b/drivers/media/video/cx231xx/Makefile
index b334897..fc72cad 100644
--- a/drivers/media/video/cx231xx/Makefile
+++ b/drivers/media/video/cx231xx/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_VIDEO_CX231XX_DVB) += cx231xx-dvb.o
 
 ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
 ccflags-y += -Idrivers/media/dvb/dvb-usb
 
diff --git a/drivers/media/video/cx23885/Makefile b/drivers/media/video/cx23885/Makefile
index f81f279..3608f32 100644
--- a/drivers/media/video/cx23885/Makefile
+++ b/drivers/media/video/cx23885/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_MEDIA_ALTERA_CI) += altera-ci.o
 
 ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
 
 ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/video/cx25821/Makefile b/drivers/media/video/cx25821/Makefile
index aedde18..1628aa3 100644
--- a/drivers/media/video/cx25821/Makefile
+++ b/drivers/media/video/cx25821/Makefile
@@ -9,5 +9,5 @@ obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
 
 ccflags-y := -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/cx88/Makefile b/drivers/media/video/cx88/Makefile
index c1a2785..1902366 100644
--- a/drivers/media/video/cx88/Makefile
+++ b/drivers/media/video/cx88/Makefile
@@ -12,5 +12,5 @@ obj-$(CONFIG_VIDEO_CX88_VP3054) += cx88-vp3054-i2c.o
 
 ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/em28xx/Makefile b/drivers/media/video/em28xx/Makefile
index c8b338d..b00298a 100644
--- a/drivers/media/video/em28xx/Makefile
+++ b/drivers/media/video/em28xx/Makefile
@@ -11,5 +11,5 @@ obj-$(CONFIG_VIDEO_EM28XX_RC) += em28xx-rc.o
 
 ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/ivtv/Makefile b/drivers/media/video/ivtv/Makefile
index 77de8a4..c54cfe1 100644
--- a/drivers/media/video/ivtv/Makefile
+++ b/drivers/media/video/ivtv/Makefile
@@ -9,6 +9,6 @@ obj-$(CONFIG_VIDEO_FB_IVTV) += ivtvfb.o
 
 ccflags-y += -I$(srctree)/drivers/media/video
 ccflags-y += -I$(srctree)/drivers/media/common/tuners
-ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
+ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
 
diff --git a/drivers/media/video/pvrusb2/Makefile b/drivers/media/video/pvrusb2/Makefile
index c17f37d..298a930 100644
--- a/drivers/media/video/pvrusb2/Makefile
+++ b/drivers/media/video/pvrusb2/Makefile
@@ -18,5 +18,5 @@ obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2.o
 
 ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/saa7134/Makefile b/drivers/media/video/saa7134/Makefile
index da38993..364891f 100644
--- a/drivers/media/video/saa7134/Makefile
+++ b/drivers/media/video/saa7134/Makefile
@@ -12,5 +12,5 @@ obj-$(CONFIG_VIDEO_SAA7134_DVB) += saa7134-dvb.o
 
 ccflags-y += -I$(srctree)/drivers/media/video
 ccflags-y += -I$(srctree)/drivers/media/common/tuners
-ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
+ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
diff --git a/drivers/media/video/saa7164/Makefile b/drivers/media/video/saa7164/Makefile
index 068443a..50e19f9 100644
--- a/drivers/media/video/saa7164/Makefile
+++ b/drivers/media/video/saa7164/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_VIDEO_SAA7164) += saa7164.o
 
 ccflags-y += -I$(srctree)/drivers/media/video
 ccflags-y += -I$(srctree)/drivers/media/common/tuners
-ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
+ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
 
 ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/video/tlg2300/Makefile b/drivers/media/video/tlg2300/Makefile
index ea09b9a..f0f4f6a 100644
--- a/drivers/media/video/tlg2300/Makefile
+++ b/drivers/media/video/tlg2300/Makefile
@@ -4,6 +4,6 @@ obj-$(CONFIG_VIDEO_TLG2300) += poseidon.o
 
 ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
 
diff --git a/drivers/media/video/tm6000/Makefile b/drivers/media/video/tm6000/Makefile
index 395515b..b797a8a 100644
--- a/drivers/media/video/tm6000/Makefile
+++ b/drivers/media/video/tm6000/Makefile
@@ -11,5 +11,5 @@ obj-$(CONFIG_VIDEO_TM6000_DVB) += tm6000-dvb.o
 
 ccflags-y := -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
diff --git a/drivers/staging/media/as102/Makefile b/drivers/staging/media/as102/Makefile
index 1bca43e..d8dfb75 100644
--- a/drivers/staging/media/as102/Makefile
+++ b/drivers/staging/media/as102/Makefile
@@ -3,4 +3,4 @@ dvb-as102-objs := as102_drv.o as102_fw.o as10x_cmd.o as10x_cmd_stream.o \
 
 obj-$(CONFIG_DVB_AS102) += dvb-as102.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
+EXTRA_CFLAGS += -Idrivers/media/dvb-core
diff --git a/drivers/staging/media/cxd2099/Makefile b/drivers/staging/media/cxd2099/Makefile
index 64cfc77..b0833fa 100644
--- a/drivers/staging/media/cxd2099/Makefile
+++ b/drivers/staging/media/cxd2099/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_DVB_CXD2099) += cxd2099.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core/
+ccflags-y += -Idrivers/media/dvb-core/
 ccflags-y += -Idrivers/media/dvb/frontends/
 ccflags-y += -Idrivers/media/common/tuners/
diff --git a/drivers/staging/media/go7007/Makefile b/drivers/staging/media/go7007/Makefile
index 6ee837c..eea1e72 100644
--- a/drivers/staging/media/go7007/Makefile
+++ b/drivers/staging/media/go7007/Makefile
@@ -27,4 +27,4 @@ s2250-y := s2250-board.o
 ccflags-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD:m=y) += -Idrivers/media/dvb/dvb-usb
 
 ccflags-y += -Idrivers/media/dvb/frontends
-ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
-- 
1.7.10.2

