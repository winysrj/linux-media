Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563Ab2FNUiy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 16:38:54 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5EKcsFv022308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 16:38:54 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 10/10] [media] break siano into mmc and usb directories
Date: Thu, 14 Jun 2012 17:36:01 -0300
Message-Id: <1339706161-22713-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
References: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

siano is, in fact, 2 drivers: one for MMC and one for USB, plus
a common bus-independent code. Break it accordingly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig                            |    1 +
 drivers/media/Makefile                           |    2 +-
 drivers/media/common/Kconfig                     |    1 +
 drivers/media/common/Makefile                    |    2 +-
 drivers/media/common/siano/Kconfig               |   17 ++++++++++++++
 drivers/media/common/siano/Makefile              |    7 ++++++
 drivers/media/{usb => common}/siano/sms-cards.c  |    0
 drivers/media/{usb => common}/siano/sms-cards.h  |    0
 drivers/media/{usb => common}/siano/smscoreapi.c |    0
 drivers/media/{usb => common}/siano/smscoreapi.h |    0
 drivers/media/{usb => common}/siano/smsdvb.c     |    0
 drivers/media/{usb => common}/siano/smsendian.c  |    0
 drivers/media/{usb => common}/siano/smsendian.h  |    0
 drivers/media/{usb => common}/siano/smsir.c      |    0
 drivers/media/{usb => common}/siano/smsir.h      |    0
 drivers/media/mmc/Kconfig                        |    1 +
 drivers/media/mmc/Makefile                       |    1 +
 drivers/media/mmc/siano/Kconfig                  |   10 +++++++++
 drivers/media/mmc/siano/Makefile                 |    6 +++++
 drivers/media/{usb => mmc}/siano/smssdio.c       |    0
 drivers/media/usb/siano/Kconfig                  |   26 +---------------------
 drivers/media/usb/siano/Makefile                 |    7 +-----
 22 files changed, 48 insertions(+), 33 deletions(-)
 create mode 100644 drivers/media/common/siano/Kconfig
 create mode 100644 drivers/media/common/siano/Makefile
 rename drivers/media/{usb => common}/siano/sms-cards.c (100%)
 rename drivers/media/{usb => common}/siano/sms-cards.h (100%)
 rename drivers/media/{usb => common}/siano/smscoreapi.c (100%)
 rename drivers/media/{usb => common}/siano/smscoreapi.h (100%)
 rename drivers/media/{usb => common}/siano/smsdvb.c (100%)
 rename drivers/media/{usb => common}/siano/smsendian.c (100%)
 rename drivers/media/{usb => common}/siano/smsendian.h (100%)
 rename drivers/media/{usb => common}/siano/smsir.c (100%)
 rename drivers/media/{usb => common}/siano/smsir.h (100%)
 create mode 100644 drivers/media/mmc/Kconfig
 create mode 100644 drivers/media/mmc/Makefile
 create mode 100644 drivers/media/mmc/siano/Kconfig
 create mode 100644 drivers/media/mmc/siano/Makefile
 rename drivers/media/{usb => mmc}/siano/smssdio.c (100%)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 7b079a4..d892d48 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -165,6 +165,7 @@ source "drivers/media/radio/Kconfig"
 source "drivers/media/dvb-core/Kconfig"
 source "drivers/media/pci/Kconfig"
 source "drivers/media/usb/Kconfig"
+source "drivers/media/mmc/Kconfig"
 
 comment "Supported FireWire (IEEE 1394) Adapters"
 	depends on DVB_CORE && FIREWIRE
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index f89ccac..3265a9a 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -11,5 +11,5 @@ endif
 obj-y += v4l2-core/ tuners/ common/ rc/ video/
 
 obj-$(CONFIG_VIDEO_DEV) += radio/
-obj-$(CONFIG_DVB_CORE)  += dvb-core/ pci/ dvb-frontends/ usb/
+obj-$(CONFIG_DVB_CORE)  += dvb-core/ pci/ dvb-frontends/ usb/ mmc/
 obj-$(CONFIG_DVB_FIREDTV) += firewire/
