Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36274 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbcGWRBE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2016 13:01:04 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: lars@metafoo.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v3 6/9] media: adv7180: change mbus format to UYVY
Date: Sat, 23 Jul 2016 10:00:46 -0700
Message-Id: <1469293249-6774-7-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1469293249-6774-1-git-send-email-steve_longerbeam@mentor.com>
References: <1469293249-6774-1-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the media bus format from YUYV8_2X8 to UYVY8_2X8. Colors
now look correct when capturing with the i.mx6 backend.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Tested-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

---
v3: no changes
v2: no changes
---
 drivers/media/i2c/adv7180.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index b8a6d94..ef2a107 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -636,7 +636,7 @@ static int adv7180_enum_mbus_code(struct v4l2_subdev *sd,
 	if (code->index != 0)
 		return -EINVAL;
 
-	code->code = MEDIA_BUS_FMT_YUYV8_2X8;
+	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
 
 	return 0;
 }
@@ -646,7 +646,7 @@ static int adv7180_mbus_fmt(struct v4l2_subdev *sd,
 {
 	struct adv7180_state *state = to_state(sd);
 
-	fmt->code = MEDIA_BUS_FMT_YUYV8_2X8;
+	fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	fmt->width = 720;
 	fmt->height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
-- 
1.9.1

