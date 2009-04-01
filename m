Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:38483 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbZDAJrv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 05:47:51 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx06.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id n319leYj020863
	for <linux-media@vger.kernel.org>; Wed, 1 Apr 2009 12:47:45 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH 3/3] FMTx: si4713: Add Kconfig and Makefile entries
Date: Wed,  1 Apr 2009 12:43:31 +0300
Message-Id: <1238579011-12435-4-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1238579011-12435-3-git-send-email-eduardo.valentin@nokia.com>
References: <1238579011-12435-1-git-send-email-eduardo.valentin@nokia.com>
 <1238579011-12435-2-git-send-email-eduardo.valentin@nokia.com>
 <1238579011-12435-3-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 drivers/media/radio/Kconfig  |   12 ++++++++++++
 drivers/media/radio/Makefile |    2 ++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 3315cac..b7f9ab9 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -339,6 +339,18 @@ config RADIO_ZOLTRIX_PORT
 	help
 	  Enter the I/O port of your Zoltrix radio card.
 
+config I2C_SI4713
+	tristate "Silicon Labs Si4713 FM Radio Transmitter support"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  Say Y here if you want support to Si4713 FM Radio Transmitter.
+	  This device can transmit audio through FM. It can transmit
+	  EDS and EBDS signals as well. This device driver supports only
+	  i2c bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called fmtx-si4713.
+
 config USB_DSBR
 	tristate "D-Link/GemTek USB FM radio support"
 	depends on USB && VIDEO_V4L2
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index 0f2b35b..3b1a4ec 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -15,6 +15,8 @@ obj-$(CONFIG_RADIO_ZOLTRIX) += radio-zoltrix.o
 obj-$(CONFIG_RADIO_GEMTEK) += radio-gemtek.o
 obj-$(CONFIG_RADIO_GEMTEK_PCI) += radio-gemtek-pci.o
 obj-$(CONFIG_RADIO_TRUST) += radio-trust.o
+obj-$(CONFIG_I2C_SI4713) += fmtx-si4713.o
+fmtx-si4713-objs := radio-si4713.o si4713.o
 obj-$(CONFIG_RADIO_MAESTRO) += radio-maestro.o
 obj-$(CONFIG_USB_DSBR) += dsbr100.o
 obj-$(CONFIG_USB_SI470X) += radio-si470x.o
-- 
1.6.2.GIT

