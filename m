Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4681 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaITKgy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 06:36:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: matrandg@cisco.com, marbugge@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/2] adv7604/adv7842: fix il_vbackporch typo and zero the struct
Date: Sat, 20 Sep 2014 12:36:39 +0200
Message-Id: <1411209399-24478-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411209399-24478-1-git-send-email-hverkuil@xs4all.nl>
References: <1411209399-24478-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Both adv7604 and adv7842 had the same typo in the code that sets
the vertical backporch for the second interlaced field: it was
assigned to vbackporch instead of il_vbackporch.

In addition, the timings struct wasn't zeroed in the adv7842 driver,
leaving several fields to undefined values causing the timing match
function to fail.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 2 +-
 drivers/media/i2c/adv7842.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d4fa213..a836de6 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1593,7 +1593,7 @@ static int adv7604_query_dv_timings(struct v4l2_subdev *sd,
 			bt->height += hdmi_read16(sd, 0x0b, 0xfff);
 			bt->il_vfrontporch = hdmi_read16(sd, 0x2c, 0x1fff) / 2;
 			bt->il_vsync = hdmi_read16(sd, 0x30, 0x1fff) / 2;
-			bt->vbackporch = hdmi_read16(sd, 0x34, 0x1fff) / 2;
+			bt->il_vbackporch = hdmi_read16(sd, 0x34, 0x1fff) / 2;
 		}
 		adv7604_fill_optional_dv_timings_fields(sd, timings);
 	} else {
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 0d55491..48b628b 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1435,6 +1435,8 @@ static int adv7842_query_dv_timings(struct v4l2_subdev *sd,
 
 	v4l2_dbg(1, debug, sd, "%s:\n", __func__);
 
+	memset(timings, 0, sizeof(struct v4l2_dv_timings));
+
 	/* SDP block */
 	if (state->mode == ADV7842_MODE_SDP)
 		return -ENODATA;
@@ -1483,7 +1485,7 @@ static int adv7842_query_dv_timings(struct v4l2_subdev *sd,
 					hdmi_read(sd, 0x2d)) / 2;
 			bt->il_vsync = ((hdmi_read(sd, 0x30) & 0x1f) * 256 +
 					hdmi_read(sd, 0x31)) / 2;
-			bt->vbackporch = ((hdmi_read(sd, 0x34) & 0x1f) * 256 +
+			bt->il_vbackporch = ((hdmi_read(sd, 0x34) & 0x1f) * 256 +
 					hdmi_read(sd, 0x35)) / 2;
 		}
 		adv7842_fill_optional_dv_timings_fields(sd, timings);
-- 
2.1.0

