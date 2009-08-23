Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:52016 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbZHWJap (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 05:30:45 -0400
Message-ID: <4A910C42.5000001@freemail.hu>
Date: Sun, 23 Aug 2009 11:30:42 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [RESEND][PATCH 1/2] v4l2: modify the webcam video standard handling
References: <4A52E897.8000607@freemail.hu>
In-Reply-To: <4A52E897.8000607@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Change the handling of the case when vdev->tvnorms == 0.

Quote from V4L2 API specification, rev. 0.24 [1]:
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

The changeset was tested together with v4l-test 0.19 [2] with
gspca_sunplus driver together with Trust 610 LCD POWERC@M ZOOM and
with gspca_pac7311 together with Labtec Webcam 2200.

References:
[1] V4L2 API specification, revision 0.24
    http://v4l2spec.bytesex.org/spec/x448.htm

[2] v4l-test: Test environment for Video For Linux Two API
    http://v4l-test.sourceforge.net/

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr linux-2.6.31-rc7.orig/drivers/media/video/v4l2-dev.c linux-2.6.31-rc7/drivers/media/video/v4l2-dev.c
--- linux-2.6.31-rc7.orig/drivers/media/video/v4l2-dev.c	2009-08-23 07:36:09.000000000 +0200
+++ linux-2.6.31-rc7/drivers/media/video/v4l2-dev.c	2009-08-23 10:47:03.000000000 +0200
@@ -396,6 +396,11 @@ int video_register_device_index(struct v
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
diff -upr linux-2.6.31-rc7.orig/drivers/media/video/v4l2-ioctl.c linux-2.6.31-rc7/drivers/media/video/v4l2-ioctl.c
--- linux-2.6.31-rc7.orig/drivers/media/video/v4l2-ioctl.c	2009-08-23 07:36:09.000000000 +0200
+++ linux-2.6.31-rc7/drivers/media/video/v4l2-ioctl.c	2009-08-23 10:50:08.000000000 +0200
@@ -1077,14 +1077,17 @@ static long __video_do_ioctl(struct file
 	{
 		v4l2_std_id *id = arg;

-		ret = 0;
-		/* Calls the specific handler */
-		if (ops->vidioc_g_std)
-			ret = ops->vidioc_g_std(file, fh, id);
-		else if (vfd->current_norm)
-			*id = vfd->current_norm;
-		else
-			ret = -EINVAL;
+		/* Check if any standard is supported */
+		if (vfd->tvnorms) {
+			ret = 0;
+			/* Calls the specific handler */
+			if (ops->vidioc_g_std)
+				ret = ops->vidioc_g_std(file, fh, id);
+			else if (vfd->current_norm)
+				*id = vfd->current_norm;
+			else
+				ret = -EINVAL;
+		}

 		if (!ret)
 			dbgarg(cmd, "std=0x%08Lx\n", (long long unsigned)*id);
@@ -1097,7 +1100,7 @@ static long __video_do_ioctl(struct file
 		dbgarg(cmd, "std=%08Lx\n", (long long unsigned)*id);

 		norm = (*id) & vfd->tvnorms;
-		if (vfd->tvnorms && !norm)	/* Check if std is supported */
+		if (!norm)	/* Check if std is supported */
 			break;

 		/* Calls the specific handler */
