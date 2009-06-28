Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:58388 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbZF1M5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2009 08:57:41 -0400
Received: by fg-out-1718.google.com with SMTP id e12so295958fga.17
        for <linux-media@vger.kernel.org>; Sun, 28 Jun 2009 05:57:43 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 28 Jun 2009 15:57:43 +0300
Message-ID: <f1e62fb30906280557q4bb8bec6gc4eb8e5024c52a37@mail.gmail.com>
Subject: [PATCH] [0906_03] Siano: Update KConfig File to enable SDIO and USB
	interfaces
From: Udi Atar <udi.linuxtv@gmail.com>
To: LinuxML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Udi Atar <udia@siano-ms.com>
# Date 1246193615 -10800
# Node ID 32672e1ce386bc0da3f581576c312c447aabab01
# Parent  732b628672570537eb78109314fb60fa8f0efaf6
Update KConfig File to enable SDIO and USB interfaces

From: Udi Atar <udia@siano-ms.com>

Update KConfig file to enbale selection of SDIO and USB
interfaces, and add dependancy on relevant modules.

Priority: normal

Signed-off-by: Udi Atar <udia@siano-ms.com>

diff -r 732b62867257 -r 32672e1ce386 linux/drivers/media/dvb/siano/Kconfig
--- a/linux/drivers/media/dvb/siano/Kconfig	Sun Jun 28 09:58:01 2009 +0300
+++ b/linux/drivers/media/dvb/siano/Kconfig	Sun Jun 28 15:53:35 2009 +0300
@@ -2,25 +2,37 @@
 # Siano Mobile Silicon Digital TV device configuration
 #

-config DVB_SIANO_SMS1XXX
-	tristate "Siano SMS1XXX USB dongle support"
+config SMS_SIANO_MDTV
+	tristate "Siano SMS1xxx based MDTV receiver"
+	depends on DVB_CORE
+	default m
+	---help---
+	Choose Y or M here if you have MDTV receiver with a Siano chipset.
+
+	To compile this driver as a module, choose M here
+	(The module will be called smsmdtv).
+
+	Further documentation on this driver can be found on the WWW
+	at http://www.siano-ms.com/
+
+if SMS_SIANO_MDTV
+menu "Siano module components"
+
+# Hardware interfaces support
+
+config SMS_USB_DRV
+	tristate "USB interface support"
 	depends on DVB_CORE && USB
+	default m
 	---help---
-	  Choose Y here if you have a USB dongle with a SMS1XXX chipset.
+	Choose if you would like to have Siano's support for USB interface

-	  To compile this driver as a module, choose M here: the
-	  module will be called sms1xxx.
+config SMS_SDIO_DRV
+	tristate "SDIO interface support"
+	depends on DVB_CORE && MMC
+	default m
+	---help---
+	Choose if you would like to have Siano's support for SDIO interface

-config DVB_SIANO_SMS1XXX_SMS_IDS
-	bool "Enable support for Siano Mobile Silicon default USB IDs"
-	depends on DVB_SIANO_SMS1XXX
-	default y
-	---help---
-	  Choose Y here if you have a USB dongle with a SMS1XXX chipset
-	  that uses Siano Mobile Silicon's default usb vid:pid.
-
-	  Choose N here if you would prefer to use Siano's external driver.
-
-	  Further documentation on this driver can be found on the WWW at
-	  <http://www.siano-ms.com/>.
-
+endmenu
+endif # SMS_SIANO_MDTV
diff -r 732b62867257 -r 32672e1ce386 linux/drivers/media/dvb/siano/Makefile
--- a/linux/drivers/media/dvb/siano/Makefile	Sun Jun 28 09:58:01 2009 +0300
+++ b/linux/drivers/media/dvb/siano/Makefile	Sun Jun 28 15:53:35 2009 +0300
@@ -1,8 +1,9 @@
-sms1xxx-objs := smscoreapi.o sms-cards.o smsendian.o smsir.o

-obj-$(CONFIG_DVB_SIANO_SMS1XXX) += sms1xxx.o
-obj-$(CONFIG_DVB_SIANO_SMS1XXX) += smsusb.o
-obj-$(CONFIG_DVB_SIANO_SMS1XXX) += smsdvb.o
+smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o smsir.o
+
+obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o smsdvb.o
+obj-$(CONFIG_SMS_USB_DRV) += smsusb.o
+obj-$(CONFIG_SMS_SDIO_DRV) += smssdio.o

 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
