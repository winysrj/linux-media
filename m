Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7914 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543AbaDNJBA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:01:00 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 8044A209A1
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:56 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 17/21] smiapp-pll: Add pixel rate in pixel array as output parameters
Date: Mon, 14 Apr 2014 11:58:42 +0300
Message-Id: <1397465926-29724-18-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
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
index aca0ed7..25abf01 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -335,6 +335,7 @@ static int __smiapp_pll_calculate(struct device *dev,
 
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

