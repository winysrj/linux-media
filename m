Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:54325 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbeINVOF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 17:14:05 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        steve_longerbeam@mentor.com, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH v4 2/2] media: ov5640: Fix timings setup code
Date: Fri, 14 Sep 2018 17:58:41 +0200
Message-Id: <1536940721-25802-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1536940721-25802-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1536940721-25802-1-git-send-email-jacopo+renesas@jmondi.org>
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
Tested-by: Loic Poulain <loic.poulain@linaro.org>
on Dragonboard-410c with MIPI CSI-2 OV5640 module
Signed-off-by: Samuel Bobrowicz <sam@elite-embedded.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
---
 drivers/media/i2c/ov5640.c | 50 +++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 7ade416..2b9e84f 100644
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
@@ -1398,30 +1418,6 @@ static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
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
@@ -1665,10 +1661,6 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
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
