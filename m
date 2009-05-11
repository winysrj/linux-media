Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:52722 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbZEKGmp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 02:42:45 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id n4B6gdHP005187
	for <linux-media@vger.kernel.org>; Mon, 11 May 2009 09:42:41 +0300
From: ext-eero.nurkkala@nokia.com
To: linux-media@vger.kernel.org
Cc: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Subject: [PATCH 2/2] V4L: Add BCM2048 radio driver Makefile and Kconfig dependencies
Date: Mon, 11 May 2009 09:41:19 +0300
Message-Id: <12420240833715-git-send-email-ext-eero.nurkkala@nokia.com>
In-Reply-To: <12420240811376-git-send-email-ext-eero.nurkkala@nokia.com>
References: <1242024079959-git-send-email-ext-eero.nurkkala@nokia.com>
 <12420240811376-git-send-email-ext-eero.nurkkala@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>

This adds the Makefile and Kconfig entries for
the BCM2048 radio chip.

Signed-off-by: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
---
 drivers/media/radio/Kconfig  |   10 ++++++++++
 drivers/media/radio/Makefile |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 3315cac..c4d8a5d 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -387,6 +387,16 @@ config USB_MR800
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-mr800.
 
+config I2C_BCM2048
+	tristate "Broadcom BCM2048 FM Radio Receiver support"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  Say Y here if you want support to BCM2048 FM Radio Receiver.
+	  This device driver supports only i2c bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-bcm2048.
+
 config RADIO_TEA5764
 	tristate "TEA5764 I2C FM radio support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index 0f2b35b..c1575b9 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_RADIO_MAESTRO) += radio-maestro.o
 obj-$(CONFIG_USB_DSBR) += dsbr100.o
 obj-$(CONFIG_USB_SI470X) += radio-si470x.o
 obj-$(CONFIG_USB_MR800) += radio-mr800.o
+obj-$(CONFIG_I2C_BCM2048) += radio-bcm2048.o
 obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
 
 EXTRA_CFLAGS += -Isound
-- 
1.5.6.3

