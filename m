Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59816 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754023AbcKBNEM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 09:04:12 -0400
Subject: [PATCHv2 08/11] cec: move the CEC framework out of staging and to
 media
To: linux-media@vger.kernel.org
References: <20161102124635.11989-1-hverkuil@xs4all.nl>
 <20161102124635.11989-9-hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0b6019af-c559-a088-6f34-09a06561a907@xs4all.nl>
Date: Wed, 2 Nov 2016 14:04:08 +0100
MIME-Version: 1.0
In-Reply-To: <20161102124635.11989-9-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The last open issues have been addressed, so it is time to move
this out of staging and into the mainline and to move the public
cec headers to include/uapi/linux.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Changes since v1:

Fix path to cec.h in Documentation/media/Makefile.
Forgot to make the documentation after moving linux/cec.h to
uapi/linux/cec.h :-(
---
  Documentation/media/Makefile               |  2 +-
  drivers/media/Kconfig                      | 16 ++++++++++++++++
  drivers/media/Makefile                     |  4 ++++
  drivers/{staging => }/media/cec/Makefile   |  2 +-
  drivers/{staging => }/media/cec/cec-adap.c |  0
  drivers/{staging => }/media/cec/cec-api.c  |  0
  drivers/{staging => }/media/cec/cec-core.c |  0
  drivers/{staging => }/media/cec/cec-priv.h |  0
  drivers/media/i2c/Kconfig                  |  6 +++---
  drivers/media/platform/vivid/Kconfig       |  2 +-
  drivers/staging/media/Kconfig              |  2 --
  drivers/staging/media/Makefile             |  1 -
  drivers/staging/media/cec/Kconfig          | 12 ------------
  drivers/staging/media/cec/TODO             |  9 ---------
  drivers/staging/media/pulse8-cec/Kconfig   |  2 +-
  drivers/staging/media/s5p-cec/Kconfig      |  2 +-
  drivers/staging/media/st-cec/Kconfig       |  2 +-
  include/media/cec.h                        |  2 +-
  include/uapi/linux/Kbuild                  |  2 ++
  include/{ => uapi}/linux/cec-funcs.h       |  6 ------
  include/{ => uapi}/linux/cec.h             |  6 ------
  21 files changed, 32 insertions(+), 46 deletions(-)
  rename drivers/{staging => }/media/cec/Makefile (70%)
  rename drivers/{staging => }/media/cec/cec-adap.c (100%)
  rename drivers/{staging => }/media/cec/cec-api.c (100%)
  rename drivers/{staging => }/media/cec/cec-core.c (100%)
  rename drivers/{staging => }/media/cec/cec-priv.h (100%)
  delete mode 100644 drivers/staging/media/cec/Kconfig
  delete mode 100644 drivers/staging/media/cec/TODO
  rename include/{ => uapi}/linux/cec-funcs.h (99%)
  rename include/{ => uapi}/linux/cec.h (99%)

diff --git a/Documentation/media/Makefile b/Documentation/media/Makefile
index a7fb352..61afa05 100644
--- a/Documentation/media/Makefile
+++ b/Documentation/media/Makefile
@@ -51,7 +51,7 @@ $(BUILDDIR)/videodev2.h.rst: ${UAPI}/videodev2.h 
${PARSER} $(SRC_DIR)/videodev2.
  $(BUILDDIR)/media.h.rst: ${UAPI}/media.h ${PARSER} 
$(SRC_DIR)/media.h.rst.exceptions
  	@$($(quiet)gen_rst)

-$(BUILDDIR)/cec.h.rst: ${KAPI}/cec.h ${PARSER} 
$(SRC_DIR)/cec.h.rst.exceptions
+$(BUILDDIR)/cec.h.rst: ${UAPI}/cec.h ${PARSER} 
$(SRC_DIR)/cec.h.rst.exceptions
  	@$($(quiet)gen_rst)

  $(BUILDDIR)/lirc.h.rst: ${UAPI}/lirc.h ${PARSER} 
$(SRC_DIR)/lirc.h.rst.exceptions
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 7b85402..bc643cb 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -80,6 +80,22 @@ config MEDIA_RC_SUPPORT

  	  Say Y when you have a TV or an IR device.

+config MEDIA_CEC_SUPPORT
+	bool "HDMI CEC support"
+	select MEDIA_CEC_EDID
+	---help---
+	  Enable support for HDMI CEC (Consumer Electronics Control),
+	  which is an optional HDMI feature.
+
+	  Say Y when you have an HDMI receiver, transmitter or a USB CEC
+	  adapter that supports HDMI CEC.
+
+config MEDIA_CEC_DEBUG
+	bool "HDMI CEC debugfs interface"
+	depends on MEDIA_CEC_SUPPORT && DEBUG_FS
+	---help---
+	  Turns on the DebugFS interface for CEC devices.
+
  config MEDIA_CEC_EDID
  	bool

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 0deaa93..d87ccb8 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -6,6 +6,10 @@ ifeq ($(CONFIG_MEDIA_CEC_EDID),y)
    obj-$(CONFIG_MEDIA_SUPPORT) += cec-edid.o
  endif

+ifeq ($(CONFIG_MEDIA_CEC_SUPPORT),y)
+  obj-$(CONFIG_MEDIA_SUPPORT) += cec/
+endif
+
  media-objs	:= media-device.o media-devnode.o media-entity.o

  #
diff --git a/drivers/staging/media/cec/Makefile b/drivers/media/cec/Makefile
similarity index 70%
rename from drivers/staging/media/cec/Makefile
rename to drivers/media/cec/Makefile
index bd7f3c5..d668633 100644
--- a/drivers/staging/media/cec/Makefile
+++ b/drivers/media/cec/Makefile
@@ -1,5 +1,5 @@
  cec-objs := cec-core.o cec-adap.o cec-api.o

-ifeq ($(CONFIG_MEDIA_CEC),y)
+ifeq ($(CONFIG_MEDIA_CEC_SUPPORT),y)
    obj-$(CONFIG_MEDIA_SUPPORT) += cec.o
  endif
diff --git a/drivers/staging/media/cec/cec-adap.c 
b/drivers/media/cec/cec-adap.c
similarity index 100%
rename from drivers/staging/media/cec/cec-adap.c
rename to drivers/media/cec/cec-adap.c
diff --git a/drivers/staging/media/cec/cec-api.c 
b/drivers/media/cec/cec-api.c
similarity index 100%
rename from drivers/staging/media/cec/cec-api.c
rename to drivers/media/cec/cec-api.c
diff --git a/drivers/staging/media/cec/cec-core.c 
b/drivers/media/cec/cec-core.c
similarity index 100%
rename from drivers/staging/media/cec/cec-core.c
rename to drivers/media/cec/cec-core.c
diff --git a/drivers/staging/media/cec/cec-priv.h 
b/drivers/media/cec/cec-priv.h
similarity index 100%
rename from drivers/staging/media/cec/cec-priv.h
rename to drivers/media/cec/cec-priv.h
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 2669b4b..b31fa6f 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -221,7 +221,7 @@ config VIDEO_ADV7604

  config VIDEO_ADV7604_CEC
  	bool "Enable Analog Devices ADV7604 CEC support"
-	depends on VIDEO_ADV7604 && MEDIA_CEC
+	depends on VIDEO_ADV7604 && MEDIA_CEC_SUPPORT
  	---help---
  	  When selected the adv7604 will support the optional
  	  HDMI CEC feature.
@@ -242,7 +242,7 @@ config VIDEO_ADV7842

  config VIDEO_ADV7842_CEC
  	bool "Enable Analog Devices ADV7842 CEC support"
-	depends on VIDEO_ADV7842 && MEDIA_CEC
+	depends on VIDEO_ADV7842 && MEDIA_CEC_SUPPORT
  	---help---
  	  When selected the adv7842 will support the optional
  	  HDMI CEC feature.
@@ -481,7 +481,7 @@ config VIDEO_ADV7511

  config VIDEO_ADV7511_CEC
  	bool "Enable Analog Devices ADV7511 CEC support"
-	depends on VIDEO_ADV7511 && MEDIA_CEC
+	depends on VIDEO_ADV7511 && MEDIA_CEC_SUPPORT
  	---help---
  	  When selected the adv7511 will support the optional
  	  HDMI CEC feature.
diff --git a/drivers/media/platform/vivid/Kconfig 
b/drivers/media/platform/vivid/Kconfig
index 8e6918c..db0dd19 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -25,7 +25,7 @@ config VIDEO_VIVID

  config VIDEO_VIVID_CEC
  	bool "Enable CEC emulation support"
-	depends on VIDEO_VIVID && MEDIA_CEC
+	depends on VIDEO_VIVID && MEDIA_CEC_SUPPORT
  	---help---
  	  When selected the vivid module will emulate the optional
  	  HDMI CEC feature.
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 6620d96..0abe5ff 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -21,8 +21,6 @@ if STAGING_MEDIA && MEDIA_SUPPORT
  # Please keep them in alphabetic order
  source "drivers/staging/media/bcm2048/Kconfig"

-source "drivers/staging/media/cec/Kconfig"
-
  source "drivers/staging/media/cxd2099/Kconfig"

  source "drivers/staging/media/davinci_vpfe/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 906257e..246299e 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,5 +1,4 @@
  obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
-obj-$(CONFIG_MEDIA_CEC)		+= cec/
  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_CEC) += s5p-cec/
  obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
  obj-$(CONFIG_LIRC_STAGING)	+= lirc/
