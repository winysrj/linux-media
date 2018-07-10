Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:44845 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389946AbeGJSgn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 14:36:43 -0400
From: Jacopo Mondi <jacopo@jmondi.org>
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        steve_longerbeam@mentor.com, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org
Cc: Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Subject: [PATCH v2 2/2] media: ov5640: Fix timings setup code
Date: Tue, 10 Jul 2018 20:36:08 +0200
Message-Id: <1531247768-15362-3-git-send-email-jacopo@jmondi.org>
In-Reply-To: <1531247768-15362-1-git-send-email-jacopo@jmondi.org>
References: <1531247768-15362-1-git-send-email-jacopo@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Samuel Bobrowicz <sam@elite-embedded.com>

The current code, when changing the mode and changing the scaling or
sampling parameters, will look at the horizontal and vertical total size,
which, since 5999f381e023 ("media: ov5640: Add horizontal and vertical
totals") has been moved from the static register initialization to after
the mode change.

That means that the values are no longer set up before the code retrieves
them, which is obviously a bug.

In addition, restore timings settings in the initial configuration register
blob only, to have MIPI capture operations work again.

Fixes: 5999f381e023 ("media: ov5640: Add horizontal and vertical totals")
Signed-off-by: Samuel Bobrowicz <sam@elite-embedded.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
[re-introduce timing parameters in initial configuration blob]
Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>

---
Compared to Maxime's and Sam's original version, this one re-introduces timing
configuration parameters in the init_settings configuration blob.

On my testing platform this fixes MIPI capture operations, that with the
original patch version applied was failing anyway.

Thanks
   j
---
 drivers/media/i2c/ov5640.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 7bbd1d7..bbcb908 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -277,7 +277,9 @@ static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
-	{0x3810, 0x00, 0, 0},
+	{0x3808, 0x02, 0, 0}, {0x3809, 0x80, 0, 0}, {0x380a, 0x01, 0, 0},
+	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
+	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -1484,6 +1486,10 @@ static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
 	if (ret < 0)
 		return ret;

+	ret = ov5640_set_timings(sensor, mode);
+	if (ret < 0)
+		return ret;
+
 	/* read capture VTS */
 	ret = ov5640_get_vts(sensor);
 	if (ret < 0)
@@ -1611,6 +1617,10 @@ static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
 	if (ret < 0)
 		return ret;

+	ret = ov5640_set_timings(sensor, mode);
+	if (ret < 0)
+		return ret;
+
 	/* turn auto gain/exposure back on for direct mode */
 	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 1);
 	if (ret)
@@ -1658,10 +1668,6 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
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
