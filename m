Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:21321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab1BNVKk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:10:40 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1ELAduT014216
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:10:40 -0500
Received: from pedra (vpn-239-121.phx2.redhat.com [10.3.239.121])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1EL3TGA012908
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:10:39 -0500
Date: Mon, 14 Feb 2011 19:03:17 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/14] [media] tuner-core: CodingStyle cleanups
Message-ID: <20110214190317.21dfd2de@pedra>
In-Reply-To: <cover.1297716906.git.mchehab@redhat.com>
References: <cover.1297716906.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index e6b63e9..70ff416 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -32,7 +32,7 @@
 
 #define UNSET (-1U)
 
-#define PREFIX t->i2c->driver->driver.name
+#define PREFIX (t->i2c->driver->driver.name)
 
 /*
  * Driver modprobe parameters
@@ -55,7 +55,7 @@ static char pal[] = "--";
 static char secam[] = "--";
 static char ntsc[] = "-";
 
-module_param_named(debug,tuner_debug, int, 0644);
+module_param_named(debug, tuner_debug, int, 0644);
 module_param_array(tv_range, int, NULL, 0644);
 module_param_array(radio_range, int, NULL, 0644);
 module_param_string(pal, pal, sizeof(pal), 0644);
@@ -252,7 +252,7 @@ static void set_type(struct i2c_client *c, unsigned int type,
 	int tune_now = 1;
 
 	if (type == UNSET || type == TUNER_ABSENT) {
-		tuner_dbg ("tuner 0x%02x: Tuner type absent\n",c->addr);
+		tuner_dbg("tuner 0x%02x: Tuner type absent\n", c->addr);
 		return;
 	}
 
@@ -422,9 +422,9 @@ static void set_addr(struct i2c_client *c, struct tuner_setup *tun_setup)
 {
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
 
-	if ( (t->type == UNSET && ((tun_setup->addr == ADDR_UNSET) &&
-	     (t->mode_mask & tun_setup->mode_mask))) ||
-	     (tun_setup->addr == c->addr)) {
+	if ((t->type == UNSET && ((tun_setup->addr == ADDR_UNSET) &&
+	    (t->mode_mask & tun_setup->mode_mask))) ||
+	    (tun_setup->addr == c->addr)) {
 		set_type(c, tun_setup->type, tun_setup->mode_mask,
 			 tun_setup->config, tun_setup->tuner_callback);
 	} else
@@ -449,7 +449,8 @@ static int tuner_s_type_addr(struct v4l2_subdev *sd, struct tuner_setup *type)
 	return 0;
 }
 
-static int tuner_s_config(struct v4l2_subdev *sd, const struct v4l2_priv_tun_config *cfg)
+static int tuner_s_config(struct v4l2_subdev *sd,
+			  const struct v4l2_priv_tun_config *cfg)
 {
 	struct tuner *t = to_tuner(sd);
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
@@ -601,13 +602,12 @@ static int tuner_probe(struct i2c_client *client,
 	/* Should be just before return */
 register_client:
 	/* Sets a default mode */
-	if (t->mode_mask & T_ANALOG_TV) {
+	if (t->mode_mask & T_ANALOG_TV)
 		t->mode = V4L2_TUNER_ANALOG_TV;
-	} else  if (t->mode_mask & T_RADIO) {
+	else if (t->mode_mask & T_RADIO)
 		t->mode = V4L2_TUNER_RADIO;
-	} else {
+	else
 		t->mode = V4L2_TUNER_DIGITAL_TV;
-	}
 	set_type(client, t->type, t->mode_mask, t->config, t->fe.callback);
 	list_add_tail(&t->list, &tuner_list);
 
