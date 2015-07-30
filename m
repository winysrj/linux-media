Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36391 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbbG3RJ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 13:09:29 -0400
Received: by wicgb10 with SMTP id gb10so576522wic.1
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2015 10:09:28 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com,
	m.krufky@samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, joe@perches.com
Subject: [PATCH v2 10/11] [media] c8sectpfe: Add Kconfig and Makefile for the driver.
Date: Thu, 30 Jul 2015 18:09:00 +0100
Message-Id: <1438276141-16902-11-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1438276141-16902-1-git-send-email-peter.griffin@linaro.org>
References: <1438276141-16902-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the Kconfig and Makefile for the c8sectpfe driver
so it will be built. It also selects additional demodulator and tuners
which are required by the supported NIM cards.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/media/platform/Kconfig                |  4 +++-
 drivers/media/platform/Makefile               |  1 +
 drivers/media/platform/sti/c8sectpfe/Kconfig  | 28 +++++++++++++++++++++++++++
 drivers/media/platform/sti/c8sectpfe/Makefile |  9 +++++++++
 4 files changed, 41 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/sti/c8sectpfe/Kconfig
 create mode 100644 drivers/media/platform/sti/c8sectpfe/Makefile

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f6bed19..68d7ed1 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -1,6 +1,6 @@
 #
 # Platform drivers
-#	All drivers here are currently for webcam support
+#	Most drivers here are currently for webcam support
 
 menuconfig V4L_PLATFORM_DRIVERS
 	bool "V4L platform devices"
@@ -280,3 +280,5 @@ config VIDEO_VIM2M
 	  This is a virtual test device for the memory-to-memory driver
 	  framework.
 endif #V4L_TEST_DRIVERS
+
+source "drivers/media/platform/sti/c8sectpfe/Kconfig"
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 114f9ab..301bc1d 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
 
 obj-$(CONFIG_VIDEO_STI_BDISP)		+= sti/bdisp/
+obj-$(CONFIG_DVB_C8SECTPFE)		+= sti/c8sectpfe/
 
 obj-$(CONFIG_BLACKFIN)                  += blackfin/
 
diff --git a/drivers/media/platform/sti/c8sectpfe/Kconfig b/drivers/media/platform/sti/c8sectpfe/Kconfig
new file mode 100644
index 0000000..d1bfd4c
--- /dev/null
+++ b/drivers/media/platform/sti/c8sectpfe/Kconfig
@@ -0,0 +1,28 @@
+config DVB_C8SECTPFE
+	tristate "STMicroelectronics C8SECTPFE DVB support"
+	depends on DVB_CORE && I2C && (ARCH_STI || ARCH_MULTIPLATFORM)
+	select LIBELF_32
+	select FW_LOADER
+	select FW_LOADER_USER_HELPER_FALLBACK
+	select DEBUG_FS
+	select DVB_LNBP21 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV090x if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB6100 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV6110 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0900 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0367 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
+
+	---help---
+	  This adds support for DVB front-end cards connected
+	  to TS inputs of STiH407/410 SoC.
+
+	  The driver currently supports C8SECTPFE's TS input block,
+	  memdma engine, and HW PID filtering.
+
+	  Supported DVB front-end cards are:
+	  - STMicroelectronics DVB-T B2100A (STV0367 + TDA18212)
+	  - STMicroelectronics DVB-S/S2 STV0903 + STV6110 + LNBP24 board
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called c8sectpfe.
diff --git a/drivers/media/platform/sti/c8sectpfe/Makefile b/drivers/media/platform/sti/c8sectpfe/Makefile
new file mode 100644
index 0000000..b578c7c
--- /dev/null
+++ b/drivers/media/platform/sti/c8sectpfe/Makefile
@@ -0,0 +1,9 @@
+c8sectpfe-y += c8sectpfe-core.o c8sectpfe-common.o c8sectpfe-dvb.o \
+		c8sectpfe-debugfs.o
+
+obj-$(CONFIG_DVB_C8SECTPFE) += c8sectpfe.o
+
+ccflags-y += -Idrivers/media/i2c
+ccflags-y += -Idrivers/media/common
+ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends/ \
+		-Idrivers/media/tuners/
-- 
1.9.1

