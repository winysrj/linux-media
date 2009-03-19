Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:55802 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbZCSGwv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 02:52:51 -0400
Message-ID: <49C1EBBB.1080109@freemail.hu>
Date: Thu, 19 Mar 2009 07:52:43 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>,
	Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gspca: add missing .type field check in VIDIOC_G_PARM
References: <49C133F6.3020202@freemail.hu> <30353c3d0903181445i409604e8r33678f7ce09d0288@mail.gmail.com> <49C1DD0C.4050500@freemail.hu>
In-Reply-To: <49C1DD0C.4050500@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Németh Márton wrote:
From: Márton Németh <nm127@freemail.hu>

The gspca webcam driver does not check the .type field of struct v4l2_streamparm.
This field is an input parameter for the driver according to V4L2 API specification,
revision 0.24 [1]. Add the missing check.

The missing check was recognised by v4l-test 0.10 [2] together with gspca_sunplus driver
and with "Trust 610 LCD POWERC@M ZOOM" webcam. This patch was verified also with
v4l-test 0.10.

References:
[1] V4L2 API specification, revision 0.24
   http://v4l2spec.bytesex.org/spec/r11680.htm

[2] v4l-test: Test environment for Video For Linux Two API
    http://v4l-test.sourceforge.net/

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.29-rc8/drivers/media/video/gspca/gspca.c.orig	2009-03-14 12:29:38.000000000 +0100
+++ linux-2.6.29-rc8/drivers/media/video/gspca/gspca.c	2009-03-19 07:14:40.000000000 +0100
@@ -1319,9 +1319,14 @@ static int vidioc_g_parm(struct file *fi
 			struct v4l2_streamparm *parm)
 {
 	struct gspca_dev *gspca_dev = priv;
+	enum v4l2_buf_type type;

+	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	type = parm->type;
 	memset(parm, 0, sizeof *parm);
-	parm->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	parm->type = type;
 	parm->parm.capture.readbuffers = gspca_dev->nbufread;

 	if (gspca_dev->sd_desc->get_streamparm) {
