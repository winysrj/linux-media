Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334Ab2FNUix (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 16:38:53 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5EKcrRU022304
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 16:38:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 08/10] [media] common: move media/common/tuners to media/tuners
Date: Thu, 14 Jun 2012 17:35:59 -0300
Message-Id: <1339706161-22713-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
References: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the tuners one level up, as the "common" directory will be used
by drivers that are shared between more than one driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 MAINTAINERS                                            |    4 ++--
 drivers/media/Kconfig                                  |    2 +-
 drivers/media/Makefile                                 |    2 +-
 drivers/media/common/Makefile                          |    2 +-
 drivers/media/common/b2c2/Makefile                     |    2 +-
 drivers/media/dvb-frontends/Makefile                   |    2 +-
 drivers/media/pci/bt8xx/Makefile                       |    2 +-
 drivers/media/pci/ddbridge/Makefile                    |    2 +-
 drivers/media/pci/ngene/Makefile                       |    2 +-
 drivers/media/pci/ttpci/Makefile                       |    2 +-
 drivers/media/{common => }/tuners/Kconfig              |    0
 drivers/media/{common => }/tuners/Makefile             |    0
 drivers/media/{common => }/tuners/fc0011.c             |    0
 drivers/media/{common => }/tuners/fc0011.h             |    0
 drivers/media/{common => }/tuners/fc0012-priv.h        |    0
 drivers/media/{common => }/tuners/fc0012.c             |    0
 drivers/media/{common => }/tuners/fc0012.h             |    0
 drivers/media/{common => }/tuners/fc0013-priv.h        |    0
 drivers/media/{common => }/tuners/fc0013.c             |    0
 drivers/media/{common => }/tuners/fc0013.h             |    0
 drivers/media/{common => }/tuners/fc001x-common.h      |    0
 drivers/media/{common => }/tuners/max2165.c            |    0
 drivers/media/{common => }/tuners/max2165.h            |    0
 drivers/media/{common => }/tuners/max2165_priv.h       |    0
 drivers/media/{common => }/tuners/mc44s803.c           |    0
 drivers/media/{common => }/tuners/mc44s803.h           |    0
 drivers/media/{common => }/tuners/mc44s803_priv.h      |    0
 drivers/media/{common => }/tuners/mt2060.c             |    0
 drivers/media/{common => }/tuners/mt2060.h             |    0
 drivers/media/{common => }/tuners/mt2060_priv.h        |    0
 drivers/media/{common => }/tuners/mt2063.c             |    0
 drivers/media/{common => }/tuners/mt2063.h             |    0
 drivers/media/{common => }/tuners/mt20xx.c             |    0
 drivers/media/{common => }/tuners/mt20xx.h             |    0
 drivers/media/{common => }/tuners/mt2131.c             |    0
 drivers/media/{common => }/tuners/mt2131.h             |    0
 drivers/media/{common => }/tuners/mt2131_priv.h        |    0
 drivers/media/{common => }/tuners/mt2266.c             |    0
 drivers/media/{common => }/tuners/mt2266.h             |    0
 drivers/media/{common => }/tuners/mxl5005s.c           |    0
 drivers/media/{common => }/tuners/mxl5005s.h           |    0
 drivers/media/{common => }/tuners/mxl5007t.c           |    0
 drivers/media/{common => }/tuners/mxl5007t.h           |    0
 drivers/media/{common => }/tuners/qt1010.c             |    0
 drivers/media/{common => }/tuners/qt1010.h             |    0
 drivers/media/{common => }/tuners/qt1010_priv.h        |    0
 drivers/media/{common => }/tuners/tda18212.c           |    0
 drivers/media/{common => }/tuners/tda18212.h           |    0
 drivers/media/{common => }/tuners/tda18218.c           |    0
 drivers/media/{common => }/tuners/tda18218.h           |    0
 drivers/media/{common => }/tuners/tda18218_priv.h      |    0
 drivers/media/{common => }/tuners/tda18271-common.c    |    0
 drivers/media/{common => }/tuners/tda18271-fe.c        |    0
 drivers/media/{common => }/tuners/tda18271-maps.c      |    0
 drivers/media/{common => }/tuners/tda18271-priv.h      |    0
 drivers/media/{common => }/tuners/tda18271.h           |    0
 drivers/media/{common => }/tuners/tda827x.c            |    0
 drivers/media/{common => }/tuners/tda827x.h            |    0
 drivers/media/{common => }/tuners/tda8290.c            |    0
 drivers/media/{common => }/tuners/tda8290.h            |    0
 drivers/media/{common => }/tuners/tda9887.c            |    0
 drivers/media/{common => }/tuners/tda9887.h            |    0
 drivers/media/{common => }/tuners/tea5761.c            |    0
 drivers/media/{common => }/tuners/tea5761.h            |    0
 drivers/media/{common => }/tuners/tea5767.c            |    0
 drivers/media/{common => }/tuners/tea5767.h            |    0
 drivers/media/{common => }/tuners/tua9001.c            |    0
 drivers/media/{common => }/tuners/tua9001.h            |    0
 drivers/media/{common => }/tuners/tua9001_priv.h       |    0
 drivers/media/{common => }/tuners/tuner-i2c.h          |    0
 drivers/media/{common => }/tuners/tuner-simple.c       |    0
 drivers/media/{common => }/tuners/tuner-simple.h       |    0
 drivers/media/{common => }/tuners/tuner-types.c        |    0
 drivers/media/{common => }/tuners/tuner-xc2028-types.h |    0
 drivers/media/{common => }/tuners/tuner-xc2028.c       |    0
 drivers/media/{common => }/tuners/tuner-xc2028.h       |    0
 drivers/media/{common => }/tuners/xc4000.c             |    0
 drivers/media/{common => }/tuners/xc4000.h             |    0
 drivers/media/{common => }/tuners/xc5000.c             |    0
 drivers/media/{common => }/tuners/xc5000.h             |    0
 drivers/media/usb/b2c2/Makefile                        |    2 +-
 drivers/media/usb/dvb-usb/Makefile                     |    2 +-
 drivers/media/v4l2-core/Makefile                       |    2 +-
 drivers/media/video/Makefile                           |    2 +-
 drivers/media/video/au0828/Makefile                    |    2 +-
 drivers/media/video/bt8xx/Makefile                     |    2 +-
 drivers/media/video/cx18/Makefile                      |    2 +-
 drivers/media/video/cx231xx/Makefile                   |    2 +-
 drivers/media/video/cx23885/Makefile                   |    2 +-
 drivers/media/video/cx25821/Makefile                   |    2 +-
 drivers/media/video/cx88/Makefile                      |    2 +-
 drivers/media/video/em28xx/Makefile                    |    2 +-
 drivers/media/video/ivtv/Makefile                      |    2 +-
 drivers/media/video/pvrusb2/Makefile                   |    2 +-
 drivers/media/video/saa7134/Makefile                   |    2 +-
 drivers/media/video/saa7164/Makefile                   |    2 +-
 drivers/media/video/tlg2300/Makefile                   |    2 +-
 drivers/media/video/tm6000/Makefile                    |    2 +-
 drivers/media/video/usbvision/Makefile                 |    2 +-
 drivers/staging/media/cxd2099/Makefile                 |    2 +-
 100 files changed, 31 insertions(+), 31 deletions(-)
 rename drivers/media/{common => }/tuners/Kconfig (100%)
 rename drivers/media/{common => }/tuners/Makefile (100%)
 rename drivers/media/{common => }/tuners/fc0011.c (100%)
 rename drivers/media/{common => }/tuners/fc0011.h (100%)
 rename drivers/media/{common => }/tuners/fc0012-priv.h (100%)
 rename drivers/media/{common => }/tuners/fc0012.c (100%)
 rename drivers/media/{common => }/tuners/fc0012.h (100%)
 rename drivers/media/{common => }/tuners/fc0013-priv.h (100%)
 rename drivers/media/{common => }/tuners/fc0013.c (100%)
 rename drivers/media/{common => }/tuners/fc0013.h (100%)
 rename drivers/media/{common => }/tuners/fc001x-common.h (100%)
 rename drivers/media/{common => }/tuners/max2165.c (100%)
 rename drivers/media/{common => }/tuners/max2165.h (100%)
 rename drivers/media/{common => }/tuners/max2165_priv.h (100%)
 rename drivers/media/{common => }/tuners/mc44s803.c (100%)
 rename drivers/media/{common => }/tuners/mc44s803.h (100%)
 rename drivers/media/{common => }/tuners/mc44s803_priv.h (100%)
 rename drivers/media/{common => }/tuners/mt2060.c (100%)
 rename drivers/media/{common => }/tuners/mt2060.h (100%)
 rename drivers/media/{common => }/tuners/mt2060_priv.h (100%)
 rename drivers/media/{common => }/tuners/mt2063.c (100%)
 rename drivers/media/{common => }/tuners/mt2063.h (100%)
 rename drivers/media/{common => }/tuners/mt20xx.c (100%)
 rename drivers/media/{common => }/tuners/mt20xx.h (100%)
 rename drivers/media/{common => }/tuners/mt2131.c (100%)
 rename drivers/media/{common => }/tuners/mt2131.h (100%)
 rename drivers/media/{common => }/tuners/mt2131_priv.h (100%)
 rename drivers/media/{common => }/tuners/mt2266.c (100%)
 rename drivers/media/{common => }/tuners/mt2266.h (100%)
 rename drivers/media/{common => }/tuners/mxl5005s.c (100%)
 rename drivers/media/{common => }/tuners/mxl5005s.h (100%)
 rename drivers/media/{common => }/tuners/mxl5007t.c (100%)
 rename drivers/media/{common => }/tuners/mxl5007t.h (100%)
 rename drivers/media/{common => }/tuners/qt1010.c (100%)
 rename drivers/media/{common => }/tuners/qt1010.h (100%)
 rename drivers/media/{common => }/tuners/qt1010_priv.h (100%)
 rename drivers/media/{common => }/tuners/tda18212.c (100%)
 rename drivers/media/{common => }/tuners/tda18212.h (100%)
 rename drivers/media/{common => }/tuners/tda18218.c (100%)
 rename drivers/media/{common => }/tuners/tda18218.h (100%)
 rename drivers/media/{common => }/tuners/tda18218_priv.h (100%)
 rename drivers/media/{common => }/tuners/tda18271-common.c (100%)
 rename drivers/media/{common => }/tuners/tda18271-fe.c (100%)
 rename drivers/media/{common => }/tuners/tda18271-maps.c (100%)
 rename drivers/media/{common => }/tuners/tda18271-priv.h (100%)
 rename drivers/media/{common => }/tuners/tda18271.h (100%)
 rename drivers/media/{common => }/tuners/tda827x.c (100%)
 rename drivers/media/{common => }/tuners/tda827x.h (100%)
 rename drivers/media/{common => }/tuners/tda8290.c (100%)
 rename drivers/media/{common => }/tuners/tda8290.h (100%)
 rename drivers/media/{common => }/tuners/tda9887.c (100%)
 rename drivers/media/{common => }/tuners/tda9887.h (100%)
 rename drivers/media/{common => }/tuners/tea5761.c (100%)
 rename drivers/media/{common => }/tuners/tea5761.h (100%)
 rename drivers/media/{common => }/tuners/tea5767.c (100%)
 rename drivers/media/{common => }/tuners/tea5767.h (100%)
 rename drivers/media/{common => }/tuners/tua9001.c (100%)
 rename drivers/media/{common => }/tuners/tua9001.h (100%)
 rename drivers/media/{common => }/tuners/tua9001_priv.h (100%)
 rename drivers/media/{common => }/tuners/tuner-i2c.h (100%)
 rename drivers/media/{common => }/tuners/tuner-simple.c (100%)
 rename drivers/media/{common => }/tuners/tuner-simple.h (100%)
 rename drivers/media/{common => }/tuners/tuner-types.c (100%)
 rename drivers/media/{common => }/tuners/tuner-xc2028-types.h (100%)
 rename drivers/media/{common => }/tuners/tuner-xc2028.c (100%)
 rename drivers/media/{common => }/tuners/tuner-xc2028.h (100%)
 rename drivers/media/{common => }/tuners/xc4000.c (100%)
 rename drivers/media/{common => }/tuners/xc4000.h (100%)
 rename drivers/media/{common => }/tuners/xc5000.c (100%)
 rename drivers/media/{common => }/tuners/xc5000.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index f175f44..4f37a4c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2699,8 +2699,8 @@ FC0011 TUNER DRIVER
 M:	Michael Buesch <m@bues.ch>
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	drivers/media/common/tuners/fc0011.h
-F:	drivers/media/common/tuners/fc0011.c
+F:	drivers/media/tuners/fc0011.h
+F:	drivers/media/tuners/fc0011.c
 
 FANOTIFY
 M:	Eric Paris <eparis@redhat.com>
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index efc3055..7b079a4 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -147,7 +147,7 @@ source "drivers/media/rc/Kconfig"
 # Tuner drivers for DVB and V4L
 #
 
