Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072Ab1KBLq0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Nov 2011 07:46:26 -0400
Date: Wed, 2 Nov 2011 09:45:06 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: devel@driverdev.osuosl.org, Greg KH <gregkh@suse.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] staging: Move media drivers to staging/media
Message-ID: <20111102094506.7e77b7e0@redhat.com>
In-Reply-To: <cover.1320233265.git.mchehab@redhat.com>
References: <cover.1320233265.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In practice, it is being hard to distinguish when a patch
should go to staging tree or to the media tree. Better
to distinguish it, by putting the media drivers at a
separate staging directory. Newer staging drivers that include
anything with "dvb*.h", "v4l2*.h" or "videodev2.h" should
go to the drivers/staging/media tree.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 create mode 100644 drivers/staging/media/Kconfig
 create mode 100644 drivers/staging/media/Makefile
 rename drivers/staging/{ => media}/cxd2099/Kconfig (100%)
 rename drivers/staging/{ => media}/cxd2099/Makefile (100%)
 rename drivers/staging/{ => media}/cxd2099/TODO (100%)
 rename drivers/staging/{ => media}/cxd2099/cxd2099.c (100%)
 rename drivers/staging/{ => media}/cxd2099/cxd2099.h (100%)
 rename drivers/staging/{ => media}/dt3155v4l/Kconfig (100%)
 rename drivers/staging/{ => media}/dt3155v4l/Makefile (100%)
 rename drivers/staging/{ => media}/dt3155v4l/dt3155v4l.c (100%)
 rename drivers/staging/{ => media}/dt3155v4l/dt3155v4l.h (100%)
 rename drivers/staging/{ => media}/easycap/Kconfig (100%)
 rename drivers/staging/{ => media}/easycap/Makefile (100%)
 rename drivers/staging/{ => media}/easycap/README (100%)
 rename drivers/staging/{ => media}/easycap/easycap.h (100%)
 rename drivers/staging/{ => media}/easycap/easycap_ioctl.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_low.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_main.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_settings.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_sound.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_testcard.c (100%)
 rename drivers/staging/{ => media}/go7007/Kconfig (100%)
 rename drivers/staging/{ => media}/go7007/Makefile (100%)
 rename drivers/staging/{ => media}/go7007/README (100%)
 rename drivers/staging/{ => media}/go7007/go7007-driver.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007-fw.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007-i2c.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007-priv.h (100%)
 rename drivers/staging/{ => media}/go7007/go7007-usb.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007-v4l2.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007.h (100%)
 rename drivers/staging/{ => media}/go7007/go7007.txt (100%)
 rename drivers/staging/{ => media}/go7007/s2250-board.c (100%)
 rename drivers/staging/{ => media}/go7007/s2250-loader.c (100%)
 rename drivers/staging/{ => media}/go7007/s2250-loader.h (100%)
 rename drivers/staging/{ => media}/go7007/saa7134-go7007.c (100%)
 rename drivers/staging/{ => media}/go7007/snd-go7007.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-i2c.h (100%)
 rename drivers/staging/{ => media}/go7007/wis-ov7640.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-saa7113.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-saa7115.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-sony-tuner.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-tw2804.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-tw9903.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-uda1342.c (100%)
 rename drivers/staging/{ => media}/lirc/Kconfig (100%)
 rename drivers/staging/{ => media}/lirc/Makefile (100%)
 rename drivers/staging/{ => media}/lirc/TODO (100%)
 rename drivers/staging/{ => media}/lirc/TODO.lirc_zilog (100%)
 rename drivers/staging/{ => media}/lirc/lirc_bt829.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_ene0100.h (100%)
 rename drivers/staging/{ => media}/lirc/lirc_igorplugusb.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_imon.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_parallel.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_parallel.h (100%)
 rename drivers/staging/{ => media}/lirc/lirc_sasem.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_serial.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_sir.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_ttusbir.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_zilog.c (100%)
 rename drivers/staging/{ => media}/solo6x10/Kconfig (100%)
 rename drivers/staging/{ => media}/solo6x10/Makefile (100%)
 rename drivers/staging/{ => media}/solo6x10/TODO (100%)
 rename drivers/staging/{ => media}/solo6x10/core.c (100%)
 rename drivers/staging/{ => media}/solo6x10/disp.c (100%)
 rename drivers/staging/{ => media}/solo6x10/enc.c (100%)
 rename drivers/staging/{ => media}/solo6x10/g723.c (100%)
 rename drivers/staging/{ => media}/solo6x10/gpio.c (100%)
 rename drivers/staging/{ => media}/solo6x10/i2c.c (100%)
 rename drivers/staging/{ => media}/solo6x10/jpeg.h (100%)
 rename drivers/staging/{ => media}/solo6x10/offsets.h (100%)
 rename drivers/staging/{ => media}/solo6x10/osd-font.h (100%)
 rename drivers/staging/{ => media}/solo6x10/p2m.c (100%)
 rename drivers/staging/{ => media}/solo6x10/registers.h (100%)
 rename drivers/staging/{ => media}/solo6x10/solo6x10.h (100%)
 rename drivers/staging/{ => media}/solo6x10/tw28.c (100%)
 rename drivers/staging/{ => media}/solo6x10/tw28.h (100%)
 rename drivers/staging/{ => media}/solo6x10/v4l2-enc.c (100%)
 rename drivers/staging/{ => media}/solo6x10/v4l2.c (100%)

