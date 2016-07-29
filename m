Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:41747 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbcG2Rki (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2016 13:40:38 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 6/6] media: adv7180: fix field type
Date: Fri, 29 Jul 2016 19:40:12 +0200
Message-Id: <20160729174012.14331-7-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Steve Longerbeam <slongerbeam@gmail.com>

The ADV7180 and ADV7182 transmit whole fields, bottom field followed
by top (or vice-versa, depending on detected video standard). So
for chips that do not have support for explicitly setting the field
mode, set the field mode to V4L2_FIELD_ALTERNATE.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
[Niklas: changed filed type from V4L2_FIELD_SEQ_{TB,BT} to
V4L2_FIELD_ALTERNATE]
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv7180.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index a8b434b..c6fed71 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -680,10 +680,13 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 	switch (format->format.field) {
 	case V4L2_FIELD_NONE:
 		if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
-			format->format.field = V4L2_FIELD_INTERLACED;
+			format->format.field = V4L2_FIELD_ALTERNATE;
 		break;
 	default:
-		format->format.field = V4L2_FIELD_INTERLACED;
+		if (state->chip_info->flags & ADV7180_FLAG_I2P)
+			format->format.field = V4L2_FIELD_INTERLACED;
+		else
+			format->format.field = V4L2_FIELD_ALTERNATE;
 		break;
 	}
 
@@ -1253,8 +1256,13 @@ static int adv7180_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	state->client = client;
-	state->field = V4L2_FIELD_INTERLACED;
 	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
+	state->curr_norm = V4L2_STD_NTSC;
+
+	if (state->chip_info->flags & ADV7180_FLAG_I2P)
+		state->field = V4L2_FIELD_INTERLACED;
+	else
+		state->field = V4L2_FIELD_ALTERNATE;
 
 	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
 		state->csi_client = i2c_new_dummy(client->adapter,
@@ -1274,7 +1282,6 @@ static int adv7180_probe(struct i2c_client *client,
 
 	state->irq = client->irq;
 	mutex_init(&state->mutex);
-	state->curr_norm = V4L2_STD_NTSC;
 	if (state->chip_info->flags & ADV7180_FLAG_RESET_POWERED)
 		state->powered = true;
 	else
-- 
2.9.0