-source "drivers/media/common/tuners/Kconfig"
+source "drivers/media/tuners/Kconfig"
 
 #
 # Video/Radio/Hybrid adapters
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 90ec998..f89ccac 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -8,7 +8,7 @@ ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
   obj-$(CONFIG_MEDIA_SUPPORT) += media.o
 endif
 
-obj-y += v4l2-core/ common/ rc/ video/
+obj-y += v4l2-core/ tuners/ common/ rc/ video/
 
 obj-$(CONFIG_VIDEO_DEV) += radio/
 obj-$(CONFIG_DVB_CORE)  += dvb-core/ pci/ dvb-frontends/ usb/
diff --git a/drivers/media/common/Makefile b/drivers/media/common/Makefile
index d0512d7..a471242 100644
--- a/drivers/media/common/Makefile
+++ b/drivers/media/common/Makefile
@@ -1,6 +1,6 @@
 saa7146-objs    := saa7146_i2c.o saa7146_core.o
 saa7146_vv-objs := saa7146_fops.o saa7146_video.o saa7146_hlp.o saa7146_vbi.o
 
-obj-y += tuners/ b2c2/
+obj-y += b2c2/
 obj-$(CONFIG_VIDEO_SAA7146) += saa7146.o
 obj-$(CONFIG_VIDEO_SAA7146_VV) += saa7146_vv.o
