Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8ONajsI031422
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 19:36:45 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8ONYoU7014981
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 19:34:51 -0400
Message-Id: <200809242334.m8ONYoU7014981@mx3.redhat.com>
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 25 Sep 2008 00:33:41 +0200
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH 5/6] si470x: correction of mono/stereo handling
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

this patch corrects the behavior of mono/stereo indication and selection.
These functions now work conform to what's defined in the V4L2 specification.

Bye,
Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
--- a/linux/drivers/media/radio/radio-si470x.c	2008-09-24 22:30:00.000000000 +0200
+++ b/linux/drivers/media/radio/radio-si470x.c	2008-09-24 22:30:00.000000000 +0200
@@ -1436,7 +1436,7 @@ static int si470x_vidioc_g_tuner(struct 
 	/* driver constants */
 	strcpy(tuner->name, "FM");
 	tuner->type = V4L2_TUNER_RADIO;
-	tuner->capability = V4L2_TUNER_CAP_LOW;
+	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
 
 	/* range limits */
 	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
@@ -1456,13 +1456,18 @@ static int si470x_vidioc_g_tuner(struct 
 		tuner->rangehigh =  90   * FREQ_MUL;
 		break;
 	};
-	tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
 
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
@@ -1497,10 +1502,17 @@ static int si470x_vidioc_s_tuner(struct 
 	if (tuner->index != 0)
 		goto done;
 
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
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
