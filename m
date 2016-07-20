Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36169 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbcGTAEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 20:04:05 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: lars@metafoo.de
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 07/10] media: adv7180: change mbus format to UYVY
Date: Tue, 19 Jul 2016 17:03:34 -0700
Message-Id: <1468973017-17647-8-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1468973017-17647-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1468973017-17647-1-git-send-email-steve_longerbeam@mentor.com>
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
 drivers/media/i2c/adv7180.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 8259549..0f0568c 100644
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