diff --git a/drivers/media/dvb/ddbridge/Makefile b/drivers/media/dvb/ddbridge/Makefile
index cf7214e..38019ba 100644
--- a/drivers/media/dvb/ddbridge/Makefile
+++ b/drivers/media/dvb/ddbridge/Makefile
@@ -11,4 +11,4 @@ ccflags-y += -Idrivers/media/dvb/frontends/
 ccflags-y += -Idrivers/media/common/tuners/
 
 # For the staging CI driver cxd2099
-ccflags-y += -Idrivers/staging/cxd2099/
+ccflags-y += -Idrivers/staging/media/cxd2099/
diff --git a/drivers/media/dvb/ngene/Makefile b/drivers/media/dvb/ngene/Makefile
index 8987361..13ebeff 100644
--- a/drivers/media/dvb/ngene/Makefile
+++ b/drivers/media/dvb/ngene/Makefile
@@ -11,4 +11,4 @@ ccflags-y += -Idrivers/media/dvb/frontends/
 ccflags-y += -Idrivers/media/common/tuners/
 
 # For the staging CI driver cxd2099
-ccflags-y += -Idrivers/staging/cxd2099/
+ccflags-y += -Idrivers/staging/media/cxd2099/
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 280da2f..2a99cba 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -28,10 +28,6 @@ source "drivers/staging/et131x/Kconfig"
 
 source "drivers/staging/slicoss/Kconfig"
 
-source "drivers/staging/go7007/Kconfig"
-
-source "drivers/staging/cxd2099/Kconfig"
-
 source "drivers/staging/usbip/Kconfig"
 
 source "drivers/staging/winbond/Kconfig"
@@ -102,20 +98,12 @@ source "drivers/staging/wlags49_h25/Kconfig"
 
 source "drivers/staging/sm7xx/Kconfig"
 
-source "drivers/staging/dt3155v4l/Kconfig"
-
 source "drivers/staging/crystalhd/Kconfig"
 
 source "drivers/staging/cxt1e1/Kconfig"
 
 source "drivers/staging/xgifb/Kconfig"
 
-source "drivers/staging/lirc/Kconfig"
-
-source "drivers/staging/easycap/Kconfig"
-
-source "drivers/staging/solo6x10/Kconfig"
-
 source "drivers/staging/tidspbridge/Kconfig"
 
 source "drivers/staging/quickstart/Kconfig"
@@ -144,6 +132,6 @@ source "drivers/staging/mei/Kconfig"
 
 source "drivers/staging/nvec/Kconfig"
 
-source "drivers/staging/media/as102/Kconfig"
+source "drivers/staging/media/Kconfig"
 
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index e66ab00..cf92bc1 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -3,11 +3,9 @@
 # fix for build system bug...
 obj-$(CONFIG_STAGING)		+= staging.o
 
+obj-y				+= media/
 obj-$(CONFIG_ET131X)		+= et131x/
 obj-$(CONFIG_SLICOSS)		+= slicoss/
-obj-$(CONFIG_VIDEO_GO7007)	+= go7007/
-obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
-obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_USBIP_CORE)	+= usbip/
 obj-$(CONFIG_W35UND)		+= winbond/
 obj-$(CONFIG_PRISM2_USB)	+= wlan-ng/
