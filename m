Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:54207 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbZFQOgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 10:36:20 -0400
Received: by fg-out-1718.google.com with SMTP id 16so123971fgg.17
        for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 07:36:22 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Jun 2009 17:36:21 +0300
Message-ID: <f1e62fb30906170736j69c9ff90pccef1be313d0dfe4@mail.gmail.com>
Subject: [PATCH] [09061_01] Siano: Update KConfig and Makefile
From: Udi Atar <udi.linuxtv@gmail.com>
To: LinuxML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Udi Atar <udia@siano-ms.com>
# Date 1245248482 -10800
# Node ID 46081b3e60046b900c9c8110513224911df8e106
# Parent  b385a43af222b6c8d2d93937644eb936f63d81e3
Update Siano KConfig file

From: Udi Atar <udia@siano-ms.com>

Priority: normal

Signed-off-by: Udi Atar <udia@siano-ms.com>

diff -r b385a43af222 -r 46081b3e6004 linux/drivers/media/dvb/siano/Kconfig
--- a/linux/drivers/media/dvb/siano/Kconfig	Tue Jun 16 23:55:44 2009 -0300
+++ b/linux/drivers/media/dvb/siano/Kconfig	Wed Jun 17 17:21:22 2009 +0300
@@ -2,25 +2,32 @@
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
+	depends on USB
+	default m if USB
 	---help---
-	  Choose Y here if you have a USB dongle with a SMS1XXX chipset
-	  that uses Siano Mobile Silicon's default usb vid:pid.
+	Choose if you would like to have Siano's support for USB interface

-	  Choose N here if you would prefer to use Siano's external driver.

-	  Further documentation on this driver can be found on the WWW at
-	  <http://www.siano-ms.com/>.
-
+endmenu
+endif # SMS_SIANO_MDTV
diff -r b385a43af222 -r 46081b3e6004 linux/drivers/media/dvb/siano/Makefile
--- a/linux/drivers/media/dvb/siano/Makefile	Tue Jun 16 23:55:44 2009 -0300
+++ b/linux/drivers/media/dvb/siano/Makefile	Wed Jun 17 17:21:22 2009 +0300
@@ -1,8 +1,8 @@
-sms1xxx-objs := smscoreapi.o sms-cards.o smsendian.o smsir.o

-obj-$(CONFIG_DVB_SIANO_SMS1XXX) += sms1xxx.o
-obj-$(CONFIG_DVB_SIANO_SMS1XXX) += smsusb.o
-obj-$(CONFIG_DVB_SIANO_SMS1XXX) += smsdvb.o
+smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o smsir.o
+
+obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o smsdvb.o
+obj-$(CONFIG_SMS_USB_DRV) += smsusb.o

 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
