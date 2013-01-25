Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:46741 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab3AYR0v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 12:26:51 -0500
Received: by mail-ea0-f173.google.com with SMTP id i1so273571eaa.32
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 09:26:49 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [REVIEW PATCH 05/12] em28xx: disable ioctl VIDIOC_S_PARM for VBI devices
Date: Fri, 25 Jan 2013 18:26:55 +0100
Message-Id: <1359134822-4585-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_S_PARM doesn't make sense for VBI device nodes, because we don't support
selecting the number of read buffers to use.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    1 +
 1 Datei geändert, 1 Zeile hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index c76714d..d4dc5b2 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1920,6 +1920,7 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 		dev->vbi_dev->queue->lock = &dev->vb_vbi_queue_lock;
 
 		/* disable inapplicable ioctls */
+		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_PARM);
 		if (dev->tuner_type == TUNER_ABSENT) {
 			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_G_TUNER);
 			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_S_TUNER);
-- 
1.7.10.4

