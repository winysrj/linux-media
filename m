Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:32856 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbcLCJoc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Dec 2016 04:44:32 -0500
From: Tabrez khan <khan.tabrez21@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging:bcm2048 : Add parentheses around  variable x
Date: Sat,  3 Dec 2016 15:14:26 +0530
Message-Id: <1480758266-6160-1-git-send-email-khan.tabrez21@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add parentheses around variable x for the readability purpose.

This warning was found using checkpatch.pl.

Signed-off-by: Tabrez khan <khan.tabrez21@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 4d9bd02..2f28dd0 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -185,7 +185,7 @@
 #define v4l2_to_dev(f)	((f * BCM2048_FREQV4L2_MULTI) / BCM2048_FREQDEV_UNIT)
 
 #define msb(x)                  ((u8)((u16)x >> 8))
-#define lsb(x)                  ((u8)((u16)x &  0x00FF))
+#define lsb(x)                  ((u8)((u16)(x) &  0x00FF))
 #define compose_u16(msb, lsb)	(((u16)msb << 8) | lsb)
 
 #define BCM2048_DEFAULT_POWERING_DELAY	20
-- 
2.7.4

