Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:61522 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731256AbeGQNKN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 09:10:13 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 1/2] adv7180: fix field type to V4L2_FIELD_ALTERNATE
Date: Tue, 17 Jul 2018 14:30:40 +0200
Message-Id: <20180717123041.2862-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180717123041.2862-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180717123041.2862-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ADV7180 and ADV7182 transmit whole fields, bottom field followed
by top (or vice-versa, depending on detected video standard). So
for chips that do not have support for explicitly setting the field
mode via I2P, set the field mode to V4L2_FIELD_ALTERNATE.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv7180.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 25d24a3f10a7cb4d..c2e24132e8c21d38 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -644,6 +644,9 @@ static int adv7180_mbus_fmt(struct v4l2_subdev *sd,
 	fmt->width = 720;
 	fmt->height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
 
+	if (state->field == V4L2_FIELD_ALTERNATE)
+		fmt->height /= 2;
+
 	return 0;
 }
 
@@ -711,11 +714,11 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 
 	switch (format->format.field) {
 	case V4L2_FIELD_NONE:
-		if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
-			format->format.field = V4L2_FIELD_INTERLACED;
-		break;
+		if (state->chip_info->flags & ADV7180_FLAG_I2P)
+			break;
+		/* fall through */
 	default:
-		format->format.field = V4L2_FIELD_INTERLACED;
+		format->format.field = V4L2_FIELD_ALTERNATE;
 		break;
 	}
 
@@ -1291,7 +1294,7 @@ static int adv7180_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	state->client = client;
-	state->field = V4L2_FIELD_INTERLACED;
+	state->field = V4L2_FIELD_ALTERNATE;
 	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
 
 	state->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "powerdown",
-- 
2.18.0
