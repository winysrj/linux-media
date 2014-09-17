Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55067 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756266AbaIQUpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 16:45:34 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 29C3A600AB
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 23:45:32 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 13/17] smiapp: Split calculating PLL with sensor's limits from updating it
Date: Wed, 17 Sep 2014 23:45:37 +0300
Message-Id: <1410986741-6801-14-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
References: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The first one is handy for just trying out a PLL configuration without a
need to apply it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 346ff5b..a1244e6 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -240,7 +240,8 @@ static int smiapp_pll_configure(struct smiapp_sensor *sensor)
 		sensor, SMIAPP_REG_U16_OP_SYS_CLK_DIV, pll->op.sys_clk_div);
 }
 
-static int smiapp_pll_update(struct smiapp_sensor *sensor)
+static int smiapp_pll_try(struct smiapp_sensor *sensor,
+			  struct smiapp_pll *pll)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	struct smiapp_pll_limits lim = {
@@ -274,6 +275,12 @@ static int smiapp_pll_update(struct smiapp_sensor *sensor)
 		.min_line_length_pck_bin = sensor->limits[SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK_BIN],
 		.min_line_length_pck = sensor->limits[SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK],
 	};
+
+	return smiapp_pll_calculate(&client->dev, &lim, pll);
+}
+
+static int smiapp_pll_update(struct smiapp_sensor *sensor)
+{
 	struct smiapp_pll *pll = &sensor->pll;
 	int rval;
 
@@ -284,7 +291,7 @@ static int smiapp_pll_update(struct smiapp_sensor *sensor)
 	pll->scale_m = sensor->scale_m;
 	pll->bits_per_pixel = sensor->csi_format->compressed;
 
-	rval = smiapp_pll_calculate(&client->dev, &lim, pll);
+	rval = smiapp_pll_try(sensor, pll);
 	if (rval < 0)
 		return rval;
 
-- 
1.7.10.4

