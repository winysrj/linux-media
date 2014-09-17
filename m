Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55060 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755801AbaIQUpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 16:45:34 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id B3EF0600A4
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 23:45:30 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 06/17] smiapp-pll: Don't validate OP clocks if there are none
Date: Wed, 17 Sep 2014 23:45:30 +0300
Message-Id: <1410986741-6801-7-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
References: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Profile 0 sensors have no OP clocks, don't validate them.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 40a18ba..f83f25f 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -129,6 +129,14 @@ static int check_all_bounds(struct device *dev,
 			limits->op.min_pix_clk_freq_hz,
 			limits->op.max_pix_clk_freq_hz,
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

