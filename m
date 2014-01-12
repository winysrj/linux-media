Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39573 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaALQXt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 11:23:49 -0500
Received: by mail-ee0-f51.google.com with SMTP id b15so2740750eek.24
        for <linux-media@vger.kernel.org>; Sun, 12 Jan 2014 08:23:48 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFT/RFC PATCH 5/8] em28xx-v4l: move v4l2_ctrl_handler freeing and v4l2_device unregistration to em28xx_v4l2_fini
Date: Sun, 12 Jan 2014 17:24:22 +0100
Message-Id: <1389543865-2534-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_ctrl_handler_free() and v4l2_device_unregister() are currently only called
when the last user closes the device and the device is already disconnected.
But that's wrong, we need to call these functions whenever the em28xx-v4l
extension is closed and we can already do this if the device is still opened
by some users.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    7 ++++---
 1 Datei geändert, 4 Zeilen hinzugefügt(+), 3 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 7535762..3ac8700 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1923,8 +1923,11 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 		dev->vdev = NULL;
 	}
 
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+	v4l2_device_unregister(&dev->v4l2_dev);
+
 	if (dev->users)
-		em28xx_warn("Device is open ! Deregistration and memory deallocation are deferred on close.\n");
+		em28xx_warn("Device is open ! Memory deallocation is deferred on last close.\n");
 
 	return 0;
 }
@@ -1951,8 +1954,6 @@ static int em28xx_v4l2_close(struct file *filp)
 
 		if (dev->disconnected) {
 			em28xx_release_resources(dev);
-			v4l2_ctrl_handler_free(&dev->ctrl_handler);
-			v4l2_device_unregister(&dev->v4l2_dev);
 			kfree(dev->alt_max_pkt_size_isoc);
 			goto exit;
 		}
-- 
1.7.10.4

