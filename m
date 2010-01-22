Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.bearnet.nu ([80.252.223.222]:3197 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab0AVMio (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 07:38:44 -0500
Message-ID: <4B599C48.9050508@pelagicore.com>
Date: Fri, 22 Jan 2010 13:38:32 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] radio: Add radio-timb to the Kconfig and Makefile
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds radio-timb to the Makefile and Kconfig.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 3f40f37..032ae2b 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -429,4 +429,14 @@ config RADIO_TEF6862
 	  To compile this driver as a module, choose M here: the
 	  module will be called TEF6862.

+config RADIO_TIMBERDALE
+	tristate "Enable the Timberdale radio driver"
+	depends on MFD_TIMBERDALE && HAS_IOMEM
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

