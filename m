Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57614 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933045Ab2JWPmx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 11:42:53 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: timo.ahonen@nokia.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/6] smiapp-pll: Correct type for min_t()
Date: Tue, 23 Oct 2012 18:42:45 +0300
Message-Id: <1351006971-32308-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20121023154231.GB23685@valkosipuli.retiisi.org.uk>
References: <20121023154231.GB23685@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unsigned.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp-pll.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 169f305..e92dc46 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -162,7 +162,7 @@ int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
 		more_mul_max);
 	/* Don't go above max pll op frequency. */
 	more_mul_max =
-		min_t(int,
+		min_t(uint32_t,
 		      more_mul_max,
 		      limits->max_pll_op_freq_hz
 		      / (pll->ext_clk_freq_hz / pll->pre_pll_clk_div * mul));
@@ -322,7 +322,7 @@ int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
 		for (sys_div = min_sys_div;
 		     sys_div <= max_sys_div;
 		     sys_div += 2 - (sys_div & 1)) {
-			int pix_div = DIV_ROUND_UP(vt_div, sys_div);
+			uint16_t pix_div = DIV_ROUND_UP(vt_div, sys_div);
 
 			if (pix_div < limits->min_vt_pix_clk_div
 			    || pix_div > limits->max_vt_pix_clk_div) {
-- 
1.7.2.5

