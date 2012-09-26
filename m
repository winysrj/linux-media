Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47851 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab2IZJsT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 05:48:19 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so481354wib.1
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 02:48:19 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, mchehab@infradead.org, hverkuil@xs4all.nl,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 4/5] media: ov7670: add possibility to bypass pll for ov7675.
Date: Wed, 26 Sep 2012 11:47:56 +0200
Message-Id: <1348652877-25816-5-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/i2c/ov7670.c |   24 ++++++++++++++++++++++--
 include/media/ov7670.h     |    1 +
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 175fbfc..54fb535 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -210,6 +210,7 @@ struct ov7670_info {
 	int clock_speed;		/* External clock speed (MHz) */
 	u8 clkrc;			/* Clock divider value */
 	bool use_smbus;			/* Use smbus I/O instead of I2C */
+	bool pll_bypass;
 	enum ov7670_model model;
 };
 
@@ -778,7 +779,12 @@ static void ov7670_get_framerate(struct v4l2_subdev *sd,
 {
 	struct ov7670_info *info = to_state(sd);
 	u32 clkrc = info->clkrc;
-	u32 pll_factor = PLL_FACTOR;
+	int pll_factor;
+
+	if (info->pll_bypass)
+		pll_factor = 1;
+	else
+		pll_factor = PLL_FACTOR;
 
 	clkrc++;
 	if (info->fmt->mbus_code == V4L2_MBUS_FMT_SBGGR8_1X8)
@@ -794,7 +800,7 @@ static int ov7670_set_framerate(struct v4l2_subdev *sd,
 {
 	struct ov7670_info *info = to_state(sd);
 	u32 clkrc;
-	u32 pll_factor = PLL_FACTOR;
+	int pll_factor;
 	int ret;
 
 	/*
@@ -804,6 +810,16 @@ static int ov7670_set_framerate(struct v4l2_subdev *sd,
 	 * pixclk = clock_speed / (clkrc + 1) * PLLfactor
 	 *
 	 */
+	if (info->pll_bypass) {
+		pll_factor = 1;
+		ret = ov7670_write(sd, REG_DBLV, DBLV_BYPASS);
+	} else {
+		pll_factor = PLL_FACTOR;
+		ret = ov7670_write(sd, REG_DBLV, DBLV_X4);
+	}
+	if (ret < 0)
+		return ret;
+
 	if (tpf->numerator == 0 || tpf->denominator == 0) {
 		clkrc = 0;
 	} else {
@@ -831,6 +847,7 @@ static int ov7670_set_framerate(struct v4l2_subdev *sd,
 	ret = ov7670_write(sd, REG_CLKRC, info->clkrc);
 	if (ret < 0)
 		return ret;
+
 	return ov7670_write(sd, REG_DBLV, DBLV_X4);
 }
 
@@ -1689,6 +1706,9 @@ static int ov7670_probe(struct i2c_client *client,
 
 		if (config->clock_speed)
 			info->clock_speed = config->clock_speed;
+
+		if (config->pll_bypass && id->driver_data != MODEL_OV7670)
+			info->pll_bypass = true;
 	}
 
 	/* Make sure it's an ov7670 */
diff --git a/include/media/ov7670.h b/include/media/ov7670.h
index b133bc1..a68c8bb 100644
--- a/include/media/ov7670.h
+++ b/include/media/ov7670.h
@@ -15,6 +15,7 @@ struct ov7670_config {
 	int min_height;			/* Filter out smaller sizes */
 	int clock_speed;		/* External clock speed (MHz) */
 	bool use_smbus;			/* Use smbus I/O instead of I2C */
+	bool pll_bypass;		/* Choose whether to bypass the PLL */
 };
 
 #endif
-- 
1.7.9.5