diff --git a/drivers/media/common/b2c2/Makefile b/drivers/media/common/b2c2/Makefile
index 377d051..48a4c90 100644
--- a/drivers/media/common/b2c2/Makefile
+++ b/drivers/media/common/b2c2/Makefile
@@ -4,4 +4,4 @@ obj-$(CONFIG_DVB_B2C2_FLEXCOP) += b2c2-flexcop.o
 
 ccflags-y += -Idrivers/media/dvb-core/
 ccflags-y += -Idrivers/media/dvb-frontends/
-ccflags-y += -Idrivers/media/common/tuners/
+ccflags-y += -Idrivers/media/tuners/
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index 28671c2..3c8e39b 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -3,7 +3,7 @@
 #
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core/
-ccflags-y += -I$(srctree)/drivers/media/common/tuners/
+ccflags-y += -I$(srctree)/drivers/media/tuners/
 
 stb0899-objs = stb0899_drv.o stb0899_algo.o
 stv0900-objs = stv0900_core.o stv0900_sw.o
diff --git a/drivers/media/pci/bt8xx/Makefile b/drivers/media/pci/bt8xx/Makefile
index 36591ae..c008d0c 100644
--- a/drivers/media/pci/bt8xx/Makefile
+++ b/drivers/media/pci/bt8xx/Makefile
@@ -3,4 +3,4 @@ obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o dst.o dst_ca.o
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
 ccflags-y += -Idrivers/media/video/bt8xx
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/tuners
diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index 9d083c9..7446c8b 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
 ccflags-y += -Idrivers/media/dvb-core/
 ccflags-y += -Idrivers/media/dvb-frontends/
-ccflags-y += -Idrivers/media/common/tuners/
+ccflags-y += -Idrivers/media/tuners/
 
 # For the staging CI driver cxd2099
 ccflags-y += -Idrivers/staging/media/cxd2099/
diff --git a/drivers/media/pci/ngene/Makefile b/drivers/media/pci/ngene/Makefile
index 6399708..5c0b5d6 100644
--- a/drivers/media/pci/ngene/Makefile
+++ b/drivers/media/pci/ngene/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_DVB_NGENE) += ngene.o
 
 ccflags-y += -Idrivers/media/dvb-core/
 ccflags-y += -Idrivers/media/dvb-frontends/