@@ -649,15 +649,15 @@ static void set_tv_freq(struct i2c_client *c, unsigned int freq)
 	};
 
 	if (t->type == UNSET) {
-		tuner_warn ("tuner type not set\n");
+		tuner_warn("tuner type not set\n");
 		return;
 	}
 	if (NULL == analog_ops->set_params) {
-		tuner_warn ("Tuner has no way to set tv freq\n");
+		tuner_warn("Tuner has no way to set tv freq\n");
 		return;
 	}
 	if (freq < tv_range[0] * 16 || freq > tv_range[1] * 16) {
-		tuner_dbg ("TV freq (%d.%02d) out of range (%d-%d)\n",
+		tuner_dbg("TV freq (%d.%02d) out of range (%d-%d)\n",
 			   freq / 16, freq % 16 * 100 / 16, tv_range[0],
 			   tv_range[1]);
 		/* V4L2 spec: if the freq is not possible then the closest
@@ -682,31 +682,31 @@ static int tuner_fixup_std(struct tuner *t)
 	if ((t->std & V4L2_STD_PAL) == V4L2_STD_PAL) {
 		switch (pal[0]) {
 		case '6':
-			tuner_dbg ("insmod fixup: PAL => PAL-60\n");
+			tuner_dbg("insmod fixup: PAL => PAL-60\n");
 			t->std = V4L2_STD_PAL_60;
 			break;
 		case 'b':
 		case 'B':
 		case 'g':
 		case 'G':
-			tuner_dbg ("insmod fixup: PAL => PAL-BG\n");
+			tuner_dbg("insmod fixup: PAL => PAL-BG\n");
 			t->std = V4L2_STD_PAL_BG;
 			break;
 		case 'i':
 		case 'I':
-			tuner_dbg ("insmod fixup: PAL => PAL-I\n");
+			tuner_dbg("insmod fixup: PAL => PAL-I\n");
 			t->std = V4L2_STD_PAL_I;
 			break;
 		case 'd':
 		case 'D':
 		case 'k':
 		case 'K':
-			tuner_dbg ("insmod fixup: PAL => PAL-DK\n");
+			tuner_dbg("insmod fixup: PAL => PAL-DK\n");
 			t->std = V4L2_STD_PAL_DK;
 			break;
 		case 'M':
 		case 'm':
-			tuner_dbg ("insmod fixup: PAL => PAL-M\n");
+			tuner_dbg("insmod fixup: PAL => PAL-M\n");
 			t->std = V4L2_STD_PAL_M;
 			break;
 		case 'N':
@@ -715,7 +715,7 @@ static int tuner_fixup_std(struct tuner *t)
 				tuner_dbg("insmod fixup: PAL => PAL-Nc\n");
 				t->std = V4L2_STD_PAL_Nc;
 			} else {
-				tuner_dbg ("insmod fixup: PAL => PAL-N\n");
+				tuner_dbg("insmod fixup: PAL => PAL-N\n");
 				t->std = V4L2_STD_PAL_N;
 			}
 			break;
@@ -723,7 +723,7 @@ static int tuner_fixup_std(struct tuner *t)
 			/* default parameter, do nothing */
 			break;
 		default:
-			tuner_warn ("pal= argument not recognised\n");
+			tuner_warn("pal= argument not recognised\n");
 			break;
 		}
 	}
@@ -736,22 +736,24 @@ static int tuner_fixup_std(struct tuner *t)
 		case 'h':
 		case 'H':
 			tuner_dbg("insmod fixup: SECAM => SECAM-BGH\n");
-			t->std = V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H;
+			t->std = V4L2_STD_SECAM_B |
+				 V4L2_STD_SECAM_G |
+				 V4L2_STD_SECAM_H;
 			break;
 		case 'd':
 		case 'D':
 		case 'k':
 		case 'K':
-			tuner_dbg ("insmod fixup: SECAM => SECAM-DK\n");
+			tuner_dbg("insmod fixup: SECAM => SECAM-DK\n");
 			t->std = V4L2_STD_SECAM_DK;
 			break;
 		case 'l':
 		case 'L':