diff --git a/drivers/media/common/Kconfig b/drivers/media/common/Kconfig
index 157f191..121b011 100644
--- a/drivers/media/common/Kconfig
+++ b/drivers/media/common/Kconfig
@@ -1,2 +1,3 @@
 source "drivers/media/common/b2c2/Kconfig"
 source "drivers/media/common/saa7146/Kconfig"
+source "drivers/media/common/siano/Kconfig"
diff --git a/drivers/media/common/Makefile b/drivers/media/common/Makefile
index f3afd83..b8e2e3a 100644
--- a/drivers/media/common/Makefile
+++ b/drivers/media/common/Makefile
@@ -1 +1 @@
-obj-y += b2c2/ saa7146/
+obj-y += b2c2/ saa7146/ siano/
diff --git a/drivers/media/common/siano/Kconfig b/drivers/media/common/siano/Kconfig
new file mode 100644
index 0000000..425aead
--- /dev/null
+++ b/drivers/media/common/siano/Kconfig
@@ -0,0 +1,17 @@
+#
+# Siano Mobile Silicon Digital TV device configuration
+#
+
+config SMS_SIANO_MDTV
+	tristate
+	depends on DVB_CORE && RC_CORE && HAS_DMA
+	depends on SMS_USB_DRV || SMS_SDIO_DRV
+	default y
+	---help---
+	  Choose Y or M here if you have MDTV receiver with a Siano chipset.
+
+	  To compile this driver as a module, choose M here
+	  (The module will be called smsmdtv).
+
+	  Further documentation on this driver can be found on the WWW
+	  at http://www.siano-ms.com/
diff --git a/drivers/media/common/siano/Makefile b/drivers/media/common/siano/Makefile
new file mode 100644
index 0000000..2a09279
--- /dev/null
+++ b/drivers/media/common/siano/Makefile
@@ -0,0 +1,7 @@
+smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o smsir.o
+
+obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o smsdvb.o
+
+ccflags-y += -Idrivers/media/dvb-core
+ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
+
diff --git a/drivers/media/usb/siano/sms-cards.c b/drivers/media/common/siano/sms-cards.c
similarity index 100%
rename from drivers/media/usb/siano/sms-cards.c
rename to drivers/media/common/siano/sms-cards.c
diff --git a/drivers/media/usb/siano/sms-cards.h b/drivers/media/common/siano/sms-cards.h
similarity index 100%
rename from drivers/media/usb/siano/sms-cards.h
rename to drivers/media/common/siano/sms-cards.h
diff --git a/drivers/media/usb/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
similarity index 100%
rename from drivers/media/usb/siano/smscoreapi.c
rename to drivers/media/common/siano/smscoreapi.c
diff --git a/drivers/media/usb/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
similarity index 100%
rename from drivers/media/usb/siano/smscoreapi.h
rename to drivers/media/common/siano/smscoreapi.h
diff --git a/drivers/media/usb/siano/smsdvb.c b/drivers/media/common/siano/smsdvb.c
similarity index 100%
rename from drivers/media/usb/siano/smsdvb.c
rename to drivers/media/common/siano/smsdvb.c
diff --git a/drivers/media/usb/siano/smsendian.c b/drivers/media/common/siano/smsendian.c
similarity index 100%
rename from drivers/media/usb/siano/smsendian.c
rename to drivers/media/common/siano/smsendian.c
diff --git a/drivers/media/usb/siano/smsendian.h b/drivers/media/common/siano/smsendian.h
similarity index 100%
rename from drivers/media/usb/siano/smsendian.h
rename to drivers/media/common/siano/smsendian.h
diff --git a/drivers/media/usb/siano/smsir.c b/drivers/media/common/siano/smsir.c
similarity index 100%
rename from drivers/media/usb/siano/smsir.c
rename to drivers/media/common/siano/smsir.c
diff --git a/drivers/media/usb/siano/smsir.h b/drivers/media/common/siano/smsir.h
similarity index 100%
rename from drivers/media/usb/siano/smsir.h
rename to drivers/media/common/siano/smsir.h
diff --git a/drivers/media/mmc/Kconfig b/drivers/media/mmc/Kconfig
new file mode 100644
index 0000000..0f2a957
--- /dev/null
+++ b/drivers/media/mmc/Kconfig
@@ -0,0 +1 @@
+source "drivers/media/mmc/siano/Kconfig"
diff --git a/drivers/media/mmc/Makefile b/drivers/media/mmc/Makefile
new file mode 100644
index 0000000..dacd3cb
--- /dev/null
+++ b/drivers/media/mmc/Makefile
@@ -0,0 +1 @@
+obj-y := siano/
diff --git a/drivers/media/mmc/siano/Kconfig b/drivers/media/mmc/siano/Kconfig
new file mode 100644
index 0000000..fa62475
--- /dev/null
+++ b/drivers/media/mmc/siano/Kconfig
@@ -0,0 +1,10 @@
+#
+# Siano Mobile Silicon Digital TV device configuration
+#
+
+config SMS_SDIO_DRV
+	tristate "Siano SMS1xxx based MDTV via SDIO interface"
+	depends on DVB_CORE && RC_CORE && HAS_DMA
+	depends on MMC
+	---help---
+	  Choose if you would like to have Siano's support for SDIO interface
diff --git a/drivers/media/mmc/siano/Makefile b/drivers/media/mmc/siano/Makefile
new file mode 100644
index 0000000..0e01f97
--- /dev/null
+++ b/drivers/media/mmc/siano/Makefile
@@ -0,0 +1,6 @@
+obj-$(CONFIG_SMS_SDIO_DRV) += smssdio.o
+
+ccflags-y += -Idrivers/media/dvb-core
+ccflags-y += -Idrivers/media/common/siano
+ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
+
diff --git a/drivers/media/usb/siano/smssdio.c b/drivers/media/mmc/siano/smssdio.c
similarity index 100%
rename from drivers/media/usb/siano/smssdio.c
rename to drivers/media/mmc/siano/smssdio.c
diff --git a/drivers/media/usb/siano/Kconfig b/drivers/media/usb/siano/Kconfig
index bc6456e..3c76e62 100644
--- a/drivers/media/usb/siano/Kconfig
+++ b/drivers/media/usb/siano/Kconfig
@@ -2,33 +2,9 @@
 # Siano Mobile Silicon Digital TV device configuration
 #
 
