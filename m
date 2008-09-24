Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8ONaiYv031410
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 19:36:45 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8ONYsTa015001
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 19:34:55 -0400
Message-Id: <200809242334.m8ONYsTa015001@mx3.redhat.com>
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 25 Sep 2008 00:33:09 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH 6/6] si470x: removement of get/set input/audio
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

this patch removes the unnecessary get/set input/audio functions.
The reason is, that the V4L2 specification says, that if input or audio cannot be switched anyway, the functions doesn't need to be implemented.
I've tested the new driver with all current radio programs in Debian/testing and found no problems with that.

In my opinion, the driver is much cleaner by removing these unnecessary functions.

Bye,
Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
--- a/linux/drivers/media/radio/radio-si470x.c	2008-09-24 22:30:00.000000000 +0200
+++ b/linux/drivers/media/radio/radio-si470x.c	2008-09-24 22:30:00.000000000 +0200
@@ -1221,36 +1221,6 @@ static int si470x_vidioc_querycap(struct
 
 
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
@@ -1369,44 +1339,13 @@ done:
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
 
 
@@ -1618,13 +1557,10 @@ done:
  */
 static const struct v4l2_ioctl_ops si470x_ioctl_ops = {
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
