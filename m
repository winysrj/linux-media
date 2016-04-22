Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:49118 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbcDVWHD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 18:07:03 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Subject: [PATCH] [media] au0828: fix double free in au0828_usb_probe()
Date: Sat, 23 Apr 2016 01:05:07 +0300
Message-Id: <1461362707-6883-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case of failure au0828_v4l2_device_register() deallocates dev
and returns error code to au0828_usb_probe(), which also
calls kfree(dev) on a failure path.

The patch removes duplicated code from au0828_v4l2_device_register().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/usb/au0828/au0828-video.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 32d7db96479c..7d0ec4cb248c 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -679,8 +679,6 @@ int au0828_v4l2_device_register(struct usb_interface *interface,
 	if (retval) {
 		pr_err("%s() v4l2_device_register failed\n",
 		       __func__);
-		mutex_unlock(&dev->lock);
-		kfree(dev);
 		return retval;
 	}
 
@@ -691,8 +689,6 @@ int au0828_v4l2_device_register(struct usb_interface *interface,
 	if (retval) {
 		pr_err("%s() v4l2_ctrl_handler_init failed\n",
 		       __func__);
-		mutex_unlock(&dev->lock);
-		kfree(dev);
 		return retval;
 	}
 	dev->v4l2_dev.ctrl_handler = &dev->v4l2_ctrl_hdl;
-- 
1.9.1

