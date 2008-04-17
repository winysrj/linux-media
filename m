Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3H22ceh029749
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 22:02:38 -0400
Received: from mylar.outflux.net (mylar.outflux.net [69.93.193.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3H22Slo004044
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 22:02:29 -0400
Received: from www.outflux.net (serenity-end.outflux.net [10.2.0.2])
	by mylar.outflux.net (8.13.8/8.13.8/Debian-3) with ESMTP id
	m3H22HKU031010
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 19:02:22 -0700
Resent-Message-ID: <20080417020217.GL18929@outflux.net>
Date: Wed, 16 Apr 2008 18:24:09 -0700
From: Kees Cook <kees@outflux.net>
To: video4linux-list@redhat.com
Message-ID: <20080417012409.GI18929@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 2/2] V4L: add "function" sysfs attribute to v4l devices
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

Add "function" initializers to cpia, cx88, ivtv, and ov511.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Kees Cook <kees@outflux.net>
---
 cpia.c                |    1 +
 cx88/cx88-blackbird.c |    1 +
 cx88/cx88-video.c     |    3 +++
 ivtv/ivtv-streams.c   |   34 ++++++++++++++++++++++++++++++++++
 ov511.c               |    1 +
 5 files changed, 40 insertions(+)
---
diff -r 6aa6656852cb linux/drivers/media/video/cpia.c
--- a/linux/drivers/media/video/cpia.c	Wed Apr 16 13:13:15 2008 -0300
+++ b/linux/drivers/media/video/cpia.c	Wed Apr 16 17:53:13 2008 -0700
@@ -3804,6 +3804,7 @@ static struct video_device cpia_template
 	.owner		= THIS_MODULE,
 	.name		= "CPiA Camera",
 	.type		= VID_TYPE_CAPTURE,
+	.function	= V4L2_FN_VIDEO_CAP,
 	.fops           = &cpia_fops,
 };
 
diff -r 6aa6656852cb linux/drivers/media/video/cx88/cx88-blackbird.c
--- a/linux/drivers/media/video/cx88/cx88-blackbird.c	Wed Apr 16 13:13:15 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-blackbird.c	Wed Apr 16 17:53:13 2008 -0700
@@ -1201,6 +1201,7 @@ static struct video_device cx8802_mpeg_t
 {
 	.name                 = "cx8802",
 	.type                 = VID_TYPE_CAPTURE|VID_TYPE_TUNER|VID_TYPE_SCALES|VID_TYPE_MPEG_ENCODER,
+	.function             = V4L2_FN_MPEG_CAP,
 	.fops                 = &mpeg_fops,
 	.minor                = -1,
 	.vidioc_querymenu     = vidioc_querymenu,
diff -r 6aa6656852cb linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Wed Apr 16 13:13:15 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Wed Apr 16 17:53:13 2008 -0700
@@ -1974,6 +1974,7 @@ static struct video_device cx8800_video_
 {
 	.name                 = "cx8800-video",
 	.type                 = VID_TYPE_CAPTURE|VID_TYPE_TUNER|VID_TYPE_SCALES,
+	.function             = V4L2_FN_MPEG_CAP,
 	.fops                 = &video_fops,
 	.minor                = -1,
 	.vidioc_querycap      = vidioc_querycap,
@@ -2028,6 +2029,7 @@ static struct video_device cx8800_radio_
 {
 	.name                 = "cx8800-radio",
 	.type                 = VID_TYPE_TUNER,
+	.function             = V4L2_FN_RADIO_CAP,
 	.fops                 = &radio_fops,
 	.minor                = -1,
 	.vidioc_querycap      = radio_querycap,
@@ -2120,6 +2122,7 @@ static int __devinit cx8800_initdev(stru
 		sizeof(cx8800_vbi_template) );
 	strcpy(cx8800_vbi_template.name,"cx8800-vbi");
 	cx8800_vbi_template.type = VID_TYPE_TELETEXT|VID_TYPE_TUNER;
+	cx8800_vbi_template.function = V4L2_FN_VBI_CAP;
 
 	/* initialize driver struct */
 #if 0
diff -r 6aa6656852cb linux/drivers/media/video/ivtv/ivtv-streams.c
--- a/linux/drivers/media/video/ivtv/ivtv-streams.c	Wed Apr 16 13:13:15 2008 -0300
+++ b/linux/drivers/media/video/ivtv/ivtv-streams.c	Wed Apr 16 17:53:13 2008 -0700
@@ -218,6 +218,40 @@ static int ivtv_prep_dev(struct ivtv *it
 	s->v4l2dev->dev = &itv->dev->dev;
 	s->v4l2dev->fops = ivtv_stream_info[type].fops;
 	s->v4l2dev->release = video_device_release;
+
+	/* Map ivtv stream type to v4l2 function type */
+	switch (s->type) {
+	case IVTV_ENC_STREAM_TYPE_MPG:
+		s->v4l2dev->function = V4L2_FN_MPEG_CAP;
+		break;
+	case IVTV_ENC_STREAM_TYPE_YUV:
+		s->v4l2dev->function = V4L2_FN_YUV_CAP;
+		break;
+	case IVTV_ENC_STREAM_TYPE_VBI:
+		s->v4l2dev->function = V4L2_FN_VBI_CAP;
+		break;
+	case IVTV_ENC_STREAM_TYPE_PCM:
+		s->v4l2dev->function = V4L2_FN_PCM_CAP;
+		break;
+	case IVTV_ENC_STREAM_TYPE_RAD:
+		s->v4l2dev->function = V4L2_FN_RADIO_CAP;
+		break;
+	case IVTV_DEC_STREAM_TYPE_MPG:
+		s->v4l2dev->function = V4L2_FN_MPEG_OUT;
+		break;
+	case IVTV_DEC_STREAM_TYPE_VBI:
+		s->v4l2dev->function = V4L2_FN_VBI_OUT;
+		break;
+	case IVTV_DEC_STREAM_TYPE_VOUT:
+		s->v4l2dev->function = V4L2_FN_VIDEO_OUT;
+		break;
+	case IVTV_DEC_STREAM_TYPE_YUV:
+		s->v4l2dev->function = V4L2_FN_YUV_OUT;
+		break;
+	default:
+		s->v4l2dev->function = V4L2_FN_UNDEFINED;
+		break;
+	}
 
 	return 0;
 }
diff -r 6aa6656852cb linux/drivers/media/video/ov511.c
--- a/linux/drivers/media/video/ov511.c	Wed Apr 16 13:13:15 2008 -0300
+++ b/linux/drivers/media/video/ov511.c	Wed Apr 16 17:53:13 2008 -0700
@@ -4674,6 +4674,7 @@ static struct video_device vdev_template
 	.owner =	THIS_MODULE,
 	.name =		"OV511 USB Camera",
 	.type =		VID_TYPE_CAPTURE,
+	.function =	V4L2_FN_VIDEO_CAP,
 	.fops =		&ov511_fops,
 	.release =	video_device_release,
 	.minor =	-1,


-- 
Kees Cook                                            @outflux.net

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
