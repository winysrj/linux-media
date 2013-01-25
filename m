Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:61455 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669Ab3AYR1E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 12:27:04 -0500
Received: by mail-ea0-f181.google.com with SMTP id i13so271497eaa.40
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 09:27:02 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [REVIEW PATCH 09/12] em28xx: VIDIOC_G_TUNER: remove unneeded setting of tuner type
Date: Fri, 25 Jan 2013 18:26:59 +0100
Message-Id: <1359134822-4585-10-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tuner type is set by the v4l2-core based on the device type.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    1 -
 1 Datei geändert, 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index af3e70a..319d0ee 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1493,7 +1493,6 @@ static int radio_g_tuner(struct file *file, void *priv,
 		return -EINVAL;
 
 	strcpy(t->name, "Radio");
-	t->type = V4L2_TUNER_RADIO;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
 
-- 
1.7.10.4

