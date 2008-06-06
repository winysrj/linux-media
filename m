Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m56NMIHD018778
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 19:22:18 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m56NM66G007877
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 19:22:06 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Date: Sat, 7 Jun 2008 01:21:58 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806070121.58990.tobias.lorenz@gmx.net>
Cc: 
Subject: [PATCH] si470x: vidioc improvements (spec and driver)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

I just read the V4L2 specification regarding the behaviour of the get and set vidioc functions.

There are some suggestions for the V4L2 specification itself:
1. There seems to be an inconsistency in VIDIOC_S_FREQUENCY. This is the only such function, where "type" has to be set before calling. In all other cases setting "index" is enough. I suggest to remove "type" from the list of required parameters when calling. It can't be influences anyway.
2. An improvement for VIDIOC_QUERYCTRL, would be, that if we call with a qc->id < V4L2_CID_BASE and V4L2_CTRL_FLAG_NEXT_CTRL set, it returns the first available control.
3. Another suggestion for VIDIOC_QUERYCTRL: If a control in the range >= V4L2_CID_BASE and <V4L2_CID_LASTP1 is not available, better don't return -EINVAL, but instead return with the flag set to V4L2_CTRL_FLAG_DISABLED. This is what most radio application expect. With return -EINVAL the applications usually generate a lot of errors.
4. A description of HW_FREQ_SEEK analogous to S_FREQUENCY is missing. But this is propably my task...

I can provide a patch for the documentation, if somebody point me to the latex source code...

Anyway I modified the driver to be conform with the V4L2 specification including the suggestions above.
These are the modifications:
- unused controls are removed from the list of queryctrls.
- g_input and s_input is completely removed, as this is not for radio devices, but for video devices.
- querycap now understands the V4L2_CTRL_FLAG_NEXT_CTRL and acts according to the suggestion 2 and 3 above
- g_audio now always returns with constant data
- s_audio is removed, as there isn't anything to set anyway
- g_tuner and s_tuner don't check for type anymore (wasn't spec conform)
- g_tuner and s_tuner now support correct indication/setting of mono/stereo (TUNER_CAP, TUNER_SUB, TUNER_MODE)
- g_frequency, s_frequency and s_hw_freq_seek don't check for type anymore (suggestion 1)

Bye,

Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
--- a/drivers/media/radio/radio-si470x.c	2008-06-06 21:18:39.000000000 +0200
+++ b/drivers/media/radio/radio-si470x.c	2008-06-06 21:36:03.000000000 +0200
@@ -104,6 +104,7 @@
  *		- hardware frequency seek support
  *		- afc indication
  *		- more safety checks, let si470x_get_freq return errno
+ *		- vidioc behaviour corrected according to v4l2 spec
  *
  * ToDo:
  * - add firmware download/update support
@@ -1172,7 +1173,6 @@ static const struct file_operations si47
  * si470x_v4l2_queryctrl - query control
  */
 static struct v4l2_queryctrl si470x_v4l2_queryctrl[] = {
-/* HINT: the disabled controls are only here to satify kradio and such apps */
 	{
 		.id		= V4L2_CID_AUDIO_VOLUME,
 		.type		= V4L2_CTRL_TYPE_INTEGER,
@@ -1183,18 +1183,6 @@ static struct v4l2_queryctrl si470x_v4l2
 		.default_value	= 15,
 	},
 	{
-		.id		= V4L2_CID_AUDIO_BALANCE,
-		.flags		= V4L2_CTRL_FLAG_DISABLED,
-	},
-	{
-		.id		= V4L2_CID_AUDIO_BASS,
-		.flags		= V4L2_CTRL_FLAG_DISABLED,
-	},
-	{
-		.id		= V4L2_CID_AUDIO_TREBLE,
-		.flags		= V4L2_CTRL_FLAG_DISABLED,
-	},
-	{
 		.id		= V4L2_CID_AUDIO_MUTE,
 		.type		= V4L2_CTRL_TYPE_BOOLEAN,
 		.name		= "Mute",
@@ -1203,10 +1191,6 @@ static struct v4l2_queryctrl si470x_v4l2
 		.step		= 1,
 		.default_value	= 1,
 	},
-	{
-		.id		= V4L2_CID_AUDIO_LOUDNESS,
-		.flags		= V4L2_CTRL_FLAG_DISABLED,
-	},
 };
 
 
