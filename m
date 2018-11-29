Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay12.mail.gandi.net ([217.70.178.232]:45231 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731628AbeK3Byh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 20:54:37 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: maxime.ripard@bootlin.com, sam@elite-embedded.com,
        slongerbeam@gmail.com, mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, linux-media@vger.kernel.org,
        hugues.fruchet@st.com, loic.poulain@linaro.org, daniel@zonque.org,
        aford173@gmail.com
Subject: [PATCH 1/2] media: ov5640: Fix set format regression
Date: Thu, 29 Nov 2018 15:48:35 +0100
Message-Id: <1543502916-21632-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1543502916-21632-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1543502916-21632-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
---
 drivers/media/i2c/ov5640.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 03a031a42b3e..c659efe918a4 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2160,6 +2160,7 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
 	struct ov5640_dev *sensor = to_ov5640_dev(sd);
 	const struct ov5640_mode_info *new_mode;
 	struct v4l2_mbus_framefmt *mbus_fmt = &format->format;
+	struct v4l2_mbus_framefmt *fmt;
 	int ret;

 	if (format->pad != 0)
@@ -2177,22 +2178,20 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
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
2.7.4
