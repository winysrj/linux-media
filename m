Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3104 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab3LTJb6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:31:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 13/50] adv7604: select YPbPr if RGB_RANGE_FULL/LIMITED is set for VGA_COMP inputs
Date: Fri, 20 Dec 2013 10:31:06 +0100
Message-Id: <1387531903-20496-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d4ac8dd..d1de747 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -949,17 +949,26 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 		}
 		break;
 	case V4L2_DV_RGB_RANGE_LIMITED:
-		/* RGB limited range (16-235) */
-		io_write_and_or(sd, 0x02, 0x0f, 0x00);
+		if (state->selected_input == ADV7604_INPUT_VGA_COMP) {
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
+		if (state->selected_input == ADV7604_INPUT_VGA_COMP) {
+			/* YCrCb full range (0-255) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x60);
+		} else {
+			/* RGB full range (0-255) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x10);
+		}
 		break;
 	}
 }
 
-
 static int adv7604_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_sd(ctrl);
-- 
1.8.4.4