@@ -43,12 +41,9 @@ obj-$(CONFIG_ZCACHE)		+= zcache/
 obj-$(CONFIG_WLAGS49_H2)	+= wlags49_h2/
 obj-$(CONFIG_WLAGS49_H25)	+= wlags49_h25/
 obj-$(CONFIG_FB_SM7XX)		+= sm7xx/
-obj-$(CONFIG_VIDEO_DT3155)	+= dt3155v4l/
 obj-$(CONFIG_CRYSTALHD)		+= crystalhd/
 obj-$(CONFIG_CXT1E1)		+= cxt1e1/
 obj-$(CONFIG_FB_XGI)		+= xgifb/
-obj-$(CONFIG_EASYCAP)		+= easycap/
-obj-$(CONFIG_SOLO6X10)		+= solo6x10/
 obj-$(CONFIG_TIDSPBRIDGE)	+= tidspbridge/
 obj-$(CONFIG_ACPI_QUICKSTART)	+= quickstart/
 obj-$(CONFIG_SBE_2T3E3)		+= sbe-2t3e3/
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
new file mode 100644
index 0000000..7e5caa3
--- /dev/null
+++ b/drivers/staging/media/Kconfig
@@ -0,0 +1,37 @@
+menuconfig STAGING_MEDIA
+        bool "Media staging drivers"
+        default n
+        ---help---
+          This option allows you to select a number of media drivers that
+	  don't have the "normal" Linux kernel quality level.
+	  Most of them don't follow properly the V4L, DVB and/or RC API's,
+	  so, they won't likely work fine with the existing applications.
+	  That also means that, one fixed, their API's will change to match
+	  the existing ones.
+
+          If you wish to work on these drivers, to help improve them, or
+          to report problems you have with them, please use the
+	  linux-media@vger.kernel.org mailing list.
+
+          If in doubt, say N here.
+
+
+if STAGING_MEDIA
+
+# Please keep them in alphabetic order
+source "drivers/staging/media/as102/Kconfig"
+
+source "drivers/staging/media/cxd2099/Kconfig"
+
+source "drivers/staging/media/dt3155v4l/Kconfig"
+
+source "drivers/staging/media/easycap/Kconfig"
+
+source "drivers/staging/media/go7007/Kconfig"
+
+source "drivers/staging/media/solo6x10/Kconfig"
+
+# Keep LIRC at the end, as it has sub-menus
+source "drivers/staging/media/lirc/Kconfig"
+
+endif
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
new file mode 100644
index 0000000..c69124c
--- /dev/null
+++ b/drivers/staging/media/Makefile
@@ -0,0 +1,7 @@
+obj-$(CONFIG_DVB_AS102)		+= as102/
+obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
+obj-$(CONFIG_EASYCAP)		+= easycap/
+obj-$(CONFIG_LIRC_STAGING)	+= lirc/
+obj-$(CONFIG_SOLO6X10)		+= solo6x10/
+obj-$(CONFIG_VIDEO_DT3155)	+= dt3155v4l/
+obj-$(CONFIG_VIDEO_GO7007)	+= go7007/
diff --git a/drivers/staging/cxd2099/Kconfig b/drivers/staging/media/cxd2099/Kconfig
similarity index 100%
rename from drivers/staging/cxd2099/Kconfig
rename to drivers/staging/media/cxd2099/Kconfig
diff --git a/drivers/staging/cxd2099/Makefile b/drivers/staging/media/cxd2099/Makefile
similarity index 100%
rename from drivers/staging/cxd2099/Makefile
rename to drivers/staging/media/cxd2099/Makefile
diff --git a/drivers/staging/cxd2099/TODO b/drivers/staging/media/cxd2099/TODO
similarity index 100%
rename from drivers/staging/cxd2099/TODO
rename to drivers/staging/media/cxd2099/TODO
diff --git a/drivers/staging/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
similarity index 100%
rename from drivers/staging/cxd2099/cxd2099.c
rename to drivers/staging/media/cxd2099/cxd2099.c
diff --git a/drivers/staging/cxd2099/cxd2099.h b/drivers/staging/media/cxd2099/cxd2099.h
similarity index 100%
rename from drivers/staging/cxd2099/cxd2099.h
rename to drivers/staging/media/cxd2099/cxd2099.h
diff --git a/drivers/staging/dt3155v4l/Kconfig b/drivers/staging/media/dt3155v4l/Kconfig
similarity index 100%
rename from drivers/staging/dt3155v4l/Kconfig
rename to drivers/staging/media/dt3155v4l/Kconfig
diff --git a/drivers/staging/dt3155v4l/Makefile b/drivers/staging/media/dt3155v4l/Makefile
similarity index 100%
rename from drivers/staging/dt3155v4l/Makefile
rename to drivers/staging/media/dt3155v4l/Makefile
diff --git a/drivers/staging/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
similarity index 100%
rename from drivers/staging/dt3155v4l/dt3155v4l.c
rename to drivers/staging/media/dt3155v4l/dt3155v4l.c
diff --git a/drivers/staging/dt3155v4l/dt3155v4l.h b/drivers/staging/media/dt3155v4l/dt3155v4l.h
similarity index 100%
rename from drivers/staging/dt3155v4l/dt3155v4l.h
rename to drivers/staging/media/dt3155v4l/dt3155v4l.h
diff --git a/drivers/staging/easycap/Kconfig b/drivers/staging/media/easycap/Kconfig
similarity index 100%
rename from drivers/staging/easycap/Kconfig
rename to drivers/staging/media/easycap/Kconfig
diff --git a/drivers/staging/easycap/Makefile b/drivers/staging/media/easycap/Makefile
similarity index 100%
rename from drivers/staging/easycap/Makefile
rename to drivers/staging/media/easycap/Makefile
diff --git a/drivers/staging/easycap/README b/drivers/staging/media/easycap/README
similarity index 100%
rename from drivers/staging/easycap/README
rename to drivers/staging/media/easycap/README
diff --git a/drivers/staging/easycap/easycap.h b/drivers/staging/media/easycap/easycap.h
similarity index 100%
rename from drivers/staging/easycap/easycap.h
rename to drivers/staging/media/easycap/easycap.h
diff --git a/drivers/staging/easycap/easycap_ioctl.c b/drivers/staging/media/easycap/easycap_ioctl.c
similarity index 100%
rename from drivers/staging/easycap/easycap_ioctl.c
rename to drivers/staging/media/easycap/easycap_ioctl.c
diff --git a/drivers/staging/easycap/easycap_low.c b/drivers/staging/media/easycap/easycap_low.c
similarity index 100%
rename from drivers/staging/easycap/easycap_low.c
rename to drivers/staging/media/easycap/easycap_low.c
diff --git a/drivers/staging/easycap/easycap_main.c b/drivers/staging/media/easycap/easycap_main.c
similarity index 100%
rename from drivers/staging/easycap/easycap_main.c
rename to drivers/staging/media/easycap/easycap_main.c
diff --git a/drivers/staging/easycap/easycap_settings.c b/drivers/staging/media/easycap/easycap_settings.c
similarity index 100%
rename from drivers/staging/easycap/easycap_settings.c
rename to drivers/staging/media/easycap/easycap_settings.c
diff --git a/drivers/staging/easycap/easycap_sound.c b/drivers/staging/media/easycap/easycap_sound.c
similarity index 100%
rename from drivers/staging/easycap/easycap_sound.c
rename to drivers/staging/media/easycap/easycap_sound.c
diff --git a/drivers/staging/easycap/easycap_testcard.c b/drivers/staging/media/easycap/easycap_testcard.c
similarity index 100%
rename from drivers/staging/easycap/easycap_testcard.c
rename to drivers/staging/media/easycap/easycap_testcard.c
diff --git a/drivers/staging/go7007/Kconfig b/drivers/staging/media/go7007/Kconfig
similarity index 100%
rename from drivers/staging/go7007/Kconfig
rename to drivers/staging/media/go7007/Kconfig
diff --git a/drivers/staging/go7007/Makefile b/drivers/staging/media/go7007/Makefile
similarity index 100%
rename from drivers/staging/go7007/Makefile
rename to drivers/staging/media/go7007/Makefile
diff --git a/drivers/staging/go7007/README b/drivers/staging/media/go7007/README
similarity index 100%
rename from drivers/staging/go7007/README
rename to drivers/staging/media/go7007/README
diff --git a/drivers/staging/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
similarity index 100%
rename from drivers/staging/go7007/go7007-driver.c
rename to drivers/staging/media/go7007/go7007-driver.c
diff --git a/drivers/staging/go7007/go7007-fw.c b/drivers/staging/media/go7007/go7007-fw.c
similarity index 100%
rename from drivers/staging/go7007/go7007-fw.c
rename to drivers/staging/media/go7007/go7007-fw.c
diff --git a/drivers/staging/go7007/go7007-i2c.c b/drivers/staging/media/go7007/go7007-i2c.c
similarity index 100%
rename from drivers/staging/go7007/go7007-i2c.c
rename to drivers/staging/media/go7007/go7007-i2c.c
diff --git a/drivers/staging/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
similarity index 100%
rename from drivers/staging/go7007/go7007-priv.h
rename to drivers/staging/media/go7007/go7007-priv.h
diff --git a/drivers/staging/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
similarity index 100%
rename from drivers/staging/go7007/go7007-usb.c
rename to drivers/staging/media/go7007/go7007-usb.c
diff --git a/drivers/staging/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
similarity index 100%
rename from drivers/staging/go7007/go7007-v4l2.c
rename to drivers/staging/media/go7007/go7007-v4l2.c
diff --git a/drivers/staging/go7007/go7007.h b/drivers/staging/media/go7007/go7007.h
similarity index 100%
rename from drivers/staging/go7007/go7007.h
rename to drivers/staging/media/go7007/go7007.h
diff --git a/drivers/staging/go7007/go7007.txt b/drivers/staging/media/go7007/go7007.txt
similarity index 100%
rename from drivers/staging/go7007/go7007.txt
rename to drivers/staging/media/go7007/go7007.txt
diff --git a/drivers/staging/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
similarity index 100%
rename from drivers/staging/go7007/s2250-board.c
rename to drivers/staging/media/go7007/s2250-board.c
diff --git a/drivers/staging/go7007/s2250-loader.c b/drivers/staging/media/go7007/s2250-loader.c
similarity index 100%
rename from drivers/staging/go7007/s2250-loader.c
rename to drivers/staging/media/go7007/s2250-loader.c
diff --git a/drivers/staging/go7007/s2250-loader.h b/drivers/staging/media/go7007/s2250-loader.h
similarity index 100%
rename from drivers/staging/go7007/s2250-loader.h
rename to drivers/staging/media/go7007/s2250-loader.h
diff --git a/drivers/staging/go7007/saa7134-go7007.c b/drivers/staging/media/go7007/saa7134-go7007.c
similarity index 100%
rename from drivers/staging/go7007/saa7134-go7007.c
rename to drivers/staging/media/go7007/saa7134-go7007.c
diff --git a/drivers/staging/go7007/snd-go7007.c b/drivers/staging/media/go7007/snd-go7007.c
similarity index 100%
rename from drivers/staging/go7007/snd-go7007.c
rename to drivers/staging/media/go7007/snd-go7007.c
diff --git a/drivers/staging/go7007/wis-i2c.h b/drivers/staging/media/go7007/wis-i2c.h
similarity index 100%
rename from drivers/staging/go7007/wis-i2c.h
rename to drivers/staging/media/go7007/wis-i2c.h
diff --git a/drivers/staging/go7007/wis-ov7640.c b/drivers/staging/media/go7007/wis-ov7640.c
similarity index 100%
rename from drivers/staging/go7007/wis-ov7640.c
rename to drivers/staging/media/go7007/wis-ov7640.c
diff --git a/drivers/staging/go7007/wis-saa7113.c b/drivers/staging/media/go7007/wis-saa7113.c
similarity index 100%
rename from drivers/staging/go7007/wis-saa7113.c
rename to drivers/staging/media/go7007/wis-saa7113.c
diff --git a/drivers/staging/go7007/wis-saa7115.c b/drivers/staging/media/go7007/wis-saa7115.c
similarity index 100%
rename from drivers/staging/go7007/wis-saa7115.c
rename to drivers/staging/media/go7007/wis-saa7115.c
diff --git a/drivers/staging/go7007/wis-sony-tuner.c b/drivers/staging/media/go7007/wis-sony-tuner.c
similarity index 100%
rename from drivers/staging/go7007/wis-sony-tuner.c
rename to drivers/staging/media/go7007/wis-sony-tuner.c
diff --git a/drivers/staging/go7007/wis-tw2804.c b/drivers/staging/media/go7007/wis-tw2804.c
similarity index 100%
rename from drivers/staging/go7007/wis-tw2804.c
rename to drivers/staging/media/go7007/wis-tw2804.c
diff --git a/drivers/staging/go7007/wis-tw9903.c b/drivers/staging/media/go7007/wis-tw9903.c
similarity index 100%
rename from drivers/staging/go7007/wis-tw9903.c
rename to drivers/staging/media/go7007/wis-tw9903.c
diff --git a/drivers/staging/go7007/wis-uda1342.c b/drivers/staging/media/go7007/wis-uda1342.c
similarity index 100%
rename from drivers/staging/go7007/wis-uda1342.c
rename to drivers/staging/media/go7007/wis-uda1342.c
diff --git a/drivers/staging/lirc/Kconfig b/drivers/staging/media/lirc/Kconfig
similarity index 100%
rename from drivers/staging/lirc/Kconfig
rename to drivers/staging/media/lirc/Kconfig
diff --git a/drivers/staging/lirc/Makefile b/drivers/staging/media/lirc/Makefile
similarity index 100%
rename from drivers/staging/lirc/Makefile
rename to drivers/staging/media/lirc/Makefile
diff --git a/drivers/staging/lirc/TODO b/drivers/staging/media/lirc/TODO
similarity index 100%
rename from drivers/staging/lirc/TODO
rename to drivers/staging/media/lirc/TODO
diff --git a/drivers/staging/lirc/TODO.lirc_zilog b/drivers/staging/media/lirc/TODO.lirc_zilog
similarity index 100%
rename from drivers/staging/lirc/TODO.lirc_zilog
rename to drivers/staging/media/lirc/TODO.lirc_zilog
diff --git a/drivers/staging/lirc/lirc_bt829.c b/drivers/staging/media/lirc/lirc_bt829.c
similarity index 100%
rename from drivers/staging/lirc/lirc_bt829.c
rename to drivers/staging/media/lirc/lirc_bt829.c
diff --git a/drivers/staging/lirc/lirc_ene0100.h b/drivers/staging/media/lirc/lirc_ene0100.h
similarity index 100%
rename from drivers/staging/lirc/lirc_ene0100.h
rename to drivers/staging/media/lirc/lirc_ene0100.h
diff --git a/drivers/staging/lirc/lirc_igorplugusb.c b/drivers/staging/media/lirc/lirc_igorplugusb.c
similarity index 100%
rename from drivers/staging/lirc/lirc_igorplugusb.c
rename to drivers/staging/media/lirc/lirc_igorplugusb.c
diff --git a/drivers/staging/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
similarity index 100%
rename from drivers/staging/lirc/lirc_imon.c
rename to drivers/staging/media/lirc/lirc_imon.c
diff --git a/drivers/staging/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
similarity index 100%
rename from drivers/staging/lirc/lirc_parallel.c
rename to drivers/staging/media/lirc/lirc_parallel.c
diff --git a/drivers/staging/lirc/lirc_parallel.h b/drivers/staging/media/lirc/lirc_parallel.h
similarity index 100%
rename from drivers/staging/lirc/lirc_parallel.h
rename to drivers/staging/media/lirc/lirc_parallel.h
diff --git a/drivers/staging/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
similarity index 100%
rename from drivers/staging/lirc/lirc_sasem.c
rename to drivers/staging/media/lirc/lirc_sasem.c
diff --git a/drivers/staging/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
similarity index 100%
rename from drivers/staging/lirc/lirc_serial.c
rename to drivers/staging/media/lirc/lirc_serial.c
diff --git a/drivers/staging/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
similarity index 100%
rename from drivers/staging/lirc/lirc_sir.c
rename to drivers/staging/media/lirc/lirc_sir.c
diff --git a/drivers/staging/lirc/lirc_ttusbir.c b/drivers/staging/media/lirc/lirc_ttusbir.c
similarity index 100%
rename from drivers/staging/lirc/lirc_ttusbir.c
rename to drivers/staging/media/lirc/lirc_ttusbir.c
diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
similarity index 100%
rename from drivers/staging/lirc/lirc_zilog.c
rename to drivers/staging/media/lirc/lirc_zilog.c
diff --git a/drivers/staging/solo6x10/Kconfig b/drivers/staging/media/solo6x10/Kconfig
similarity index 100%
rename from drivers/staging/solo6x10/Kconfig
rename to drivers/staging/media/solo6x10/Kconfig
diff --git a/drivers/staging/solo6x10/Makefile b/drivers/staging/media/solo6x10/Makefile
similarity index 100%
rename from drivers/staging/solo6x10/Makefile
rename to drivers/staging/media/solo6x10/Makefile
diff --git a/drivers/staging/solo6x10/TODO b/drivers/staging/media/solo6x10/TODO
similarity index 100%
rename from drivers/staging/solo6x10/TODO
rename to drivers/staging/media/solo6x10/TODO
diff --git a/drivers/staging/solo6x10/core.c b/drivers/staging/media/solo6x10/core.c
similarity index 100%
rename from drivers/staging/solo6x10/core.c
rename to drivers/staging/media/solo6x10/core.c
diff --git a/drivers/staging/solo6x10/disp.c b/drivers/staging/media/solo6x10/disp.c
similarity index 100%
rename from drivers/staging/solo6x10/disp.c
rename to drivers/staging/media/solo6x10/disp.c
diff --git a/drivers/staging/solo6x10/enc.c b/drivers/staging/media/solo6x10/enc.c
similarity index 100%
rename from drivers/staging/solo6x10/enc.c
rename to drivers/staging/media/solo6x10/enc.c
diff --git a/drivers/staging/solo6x10/g723.c b/drivers/staging/media/solo6x10/g723.c
similarity index 100%
rename from drivers/staging/solo6x10/g723.c
rename to drivers/staging/media/solo6x10/g723.c
diff --git a/drivers/staging/solo6x10/gpio.c b/drivers/staging/media/solo6x10/gpio.c
similarity index 100%
rename from drivers/staging/solo6x10/gpio.c
rename to drivers/staging/media/solo6x10/gpio.c
diff --git a/drivers/staging/solo6x10/i2c.c b/drivers/staging/media/solo6x10/i2c.c
similarity index 100%
rename from drivers/staging/solo6x10/i2c.c
rename to drivers/staging/media/solo6x10/i2c.c
diff --git a/drivers/staging/solo6x10/jpeg.h b/drivers/staging/media/solo6x10/jpeg.h
similarity index 100%
rename from drivers/staging/solo6x10/jpeg.h
rename to drivers/staging/media/solo6x10/jpeg.h
diff --git a/drivers/staging/solo6x10/offsets.h b/drivers/staging/media/solo6x10/offsets.h
similarity index 100%
rename from drivers/staging/solo6x10/offsets.h
rename to drivers/staging/media/solo6x10/offsets.h
diff --git a/drivers/staging/solo6x10/osd-font.h b/drivers/staging/media/solo6x10/osd-font.h
similarity index 100%
rename from drivers/staging/solo6x10/osd-font.h
rename to drivers/staging/media/solo6x10/osd-font.h
diff --git a/drivers/staging/solo6x10/p2m.c b/drivers/staging/media/solo6x10/p2m.c
similarity index 100%
rename from drivers/staging/solo6x10/p2m.c
rename to drivers/staging/media/solo6x10/p2m.c
diff --git a/drivers/staging/solo6x10/registers.h b/drivers/staging/media/solo6x10/registers.h
similarity index 100%
rename from drivers/staging/solo6x10/registers.h
rename to drivers/staging/media/solo6x10/registers.h
diff --git a/drivers/staging/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
similarity index 100%
rename from drivers/staging/solo6x10/solo6x10.h
rename to drivers/staging/media/solo6x10/solo6x10.h
diff --git a/drivers/staging/solo6x10/tw28.c b/drivers/staging/media/solo6x10/tw28.c
similarity index 100%
rename from drivers/staging/solo6x10/tw28.c
rename to drivers/staging/media/solo6x10/tw28.c
diff --git a/drivers/staging/solo6x10/tw28.h b/drivers/staging/media/solo6x10/tw28.h
similarity index 100%
rename from drivers/staging/solo6x10/tw28.h
rename to drivers/staging/media/solo6x10/tw28.h
diff --git a/drivers/staging/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
similarity index 100%
rename from drivers/staging/solo6x10/v4l2-enc.c
rename to drivers/staging/media/solo6x10/v4l2-enc.c
diff --git a/drivers/staging/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
similarity index 100%
rename from drivers/staging/solo6x10/v4l2.c
rename to drivers/staging/media/solo6x10/v4l2.c
-- 
1.7.6.4


