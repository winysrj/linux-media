Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32777 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbcGFXOe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:14:34 -0400
Received: by mail-pf0-f195.google.com with SMTP id c74so115948pfb.0
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:14:33 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 07/11] media: adv7180: change mbus format to UYVY
Date: Wed,  6 Jul 2016 16:00:00 -0700
Message-Id: <1467846004-12731-8-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the media bus format from YUYV8_2X8 to UYVY8_2X8. Colors
now look correct when capturing with the i.mx6 backend. The other
option is to set the SWPC bit in register 0x27 to swap the Cr and Cb
output samples.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/i2c/adv7180.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index fff887c..427695d 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -654,7 +654,7 @@ static int adv7180_enum_mbus_code(struct v4l2_subdev *sd,
 	if (code->index != 0)
 		return -EINVAL;
 
-	code->code = MEDIA_BUS_FMT_YUYV8_2X8;
+	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
 
 	return 0;
 }
@@ -664,7 +664,7 @@ static int adv7180_mbus_fmt(struct v4l2_subdev *sd,
 {
 	struct adv7180_state *state = to_state(sd);
 
-	fmt->code = MEDIA_BUS_FMT_YUYV8_2X8;
+	fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	fmt->width = 720;
 	fmt->height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
-- 
1.9.1

