Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50592 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752016AbaJBIrJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:47:09 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 11/18] smiapp-pll: Add pixel rate in pixel array as output parameters
Date: Thu,  2 Oct 2014 11:46:01 +0300
Message-Id: <1412239568-8524-12-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The actual pixel array pixel rate may be something else than vt_pix_clk_freq
on some implementations. Add a new field which contains the corrected value.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c |    1 +
 drivers/media/i2c/smiapp-pll.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 0d5c503..e40d902 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -391,6 +391,7 @@ static int __smiapp_pll_calculate(
 out_skip_vt_calc:
 	pll->pixel_rate_csi =
 		op_pll->pix_clk_freq_hz * lane_op_clock_ratio;
+	pll->pixel_rate_pixel_array = pll->vt.pix_clk_freq_hz;
 
 	return check_all_bounds(dev, limits, op_limits, pll, op_pll);
 }
diff --git a/drivers/media/i2c/smiapp-pll.h b/drivers/media/i2c/smiapp-pll.h
index b7c0e66..e8f035a 100644
--- a/drivers/media/i2c/smiapp-pll.h
+++ b/drivers/media/i2c/smiapp-pll.h
@@ -71,6 +71,7 @@ struct smiapp_pll {
 	struct smiapp_pll_branch op;
 
 	uint32_t pixel_rate_csi;
+	uint32_t pixel_rate_pixel_array;
 };
 
 struct smiapp_pll_branch_limits {
-- 
1.7.10.4

