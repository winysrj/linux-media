Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:11748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab0L0O0p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 09:26:45 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBREQjpQ021707
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 09:26:45 -0500
Received: from [10.11.11.201] (vpn-11-201.rdu.redhat.com [10.11.11.201])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBREQfr2004280
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 09:26:44 -0500
Message-ID: <4D18A220.804@redhat.com>
Date: Mon, 27 Dec 2010 12:26:40 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] staging/lirc: Fix compilation when LIRC=m
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

drivers/staging/lirc/lirc_bt829.c:141: undefined reference to `lirc_register_driver'
drivers/built-in.o:(.rodata+0x20f68): undefined reference to `lirc_dev_fop_read'
drivers/built-in.o:(.rodata+0x20f7c): undefined reference to `lirc_dev_fop_poll'
drivers/built-in.o:(.rodata+0x20f8c): undefined reference to `lirc_dev_fop_open'
drivers/built-in.o:(.rodata+0x20f94): undefined reference to `lirc_dev_fop_close'
drivers/built-in.o:(.rodata+0x21030): undefined reference to `lirc_dev_fop_open'
drivers/built-in.o:(.rodata+0x21038): undefined reference to `lirc_dev_fop_close'

This happens when .config is like:
	CONFIG_LIRC=m
	CONFIG_IR_LIRC_CODEC=m
	CONFIG_LIRC_STAGING=y
	CONFIG_LIRC_BT829=y

Don't allow that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/lirc/Kconfig b/drivers/staging/lirc/Kconfig
index fa790db..be97f7b 100644
--- a/drivers/staging/lirc/Kconfig
+++ b/drivers/staging/lirc/Kconfig
@@ -14,26 +14,26 @@ if LIRC_STAGING
 
 config LIRC_BT829
         tristate "BT829 based hardware"
-	depends on LIRC_STAGING && PCI
+	depends on LIRC && PCI
 	help
 	  Driver for the IR interface on BT829-based hardware
 
 config LIRC_I2C
 	tristate "I2C Based IR Receivers"
-	depends on LIRC_STAGING && I2C
+	depends on LIRC && I2C
 	help
 	  Driver for I2C-based IR receivers, such as those commonly
 	  found onboard Hauppauge PVR-150/250/350 video capture cards
 
 config LIRC_IGORPLUGUSB
 	tristate "Igor Cesko's USB IR Receiver"
-	depends on LIRC_STAGING && USB
+	depends on LIRC && USB
 	help
 	  Driver for Igor Cesko's USB IR Receiver
 
 config LIRC_IMON
 	tristate "Legacy SoundGraph iMON Receiver and Display"
-	depends on LIRC_STAGING && USB
+	depends on LIRC && USB
 	help
 	  Driver for the original SoundGraph iMON IR Receiver and Display
 
@@ -41,31 +41,31 @@ config LIRC_IMON
 
 config LIRC_IT87
 	tristate "ITE IT87XX CIR Port Receiver"
-	depends on LIRC_STAGING && PNP
+	depends on LIRC && PNP
 	help
 	  Driver for the ITE IT87xx IR Receiver
 
 config LIRC_ITE8709
 	tristate "ITE8709 CIR Port Receiver"
-	depends on LIRC_STAGING && PNP
+	depends on LIRC && PNP
 	help
 	  Driver for the ITE8709 IR Receiver
 
 config LIRC_PARALLEL
 	tristate "Homebrew Parallel Port Receiver"
-	depends on LIRC_STAGING && PARPORT
+	depends on LIRC && PARPORT
 	help
 	  Driver for Homebrew Parallel Port Receivers
 
 config LIRC_SASEM
 	tristate "Sasem USB IR Remote"
-	depends on LIRC_STAGING && USB
+	depends on LIRC && USB
 	help
 	  Driver for the Sasem OnAir Remocon-V or Dign HV5 HTPC IR/VFD Module
 
 config LIRC_SERIAL
 	tristate "Homebrew Serial Port Receiver"
-	depends on LIRC_STAGING
+	depends on LIRC
 	help
 	  Driver for Homebrew Serial Port Receivers
 
@@ -78,19 +78,19 @@ config LIRC_SERIAL_TRANSMITTER
 
 config LIRC_SIR
 	tristate "Built-in SIR IrDA port"
-	depends on LIRC_STAGING
+	depends on LIRC
 	help
 	  Driver for the SIR IrDA port
 
 config LIRC_TTUSBIR
 	tristate "Technotrend USB IR Receiver"
-	depends on LIRC_STAGING && USB
+	depends on LIRC && USB
 	help
 	  Driver for the Technotrend USB IR Receiver
 
 config LIRC_ZILOG
 	tristate "Zilog/Hauppauge IR Transmitter"
-	depends on LIRC_STAGING && I2C
+	depends on LIRC && I2C
 	help
 	  Driver for the Zilog/Hauppauge IR Transmitter, found on
 	  PVR-150/500, HVR-1200/1250/1700/1800, HD-PVR and other cards
