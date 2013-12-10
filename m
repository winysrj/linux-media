Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2047 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3LJPGF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 10:06:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 09/22] adv7842: 625/525 line standard jitter fix.
Date: Tue, 10 Dec 2013 16:03:55 +0100
Message-Id: <288fecdf2de7f90beb60ca3b32cabd2fe257b879.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
References: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Both the PAL and NTSC standards are interlaced where a
frame consist of two fields. Total number of lines in a frame in both systems
are an odd number so the two fields will have different length.

In the 625 line standard ("PAL") the odd field of the frame is transmitted first,
while in the 525 standard ("NTSC") the even field is transmitted first.

This adds the possibility to change output config between the fields and standards.

This setting will reduce the "format-jitter" on the signal sent by the pixelport
moving the difference between the fields to vertical front/back-porch only.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 56 ++++++++++++++++++++++++++++++++-------------
 include/media/adv7842.h     |  3 ++-
 2 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 6335d9f..3e8d7cc 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2343,15 +2343,55 @@ static int adv7842_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 	return 0;
 }
 
+static void adv7842_s_sdp_io(struct v4l2_subdev *sd, struct adv7842_sdp_io_sync_adjustment *s)
+{
+	if (s && s->adjust) {
+		sdp_io_write(sd, 0x94, (s->hs_beg >> 8) & 0xf);
+		sdp_io_write(sd, 0x95, s->hs_beg & 0xff);
+		sdp_io_write(sd, 0x96, (s->hs_width >> 8) & 0xf);
+		sdp_io_write(sd, 0x97, s->hs_width & 0xff);
+		sdp_io_write(sd, 0x98, (s->de_beg >> 8) & 0xf);
+		sdp_io_write(sd, 0x99, s->de_beg & 0xff);
+		sdp_io_write(sd, 0x9a, (s->de_end >> 8) & 0xf);
+		sdp_io_write(sd, 0x9b, s->de_end & 0xff);
+		sdp_io_write(sd, 0xac, s->de_v_beg_o);
+		sdp_io_write(sd, 0xad, s->de_v_beg_e);
+		sdp_io_write(sd, 0xae, s->de_v_end_o);
+		sdp_io_write(sd, 0xaf, s->de_v_end_e);
+	} else {
+		/* set to default */
+		sdp_io_write(sd, 0x94, 0x00);
+		sdp_io_write(sd, 0x95, 0x00);
+		sdp_io_write(sd, 0x96, 0x00);
+		sdp_io_write(sd, 0x97, 0x20);
+		sdp_io_write(sd, 0x98, 0x00);
+		sdp_io_write(sd, 0x99, 0x00);
+		sdp_io_write(sd, 0x9a, 0x00);
+		sdp_io_write(sd, 0x9b, 0x00);
+		sdp_io_write(sd, 0xac, 0x04);
+		sdp_io_write(sd, 0xad, 0x04);
+		sdp_io_write(sd, 0xae, 0x04);
+		sdp_io_write(sd, 0xaf, 0x04);
+	}
+}
+
 static int adv7842_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 {
 	struct adv7842_state *state = to_state(sd);
+	struct adv7842_platform_data *pdata = &state->pdata;
 
 	v4l2_dbg(1, debug, sd, "%s:\n", __func__);
 
 	if (state->mode != ADV7842_MODE_SDP)
 		return -ENODATA;
 
+	if (norm & V4L2_STD_625_50)
+		adv7842_s_sdp_io(sd, &pdata->sdp_io_sync_625);
+	else if (norm & V4L2_STD_525_60)
+		adv7842_s_sdp_io(sd, &pdata->sdp_io_sync_525);
+	else
+		adv7842_s_sdp_io(sd, NULL);
+
 	if (norm & V4L2_STD_ALL) {
 		state->norm = norm;
 		return 0;
@@ -2421,22 +2461,6 @@ static int adv7842_core_init(struct v4l2_subdev *sd)
 
 	sdp_csc_coeff(sd, &pdata->sdp_csc_coeff);
 
-	if (pdata->sdp_io_sync.adjust) {
-		const struct adv7842_sdp_io_sync_adjustment *s = &pdata->sdp_io_sync;
-		sdp_io_write(sd, 0x94, (s->hs_beg>>8) & 0xf);
-		sdp_io_write(sd, 0x95, s->hs_beg & 0xff);
-		sdp_io_write(sd, 0x96, (s->hs_width>>8) & 0xf);
-		sdp_io_write(sd, 0x97, s->hs_width & 0xff);
-		sdp_io_write(sd, 0x98, (s->de_beg>>8) & 0xf);
-		sdp_io_write(sd, 0x99, s->de_beg & 0xff);
-		sdp_io_write(sd, 0x9a, (s->de_end>>8) & 0xf);
-		sdp_io_write(sd, 0x9b, s->de_end & 0xff);
-		sdp_io_write(sd, 0xac, s->de_v_beg_o);
-		sdp_io_write(sd, 0xad, s->de_v_beg_e);
-		sdp_io_write(sd, 0xae, s->de_v_end_o);
-		sdp_io_write(sd, 0xaf, s->de_v_end_e);
-	}
-
 	/* todo, improve settings for sdram */
 	if (pdata->sd_ram_size >= 128) {
 		sdp_write(sd, 0x12, 0x0d); /* Frame TBC,3D comb enabled */
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index f4e9d0d..5327ba3 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -197,7 +197,8 @@ struct adv7842_platform_data {
 
 	struct adv7842_sdp_csc_coeff sdp_csc_coeff;
 
-	struct adv7842_sdp_io_sync_adjustment sdp_io_sync;
+	struct adv7842_sdp_io_sync_adjustment sdp_io_sync_625;
+	struct adv7842_sdp_io_sync_adjustment sdp_io_sync_525;
 
 	/* i2c addresses */
 	u8 i2c_sdp_io;
-- 
1.8.4.rc3

