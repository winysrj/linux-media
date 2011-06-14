Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4272 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1FNHOx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 03:14:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv6 PATCH 01/10] tuner-core: fix s_std and s_tuner.
Date: Tue, 14 Jun 2011 09:14:33 +0200
Message-Id: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
In-Reply-To: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
References: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Both s_std and s_tuner are broken because set_mode_freq is called before the
new std (for s_std) and audmode (for s_tuner) are set.

This patch splits set_mode_freq in a set_mode and a set_freq and in s_std/s_tuner
first calls set_mode, and if that returns 0 (i.e. the mode is supported)
then they set t->std/t->audmode and call set_freq.

This fixes a bug where changing std or audmode would actually change it to
the previous value.

Discovered while testing analog TV standards for cx18 with a tda18271 tuner.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/tuner-core.c |   59 ++++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 5748d04..accd9d4 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -742,19 +742,15 @@ static inline int check_mode(struct tuner *t, enum v4l2_tuner_type mode)
 }
 
 /**
- * set_mode_freq - Switch tuner to other mode.
- * @client:	struct i2c_client pointer
+ * set_mode - Switch tuner to other mode.
  * @t:		a pointer to the module's internal struct_tuner
  * @mode:	enum v4l2_type (radio or TV)
- * @freq:	frequency to set (0 means to use the previous one)
  *
  * If tuner doesn't support the needed mode (radio or TV), prints a
  * debug message and returns -EINVAL, changing its state to standby.
- * Otherwise, changes the state and sets frequency to the last value, if
- * the tuner can sleep or if it supports both Radio and TV.
+ * Otherwise, changes the mode and returns 0.
  */
-static int set_mode_freq(struct i2c_client *client, struct tuner *t,
-			 enum v4l2_tuner_type mode, unsigned int freq)
+static int set_mode(struct tuner *t, enum v4l2_tuner_type mode)
 {
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 
@@ -770,17 +766,27 @@ static int set_mode_freq(struct i2c_client *client, struct tuner *t,
 		t->mode = mode;
 		tuner_dbg("Changing to mode %d\n", mode);
 	}
+	return 0;
+}
+
+/**
+ * set_freq - Set the tuner to the desired frequency.
+ * @t:		a pointer to the module's internal struct_tuner
+ * @freq:	frequency to set (0 means to use the current frequency)
+ */
+static void set_freq(struct tuner *t, unsigned int freq)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&t->sd);
+
 	if (t->mode == V4L2_TUNER_RADIO) {
-		if (freq)
-			t->radio_freq = freq;
-		set_radio_freq(client, t->radio_freq);
+		if (!freq)
+			freq = t->radio_freq;
+		set_radio_freq(client, freq);
 	} else {
-		if (freq)
-			t->tv_freq = freq;
-		set_tv_freq(client, t->tv_freq);
+		if (!freq)
+			freq = t->tv_freq;
+		set_tv_freq(client, freq);
 	}
-
-	return 0;
 }
 
 /*
@@ -1076,10 +1082,9 @@ static void tuner_status(struct dvb_frontend *fe)
 static int tuner_s_radio(struct v4l2_subdev *sd)
 {
 	struct tuner *t = to_tuner(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (set_mode_freq(client, t, V4L2_TUNER_RADIO, 0) == -EINVAL)
-		return 0;
+	if (set_mode(t, V4L2_TUNER_RADIO) == 0)
+		set_freq(t, 0);
 	return 0;
 }
 
@@ -1111,25 +1116,22 @@ static int tuner_s_power(struct v4l2_subdev *sd, int on)
 static int tuner_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 {
 	struct tuner *t = to_tuner(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (set_mode_freq(client, t, V4L2_TUNER_ANALOG_TV, 0) == -EINVAL)
+	if (set_mode(t, V4L2_TUNER_ANALOG_TV))
 		return 0;
 
 	t->std = std;
 	tuner_fixup_std(t);
-
+	set_freq(t, 0);
 	return 0;
 }
 
 static int tuner_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 {
 	struct tuner *t = to_tuner(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (set_mode_freq(client, t, f->type, f->frequency) == -EINVAL)
-		return 0;
 
+	if (set_mode(t, f->type) == 0)
+		set_freq(t, f->frequency);
 	return 0;
 }
 
@@ -1198,13 +1200,13 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 {
 	struct tuner *t = to_tuner(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (set_mode_freq(client, t, vt->type, 0) == -EINVAL)
+	if (set_mode(t, vt->type))
 		return 0;
 
 	if (t->mode == V4L2_TUNER_RADIO)
 		t->audmode = vt->audmode;
+	set_freq(t, 0);
 
 	return 0;
 }
@@ -1239,7 +1241,8 @@ static int tuner_resume(struct i2c_client *c)
 	tuner_dbg("resume\n");
 
 	if (!t->standby)
-		set_mode_freq(c, t, t->type, 0);
+		if (set_mode(t, t->type) == 0)
+			set_freq(t, 0);
 
 	return 0;
 }
-- 
1.7.1

