Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:52998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1BNVIh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:08:37 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1EL8b65027838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:08:37 -0500
Received: from pedra (vpn-239-121.phx2.redhat.com [10.3.239.121])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1EL3TG8012908
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:08:36 -0500
Date: Mon, 14 Feb 2011 19:03:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 08/14] [media] tuner-core: Better implement standby mode
Message-ID: <20110214190316.6985b67a@pedra>
In-Reply-To: <cover.1297716906.git.mchehab@redhat.com>
References: <cover.1297716906.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

In the past, T_STANDBY were used on devices with a separate radio tuner to
mark a tuner that were disabled. With the time, it got newer meanings.

Also, due to a bug at the logic, the driver might incorrectly return
T_STANDBY to userspace.

So, instead of keeping the abuse, just use a boolean for storing
such information.

We can't remove T_STANDBY yet, as this is used on two other drivers. A
latter patch will address its usage outside tuner-core.

Thanks-to: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 7cdfe3a..e6855a4 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -115,9 +115,11 @@ struct tuner {
 	unsigned int        radio_freq;
 	unsigned int        audmode;
 
-	unsigned int        mode;
+	enum v4l2_tuner_type mode;
 	unsigned int        mode_mask; /* Combination of allowable modes */
 
+	bool                standby;	/* Standby mode */
+
 	unsigned int        type; /* chip type id */
 	unsigned int        config;
 	const char          *name;
@@ -262,12 +264,6 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		t->fe.callback = tuner_callback;
 	}
 
-	if (t->mode == T_UNINITIALIZED) {
-		tuner_dbg ("tuner 0x%02x: called during i2c_client register by adapter's attach_inform\n", c->addr);
-
-		return;
-	}
-
 	/* discard private data, in case set_type() was previously called */
 	tuner_detach(&t->fe);
 	t->fe.analog_demod_priv = NULL;
