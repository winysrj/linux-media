Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59508 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaBEQmG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:42:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 39/47] adv7604: Inline the to_sd function
Date: Wed,  5 Feb 2014 17:42:30 +0100
Message-Id: <1391618558-5580-40-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This one line function is called in a single location. Inline it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 4815063..be75fa5 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -350,11 +350,6 @@ static inline struct adv7604_state *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct adv7604_state, sd);
 }
 
-static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
-{
-	return &container_of(ctrl->handler, struct adv7604_state, hdl)->sd;
-}
-
 static inline unsigned hblanking(const struct v4l2_bt_timings *t)
 {
 	return V4L2_DV_BT_BLANKING_WIDTH(t);
@@ -1280,7 +1275,9 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 
 static int adv7604_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct v4l2_subdev *sd =
+		&container_of(ctrl->handler, struct adv7604_state, hdl)->sd;
+
 	struct adv7604_state *state = to_state(sd);
 
 	switch (ctrl->id) {
-- 
1.8.3.2

