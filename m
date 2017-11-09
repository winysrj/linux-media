Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:47130 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbdKIFuB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Nov 2017 00:50:01 -0500
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, andreyknvl@google.com, kcc@google.com,
        dvyukov@google.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [RFT] [media] em28xx: Fix use-after-free in v4l2_fh_init
Date: Thu,  9 Nov 2017 11:19:12 +0530
Message-Id: <47c1c53ffe47fbd34a3f1aae92391e7ff5a0aab8.1510205498.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here, em28xx_free_v4l2 is release "v4l2->dev->v4l2"
Which is allready release by em28xx_v4l2_init.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
This bug report by Andrey Konovalov "net/media/em28xx: use-after-free in v4l2_fh_init"

 drivers/media/usb/em28xx/em28xx-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 8d253a5..f1ee53f 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2785,8 +2785,8 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	v4l2_ctrl_handler_free(&v4l2->ctrl_handler);
 	v4l2_device_unregister(&v4l2->v4l2_dev);
 err:
-	dev->v4l2 = NULL;
 	kref_put(&v4l2->ref, em28xx_free_v4l2);
+	dev->v4l2 = NULL;
 	mutex_unlock(&dev->lock);
 	return ret;
 }
-- 
1.9.1
