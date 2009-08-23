Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:49231 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbZHWJaw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 05:30:52 -0400
Message-ID: <4A910C4B.1070600@freemail.hu>
Date: Sun, 23 Aug 2009 11:30:51 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [RESEND][PATCH 2/2] v4l2: remove unnecessary vidioc_s_std() from
 gspca
References: <4A52E8A1.40408@freemail.hu>
In-Reply-To: <4A52E8A1.40408@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The vidioc_s_std() is not necessary when vdev->tvnorms == 0. [1]

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
--- linux-2.6.31-rc7.orig/drivers/media/video/gspca/gspca.c	2009-08-23 07:36:08.000000000 +0200
+++ linux-2.6.31-rc7/drivers/media/video/gspca/gspca.c	2009-08-23 11:06:22.000000000 +0200
@@ -1473,12 +1473,6 @@ static int vidioc_s_parm(struct file *fi
 	return 0;
 }

-static int vidioc_s_std(struct file *filp, void *priv,
-			v4l2_std_id *parm)
-{
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 static int vidiocgmbuf(struct file *file, void *priv,
 			struct video_mbuf *mbuf)
@@ -1949,7 +1943,6 @@ static const struct v4l2_ioctl_ops dev_i
 	.vidioc_s_jpegcomp	= vidioc_s_jpegcomp,
 	.vidioc_g_parm		= vidioc_g_parm,
 	.vidioc_s_parm		= vidioc_s_parm,
-	.vidioc_s_std		= vidioc_s_std,
 	.vidioc_enum_framesizes = vidioc_enum_framesizes,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register	= vidioc_g_register,

