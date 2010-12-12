Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3428 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab0LLRcG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:06 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MA002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:03 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 02/19] tvaudio: use the control framework, fix vol/balance bugs
Date: Sun, 12 Dec 2010 18:31:44 +0100
Message-Id: <bbfe0d5b715de46058b6c4f64669d831cbb2f77f.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Implement the control framework in tvaudio.

While doing that I noticed that the handling of balance was completely
broken. It's now fixed.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/tvaudio.c |  221 ++++++++++++++---------------------------
 1 files changed, 75 insertions(+), 146 deletions(-)

diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index a25e2b5..e1534f8 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -35,6 +35,7 @@
 #include <media/tvaudio.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 
 #include <media/i2c-addr.h>
 
@@ -87,13 +88,13 @@ struct CHIPDESC {
 	audiocmd   init;
 
 	/* which register has which value */
-	int    leftreg,rightreg,treblereg,bassreg;
+	int    leftreg, rightreg, treblereg, bassreg;
 
-	/* initialize with (defaults to 65535/65535/32768/32768 */
-	int    leftinit,rightinit,trebleinit,bassinit;
+	/* initialize with (defaults to 65535/32768/32768 */
+	int    volinit, trebleinit, bassinit;
 
 	/* functions to convert the values (v4l -> chip) */
-	getvalue volfunc,treblefunc,bassfunc;
+	getvalue volfunc, treblefunc, bassfunc;
 
 	/* get/set mode */
 	getmode  getmode;
@@ -109,6 +110,12 @@ struct CHIPDESC {
 /* current state of the chip */
 struct CHIPSTATE {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	struct {
+		/* volume/balance cluster */
+		struct v4l2_ctrl *volume;
+		struct v4l2_ctrl *balance;
+	};
 
 	/* chip-specific description - should point to
 	   an entry at CHIPDESC table */
@@ -118,7 +125,7 @@ struct CHIPSTATE {
 	audiocmd   shadow;
 
 	/* current settings */
-	__u16 left,right,treble,bass,muted,mode;
+	u16 muted, mode;
 	int prevmode;
 	int radio;
 	int input;
@@ -135,6 +142,11 @@ static inline struct CHIPSTATE *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct CHIPSTATE, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct CHIPSTATE, hdl)->sd;
+}
+
 
 /* ---------------------------------------------------------------------- */
 /* i2c I/O functions                                                      */
@@ -1450,8 +1462,7 @@ static struct CHIPDESC chiplist[] = {
 		.rightreg   = TDA9875_MVR,
 		.bassreg    = TDA9875_MBA,
 		.treblereg  = TDA9875_MTR,
-		.leftinit   = 58880,
-		.rightinit  = 58880,
+		.volinit    = 58880,
 	},
 	{
 		.name       = "tda9850",
@@ -1607,118 +1618,39 @@ static struct CHIPDESC chiplist[] = {
 
 /* ---------------------------------------------------------------------- */
 
-static int tvaudio_g_ctrl(struct v4l2_subdev *sd,
-			    struct v4l2_control *ctrl)
+static int tvaudio_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct CHIPSTATE *chip = to_state(sd);
 	struct CHIPDESC *desc = chip->desc;
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		if (!(desc->flags & CHIP_HAS_INPUTSEL))
-			break;
-		ctrl->value=chip->muted;
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		if (!(desc->flags & CHIP_HAS_VOLUME))
-			break;
-		ctrl->value = max(chip->left,chip->right);
-		return 0;
-	case V4L2_CID_AUDIO_BALANCE:
-	{
-		int volume;
-		if (!(desc->flags & CHIP_HAS_VOLUME))
-			break;
-		volume = max(chip->left,chip->right);
-		if (volume)
-			ctrl->value=(32768*min(chip->left,chip->right))/volume;
-		else
-			ctrl->value=32768;
-		return 0;
-	}
-	case V4L2_CID_AUDIO_BASS:
-		if (!(desc->flags & CHIP_HAS_BASSTREBLE))
-			break;
-		ctrl->value = chip->bass;
-		return 0;
-	case V4L2_CID_AUDIO_TREBLE:
-		if (!(desc->flags & CHIP_HAS_BASSTREBLE))
-			break;
-		ctrl->value = chip->treble;
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static int tvaudio_s_ctrl(struct v4l2_subdev *sd,
-			    struct v4l2_control *ctrl)
-{
-	struct CHIPSTATE *chip = to_state(sd);
-	struct CHIPDESC *desc = chip->desc;
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		if (!(desc->flags & CHIP_HAS_INPUTSEL))
-			break;
-
-		if (ctrl->value < 0 || ctrl->value >= 2)
-			return -ERANGE;
-		chip->muted = ctrl->value;
+		chip->muted = ctrl->val;
 		if (chip->muted)
 			chip_write_masked(chip,desc->inputreg,desc->inputmute,desc->inputmask);
 		else
 			chip_write_masked(chip,desc->inputreg,
 					desc->inputmap[chip->input],desc->inputmask);
 		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-	{
-		int volume,balance;
-
-		if (!(desc->flags & CHIP_HAS_VOLUME))
-			break;
-
-		volume = max(chip->left,chip->right);
-		if (volume)
-			balance=(32768*min(chip->left,chip->right))/volume;
-		else
-			balance=32768;
-
-		volume=ctrl->value;
-		chip->left = (min(65536 - balance,32768) * volume) / 32768;
-		chip->right = (min(balance,volume *(__u16)32768)) / 32768;
+	case V4L2_CID_AUDIO_VOLUME: {
+		u32 volume, balance;
+		u32 left, right;
 
-		chip_write(chip,desc->leftreg,desc->volfunc(chip->left));
-		chip_write(chip,desc->rightreg,desc->volfunc(chip->right));
-
-		return 0;
-	}
-	case V4L2_CID_AUDIO_BALANCE:
-	{
-		int volume, balance;
-		if (!(desc->flags & CHIP_HAS_VOLUME))
-			break;
-
-		volume = max(chip->left,chip->right);
-		balance = ctrl->value;
-
-		chip_write(chip,desc->leftreg,desc->volfunc(chip->left));
-		chip_write(chip,desc->rightreg,desc->volfunc(chip->right));
+		volume = chip->volume->val;
+		balance = chip->balance->val;
+		left = (min(65536U - balance, 32768U) * volume) / 32768U;
+		right = (min(balance, 32768U) * volume) / 32768U;
 
+		chip_write(chip, desc->leftreg, desc->volfunc(left));
+		chip_write(chip, desc->rightreg, desc->volfunc(right));
 		return 0;
 	}
 	case V4L2_CID_AUDIO_BASS:
-		if (!(desc->flags & CHIP_HAS_BASSTREBLE))
-			break;
-		chip->bass = ctrl->value;
-		chip_write(chip,desc->bassreg,desc->bassfunc(chip->bass));
-
+		chip_write(chip, desc->bassreg, desc->bassfunc(ctrl->val));
 		return 0;
 	case V4L2_CID_AUDIO_TREBLE:
-		if (!(desc->flags & CHIP_HAS_BASSTREBLE))
-			break;
-		chip->treble = ctrl->value;
-		chip_write(chip,desc->treblereg,desc->treblefunc(chip->treble));
-
+		chip_write(chip, desc->treblereg, desc->treblefunc(ctrl->val));
 		return 0;
 	}
 	return -EINVAL;
@@ -1738,35 +1670,6 @@ static int tvaudio_s_radio(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static int tvaudio_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	struct CHIPSTATE *chip = to_state(sd);
-	struct CHIPDESC *desc = chip->desc;
-
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		if (desc->flags & CHIP_HAS_INPUTSEL)
-			return v4l2_ctrl_query_fill(qc, 0, 1, 1, 0);
-		break;
-	case V4L2_CID_AUDIO_VOLUME:
-		if (desc->flags & CHIP_HAS_VOLUME)
-			return v4l2_ctrl_query_fill(qc, 0, 65535, 65535 / 100, 58880);
-		break;
-	case V4L2_CID_AUDIO_BALANCE:
-		if (desc->flags & CHIP_HAS_VOLUME)
-			return v4l2_ctrl_query_fill(qc, 0, 65535, 65535 / 100, 32768);
-		break;
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-		if (desc->flags & CHIP_HAS_BASSTREBLE)
-			return v4l2_ctrl_query_fill(qc, 0, 65535, 65535 / 100, 32768);
-		break;
-	default:
-		break;
-	}
-	return -EINVAL;
-}
-
 static int tvaudio_s_routing(struct v4l2_subdev *sd,
 			     u32 input, u32 output, u32 config)
 {
@@ -1893,11 +1796,19 @@ static int tvaudio_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ide
 
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops tvaudio_ctrl_ops = {
+	.s_ctrl = tvaudio_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops tvaudio_core_ops = {
 	.g_chip_ident = tvaudio_g_chip_ident,
-	.queryctrl = tvaudio_queryctrl,
-	.g_ctrl = tvaudio_g_ctrl,
-	.s_ctrl = tvaudio_s_ctrl,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 	.s_std = tvaudio_s_std,
 };
 
@@ -1982,6 +1893,10 @@ static int tvaudio_probe(struct i2c_client *client, const struct i2c_device_id *
 	else
 		chip_cmd(chip, "init", &desc->init);
 
+	v4l2_ctrl_handler_init(&chip->hdl, 5);
+	if (desc->flags & CHIP_HAS_INPUTSEL)
+		v4l2_ctrl_new_std(&chip->hdl, &tvaudio_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
 	if (desc->flags & CHIP_HAS_VOLUME) {
 		if (!desc->volfunc) {
 			/* This shouldn't be happen. Warn user, but keep working
@@ -1990,12 +1905,14 @@ static int tvaudio_probe(struct i2c_client *client, const struct i2c_device_id *
 			v4l2_info(sd, "volume callback undefined!\n");
 			desc->flags &= ~CHIP_HAS_VOLUME;
 		} else {
-			chip->left  = desc->leftinit  ? desc->leftinit  : 65535;
-			chip->right = desc->rightinit ? desc->rightinit : 65535;
-			chip_write(chip, desc->leftreg,
-				   desc->volfunc(chip->left));
-			chip_write(chip, desc->rightreg,
-				   desc->volfunc(chip->right));
+			chip->volume = v4l2_ctrl_new_std(&chip->hdl,
+				&tvaudio_ctrl_ops, V4L2_CID_AUDIO_VOLUME,
+				0, 65535, 65535 / 100,
+				desc->volinit ? desc->volinit : 65535);
+			chip->balance = v4l2_ctrl_new_std(&chip->hdl,
+				&tvaudio_ctrl_ops, V4L2_CID_AUDIO_BALANCE,
+				0, 65535, 65535 / 100, 32768);
+			v4l2_ctrl_cluster(2, &chip->volume);
 		}
 	}
 	if (desc->flags & CHIP_HAS_BASSTREBLE) {
@@ -2006,17 +1923,28 @@ static int tvaudio_probe(struct i2c_client *client, const struct i2c_device_id *
 			v4l2_info(sd, "bass/treble callbacks undefined!\n");
 			desc->flags &= ~CHIP_HAS_BASSTREBLE;
 		} else {
-			chip->treble = desc->trebleinit ?
-						desc->trebleinit : 32768;
-			chip->bass   = desc->bassinit   ?
-						desc->bassinit   : 32768;
-			chip_write(chip, desc->bassreg,
-				   desc->bassfunc(chip->bass));
-			chip_write(chip, desc->treblereg,
-				   desc->treblefunc(chip->treble));
+			v4l2_ctrl_new_std(&chip->hdl,
+				&tvaudio_ctrl_ops, V4L2_CID_AUDIO_BASS,
+				0, 65535, 65535 / 100,
+				desc->bassinit ? desc->bassinit : 32768);
+			v4l2_ctrl_new_std(&chip->hdl,
+				&tvaudio_ctrl_ops, V4L2_CID_AUDIO_TREBLE,
+				0, 65535, 65535 / 100,
+				desc->trebleinit ? desc->trebleinit : 32768);
 		}
 	}
 
+	sd->ctrl_handler = &chip->hdl;
+	if (chip->hdl.error) {
+		int err = chip->hdl.error;
+
+		v4l2_ctrl_handler_free(&chip->hdl);
+		kfree(chip);
+		return err;
+	}
+	/* set controls to the default values */
+	v4l2_ctrl_handler_setup(&chip->hdl);
+
 	chip->thread = NULL;
 	init_timer(&chip->wt);
 	if (desc->flags & CHIP_NEED_CHECKMODE) {
@@ -2052,6 +1980,7 @@ static int tvaudio_remove(struct i2c_client *client)
 	}
 
 	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&chip->hdl);
 	kfree(chip);
 	return 0;
 }
-- 
1.7.0.4

