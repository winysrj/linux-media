Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5UKvqmS008422
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 16:57:52 -0400
Received: from mail.laptop.org (lists.laptop.org [18.85.2.145])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5UKvduZ018647
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 16:57:39 -0400
To: mchehab@infradead.org
From: Daniel Drake <dsd@laptop.org>
Message-Id: <20080630205739.74EE1FAA95@dev.laptop.org>
Date: Mon, 30 Jun 2008 16:57:39 -0400 (EDT)
Cc: video4linux-list@redhat.com, corbet@lwn.net
Subject: [PATCH] OV7670: don't reject unsupported settings
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

For VIDIOC_G_FMT/VIDIOC_TRY_FMT, the V4L2 API spec states:
"Drivers should not return an error code unless the input is ambiguous"
"Very simple, inflexible devices may even ignore all input and always
return the default parameters."
"When the requested buffer type is not supported drivers return an
EINVAL error code."
i.e. returning errors for unsupported fields is bad, and it's ok to
unconditionally overwrite user-requested settings

This patch makes ov7670 meet that behaviour, and brings it in line with
other drivers e.g. stk-webcam. It also fixes compatibility with (unpatched)
gstreamer.

Signed-off-by: Daniel Drake <dsd@laptop.org>

---

This patch is a bit controversial because the V4L2 API spec is not
crystal clear and other drivers (e.g. zr364xx) also behave the same way
(and do not work with gstreamer). I haven't had any responses to my
request for clarification:
http://marc.info/?l=linux-video&m=121434022130546&w=2

If this patch is accepted, I have some patches for other drivers that I
can submit.

diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 2bc6bdc..f201af2 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -680,17 +680,17 @@ static int ov7670_try_fmt(struct i2c_client *c, struct v4l2_format *fmt,
 	for (index = 0; index < N_OV7670_FMTS; index++)
 		if (ov7670_formats[index].pixelformat == pix->pixelformat)
 			break;
-	if (index >= N_OV7670_FMTS)
-		return -EINVAL;
+	if (index >= N_OV7670_FMTS) {
+		/* default to first format */
+		index = 0;
+		pix->pixelformat = ov7670_formats[0].pixelformat;
+	}
 	if (ret_fmt != NULL)
 		*ret_fmt = ov7670_formats + index;
 	/*
 	 * Fields: the OV devices claim to be progressive.
 	 */
-	if (pix->field == V4L2_FIELD_ANY)
-		pix->field = V4L2_FIELD_NONE;
-	else if (pix->field != V4L2_FIELD_NONE)
-		return -EINVAL;
+	pix->field = V4L2_FIELD_NONE;
 	/*
 	 * Round requested image size down to the nearest
 	 * we support, but not below the smallest.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