-ccflags-y += -Idrivers/media/common/tuners/
+ccflags-y += -Idrivers/media/tuners/
 
 # For the staging CI driver cxd2099
 ccflags-y += -Idrivers/staging/media/cxd2099/
diff --git a/drivers/media/pci/ttpci/Makefile b/drivers/media/pci/ttpci/Makefile
index 22a235f..9890596 100644
--- a/drivers/media/pci/ttpci/Makefile
+++ b/drivers/media/pci/ttpci/Makefile
@@ -18,4 +18,4 @@ obj-$(CONFIG_DVB_BUDGET_PATCH) += budget-patch.o
 obj-$(CONFIG_DVB_AV7110) += dvb-ttpci.o
 
 ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends/
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/tuners
diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/tuners/Kconfig
similarity index 100%
rename from drivers/media/common/tuners/Kconfig
rename to drivers/media/tuners/Kconfig
diff --git a/drivers/media/common/tuners/Makefile b/drivers/media/tuners/Makefile
similarity index 100%
rename from drivers/media/common/tuners/Makefile
rename to drivers/media/tuners/Makefile
diff --git a/drivers/media/common/tuners/fc0011.c b/drivers/media/tuners/fc0011.c
similarity index 100%
rename from drivers/media/common/tuners/fc0011.c
rename to drivers/media/tuners/fc0011.c
diff --git a/drivers/media/common/tuners/fc0011.h b/drivers/media/tuners/fc0011.h
similarity index 100%
rename from drivers/media/common/tuners/fc0011.h
rename to drivers/media/tuners/fc0011.h
diff --git a/drivers/media/common/tuners/fc0012-priv.h b/drivers/media/tuners/fc0012-priv.h
similarity index 100%
rename from drivers/media/common/tuners/fc0012-priv.h
rename to drivers/media/tuners/fc0012-priv.h
diff --git a/drivers/media/common/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
similarity index 100%
rename from drivers/media/common/tuners/fc0012.c
rename to drivers/media/tuners/fc0012.c
diff --git a/drivers/media/common/tuners/fc0012.h b/drivers/media/tuners/fc0012.h
similarity index 100%
rename from drivers/media/common/tuners/fc0012.h
rename to drivers/media/tuners/fc0012.h
diff --git a/drivers/media/common/tuners/fc0013-priv.h b/drivers/media/tuners/fc0013-priv.h
similarity index 100%
rename from drivers/media/common/tuners/fc0013-priv.h
rename to drivers/media/tuners/fc0013-priv.h
diff --git a/drivers/media/common/tuners/fc0013.c b/drivers/media/tuners/fc0013.c
similarity index 100%
rename from drivers/media/common/tuners/fc0013.c
rename to drivers/media/tuners/fc0013.c
diff --git a/drivers/media/common/tuners/fc0013.h b/drivers/media/tuners/fc0013.h
similarity index 100%
rename from drivers/media/common/tuners/fc0013.h
rename to drivers/media/tuners/fc0013.h
diff --git a/drivers/media/common/tuners/fc001x-common.h b/drivers/media/tuners/fc001x-common.h
similarity index 100%
rename from drivers/media/common/tuners/fc001x-common.h
rename to drivers/media/tuners/fc001x-common.h
diff --git a/drivers/media/common/tuners/max2165.c b/drivers/media/tuners/max2165.c
similarity index 100%
rename from drivers/media/common/tuners/max2165.c
rename to drivers/media/tuners/max2165.c
diff --git a/drivers/media/common/tuners/max2165.h b/drivers/media/tuners/max2165.h
similarity index 100%
rename from drivers/media/common/tuners/max2165.h
rename to drivers/media/tuners/max2165.h
diff --git a/drivers/media/common/tuners/max2165_priv.h b/drivers/media/tuners/max2165_priv.h
similarity index 100%
rename from drivers/media/common/tuners/max2165_priv.h
rename to drivers/media/tuners/max2165_priv.h
diff --git a/drivers/media/common/tuners/mc44s803.c b/drivers/media/tuners/mc44s803.c
similarity index 100%
rename from drivers/media/common/tuners/mc44s803.c
rename to drivers/media/tuners/mc44s803.c
diff --git a/drivers/media/common/tuners/mc44s803.h b/drivers/media/tuners/mc44s803.h
similarity index 100%
rename from drivers/media/common/tuners/mc44s803.h
rename to drivers/media/tuners/mc44s803.h
diff --git a/drivers/media/common/tuners/mc44s803_priv.h b/drivers/media/tuners/mc44s803_priv.h
similarity index 100%
rename from drivers/media/common/tuners/mc44s803_priv.h
rename to drivers/media/tuners/mc44s803_priv.h
diff --git a/drivers/media/common/tuners/mt2060.c b/drivers/media/tuners/mt2060.c
similarity index 100%
rename from drivers/media/common/tuners/mt2060.c
rename to drivers/media/tuners/mt2060.c
diff --git a/drivers/media/common/tuners/mt2060.h b/drivers/media/tuners/mt2060.h
similarity index 100%
rename from drivers/media/common/tuners/mt2060.h
rename to drivers/media/tuners/mt2060.h
diff --git a/drivers/media/common/tuners/mt2060_priv.h b/drivers/media/tuners/mt2060_priv.h
similarity index 100%
rename from drivers/media/common/tuners/mt2060_priv.h
rename to drivers/media/tuners/mt2060_priv.h
diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
similarity index 100%
rename from drivers/media/common/tuners/mt2063.c
rename to drivers/media/tuners/mt2063.c
diff --git a/drivers/media/common/tuners/mt2063.h b/drivers/media/tuners/mt2063.h
similarity index 100%
rename from drivers/media/common/tuners/mt2063.h
rename to drivers/media/tuners/mt2063.h
diff --git a/drivers/media/common/tuners/mt20xx.c b/drivers/media/tuners/mt20xx.c
similarity index 100%
rename from drivers/media/common/tuners/mt20xx.c
rename to drivers/media/tuners/mt20xx.c
diff --git a/drivers/media/common/tuners/mt20xx.h b/drivers/media/tuners/mt20xx.h
similarity index 100%
rename from drivers/media/common/tuners/mt20xx.h
rename to drivers/media/tuners/mt20xx.h
diff --git a/drivers/media/common/tuners/mt2131.c b/drivers/media/tuners/mt2131.c
similarity index 100%
rename from drivers/media/common/tuners/mt2131.c
rename to drivers/media/tuners/mt2131.c
diff --git a/drivers/media/common/tuners/mt2131.h b/drivers/media/tuners/mt2131.h
similarity index 100%
rename from drivers/media/common/tuners/mt2131.h
rename to drivers/media/tuners/mt2131.h
diff --git a/drivers/media/common/tuners/mt2131_priv.h b/drivers/media/tuners/mt2131_priv.h
similarity index 100%
rename from drivers/media/common/tuners/mt2131_priv.h
rename to drivers/media/tuners/mt2131_priv.h
diff --git a/drivers/media/common/tuners/mt2266.c b/drivers/media/tuners/mt2266.c
similarity index 100%
rename from drivers/media/common/tuners/mt2266.c
rename to drivers/media/tuners/mt2266.c
diff --git a/drivers/media/common/tuners/mt2266.h b/drivers/media/tuners/mt2266.h
similarity index 100%
rename from drivers/media/common/tuners/mt2266.h
rename to drivers/media/tuners/mt2266.h
diff --git a/drivers/media/common/tuners/mxl5005s.c b/drivers/media/tuners/mxl5005s.c
similarity index 100%
rename from drivers/media/common/tuners/mxl5005s.c
rename to drivers/media/tuners/mxl5005s.c
diff --git a/drivers/media/common/tuners/mxl5005s.h b/drivers/media/tuners/mxl5005s.h
similarity index 100%
rename from drivers/media/common/tuners/mxl5005s.h
rename to drivers/media/tuners/mxl5005s.h
diff --git a/drivers/media/common/tuners/mxl5007t.c b/drivers/media/tuners/mxl5007t.c
similarity index 100%
rename from drivers/media/common/tuners/mxl5007t.c
rename to drivers/media/tuners/mxl5007t.c
diff --git a/drivers/media/common/tuners/mxl5007t.h b/drivers/media/tuners/mxl5007t.h
similarity index 100%
rename from drivers/media/common/tuners/mxl5007t.h
rename to drivers/media/tuners/mxl5007t.h
diff --git a/drivers/media/common/tuners/qt1010.c b/drivers/media/tuners/qt1010.c
similarity index 100%
rename from drivers/media/common/tuners/qt1010.c
rename to drivers/media/tuners/qt1010.c
diff --git a/drivers/media/common/tuners/qt1010.h b/drivers/media/tuners/qt1010.h
similarity index 100%
rename from drivers/media/common/tuners/qt1010.h
rename to drivers/media/tuners/qt1010.h
diff --git a/drivers/media/common/tuners/qt1010_priv.h b/drivers/media/tuners/qt1010_priv.h
similarity index 100%
rename from drivers/media/common/tuners/qt1010_priv.h
rename to drivers/media/tuners/qt1010_priv.h
diff --git a/drivers/media/common/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
similarity index 100%
rename from drivers/media/common/tuners/tda18212.c
rename to drivers/media/tuners/tda18212.c
diff --git a/drivers/media/common/tuners/tda18212.h b/drivers/media/tuners/tda18212.h
similarity index 100%
rename from drivers/media/common/tuners/tda18212.h
rename to drivers/media/tuners/tda18212.h
diff --git a/drivers/media/common/tuners/tda18218.c b/drivers/media/tuners/tda18218.c
similarity index 100%
rename from drivers/media/common/tuners/tda18218.c
rename to drivers/media/tuners/tda18218.c
diff --git a/drivers/media/common/tuners/tda18218.h b/drivers/media/tuners/tda18218.h
similarity index 100%
rename from drivers/media/common/tuners/tda18218.h
rename to drivers/media/tuners/tda18218.h
diff --git a/drivers/media/common/tuners/tda18218_priv.h b/drivers/media/tuners/tda18218_priv.h
similarity index 100%
rename from drivers/media/common/tuners/tda18218_priv.h
rename to drivers/media/tuners/tda18218_priv.h
diff --git a/drivers/media/common/tuners/tda18271-common.c b/drivers/media/tuners/tda18271-common.c
similarity index 100%
rename from drivers/media/common/tuners/tda18271-common.c
rename to drivers/media/tuners/tda18271-common.c
diff --git a/drivers/media/common/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
similarity index 100%
rename from drivers/media/common/tuners/tda18271-fe.c
rename to drivers/media/tuners/tda18271-fe.c
diff --git a/drivers/media/common/tuners/tda18271-maps.c b/drivers/media/tuners/tda18271-maps.c
similarity index 100%
rename from drivers/media/common/tuners/tda18271-maps.c
rename to drivers/media/tuners/tda18271-maps.c
diff --git a/drivers/media/common/tuners/tda18271-priv.h b/drivers/media/tuners/tda18271-priv.h
similarity index 100%
rename from drivers/media/common/tuners/tda18271-priv.h
rename to drivers/media/tuners/tda18271-priv.h
diff --git a/drivers/media/common/tuners/tda18271.h b/drivers/media/tuners/tda18271.h
similarity index 100%
rename from drivers/media/common/tuners/tda18271.h
rename to drivers/media/tuners/tda18271.h
diff --git a/drivers/media/common/tuners/tda827x.c b/drivers/media/tuners/tda827x.c
similarity index 100%
rename from drivers/media/common/tuners/tda827x.c
rename to drivers/media/tuners/tda827x.c
diff --git a/drivers/media/common/tuners/tda827x.h b/drivers/media/tuners/tda827x.h
similarity index 100%
rename from drivers/media/common/tuners/tda827x.h
rename to drivers/media/tuners/tda827x.h
diff --git a/drivers/media/common/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
similarity index 100%
rename from drivers/media/common/tuners/tda8290.c
rename to drivers/media/tuners/tda8290.c
diff --git a/drivers/media/common/tuners/tda8290.h b/drivers/media/tuners/tda8290.h
similarity index 100%
rename from drivers/media/common/tuners/tda8290.h
rename to drivers/media/tuners/tda8290.h
diff --git a/drivers/media/common/tuners/tda9887.c b/drivers/media/tuners/tda9887.c
similarity index 100%
rename from drivers/media/common/tuners/tda9887.c
rename to drivers/media/tuners/tda9887.c
diff --git a/drivers/media/common/tuners/tda9887.h b/drivers/media/tuners/tda9887.h
similarity index 100%
rename from drivers/media/common/tuners/tda9887.h
rename to drivers/media/tuners/tda9887.h
diff --git a/drivers/media/common/tuners/tea5761.c b/drivers/media/tuners/tea5761.c
similarity index 100%
rename from drivers/media/common/tuners/tea5761.c
rename to drivers/media/tuners/tea5761.c
diff --git a/drivers/media/common/tuners/tea5761.h b/drivers/media/tuners/tea5761.h
similarity index 100%
rename from drivers/media/common/tuners/tea5761.h
rename to drivers/media/tuners/tea5761.h
diff --git a/drivers/media/common/tuners/tea5767.c b/drivers/media/tuners/tea5767.c
similarity index 100%
rename from drivers/media/common/tuners/tea5767.c
rename to drivers/media/tuners/tea5767.c
diff --git a/drivers/media/common/tuners/tea5767.h b/drivers/media/tuners/tea5767.h
similarity index 100%
rename from drivers/media/common/tuners/tea5767.h
rename to drivers/media/tuners/tea5767.h
diff --git a/drivers/media/common/tuners/tua9001.c b/drivers/media/tuners/tua9001.c
similarity index 100%
rename from drivers/media/common/tuners/tua9001.c
rename to drivers/media/tuners/tua9001.c
diff --git a/drivers/media/common/tuners/tua9001.h b/drivers/media/tuners/tua9001.h
similarity index 100%
rename from drivers/media/common/tuners/tua9001.h
rename to drivers/media/tuners/tua9001.h
diff --git a/drivers/media/common/tuners/tua9001_priv.h b/drivers/media/tuners/tua9001_priv.h
similarity index 100%
rename from drivers/media/common/tuners/tua9001_priv.h
rename to drivers/media/tuners/tua9001_priv.h
diff --git a/drivers/media/common/tuners/tuner-i2c.h b/drivers/media/tuners/tuner-i2c.h
similarity index 100%
rename from drivers/media/common/tuners/tuner-i2c.h
rename to drivers/media/tuners/tuner-i2c.h
diff --git a/drivers/media/common/tuners/tuner-simple.c b/drivers/media/tuners/tuner-simple.c
similarity index 100%
rename from drivers/media/common/tuners/tuner-simple.c
rename to drivers/media/tuners/tuner-simple.c
diff --git a/drivers/media/common/tuners/tuner-simple.h b/drivers/media/tuners/tuner-simple.h
similarity index 100%
rename from drivers/media/common/tuners/tuner-simple.h
rename to drivers/media/tuners/tuner-simple.h
diff --git a/drivers/media/common/tuners/tuner-types.c b/drivers/media/tuners/tuner-types.c
similarity index 100%
rename from drivers/media/common/tuners/tuner-types.c
rename to drivers/media/tuners/tuner-types.c
diff --git a/drivers/media/common/tuners/tuner-xc2028-types.h b/drivers/media/tuners/tuner-xc2028-types.h
similarity index 100%
rename from drivers/media/common/tuners/tuner-xc2028-types.h
rename to drivers/media/tuners/tuner-xc2028-types.h
diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
similarity index 100%
rename from drivers/media/common/tuners/tuner-xc2028.c
rename to drivers/media/tuners/tuner-xc2028.c
diff --git a/drivers/media/common/tuners/tuner-xc2028.h b/drivers/media/tuners/tuner-xc2028.h
similarity index 100%
rename from drivers/media/common/tuners/tuner-xc2028.h
rename to drivers/media/tuners/tuner-xc2028.h
diff --git a/drivers/media/common/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
similarity index 100%
rename from drivers/media/common/tuners/xc4000.c
rename to drivers/media/tuners/xc4000.c
diff --git a/drivers/media/common/tuners/xc4000.h b/drivers/media/tuners/xc4000.h
similarity index 100%
rename from drivers/media/common/tuners/xc4000.h
rename to drivers/media/tuners/xc4000.h
diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
similarity index 100%
rename from drivers/media/common/tuners/xc5000.c
rename to drivers/media/tuners/xc5000.c
diff --git a/drivers/media/common/tuners/xc5000.h b/drivers/media/tuners/xc5000.h
similarity index 100%
rename from drivers/media/common/tuners/xc5000.h
rename to drivers/media/tuners/xc5000.h
diff --git a/drivers/media/usb/b2c2/Makefile b/drivers/media/usb/b2c2/Makefile
index 9eaf208..2f7ee5c 100644
--- a/drivers/media/usb/b2c2/Makefile
+++ b/drivers/media/usb/b2c2/Makefile
@@ -3,5 +3,5 @@ obj-$(CONFIG_DVB_B2C2_FLEXCOP_USB) += b2c2-flexcop-usb.o
 
 ccflags-y += -Idrivers/media/dvb-core/
 ccflags-y += -Idrivers/media/dvb-frontends/
