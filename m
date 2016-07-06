Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36394 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbcGFXNh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:13:37 -0400
Received: by mail-pf0-f195.google.com with SMTP id i123so105333pfg.3
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:13:36 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 11/11] media: adv7180: fix field type
Date: Wed,  6 Jul 2016 16:00:04 -0700
Message-Id: <1467846004-12731-12-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
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
 drivers/media/i2c/adv7180.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 4c2623f..c12fca7 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -743,10 +743,17 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
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
 
@@ -1416,9 +1423,14 @@ static int adv7180_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	state->client = client;
-	state->field = V4L2_FIELD_INTERLACED;
 	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
 
+	if (state->chip_info->flags & ADV7180_FLAG_I2P)
+		state->field = V4L2_FIELD_INTERLACED;
+	else
+		state->field = (state->curr_norm & V4L2_STD_525_60) ?
+			V4L2_FIELD_SEQ_TB : V4L2_FIELD_SEQ_BT;
+
 	ret = adv7180_of_parse(state);
 	if (ret)
 		return ret;
-- 
1.9.1