@@ -387,8 +383,7 @@ static void set_type(struct i2c_client *c, unsigned int type,
 
 	tuner_dbg("type set to %s\n", t->name);
 
-	if (t->mode_mask == T_UNINITIALIZED)
-		t->mode_mask = new_mode_mask;
+	t->mode_mask = new_mode_mask;
 
 	/* Some tuners require more initialization setup before use,
 	   such as firmware download or device calibration.
@@ -411,7 +406,6 @@ static void set_type(struct i2c_client *c, unsigned int type,
 attach_failed:
 	tuner_dbg("Tuner attach for type = %d failed.\n", t->type);
 	t->type = TUNER_ABSENT;
-	t->mode_mask = T_UNINITIALIZED;
 
 	return;
 }
@@ -429,10 +423,10 @@ static void set_addr(struct i2c_client *c, struct tuner_setup *tun_setup)
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
 
 	if ( (t->type == UNSET && ((tun_setup->addr == ADDR_UNSET) &&
-		(t->mode_mask & tun_setup->mode_mask))) ||
-		(tun_setup->addr == c->addr)) {
-			set_type(c, tun_setup->type, tun_setup->mode_mask,
-				 tun_setup->config, tun_setup->tuner_callback);
+	     (t->mode_mask & tun_setup->mode_mask))) ||
+	     (tun_setup->addr == c->addr)) {
+		set_type(c, tun_setup->type, tun_setup->mode_mask,
+			 tun_setup->config, tun_setup->tuner_callback);
 	} else
 		tuner_dbg("set addr discarded for type %i, mask %x. "
 			  "Asked to change tuner at addr 0x%02x, with mask %x\n",
@@ -491,7 +485,8 @@ static void tuner_lookup(struct i2c_adapter *adap,
 		    strcmp(pos->i2c->driver->driver.name, "tuner"))
 			continue;
 
-		mode_mask = pos->mode_mask & ~T_STANDBY;
+		mode_mask = pos->mode_mask;
+		pos->standby = 1;
 		if (*radio == NULL && mode_mask == T_RADIO)
 			*radio = pos;
 		/* Note: currently TDA9887 is the only demod-only
@@ -521,7 +516,9 @@ static int tuner_probe(struct i2c_client *client,
 	t->name = "(tuner unset)";
 	t->type = UNSET;
 	t->audmode = V4L2_TUNER_MODE_STEREO;
-	t->mode_mask = T_UNINITIALIZED;
+	t->standby = 1;
+	t->radio_freq = 87.5 * 16000;	/* Initial freq range */
+	t->tv_freq = 400 * 16; /* Sets freq to VHF High - needed for some PLL's to properly start */
 
 	if (show_i2c) {
 		unsigned char buffer[16];
@@ -544,9 +541,6 @@ static int tuner_probe(struct i2c_client *client,
 					       t->i2c->addr) >= 0) {
 				t->type = TUNER_TEA5761;
 				t->mode_mask = T_RADIO;
-				t->mode = T_STANDBY;
-				/* Sets freq to FM range */
-				t->radio_freq = 87.5 * 16000;
 				tuner_lookup(t->i2c->adapter, &radio, &tv);
 				if (tv)
 					tv->mode_mask &= ~T_RADIO;
@@ -569,7 +563,6 @@ static int tuner_probe(struct i2c_client *client,
 				t->type = TUNER_TDA9887;
 				t->mode_mask = T_RADIO | T_ANALOG_TV |
 					       T_DIGITAL_TV;
-				t->mode = T_STANDBY;
 				goto register_client;
 			}
 			break;
@@ -579,9 +572,7 @@ static int tuner_probe(struct i2c_client *client,
 					>= 0) {
 				t->type = TUNER_TEA5767;
 				t->mode_mask = T_RADIO;
-				t->mode = T_STANDBY;
 				/* Sets freq to FM range */
-				t->radio_freq = 87.5 * 16000;
 				tuner_lookup(t->i2c->adapter, &radio, &tv);
 				if (tv)
 					tv->mode_mask &= ~T_RADIO;
@@ -605,15 +596,10 @@ static int tuner_probe(struct i2c_client *client,
 		if (radio == NULL)
 			t->mode_mask |= T_RADIO;
 		tuner_dbg("Setting mode_mask to 0x%02x\n", t->mode_mask);
-		t->tv_freq = 400 * 16; /* Sets freq to VHF High */
-		t->radio_freq = 87.5 * 16000; /* Sets freq to FM range */
 	}
 
 	/* Should be just before return */
 register_client:
-	tuner_info("chip found @ 0x%x (%s)\n", client->addr << 1,
-		       client->adapter->name);
-
 	/* Sets a default mode */
 	if (t->mode_mask & T_ANALOG_TV) {
 		t->mode = V4L2_TUNER_ANALOG_TV;
@@ -624,6 +610,12 @@ register_client:
 	}
 	set_type(client, t->type, t->mode_mask, t->config, t->fe.callback);
 	list_add_tail(&t->list, &tuner_list);
+
+	tuner_info("Tuner %d found with type(s)%s%s%s.\n",
+		   t->type,
+		   t->mode_mask & T_RADIO ? " radio" : "",
+		   t->mode_mask & T_ANALOG_TV ? " TV" : "",
+		   t->mode_mask & T_ANALOG_TV ? " DTV" : "");
 	return 0;
 }
 
@@ -679,6 +671,7 @@ static void set_tv_freq(struct i2c_client *c, unsigned int freq)
 	tuner_dbg("tv freq set to %d.%02d\n",
 			freq / 16, freq % 16 * 100 / 16);
 	t->tv_freq = freq;
+	t->standby = false;
 
 	analog_ops->set_params(&t->fe, &params);
 }
@@ -837,13 +830,14 @@ static void set_radio_freq(struct i2c_client *c, unsigned int freq)
 	tuner_dbg("radio freq set to %d.%02d\n",
 			freq / 16000, freq % 16000 * 100 / 16000);
 	t->radio_freq = freq;
+	t->standby = false;
 
 	analog_ops->set_params(&t->fe, &params);
 }
 
 /**
  * check_mode - Verify if tuner supports the requested mode
- * @t - a pointer to the module's internal struct_tuner
+ * @t: a pointer to the module's internal struct_tuner
  *
  * This function checks if the tuner is capable of tuning analog TV,
  * digital TV or radio, depending on what the caller wants. If the
@@ -852,51 +846,51 @@ static void set_radio_freq(struct i2c_client *c, unsigned int freq)
  * This function is needed for boards that have a separate tuner for
  * radio (like devices with tea5767).
  */
