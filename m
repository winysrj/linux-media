Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10975 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933750AbcKPJFY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 04:05:24 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 3/9] s5p-mfc: Remove special clock rate management
Date: Wed, 16 Nov 2016 10:04:52 +0100
Message-id: <1479287098-30493-4-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
References: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161116090519eucas1p11aa58cad47673b61c9e077d4fcd29d0d@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The maximum rate of special clock depends on SoC variant and should be set
in device tree via assigned-clock-rates property, so remove the code which
forces special clock to 200MHz.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index b5806ab7ac31..818c04646061 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -20,7 +20,6 @@
 
 #define MFC_GATE_CLK_NAME	"mfc"
 #define MFC_SCLK_NAME		"sclk_mfc"
-#define MFC_SCLK_RATE		(200 * 1000000)
 
 #define CLK_DEBUG
 
@@ -57,7 +56,6 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 			mfc_info("Failed to get MFC special clock control\n");
 			pm->clock = NULL;
 		} else {
-			clk_set_rate(pm->clock, MFC_SCLK_RATE);
 			ret = clk_prepare_enable(pm->clock);
 			if (ret) {
 				mfc_err("Failed to enable MFC special clock\n");
-- 
1.9.1

