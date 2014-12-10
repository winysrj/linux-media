Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40811 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933378AbaLJVQk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 16:16:40 -0500
Received: from lanttu.localdomain (lanttu.localdomain [192.168.5.64])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 74470600A1
	for <linux-media@vger.kernel.org>; Wed, 10 Dec 2014 23:16:35 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 6/7] smiapp: Replace pll_flags quirk with more generic init quirk
Date: Wed, 10 Dec 2014 23:16:19 +0200
Message-Id: <1418246180-667-7-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
References: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The pll_flags quirk just returned the extra PLL flags the sensor required,
but the init quirk is far more versatile. It can be used to perform any
extra initialisation needed by the sensor, including allocating memory for
sensor specific struct and creating sensor specific new controls.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c  |    5 ++++-
 drivers/media/i2c/smiapp/smiapp-quirk.c |    8 +++++---
 drivers/media/i2c/smiapp/smiapp-quirk.h |    4 ++++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index bacef3e..737da1e 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2697,7 +2697,6 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 	pll->bus_type = SMIAPP_PLL_BUS_TYPE_CSI2;
 	pll->csi2.lanes = sensor->platform_data->lanes;
 	pll->ext_clk_freq_hz = sensor->platform_data->ext_clk;
-	pll->flags = smiapp_call_quirk(sensor, pll_flags);
 	pll->scale_n = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
 	/* Profile 0 sensors have no separate OP clock branch. */
 	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
@@ -2772,6 +2771,10 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 	if (rval < 0)
 		goto out_cleanup;
 
+	rval = smiapp_call_quirk(sensor, init);
+	if (rval)
+		goto out_cleanup;
+
 	rval = smiapp_get_mbus_formats(sensor);
 	if (rval) {
 		rval = -ENODEV;
diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.c b/drivers/media/i2c/smiapp/smiapp-quirk.c
index dd4ae6f..abf9ea7 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.c
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.c
@@ -214,9 +214,11 @@ static int jt8ev1_post_streamoff(struct smiapp_sensor *sensor)
 	return smiapp_write_8(sensor, 0x3328, 0x80);
 }
 
-static unsigned long jt8ev1_pll_flags(struct smiapp_sensor *sensor)
+static int jt8ev1_init(struct smiapp_sensor *sensor)
 {
-	return SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE;
+	sensor->pll.flags |= SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE;
+
+	return 0;
 }
 
 const struct smiapp_quirk smiapp_jt8ev1_quirk = {
@@ -224,7 +226,7 @@ const struct smiapp_quirk smiapp_jt8ev1_quirk = {
 	.post_poweron = jt8ev1_post_poweron,
 	.pre_streamon = jt8ev1_pre_streamon,
 	.post_streamoff = jt8ev1_post_streamoff,
-	.pll_flags = jt8ev1_pll_flags,
+	.init = jt8ev1_init,
 };
 
 static int tcm8500md_limits(struct smiapp_sensor *sensor)
diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.h b/drivers/media/i2c/smiapp/smiapp-quirk.h
index 3a3c3e5..a24eb43 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.h
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.h
@@ -29,6 +29,9 @@ struct smiapp_sensor;
  * @post_poweron: Called always after the sensor has been fully powered on.
  * @pre_streamon: Called just before streaming is enabled.
  * @post_streamon: Called right after stopping streaming.
+ * @pll_flags: Return flags for the PLL calculator.
+ * @init: Quirk initialisation, called the last in probe(). This is
+ *	  also appropriate for adding sensor specific controls, for instance.
  * @reg_access: Register access quirk. The quirk may divert the access
  *		to another register, or no register at all.
  *
@@ -47,6 +50,7 @@ struct smiapp_quirk {
 	int (*pre_streamon)(struct smiapp_sensor *sensor);
 	int (*post_streamoff)(struct smiapp_sensor *sensor);
 	unsigned long (*pll_flags)(struct smiapp_sensor *sensor);
+	int (*init)(struct smiapp_sensor *sensor);
 	int (*reg_access)(struct smiapp_sensor *sensor, bool write, u32 *reg,
 			  u32 *val);
 	unsigned long flags;
-- 
1.7.10.4