-ccflags-y += -Idrivers/media/common/tuners/
+ccflags-y += -Idrivers/media/tuners/
 ccflags-y += -Idrivers/media/common/b2c2/
diff --git a/drivers/media/usb/dvb-usb/Makefile b/drivers/media/usb/dvb-usb/Makefile
index 1dafb8d..1d3b497 100644
--- a/drivers/media/usb/dvb-usb/Makefile
+++ b/drivers/media/usb/dvb-usb/Makefile
@@ -116,6 +116,6 @@ obj-$(CONFIG_DVB_USB_AF9035) += dvb-usb-af9035.o
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends/
 # due to tuner-xc3028
-ccflags-y += -I$(srctree)/drivers/media/common/tuners
+ccflags-y += -I$(srctree)/drivers/media/tuners
 ccflags-y += -I$(srctree)/drivers/media/pci/ttpci
 
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 74b65ea..c0e90bc 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -31,5 +31,5 @@ obj-$(CONFIG_VIDEOBUF2_DMA_SG) += videobuf2-dma-sg.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
-ccflags-y += -I$(srctree)/drivers/media/common/tuners
+ccflags-y += -I$(srctree)/drivers/media/tuners
 
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 17d729d..fb096de 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -187,4 +187,4 @@ obj-$(CONFIG_ARCH_OMAP)	+= omap/
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
-ccflags-y += -I$(srctree)/drivers/media/common/tuners
+ccflags-y += -I$(srctree)/drivers/media/tuners
diff --git a/drivers/media/video/au0828/Makefile b/drivers/media/video/au0828/Makefile
index 61b69e6..98cc20c 100644
--- a/drivers/media/video/au0828/Makefile
+++ b/drivers/media/video/au0828/Makefile
@@ -2,7 +2,7 @@ au0828-objs	:= au0828-core.o au0828-i2c.o au0828-cards.o au0828-dvb.o au0828-vid
 
 obj-$(CONFIG_VIDEO_AU0828) += au0828.o
 
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
 
