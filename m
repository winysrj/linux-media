Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:54678 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZGGGVH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jul 2009 02:21:07 -0400
Message-ID: <4A52E897.8000607@freemail.hu>
Date: Tue, 07 Jul 2009 08:17:59 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] v4l2: modify the webcam video standard handling
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Change the handling of the case when vdev->tvnorms == 0.

>From V4L2 API specification, rev. 0.24 [1]:
> Special rules apply to USB cameras where the notion of video
> standards makes little sense. More generally any capture device,
> output devices accordingly, which is
>
> * incapable of capturing fields or frames at the nominal rate
>   of the video standard, or
> * where timestamps refer to the instant the field or frame was
>   received by the driver, not the capture time, or
> * where sequence numbers refer to the frames received by the
>   driver, not the captured frames.
>
> Here the driver shall set the std field of struct v4l2_input
> and struct v4l2_output to zero, the VIDIOC_G_STD, VIDIOC_S_STD,
> VIDIOC_QUERYSTD and VIDIOC_ENUMSTD ioctls shall return the
> EINVAL error code.

The changeset was tested together with v4l-test 0.16 [2] with
gspca_sunplus driver together with Trust 610 LCD POWERC@M ZOOM.

References:
[1] V4L2 API specification, revision 0.24
    http://v4l2spec.bytesex.org/spec/x448.htm

[2] v4l-test: Test environment for Video For Linux Two API
    http://v4l-test.sourceforge.net/

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr linux-2.6.31-rc1.orig/drivers/media/video/v4l2-dev.c linux-2.6.31-rc1/drivers/media/video/v4l2-dev.c
--- linux-2.6.31-rc1.orig/drivers/media/video/v4l2-dev.c	2009-06-25 01:25:37.000000000 +0200
+++ linux-2.6.31-rc1/drivers/media/video/v4l2-dev.c	2009-07-06 07:48:13.000000000 +0200
@@ -397,6 +397,11 @@ int video_register_device_index(struct v
 	if (!vdev->release)
 		return -EINVAL;

+	/* if no video standards are supported then no need to get and set
+	   them: they will never be called */
+	WARN_ON(!vdev->tvnorms && vdev->ioctl_ops->vidioc_g_std);
+	WARN_ON(!vdev->tvnorms && vdev->ioctl_ops->vidioc_s_std);
+
 	/* Part 1: check device type */
 	switch (type) {
 	case VFL_TYPE_GRABBER:
diff -upr linux-2.6.31-rc1.orig/drivers/media/video/v4l2-ioctl.c linux-2.6.31-rc1/drivers/media/video/v4l2-ioctl.c
--- linux-2.6.31-rc1.orig/drivers/media/video/v4l2-ioctl.c	2009-06-25 01:25:37.000000000 +0200
+++ linux-2.6.31-rc1/drivers/media/video/v4l2-ioctl.c	2009-07-06 07:41:23.000000000 +0200
@@ -1077,12 +1077,15 @@ static long __video_do_ioctl(struct file
 	{
 		v4l2_std_id *id = arg;

-		ret = 0;
-		/* Calls the specific handler */
-		if (ops->vidioc_g_std)
-			ret = ops->vidioc_g_std(file, fh, id);
-		else
-			*id = vfd->current_norm;
+		/* Check if any standard is supported */
+		if (vfd->tvnorms) {
+			ret = 0;
+			/* Calls the specific handler */
+			if (ops->vidioc_g_std)
+				ret = ops->vidioc_g_std(file, fh, id);
+			else
+				*id = vfd->current_norm;
+		}

 		if (!ret)
 			dbgarg(cmd, "std=0x%08Lx\n", (long long unsigned)*id);
@@ -1095,7 +1098,7 @@ static long __video_do_ioctl(struct file
 		dbgarg(cmd, "std=%08Lx\n", (long long unsigned)*id);

 		norm = (*id) & vfd->tvnorms;
-		if (vfd->tvnorms && !norm)	/* Check if std is supported */
+		if (!norm)	/* Check if std is supported */
 			break;

 		/* Calls the specific handler */
