Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:39747 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbaAQRo3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 12:44:29 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so2246859eek.37
        for <linux-media@vger.kernel.org>; Fri, 17 Jan 2014 09:44:28 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/3] em28xx-v4l: do not call em28xx_init_camera() if the device has no sensor
Date: Fri, 17 Jan 2014 18:45:32 +0100
Message-Id: <1389980732-8375-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1389980732-8375-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1389980732-8375-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This avoids the unnecessary temporary registration of a dummy V4L2 clock.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    3 ++-
 1 Datei geändert, 2 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 09e18da..2775c90 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2273,7 +2273,8 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	}
 
 	em28xx_tuner_setup(dev);
-	em28xx_init_camera(dev);
+	if (dev->em28xx_sensor != EM28XX_NOSENSOR)
+		em28xx_init_camera(dev);
 
 	/* Configure audio */
 	ret = em28xx_audio_setup(dev);
-- 
1.7.10.4

