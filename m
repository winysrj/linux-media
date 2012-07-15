Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60243 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2GOGAq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jul 2012 02:00:46 -0400
Received: by yhmm54 with SMTP id m54so4733198yhm.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jul 2012 23:00:46 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] pwc: Use vb2 queue mutex through a single name
Date: Sun, 15 Jul 2012 03:00:33 -0300
Message-Id: <1342332033-30250-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This lock was being taken using two different names
(pointers) in the same function.
Both names refer to the same lock,
so this wasn't an error; but it looked very strange.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/pwc/pwc-if.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index de7c7ba..b5d0729 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -1127,7 +1127,7 @@ static void usb_pwc_disconnect(struct usb_interface *intf)
 	v4l2_device_disconnect(&pdev->v4l2_dev);
 	video_unregister_device(&pdev->vdev);
 	mutex_unlock(&pdev->v4l2_lock);
-	mutex_unlock(pdev->vb_queue.lock);
+	mutex_unlock(&pdev->vb_queue_lock);
 
 #ifdef CONFIG_USB_PWC_INPUT_EVDEV
 	if (pdev->button_dev)
-- 
1.7.8.6