diff --git a/drivers/staging/media/cec/Kconfig 
b/drivers/staging/media/cec/Kconfig
deleted file mode 100644
index 6e12d41..0000000
--- a/drivers/staging/media/cec/Kconfig
+++ /dev/null
@@ -1,12 +0,0 @@
-config MEDIA_CEC
-	bool "CEC API (EXPERIMENTAL)"
-	depends on MEDIA_SUPPORT
-	select MEDIA_CEC_EDID
-	---help---
-	  Enable the CEC API.
-
-config MEDIA_CEC_DEBUG
-	bool "CEC debugfs interface (EXPERIMENTAL)"
-	depends on MEDIA_CEC && DEBUG_FS
-	---help---
-	  Turns on the DebugFS interface for CEC devices.
diff --git a/drivers/staging/media/cec/TODO b/drivers/staging/media/cec/TODO
deleted file mode 100644
index 504d35c..0000000
--- a/drivers/staging/media/cec/TODO
+++ /dev/null
@@ -1,9 +0,0 @@
-TODOs:
-
-- Once this is out of staging this should no longer be a separate
-  config option, instead it should be selected by drivers that want it.
-- Revisit the IS_REACHABLE(RC_CORE): perhaps the RC_CORE support should
-  be enabled through a separate config option in drivers/media/Kconfig
-  or rc/Kconfig?
-
-Hans Verkuil <hans.verkuil@cisco.com>
diff --git a/drivers/staging/media/pulse8-cec/Kconfig 
b/drivers/staging/media/pulse8-cec/Kconfig
index c6aa2d1..6ffc407 100644
--- a/drivers/staging/media/pulse8-cec/Kconfig
+++ b/drivers/staging/media/pulse8-cec/Kconfig
@@ -1,6 +1,6 @@
  config USB_PULSE8_CEC
  	tristate "Pulse Eight HDMI CEC"
