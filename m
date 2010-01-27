Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.bearnet.nu ([80.252.223.222]:2795 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab0A0QWX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 11:22:23 -0500
Message-ID: <4B606832.7080006@pelagicore.com>
Date: Wed, 27 Jan 2010 17:22:10 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 2/2] radio: Add radio-timb to the Kconfig and Makefile
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds radio-timb to the Makefile and Kconfig.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 3f40f37..46fd8c4 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -429,4 +429,14 @@ config RADIO_TEF6862
 	  To compile this driver as a module, choose M here: the
 	  module will be called TEF6862.

+config RADIO_TIMBERDALE
+	tristate "Enable the Timberdale radio driver"
+	depends on MFD_TIMBERDALE && VIDEO_V4L2 && HAS_IOMEM
+	select RADIO_TEF6862
+	select RADIO_SAA7706H
+	---help---
+	  This is a kind of umbrella driver for the Radio Tuner and DSP
+	  found behind the Timberdale FPGA on the Russellville board.
+	  Enable this driver will automatically select the DSP and tuner.
+
 endif # RADIO_ADAPTERS
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index 01922ad..8973850 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -24,5 +24,6 @@ obj-$(CONFIG_RADIO_SI470X) += si470x/
 obj-$(CONFIG_USB_MR800) += radio-mr800.o
 obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
 obj-$(CONFIG_RADIO_TEF6862) += tef6862.o
+obj-$(CONFIG_RADIO_TIMBERDALE) += radio-timb.o

 EXTRA_CFLAGS += -Isound

