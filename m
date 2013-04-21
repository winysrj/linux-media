Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab3DUTAv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 15:00:51 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3LJ0odp018883
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 21 Apr 2013 15:00:50 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv3 06/10] [media] tuner-core: consider SDR as radio
Date: Sun, 21 Apr 2013 16:00:35 -0300
Message-Id: <1366570839-662-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366570839-662-1-git-send-email-mchehab@redhat.com>
References: <1366570839-662-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several tests at tuner-core for radio. Extend it to
also cover SDR radio.

Some of the changes here may need to be reviewed, SDR support will
actually be implemented there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/v4l2-core/tuner-core.c | 22 ++++++++++++----------
 include/uapi/linux/videodev2.h       |  3 +++
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index ddc9379..b97ec63 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -445,7 +445,7 @@ static void set_type(struct i2c_client *c, unsigned int type,
 	   on analog tuners for PLL to properly work
 	 */
 	if (tune_now) {
-		if (V4L2_TUNER_RADIO == t->mode)
+		if (V4L2_TUNER_IS_RADIO(t->mode))
 			set_radio_freq(c, t->radio_freq);
 		else
 			set_tv_freq(c, t->tv_freq);
@@ -743,7 +743,7 @@ static int tuner_remove(struct i2c_client *client)
 static inline int check_mode(struct tuner *t, enum v4l2_tuner_type mode)
 {
 	int t_mode;
-	if (mode == V4L2_TUNER_RADIO)
+	if (V4L2_TUNER_IS_RADIO(mode))
 		t_mode = T_RADIO;
 	else
 		t_mode = T_ANALOG_TV;
@@ -791,7 +791,7 @@ static void set_freq(struct tuner *t, unsigned int freq)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&t->sd);
 
-	if (t->mode == V4L2_TUNER_RADIO) {
+	if (V4L2_TUNER_IS_RADIO(t->mode)) {
 		if (!freq)
 			freq = t->radio_freq;
 		set_radio_freq(client, freq);
@@ -1024,11 +1024,13 @@ static void tuner_status(struct dvb_frontend *fe)
 		p = "digital TV";
 		break;
 	case V4L2_TUNER_ANALOG_TV:
-	default:
 		p = "analog TV";
 		break;
+	default:
+		p = "SDR";
+		break;
 	}
-	if (t->mode == V4L2_TUNER_RADIO) {
+	if (V4L2_TUNER_IS_RADIO(t->mode)) {
 		freq = t->radio_freq / 16000;
 		freq_fraction = (t->radio_freq % 16000) * 100 / 16000;
 	} else {
@@ -1039,7 +1041,7 @@ static void tuner_status(struct dvb_frontend *fe)
 		   t->standby ? " on standby mode" : "");
 	tuner_info("Frequency:       %lu.%02lu MHz\n", freq, freq_fraction);
 	tuner_info("Standard:        0x%08lx\n", (unsigned long)t->std);
-	if (t->mode != V4L2_TUNER_RADIO)
+	if (!V4L2_TUNER_IS_RADIO(t->mode))
 		return;
 	if (fe_tuner_ops->get_status) {
 		u32 tuner_status;
@@ -1144,11 +1146,11 @@ static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 		u32 abs_freq;
 
 		fe_tuner_ops->get_frequency(&t->fe, &abs_freq);
-		f->frequency = (V4L2_TUNER_RADIO == t->mode) ?
+		f->frequency = (V4L2_TUNER_IS_RADIO(t->mode)) ?
 			DIV_ROUND_CLOSEST(abs_freq * 2, 125) :
 			DIV_ROUND_CLOSEST(abs_freq, 62500);
 	} else {
-		f->frequency = (V4L2_TUNER_RADIO == f->type) ?
+		f->frequency = (V4L2_TUNER_IS_RADIO(f->type)) ?
 			t->radio_freq : t->tv_freq;
 	}
 	return 0;
@@ -1180,7 +1182,7 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 		if (!analog_ops->has_signal(&t->fe, &signal))
 			vt->signal = signal;
 	}
-	if (vt->type != V4L2_TUNER_RADIO) {
+	if (!V4L2_TUNER_IS_RADIO(vt->type)) {
 		vt->capability |= V4L2_TUNER_CAP_NORM;
 		vt->rangelow = tv_range[0] * 16;
 		vt->rangehigh = tv_range[1] * 16;
@@ -1224,7 +1226,7 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
 	if (set_mode(t, vt->type))
 		return 0;
 
-	if (t->mode == V4L2_TUNER_RADIO) {
+	if (V4L2_TUNER_IS_RADIO(t->mode)) {
 		t->audmode = vt->audmode;
 		/*
 		 * For radio audmode can only be mono or stereo. Map any
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index e2cc369..9d18af7 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -182,6 +182,9 @@ enum v4l2_tuner_type {
 #define V4L2_TUNER_IS_SDR(type)					\
 	(((type) >= V4L2_TUNER_SDR_RADIO) || ((type) < V4L2_TUNER_SDR_MAX))
 
+#define V4L2_TUNER_IS_RADIO(type)					\
+	(((type) == V4L2_TUNER_RADIO) || V4L2_TUNER_IS_SDR(type))
+
 enum v4l2_memory {
 	V4L2_MEMORY_MMAP             = 1,
 	V4L2_MEMORY_USERPTR          = 2,
-- 
1.8.1.4

