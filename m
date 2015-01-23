Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-190.synserver.de ([212.40.185.190]:1095 "EHLO
	smtp-out-190.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667AbbAWPwk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 10:52:40 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?=
	<richard.rojfors@mocean-labs.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 03/15] [media] adv7180: Use inline function instead of macro
Date: Fri, 23 Jan 2015 16:52:22 +0100
Message-Id: <1422028354-31891-4-git-send-email-lars@metafoo.de>
In-Reply-To: <1422028354-31891-1-git-send-email-lars@metafoo.de>
References: <1422028354-31891-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use a inline function instead of a macro for the container_of helper for
getting the driver's state struct from a control. A inline function has the
advantage that it is more typesafe and nicer in general.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
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

