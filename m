Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33128 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbcDXVKS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:18 -0400
Received: by mail-wm0-f66.google.com with SMTP id r12so17687915wme.0
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:18 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: [RFC PATCH 04/24] smiapp-pll: Take existing divisor into account in minimum divisor check
Date: Mon, 25 Apr 2016 00:08:04 +0300
Message-Id: <1461532104-24032-5-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Required added multiplier (and divisor) calculation did not take into
account the existing divisor when checking the values against the minimum
divisor. Do just that.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp-pll.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index e3348db..5ad1edb 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -227,7 +227,8 @@ static int __smiapp_pll_calculate(
 
 	more_mul_factor = lcm(div, pll->pre_pll_clk_div) / div;
 	dev_dbg(dev, "more_mul_factor: %u\n", more_mul_factor);
-	more_mul_factor = lcm(more_mul_factor, op_limits->min_sys_clk_div);
+	more_mul_factor = lcm(more_mul_factor,
+			      DIV_ROUND_UP(op_limits->min_sys_clk_div, div));
 	dev_dbg(dev, "more_mul_factor: min_op_sys_clk_div: %d\n",
 		more_mul_factor);
 	i = roundup(more_mul_min, more_mul_factor);
-- 
1.9.1

