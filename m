Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:41738 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbcG2Rkh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2016 13:40:37 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 5/6] media: adv7180: fill in mbus format in set_fmt
Date: Fri, 29 Jul 2016 19:40:11 +0200
Message-Id: <20160729174012.14331-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the V4L2_SUBDEV_FORMAT_TRY is used in set_fmt the width, height etc
would not be filled.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv7180.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index b77b0a4..a8b434b 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -675,6 +675,7 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 {
 	struct adv7180_state *state = to_state(sd);
 	struct v4l2_mbus_framefmt *framefmt;
+	int ret;
 
 	switch (format->format.field) {
 	case V4L2_FIELD_NONE:
@@ -686,8 +687,9 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 		break;
 	}
 
+	ret = adv7180_mbus_fmt(sd,  &format->format);
+
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
-		framefmt = &format->format;
 		if (state->field != format->format.field) {
 			state->field = format->format.field;
 			adv7180_set_power(state, false);
@@ -699,7 +701,7 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 		*framefmt = format->format;
 	}
 
-	return adv7180_mbus_fmt(sd, framefmt);
+	return ret;
 }
 
 static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
-- 
2.9.0

