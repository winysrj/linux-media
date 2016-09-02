Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:32869 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932887AbcIBQqz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2016 12:46:55 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, hans.verkuil@cisco.com
Cc: slongerbeam@gmail.com, lars@metafoo.de, mchehab@kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv3 1/6] media: adv7180: fill in mbus format in set_fmt
Date: Fri,  2 Sep 2016 18:44:56 +0200
Message-Id: <20160902164501.19535-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160902164501.19535-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160902164501.19535-1-niklas.soderlund+renesas@ragnatech.se>
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
index 515ea6a..50efecc 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -711,6 +711,7 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 {
 	struct adv7180_state *state = to_state(sd);
 	struct v4l2_mbus_framefmt *framefmt;
+	int ret;
 
 	switch (format->format.field) {
 	case V4L2_FIELD_NONE:
@@ -722,8 +723,9 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 		break;
 	}
 
+	ret = adv7180_mbus_fmt(sd,  &format->format);
+
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
-		framefmt = &format->format;
 		if (state->field != format->format.field) {
 			state->field = format->format.field;
 			adv7180_set_power(state, false);
@@ -735,7 +737,7 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 		*framefmt = format->format;
 	}
 
-	return adv7180_mbus_fmt(sd, framefmt);
+	return ret;
 }
 
 static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
-- 
2.9.3

