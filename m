Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8ONaiOo031402
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 19:36:45 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8ONYqrM014995
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 19:34:55 -0400
Message-Id: <200809242334.m8ONYqrM014995@mx3.redhat.com>
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 25 Sep 2008 00:30:26 +0200
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH 4/6] si470x: tuner->type handling
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

Hi Mauro,

the V4L2 specification says, when to check and when to return tuner->type as constant value.
This patch corrects exactly this behavior, so that it is now conform to the V4L2 specification.

Bye,
Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
--- a/linux/drivers/media/radio/radio-si470x.c	2008-09-24 22:30:00.000000000 +0200
+++ b/linux/drivers/media/radio/radio-si470x.c	2008-09-24 22:30:00.000000000 +0200
@@ -104,6 +104,7 @@
  *		- hardware frequency seek support
  *		- afc indication
  *		- more safety checks, let si470x_get_freq return errno
+ *		- vidioc behavior corrected according to v4l2 spec
  *
  * ToDo:
  * - add firmware download/update support
@@ -1423,7 +1424,7 @@ static int si470x_vidioc_g_tuner(struct 
 		retval = -EIO;
 		goto done;
 	}
-	if ((tuner->index != 0) && (tuner->type != V4L2_TUNER_RADIO)) {
+	if (tuner->index != 0) {
 		retval = -EINVAL;
 		goto done;
 	}
@@ -1432,7 +1433,11 @@ static int si470x_vidioc_g_tuner(struct 
 	if (retval < 0)
 		goto done;
 
+	/* driver constants */
 	strcpy(tuner->name, "FM");
+	tuner->type = V4L2_TUNER_RADIO;
+	tuner->capability = V4L2_TUNER_CAP_LOW;
+
 	/* range limits */
 	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
 	/* 0: 87.5 - 108 MHz (USA, Europe, default) */
@@ -1452,7 +1457,6 @@ static int si470x_vidioc_g_tuner(struct 
 		break;
 	};
 	tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
-	tuner->capability = V4L2_TUNER_CAP_LOW;
 
 	/* Stereo indicator == Stereo (instead of Mono) */
 	if ((radio->registers[STATUSRSSI] & STATUSRSSI_ST) == 1)
@@ -1483,17 +1487,15 @@ static int si470x_vidioc_s_tuner(struct 
 		struct v4l2_tuner *tuner)
 {
 	struct si470x_device *radio = video_drvdata(file);
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
 
 	if (tuner->audmode == V4L2_TUNER_MODE_MONO)
 		radio->registers[POWERCFG] |= POWERCFG_MONO;  /* force mono */
@@ -1524,11 +1526,12 @@ static int si470x_vidioc_g_frequency(str
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
@@ -1553,7 +1556,7 @@ static int si470x_vidioc_s_frequency(str
 		retval = -EIO;
 		goto done;
 	}
-	if ((freq->tuner != 0) && (freq->type != V4L2_TUNER_RADIO)) {
+	if (freq->tuner != 0) {
 		retval = -EINVAL;
 		goto done;
 	}
@@ -1582,7 +1585,7 @@ static int si470x_vidioc_s_hw_freq_seek(
 		retval = -EIO;
 		goto done;
 	}
-	if ((seek->tuner != 0) && (seek->type != V4L2_TUNER_RADIO)) {
+	if (seek->tuner != 0) {
 		retval = -EINVAL;
 		goto done;
 	}

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
