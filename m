Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1545 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab0LLRcH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:07 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MH002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:06 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 09/19] tda9875: use control framework
Date: Sun, 12 Dec 2010 18:31:51 +0100
Message-Id: <8824465c8940117356a74d10f56e00830ae5562a.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/tda9875.c |  192 ++++++++++++-----------------------------
 1 files changed, 57 insertions(+), 135 deletions(-)

diff --git a/drivers/media/video/tda9875.c b/drivers/media/video/tda9875.c
index 35b6ff5..6d8ff21 100644
--- a/drivers/media/video/tda9875.c
+++ b/drivers/media/video/tda9875.c
@@ -28,6 +28,7 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/i2c-addr.h>
 
 static int debug; /* insmod parameter */
@@ -38,8 +39,12 @@ MODULE_LICENSE("GPL");
 /* This is a superset of the TDA9875 */
 struct tda9875 {
 	struct v4l2_subdev sd;
-	int rvol, lvol;
-	int bass, treble;
+	struct v4l2_ctrl_handler hdl;
+	struct {
+		/* volume/balance cluster */
+		struct v4l2_ctrl *volume;
+		struct v4l2_ctrl *balance;
+	};
 };
 
 static inline struct tda9875 *to_state(struct v4l2_subdev *sd)
@@ -47,6 +52,11 @@ static inline struct tda9875 *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct tda9875, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct tda9875, hdl)->sd;
+}
+
 #define dprintk  if (debug) printk
 
 /* The TDA9875 is made by Philips Semiconductor
@@ -134,28 +144,8 @@ static int i2c_read_register(struct i2c_client *client, int addr, int reg)
 	return read[0];
 }
 
-static void tda9875_set(struct v4l2_subdev *sd)
-{
-	struct tda9875 *tda = to_state(sd);
-	unsigned char a;
-
-	v4l2_dbg(1, debug, sd, "tda9875_set(%04x,%04x,%04x,%04x)\n",
-		tda->lvol, tda->rvol, tda->bass, tda->treble);
-
-	a = tda->lvol & 0xff;
-	tda9875_write(sd, TDA9875_MVL, a);
-	a =tda->rvol & 0xff;
-	tda9875_write(sd, TDA9875_MVR, a);
-	a =tda->bass & 0xff;
-	tda9875_write(sd, TDA9875_MBA, a);
-	a =tda->treble  & 0xff;
-	tda9875_write(sd, TDA9875_MTR, a);
-}
-
 static void do_tda9875_init(struct v4l2_subdev *sd)
 {
-	struct tda9875 *t = to_state(sd);
-
 	v4l2_dbg(1, debug, sd, "In tda9875_init\n");
 	tda9875_write(sd, TDA9875_CFG, 0xd0); /*reg de config 0 (reset)*/
 	tda9875_write(sd, TDA9875_MSR, 0x03);    /* Monitor 0b00000XXX*/
@@ -189,138 +179,49 @@ static void do_tda9875_init(struct v4l2_subdev *sd)
 	tda9875_write(sd, TDA9875_ATR, 0x00);   /* Aux Aigus Main 0dB*/
 
 	tda9875_write(sd, TDA9875_MUT, 0xcc);   /* General mute  */
-
-	t->lvol = t->rvol = 0;  	/* 0dB */
-	t->bass = 0; 			/* 0dB */
-	t->treble = 0;  		/* 0dB */
-	tda9875_set(sd);
 }
 
-
-static int tda9875_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int tda9875_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct tda9875 *t = to_state(sd);
+	int volume, balance, left, right;
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
-	{
-		int left = (t->lvol+84)*606;
-		int right = (t->rvol+84)*606;
-
-		ctrl->value=max(left,right);
-		return 0;
-	}
-	case V4L2_CID_AUDIO_BALANCE:
-	{
-		int left = (t->lvol+84)*606;
-		int right = (t->rvol+84)*606;
-		int volume = max(left,right);
-		int balance = (32768*min(left,right))/
-			      (volume ? volume : 1);
-		ctrl->value=(left<right)?
-			(65535-balance) : balance;
+		volume = t->volume->val + 84;
+		balance = t->balance->val;
+		left = (min(255 - balance, 128) * volume) / 128 - 84;
+		right = (min(balance, 128) * volume) / 128 - 84;
+		tda9875_write(sd, TDA9875_MVL, left);
+		tda9875_write(sd, TDA9875_MVR, right);
 		return 0;
-	}
 	case V4L2_CID_AUDIO_BASS:
-		ctrl->value = (t->bass+12)*2427;    /* min -12 max +15 */
+		tda9875_write(sd, TDA9875_MBA, ctrl->val & 0x1f);
 		return 0;
 	case V4L2_CID_AUDIO_TREBLE:
