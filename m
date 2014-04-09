Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50025 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934335AbaDITZA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 15:25:00 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id CC31720DF4
	for <linux-media@vger.kernel.org>; Wed,  9 Apr 2014 22:24:54 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 13/17] smiapp-pll: Add pixel rate in pixel array as output parameters
Date: Wed,  9 Apr 2014 22:25:05 +0300
Message-Id: <1397071509-2071-14-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The actual pixel array pixel rate may be something else than vt_pix_clk_freq
on some implementations. Add a new field which contains the corrected value.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c | 1 +
 drivers/media/i2c/smiapp-pll.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 9d06a33..a83597e 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -334,6 +334,7 @@ static int __smiapp_pll_calculate(struct device *dev,
 
 	pll->pixel_rate_csi =
 		pll->op_pix_clk_freq_hz * lane_op_clock_ratio;
+	pll->pixel_rate_pixel_array = pll->vt_pix_clk_freq_hz;
 
 	rval = bounds_check(dev, pll->pll_ip_clk_freq_hz,
 			    limits->min_pll_ip_freq_hz,
diff --git a/drivers/media/i2c/smiapp-pll.h b/drivers/media/i2c/smiapp-pll.h
index 02d11db..c6ad809 100644
--- a/drivers/media/i2c/smiapp-pll.h
+++ b/drivers/media/i2c/smiapp-pll.h
@@ -75,6 +75,7 @@ struct smiapp_pll {
 	uint32_t vt_pix_clk_freq_hz;
 
 	uint32_t pixel_rate_csi;
+	uint32_t pixel_rate_pixel_array;
 };
 
 struct smiapp_pll_branch_limits {
-- 
1.8.3.2

