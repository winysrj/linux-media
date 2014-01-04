Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43694 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbaADN7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 08:59:17 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v4 16/22] [media] em28xx: use a better value for I2C timeouts
Date: Sat,  4 Jan 2014 08:55:45 -0200
Message-Id: <1388832951-11195-17-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
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
index db47c2236ca4..9af19332b0f1 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -183,8 +183,21 @@
 
 #define EM28XX_INTERLACED_DEFAULT 1
 
-/* time in msecs to wait for i2c xfers to finish */
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
+#define EM2800_I2C_XFER_TIMEOUT		36
 
 /* time in msecs to wait for AC97 xfers to finish */
 #define EM2800_AC97_XFER_TIMEOUT	100
-- 
1.8.3.1