diff --git a/drivers/media/video/bt8xx/Makefile b/drivers/media/video/bt8xx/Makefile
index 4cba4ef..f6351a2 100644
--- a/drivers/media/video/bt8xx/Makefile
+++ b/drivers/media/video/bt8xx/Makefile
@@ -9,5 +9,5 @@ bttv-objs      :=      bttv-driver.o bttv-cards.o bttv-if.o \
 obj-$(CONFIG_VIDEO_BT848) += bttv.o
 
 ccflags-y += -Idrivers/media/video
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
diff --git a/drivers/media/video/cx18/Makefile b/drivers/media/video/cx18/Makefile
index db5ab12..d3ff154 100644
--- a/drivers/media/video/cx18/Makefile
+++ b/drivers/media/video/cx18/Makefile
@@ -10,4 +10,4 @@ obj-$(CONFIG_VIDEO_CX18_ALSA) += cx18-alsa.o
 
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/tuners
diff --git a/drivers/media/video/cx231xx/Makefile b/drivers/media/video/cx231xx/Makefile
index fe5706d..b774a7c 100644
--- a/drivers/media/video/cx231xx/Makefile
+++ b/drivers/media/video/cx231xx/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_VIDEO_CX231XX_ALSA) += cx231xx-alsa.o
 obj-$(CONFIG_VIDEO_CX231XX_DVB) += cx231xx-dvb.o
 
 ccflags-y += -Idrivers/media/video
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
 ccflags-y += -Idrivers/media/usb/dvb-usb
