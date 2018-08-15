Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:32929 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbeHONUa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 09:20:30 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        steve_longerbeam@mentor.com, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH v3 2/2] media: ov5640: Fix timings setup code
Date: Wed, 15 Aug 2018 12:28:17 +0200
Message-Id: <1534328897-14957-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1534328897-14957-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1534328897-14957-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacopo Mondi <jacopo@jmondi.org>

As of:
commit 476dec012f4c ("media: ov5640: Add horizontal and vertical totals")
the timings parameters gets programmed separately from the static register
values array.

When changing capture mode, the vertical and horizontal totals gets inspected
by the set_mode_exposure_calc() functions, and only later programmed with the
new values. This means exposure, light banding filter and shutter gain are
calculated using the previous timings, and are thus not correct.

Fix this by programming timings right after the static register value table
has been sent to the sensor in the ov5640_load_regs() function.

Fixes: 476dec012f4c ("media: ov5640: Add horizontal and vertical totals")
Tested-by: Steve Longerbeam <slongerbeam@gmail.com>
on i.MX6q SabreSD with MIPI CSI-2 OV5640 module
Signed-off-by: Samuel Bobrowicz <sam@elite-embedded.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
---
 drivers/media/i2c/ov5640.c | 50 +++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 7bbd1d7..c81a2a7 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -908,6 +908,26 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
 }
 
 /* download ov5640 settings to sensor through i2c */
+static int ov5640_set_timings(struct ov5640_dev *sensor,
+			      const struct ov5640_mode_info *mode)
+{
+	int ret;
+
+	ret = ov5640_write_reg16(sensor, OV5640_REG_TIMING_DVPHO, mode->hact);
+	if (ret < 0)
+		return ret;
+
+	ret = ov5640_write_reg16(sensor, OV5640_REG_TIMING_DVPVO, mode->vact);
+	if (ret < 0)
+		return ret;
+
+	ret = ov5640_write_reg16(sensor, OV5640_REG_TIMING_HTS, mode->htot);
+	if (ret < 0)
+		return ret;
+
+	return ov5640_write_reg16(sensor, OV5640_REG_TIMING_VTS, mode->vtot);
+}
+
 static int ov5640_load_regs(struct ov5640_dev *sensor,
 			    const struct ov5640_mode_info *mode)
 {
@@ -935,7 +955,7 @@ static int ov5640_load_regs(struct ov5640_dev *sensor,
 			usleep_range(1000 * delay_ms, 1000 * delay_ms + 100);
 	}
 
-	return ret;
+	return ov5640_set_timings(sensor, mode);
 }
 
 /* read exposure, in number of line periods */
@@ -1391,30 +1411,6 @@ static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
 	return ov5640_write_reg(sensor, OV5640_REG_DEBUG_MODE, temp);
 }
 
-static int ov5640_set_timings(struct ov5640_dev *sensor,
-			      const struct ov5640_mode_info *mode)
-{
-	int ret;
-
-	ret = ov5640_write_reg16(sensor, OV5640_REG_TIMING_DVPHO, mode->hact);
-	if (ret < 0)
-		return ret;
-
-	ret = ov5640_write_reg16(sensor, OV5640_REG_TIMING_DVPVO, mode->vact);
-	if (ret < 0)
-		return ret;
-
-	ret = ov5640_write_reg16(sensor, OV5640_REG_TIMING_HTS, mode->htot);
-	if (ret < 0)
-		return ret;
-
-	ret = ov5640_write_reg16(sensor, OV5640_REG_TIMING_VTS, mode->vtot);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
 static const struct ov5640_mode_info *
 ov5640_find_mode(struct ov5640_dev *sensor, enum ov5640_frame_rate fr,
 		 int width, int height, bool nearest)
@@ -1658,10 +1654,6 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 	if (ret < 0)
 		return ret;
 
-	ret = ov5640_set_timings(sensor, mode);
-	if (ret < 0)
-		return ret;
-
 	ret = ov5640_set_binning(sensor, dn_mode != SCALING);
 	if (ret < 0)
 		return ret;
-- 
2.7.4