-			if ((secam[1]=='C')||(secam[1]=='c')) {
-				tuner_dbg ("insmod fixup: SECAM => SECAM-L'\n");
+			if ((secam[1] == 'C') || (secam[1] == 'c')) {
+				tuner_dbg("insmod fixup: SECAM => SECAM-L'\n");
 				t->std = V4L2_STD_SECAM_LC;
 			} else {
-				tuner_dbg ("insmod fixup: SECAM => SECAM-L\n");
+				tuner_dbg("insmod fixup: SECAM => SECAM-L\n");
 				t->std = V4L2_STD_SECAM_L;
 			}
 			break;
@@ -759,7 +761,7 @@ static int tuner_fixup_std(struct tuner *t)
 			/* default parameter, do nothing */
 			break;
 		default:
-			tuner_warn ("secam= argument not recognised\n");
+			tuner_warn("secam= argument not recognised\n");
 			break;
 		}
 	}
@@ -808,15 +810,15 @@ static void set_radio_freq(struct i2c_client *c, unsigned int freq)
 	};
 
 	if (t->type == UNSET) {
-		tuner_warn ("tuner type not set\n");
+		tuner_warn("tuner type not set\n");
 		return;
 	}
 	if (NULL == analog_ops->set_params) {
-		tuner_warn ("tuner has no way to set radio frequency\n");
+		tuner_warn("tuner has no way to set radio frequency\n");
 		return;
 	}
 	if (freq < radio_range[0] * 16000 || freq > radio_range[1] * 16000) {
-		tuner_dbg ("radio freq (%d.%02d) out of range (%d-%d)\n",
+		tuner_dbg("radio freq (%d.%02d) out of range (%d-%d)\n",
 			   freq / 16000, freq % 16000 * 100 / 16000,
 			   radio_range[0], radio_range[1]);
 		/* V4L2 spec: if the freq is not possible then the closest
@@ -848,9 +850,9 @@ static void set_radio_freq(struct i2c_client *c, unsigned int freq)
  */
 static inline int check_mode(struct tuner *t, enum v4l2_tuner_type mode)
 {
-	if ((1 << mode & t->mode_mask) == 0) {
+	if ((1 << mode & t->mode_mask) == 0)
 		return -EINVAL;
-	}
+
 	return 0;
 }
 
@@ -867,7 +869,7 @@ static inline int check_mode(struct tuner *t, enum v4l2_tuner_type mode)
  * the tuner can sleep or if it supports both Radio and TV.
  */
 static int set_mode_freq(struct i2c_client *client, struct tuner *t,
-		         enum v4l2_tuner_type mode, unsigned int freq)
+			 enum v4l2_tuner_type mode, unsigned int freq)
 {
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 
@@ -913,7 +915,7 @@ static void set_freq(struct i2c_client *c, unsigned long freq)
 		set_tv_freq(c, freq);
 		break;
 	default:
-		tuner_dbg("freq set: unknown mode: 0x%04x!\n",t->mode);
+		tuner_dbg("freq set: unknown mode: 0x%04x!\n", t->mode);
 	}
 }
 
@@ -933,16 +935,16 @@ static void tuner_status(struct dvb_frontend *fe)
 	const char *p;
 
 	switch (t->mode) {
-		case V4L2_TUNER_RADIO:
-			p = "radio";
-			break;
-		case V4L2_TUNER_DIGITAL_TV:
-			p = "digital TV";
-			break;
-		case V4L2_TUNER_ANALOG_TV:
-		default:
-			p = "analog TV";
-			break;
+	case V4L2_TUNER_RADIO:
+		p = "radio";
+		break;
+	case V4L2_TUNER_DIGITAL_TV:
+		p = "digital TV";
+		break;
+	case V4L2_TUNER_ANALOG_TV:
+	default:
+		p = "analog TV";
+		break;
 	}
 	if (t->mode == V4L2_TUNER_RADIO) {
 		freq = t->radio_freq / 16000;
@@ -956,7 +958,7 @@ static void tuner_status(struct dvb_frontend *fe)
 	tuner_info("Frequency:       %lu.%02lu MHz\n", freq, freq_fraction);
 	tuner_info("Standard:        0x%08lx\n", (unsigned long)t->std);
 	if (t->mode != V4L2_TUNER_RADIO)
-	       return;
+		return;
 	if (fe_tuner_ops->get_status) {
 		u32 tuner_status;
 
-- 
1.7.1


