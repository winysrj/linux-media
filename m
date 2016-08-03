Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35297 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbcHCSEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 14:04:05 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: lars@metafoo.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v4 1/8] media: adv7180: fix field type
Date: Wed,  3 Aug 2016 11:03:43 -0700
Message-Id: <1470247430-11168-2-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
References: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Steve Longerbeam <slongerbeam@gmail.com>

The ADV7180 and ADV7182 transmit whole fields, bottom field followed
by top (or vice-versa, depending on detected video standard). So
for chips that do not have support for explicitly setting the field
mode via I2P, set the field mode to V4L2_FIELD_ALTERNATE.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

---

v4:
- switch V4L2_FIELD_SEQ_TB/V4L2_FIELD_SEQ_BT to V4L2_FIELD_ALTERNATE.
  This is from Niklas Söderlund.
- remove checks for ADV7180_FLAG_I2P when setting field mode, since I2P
  support is planned to be removed.
- move init of state->curr_norm back to its original location, since
  state->field init is no longer dependent on state->curr_norm.

v3: no changes

v2:
- the init of state->curr_norm in probe needs to be moved up, ahead
  of the init of state->field.
---
 drivers/media/i2c/adv7180.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 95cbc85..192eeae 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -679,10 +679,10 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 	switch (format->format.field) {
 	case V4L2_FIELD_NONE:
 		if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
-			format->format.field = V4L2_FIELD_INTERLACED;
+			format->format.field = V4L2_FIELD_ALTERNATE;
 		break;
 	default:
-		format->format.field = V4L2_FIELD_INTERLACED;
+		format->format.field = V4L2_FIELD_ALTERNATE;
 		break;
 	}
 
@@ -1251,7 +1251,7 @@ static int adv7180_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	state->client = client;
-	state->field = V4L2_FIELD_INTERLACED;
+	state->field = V4L2_FIELD_ALTERNATE;
 	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
 
 	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
-- 
1.9.1

