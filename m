Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51343 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbaAFQI2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 11:08:28 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/6] [media] em28xx: use a better value for I2C timeouts
Date: Mon,  6 Jan 2014 11:04:57 -0200
Message-Id: <1389013500-3110-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389013500-3110-1-git-send-email-m.chehab@samsung.com>
References: <1389013500-3110-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the lack of a better spec, let's assume the timeout
values compatible with SMBus spec:
	http://smbus.org/specs/smbus110.pdf

at chapter 8 - Electrical Characteristics of SMBus devices

Ok, SMBus is a subset of I2C, and not all devices will be
following it, but the timeout value before this patch was not
even following the spec.

So, while we don't have a better guess for it, use 35 + 1
ms as the timeout.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 7ae05ebc13c1..949372e11887 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -182,8 +182,21 @@
 
 #define EM28XX_INTERLACED_DEFAULT 1
 
-/* time in msecs to wait for i2c writes to finish */
-#define EM2800_I2C_XFER_TIMEOUT		20
+/*
+ * Time in msecs to wait for i2c xfers to finish.
+ * 35ms is the maximum time a SMBUS device could wait when
+ * clock stretching is used. As the transfer itself will take
+ * some time to happen, set it to 35 ms.
+ *
+ * Ok, I2C doesn't specify any limit. So, eventually, we may need
+ * to increase this timeout.
+ *
+ * FIXME: this assumes that an I2C message is not longer than 1ms.
+ * This is actually dependent on the I2C bus speed, although most
+ * devices use a 100kHz clock. So, this assumtion is true most of
+ * the time.
+ */
+#define EM28XX_I2C_XFER_TIMEOUT		36
 
 /* max. number of button state polling addresses */
 #define EM28XX_NUM_BUTTON_ADDRESSES_MAX		5
-- 
1.8.3.1

