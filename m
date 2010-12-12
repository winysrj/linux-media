Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2430 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab0LLRcH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:07 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MG002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:05 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 08/19] tda7432: use control framework
Date: Sun, 12 Dec 2010 18:31:50 +0100
Message-Id: <1215a31c216c331f6ef31d115d16e539ef4147c1.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/tda7432.c |  277 ++++++++++++++++-------------------------
 1 files changed, 106 insertions(+), 171 deletions(-)

diff --git a/drivers/media/video/tda7432.c b/drivers/media/video/tda7432.c
index 3941f95..2e430a6 100644
--- a/drivers/media/video/tda7432.c
+++ b/drivers/media/video/tda7432.c
@@ -35,6 +35,7 @@
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 #include <media/i2c-addr.h>
 
 #ifndef VIDEO_AUDIO_BALANCE
@@ -50,7 +51,7 @@ static int loudness; /* disable loudness by default */
 static int debug;	 /* insmod parameter */
 module_param(debug, int, S_IRUGO | S_IWUSR);
 module_param(loudness, int, S_IRUGO);
-MODULE_PARM_DESC(maxvol,"Set maximium volume to +20db (0), default is 0db(1)");
+MODULE_PARM_DESC(maxvol, "Set maximum volume to +20db (0), default is 0db(1)");
 module_param(maxvol, int, S_IRUGO | S_IWUSR);
 
 
@@ -59,13 +60,17 @@ module_param(maxvol, int, S_IRUGO | S_IWUSR);
 
 struct tda7432 {
 	struct v4l2_subdev sd;
-	int addr;
-	int input;
-	int volume;
-	int muted;
-	int bass, treble;
-	int lf, lr, rf, rr;
-	int loud;
+	struct v4l2_ctrl_handler hdl;
+	struct {
+		/* bass/treble cluster */
+		struct v4l2_ctrl *bass;
+		struct v4l2_ctrl *treble;
+	};
+	struct {
+		/* mute/balance cluster */
+		struct v4l2_ctrl *mute;
+		struct v4l2_ctrl *balance;
+	};
 };
 
 static inline struct tda7432 *to_state(struct v4l2_subdev *sd)
@@ -73,6 +78,11 @@ static inline struct tda7432 *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct tda7432, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct tda7432, hdl)->sd;
+}
+
 /* The TDA7432 is made by STS-Thompson
  * http://www.st.com
  * http://us.st.com/stonline/books/pdf/docs/4056.pdf
@@ -226,24 +236,22 @@ static int tda7432_write(struct v4l2_subdev *sd, int subaddr, int val)
 static int tda7432_set(struct v4l2_subdev *sd)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct tda7432 *t = to_state(sd);
 	unsigned char buf[16];
 
-	v4l2_dbg(1, debug, sd,
-		"tda7432: 7432_set(0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x)\n",
-		t->input, t->volume, t->bass, t->treble, t->lf, t->lr,
-		t->rf, t->rr, t->loud);
 	buf[0]  = TDA7432_IN;
-	buf[1]  = t->input;
-	buf[2]  = t->volume;
-	buf[3]  = t->bass;
-	buf[4]	= t->treble;
-	buf[5]  = t->lf;
-	buf[6]  = t->lr;
-	buf[7]  = t->rf;
-	buf[8]  = t->rr;
-	buf[9]  = t->loud;
-	if (10 != i2c_master_send(client, buf, 10)) {
+	buf[1]  = TDA7432_STEREO_IN |  /* Main (stereo) input   */
+		  TDA7432_BASS_SYM  |  /* Symmetric bass cut    */
+		  TDA7432_BASS_NORM;   /* Normal bass range     */
+	buf[2]  = 0x3b;
+	if (loudness)			 /* Turn loudness on?     */
+		buf[2] |= TDA7432_LD_ON;
+	buf[3]  = TDA7432_TREBLE_0DB | (TDA7432_BASS_0DB << 4);
+	buf[4]  = TDA7432_ATTEN_0DB;
+	buf[5]  = TDA7432_ATTEN_0DB;
+	buf[6]  = TDA7432_ATTEN_0DB;
+	buf[7]  = TDA7432_ATTEN_0DB;
+	buf[8]  = loudness;
+	if (9 != i2c_master_send(client, buf, 9)) {
 		v4l2_err(sd, "I/O error, trying tda7432_set\n");
 		return -1;
 	}
