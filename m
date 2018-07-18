Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56421 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730015AbeGRL4r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 07:56:47 -0400
From: Jacopo Mondi <jacopo@jmondi.org>
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        steve_longerbeam@mentor.com, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org
Cc: Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Subject: [PATCH 1/2] media: ov5640: Fix timings setup code
Date: Wed, 18 Jul 2018 13:19:02 +0200
Message-Id: <1531912743-24767-2-git-send-email-jacopo@jmondi.org>
In-Reply-To: <1531912743-24767-1-git-send-email-jacopo@jmondi.org>
References: <1531912743-24767-1-git-send-email-jacopo@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
Signed-off-by: Samuel Bobrowicz <sam@elite-embedded.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>

---
This fix has been circulating around for quite some time now, in Maxime clock
tree patches, in Sam dropbox patches and in my latest MIPI fixes patches.
While the rest of the series have not yet been accepted, there is general
consensus this is an actual fix that has to be collected.

I've slightly modified Sam's and Maxime's version I previously sent,
programming timings directly in ov5640_load_regs() function.
You can find Sam's previous version here:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg131654.html
and mine here, with an additional change that aimed to fix MIPI mode, which
I've left out in this version:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg133422.html

Sam, Maxime, I took the liberty of taking your Signed-off-by from the previous
patch, as this was spotted by you first. Is this ok with you?

Thanks
   j
---
---
 drivers/media/i2c/ov5640.c | 50 +++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 1ecbb7a..12b3496 100644
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
@@ -1385,30 +1405,6 @@ static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
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
@@ -1652,10 +1648,6 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
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