-		ctrl->value = (t->treble+12)*2730;/* min -12 max +12 */
+		tda9875_write(sd, TDA9875_MTR, ctrl->val & 0x1f);
 		return 0;
 	}
 	return -EINVAL;
 }
 
-static int tda9875_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct tda9875 *t = to_state(sd);
-	int chvol = 0, volume = 0, balance = 0, left, right;
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_VOLUME:
-		left = (t->lvol+84)*606;
-		right = (t->rvol+84)*606;
-
-		volume = max(left,right);
-		balance = (32768*min(left,right))/
-			      (volume ? volume : 1);
-		balance =(left<right)?
-			(65535-balance) : balance;
-
-		volume = ctrl->value;
-
-		chvol=1;
-		break;
-	case V4L2_CID_AUDIO_BALANCE:
-		left = (t->lvol+84)*606;
-		right = (t->rvol+84)*606;
-
-		volume=max(left,right);
-
-		balance = ctrl->value;
-
-		chvol=1;
-		break;
-	case V4L2_CID_AUDIO_BASS:
-		t->bass = ((ctrl->value/2400)-12) & 0xff;
-		if (t->bass > 15)
-			t->bass = 15;
-		if (t->bass < -12)
-			t->bass = -12 & 0xff;
-		break;
-	case V4L2_CID_AUDIO_TREBLE:
-		t->treble = ((ctrl->value/2700)-12) & 0xff;
-		if (t->treble > 12)
-			t->treble = 12;
-		if (t->treble < -12)
-			t->treble = -12 & 0xff;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (chvol) {
-		left = (min(65536 - balance,32768) *
-			volume) / 32768;
-		right = (min(balance,32768) *
-				volume) / 32768;
-		t->lvol = ((left/606)-84) & 0xff;
-		if (t->lvol > 24)
-			t->lvol = 24;
-		if (t->lvol < -84)
-			t->lvol = -84 & 0xff;
-
-		t->rvol = ((right/606)-84) & 0xff;
-		if (t->rvol > 24)
-			t->rvol = 24;
-		if (t->rvol < -84)
-			t->rvol = -84 & 0xff;
-	}
-
-	tda9875_set(sd);
-	return 0;
-}
-
-static int tda9875_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(qc, 0, 65535, 65535 / 100, 58880);
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-		return v4l2_ctrl_query_fill(qc, 0, 65535, 65535 / 100, 32768);
-	}
-	return -EINVAL;
-}
-
 /* ----------------------------------------------------------------------- */
 
-static const struct v4l2_subdev_core_ops tda9875_core_ops = {
-	.queryctrl = tda9875_queryctrl,
-	.g_ctrl = tda9875_g_ctrl,
+static const struct v4l2_ctrl_ops tda9875_ctrl_ops = {
 	.s_ctrl = tda9875_s_ctrl,
 };
 
+static const struct v4l2_subdev_core_ops tda9875_core_ops = {
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
+};
+
 static const struct v4l2_subdev_ops tda9875_ops = {
 	.core = &tda9875_core_ops,
 };
@@ -366,18 +267,39 @@ static int tda9875_probe(struct i2c_client *client,
 		return -ENOMEM;
 	sd = &t->sd;
 	v4l2_i2c_subdev_init(sd, client, &tda9875_ops);
-
+	v4l2_ctrl_handler_init(&t->hdl, 4);
+	t->volume = v4l2_ctrl_new_std(&t->hdl, &tda9875_ctrl_ops,
+		V4L2_CID_AUDIO_VOLUME, -84, 24, 1, 13);
+	t->balance = v4l2_ctrl_new_std(&t->hdl, &tda9875_ctrl_ops,
+		V4L2_CID_AUDIO_BALANCE, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&t->hdl, &tda9875_ctrl_ops,
+		V4L2_CID_AUDIO_BASS, -12, 15, 1, 0);
+	v4l2_ctrl_new_std(&t->hdl, &tda9875_ctrl_ops,
+		V4L2_CID_AUDIO_TREBLE, -12, 12, 1, 0);
+	sd->ctrl_handler = &t->hdl;
+	if (t->hdl.error) {
+		int err = t->hdl.error;
+
+		v4l2_ctrl_handler_free(&t->hdl);
+		kfree(t);
+		return err;
+	}
+	v4l2_ctrl_cluster(2, &t->volume);
 	do_tda9875_init(sd);
+	v4l2_ctrl_handler_setup(&t->hdl);
+
 	return 0;
 }
 
 static int tda9875_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct tda9875 *t = to_state(sd);
 
 	do_tda9875_init(sd);
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_state(sd));
+	v4l2_ctrl_handler_free(&t->hdl);
+	kfree(t);
 	return 0;
 }
 
-- 
1.7.0.4

