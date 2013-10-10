Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34744 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab3JJSbp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Oct 2013 14:31:45 -0400
Received: by mail-ee0-f46.google.com with SMTP id c13so1352253eek.19
        for <linux-media@vger.kernel.org>; Thu, 10 Oct 2013 11:31:43 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	stable@kernel.org
Subject: [PATCH] em28xx: fix error path in em28xx_start_analog_streaming()
Date: Thu, 10 Oct 2013 20:31:53 +0200
Message-Id: <1381429913-6308-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Increase the streaming_users count only if streaming start succeeds.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Cc: stable@kernel.org
---
 drivers/media/usb/em28xx/em28xx-video.c |    7 ++++---
 1 Datei geändert, 4 Zeilen hinzugefügt(+), 3 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 9d10334..fc5d60e 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -638,7 +638,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 	if (rc)
 		return rc;
 
-	if (dev->streaming_users++ == 0) {
+	if (dev->streaming_users == 0) {
 		/* First active streaming user, so allocate all the URBs */
 
 		/* Allocate the USB bandwidth */
@@ -657,7 +657,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 					  dev->packet_multiplier,
 					  em28xx_urb_data_copy);
 		if (rc < 0)
-			goto fail;
+			return rc;
 
 		/*
 		 * djh: it's not clear whether this code is still needed.  I'm
@@ -675,7 +675,8 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
 	}
 
-fail:
+	dev->streaming_users++;
+
 	return rc;
 }
 
-- 
1.7.10.4

