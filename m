Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:41162 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbbFGKcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 06:32:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/6] adv7842: replace uintX_t by uX for consistency
Date: Sun,  7 Jun 2015 12:32:31 +0200
Message-Id: <1433673155-20179-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433673155-20179-1-git-send-email-hverkuil@xs4all.nl>
References: <1433673155-20179-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Currently this driver mixes u8/u32 and uint8_t/uint32_t. Standardize on
u8/u32.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 22 ++++++++++----------
 include/media/adv7842.h     | 50 ++++++++++++++++++++++-----------------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index f5248ba..f14ea78 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1556,7 +1556,7 @@ static int adv7842_query_dv_timings(struct v4l2_subdev *sd,
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT;
 
 	if (is_digital_input(sd)) {
-		uint32_t freq;
+		u32 freq;
 
 		timings->type = V4L2_DV_BT_656_1120;
 
@@ -2334,7 +2334,7 @@ struct adv7842_cfg_read_infoframe {
 static void log_infoframe(struct v4l2_subdev *sd, struct adv7842_cfg_read_infoframe *cri)
 {
 	int i;
-	uint8_t buffer[32];
+	u8 buffer[32];
 	union hdmi_infoframe frame;
 	u8 len;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -2407,7 +2407,7 @@ static const char * const prim_mode_txt[] = {
 static int adv7842_sdp_log_status(struct v4l2_subdev *sd)
 {
 	/* SDP (Standard definition processor) block */
-	uint8_t sdp_signal_detected = sdp_read(sd, 0x5A) & 0x01;
+	u8 sdp_signal_detected = sdp_read(sd, 0x5A) & 0x01;
 
 	v4l2_info(sd, "Chip powered %s\n", no_power(sd) ? "off" : "on");
 	v4l2_info(sd, "Prim-mode = 0x%x, video std = 0x%x\n",
@@ -2451,10 +2451,10 @@ static int adv7842_cp_log_status(struct v4l2_subdev *sd)
 	/* CP block */
 	struct adv7842_state *state = to_state(sd);
 	struct v4l2_dv_timings timings;
-	uint8_t reg_io_0x02 = io_read(sd, 0x02);
-	uint8_t reg_io_0x21 = io_read(sd, 0x21);
-	uint8_t reg_rep_0x77 = rep_read(sd, 0x77);
-	uint8_t reg_rep_0x7d = rep_read(sd, 0x7d);
+	u8 reg_io_0x02 = io_read(sd, 0x02);
+	u8 reg_io_0x21 = io_read(sd, 0x21);
+	u8 reg_rep_0x77 = rep_read(sd, 0x77);
+	u8 reg_rep_0x7d = rep_read(sd, 0x7d);
 	bool audio_pll_locked = hdmi_read(sd, 0x04) & 0x01;
 	bool audio_sample_packet_detect = hdmi_read(sd, 0x18) & 0x01;
 	bool audio_mute = io_read(sd, 0x65) & 0x40;
@@ -2526,10 +2526,10 @@ static int adv7842_cp_log_status(struct v4l2_subdev *sd)
 	if (no_cp_signal(sd)) {
 		v4l2_info(sd, "STDI: not locked\n");
 	} else {
-		uint32_t bl = ((cp_read(sd, 0xb1) & 0x3f) << 8) | cp_read(sd, 0xb2);
-		uint32_t lcf = ((cp_read(sd, 0xb3) & 0x7) << 8) | cp_read(sd, 0xb4);
-		uint32_t lcvs = cp_read(sd, 0xb3) >> 3;
-		uint32_t fcl = ((cp_read(sd, 0xb8) & 0x1f) << 8) | cp_read(sd, 0xb9);
+		u32 bl = ((cp_read(sd, 0xb1) & 0x3f) << 8) | cp_read(sd, 0xb2);
+		u32 lcf = ((cp_read(sd, 0xb3) & 0x7) << 8) | cp_read(sd, 0xb4);
+		u32 lcvs = cp_read(sd, 0xb3) >> 3;
+		u32 fcl = ((cp_read(sd, 0xb8) & 0x1f) << 8) | cp_read(sd, 0xb9);
 		char hs_pol = ((cp_read(sd, 0xb5) & 0x10) ?
 				((cp_read(sd, 0xb5) & 0x08) ? '+' : '-') : 'x');
 		char vs_pol = ((cp_read(sd, 0xb5) & 0x40) ?
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index 1f38db8..bc24970 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -103,35 +103,35 @@ enum adv7842_drive_strength {
 
 struct adv7842_sdp_csc_coeff {
 	bool manual;
-	uint16_t scaling;
-	uint16_t A1;
-	uint16_t A2;
-	uint16_t A3;
-	uint16_t A4;
-	uint16_t B1;
-	uint16_t B2;
-	uint16_t B3;
-	uint16_t B4;
-	uint16_t C1;
-	uint16_t C2;
-	uint16_t C3;
-	uint16_t C4;
+	u16 scaling;
+	u16 A1;
+	u16 A2;
+	u16 A3;
+	u16 A4;
+	u16 B1;
+	u16 B2;
+	u16 B3;
+	u16 B4;
+	u16 C1;
+	u16 C2;
+	u16 C3;
+	u16 C4;
 };
 
 struct adv7842_sdp_io_sync_adjustment {
 	bool adjust;
-	uint16_t hs_beg;
-	uint16_t hs_width;
-	uint16_t de_beg;
-	uint16_t de_end;
-	uint8_t vs_beg_o;
-	uint8_t vs_beg_e;
-	uint8_t vs_end_o;
-	uint8_t vs_end_e;
-	uint8_t de_v_beg_o;
-	uint8_t de_v_beg_e;
-	uint8_t de_v_end_o;
-	uint8_t de_v_end_e;
+	u16 hs_beg;
+	u16 hs_width;
+	u16 de_beg;
+	u16 de_end;
+	u8 vs_beg_o;
+	u8 vs_beg_e;
+	u8 vs_end_o;
+	u8 vs_end_e;
+	u8 de_v_beg_o;
+	u8 de_v_beg_e;
+	u8 de_v_end_o;
+	u8 de_v_end_e;
 };
 
 /* Platform dependent definition */
-- 
2.1.4

