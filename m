Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab3DUTA4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 15:00:56 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3LJ0u4O012541
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 21 Apr 2013 15:00:56 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv3 08/10] [media] tuner-core: store tuner ranges at tuner struct
Date: Sun, 21 Apr 2013 16:00:37 -0300
Message-Id: <1366570839-662-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366570839-662-1-git-send-email-mchehab@redhat.com>
References: <1366570839-662-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using global values for tuner ranges, store them
internally. That fixes the need of using a different range
for SDR radio, and will help to latter add a tuner ops to
retrieve the tuner range for SDR mode.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/v4l2-core/tuner-core.c | 59 ++++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index e54b5ae..abdcda4 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -67,8 +67,8 @@ static char secam[] = "--";
 static char ntsc[] = "-";
 
 module_param_named(debug, tuner_debug, int, 0644);
-module_param_array(tv_range, int, NULL, 0644);
-module_param_array(radio_range, int, NULL, 0644);
+module_param_array(tv_range, int, NULL, 0444);
+module_param_array(radio_range, int, NULL, 0444);
 module_param_string(pal, pal, sizeof(pal), 0644);
 module_param_string(secam, secam, sizeof(secam), 0644);
 module_param_string(ntsc, ntsc, sizeof(ntsc), 0644);
@@ -134,6 +134,8 @@ struct tuner {
 	unsigned int        type; /* chip type id */
 	void                *config;
 	const char          *name;
+
+	u32                 radio_range[2], tv_range[2], sdr_range[2];
 };
 
 /*
@@ -266,7 +268,7 @@ static void set_type(struct i2c_client *c, unsigned int type,
 	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 	unsigned char buffer[4];
-	int tune_now = 1;
+	int i, tune_now = 1;
 
 	if (type == UNSET || type == TUNER_ABSENT) {
 		tuner_dbg("tuner 0x%02x: Tuner type absent\n", c->addr);
@@ -451,6 +453,13 @@ static void set_type(struct i2c_client *c, unsigned int type,
 			set_tv_freq(c, t->tv_freq);
 	}
 
+	/* Initializes the tuner ranges from modprobe parameters */
+	for (i = 0; i < 2; i++) {
+		t->radio_range[i] = radio_range[i] * 16000;
+		t->sdr_range[i] = tv_range[i] * 16000;
+		t->tv_range[i] = tv_range[i] * 16;
+	}
+
 	tuner_dbg("%s %s I2C addr 0x%02x with type %d used for 0x%02x\n",
 		  c->adapter->name, c->driver->driver.name, c->addr << 1, type,
 		  t->mode_mask);
@@ -831,16 +840,16 @@ static void set_tv_freq(struct i2c_client *c, unsigned int freq)
 		tuner_warn("Tuner has no way to set tv freq\n");
 		return;
 	}
-	if (freq < tv_range[0] * 16 || freq > tv_range[1] * 16) {
+	if (freq < t->tv_range[0] || freq > t->tv_range[1]) {
 		tuner_dbg("TV freq (%d.%02d) out of range (%d-%d)\n",
-			   freq / 16, freq % 16 * 100 / 16, tv_range[0],
-			   tv_range[1]);
+			   freq / 16, freq % 16 * 100 / 16, t->tv_range[0] / 16,
+			   t->tv_range[1] / 16);
 		/* V4L2 spec: if the freq is not possible then the closest
 		   possible value should be selected */
-		if (freq < tv_range[0] * 16)
-			freq = tv_range[0] * 16;
+		if (freq < t->tv_range[0])
+			freq = t->tv_range[0];
 		else
-			freq = tv_range[1] * 16;
+			freq = t->tv_range[1];
 	}
 	params.frequency = freq;
 	tuner_dbg("tv freq set to %d.%02d\n",
@@ -957,7 +966,7 @@ static void set_radio_freq(struct i2c_client *c, unsigned int freq)
 {
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
-
+	u32 *range;
 	struct analog_parameters params = {
 		.mode      = t->mode,
 		.audmode   = t->audmode,
@@ -972,16 +981,22 @@ static void set_radio_freq(struct i2c_client *c, unsigned int freq)
 		tuner_warn("tuner has no way to set radio frequency\n");
 		return;
 	}
-	if (freq < radio_range[0] * 16000 || freq > radio_range[1] * 16000) {
+
+	if (V4L2_TUNER_IS_SDR(t->mode))
+		range = t->sdr_range;
+	else
+		range = t->radio_range;
+
+	if (freq < range[0] || freq > range[1]) {
 		tuner_dbg("radio freq (%d.%02d) out of range (%d-%d)\n",
 			   freq / 16000, freq % 16000 * 100 / 16000,
-			   radio_range[0], radio_range[1]);
+			   range[0] / 16000, range[1] / 16000);
 		/* V4L2 spec: if the freq is not possible then the closest
 		   possible value should be selected */
-		if (freq < radio_range[0] * 16000)
-			freq = radio_range[0] * 16000;
+		if (freq < range[0])
+			freq = range[0];
 		else
-			freq = radio_range[1] * 16000;
+			freq = range[1];
 	}
 	params.frequency = freq;
 	tuner_dbg("radio freq set to %d.%02d\n",
@@ -1184,8 +1199,8 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	}
 	if (!V4L2_TUNER_IS_RADIO(vt->type)) {
 		vt->capability |= V4L2_TUNER_CAP_NORM;
-		vt->rangelow = tv_range[0] * 16;
-		vt->rangehigh = tv_range[1] * 16;
+		vt->rangelow = t->tv_range[0];
+		vt->rangehigh = t->tv_range[1];
 		return 0;
 	}
 
@@ -1193,11 +1208,11 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	vt->capability |= V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
 
 	if (V4L2_TUNER_IS_SDR(vt->type)) {
-		vt->rangelow  = tv_range[0] * 16000;
-		vt->rangehigh = tv_range[1] * 16000;
-	else {
-		vt->rangelow = radio_range[0] * 16000;
-		vt->rangehigh = radio_range[1] * 16000;
+		vt->rangelow  = t->sdr_range[0];
+		vt->rangehigh = t->sdr_range[1];
+	} else {
+		vt->rangelow = t->radio_range[0];
+		vt->rangehigh = t->radio_range[1];
 	}
 	/* Check if the radio device is active */
 	if (vt->type != t->mode)
-- 
1.8.1.4