@@ -1228,56 +1212,59 @@ static int si470x_vidioc_querycap(struct
 
 
 /*
- * si470x_vidioc_g_input - get input
- */
-static int si470x_vidioc_g_input(struct file *file, void *priv,
-		unsigned int *i)
-{
-	*i = 0;
-
-	return 0;
-}
-
-
-/*
- * si470x_vidioc_s_input - set input
- */
-static int si470x_vidioc_s_input(struct file *file, void *priv, unsigned int i)
-{
-	int retval = 0;
-
-	/* safety checks */
-	if (i != 0)
-		retval = -EINVAL;
-
-	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME
-			": set input failed with %d\n", retval);
-	return retval;
-}
-
-
-/*
  * si470x_vidioc_queryctrl - enumerate control items
  */
 static int si470x_vidioc_queryctrl(struct file *file, void *priv,
 		struct v4l2_queryctrl *qc)
 {
-	unsigned char i;
+	unsigned char i = 0;
 	int retval = -EINVAL;
+	int next = 0;
 
-	/* safety checks */
-	if (!qc->id)
-		goto done;
+	/* extract next ctrl flag */
+	if ((qc->id & V4L2_CTRL_FLAG_NEXT_CTRL) == 1) {
+		next = 1;
+		qc->id &= ~V4L2_CTRL_FLAG_NEXT_CTRL;
+
+	}
 
+	/* abort if qc->id is below V4L2_CID_BASE */
+	if (qc->id < V4L2_CID_BASE) {
+		/* special handling for getting first control */
+		if (next == 1) {
+			retval = 0;
+			goto copy;
+		} else
+			goto done;
+	}
+
+	/* search video control */
 	for (i = 0; i < ARRAY_SIZE(si470x_v4l2_queryctrl); i++) {
 		if (qc->id == si470x_v4l2_queryctrl[i].id) {
-			memcpy(qc, &(si470x_v4l2_queryctrl[i]), sizeof(*qc));
-			retval = 0;
+			retval = 0; /* found */
 			break;
 		}
 	}
 
+	/* use next control */
+	if (next == 1) {
+		i++;
+		if (i >= ARRAY_SIZE(si470x_v4l2_queryctrl))
+			retval = -EINVAL; /* not found */
+	}
+
+	/* disable unsupported base controls */
+	/* to satisfy kradio and such apps */
+	if ((retval == -EINVAL) && (qc->id < V4L2_CID_LASTP1)) {
+		qc->flags = V4L2_CTRL_FLAG_DISABLED;
+		retval = 0;
+		goto done;
+	}
+
+copy:
+	/* copy that control */
+	memcpy(qc, &(si470x_v4l2_queryctrl[i]), sizeof(*qc));
+
 done:
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
@@ -1368,44 +1355,13 @@ done:
 static int si470x_vidioc_g_audio(struct file *file, void *priv,
 		struct v4l2_audio *audio)
 {
-	int retval = 0;
-
-	/* safety checks */
-	if (audio->index != 0) {
-		retval = -EINVAL;
-		goto done;
-	}
-
+	/* driver constants */
+	audio->index = 0;
 	strcpy(audio->name, "Radio");
 	audio->capability = V4L2_AUDCAP_STEREO;
+	audio->mode = 0;
 
-done:
-	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME
-			": get audio failed with %d\n", retval);
-	return retval;
-}
-
-
-/*
- * si470x_vidioc_s_audio - set audio attributes
- */
-static int si470x_vidioc_s_audio(struct file *file, void *priv,
-		struct v4l2_audio *audio)
-{
-	int retval = 0;
-
-	/* safety checks */
-	if (audio->index != 0) {
-		retval = -EINVAL;
-		goto done;
-	}
-
-done:
-	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME
-			": set audio failed with %d\n", retval);
-	return retval;
+	return 0;
 }
 
 
@@ -1423,7 +1379,7 @@ static int si470x_vidioc_g_tuner(struct 
 		retval = -EIO;
 		goto done;
 	}
