Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822Ab2JQTqg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 15:46:36 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9HJkaV9017400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 15:46:36 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] siano: allow compiling it without RC support
Date: Wed, 17 Oct 2012 16:46:33 -0300
Message-Id: <1350503193-8412-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1350503193-8412-1-git-send-email-mchehab@redhat.com>
References: <1350503193-8412-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remote controller support should be optional on all drivers.

Make it optional at Siano's driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/Kconfig        |  7 +++++++
 drivers/media/common/b2c2/Kconfig   |  5 -----
 drivers/media/common/siano/Kconfig  | 17 +++++++++--------
 drivers/media/common/siano/Makefile |  3 ++-
 drivers/media/common/siano/smsir.h  |  9 +++++++++
 drivers/media/mmc/siano/Kconfig     |  1 +
 drivers/media/usb/siano/Kconfig     |  1 +
 7 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/media/common/Kconfig b/drivers/media/common/Kconfig
index 121b011..d2a436c 100644
--- a/drivers/media/common/Kconfig
+++ b/drivers/media/common/Kconfig
@@ -1,3 +1,10 @@
+# Used by common drivers, when they need to ask questions
+config MEDIA_COMMON_OPTIONS
+	bool
+
+comment "common driver options"
+	depends on MEDIA_COMMON_OPTIONS
+
 source "drivers/media/common/b2c2/Kconfig"
 source "drivers/media/common/saa7146/Kconfig"
 source "drivers/media/common/siano/Kconfig"
diff --git a/drivers/media/common/b2c2/Kconfig b/drivers/media/common/b2c2/Kconfig
index 1df9e57..a8c6cdf 100644
--- a/drivers/media/common/b2c2/Kconfig
+++ b/drivers/media/common/b2c2/Kconfig
@@ -17,11 +17,6 @@ config DVB_B2C2_FLEXCOP
 	select DVB_CX24123 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TUNER_CX24113 if MEDIA_SUBDRV_AUTOSELECT
-	help
-	  Support for the digital TV receiver chip made by B2C2 Inc. included in
-	  Technisats PCI cards and USB boxes.
-
-	  Say Y if you own such a device and want to use it.
 
 # Selected via the PCI or USB flexcop drivers
 config DVB_B2C2_FLEXCOP_DEBUG
diff --git a/drivers/media/common/siano/Kconfig b/drivers/media/common/siano/Kconfig
index 425aead..3cb7823 100644
--- a/drivers/media/common/siano/Kconfig
+++ b/drivers/media/common/siano/Kconfig
@@ -4,14 +4,15 @@
 
 config SMS_SIANO_MDTV
 	tristate
-	depends on DVB_CORE && RC_CORE && HAS_DMA
+	depends on DVB_CORE && HAS_DMA
 	depends on SMS_USB_DRV || SMS_SDIO_DRV
 	default y
-	---help---
-	  Choose Y or M here if you have MDTV receiver with a Siano chipset.
-
-	  To compile this driver as a module, choose M here
-	  (The module will be called smsmdtv).
 
-	  Further documentation on this driver can be found on the WWW
-	  at http://www.siano-ms.com/
+config SMS_SIANO_RC
+	bool "Enable Remote Controller support for Siano devices"
+	depends on SMS_SIANO_MDTV && RC_CORE
+	depends on SMS_USB_DRV || SMS_SDIO_DRV
+	depends on MEDIA_COMMON_OPTIONS
+	default y
+	---help---
+	  Choose Y to select Remote Controller support for Siano driver.
diff --git a/drivers/media/common/siano/Makefile b/drivers/media/common/siano/Makefile
index 2a09279..0e6f5e9 100644
--- a/drivers/media/common/siano/Makefile
+++ b/drivers/media/common/siano/Makefile
@@ -1,6 +1,7 @@
-smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o smsir.o
+smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o
 
 obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o smsdvb.o
+obj-$(CONFIG_SMS_SIANO_RC) += smsir.o
 
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/common/siano/smsir.h b/drivers/media/common/siano/smsir.h
index ae92b3a..69b59b9 100644
--- a/drivers/media/common/siano/smsir.h
+++ b/drivers/media/common/siano/smsir.h
@@ -46,10 +46,19 @@ struct ir_t {
 	u32 controller;
 };
 
+#ifdef CONFIG_SMS_SIANO_RC
 int sms_ir_init(struct smscore_device_t *coredev);
 void sms_ir_exit(struct smscore_device_t *coredev);
 void sms_ir_event(struct smscore_device_t *coredev,
 			const char *buf, int len);
+#else
+inline static int sms_ir_init(struct smscore_device_t *coredev) {
+	return 0;
+}
+inline static void sms_ir_exit(struct smscore_device_t *coredev) {};
+inline static void sms_ir_event(struct smscore_device_t *coredev,
+			const char *buf, int len) {};
+#endif
 
 #endif /* __SMS_IR_H__ */
 
diff --git a/drivers/media/mmc/siano/Kconfig b/drivers/media/mmc/siano/Kconfig
index fa62475..69f8061 100644
--- a/drivers/media/mmc/siano/Kconfig
+++ b/drivers/media/mmc/siano/Kconfig
@@ -6,5 +6,6 @@ config SMS_SDIO_DRV
 	tristate "Siano SMS1xxx based MDTV via SDIO interface"
 	depends on DVB_CORE && RC_CORE && HAS_DMA
 	depends on MMC
+	select MEDIA_COMMON_OPTIONS
 	---help---
 	  Choose if you would like to have Siano's support for SDIO interface
diff --git a/drivers/media/usb/siano/Kconfig b/drivers/media/usb/siano/Kconfig
index 3c76e62..b2c229e 100644
--- a/drivers/media/usb/siano/Kconfig
+++ b/drivers/media/usb/siano/Kconfig
@@ -5,6 +5,7 @@
 config SMS_USB_DRV
 	tristate "Siano SMS1xxx based MDTV receiver"
 	depends on DVB_CORE && RC_CORE && HAS_DMA
+	select MEDIA_COMMON_OPTIONS
 	---help---
 	  Choose if you would like to have Siano's support for USB interface
 
-- 
1.7.11.7

