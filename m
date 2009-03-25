Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:54685 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZCYQvs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 12:51:48 -0400
Message-ID: <49CA611B.5050902@freemail.hu>
Date: Wed, 25 Mar 2009 17:51:39 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] v4l2: fill reserved fields of VIDIOC_ENUMAUDIO also
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

When enumerating audio inputs with VIDIOC_ENUMAUDIO the gspca_sunplus driver
does not fill the reserved fields of the struct v4l2_audio with zeros as
required by V4L2 API revision 0.24 [1]. Add the missing initializations to
the V4L2 framework.

The patch was tested with v4l-test 0.10 [2] with gspca_sunplus driver and
with Trust 610 LCD POWERC@M ZOOM webcam.

References:
[1] V4L2 API specification, revision 0.24
    http://v4l2spec.bytesex.org/spec/r8242.htm

[2] v4l-test: Test environment for Video For Linux Two API
    http://v4l-test.sourceforge.net/

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.29/drivers/media/video/v4l2-ioctl.c.orig	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29/drivers/media/video/v4l2-ioctl.c	2009-03-25 17:11:27.000000000 +0100
@@ -1363,9 +1363,13 @@ static long __video_do_ioctl(struct file
 	case VIDIOC_ENUMAUDIO:
 	{
 		struct v4l2_audio *p = arg;
+		__u32 index = p->index;

 		if (!ops->vidioc_enumaudio)
 			break;
+
+		memset(p, 0, sizeof(*p));
+		p->index = index;
 		ret = ops->vidioc_enumaudio(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "index=%d, name=%s, capability=0x%x, "
