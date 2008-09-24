Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8ONZA8c031212
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 19:35:10 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8ONYqto014998
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 19:34:53 -0400
Message-Id: <200809242334.m8ONYqto014998@mx3.redhat.com>
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 25 Sep 2008 00:25:39 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH 3/6] si470x: improvement of unsupported base controls
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

this patch changes the handling of unsupported base controls.
In the former version, specific unsupported base controls were listed in the queryctrl table and were flagged as disabled controls.
This was done for all base controls used by the applications.
The patch now removes the specific base controls and instead lets queryctrl automatically return unsupported base controls flagged as disabled.

Bye,
Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
--- a/linux/drivers/media/radio/radio-si470x.c	2008-09-24 22:30:00.000000000 +0200
+++ b/linux/drivers/media/radio/radio-si470x.c	2008-09-24 22:30:00.000000000 +0200
@@ -1181,7 +1181,6 @@ static const struct file_operations si47
  * si470x_v4l2_queryctrl - query control
  */
 static struct v4l2_queryctrl si470x_v4l2_queryctrl[] = {
-/* HINT: the disabled controls are only here to satify kradio and such apps */
 	{
 		.id		= V4L2_CID_AUDIO_VOLUME,
 		.type		= V4L2_CTRL_TYPE_INTEGER,
@@ -1192,18 +1191,6 @@ static struct v4l2_queryctrl si470x_v4l2
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
@@ -1212,10 +1199,6 @@ static struct v4l2_queryctrl si470x_v4l2
 		.step		= 1,
 		.default_value	= 1,
 	},
-	{
-		.id		= V4L2_CID_AUDIO_LOUDNESS,
-		.flags		= V4L2_CTRL_FLAG_DISABLED,
-	},
 };
 
 
@@ -1272,21 +1255,29 @@ static int si470x_vidioc_s_input(struct 
 static int si470x_vidioc_queryctrl(struct file *file, void *priv,
 		struct v4l2_queryctrl *qc)
 {
-	unsigned char i;
+	unsigned char i = 0;
 	int retval = -EINVAL;
 
-	/* safety checks */
-	if (!qc->id)
+	/* abort if qc->id is below V4L2_CID_BASE */
+	if (qc->id < V4L2_CID_BASE)
 		goto done;
 
+	/* search video control */
 	for (i = 0; i < ARRAY_SIZE(si470x_v4l2_queryctrl); i++) {
 		if (qc->id == si470x_v4l2_queryctrl[i].id) {
 			memcpy(qc, &(si470x_v4l2_queryctrl[i]), sizeof(*qc));
-			retval = 0;
+			retval = 0; /* found */
 			break;
 		}
 	}
 
+	/* disable unsupported base controls */
+	/* to satisfy kradio and such apps */
+	if ((retval == -EINVAL) && (qc->id < V4L2_CID_LASTP1)) {
+		qc->flags = V4L2_CTRL_FLAG_DISABLED;
+		retval = 0;
+	}
+
 done:
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
