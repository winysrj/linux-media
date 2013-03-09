Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:60967 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab3CIKwV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Mar 2013 05:52:21 -0500
Received: by mail-ee0-f54.google.com with SMTP id c41so1433841eek.27
        for <linux-media@vger.kernel.org>; Sat, 09 Mar 2013 02:52:20 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: set the timestamp type for video and vbi vb2_queues
Date: Sat,  9 Mar 2013 11:53:01 +0100
Message-Id: <1362826381-4460-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The em28xx driver obtains the timestamps using function v4l2_get_timestamp(),
which produces a montonic timestamp.

Fixes the warnings appearing in the system log since commit 6aa69f99
"[media] vb2: Add support for non monotonic timestamps"

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    2 ++
 1 Datei geändert, 2 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 93fc620..d585c19 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -700,6 +700,7 @@ int em28xx_vb2_setup(struct em28xx *dev)
 	q = &dev->vb_vidq;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->drv_priv = dev;
 	q->buf_struct_size = sizeof(struct em28xx_buffer);
 	q->ops = &em28xx_video_qops;
@@ -713,6 +714,7 @@ int em28xx_vb2_setup(struct em28xx *dev)
 	q = &dev->vb_vbiq;
 	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
 	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
+	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->drv_priv = dev;
 	q->buf_struct_size = sizeof(struct em28xx_buffer);
 	q->ops = &em28xx_vbi_qops;
-- 
1.7.10.4

