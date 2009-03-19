Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41949 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbZCSNCZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 09:02:25 -0400
Received: by fxm2 with SMTP id 2so488490fxm.37
        for <linux-media@vger.kernel.org>; Thu, 19 Mar 2009 06:02:22 -0700 (PDT)
Subject: [patch review] radio/Kconfig: introduce 3 groups: isa, pci, and
 others drivers
From: Alexey Klimov <klimov.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Thu, 19 Mar 2009 16:03:20 +0300
Message-Id: <1237467800.19717.37.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, all
What do you think about such patch that makes selecting of radio drivers
in menuconfig more comfortable ?

---

Patch divides/separates radio drivers in Kconfig in 3 groups - ISA, PCI
and others.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 626c136ec221 linux/drivers/media/radio/Kconfig
--- a/linux/drivers/media/radio/Kconfig	Fri Mar 13 14:35:14 2009 -0700
+++ b/linux/drivers/media/radio/Kconfig	Thu Mar 19 15:20:12 2009 +0300
@@ -10,6 +10,13 @@
 	  Say Y here to enable selecting AM/FM radio adapters.
 
 if RADIO_ADAPTERS && VIDEO_V4L2
+
+config RADIO_ADAPTERS_ISA
+	boolean "ISA radio adapters"
+	---help---
+	  Enable this if you have ISA-based radio adapter.
+
+if RADIO_ADAPTERS_ISA
 
 config RADIO_CADET
 	tristate "ADS Cadet AM/FM Tuner"
@@ -150,50 +157,6 @@
 	  Say Y here to enable automatic probing for GemTek Radio card. The
 	  following ports will be probed: 0x20c, 0x30c, 0x24c, 0x34c, 0x248 and
 	  0x28c.
-
-config RADIO_GEMTEK_PCI
-	tristate "GemTek PCI Radio Card support"
-	depends on VIDEO_V4L2 && PCI
-	---help---
-	  Choose Y here if you have this PCI FM radio card.
-
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video for Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called radio-gemtek-pci.
-
-config RADIO_MAXIRADIO
-	tristate "Guillemot MAXI Radio FM 2000 radio"
-	depends on VIDEO_V4L2 && PCI
-	---help---
-	  Choose Y here if you have this radio card.  This card may also be
-	  found as Gemtek PCI FM.
-
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called radio-maxiradio.
-
-config RADIO_MAESTRO
-	tristate "Maestro on board radio"
-	depends on VIDEO_V4L2 && PCI
-	---help---
-	  Say Y here to directly support the on-board radio tuner on the
-	  Maestro 2 or 2E sound card.
-
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called radio-maestro.
 
 config RADIO_SF16FMI
 	tristate "SF16FMI Radio"
@@ -339,6 +302,68 @@
 	help
 	  Enter the I/O port of your Zoltrix radio card.
 
+endif # RADIO_ADAPTERS_ISA
+
+config RADIO_ADAPTERS_PCI
+	boolean "PCI radio adapters"
+	---help---
+	  Enable this if you have PCI-based radio adapters.
+
+if RADIO_ADAPTERS_PCI
+
+config RADIO_GEMTEK_PCI
+	tristate "GemTek PCI Radio Card support"
+	depends on VIDEO_V4L2 && PCI
+	---help---
+	  Choose Y here if you have this PCI FM radio card.
+
+	  In order to control your radio card, you will need to use programs
+	  that are compatible with the Video for Linux API.  Information on
+	  this API and pointers to "v4l" programs may be found at
+	  <file:Documentation/video4linux/API.html>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-gemtek-pci.
+
+config RADIO_MAXIRADIO
+	tristate "Guillemot MAXI Radio FM 2000 radio"
+	depends on VIDEO_V4L2 && PCI
+	---help---
+	  Choose Y here if you have this radio card.  This card may also be
+	  found as Gemtek PCI FM.
+
+	  In order to control your radio card, you will need to use programs
+	  that are compatible with the Video For Linux API.  Information on
+	  this API and pointers to "v4l" programs may be found at
+	  <file:Documentation/video4linux/API.html>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-maxiradio.
+
+config RADIO_MAESTRO
+	tristate "Maestro on board radio"
+	depends on VIDEO_V4L2 && PCI
+	---help---
+	  Say Y here to directly support the on-board radio tuner on the
+	  Maestro 2 or 2E sound card.
+
+	  In order to control your radio card, you will need to use programs
+	  that are compatible with the Video For Linux API.  Information on
+	  this API and pointers to "v4l" programs may be found at
+	  <file:Documentation/video4linux/API.html>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-maestro.
+
+endif # RADIO_ADAPTERS_PCI
+
+config RADIO_ADAPTERS_OTHERS
+	boolean "USB, I2C and others radio adapter interfaces"
+	---help---
+	  Enable this if you have USB, I2C or others radio interfaces.
+
+if RADIO_ADAPTERS_OTHERS
+
 config USB_DSBR
 	tristate "D-Link/GemTek USB FM radio support"
 	depends on USB && VIDEO_V4L2
@@ -406,4 +431,6 @@
 	  Say Y here if TEA5764 have a 32768 Hz crystal in circuit, say N
 	  here if TEA5764 reference frequency is connected in FREQIN.
 
+endif # RADIO_ADAPTERS_OTHERS
+
 endif # RADIO_ADAPTERS



-- 
Best regards, Klimov Alexey

