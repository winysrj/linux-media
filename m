Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2413 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3LJNZQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 08:25:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 05/15] adv7604: Receive CEA formats as RGB on VGA (RGB) input
Date: Tue, 10 Dec 2013 14:23:10 +0100
Message-Id: <bec4c1794438fe30ec2a11430dd294d1080dd79b.1386681716.git.hans.verkuil@cisco.com>
In-Reply-To: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
References: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
References: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

If the input is ADV7604_INPUT_VGA_RGB and RGB quantization range is
set to V4L2_DV_RGB_RANGE_AUTO, video with CEA timings will be
received as RGB. For ADV7604_INPUT_VGA_COMP, automatic CSC mode
will be selected.

See table 44 on page 205 in "ADV7604 Hardware Manual, Rev. F, August 2010"
for details.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 50 ++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 37f3994..7187378 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -911,25 +911,41 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 {
 	struct adv7604_state *state = to_state(sd);
 
+	v4l2_dbg(2, debug, sd, "%s: rgb_quantization_range = %d\n",
+		       __func__, state->rgb_quantization_range);
+
 	switch (state->rgb_quantization_range) {
 	case V4L2_DV_RGB_RANGE_AUTO:
-		/* automatic */
-		if (is_digital_input(sd) && !(hdmi_read(sd, 0x05) & 0x80)) {
-			/* receiving DVI-D signal */
-
-			/* ADV7604 selects RGB limited range regardless of
-			   input format (CE/IT) in automatic mode */
-			if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
-				/* RGB limited range (16-235) */
-				io_write_and_or(sd, 0x02, 0x0f, 0x00);
-
-			} else {
-				/* RGB full range (0-255) */
-				io_write_and_or(sd, 0x02, 0x0f, 0x10);
-			}
-		} else {
-			/* receiving HDMI or analog signal, set automode */
+		if (state->selected_input == ADV7604_INPUT_VGA_RGB) {
+			/* Receiving analog RGB signal
+			 * Set RGB full range (0-255) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x10);
+			break;
+		}
+
+		if (state->selected_input == ADV7604_INPUT_VGA_COMP) {
+			/* Receiving analog YPbPr signal
+			 * Set automode */
+			io_write_and_or(sd, 0x02, 0x0f, 0xf0);
+			break;
+		}
+
+		if (hdmi_read(sd, 0x05) & 0x80) {
+			/* Receiving HDMI signal
+			 * Set automode */
 			io_write_and_or(sd, 0x02, 0x0f, 0xf0);
+			break;
+		}
+
+		/* Receiving DVI-D signal
+		 * ADV7604 selects RGB limited range regardless of
+		 * input format (CE/IT) in automatic mode */
+		if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
+			/* RGB limited range (16-235) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x00);
+		} else {
+			/* RGB full range (0-255) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x10);
 		}
 		break;
 	case V4L2_DV_RGB_RANGE_LIMITED:
@@ -1709,7 +1725,7 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 	char *input_color_space_txt[16] = {
 		"RGB limited range (16-235)", "RGB full range (0-255)",
 		"YCbCr Bt.601 (16-235)", "YCbCr Bt.709 (16-235)",
-		"XvYCC Bt.601", "XvYCC Bt.709",
+		"xvYCC Bt.601", "xvYCC Bt.709",
 		"YCbCr Bt.601 (0-255)", "YCbCr Bt.709 (0-255)",
 		"invalid", "invalid", "invalid", "invalid", "invalid",
 		"invalid", "invalid", "automatic"
-- 
1.8.4.rc3