diff --git a/drivers/media/video/cx23885/Makefile b/drivers/media/video/cx23885/Makefile
index 8f82e01..f92cc4c 100644
--- a/drivers/media/video/cx23885/Makefile
+++ b/drivers/media/video/cx23885/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_VIDEO_CX23885) += cx23885.o
 obj-$(CONFIG_MEDIA_ALTERA_CI) += altera-ci.o
 
 ccflags-y += -Idrivers/media/video
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
 
diff --git a/drivers/media/video/cx25821/Makefile b/drivers/media/video/cx25821/Makefile
index af23e0c..1434e80 100644
--- a/drivers/media/video/cx25821/Makefile
+++ b/drivers/media/video/cx25821/Makefile
@@ -8,6 +8,6 @@ obj-$(CONFIG_VIDEO_CX25821) += cx25821.o
 obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
 
 ccflags-y := -Idrivers/media/video
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/video/cx88/Makefile b/drivers/media/video/cx88/Makefile
index 5c4d306..884b4cd 100644
--- a/drivers/media/video/cx88/Makefile
+++ b/drivers/media/video/cx88/Makefile
@@ -11,6 +11,6 @@ obj-$(CONFIG_VIDEO_CX88_DVB) += cx88-dvb.o
 obj-$(CONFIG_VIDEO_CX88_VP3054) += cx88-vp3054-i2c.o
 
 ccflags-y += -Idrivers/media/video
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/video/em28xx/Makefile b/drivers/media/video/em28xx/Makefile
index f4118d2..65c7c29 100644
--- a/drivers/media/video/em28xx/Makefile
+++ b/drivers/media/video/em28xx/Makefile
@@ -10,6 +10,6 @@ obj-$(CONFIG_VIDEO_EM28XX_DVB) += em28xx-dvb.o
 obj-$(CONFIG_VIDEO_EM28XX_RC) += em28xx-rc.o
 
 ccflags-y += -Idrivers/media/video
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/video/ivtv/Makefile b/drivers/media/video/ivtv/Makefile
index 0015bd4..80b4ec1 100644
--- a/drivers/media/video/ivtv/Makefile
+++ b/drivers/media/video/ivtv/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_VIDEO_IVTV) += ivtv.o
 obj-$(CONFIG_VIDEO_FB_IVTV) += ivtvfb.o
 
 ccflags-y += -I$(srctree)/drivers/media/video
