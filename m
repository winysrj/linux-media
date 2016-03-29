Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:39809 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbcC2AZe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2016 20:25:34 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	nenggun.kim@samsung.com, jh1009.sung@samsung.com,
	chehabrafael@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: au0828 fix au0828_v4l2_device_register() to not unlock and free
Date: Mon, 28 Mar 2016 18:25:29 -0600
Message-Id: <1459211129-7968-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

au0828_v4l2_device_register() unlocks au0828_dev->lock and frees au0828
dev in error legs before return. au0828_usb_probe() does the same when
au0828_v4l2_device_register() returns error.

Fix au0828_v4l2_device_register() to not to unlock and free in its error
legs.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 32d7db9..7d0ec4c 100644
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
2.5.0

