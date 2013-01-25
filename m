Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:42017 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637Ab3AYR0y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 12:26:54 -0500
Received: by mail-ee0-f50.google.com with SMTP id e51so323266eek.37
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 09:26:53 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [REVIEW PATCH 06/12] em28xx: make ioctls VIDIOC_G/S_PARM working for VBI devices
Date: Fri, 25 Jan 2013 18:26:56 +0100
Message-Id: <1359134822-4585-7-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the current code V4L2_BUF_TYPE_VIDEO_CAPTURE is accepted only, but for VBI
devices only buffer type V4L2_BUF_TYPE_VBI_CAPTURE is used/valid.

Remove the buffer type check entirely, because this is already done by the v4l2-core.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    6 ------
 1 Datei geändert, 6 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index d4dc5b2..6172d59 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1024,9 +1024,6 @@ static int vidioc_g_parm(struct file *file, void *priv,
 	struct em28xx      *dev = fh->dev;
 	int rc = 0;
 
-	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
 	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
 	if (dev->board.is_webcam)
 		rc = v4l2_device_call_until_err(&dev->v4l2_dev, 0,
@@ -1044,9 +1041,6 @@ static int vidioc_s_parm(struct file *file, void *priv,
 	struct em28xx_fh   *fh  = priv;
 	struct em28xx      *dev = fh->dev;
 
-	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
 	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
 	return v4l2_device_call_until_err(&dev->v4l2_dev, 0, video, s_parm, p);
 }
-- 
1.7.10.4

