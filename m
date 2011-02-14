Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:35819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab1BNVHf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:07:35 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1EL7ZVQ027691
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:07:35 -0500
Received: from pedra (vpn-239-121.phx2.redhat.com [10.3.239.121])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1EL3TG7012908
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:07:35 -0500
Date: Mon, 14 Feb 2011 19:03:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/14] [media] tuner-core: Some cleanups at
 check_mode/set_mode
Message-ID: <20110214190315.7139dfea@pedra>
In-Reply-To: <cover.1297716906.git.mchehab@redhat.com>
References: <cover.1297716906.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Properly document those functions and do some cleanups around that.
There's just one behavior change on this patchset: it will now restore
TV frequency when changing from radio to TV mode.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 5c3da21..7cdfe3a 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -841,38 +841,39 @@ static void set_radio_freq(struct i2c_client *c, unsigned int freq)
 	analog_ops->set_params(&t->fe, &params);
 }
 
-/*
- * Functions that should be broken into separate radio/TV functions
+/**
+ * check_mode - Verify if tuner supports the requested mode
+ * @t - a pointer to the module's internal struct_tuner
+ *
+ * This function checks if the tuner is capable of tuning analog TV,
+ * digital TV or radio, depending on what the caller wants. If the
+ * tuner can't support that mode, it returns -EINVAL. Otherwise, it
+ * returns 0.
+ * This function is needed for boards that have a separate tuner for
+ * radio (like devices with tea5767).
  */
-
-static inline int check_mode(struct tuner *t, char *cmd)
+static inline int check_mode(struct tuner *t)
 {
 	if ((1 << t->mode & t->mode_mask) == 0) {
 		return -EINVAL;
 	}
-
-	switch (t->mode) {
-	case V4L2_TUNER_RADIO:
-		tuner_dbg("Cmd %s accepted for radio\n", cmd);
-		break;
-	case V4L2_TUNER_ANALOG_TV:
-		tuner_dbg("Cmd %s accepted for analog TV\n", cmd);
-		break;
-	case V4L2_TUNER_DIGITAL_TV:
-		tuner_dbg("Cmd %s accepted for digital TV\n", cmd);
-		break;
-	}
 	return 0;
 }
 
-/*
- * Switch tuner to other mode. If tuner support both tv and radio,
- * set another frequency to some value (This is needed for some pal
- * tuners to avoid locking). Otherwise, just put second tuner in
- * standby mode.
+/**
+ * set_mode - Switch tuner to other mode.
+ * @client - struct i2c_client pointer
+ * @t - a pointer to the module's internal struct_tuner
+ * @mode - enum v4l2_type + T_STANDBY mode
+ * @cmd - string for the command to be executed (for debug messages)
+ *
+ * If tuner doesn't support the needed mode (radio or TV), prints a
+ * debug message and returns -EINVAL, changing internal state to T_STANDBY.
+ * Otherwise, changes the state and sets frequency to the last value, if
+ * the tuner can sleep or if it supports both Radio and TV.
  */
-
-static inline int set_mode(struct i2c_client *client, struct tuner *t, int mode, char *cmd)
+static inline int set_mode(struct i2c_client *client, struct tuner *t,
+			   int mode, char *cmd)
 {
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 
@@ -881,7 +882,7 @@ static inline int set_mode(struct i2c_client *client, struct tuner *t, int mode,
 
 	t->mode = mode;
 
-	if (check_mode(t, cmd) == -EINVAL) {
+	if (check_mode(t) == -EINVAL) {
 		tuner_dbg("Tuner doesn't support this mode. "
 			  "Putting tuner to sleep\n");
 		t->mode = T_STANDBY;
@@ -889,9 +890,22 @@ static inline int set_mode(struct i2c_client *client, struct tuner *t, int mode,
 			analog_ops->standby(&t->fe);
 		return -EINVAL;
 	}
+
+	if (t->mode == V4L2_TUNER_RADIO) {
+		if (t->radio_freq)
+			set_radio_freq(client, t->radio_freq);
+	} else {
+		if (t->tv_freq)
+			set_tv_freq(client, t->tv_freq);
+	}
+
 	return 0;
 }
 
+/*
+ * Functions that should be broken into separate radio/TV functions
+ */
+
 static void set_freq(struct i2c_client *c, unsigned long freq)
 {
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
@@ -959,7 +973,7 @@ static int tuner_s_power(struct v4l2_subdev *sd, int on)
 
 	tuner_dbg("Putting tuner to sleep\n");
 
-	if (check_mode(t, "s_power") == -EINVAL)
+	if (check_mode(t) == -EINVAL)
 		return 0;
 	t->mode = T_STANDBY;
 	if (analog_ops->standby)
@@ -977,8 +991,6 @@ static int tuner_s_radio(struct v4l2_subdev *sd)
 
 	if (set_mode(client, t, V4L2_TUNER_RADIO, "s_radio") == -EINVAL)
 		return 0;
-	if (t->radio_freq)
-		set_freq(client, t->radio_freq);
 	return 0;
 }
 
@@ -1017,7 +1029,7 @@ static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 	struct tuner *t = to_tuner(sd);
 	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
 
-	if (check_mode(t, "g_frequency") == -EINVAL)
+	if (check_mode(t) == -EINVAL)
 		return 0;
 	f->type = t->mode;
 	if (fe_tuner_ops->get_frequency) {
@@ -1040,7 +1052,7 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
 
-	if (check_mode(t, "g_tuner") == -EINVAL)
+	if (check_mode(t) == -EINVAL)
 		return 0;
 
 	vt->type = t->mode;
@@ -1081,7 +1093,7 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	struct tuner *t = to_tuner(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (check_mode(t, "s_tuner") == -EINVAL)
+	if (check_mode(t) == -EINVAL)
 		return 0;
 
 	/* do nothing unless we're a radio tuner */
-- 
1.7.1