-ccflags-y += -I$(srctree)/drivers/media/common/tuners
+ccflags-y += -I$(srctree)/drivers/media/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 
diff --git a/drivers/media/video/pvrusb2/Makefile b/drivers/media/video/pvrusb2/Makefile
index 1458797..bc716db 100644
--- a/drivers/media/video/pvrusb2/Makefile
+++ b/drivers/media/video/pvrusb2/Makefile
@@ -17,6 +17,6 @@ pvrusb2-objs	:= pvrusb2-i2c-core.o \
 obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2.o
 
 ccflags-y += -Idrivers/media/video
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/video/saa7134/Makefile b/drivers/media/video/saa7134/Makefile
index 7af78a8..aba5008 100644
--- a/drivers/media/video/saa7134/Makefile
+++ b/drivers/media/video/saa7134/Makefile
@@ -11,6 +11,6 @@ obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 obj-$(CONFIG_VIDEO_SAA7134_DVB) += saa7134-dvb.o
 
 ccflags-y += -I$(srctree)/drivers/media/video
-ccflags-y += -I$(srctree)/drivers/media/common/tuners
+ccflags-y += -I$(srctree)/drivers/media/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/video/saa7164/Makefile b/drivers/media/video/saa7164/Makefile
index d8ed33d..847110c 100644
--- a/drivers/media/video/saa7164/Makefile
+++ b/drivers/media/video/saa7164/Makefile
@@ -5,7 +5,7 @@ saa7164-objs	:= saa7164-cards.o saa7164-core.o saa7164-i2c.o saa7164-dvb.o \
 obj-$(CONFIG_VIDEO_SAA7164) += saa7164.o
 
 ccflags-y += -I$(srctree)/drivers/media/video
-ccflags-y += -I$(srctree)/drivers/media/common/tuners
+ccflags-y += -I$(srctree)/drivers/media/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 
diff --git a/drivers/media/video/tlg2300/Makefile b/drivers/media/video/tlg2300/Makefile
index 268d825..4d66087 100644
--- a/drivers/media/video/tlg2300/Makefile
+++ b/drivers/media/video/tlg2300/Makefile
@@ -3,7 +3,7 @@ poseidon-objs := pd-video.o pd-alsa.o pd-dvb.o pd-radio.o pd-main.o
 obj-$(CONFIG_VIDEO_TLG2300) += poseidon.o
 
 ccflags-y += -Idrivers/media/video
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
 
diff --git a/drivers/media/video/tm6000/Makefile b/drivers/media/video/tm6000/Makefile
index 56cbcba..1feb8c9 100644
--- a/drivers/media/video/tm6000/Makefile
+++ b/drivers/media/video/tm6000/Makefile
@@ -10,6 +10,6 @@ obj-$(CONFIG_VIDEO_TM6000_ALSA) += tm6000-alsa.o
 obj-$(CONFIG_VIDEO_TM6000_DVB) += tm6000-dvb.o
 
 ccflags-y := -Idrivers/media/video
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/video/usbvision/Makefile b/drivers/media/video/usbvision/Makefile
index aea1e3b..d55c6bd 100644
--- a/drivers/media/video/usbvision/Makefile
+++ b/drivers/media/video/usbvision/Makefile
@@ -3,4 +3,4 @@ usbvision-objs  := usbvision-core.o usbvision-video.o usbvision-i2c.o usbvision-
 obj-$(CONFIG_VIDEO_USBVISION) += usbvision.o
 
 ccflags-y += -Idrivers/media/video
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/tuners
diff --git a/drivers/staging/media/cxd2099/Makefile b/drivers/staging/media/cxd2099/Makefile
index eb6bc59..b2905e6 100644
--- a/drivers/staging/media/cxd2099/Makefile
+++ b/drivers/staging/media/cxd2099/Makefile
@@ -2,4 +2,4 @@ obj-$(CONFIG_DVB_CXD2099) += cxd2099.o
 
 ccflags-y += -Idrivers/media/dvb-core/
 ccflags-y += -Idrivers/media/dvb-frontends/
-ccflags-y += -Idrivers/media/common/tuners/
+ccflags-y += -Idrivers/media/tuners/
-- 
1.7.10.2

