Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab3DUTAu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 15:00:50 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3LJ0nuj016332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 21 Apr 2013 15:00:50 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv3 10/10] [media] tuner-core: add support for SDR set_tuner
Date: Sun, 21 Apr 2013 16:00:39 -0300
Message-Id: <1366570839-662-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366570839-662-1-git-send-email-mchehab@redhat.com>
References: <1366570839-662-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most SDR devices use TV tuners. Those generally require
to know what is the type of the envelope, in order to
adjust their PLL's and filters.

Add support to tune them via tuner-core.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/v4l2-core/tuner-core.c | 220 ++++++++++++++++++++++-------------
 1 file changed, 141 insertions(+), 79 deletions(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 28bbcad..2b9eed6 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -121,10 +121,12 @@ struct tuner {
 	struct list_head    list;
 
 	/* keep track of the current settings */
-	v4l2_std_id         std;
+	v4l2_std_id         std, sdr_std;
 	unsigned int        tv_freq;
 	unsigned int        radio_freq;
+	unsigned int        sdr_freq;
 	unsigned int        audmode;
+	u32                 bandwidth;
 
 	enum v4l2_tuner_type mode;
 	unsigned int        mode_mask; /* Combination of allowable modes */
@@ -142,8 +144,9 @@ struct tuner {
  * Function prototypes
  */
 
-static void set_tv_freq(struct i2c_client *c, unsigned int freq);
-static void set_radio_freq(struct i2c_client *c, unsigned int freq);
+static void set_freq(struct tuner *t, unsigned int freq);
+static void set_tv_freq(struct tuner *t, struct analog_parameters *params);
+static void set_radio_freq(struct tuner *t, struct analog_parameters *params);
 
 /*
  * tuner attach/detach logic
@@ -440,19 +443,6 @@ static void set_type(struct i2c_client *c, unsigned int type,
 
 	t->mode_mask = new_mode_mask;
 
-	/* Some tuners require more initialization setup before use,
-	   such as firmware download or device calibration.
-	   trying to set a frequency here will just fail
-	   FIXME: better to move set_freq to the tuner code. This is needed
-	   on analog tuners for PLL to properly work
-	 */
-	if (tune_now) {
-		if (V4L2_TUNER_IS_RADIO(t->mode))
-			set_radio_freq(c, t->radio_freq);
-		else
-			set_tv_freq(c, t->tv_freq);
-	}
-
 	/* Initializes the tuner ranges from modprobe parameters */
 	for (i = 0; i < 2; i++) {
 		t->radio_range[i] = radio_range[i] * 16000;
@@ -466,6 +456,28 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		t->sdr_range[0] = min / 16;
 		t->sdr_range[1] = max / 16;
 	}
+	/*
+	 * FIXME: It is possible that, for some SDR devices, the analog
+	 * standard needs to be better known. In this case, it should use
+	 * V4L2 VIDIOC_S_STD to change the content of t->sdr_std to reflect
+	 * what type of RF is expected.
+	 * Adding support for it would require additional changes at
+	 * v4l2-dev, as tuner-core needs to know if the request comes from
+	 * a SDR devnode or from an analog TV devnode, because, a TV s_std
+	 * ops cause the tuner to switch modes.
+	 */
+	t->sdr_std = V4L2_STD_ALL;
+
+	/*
+	 * Some tuners require more initialization setup before use,
+	 * such as firmware download or device calibration.
+	 * trying to set a frequency here will just fail
+	 *
+	 * FIXME: better to move set_freq to the tuner code. This is needed
+	 *	  on analog tuners for PLL to properly work
+	 */
+	if (tune_now)
+		set_freq(t, 0);
 
 	tuner_dbg("%s %s I2C addr 0x%02x with type %d used for 0x%02x\n",
 		  c->adapter->name, c->driver->driver.name, c->addr << 1, type,
@@ -805,16 +817,81 @@ static int set_mode(struct tuner *t, enum v4l2_tuner_type mode)
  */
 static void set_freq(struct tuner *t, unsigned int freq)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(&t->sd);
+	struct analog_parameters params;
+	struct dtv_frontend_properties *c = &t->fe.dtv_property_cache;
+	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
+	bool is_analog = true;
 
-	if (V4L2_TUNER_IS_RADIO(t->mode)) {
+	if (t->type == UNSET) {
+		tuner_warn("tuner type not set\n");
+		return;
+	}
+
+	memset(&params, 0, sizeof(params));
+
+	switch (t->mode) {
+	case V4L2_TUNER_ANALOG_TV:
+		if (!freq)
+			freq = t->tv_freq;
+
+		params.mode      = t->mode;
+		params.audmode   = t->audmode;
+		params.std       = t->std;
+		params.frequency = freq;
+		set_tv_freq(t, &params);
+		t->tv_freq = params.frequency;
+		return;
+	case V4L2_TUNER_RADIO:
 		if (!freq)
 			freq = t->radio_freq;
-		set_radio_freq(client, freq);
+		params.mode      = V4L2_TUNER_RADIO;
+		params.audmode   = t->audmode;
+		params.frequency = freq;
+		set_radio_freq(t, &params);
+		t->radio_freq = params.frequency;
+		return;
+	case V4L2_TUNER_SDR_RADIO:
+		params.mode = V4L2_TUNER_RADIO;
+		break;
+	case V4L2_TUNER_SDR_ATV:
+		params.mode = V4L2_TUNER_ANALOG_TV;
+		params.std = t->sdr_std;
+		break;
+	case V4L2_TUNER_SDR_DTV_ATSC:
+		is_analog = false;
+		c->delivery_system = SYS_ATSC;
+		c->bandwidth_hz = 6000000;
+		break;
+	case V4L2_TUNER_SDR_DTV_DVBT:
+		is_analog = false;
+		c->delivery_system = SYS_DVBT;
+		c->bandwidth_hz = t->bandwidth;
+		break;
+	case V4L2_TUNER_SDR_DTV_ISDBT:
+		is_analog = false;
+		c->delivery_system = SYS_ISDBT;
+		c->bandwidth_hz = t->bandwidth;
+		break;
+	case V4L2_TUNER_DIGITAL_TV:
+	case V4L2_TUNER_SDR_MAX:
+		is_analog = false;
+		c->delivery_system = SYS_DVBT;
+		c->bandwidth_hz = 8000000;
+		break;
+	}
+
+	if (!freq)
+		freq = t->sdr_freq;
+	if (is_analog) {
+		params.frequency = freq;
+		set_radio_freq(t, &params);
+		t->sdr_freq = params.frequency;
 	} else {
-		if (!freq)
-			freq = t->tv_freq;
-		set_tv_freq(client, freq);
+		t->standby = false;
+		c->frequency = freq * 16;
+		if (fe_tuner_ops->set_params)
+			fe_tuner_ops->set_params(&t->fe);
+		t->sdr_freq = (c->frequency + 7) / 16;
 	}
 }
 
@@ -825,46 +902,37 @@ static void set_freq(struct tuner *t, unsigned int freq)
 /**
  * set_tv_freq - Set tuner frequency,  freq in Units of 62.5 kHz = 1/16MHz
  *
- * @c:	i2c_client descriptor
- * @freq: frequency
+ * @t:		a pointer to the module's internal struct_tuner
+ * @params:	analog parameters to set
  */
-static void set_tv_freq(struct i2c_client *c, unsigned int freq)
+static void set_tv_freq(struct tuner *t, struct analog_parameters *params)
 {
-	struct tuner *t = to_tuner(i2c_get_clientdata(c));
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 
-	struct analog_parameters params = {
-		.mode      = t->mode,
-		.audmode   = t->audmode,
-		.std       = t->std
-	};
-
-	if (t->type == UNSET) {
-		tuner_warn("tuner type not set\n");
-		return;
-	}
 	if (NULL == analog_ops->set_params) {
-		tuner_warn("Tuner has no way to set tv freq\n");
+		tuner_warn("Tuner has no way to set TV frequency\n");
 		return;
 	}
-	if (freq < t->tv_range[0] || freq > t->tv_range[1]) {
-		tuner_dbg("TV freq (%d.%02d) out of range (%d-%d)\n",
-			   freq / 16, freq % 16 * 100 / 16, t->tv_range[0] / 16,
-			   t->tv_range[1] / 16);
-		/* V4L2 spec: if the freq is not possible then the closest
-		   possible value should be selected */
-		if (freq < t->tv_range[0])
-			freq = t->tv_range[0];
+	if (params->frequency < t->tv_range[0] ||
+	    params->frequency > t->tv_range[1]) {
+		tuner_dbg("TV frequency (%d.%02d) out of range (%d-%d)\n",
+			  params->frequency / 16,
+			  params->frequency % 16 * 100 / 16,
+			  t->tv_range[0] / 16, t->tv_range[1] / 16);
+		/*
+		 * V4L2 spec: if the params->frequency is not possible,
+		 * then the closest possible value should be selected
+		 */
+		if (params->frequency < t->tv_range[0])
+			params->frequency = t->tv_range[0];
 		else
-			freq = t->tv_range[1];
+			params->frequency = t->tv_range[1];
 	}
-	params.frequency = freq;
-	tuner_dbg("tv freq set to %d.%02d\n",
-			freq / 16, freq % 16 * 100 / 16);
-	t->tv_freq = freq;
+	tuner_dbg("TV frequency set to %d.%02d\n",
+		  params->frequency / 16, params->frequency % 16 * 100 / 16);
 	t->standby = false;
 
-	analog_ops->set_params(&t->fe, &params);
+	analog_ops->set_params(&t->fe, params);
 }
 
 /**
@@ -966,24 +1034,14 @@ static v4l2_std_id tuner_fixup_std(struct tuner *t, v4l2_std_id std)
 /**
  * set_radio_freq - Set tuner frequency,  freq in Units of 62.5 Hz  = 1/16kHz
  *
- * @c:	i2c_client descriptor
- * @freq: frequency
+ * @t:		a pointer to the module's internal struct_tuner
+ * @params:	analog parameters to set
  */
-static void set_radio_freq(struct i2c_client *c, unsigned int freq)
+static void set_radio_freq(struct tuner *t, struct analog_parameters *params)
 {
-	struct tuner *t = to_tuner(i2c_get_clientdata(c));
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 	u32 *range;
-	struct analog_parameters params = {
-		.mode      = t->mode,
-		.audmode   = t->audmode,
-		.std       = t->std
-	};
 
-	if (t->type == UNSET) {
-		tuner_warn("tuner type not set\n");
-		return;
-	}
 	if (NULL == analog_ops->set_params) {
 		tuner_warn("tuner has no way to set radio frequency\n");
 		return;
@@ -994,29 +1052,31 @@ static void set_radio_freq(struct i2c_client *c, unsigned int freq)
 	else
 		range = t->radio_range;
 
-	if (freq < range[0] || freq > range[1]) {
-		tuner_dbg("radio freq (%d.%02d) out of range (%d-%d)\n",
-			   freq / 16000, freq % 16000 * 100 / 16000,
+	if (params->frequency < range[0] || params->frequency > range[1]) {
+		tuner_dbg("radio frequency (%d.%02d) out of range (%d-%d)\n",
+			   params->frequency / 16000,
+			   params->frequency % 16000 * 100 / 16000,
 			   range[0] / 16000, range[1] / 16000);
-		/* V4L2 spec: if the freq is not possible then the closest
-		   possible value should be selected */
-		if (freq < range[0])
-			freq = range[0];
+		/*
+		 * V4L2 spec: if the params->frequency is not possible,
+		 * then the closest possible value should be selected
+		 */
+		if (params->frequency < range[0])
+			params->frequency = range[0];
 		else
-			freq = range[1];
+			params->frequency = range[1];
 	}
-	params.frequency = freq;
-	tuner_dbg("radio freq set to %d.%02d\n",
-			freq / 16000, freq % 16000 * 100 / 16000);
-	t->radio_freq = freq;
+	tuner_dbg("radio frequency set to %d.%02d\n",
+		  params->frequency / 16000,
+		  params->frequency % 16000 * 100 / 16000);
 	t->standby = false;
 
-	analog_ops->set_params(&t->fe, &params);
+	analog_ops->set_params(&t->fe, params);
 	/*
 	 * The tuner driver might decide to change the audmode if it only
 	 * supports stereo, so update t->audmode.
 	 */
-	t->audmode = params.audmode;
+	t->audmode = params->audmode;
 }
 
 /*
@@ -1269,7 +1329,7 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
 	if (set_mode(t, vt->type))
 		return 0;
 
-	if (V4L2_TUNER_IS_RADIO(t->mode)) {
+	if (vt->type == V4L2_TUNER_RADIO) {
 		t->audmode = vt->audmode;
 		/*
 		 * For radio audmode can only be mono or stereo. Map any
@@ -1280,6 +1340,8 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
 		if (t->audmode != V4L2_TUNER_MODE_MONO &&
 		    t->audmode != V4L2_TUNER_MODE_STEREO)
 			t->audmode = V4L2_TUNER_MODE_STEREO;
+	} else if (V4L2_TUNER_IS_SDR(vt->type)) {
+		t->bandwidth = vt->bandwidth;
 	}
 	set_freq(t, 0);
 
-- 
1.8.1.4

