Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50538 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751400AbaJBIqm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:46:42 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 08/18] smiapp-pll: Don't validate OP clocks if there are none
Date: Thu,  2 Oct 2014 11:45:58 +0300
Message-Id: <1412239568-8524-9-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

For profile 0 sensors (which have no OP clocks), the OP limits are in fact
VT limits. Do not verify them again.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index cac1407..862ca0c 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -131,6 +131,14 @@ static int check_all_bounds(struct device *dev,
 			op_limits->min_pix_clk_freq_hz,
 			op_limits->max_pix_clk_freq_hz,
 			"op_pix_clk_freq_hz");
+
+	/*
+	 * If there are no OP clocks, the VT clocks are contained in
+	 * the OP clock struct.
+	 */
+	if (pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS)
+		return rval;
+
 	if (!rval)
 		rval = bounds_check(
 			dev, pll->vt.sys_clk_freq_hz,
-- 
1.7.10.4

