Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35776 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbdDHPov (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 11:44:51 -0400
Received: by mail-wr0-f196.google.com with SMTP id t20so23770553wra.2
        for <linux-media@vger.kernel.org>; Sat, 08 Apr 2017 08:44:50 -0700 (PDT)
From: Nikola Jelic <nikola.jelic83@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] media: bcm2048: fix several macros
Date: Sat,  8 Apr 2017 17:44:41 +0200
Message-Id: <20170408154441.10719-1-nikola.jelic83@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some of the macros didn't use the parenthesis around the parameters when
used in the body of the macro.

Signed-off-by: Nikola Jelic <nikola.jelic83@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 375c6178032a..38f72d069e27 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -177,12 +177,12 @@
 
 #define BCM2048_FREQDEV_UNIT		10000
 #define BCM2048_FREQV4L2_MULTI		625
-#define dev_to_v4l2(f)	((f * BCM2048_FREQDEV_UNIT) / BCM2048_FREQV4L2_MULTI)
-#define v4l2_to_dev(f)	((f * BCM2048_FREQV4L2_MULTI) / BCM2048_FREQDEV_UNIT)
+#define dev_to_v4l2(f)	(((f) * BCM2048_FREQDEV_UNIT) / BCM2048_FREQV4L2_MULTI)
+#define v4l2_to_dev(f)	(((f) * BCM2048_FREQV4L2_MULTI) / BCM2048_FREQDEV_UNIT)
 
-#define msb(x)                  ((u8)((u16)x >> 8))
-#define lsb(x)                  ((u8)((u16)x &  0x00FF))
-#define compose_u16(msb, lsb)	(((u16)msb << 8) | lsb)
+#define msb(x)                  ((u8)((u16)(x) >> 8))
+#define lsb(x)                  ((u8)((u16)(x) &  0x00FF))
+#define compose_u16(msb, lsb)	(((u16)(msb) << 8) | (lsb))
 
 #define BCM2048_DEFAULT_POWERING_DELAY	20
 #define BCM2048_DEFAULT_REGION		0x02
@@ -2016,7 +2016,7 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,		\
 	if (!bdev)							\
 		return -ENODEV;						\
 									\
-	out = kzalloc(size + 1, GFP_KERNEL);				\
+	out = kzalloc((size) + 1, GFP_KERNEL);				\
 	if (!out)							\
 		return -ENOMEM;						\
 									\
-- 
2.11.0
