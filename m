Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1913 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3EZN1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 09:27:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 14/24] au8522_decoder: remove g_chip_ident op.
Date: Sun, 26 May 2013 15:27:09 +0200
Message-Id: <1369574839-6687-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
References: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is no longer needed since the core now handles this through DBG_G_CHIP_INFO.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 9d159b4..23a0d05 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -35,7 +35,6 @@
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <media/v4l2-common.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-device.h>
 #include "au8522.h"
 #include "au8522_priv.h"
@@ -524,11 +523,8 @@ static int au8522_s_ctrl(struct v4l2_ctrl *ctrl)
 static int au8522_g_register(struct v4l2_subdev *sd,
 			     struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct au8522_state *state = to_state(sd);
 
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	reg->val = au8522_readreg(state, reg->reg & 0xffff);
 	return 0;
 }
@@ -536,11 +532,8 @@ static int au8522_g_register(struct v4l2_subdev *sd,
 static int au8522_s_register(struct v4l2_subdev *sd,
 			     const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct au8522_state *state = to_state(sd);
 
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	au8522_writereg(state, reg->reg, reg->val & 0xff);
 	return 0;
 }
@@ -632,20 +625,10 @@ static int au8522_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	return 0;
 }
 
-static int au8522_g_chip_ident(struct v4l2_subdev *sd,
-			       struct v4l2_dbg_chip_ident *chip)
-{
-	struct au8522_state *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, state->id, state->rev);
-}
-
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops au8522_core_ops = {
 	.log_status = v4l2_ctrl_subdev_log_status,
-	.g_chip_ident = au8522_g_chip_ident,
 	.reset = au8522_reset,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = au8522_g_register,
-- 
1.7.10.4