-static inline int check_mode(struct tuner *t)
+static inline int check_mode(struct tuner *t, enum v4l2_tuner_type mode)
 {
-	if ((1 << t->mode & t->mode_mask) == 0) {
+	if ((1 << mode & t->mode_mask) == 0) {
 		return -EINVAL;
 	}
 	return 0;
 }
 
 /**
- * set_mode - Switch tuner to other mode.
- * @client - struct i2c_client pointer
- * @t - a pointer to the module's internal struct_tuner
- * @mode - enum v4l2_type + T_STANDBY mode
- * @cmd - string for the command to be executed (for debug messages)
+ * set_mode_freq - Switch tuner to other mode.
+ * @client:	struct i2c_client pointer
+ * @t:		a pointer to the module's internal struct_tuner
+ * @mode:	enum v4l2_type (radio or TV)
+ * @freq:	frequency to set (0 means to use the previous one)
  *
  * If tuner doesn't support the needed mode (radio or TV), prints a
  * debug message and returns -EINVAL, changing internal state to T_STANDBY.
  * Otherwise, changes the state and sets frequency to the last value, if
  * the tuner can sleep or if it supports both Radio and TV.
  */
-static inline int set_mode(struct i2c_client *client, struct tuner *t,
-			   int mode, char *cmd)
+static int set_mode_freq(struct i2c_client *client, struct tuner *t,
+		         enum v4l2_tuner_type mode, unsigned int freq)
 {
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 
-	if (mode == t->mode)
-		return 0;
-
-	t->mode = mode;
-
-	if (check_mode(t) == -EINVAL) {
-		tuner_dbg("Tuner doesn't support this mode. "
-			  "Putting tuner to sleep\n");
-		t->mode = T_STANDBY;
-		if (analog_ops->standby)
-			analog_ops->standby(&t->fe);
-		return -EINVAL;
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
 	}
-
 	if (t->mode == V4L2_TUNER_RADIO) {
-		if (t->radio_freq)
-			set_radio_freq(client, t->radio_freq);
+		if (freq)
+			t->radio_freq = freq;
+		set_radio_freq(client, t->radio_freq);
 	} else {
-		if (t->tv_freq)
-			set_tv_freq(client, t->tv_freq);
+		if (freq)
+			t->tv_freq = freq;
+		set_tv_freq(client, t->tv_freq);
 	}
 
 	return 0;
@@ -923,6 +917,13 @@ static void set_freq(struct i2c_client *c, unsigned long freq)
 	}
 }
 
+/**
+ * tuner_status - Dumps the current tuner status at dmesg
+ * @fe: pointer to struct dvb_frontend
+ *
+ * This callback is used only for driver debug purposes, answering to
+ * VIDIOC_LOG_STATUS. No changes should happen on this call.
+ */
 static void tuner_status(struct dvb_frontend *fe)
 {
 	struct tuner *t = fe->analog_demod_priv;
@@ -932,10 +933,16 @@ static void tuner_status(struct dvb_frontend *fe)
 	const char *p;
 
 	switch (t->mode) {
-		case V4L2_TUNER_RADIO: 	    p = "radio"; break;
-		case V4L2_TUNER_ANALOG_TV:  p = "analog TV"; break;
-		case V4L2_TUNER_DIGITAL_TV: p = "digital TV"; break;
-		default: p = "undefined"; break;
+		case V4L2_TUNER_RADIO:
+			p = "radio";
+			break;
+		case V4L2_TUNER_DIGITAL_TV:
+			p = "digital TV";
+			break;
+		case V4L2_TUNER_ANALOG_TV:
+		default:
+			p = "analog TV";
+			break;
 	}
 	if (t->mode == V4L2_TUNER_RADIO) {
 		freq = t->radio_freq / 16000;
@@ -944,7 +951,8 @@ static void tuner_status(struct dvb_frontend *fe)
 		freq = t->tv_freq / 16;
 		freq_fraction = (t->tv_freq % 16) * 100 / 16;
 	}
-	tuner_info("Tuner mode:      %s\n", p);
+	tuner_info("Tuner mode:      %s%s\n", p,
+		   t->standby ? " on standby mode" : "");
 	tuner_info("Frequency:       %lu.%02lu MHz\n", freq, freq_fraction);
 	tuner_info("Standard:        0x%08lx\n", (unsigned long)t->std);
 	if (t->mode != V4L2_TUNER_RADIO)
@@ -963,19 +971,22 @@ static void tuner_status(struct dvb_frontend *fe)
 			   analog_ops->has_signal(fe));
 }
 
+/**
+ * tuner_s_power - controls the power state of the tuner
+ * @sd: pointer to struct v4l2_subdev
+ * @on: a zero value puts the tuner to sleep
+ */
 static int tuner_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct tuner *t = to_tuner(sd);
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 
+	/* FIXME: Why this function don't wake the tuner if on != 0 ? */
 	if (on)
 		return 0;
 
 	tuner_dbg("Putting tuner to sleep\n");
-
-	if (check_mode(t) == -EINVAL)
-		return 0;
-	t->mode = T_STANDBY;
+	t->standby = true;
 	if (analog_ops->standby)
 		analog_ops->standby(&t->fe);
 	return 0;
@@ -983,13 +994,12 @@ static int tuner_s_power(struct v4l2_subdev *sd, int on)
 
 /* ---------------------------------------------------------------------- */
 
