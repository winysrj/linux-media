Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36642 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbcGWRBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2016 13:01:07 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: lars@metafoo.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v3 9/9] media: adv7180: fix field type
Date: Sat, 23 Jul 2016 10:00:49 -0700
Message-Id: <1469293249-6774-10-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1469293249-6774-1-git-send-email-steve_longerbeam@mentor.com>
References: <1469293249-6774-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ADV7180 and ADV7182 transmit whole fields, bottom field followed
by top (or vice-versa, depending on detected video standard). So
for chips that do not have support for explicitly setting the field
mode, set the field mode to SEQ_BT for PAL, and SEQ_TB for NTSC (there
seems to be conflicting info on field order of PAL vs NTSC, so follow
what is in adv7183.c).

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

---

v3: no changes

v2:
- the init of state->curr_norm in probe needs to be moved up, ahead
  of the init of state->field.
---
 drivers/media/i2c/adv7180.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 6bcc652..3b8041e 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -718,10 +718,17 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 	switch (format->format.field) {
 	case V4L2_FIELD_NONE:
 		if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
-			format->format.field = V4L2_FIELD_INTERLACED;
+			format->format.field =
+				(state->curr_norm & V4L2_STD_525_60) ?
+				V4L2_FIELD_SEQ_TB : V4L2_FIELD_SEQ_BT;
 		break;
 	default:
-		format->format.field = V4L2_FIELD_INTERLACED;
+		if (state->chip_info->flags & ADV7180_FLAG_I2P)
+			format->format.field = V4L2_FIELD_INTERLACED;
+		else
+			format->format.field =
+				(state->curr_norm & V4L2_STD_525_60) ?
+				V4L2_FIELD_SEQ_TB : V4L2_FIELD_SEQ_BT;
 		break;
 	}
 
@@ -1365,8 +1372,14 @@ static int adv7180_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	state->client = client;
-	state->field = V4L2_FIELD_INTERLACED;
 	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
+	state->curr_norm = V4L2_STD_NTSC;
+
+	if (state->chip_info->flags & ADV7180_FLAG_I2P)
+		state->field = V4L2_FIELD_INTERLACED;
+	else
+		state->field = (state->curr_norm & V4L2_STD_525_60) ?
+			V4L2_FIELD_SEQ_TB : V4L2_FIELD_SEQ_BT;
 
 	adv7180_of_parse(state);
 
@@ -1396,7 +1409,6 @@ static int adv7180_probe(struct i2c_client *client,
 
 	state->irq = client->irq;
 	mutex_init(&state->mutex);
-	state->curr_norm = V4L2_STD_NTSC;
 	if (state->chip_info->flags & ADV7180_FLAG_RESET_POWERED)
 		state->powered = true;
 	else
-- 
1.9.1

