Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:51597 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934013AbZHHLXZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 07:23:25 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv15 7/8] FM TX: si4713: Add Kconfig and Makefile entries
Date: Sat,  8 Aug 2009 14:10:32 +0300
Message-Id: <1249729833-24975-8-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1249729833-24975-7-git-send-email-eduardo.valentin@nokia.com>
References: <1249729833-24975-1-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-2-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-3-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-4-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-5-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-6-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-7-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simple add Makefile and Kconfig entries.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 linux/drivers/media/radio/Kconfig  |   22 ++++++++++++++++++++++
 linux/drivers/media/radio/Makefile |    2 ++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/linux/drivers/media/radio/Kconfig b/linux/drivers/media/radio/Kconfig
index 3315cac..6c6a409 100644
--- a/linux/drivers/media/radio/Kconfig
+++ b/linux/drivers/media/radio/Kconfig
@@ -339,6 +339,28 @@ config RADIO_ZOLTRIX_PORT
 	help
 	  Enter the I/O port of your Zoltrix radio card.
 
+config I2C_SI4713
+	tristate "I2C driver for Silicon Labs Si4713 device"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  Say Y here if you want support to Si4713 I2C device.
+	  This device driver supports only i2c bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called si4713.
+
+config RADIO_SI4713
+	tristate "Silicon Labs Si4713 FM Radio Transmitter support"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  Say Y here if you want support to Si4713 FM Radio Transmitter.
+	  This device can transmit audio through FM. It can transmit
+	  EDS and EBDS signals as well. This module is the v4l2 radio
+	  interface for the i2c driver of this device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-si4713.
+
 config USB_DSBR
 	tristate "D-Link/GemTek USB FM radio support"
 	depends on USB && VIDEO_V4L2
diff --git a/linux/drivers/media/radio/Makefile b/linux/drivers/media/radio/Makefile
index 0f2b35b..34ae761 100644
--- a/linux/drivers/media/radio/Makefile
+++ b/linux/drivers/media/radio/Makefile
@@ -15,6 +15,8 @@ obj-$(CONFIG_RADIO_ZOLTRIX) += radio-zoltrix.o
 obj-$(CONFIG_RADIO_GEMTEK) += radio-gemtek.o
 obj-$(CONFIG_RADIO_GEMTEK_PCI) += radio-gemtek-pci.o
 obj-$(CONFIG_RADIO_TRUST) += radio-trust.o
+obj-$(CONFIG_I2C_SI4713) += si4713-i2c.o
+obj-$(CONFIG_RADIO_SI4713) += radio-si4713.o
 obj-$(CONFIG_RADIO_MAESTRO) += radio-maestro.o
 obj-$(CONFIG_USB_DSBR) += dsbr100.o
 obj-$(CONFIG_USB_SI470X) += radio-si470x.o
-- 
1.6.2.GIT