@@ -251,174 +259,77 @@ static int tda7432_set(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static void do_tda7432_init(struct v4l2_subdev *sd)
-{
-	struct tda7432 *t = to_state(sd);
-
-	v4l2_dbg(2, debug, sd, "In tda7432_init\n");
-
-	t->input  = TDA7432_STEREO_IN |  /* Main (stereo) input   */
-		    TDA7432_BASS_SYM  |  /* Symmetric bass cut    */
-		    TDA7432_BASS_NORM;   /* Normal bass range     */
-	t->volume =  0x3b ;				 /* -27dB Volume            */
-	if (loudness)			 /* Turn loudness on?     */
-		t->volume |= TDA7432_LD_ON;
-	t->muted    = 1;
-	t->treble   = TDA7432_TREBLE_0DB; /* 0dB Treble            */
-	t->bass		= TDA7432_BASS_0DB; 	 /* 0dB Bass              */
-	t->lf     = TDA7432_ATTEN_0DB;	 /* 0dB attenuation       */
-	t->lr     = TDA7432_ATTEN_0DB;	 /* 0dB attenuation       */
-	t->rf     = TDA7432_ATTEN_0DB;	 /* 0dB attenuation       */
-	t->rr     = TDA7432_ATTEN_0DB;	 /* 0dB attenuation       */
-	t->loud   = loudness;		 /* insmod parameter      */
-
-	tda7432_set(sd);
-}
-
-static int tda7432_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct tda7432 *t = to_state(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value=t->muted;
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		if (!maxvol){  /* max +20db */
-			ctrl->value = ( 0x6f - (t->volume & 0x7F) ) * 630;
-		} else {       /* max 0db   */
-			ctrl->value = ( 0x6f - (t->volume & 0x7F) ) * 829;
-		}
-		return 0;
-	case V4L2_CID_AUDIO_BALANCE:
-	{
-		if ( (t->lf) < (t->rf) )
-			/* right is attenuated, balance shifted left */
-			ctrl->value = (32768 - 1057*(t->rf));
-		else
-			/* left is attenuated, balance shifted right */
-			ctrl->value = (32768 + 1057*(t->lf));
-		return 0;
-	}
-	case V4L2_CID_AUDIO_BASS:
-	{
-		/* Bass/treble 4 bits each */
-		int bass=t->bass;
-		if(bass >= 0x8)
-			bass = ~(bass - 0x8) & 0xf;
-		ctrl->value = (bass << 12)+(bass << 8)+(bass << 4)+(bass);
-		return 0;
-	}
-	case V4L2_CID_AUDIO_TREBLE:
-	{
-		int treble=t->treble;
-		if(treble >= 0x8)
-			treble = ~(treble - 0x8) & 0xf;
-		ctrl->value = (treble << 12)+(treble << 8)+(treble << 4)+(treble);
-		return 0;
-	}
-	}
-	return -EINVAL;
-}
-
-static int tda7432_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int tda7432_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct tda7432 *t = to_state(sd);
+	u8 bass, treble, volume;
+	u8 lf, lr, rf, rr;
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		t->muted=ctrl->value;
-		break;
-	case V4L2_CID_AUDIO_VOLUME:
-		if(!maxvol){ /* max +20db */
-			t->volume = 0x6f - ((ctrl->value)/630);
-		} else {    /* max 0db   */
-			t->volume = 0x6f - ((ctrl->value)/829);
-		}
-		if (loudness)		/* Turn on the loudness bit */
-			t->volume |= TDA7432_LD_ON;
-
-		tda7432_write(sd, TDA7432_VL, t->volume);
-		return 0;
-	case V4L2_CID_AUDIO_BALANCE:
-		if (ctrl->value < 32768) {
+		if (t->balance->val < 0) {
 			/* shifted to left, attenuate right */
-			t->rr = (32768 - ctrl->value)/1057;
-			t->rf = t->rr;
-			t->lr = TDA7432_ATTEN_0DB;
-			t->lf = TDA7432_ATTEN_0DB;
-		} else if(ctrl->value > 32769) {
+			rr = rf = -t->balance->val;
+			lr = lf = TDA7432_ATTEN_0DB;
+		} else if (t->balance->val > 0) {
 			/* shifted to right, attenuate left */
-			t->lf = (ctrl->value - 32768)/1057;
-			t->lr = t->lf;
-			t->rr = TDA7432_ATTEN_0DB;
-			t->rf = TDA7432_ATTEN_0DB;
+			rr = rf = TDA7432_ATTEN_0DB;
+			lr = lf = t->balance->val;
 		} else {
 			/* centered */
-			t->rr = TDA7432_ATTEN_0DB;
-			t->rf = TDA7432_ATTEN_0DB;
-			t->lf = TDA7432_ATTEN_0DB;
-			t->lr = TDA7432_ATTEN_0DB;
+			rr = rf = TDA7432_ATTEN_0DB;
+			lr = lf = TDA7432_ATTEN_0DB;
 		}
-		break;
-	case V4L2_CID_AUDIO_BASS:
-		t->bass = ctrl->value >> 12;
-		if(t->bass>= 0x8)
-				t->bass = (~t->bass & 0xf) + 0x8 ;
-
-		tda7432_write(sd, TDA7432_TN, 0x10 | (t->bass << 4) | t->treble);
+		if (t->mute->val) {
+			lf |= TDA7432_MUTE;
+			lr |= TDA7432_MUTE;
+			lf |= TDA7432_MUTE;
+			rr |= TDA7432_MUTE;
+		}
+		/* Mute & update balance*/
+		tda7432_write(sd, TDA7432_LF, lf);
+		tda7432_write(sd, TDA7432_LR, lr);
+		tda7432_write(sd, TDA7432_RF, rf);
+		tda7432_write(sd, TDA7432_RR, rr);
 		return 0;
-	case V4L2_CID_AUDIO_TREBLE:
-		t->treble= ctrl->value >> 12;
-		if(t->treble>= 0x8)
-				t->treble = (~t->treble & 0xf) + 0x8 ;
+	case V4L2_CID_AUDIO_VOLUME:
+		volume = 0x6f - ctrl->val;
+		if (loudness)		/* Turn on the loudness bit */
+			volume |= TDA7432_LD_ON;
 
-		tda7432_write(sd, TDA7432_TN, 0x10 | (t->bass << 4) | t->treble);
+		tda7432_write(sd, TDA7432_VL, volume);
 		return 0;
-	default:
-		return -EINVAL;
-	}
-
-	/* Used for both mute and balance changes */
-	if (t->muted)
-	{
-		/* Mute & update balance*/
-		tda7432_write(sd, TDA7432_LF, t->lf | TDA7432_MUTE);
-		tda7432_write(sd, TDA7432_LR, t->lr | TDA7432_MUTE);
-		tda7432_write(sd, TDA7432_RF, t->rf | TDA7432_MUTE);
-		tda7432_write(sd, TDA7432_RR, t->rr | TDA7432_MUTE);
-	} else {
-		tda7432_write(sd, TDA7432_LF, t->lf);
-		tda7432_write(sd, TDA7432_LR, t->lr);
-		tda7432_write(sd, TDA7432_RF, t->rf);
-		tda7432_write(sd, TDA7432_RR, t->rr);
-	}
-	return 0;
-}
-
-static int tda7432_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(qc, 0, 65535, 65535 / 100, 58880);
-	case V4L2_CID_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 0);
-	case V4L2_CID_AUDIO_BALANCE:
 	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-		return v4l2_ctrl_query_fill(qc, 0, 65535, 65535 / 100, 32768);
