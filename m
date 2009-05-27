Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38876 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024AbZE0Jkq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 05:40:46 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv4 7 of 8] FMTx: si4713: Add Kconfig and Makefile entries
Date: Wed, 27 May 2009 12:35:54 +0300
Message-Id: <1243416955-29748-8-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1243416955-29748-7-git-send-email-eduardo.valentin@nokia.com>
References: <1243416955-29748-1-git-send-email-eduardo.valentin@nokia.com>
 <1243416955-29748-2-git-send-email-eduardo.valentin@nokia.com>
 <1243416955-29748-3-git-send-email-eduardo.valentin@nokia.com>
 <1243416955-29748-4-git-send-email-eduardo.valentin@nokia.com>
 <1243416955-29748-5-git-send-email-eduardo.valentin@nokia.com>
 <1243416955-29748-6-git-send-email-eduardo.valentin@nokia.com>
 <1243416955-29748-7-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Eduardo Valentin <eduardo.valentin@nokia.com>
# Date 1243414607 -10800
# Branch export
# Node ID b1d98e675a3c4e9e6d247701c9ac18239e3dcc1c
# Parent  1abb96fdce05e1449faac2223e93056bacf389bd
Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 drivers/media/linux/radio/Kconfig  |   22 ++++++++++++++++++++++
 drivers/media/linux/radio/Makefile |    3 +++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff -r 1abb96fdce05 -r b1d98e675a3c linux/drivers/media/radio/Kconfig
--- a/linux/drivers/media/radio/Kconfig	Wed May 27 11:56:46 2009 +0300
+++ b/linux/drivers/media/radio/Kconfig	Wed May 27 11:56:47 2009 +0300
@@ -339,6 +339,28 @@
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
diff -r 1abb96fdce05 -r b1d98e675a3c linux/drivers/media/radio/Makefile
--- a/linux/drivers/media/radio/Makefile	Wed May 27 11:56:46 2009 +0300
+++ b/linux/drivers/media/radio/Makefile	Wed May 27 11:56:47 2009 +0300
@@ -15,6 +15,9 @@
 obj-$(CONFIG_RADIO_GEMTEK) += radio-gemtek.o
 obj-$(CONFIG_RADIO_GEMTEK_PCI) += radio-gemtek-pci.o
 obj-$(CONFIG_RADIO_TRUST) += radio-trust.o
+obj-$(CONFIG_I2C_SI4713) += si4713-i2c.o
+si4713-i2c-objs := si4713.o si4713-subdev.o
+obj-$(CONFIG_RADIO_SI4713) += radio-si4713.o
 obj-$(CONFIG_RADIO_MAESTRO) += radio-maestro.o
 obj-$(CONFIG_USB_DSBR) += dsbr100.o
 obj-$(CONFIG_USB_SI470X) += radio-si470x.o
