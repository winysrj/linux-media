Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34043 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbcGTAEB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 20:04:01 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: lars@metafoo.de
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 02/10] media: adv7180: Fix broken interrupt register access
Date: Tue, 19 Jul 2016 17:03:29 -0700
Message-Id: <1468973017-17647-3-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1468973017-17647-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1468973017-17647-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Access to the interrupt page registers has been broken since at least
commit 3999e5d01da7 ("[media] adv7180: Do implicit register paging").
That commit forgot to add the interrupt page number to the register
defines.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Tested-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7180.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index b77b0a4..95cbc85 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -100,7 +100,7 @@
 #define ADV7180_REG_IDENT 0x0011
 #define ADV7180_ID_7180 0x18
 
-#define ADV7180_REG_ICONF1		0x0040
+#define ADV7180_REG_ICONF1		0x2040
 #define ADV7180_ICONF1_ACTIVE_LOW	0x01
 #define ADV7180_ICONF1_PSYNC_ONLY	0x10
 #define ADV7180_ICONF1_ACTIVE_TO_CLR	0xC0
@@ -113,15 +113,15 @@
 
 #define ADV7180_IRQ1_LOCK	0x01
 #define ADV7180_IRQ1_UNLOCK	0x02
-#define ADV7180_REG_ISR1	0x0042
-#define ADV7180_REG_ICR1	0x0043
-#define ADV7180_REG_IMR1	0x0044
-#define ADV7180_REG_IMR2	0x0048
+#define ADV7180_REG_ISR1	0x2042
+#define ADV7180_REG_ICR1	0x2043
+#define ADV7180_REG_IMR1	0x2044
+#define ADV7180_REG_IMR2	0x2048
 #define ADV7180_IRQ3_AD_CHANGE	0x08
-#define ADV7180_REG_ISR3	0x004A
-#define ADV7180_REG_ICR3	0x004B
-#define ADV7180_REG_IMR3	0x004C
-#define ADV7180_REG_IMR4	0x50
+#define ADV7180_REG_ISR3	0x204A
+#define ADV7180_REG_ICR3	0x204B
+#define ADV7180_REG_IMR3	0x204C
+#define ADV7180_REG_IMR4	0x2050
 
 #define ADV7180_REG_NTSC_V_BIT_END	0x00E6
 #define ADV7180_NTSC_V_BIT_END_MANUAL_NVEND	0x4F
-- 
1.9.1

