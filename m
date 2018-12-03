Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51373 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbeLCIoo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 03:44:44 -0500
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
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: [PATCH v6 01/12] media: ov5640: Fix set format regression
Date: Mon,  3 Dec 2018 09:44:16 +0100
Message-Id: <445b7d9c5d6b62f3f2b00fcbe97bcf65865f7200.1543826654.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
References: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

The set_fmt operations updates the sensor format only when the image format
is changed. When only the image sizes gets changed, the format do not get
updated causing the sensor to always report the one that was previously in
use.

Without this patch, updating frame size only fails:
  [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb xfer:srgb ...]

With this patch applied:
  [fmt:UYVY8_2X8/1024x768@1/30 field:none colorspace:srgb xfer:srgb ...]

Fixes: 6949d864776e ("media: ov5640: do not change mode if format or frame
interval is unchanged")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index a91d91715d00..807bd0e386a4 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2021,6 +2021,7 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
 	struct ov5640_dev *sensor = to_ov5640_dev(sd);
 	const struct ov5640_mode_info *new_mode;
 	struct v4l2_mbus_framefmt *mbus_fmt = &format->format;
+	struct v4l2_mbus_framefmt *fmt;
 	int ret;
 
 	if (format->pad != 0)
@@ -2038,22 +2039,20 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
 	if (ret)
 		goto out;
 
-	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
-		struct v4l2_mbus_framefmt *fmt =
-			v4l2_subdev_get_try_format(sd, cfg, 0);
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
+		fmt = v4l2_subdev_get_try_format(sd, cfg, 0);
+	else
+		fmt = &sensor->fmt;
 
-		*fmt = *mbus_fmt;
-		goto out;
-	}
+	*fmt = *mbus_fmt;
 
 	if (new_mode != sensor->current_mode) {
 		sensor->current_mode = new_mode;
 		sensor->pending_mode_change = true;
 	}
-	if (mbus_fmt->code != sensor->fmt.code) {
-		sensor->fmt = *mbus_fmt;
+	if (mbus_fmt->code != sensor->fmt.code)
 		sensor->pending_fmt_change = true;
-	}
+
 out:
 	mutex_unlock(&sensor->lock);
 	return ret;
-- 
git-series 0.9.1
