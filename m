Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:53361 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZFHIW6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 04:22:58 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv6 6 of 7] FMTx: si4713: Add Kconfig and Makefile entries
Date: Mon,  8 Jun 2009 11:18:06 +0300
Message-Id: <1244449087-5543-7-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1244449087-5543-6-git-send-email-eduardo.valentin@nokia.com>
References: <1244449087-5543-1-git-send-email-eduardo.valentin@nokia.com>
 <1244449087-5543-2-git-send-email-eduardo.valentin@nokia.com>
 <1244449087-5543-3-git-send-email-eduardo.valentin@nokia.com>
 <1244449087-5543-4-git-send-email-eduardo.valentin@nokia.com>
 <1244449087-5543-5-git-send-email-eduardo.valentin@nokia.com>
 <1244449087-5543-6-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Eduardo Valentin <eduardo.valentin@nokia.com>

# HG changeset patch
# User Eduardo Valentin <eduardo.valentin@nokia.com>
# Date 1243414607 -10800
# Node ID fbdd1a2a4fd099a98b1a48f3853a78c0a544632d
# Parent  786afca68fc9fd35b18ee5cb4166b491613b13a5
Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 drivers/media/radio/Kconfig  |   22 ++++++++++++++++++++++
 drivers/media/radio/Makefile |    3 +++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff -r 786afca68fc9 -r fbdd1a2a4fd0 linux/drivers/media/radio/Kconfig
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
diff -r 786afca68fc9 -r fbdd1a2a4fd0 linux/drivers/media/radio/Makefile
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