-
 static int tuner_s_radio(struct v4l2_subdev *sd)
 {
 	struct tuner *t = to_tuner(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (set_mode(client, t, V4L2_TUNER_RADIO, "s_radio") == -EINVAL)
+	if (set_mode_freq(client, t, V4L2_TUNER_RADIO, 0) == -EINVAL)
 		return 0;
 	return 0;
 }
@@ -1002,13 +1012,12 @@ static int tuner_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	struct tuner *t = to_tuner(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (set_mode(client, t, V4L2_TUNER_ANALOG_TV, "s_std") == -EINVAL)
+	if (set_mode_freq(client, t, V4L2_TUNER_ANALOG_TV, 0) == -EINVAL)
 		return 0;
 
 	t->std = std;
 	tuner_fixup_std(t);
-	if (t->tv_freq)
-		set_freq(client, t->tv_freq);
+
 	return 0;
 }
 
@@ -1017,9 +1026,8 @@ static int tuner_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 	struct tuner *t = to_tuner(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (set_mode(client, t, f->type, "s_frequency") == -EINVAL)
+	if (set_mode_freq(client, t, f->type, f->frequency) == -EINVAL)
 		return 0;
-	set_freq(client, f->frequency);
 
 	return 0;
 }
@@ -1029,20 +1037,20 @@ static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 	struct tuner *t = to_tuner(sd);
 	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
 
-	if (check_mode(t) == -EINVAL)
+	if (check_mode(t, f->type) == -EINVAL)
 		return 0;
 	f->type = t->mode;
-	if (fe_tuner_ops->get_frequency) {
+	if (fe_tuner_ops->get_frequency && !t->standby) {
 		u32 abs_freq;
 
 		fe_tuner_ops->get_frequency(&t->fe, &abs_freq);
 		f->frequency = (V4L2_TUNER_RADIO == t->mode) ?
 			DIV_ROUND_CLOSEST(abs_freq * 2, 125) :
 			DIV_ROUND_CLOSEST(abs_freq, 62500);
-		return 0;
+	} else {
+		f->frequency = (V4L2_TUNER_RADIO == t->mode) ?
+			t->radio_freq : t->tv_freq;
 	}
-	f->frequency = (V4L2_TUNER_RADIO == t->mode) ?
-		t->radio_freq : t->tv_freq;
 	return 0;
 }
 
@@ -1052,9 +1060,8 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
 
-	if (check_mode(t) == -EINVAL)
+	if (check_mode(t, vt->type) == -EINVAL)
 		return 0;
-
 	vt->type = t->mode;
 	if (analog_ops->get_afc)
 		vt->afc = analog_ops->get_afc(&t->fe);
@@ -1067,8 +1074,7 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	}
 
 	/* radio mode */
-	vt->rxsubchans =
-		V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
+	vt->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
 	if (fe_tuner_ops->get_status) {
 		u32 tuner_status;
 
@@ -1080,11 +1086,11 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	}
 	if (analog_ops->has_signal)
 		vt->signal = analog_ops->has_signal(&t->fe);
-	vt->capability |=
-		V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
+	vt->capability |= V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
 	vt->audmode = t->audmode;
 	vt->rangelow = radio_range[0] * 16000;
 	vt->rangehigh = radio_range[1] * 16000;
+
 	return 0;
 }
 
@@ -1093,14 +1099,12 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	struct tuner *t = to_tuner(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (check_mode(t) == -EINVAL)
+	if (set_mode_freq(client, t, vt->type, 0) == -EINVAL)
 		return 0;
 
-	/* do nothing unless we're a radio tuner */
-	if (t->mode != V4L2_TUNER_RADIO)
-		return 0;
-	t->audmode = vt->audmode;
-	set_radio_freq(client, t->radio_freq);
+	if (t->mode == V4L2_TUNER_RADIO)
+		t->audmode = vt->audmode;
+
 	return 0;
 }
 
@@ -1128,13 +1132,10 @@ static int tuner_resume(struct i2c_client *c)
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
 
 	tuner_dbg("resume\n");
-	if (V4L2_TUNER_RADIO == t->mode) {
-		if (t->radio_freq)
-			set_freq(c, t->radio_freq);
-	} else {
-		if (t->tv_freq)
-			set_freq(c, t->tv_freq);
-	}
+	if (V4L2_TUNER_RADIO == t->mode)
+		set_freq(c, t->radio_freq);
+	else
+		set_freq(c, t->tv_freq);
 	return 0;
 }
 
diff --git a/include/media/tuner.h b/include/media/tuner.h
index 5eec529..1d59642 100644
--- a/include/media/tuner.h
+++ b/include/media/tuner.h
@@ -160,7 +160,6 @@
 #ifdef __KERNEL__
 
 enum tuner_mode {
-	T_UNINITIALIZED = 0,
 	T_RADIO		= 1 << V4L2_TUNER_RADIO,
 	T_ANALOG_TV     = 1 << V4L2_TUNER_ANALOG_TV,
 	T_DIGITAL_TV    = 1 << V4L2_TUNER_DIGITAL_TV,
-- 
1.7.1


