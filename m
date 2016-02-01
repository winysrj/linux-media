Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:36623 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbcBAP7b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2016 10:59:31 -0500
From: Insu Yun <wuninsu@gmail.com>
To: hverkuil@xs4all.nl, mchehab@osg.samsung.com, khoroshilov@ispras.ru,
	arnd@arndb.de, vdronov@redhat.com, oneukum@suse.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] usbvision: fix locking error
Date: Mon,  1 Feb 2016 10:59:30 -0500
Message-Id: <1454342370-14609-1-git-send-email-wuninsu@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When remove_pending is non-zero, v4l2_lock is never unlocked.

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/media/usb/usbvision/usbvision-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index de9ff3b..75d06ea 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1156,6 +1156,7 @@ static int usbvision_radio_close(struct file *file)
 	usbvision_audio_off(usbvision);
 	usbvision->radio = 0;
 	usbvision->user--;
+	mutex_unlock(&usbvision->v4l2_lock);
 
 	if (usbvision->remove_pending) {
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
@@ -1164,7 +1165,6 @@ static int usbvision_radio_close(struct file *file)
 		return 0;
 	}
 
-	mutex_unlock(&usbvision->v4l2_lock);
 	PDEBUG(DBG_IO, "success");
 	return v4l2_fh_release(file);
 }
-- 
1.9.1

