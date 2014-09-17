Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1379 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbaIQMvT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 08:51:19 -0400
Message-ID: <541983BD.3000701@xs4all.nl>
Date: Wed, 17 Sep 2014 14:51:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: "Mats Randgaard (matrandg)" <matrandg@cisco.com>,
	Martin Bugge <marbugge@cisco.com>
Subject: [PATCH] adv7604/adv7842: fix query_dv_timings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set il_vfrontporch/il_vsync/il_vbackporch to 0 for progressive video and
fix a typo where bt->vbackporch was set instead of bt->il_vbackporch.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d4fa213..5ca4bfe 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1593,7 +1593,9 @@ static int adv7604_query_dv_timings(struct v4l2_subdev *sd,
 			bt->height += hdmi_read16(sd, 0x0b, 0xfff);
 			bt->il_vfrontporch = hdmi_read16(sd, 0x2c, 0x1fff) / 2;
 			bt->il_vsync = hdmi_read16(sd, 0x30, 0x1fff) / 2;
-			bt->vbackporch = hdmi_read16(sd, 0x34, 0x1fff) / 2;
+			bt->il_vbackporch = hdmi_read16(sd, 0x34, 0x1fff) / 2;
+		} else {
+			bt->il_vfrontporch = bt->il_vsync = bt->il_vbackporch = 0;
 		}
 		adv7604_fill_optional_dv_timings_fields(sd, timings);
 	} else {
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 0d55491..541f2db 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1483,8 +1483,10 @@ static int adv7842_query_dv_timings(struct v4l2_subdev *sd,
 					hdmi_read(sd, 0x2d)) / 2;
 			bt->il_vsync = ((hdmi_read(sd, 0x30) & 0x1f) * 256 +
 					hdmi_read(sd, 0x31)) / 2;
-			bt->vbackporch = ((hdmi_read(sd, 0x34) & 0x1f) * 256 +
+			bt->il_vbackporch = ((hdmi_read(sd, 0x34) & 0x1f) * 256 +
 					hdmi_read(sd, 0x35)) / 2;
+		} else {
+			bt->il_vfrontporch = bt->il_vsync = bt->il_vbackporch = 0;
 		}
 		adv7842_fill_optional_dv_timings_fields(sd, timings);
 	} else {
