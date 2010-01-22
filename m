Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.bearnet.nu ([80.252.223.222]:2068 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab0AVJJM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 04:09:12 -0500
Message-ID: <4B596B2F.80207@pelagicore.com>
Date: Fri, 22 Jan 2010 10:09:03 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 3/3] radio: Add SAA7706H to Kconfig and Makefile
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the SAA7706H to Kconfig and Makefile, it points out
the source code added in the previous patch.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 3f40f37..1716e52 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -417,6 +417,18 @@ config RADIO_TEA5764_XTAL
 	  Say Y here if TEA5764 have a 32768 Hz crystal in circuit, say N
 	  here if TEA5764 reference frequency is connected in FREQIN.

+config RADIO_SAA7706H
+	tristate "SAA7706H Car Radio DSP"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  Say Y here if you want to use the SAA7706H Car radio Digital
+	  Signal Processor, found for instance on the Russellville development
+	  board. On the russellville the device is connected to internal
+	  timberdale I2C bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called SAA7706H.
+
 config RADIO_TEF6862
 	tristate "TEF6862 Car Radio Enhanced Selectivity Tuner"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index 01922ad..f681dbf 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_USB_DSBR) += dsbr100.o
 obj-$(CONFIG_RADIO_SI470X) += si470x/
 obj-$(CONFIG_USB_MR800) += radio-mr800.o
 obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
+obj-$(CONFIG_RADIO_SAA7706H) += saa7706h.o
 obj-$(CONFIG_RADIO_TEF6862) += tef6862.o

 EXTRA_CFLAGS += -Isound

