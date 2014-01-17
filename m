Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62877 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbaAQRo2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 12:44:28 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so1898300eae.33
        for <linux-media@vger.kernel.org>; Fri, 17 Jan 2014 09:44:27 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/3] em28xx-video: do not unregister the v4l2 dummy clock before v4l2_device_unregister() has been called
Date: Fri, 17 Jan 2014 18:45:30 +0100
Message-Id: <1389980732-8375-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwiese the core refuses to unregister the clock and the following warning
appears in the system log:

"WARNING: ... at drivers/media/v4l2-core/v4l2-clk.c:231 v4l2_clk_unregister+0x8a/0x90 [videodev]()
 v4l2_clk_unregister(): Refusing to unregister ref-counted 11-0030:mclk clock!"

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    6 +++---
 1 Datei geändert, 3 Zeilen hinzugefügt(+), 3 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index c3c9289..09e18da 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1918,14 +1918,14 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 		video_unregister_device(dev->vdev);
 	}
 
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+	v4l2_device_unregister(&dev->v4l2_dev);
+
 	if (dev->clk) {
 		v4l2_clk_unregister_fixed(dev->clk);
 		dev->clk = NULL;
 	}
 
-	v4l2_ctrl_handler_free(&dev->ctrl_handler);
-	v4l2_device_unregister(&dev->v4l2_dev);
-
 	if (dev->users)
 		em28xx_warn("Device is open ! Memory deallocation is deferred on last close.\n");
 	mutex_unlock(&dev->lock);
-- 
1.7.10.4

