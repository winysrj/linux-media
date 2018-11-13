Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51192 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733152AbeKMXBv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 18:01:51 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v5 05/11] media: ov5640: Compute the clock rate at runtime
Date: Tue, 13 Nov 2018 14:03:19 +0100
Message-Id: <20181113130325.28975-6-maxime.ripard@bootlin.com>
In-Reply-To: <20181113130325.28975-1-maxime.ripard@bootlin.com>
References: <20181113130325.28975-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clock rate, while hardcoded until now, is actually a function of the
resolution, framerate and bytes per pixel. Now that we have an algorithm to
adjust our clock rate, we can select it dynamically when we change the
mode.

This changes a bit the clock rate being used, with the following effect:

+------+------+------+------+-----+-----------------+----------------+-----------+
| Hact | Vact | Htot | Vtot | FPS | Hardcoded clock | Computed clock | Deviation |
+------+------+------+------+-----+-----------------+----------------+-----------+
|  640 |  480 | 1896 | 1080 |  15 |        56000000 |       61430400 | 8.84 %    |
|  640 |  480 | 1896 | 1080 |  30 |       112000000 |      122860800 | 8.84 %    |
| 1024 |  768 | 1896 | 1080 |  15 |        56000000 |       61430400 | 8.84 %    |
| 1024 |  768 | 1896 | 1080 |  30 |       112000000 |      122860800 | 8.84 %    |
|  320 |  240 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
|  320 |  240 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
|  176 |  144 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
|  176 |  144 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
|  720 |  480 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
|  720 |  480 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
|  720 |  576 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
|  720 |  576 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
| 1280 |  720 | 1892 |  740 |  15 |        42000000 |       42002400 | 0.01 %    |
| 1280 |  720 | 1892 |  740 |  30 |        84000000 |       84004800 | 0.01 %    |
| 1920 | 1080 | 2500 | 1120 |  15 |        84000000 |       84000000 | 0.00 %    |
| 1920 | 1080 | 2500 | 1120 |  30 |       168000000 |      168000000 | 0.00 %    |
| 2592 | 1944 | 2844 | 1944 |  15 |        84000000 |      165862080 | 49.36 %   |
+------+------+------+------+-----+-----------------+----------------+-----------+

Only the 640x480, 1024x768 and 2592x1944 modes are significantly affected
by the new formula.

In this case, 640x480 and 1024x768 are actually fixed by this change.
Indeed, the sensor was sending data at, for example, 27.33fps instead of
30fps. This is -9%, which is roughly what we're seeing in the array.
Testing these modes with the new clock setup actually fix that error, and
data are now sent at around 30fps.

2592x1944, on the other hand, is probably due to the fact that this mode
can only be used using MIPI-CSI2, in a two lane mode, and never really
tested with a DVP bus.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 25613ecf83c5..bcfb2b25a450 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1992,7 +1992,8 @@ static int ov5640_set_mode(struct ov5640_dev *sensor)
 	 * All the formats we support have 16 bits per pixel, seems to require
 	 * the same rate than YUV, so we can just use 16 bpp all the time.
 	 */
-	rate = mode->pixel_clock * 16;
+	rate = mode->vtot * mode->htot * 16;
+	rate *= ov5640_framerates[sensor->current_fr];
 	if (sensor->ep.bus_type == V4L2_MBUS_CSI2_DPHY) {
 		rate = rate / sensor->ep.bus.mipi_csi2.num_data_lanes;
 		ret = ov5640_set_mipi_pclk(sensor, rate);
-- 
2.19.1
