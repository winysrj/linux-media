Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:51105 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3KFIjp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 03:39:45 -0500
Received: by mail-la0-f45.google.com with SMTP id el20so1425746lab.4
        for <linux-media@vger.kernel.org>; Wed, 06 Nov 2013 00:39:44 -0800 (PST)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] em28xx-video: Swap release order to avoid lock nesting
Date: Wed,  6 Nov 2013 09:39:35 +0100
Message-Id: <1383727175-26052-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vb2_fop_release might take the video queue mutex lock.
In order to avoid nesting mutexes the private mutex is taken after the
fop_release has finished.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 9d10334..b5c3360 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1663,8 +1663,8 @@ static int em28xx_v4l2_close(struct file *filp)
 
 	em28xx_videodbg("users=%d\n", dev->users);
 
-	mutex_lock(&dev->lock);
 	vb2_fop_release(filp);
+	mutex_lock(&dev->lock);
 
 	if (dev->users == 1) {
 		/* the device is already disconnect,
-- 
1.8.4.rc3

