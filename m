Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33307 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab2CJCwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 21:52:13 -0500
Received: by vcqp1 with SMTP id p1so2054513vcq.19
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2012 18:52:13 -0800 (PST)
From: Andrew Miller <amiller@amilx.com>
To: linux-media@vger.kernel.org
Cc: amiller@amilx.com, devel@driverdev.osuosl.org
Subject: [PATCH] Staging: media: solo6x10: core.c Fix some coding style issue
Date: Fri,  9 Mar 2012 21:51:01 -0500
Message-Id: <1331347861-9747-1-git-send-email-amiller@amilx.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replaced spaces with tabs

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/media/solo6x10/core.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/media/solo6x10/core.c b/drivers/staging/media/solo6x10/core.c
index f974f64..d2fd842 100644
--- a/drivers/staging/media/solo6x10/core.c
+++ b/drivers/staging/media/solo6x10/core.c
@@ -195,28 +195,28 @@ static int __devinit solo_pci_probe(struct pci_dev *pdev,
 			SOLO6010_SYS_CFG_OUTDIV(3);
 	solo_reg_write(solo_dev, SOLO_SYS_CFG, reg);
 
-        if (solo_dev->flags & FLAGS_6110) {
-                u32 sys_clock_MHz = SOLO_CLOCK_MHZ;
-                u32 pll_DIVQ;
-                u32 pll_DIVF;
-
-                if (sys_clock_MHz < 125) {
-                        pll_DIVQ = 3;
-                        pll_DIVF = (sys_clock_MHz * 4) / 3;
-                } else {
-                        pll_DIVQ = 2;
-                        pll_DIVF = (sys_clock_MHz * 2) / 3;
-                }
-
-                solo_reg_write(solo_dev, SOLO6110_PLL_CONFIG,
+	if (solo_dev->flags & FLAGS_6110) {
+		u32 sys_clock_MHz = SOLO_CLOCK_MHZ;
+		u32 pll_DIVQ;
+		u32 pll_DIVF;
+
+		if (sys_clock_MHz < 125) {
+			pll_DIVQ = 3;
+			pll_DIVF = (sys_clock_MHz * 4) / 3;
+		} else {
+			pll_DIVQ = 2;
+			pll_DIVF = (sys_clock_MHz * 2) / 3;
+		}
+
+		solo_reg_write(solo_dev, SOLO6110_PLL_CONFIG,
 			       SOLO6110_PLL_RANGE_5_10MHZ |
 			       SOLO6110_PLL_DIVR(9) |
 			       SOLO6110_PLL_DIVQ_EXP(pll_DIVQ) |
 			       SOLO6110_PLL_DIVF(pll_DIVF) | SOLO6110_PLL_FSEN);
-		mdelay(1);      // PLL Locking time (1ms)
+		mdelay(1);      /* PLL Locking time (1ms) */
 
 		solo_reg_write(solo_dev, SOLO_DMA_CTRL1, 3 << 8); /* ? */
-        } else
+	} else
 		solo_reg_write(solo_dev, SOLO_DMA_CTRL1, 1 << 8); /* ? */
 
 	solo_reg_write(solo_dev, SOLO_TIMER_CLOCK_NUM, SOLO_CLOCK_MHZ - 1);
-- 
1.7.7.6

