Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:44265 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab3CWWgA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 18:36:00 -0400
Received: by mail-la0-f53.google.com with SMTP id fr10so9245168lab.40
        for <linux-media@vger.kernel.org>; Sat, 23 Mar 2013 15:35:59 -0700 (PDT)
From: Volokh Konstantin <volokh84@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH] hverkuil/go7007: media: i2c : tw2804: Revert ADC Control Reverting patch commit 3d321ebba68f1fc50a9461373e8da0887e39fbbc Case: In AdLink MPG24 there is bt878 exists (it captures one frame of all video inputs),  Video Signal for it one transmits through tw2804 chip, so we can`t control ADC (shut on/off) on tw2804 ,as some another can use bttv capture way.
Date: Sun, 24 Mar 2013 02:28:28 +0400
Message-Id: <1364077708-508-1-git-send-email-volokh84@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/media/i2c/tw2804.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/tw2804.c b/drivers/media/i2c/tw2804.c
index 441b766..c5dc2c3 100644
--- a/drivers/media/i2c/tw2804.c
+++ b/drivers/media/i2c/tw2804.c
@@ -53,7 +53,7 @@ static const u8 global_registers[] = {
 	0x3d, 0x80,
 	0x3e, 0x82,
 	0x3f, 0x82,
-	0x78, 0x0f,
+	0x78, 0x00,
 	0xff, 0xff, /* Terminator (reg 0xff does not exist) */
 };
 
@@ -337,20 +337,6 @@ static int tw2804_s_video_routing(struct v4l2_subdev *sd, u32 input, u32 output,
 	return 0;
 }
 
-static int tw2804_s_stream(struct v4l2_subdev *sd, int enable)
-{
-	struct tw2804 *dec = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	u32 reg = read_reg(client, 0x78, 0);
-
-	if (enable == 1)
-		write_reg(client, 0x78, reg & ~(1 << dec->channel), 0);
-	else
-		write_reg(client, 0x78, reg | (1 << dec->channel), 0);
-
-	return 0;
-}
-
 static const struct v4l2_ctrl_ops tw2804_ctrl_ops = {
 	.g_volatile_ctrl = tw2804_g_volatile_ctrl,
 	.s_ctrl = tw2804_s_ctrl,
@@ -358,7 +344,6 @@ static const struct v4l2_ctrl_ops tw2804_ctrl_ops = {
 
 static const struct v4l2_subdev_video_ops tw2804_video_ops = {
 	.s_routing = tw2804_s_video_routing,
-	.s_stream = tw2804_s_stream,
 };
 
 static const struct v4l2_subdev_core_ops tw2804_core_ops = {
-- 
1.7.7.6

