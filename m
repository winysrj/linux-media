Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43866 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751319AbeEQIyK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:54:10 -0400
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
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v3 06/12] media: ov5640: Compute the clock rate at runtime
Date: Thu, 17 May 2018 10:53:59 +0200
Message-Id: <20180517085405.10104-7-maxime.ripard@bootlin.com>
In-Reply-To: <20180517085405.10104-1-maxime.ripard@bootlin.com>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
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
index 77864a1a5eb0..e9bd0aa55409 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1886,7 +1886,8 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 	 * which is 8 bits per pixel.
 	 */
 	bpp = sensor->fmt.code == MEDIA_BUS_FMT_JPEG_1X8 ? 8 : 16;
-	rate = mode->pixel_clock * bpp;
+	rate = mode->vtot * mode->htot * bpp;
+	rate *= ov5640_framerates[sensor->current_fr];
 	if (sensor->ep.bus_type == V4L2_MBUS_CSI2) {
 		rate = rate / sensor->ep.bus.mipi_csi2.num_data_lanes;
 		ret = ov5640_set_mipi_pclk(sensor, rate);
-- 
2.17.0