-	depends on USB_ACM && MEDIA_CEC
+	depends on USB_ACM && MEDIA_CEC_SUPPORT
  	select SERIO
  	select SERIO_SERPORT
  	---help---
diff --git a/drivers/staging/media/s5p-cec/Kconfig 
b/drivers/staging/media/s5p-cec/Kconfig
index 0315fd7..ddfd955 100644
--- a/drivers/staging/media/s5p-cec/Kconfig
+++ b/drivers/staging/media/s5p-cec/Kconfig
@@ -1,6 +1,6 @@
  config VIDEO_SAMSUNG_S5P_CEC
         tristate "Samsung S5P CEC driver"
-       depends on VIDEO_DEV && MEDIA_CEC && (PLAT_S5P || ARCH_EXYNOS || 
COMPILE_TEST)
+       depends on VIDEO_DEV && MEDIA_CEC_SUPPORT && (PLAT_S5P || 
ARCH_EXYNOS || COMPILE_TEST)
         ---help---
           This is a driver for Samsung S5P HDMI CEC interface. It uses the
           generic CEC framework interface.
diff --git a/drivers/staging/media/st-cec/Kconfig 
b/drivers/staging/media/st-cec/Kconfig
index 784d2c6..c04283d 100644
--- a/drivers/staging/media/st-cec/Kconfig
+++ b/drivers/staging/media/st-cec/Kconfig
@@ -1,6 +1,6 @@
  config VIDEO_STI_HDMI_CEC
         tristate "STMicroelectronics STiH4xx HDMI CEC driver"
