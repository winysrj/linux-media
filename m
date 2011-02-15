Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab1BONhz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 08:37:55 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1FDbtZT001211
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 15 Feb 2011 08:37:55 -0500
Received: from pedra (vpn-239-107.phx2.redhat.com [10.3.239.107])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p1FDXmP3005481
	for <linux-media@vger.kernel.org>; Tue, 15 Feb 2011 08:37:55 -0500
Date: Tue, 15 Feb 2011 11:33:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] [media] tuner-core: Rearrange some functions to better
 document
Message-ID: <20110215113335.01162415@pedra>
In-Reply-To: <cover.1297776328.git.mchehab@redhat.com>
References: <cover.1297776328.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Group a few functions together and add/fix comments for each
block of the driver.

This is just a cleanup patch meant to improve driver readability.
No functional changes in this patch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 2c7fe18..a91a299 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -251,7 +251,7 @@ static struct analog_demod_ops tuner_analog_ops = {
 };
 
 /*
- * Functions to select between radio and TV and tuner probe functions
+ * Functions to select between radio and TV and tuner probe/remove functions
  */
 
 /**
@@ -698,6 +698,75 @@ static int tuner_remove(struct i2c_client *client)
 }
 
 /*
+ * Functions to switch between Radio and TV
+ *
+ * A few cards have a separate I2C tuner for radio. Those routines
+ * take care of switching between TV/Radio mode, filtering only the
+ * commands that apply to the Radio or TV tuner.
+ */
+
+/**
+ * check_mode - Verify if tuner supports the requested mode
+ * @t: a pointer to the module's internal struct_tuner
+ *
+ * This function checks if the tuner is capable of tuning analog TV,
+ * digital TV or radio, depending on what the caller wants. If the
+ * tuner can't support that mode, it returns -EINVAL. Otherwise, it
+ * returns 0.
+ * This function is needed for boards that have a separate tuner for
+ * radio (like devices with tea5767).
+ */
+static inline int check_mode(struct tuner *t, enum v4l2_tuner_type mode)
+{
+	if ((1 << mode & t->mode_mask) == 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * set_mode_freq - Switch tuner to other mode.
+ * @client:	struct i2c_client pointer
+ * @t:		a pointer to the module's internal struct_tuner
+ * @mode:	enum v4l2_type (radio or TV)
+ * @freq:	frequency to set (0 means to use the previous one)
+ *
+ * If tuner doesn't support the needed mode (radio or TV), prints a
+ * debug message and returns -EINVAL, changing its state to standby.
+ * Otherwise, changes the state and sets frequency to the last value, if
+ * the tuner can sleep or if it supports both Radio and TV.
+ */
+static int set_mode_freq(struct i2c_client *client, struct tuner *t,
+			 enum v4l2_tuner_type mode, unsigned int freq)
+{
+	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
+
+	if (mode != t->mode) {
+		if (check_mode(t, mode) == -EINVAL) {
+			tuner_dbg("Tuner doesn't support mode %d. "
+				  "Putting tuner to sleep\n", mode);
+			t->standby = true;
+			if (analog_ops->standby)
+				analog_ops->standby(&t->fe);
+			return -EINVAL;
+		}
+		t->mode = mode;
+		tuner_dbg("Changing to mode %d\n", mode);
+	}
+	if (t->mode == V4L2_TUNER_RADIO) {
+		if (freq)
+			t->radio_freq = freq;
+		set_radio_freq(client, t->radio_freq);
+	} else {
+		if (freq)
+			t->tv_freq = freq;
+		set_tv_freq(client, t->tv_freq);
+	}
+
+	return 0;
+}
+
+/*
  * Functions that are specific for TV mode
  */
 
@@ -925,66 +994,9 @@ static void set_radio_freq(struct i2c_client *c, unsigned int freq)
 	analog_ops->set_params(&t->fe, &params);
 }
 
-/**
- * check_mode - Verify if tuner supports the requested mode
- * @t: a pointer to the module's internal struct_tuner
- *
- * This function checks if the tuner is capable of tuning analog TV,
- * digital TV or radio, depending on what the caller wants. If the
- * tuner can't support that mode, it returns -EINVAL. Otherwise, it
- * returns 0.
- * This function is needed for boards that have a separate tuner for
- * radio (like devices with tea5767).
+/*
+ * Debug function for reporting tuner status to userspace
  */
-static inline int check_mode(struct tuner *t, enum v4l2_tuner_type mode)
-{
-	if ((1 << mode & t->mode_mask) == 0)
-		return -EINVAL;
-
-	return 0;
-}
-
-/**
- * set_mode_freq - Switch tuner to other mode.
- * @client:	struct i2c_client pointer
- * @t:		a pointer to the module's internal struct_tuner
- * @mode:	enum v4l2_type (radio or TV)
- * @freq:	frequency to set (0 means to use the previous one)
- *
- * If tuner doesn't support the needed mode (radio or TV), prints a
- * debug message and returns -EINVAL, changing internal state to T_STANDBY.
- * Otherwise, changes the state and sets frequency to the last value, if
- * the tuner can sleep or if it supports both Radio and TV.
- */
-static int set_mode_freq(struct i2c_client *client, struct tuner *t,
-			 enum v4l2_tuner_type mode, unsigned int freq)
-{
-	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
-
-	if (mode != t->mode) {
-		if (check_mode(t, mode) == -EINVAL) {
-			tuner_dbg("Tuner doesn't support mode %d. "
-				  "Putting tuner to sleep\n", mode);
-			t->standby = true;
-			if (analog_ops->standby)
-				analog_ops->standby(&t->fe);
-			return -EINVAL;
-		}
-		t->mode = mode;
-		tuner_dbg("Changing to mode %d\n", mode);
-	}
-	if (t->mode == V4L2_TUNER_RADIO) {
-		if (freq)
-			t->radio_freq = freq;
-		set_radio_freq(client, t->radio_freq);
-	} else {
-		if (freq)
-			t->tv_freq = freq;
-		set_tv_freq(client, t->tv_freq);
-	}
-
-	return 0;
-}
 
 /**
  * tuner_status - Dumps the current tuner status at dmesg
@@ -1040,6 +1052,24 @@ static void tuner_status(struct dvb_frontend *fe)
 			   analog_ops->has_signal(fe));
 }
 
+/*
+ * Function to splicitly change mode to radio. Probably not needed anymore
+ */
+
+static int tuner_s_radio(struct v4l2_subdev *sd)
+{
+	struct tuner *t = to_tuner(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (set_mode_freq(client, t, V4L2_TUNER_RADIO, 0) == -EINVAL)
+		return 0;
+	return 0;
+}
+
+/*
+ * Tuner callbacks to handle userspace ioctl's
+ */
+
 /**
  * tuner_s_power - controls the power state of the tuner
  * @sd: pointer to struct v4l2_subdev
@@ -1061,24 +1091,6 @@ static int tuner_s_power(struct v4l2_subdev *sd, int on)
 	return 0;
 }
 
-/*
- * Function to splicitly change mode to radio. Probably not needed anymore
- */
-
-static int tuner_s_radio(struct v4l2_subdev *sd)
-{
-	struct tuner *t = to_tuner(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (set_mode_freq(client, t, V4L2_TUNER_RADIO, 0) == -EINVAL)
-		return 0;
-	return 0;
-}
-
-/*
- * Tuner callbacks to handle userspace ioctl's
- */
-
 static int tuner_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 {
 	struct tuner *t = to_tuner(sd);
-- 
1.7.1