-config SMS_SIANO_MDTV
+config SMS_USB_DRV
 	tristate "Siano SMS1xxx based MDTV receiver"
 	depends on DVB_CORE && RC_CORE && HAS_DMA
 	---help---
-	  Choose Y or M here if you have MDTV receiver with a Siano chipset.
-
-	  To compile this driver as a module, choose M here
-	  (The module will be called smsmdtv).
-
-	  Further documentation on this driver can be found on the WWW
-	  at http://www.siano-ms.com/
-
-if SMS_SIANO_MDTV
-menu "Siano module components"
-
-# Hardware interfaces support
-
-config SMS_USB_DRV
-	tristate "USB interface support"
-	depends on DVB_CORE && USB
-	---help---
 	  Choose if you would like to have Siano's support for USB interface
 
-config SMS_SDIO_DRV
-	tristate "SDIO interface support"
-	depends on DVB_CORE && MMC
-	---help---
-	  Choose if you would like to have Siano's support for SDIO interface
-endmenu
-endif # SMS_SIANO_MDTV
diff --git a/drivers/media/usb/siano/Makefile b/drivers/media/usb/siano/Makefile
index 14756bd..758b6a0 100644
--- a/drivers/media/usb/siano/Makefile
+++ b/drivers/media/usb/siano/Makefile
@@ -1,11 +1,6 @@
-
-smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o smsir.o
-
-obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o smsdvb.o
 obj-$(CONFIG_SMS_USB_DRV) += smsusb.o
-obj-$(CONFIG_SMS_SDIO_DRV) += smssdio.o
 
 ccflags-y += -Idrivers/media/dvb-core
-
+ccflags-y += -Idrivers/media/common/siano
 ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
 
-- 
1.7.10.2