-       depends on VIDEO_DEV && MEDIA_CEC && (ARCH_STI || COMPILE_TEST)
+       depends on VIDEO_DEV && MEDIA_CEC_SUPPORT && (ARCH_STI || 
COMPILE_TEST)
         ---help---
           This is a driver for STIH4xx HDMI CEC interface. It uses the
           generic CEC framework interface.
diff --git a/include/media/cec.h b/include/media/cec.h
index fdb5d60..717eaf5 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -196,7 +196,7 @@ static inline bool cec_is_sink(const struct 
cec_adapter *adap)
  	return adap->phys_addr == 0;
  }

-#if IS_ENABLED(CONFIG_MEDIA_CEC)
+#if IS_ENABLED(CONFIG_MEDIA_CEC_SUPPORT)
  struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
  		void *priv, const char *name, u32 caps, u8 available_las,
  		struct device *parent);
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 6965d09..c49c448 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -82,6 +82,8 @@ header-y += capi.h
  header-y += cciss_defs.h
  header-y += cciss_ioctl.h
  header-y += cdrom.h
+header-y += cec.h
+header-y += cec-funcs.h
  header-y += cgroupstats.h
  header-y += chio.h
  header-y += cm4000_cs.h
diff --git a/include/linux/cec-funcs.h b/include/uapi/linux/cec-funcs.h
similarity index 99%
rename from include/linux/cec-funcs.h
rename to include/uapi/linux/cec-funcs.h
index 138bbf7..1a1de21 100644
--- a/include/linux/cec-funcs.h
+++ b/include/uapi/linux/cec-funcs.h
@@ -33,12 +33,6 @@
   * SOFTWARE.
   */

-/*
- * Note: this framework is still in staging and it is likely the API
- * will change before it goes out of staging.
- *
- * Once it is moved out of staging this header will move to uapi.
- */
  #ifndef _CEC_UAPI_FUNCS_H
  #define _CEC_UAPI_FUNCS_H

diff --git a/include/linux/cec.h b/include/uapi/linux/cec.h
similarity index 99%
rename from include/linux/cec.h
rename to include/uapi/linux/cec.h
index 9c87711..f4ec0af 100644
--- a/include/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -33,12 +33,6 @@
   * SOFTWARE.
   */

-/*
- * Note: this framework is still in staging and it is likely the API
- * will change before it goes out of staging.
- *
- * Once it is moved out of staging this header will move to uapi.
- */
  #ifndef _CEC_UAPI_H
  #define _CEC_UAPI_H

-- 
2.10.1

