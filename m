Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3916 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1FKRso (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 13:48:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 6/6] tuner-core: fix g_frequency and g/s_tuner
Date: Sat, 11 Jun 2011 19:48:35 +0200
Message-Id: <668a48433686f298caf1431a225beba84bf1edb1.1307813916.git.hans.verkuil@cisco.com>
In-Reply-To: <1307814515-17351-1-git-send-email-hverkuil@xs4all.nl>
References: <1307814515-17351-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <980897e53f7cc2ec9bbbf58d9d451ee56a249309.1307813916.git.hans.verkuil@cisco.com>
References: <980897e53f7cc2ec9bbbf58d9d451ee56a249309.1307813916.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

VIDIOC_G_FREQUENCY and VIDIOC_G/S_TUNER should not check the tuner type,
instead that is something the driver fills in.

Since apps will often leave the type at 0, the 'supported_mode' call
will return false and the call just returns.

But the call should only return if the current selected mode is not
supported by this tuner. So add a 'valid_mode' bool to keep track of
that status and use it instead of calling supported_mode().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/tuner-core.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index ffe5de3..094f277 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -127,7 +127,8 @@ struct tuner {
 	unsigned int        audmode;
 
 	enum v4l2_tuner_type mode;
-	unsigned int        mode_mask; /* Combination of allowable modes */
+	unsigned int        mode_mask;  /* Combination of allowable modes */
+	bool                active_mode; /* Current tuner mode is active */
 
 	bool                standby;	/* Standby mode */
 
@@ -597,7 +598,7 @@ static int tuner_probe(struct i2c_client *client,
 	t->name = "(tuner unset)";
 	t->type = UNSET;
 	t->audmode = V4L2_TUNER_MODE_STEREO;
-	t->standby = 1;
+	t->standby = true;
 	t->radio_freq = 87.5 * 16000;	/* Initial freq range */
 	t->tv_freq = 400 * 16; /* Sets freq to VHF High - needed for some PLL's to properly start */
 
@@ -685,6 +686,7 @@ register_client:
 		t->mode = V4L2_TUNER_ANALOG_TV;
 	else
 		t->mode = V4L2_TUNER_RADIO;
+	t->active_mode = true;
 	set_type(client, t->type, t->mode_mask, t->config, t->fe.callback);
 	list_add_tail(&t->list, &tuner_list);
 
@@ -756,11 +758,13 @@ static bool set_mode(struct tuner *t, enum v4l2_tuner_type mode)
 			tuner_dbg("Tuner doesn't support mode %d. "
 				  "Putting tuner to sleep\n", mode);
 			t->standby = true;
+			t->active_mode = false;
 			if (analog_ops->standby)
 				analog_ops->standby(&t->fe);
 			return false;
 		}
 		t->mode = mode;
+		t->active_mode = true;
 		tuner_dbg("Changing to mode %d\n", mode);
 	}
 	return true;
@@ -1034,7 +1038,7 @@ static void tuner_status(struct dvb_frontend *fe)
 }
 
 /*
- * Function to splicitly change mode to radio. Probably not needed anymore
+ * Function to explicitly change mode to radio. Probably not needed anymore
  */
 
 static int tuner_s_radio(struct v4l2_subdev *sd)
@@ -1099,7 +1103,7 @@ static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 	struct tuner *t = to_tuner(sd);
 	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
 
-	if (!supported_mode(t, f->type))
+	if (!t->active_mode)
 		return 0;
 	f->type = t->mode;
 	if (fe_tuner_ops->get_frequency && !t->standby) {
@@ -1122,7 +1126,7 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
 
-	if (!supported_mode(t, vt->type))
+	if (!t->active_mode)
 		return 0;
 	vt->type = t->mode;
 	if (analog_ops->get_afc)
@@ -1160,7 +1164,7 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 {
 	struct tuner *t = to_tuner(sd);
 
-	if (!set_mode(t, vt->type))
+	if (!t->active_mode)
 		return 0;
 
 	if (t->mode == V4L2_TUNER_RADIO) {
-- 
1.7.1

