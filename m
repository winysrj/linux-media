Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4901 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620Ab1FKPFo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 11:05:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 4/5] tuner-core: fix s_std and s_tuner.
Date: Sat, 11 Jun 2011 17:05:30 +0200
Message-Id: <47b1f3efad3f5f8a92ff44f857c3bafa35a8ef02.1307804332.git.hans.verkuil@cisco.com>
In-Reply-To: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <980897e53f7cc2ec9bbbf58d9d451ee56a249309.1307804332.git.hans.verkuil@cisco.com>
References: <980897e53f7cc2ec9bbbf58d9d451ee56a249309.1307804332.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Both s_std and s_tuner are broken because set_mode_freq is called before the
new std (for s_std) and audmode (for s_tuner) are set.

This patch splits set_mode_freq in a set_mode and a set_freq and in s_std
first calls set_mode, and if that returns true (i.e. the mode is supported)
then they set t->std/t->audmode and call set_freq.

This fixes a bug where changing std or audmode would actually change it to
the previous value.

Discovered while testing analog TV standards for cx18 with a tda18271 tuner.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/tuner-core.c |   57 ++++++++++++++++++++-----------------
 1 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 462a8f4..e5ec145 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -739,19 +739,15 @@ static bool supported_mode(struct tuner *t, enum v4l2_tuner_type mode)
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
  * debug message and returns false, changing its state to standby.
- * Otherwise, changes the state and sets frequency to the last value
- * and returns true.
+ * Otherwise, changes the state and returns true.
  */
-static bool set_mode_freq(struct i2c_client *client, struct tuner *t,
-			 enum v4l2_tuner_type mode, unsigned int freq)
+static bool set_mode(struct tuner *t, enum v4l2_tuner_type mode)
 {
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 
@@ -767,17 +763,27 @@ static bool set_mode_freq(struct i2c_client *client, struct tuner *t,
 		t->mode = mode;
 		tuner_dbg("Changing to mode %d\n", mode);
 	}
+	return true;
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
-	return true;
 }
 
 /*
@@ -1034,9 +1040,9 @@ static void tuner_status(struct dvb_frontend *fe)
 static int tuner_s_radio(struct v4l2_subdev *sd)
 {
 	struct tuner *t = to_tuner(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	set_mode_freq(client, t, V4L2_TUNER_RADIO, 0);
+	set_mode(t, V4L2_TUNER_RADIO);
+	set_freq(t, 0);
 	return 0;
 }
 
@@ -1068,24 +1074,23 @@ static int tuner_s_power(struct v4l2_subdev *sd, int on)
 static int tuner_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 {
 	struct tuner *t = to_tuner(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (!set_mode_freq(client, t, V4L2_TUNER_ANALOG_TV, 0))
+	if (!set_mode(t, V4L2_TUNER_ANALOG_TV))
 		return 0;
 
 	t->std = tuner_fixup_std(t, std);
 	if (t->std != std)
 		tuner_dbg("Fixup standard %llx to %llx\n", std, t->std);
-
+	set_freq(t, 0);
 	return 0;
 }
 
 static int tuner_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 {
 	struct tuner *t = to_tuner(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	set_mode_freq(client, t, f->type, f->frequency);
+	if (set_mode(t, f->type))
+		set_freq(t, f->frequency);
 	return 0;
 }
 
@@ -1154,13 +1159,13 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 {
 	struct tuner *t = to_tuner(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (!set_mode_freq(client, t, vt->type, 0))
+	if (!set_mode(t, vt->type))
 		return 0;
 
 	if (t->mode == V4L2_TUNER_RADIO)
 		t->audmode = vt->audmode;
+	set_freq(t, 0);
 
 	return 0;
 }
@@ -1195,8 +1200,8 @@ static int tuner_resume(struct i2c_client *c)
 	tuner_dbg("resume\n");
 
 	if (!t->standby)
-		set_mode_freq(c, t, t->type, 0);
-
+		if (set_mode(t, t->type))
+			set_freq(t, 0);
 	return 0;
 }
 
-- 
1.7.1

