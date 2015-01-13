Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-231.synserver.de ([212.40.185.231]:1070 "EHLO
	smtp-out-227.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752306AbbAMMB1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 07:01:27 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 03/16] [media] adv7180: Use inline function instead of macro
Date: Tue, 13 Jan 2015 13:01:08 +0100
Message-Id: <1421150481-30230-4-git-send-email-lars@metafoo.de>
In-Reply-To: <1421150481-30230-1-git-send-email-lars@metafoo.de>
References: <1421150481-30230-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use a inline function instead of a macro for the container_of helper for
getting the driver's state struct from a control. A inline function has the
advantage that it is more typesafe and nicer in general.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7180.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index f424a4d..f2508abe 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -130,9 +130,11 @@ struct adv7180_state {
 	bool			powered;
 	u8			input;
 };
-#define to_adv7180_sd(_ctrl) (&container_of(_ctrl->handler,		\
-					    struct adv7180_state,	\
-					    ctrl_hdl)->sd)
+
+static struct adv7180_state *ctrl_to_adv7180(struct v4l2_ctrl *ctrl)
+{
+	return container_of(ctrl->handler, struct adv7180_state, ctrl_hdl);
+}
 
 static v4l2_std_id adv7180_std_to_v4l2(u8 status1)
 {
@@ -345,9 +347,8 @@ static int adv7180_s_power(struct v4l2_subdev *sd, int on)
 
 static int adv7180_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct v4l2_subdev *sd = to_adv7180_sd(ctrl);
-	struct adv7180_state *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct adv7180_state *state = ctrl_to_adv7180(ctrl);
+	struct i2c_client *client = v4l2_get_subdevdata(&state->sd);
 	int ret = mutex_lock_interruptible(&state->mutex);
 	int val;
 
-- 
1.8.0

