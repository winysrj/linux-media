Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:63047 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbZGGGVP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jul 2009 02:21:15 -0400
Message-ID: <4A52E8A1.40408@freemail.hu>
Date: Tue, 07 Jul 2009 08:18:09 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] v4l2: remove unnecessary vidioc_s_std() from gspca
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The vidioc_s_std() is not necessary when vdev->tvnorms == 0. [1]

The changeset was tested together with v4l-test 0.16 [2] with
gspca_sunplus driver together with Trust 610 LCD POWERC@M ZOOM.

References:
[1] V4L2 API specification, revision 0.24
    http://v4l2spec.bytesex.org/spec/x448.htm

[2] v4l-test: Test environment for Video For Linux Two API
    http://v4l-test.sourceforge.net/

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.31-rc1/drivers/media/video/gspca/gspca.c.orig	2009-06-25 01:25:37.000000000 +0200
+++ linux-2.6.31-rc1/drivers/media/video/gspca/gspca.c	2009-07-06 08:14:19.000000000 +0200
@@ -1405,12 +1405,6 @@ static int vidioc_s_parm(struct file *fi
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
@@ -1881,7 +1875,6 @@ static const struct v4l2_ioctl_ops dev_i
 	.vidioc_s_jpegcomp	= vidioc_s_jpegcomp,
 	.vidioc_g_parm		= vidioc_g_parm,
 	.vidioc_s_parm		= vidioc_s_parm,
-	.vidioc_s_std		= vidioc_s_std,
 	.vidioc_enum_framesizes = vidioc_enum_framesizes,
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 	.vidiocgmbuf          = vidiocgmbuf,
