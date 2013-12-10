Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2898 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab3LJPGD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 10:06:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 05/22] adv7842: support YCrCb analog input.
Date: Tue, 10 Dec 2013 16:03:51 +0100
Message-Id: <897dd7b90fae2918cca1d7e844e238ab60d2804c.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
References: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 40 +++++++++++++++++++++++++++++-----------
 include/media/adv7842.h     |  3 ---
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 4f93526..d350c86 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1056,12 +1056,22 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 		}
 		break;
 	case V4L2_DV_RGB_RANGE_LIMITED:
-		/* RGB limited range (16-235) */
-		io_write_and_or(sd, 0x02, 0x0f, 0x00);
+		if (state->mode == ADV7842_MODE_COMP) {
+			/* YCrCb limited range (16-235) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x20);
+		} else {
+			/* RGB limited range (16-235) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x00);
+		}
 		break;
 	case V4L2_DV_RGB_RANGE_FULL:
-		/* RGB full range (0-255) */
-		io_write_and_or(sd, 0x02, 0x0f, 0x10);
+		if (state->mode == ADV7842_MODE_COMP) {
+			/* YCrCb full range (0-255) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x60);
+		} else {
+			/* RGB full range (0-255) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x10);
+		}
 		break;
 	}
 }
@@ -1586,6 +1596,13 @@ static void select_input(struct v4l2_subdev *sd,
 
 		afe_write(sd, 0x00, 0x00); /* power up ADC */
 		afe_write(sd, 0xc8, 0x00); /* phase control */
+		if (state->mode == ADV7842_MODE_COMP) {
+			/* force to YCrCb */
+			io_write_and_or(sd, 0x02, 0x0f, 0x60);
+		} else {
+			/* force to RGB */
+			io_write_and_or(sd, 0x02, 0x0f, 0x10);
+		}
 
 		/* set ADI recommended settings for digitizer */
 		/* "ADV7842 Register Settings Recommendations
@@ -1681,19 +1698,19 @@ static int adv7842_s_routing(struct v4l2_subdev *sd,
 
 	switch (input) {
 	case ADV7842_SELECT_HDMI_PORT_A:
-		/* TODO select HDMI_COMP or HDMI_GR */
 		state->mode = ADV7842_MODE_HDMI;
 		state->vid_std_select = ADV7842_HDMI_COMP_VID_STD_HD_1250P;
 		state->hdmi_port_a = true;
 		break;
 	case ADV7842_SELECT_HDMI_PORT_B:
-		/* TODO select HDMI_COMP or HDMI_GR */
 		state->mode = ADV7842_MODE_HDMI;
 		state->vid_std_select = ADV7842_HDMI_COMP_VID_STD_HD_1250P;
 		state->hdmi_port_a = false;
 		break;
 	case ADV7842_SELECT_VGA_COMP:
-		v4l2_info(sd, "%s: VGA component: todo\n", __func__);
+		state->mode = ADV7842_MODE_COMP;
+		state->vid_std_select = ADV7842_RGB_VID_STD_AUTO_GRAPH_MODE;
+		break;
 	case ADV7842_SELECT_VGA_RGB:
 		state->mode = ADV7842_MODE_RGB;
 		state->vid_std_select = ADV7842_RGB_VID_STD_AUTO_GRAPH_MODE;
@@ -2341,9 +2358,10 @@ static int adv7842_g_std(struct v4l2_subdev *sd, v4l2_std_id *norm)
 
 /* ----------------------------------------------------------------------- */
 
-static int adv7842_core_init(struct v4l2_subdev *sd,
-		const struct adv7842_platform_data *pdata)
+static int adv7842_core_init(struct v4l2_subdev *sd)
 {
+	struct adv7842_state *state = to_state(sd);
+	struct adv7842_platform_data *pdata = &state->pdata;
 	hdmi_write(sd, 0x48,
 		   (pdata->disable_pwrdnb ? 0x80 : 0) |
 		   (pdata->disable_cable_det_rst ? 0x40 : 0));
@@ -2356,7 +2374,7 @@ static int adv7842_core_init(struct v4l2_subdev *sd,
 
 	/* video format */
 	io_write(sd, 0x02,
-		 pdata->inp_color_space << 4 |
+		 0xf0 |
 		 pdata->alt_gamma << 3 |
 		 pdata->op_656_range << 2 |
 		 pdata->rgb_out << 1 |
@@ -2566,7 +2584,7 @@ static int adv7842_command_ram_test(struct v4l2_subdev *sd)
 	adv7842_rewrite_i2c_addresses(sd, pdata);
 
 	/* and re-init chip and state */
-	adv7842_core_init(sd, pdata);
+	adv7842_core_init(sd);
 
 	disable_input(sd);
 
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index c02201d..b0cfc5f 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -159,9 +159,6 @@ struct adv7842_platform_data {
 	/* Video standard */
 	enum adv7842_vid_std_select vid_std_select;
 
-	/* Input Color Space */
-	enum adv7842_inp_color_space inp_color_space;
-
 	/* Select output format */
 	enum adv7842_op_format_sel op_format_sel;
 
-- 
1.8.4.rc3

