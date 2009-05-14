Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110812.mail.gq1.yahoo.com ([67.195.13.235]:26168 "HELO
	web110812.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751159AbZENT0S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 15:26:18 -0400
Message-ID: <7362.40279.qm@web110812.mail.gq1.yahoo.com>
Date: Thu, 14 May 2009 12:26:18 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_10] Siano - perform clean multi-modules build
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242323350 -10800
# Node ID f93a86c6f9785cb60e015e811ddfca6850135887
# Parent  0018ed9bbca31e76a17ead56e2e953c325c7cf3f
[0905_10] Siano - perform clean multi-modules build

From: Uri Shkolnik <uris@siano-ms.com>

Clean up the multi dynamic module build, so no warning/errors
will occur either with clean kernel git or Siano's repository.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 0018ed9bbca3 -r f93a86c6f978 linux/drivers/media/dvb/siano/Kconfig
--- a/linux/drivers/media/dvb/siano/Kconfig	Tue May 12 16:13:13 2009 +0000
+++ b/linux/drivers/media/dvb/siano/Kconfig	Thu May 14 20:49:10 2009 +0300
@@ -2,25 +2,74 @@
 # Siano Mobile Silicon Digital TV device configuration
 #
 
-config DVB_SIANO_SMS1XXX
-	tristate "Siano SMS1XXX USB dongle support"
-	depends on DVB_CORE && USB
+config SMS_SIANO_MDTV
+	tristate "Siano SMS1xxx based MDTV receiver"
+	default m
 	---help---
-	  Choose Y here if you have a USB dongle with a SMS1XXX chipset.
+	Choose Y or M here if you have MDTV receiver with a Siano chipset.
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called sms1xxx.
+	To compile this driver as a module, choose M here
+	(The modules will be called smsmdtv).
 
-config DVB_SIANO_SMS1XXX_SMS_IDS
-	bool "Enable support for Siano Mobile Silicon default USB IDs"
-	depends on DVB_SIANO_SMS1XXX
-	default y
+	Note: All dependents, if selected, will be part of this module.
+
+	Further documentation on this driver can be found on the WWW at http://www.siano-ms.com/
+
+if SMS_SIANO_MDTV
+menu "Siano module components"
+
+# Kernel sub systems support
+config SMS_DVB3_SUBSYS
+	tristate "DVB v.3 Subsystem support"
+	depends on DVB_CORE
+	default m if DVB_CORE
 	---help---
-	  Choose Y here if you have a USB dongle with a SMS1XXX chipset
-	  that uses Siano Mobile Silicon's default usb vid:pid.
+	Choose if you would like to have DVB v.3 kernel sub-system support.
 
-	  Choose N here if you would prefer to use Siano's external driver.
+#config SMS_DVB5_S2API_SUBSYS
+#	tristate "DVB v.5 (S2 API) Subsystem support"
+#	default n
+#	---help---
+#	Choose if you would like to have DVB v.5 (S2 API) kernel sub-system support.
+#
+#config SMS_HOSTLIB_SUBSYS
+#	tristate "Host Library Subsystem support"
+#	default n
+#	---help---
+#	Choose if you would like to have Siano's host library kernel sub-system support.
+#
+#if SMS_HOSTLIB_SUBSYS
+#
+#config SMS_NET_SUBSYS
+#	tristate "Siano Network Adapter"
+#	depends on SMS_HOSTLIB_SUBSYS
+#	default n
+#	---help---
+#	Choose if you would like to have Siano's network adapter support.
+#endif # SMS_HOSTLIB_SUBSYS
 
-	  Further documentation on this driver can be found on the WWW at
-	  <http://www.siano-ms.com/>.
+# Hardware interfaces support
 
+config SMS_USB_DRV
+	tristate "USB interface support"
+	depends on USB
+	default m if USB
+	---help---
+	Choose if you would like to have Siano's support for USB interface
+
+config SMS_SDIO_DRV
+	tristate "SDIO interface support"
+	depends on MMC
+	default m if MMC
+	---help---
+	Choose if you would like to have Siano's support for SDIO interface
+
+#config SMS_SPI_PXA310_DRV
+#	tristate "PXA 310 SPI interface support"
+#	depends on ARM && ARCH_PXA && MACH_ZYLONITE && PXA_SSP && SPI
+#	default m if ARM && ARCH_PXA && MACH_ZYLONITE && PXA_SSP && SPI
+#	---help---
+#	Choose if you would like to have Siano's support for PXA 310 SPI interface
+
+endmenu
+endif # SMS_SIANO_MDTV
diff -r 0018ed9bbca3 -r f93a86c6f978 linux/drivers/media/dvb/siano/Makefile
--- a/linux/drivers/media/dvb/siano/Makefile	Tue May 12 16:13:13 2009 +0000
+++ b/linux/drivers/media/dvb/siano/Makefile	Thu May 14 20:49:10 2009 +0300
@@ -1,8 +1,9 @@ sms1xxx-objs := smscoreapi.o sms-cards.o
-sms1xxx-objs := smscoreapi.o sms-cards.o smsendian.o
+smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o
 
-obj-$(CONFIG_DVB_SIANO_SMS1XXX) += sms1xxx.o
-obj-$(CONFIG_DVB_SIANO_SMS1XXX) += smsusb.o
-obj-$(CONFIG_DVB_SIANO_SMS1XXX) += smsdvb.o
+obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o
+obj-$(CONFIG_SMS_USB_DRV) += smsusb.o
+obj-$(CONFIG_SMS_DVB3_SUBSYS) += smsdvb.o
+#obj-$(CONFIG_SMS_SDIO_DRV) += smssdio.o
 
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 
diff -r 0018ed9bbca3 -r f93a86c6f978 linux/drivers/media/dvb/siano/smsendian.h
--- a/linux/drivers/media/dvb/siano/smsendian.h	Tue May 12 16:13:13 2009 +0000
+++ b/linux/drivers/media/dvb/siano/smsendian.h	Thu May 14 20:49:10 2009 +0300
@@ -24,9 +24,9 @@ along with this program.  If not, see <h
 
 #include <asm/byteorder.h>
 
-void smsendian_handle_tx_message(void *buffer);
-void smsendian_handle_rx_message(void *buffer);
-void smsendian_handle_message_header(void *msg);
+extern void smsendian_handle_tx_message(void *buffer);
+extern void smsendian_handle_rx_message(void *buffer);
+extern void smsendian_handle_message_header(void *msg);
 
 #endif /* __SMS_ENDIAN_H__ */
 



      