+		bass = t->bass->val;
+		treble = t->treble->val;
+		if (bass >= 0x8)
+			bass = 14 - (bass - 8);
+		if (treble >= 0x8)
+			treble = 14 - (treble - 8);
+
+		tda7432_write(sd, TDA7432_TN, 0x10 | (bass << 4) | treble);
+		return 0;
 	}
 	return -EINVAL;
 }
 
 /* ----------------------------------------------------------------------- */
 
-static const struct v4l2_subdev_core_ops tda7432_core_ops = {
-	.queryctrl = tda7432_queryctrl,
-	.g_ctrl = tda7432_g_ctrl,
+static const struct v4l2_ctrl_ops tda7432_ctrl_ops = {
 	.s_ctrl = tda7432_s_ctrl,
 };
 
+static const struct v4l2_subdev_core_ops tda7432_core_ops = {
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
+};
+
 static const struct v4l2_subdev_ops tda7432_ops = {
 	.core = &tda7432_core_ops,
 };
@@ -443,6 +354,28 @@ static int tda7432_probe(struct i2c_client *client,
 		return -ENOMEM;
 	sd = &t->sd;
 	v4l2_i2c_subdev_init(sd, client, &tda7432_ops);
+	v4l2_ctrl_handler_init(&t->hdl, 5);
+	v4l2_ctrl_new_std(&t->hdl, &tda7432_ctrl_ops,
+		V4L2_CID_AUDIO_VOLUME, 0, maxvol ? 0x68 : 0x4f, 1, maxvol ? 0x5d : 0x47);
+	t->mute = v4l2_ctrl_new_std(&t->hdl, &tda7432_ctrl_ops,
+		V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	t->balance = v4l2_ctrl_new_std(&t->hdl, &tda7432_ctrl_ops,
+		V4L2_CID_AUDIO_BALANCE, -31, 31, 1, 0);
+	t->bass = v4l2_ctrl_new_std(&t->hdl, &tda7432_ctrl_ops,
+		V4L2_CID_AUDIO_BASS, 0, 14, 1, 7);
+	t->treble = v4l2_ctrl_new_std(&t->hdl, &tda7432_ctrl_ops,
+		V4L2_CID_AUDIO_TREBLE, 0, 14, 1, 7);
+	sd->ctrl_handler = &t->hdl;
+	if (t->hdl.error) {
+		int err = t->hdl.error;
+
+		v4l2_ctrl_handler_free(&t->hdl);
+		kfree(t);
+		return err;
+	}
+	v4l2_ctrl_cluster(2, &t->bass);
+	v4l2_ctrl_cluster(2, &t->mute);
+	v4l2_ctrl_handler_setup(&t->hdl);
 	if (loudness < 0 || loudness > 15) {
 		v4l2_warn(sd, "loudness parameter must be between 0 and 15\n");
 		if (loudness < 0)
@@ -451,17 +384,19 @@ static int tda7432_probe(struct i2c_client *client,
 			loudness = 15;
 	}
 
-	do_tda7432_init(sd);
+	tda7432_set(sd);
 	return 0;
 }
 
 static int tda7432_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct tda7432 *t = to_state(sd);
 
-	do_tda7432_init(sd);
+	tda7432_set(sd);
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_state(sd));
+	v4l2_ctrl_handler_free(&t->hdl);
+	kfree(t);
 	return 0;
 }
 
-- 
1.7.0.4

