Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.cvg.de ([62.153.82.30]:59094 "EHLO mail.cvg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161028AbbBDRvX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 12:51:23 -0500
From: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
To: linux-media@vger.kernel.org
Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2] [media] mt9p031: fixed calculation of clk_div
Date: Wed,  4 Feb 2015 18:51:10 +0100
Message-Id: <1423072270-20078-1-git-send-email-enrico.scholz@sigma-chemnitz.de>
In-Reply-To: <1423061612-12623-1-git-send-email-enrico.scholz@sigma-chemnitz.de>
References: <1423061612-12623-1-git-send-email-enrico.scholz@sigma-chemnitz.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There must be used 'min_t', not 'max_t' for calculating the divider.

Signed-off-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9p031.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 0cabf91..43ee299 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -254,7 +254,7 @@ static int mt9p031_clk_setup(struct mt9p031 *mt9p031)
 		div = DIV_ROUND_UP(ext_freq, pdata->target_freq);
 		div = roundup_pow_of_two(div) / 2;
 
-		mt9p031->clk_div = max_t(unsigned int, div, 64);
+		mt9p031->clk_div = min_t(unsigned int, div, 64);
 		mt9p031->use_pll = false;
 
 		return 0;
-- 
2.1.0

