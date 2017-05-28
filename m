Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46584 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750986AbdE1Joi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 05:44:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v4.12 2/3] cec: rename MEDIA_CEC_NOTIFIER to CEC_NOTIFIER
Date: Sun, 28 May 2017 11:44:25 +0200
Message-Id: <20170528094426.10089-3-hverkuil@xs4all.nl>
In-Reply-To: <20170528094426.10089-1-hverkuil@xs4all.nl>
References: <20170528094426.10089-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This config option is strictly speaking independent of the
media subsystem since it can be used by drm as well.

Besides, it looks odd when drivers select CEC_CORE and
MEDIA_CEC_NOTIFIER, that's inconsistent naming.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/Kconfig          | 2 +-
 drivers/media/cec/Makefile     | 2 +-
 drivers/media/cec/cec-core.c   | 4 ++--
 drivers/media/platform/Kconfig | 4 ++--
 include/media/cec-notifier.h   | 2 +-
 include/media/cec.h            | 4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 9ec634e2f2ba..55d9c2b82b7e 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -5,7 +5,7 @@
 config CEC_CORE
 	tristate
 
-config MEDIA_CEC_NOTIFIER
+config CEC_NOTIFIER
 	bool
 
 menuconfig MEDIA_SUPPORT
diff --git a/drivers/media/cec/Makefile b/drivers/media/cec/Makefile
index 402a6c62a3e8..eaf408e64669 100644
--- a/drivers/media/cec/Makefile
+++ b/drivers/media/cec/Makefile
@@ -1,6 +1,6 @@
 cec-objs := cec-core.o cec-adap.o cec-api.o cec-edid.o
 
-ifeq ($(CONFIG_MEDIA_CEC_NOTIFIER),y)
+ifeq ($(CONFIG_CEC_NOTIFIER),y)
   cec-objs += cec-notifier.o
 endif
 
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index f9ebff90f8eb..feeb4c5afa69 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -187,7 +187,7 @@ static void cec_devnode_unregister(struct cec_devnode *devnode)
 	put_device(&devnode->dev);
 }
 
-#ifdef CONFIG_MEDIA_CEC_NOTIFIER
+#ifdef CONFIG_CEC_NOTIFIER
 static void cec_cec_notify(struct cec_adapter *adap, u16 pa)
 {
 	cec_s_phys_addr(adap, pa, false);
@@ -355,7 +355,7 @@ void cec_unregister_adapter(struct cec_adapter *adap)
 	adap->rc = NULL;
 #endif
 	debugfs_remove_recursive(adap->cec_dir);
-#ifdef CONFIG_MEDIA_CEC_NOTIFIER
+#ifdef CONFIG_CEC_NOTIFIER
 	if (adap->notifier)
 		cec_notifier_unregister(adap->notifier);
 #endif
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 017419bef9b1..041cb80a26b1 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -503,7 +503,7 @@ config VIDEO_SAMSUNG_S5P_CEC
        tristate "Samsung S5P CEC driver"
        depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
        select CEC_CORE
-       select MEDIA_CEC_NOTIFIER
+       select CEC_NOTIFIER
        ---help---
          This is a driver for Samsung S5P HDMI CEC interface. It uses the
          generic CEC framework interface.
@@ -514,7 +514,7 @@ config VIDEO_STI_HDMI_CEC
        tristate "STMicroelectronics STiH4xx HDMI CEC driver"
        depends on ARCH_STI || COMPILE_TEST
        select CEC_CORE
-       select MEDIA_CEC_NOTIFIER
+       select CEC_NOTIFIER
        ---help---
          This is a driver for STIH4xx HDMI CEC interface. It uses the
          generic CEC framework interface.
diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
index 71d7ced2c09e..298f996969df 100644
--- a/include/media/cec-notifier.h
+++ b/include/media/cec-notifier.h
@@ -29,7 +29,7 @@ struct edid;
 struct cec_adapter;
 struct cec_notifier;
 
-#if IS_REACHABLE(CONFIG_CEC_CORE) && IS_ENABLED(CONFIG_MEDIA_CEC_NOTIFIER)
+#if IS_REACHABLE(CONFIG_CEC_CORE) && IS_ENABLED(CONFIG_CEC_NOTIFIER)
 
 /**
  * cec_notifier_get - find or create a new cec_notifier for the given device.
diff --git a/include/media/cec.h b/include/media/cec.h
index b8eb895731d5..bfa88d4d67e1 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -173,7 +173,7 @@ struct cec_adapter {
 	bool passthrough;
 	struct cec_log_addrs log_addrs;
 
-#ifdef CONFIG_MEDIA_CEC_NOTIFIER
+#ifdef CONFIG_CEC_NOTIFIER
 	struct cec_notifier *notifier;
 #endif
 
@@ -300,7 +300,7 @@ u16 cec_phys_addr_for_input(u16 phys_addr, u8 input);
  */
 int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port);
 
-#ifdef CONFIG_MEDIA_CEC_NOTIFIER
+#ifdef CONFIG_CEC_NOTIFIER
 void cec_register_cec_notifier(struct cec_adapter *adap,
 			       struct cec_notifier *notifier);
 #endif
-- 
2.11.0
