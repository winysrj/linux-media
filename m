Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:64080 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbZCRRsu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 13:48:50 -0400
Message-ID: <49C133F6.3020202@freemail.hu>
Date: Wed, 18 Mar 2009 18:48:38 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] gspca: add missing .type field check in VIDIOC_G_PARM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
+++ linux-2.6.29-rc8/drivers/media/video/gspca/gspca.c	2009-03-18 16:51:03.000000000 +0100
@@ -1320,6 +1320,9 @@ static int vidioc_g_parm(struct file *fi
 {
 	struct gspca_dev *gspca_dev = priv;

+	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
 	memset(parm, 0, sizeof *parm);
 	parm->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	parm->parm.capture.readbuffers = gspca_dev->nbufread;