-	if ((tuner->index != 0) && (tuner->type != V4L2_TUNER_RADIO)) {
+	if (tuner->index != 0) {
 		retval = -EINVAL;
 		goto done;
 	}
@@ -1432,7 +1388,12 @@ static int si470x_vidioc_g_tuner(struct 
 	if (retval < 0)
 		goto done;
 
+	/* driver constants */
 	strcpy(tuner->name, "FM");
+	tuner->type = V4L2_TUNER_RADIO;
+	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
+
+	/* range limits */
 	switch (band) {
 	/* 0: 87.5 - 108 MHz (USA, Europe, default) */
 	default:
@@ -1450,14 +1411,18 @@ static int si470x_vidioc_g_tuner(struct 
 		tuner->rangehigh =  90   * FREQ_MUL;
 		break;
 	};
-	tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
-	tuner->capability = V4L2_TUNER_CAP_LOW;
 
-	/* Stereo indicator == Stereo (instead of Mono) */
+	/* stereo indicator == stereo (instead of mono) */
 	if ((radio->registers[STATUSRSSI] & STATUSRSSI_ST) == 1)
-		tuner->audmode = V4L2_TUNER_MODE_STEREO;
+		tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
 	else
+		tuner->rxsubchans = V4L2_TUNER_SUB_MONO;
+
+	/* mono/stereo selector */
+	if ((radio->registers[POWERCFG] & POWERCFG_MONO) == 1)
 		tuner->audmode = V4L2_TUNER_MODE_MONO;
+	else
+		tuner->audmode = V4L2_TUNER_MODE_STEREO;
 
 	/* min is worst, max is best; signal:0..0xffff; rssi: 0..0xff */
 	tuner->signal = (radio->registers[STATUSRSSI] & STATUSRSSI_RSSI)
@@ -1482,22 +1447,27 @@ static int si470x_vidioc_s_tuner(struct 
 		struct v4l2_tuner *tuner)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
-	int retval = 0;
+	int retval = -EINVAL;
 
 	/* safety checks */
 	if (radio->disconnected) {
 		retval = -EIO;
 		goto done;
 	}
-	if ((tuner->index != 0) && (tuner->type != V4L2_TUNER_RADIO)) {
-		retval = -EINVAL;
+	if (tuner->index != 0)
 		goto done;
-	}
 
-	if (tuner->audmode == V4L2_TUNER_MODE_MONO)
+	/* mono/stereo selector */
+	switch (tuner->audmode) {
+	case V4L2_TUNER_MODE_MONO:
 		radio->registers[POWERCFG] |= POWERCFG_MONO;  /* force mono */
-	else
+		break;
+	case V4L2_TUNER_MODE_STEREO:
 		radio->registers[POWERCFG] &= ~POWERCFG_MONO; /* try stereo */
+		break;
+	default:
+		goto done;
+	}
 
 	retval = si470x_set_register(radio, POWERCFG);
 
@@ -1523,11 +1493,12 @@ static int si470x_vidioc_g_frequency(str
 		retval = -EIO;
 		goto done;
 	}
-	if ((freq->tuner != 0) && (freq->type != V4L2_TUNER_RADIO)) {
+	if (freq->tuner != 0) {
 		retval = -EINVAL;
 		goto done;
 	}
 
+	freq->type = V4L2_TUNER_RADIO;
 	retval = si470x_get_freq(radio, &freq->frequency);
 
 done:
@@ -1552,7 +1523,7 @@ static int si470x_vidioc_s_frequency(str
 		retval = -EIO;
 		goto done;
 	}
-	if ((freq->tuner != 0) && (freq->type != V4L2_TUNER_RADIO)) {
+	if (freq->tuner != 0) {
 		retval = -EINVAL;
 		goto done;
 	}
@@ -1581,7 +1552,7 @@ static int si470x_vidioc_s_hw_freq_seek(
 		retval = -EIO;
 		goto done;
 	}
-	if ((seek->tuner != 0) && (seek->type != V4L2_TUNER_RADIO)) {
+	if (seek->tuner != 0) {
 		retval = -EINVAL;
 		goto done;
 	}
@@ -1606,13 +1577,10 @@ static struct video_device si470x_viddev
 	.type			= VID_TYPE_TUNER,
 	.release		= video_device_release,
 	.vidioc_querycap	= si470x_vidioc_querycap,
-	.vidioc_g_input		= si470x_vidioc_g_input,
-	.vidioc_s_input		= si470x_vidioc_s_input,
 	.vidioc_queryctrl	= si470x_vidioc_queryctrl,
 	.vidioc_g_ctrl		= si470x_vidioc_g_ctrl,
 	.vidioc_s_ctrl		= si470x_vidioc_s_ctrl,
 	.vidioc_g_audio		= si470x_vidioc_g_audio,
-	.vidioc_s_audio		= si470x_vidioc_s_audio,
 	.vidioc_g_tuner		= si470x_vidioc_g_tuner,
 	.vidioc_s_tuner		= si470x_vidioc_s_tuner,
 	.vidioc_g_frequency	= si470x_vidioc_g_frequency,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
