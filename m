Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1152 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3LJNZR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 08:25:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 06/15] adv7604: select YPbPr if RGB_RANGE_FULL/LIMITED is set for VGA_COMP inputs
Date: Tue, 10 Dec 2013 14:23:11 +0100
Message-Id: <437e4eb06a454d5f9fa6c76432b7ce22f8503db2.1386681716.git.hans.verkuil@cisco.com>
In-Reply-To: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
References: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
References: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 7187378..b53373b 100644
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
1.8.4.rc3

