Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:56770 "EHLO
        smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161175AbdAIPlw (ORCPT
        <rfc822;groupwise-linux-media@vger.kernel.org:0:0>);
        Mon, 9 Jan 2017 10:41:52 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: mchehab@kernel.org
Cc: dave@stgolabs.net, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH] media/usbvision: remove ctrl_urb_wq
Date: Mon,  9 Jan 2017 07:41:34 -0800
Message-Id: <1483976494-25713-1-git-send-email-dave@stgolabs.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While the wakeup path seems to be set up, this waitqueue is actually
never used as no-one enqueues themselves on the list. As such, wakeups
are meaningless without waiters, so lets just get rid of the whole
thing.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 drivers/media/usb/usbvision/usbvision-core.c  | 2 --
 drivers/media/usb/usbvision/usbvision-video.c | 1 -
 drivers/media/usb/usbvision/usbvision.h       | 1 -
 3 files changed, 4 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index bf041a9e69db..c938aa477edf 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -1417,8 +1417,6 @@ static void usbvision_ctrl_urb_complete(struct urb *urb)
 
 	PDEBUG(DBG_IRQ, "");
 	usbvision->ctrl_urb_busy = 0;
-	if (waitqueue_active(&usbvision->ctrl_urb_wq))
-		wake_up_interruptible(&usbvision->ctrl_urb_wq);
 }
 
 
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index a7529196c327..97685d0ad7c9 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1340,7 +1340,6 @@ static struct usb_usbvision *usbvision_alloc(struct usb_device *dev,
 	usbvision->ctrl_urb = usb_alloc_urb(USBVISION_URB_FRAMES, GFP_KERNEL);
 	if (usbvision->ctrl_urb == NULL)
 		goto err_unreg;
-	init_waitqueue_head(&usbvision->ctrl_urb_wq);
 
 	return usbvision;
 
diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/usbvision/usbvision.h
index 4f2e4fde38f2..a5268c4f6a17 100644
--- a/drivers/media/usb/usbvision/usbvision.h
+++ b/drivers/media/usb/usbvision/usbvision.h
@@ -370,7 +370,6 @@ struct usb_usbvision {
 	unsigned char ctrl_urb_buffer[8];
 	int ctrl_urb_busy;
 	struct usb_ctrlrequest ctrl_urb_setup;
-	wait_queue_head_t ctrl_urb_wq;					/* Processes waiting */
 
 	/* configuration part */
 	int have_tuner;
-- 
2.6.6

