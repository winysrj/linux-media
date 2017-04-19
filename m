Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:36659 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940326AbdDSXOh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 19:14:37 -0400
Received: by mail-qk0-f182.google.com with SMTP id d131so33190521qkc.3
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 16:14:37 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 12/12] au0828: Add timer to restart TS stream if no data arrives on bulk endpoint
Date: Wed, 19 Apr 2017 19:13:55 -0400
Message-Id: <1492643635-30823-13-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
References: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For reasons unclear, we intermittently see a case where the tune
is successful but the bulk stream fails to deliver any packets.

Add a timer to automatically stop/start the data pump if we
encounter such a case.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/au0828/au0828-dvb.c | 30 ++++++++++++++++++++++++++++++
 drivers/media/usb/au0828/au0828.h     |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index 7e0c9b7..34dc7e0 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -105,6 +105,15 @@
 
 static void au0828_restart_dvb_streaming(struct work_struct *work);
 
+static void au0828_bulk_timeout(unsigned long data)
+{
+	struct au0828_dev *dev = (struct au0828_dev *) data;
+
+	dprintk(1, "%s called\n", __func__);
+	dev->bulk_timeout_running = 0;
+	schedule_work(&dev->restart_streaming);
+}
+
 /*-------------------------------------------------------------------*/
 static void urb_completion(struct urb *purb)
 {
@@ -138,6 +147,13 @@ static void urb_completion(struct urb *purb)
 			ptr[0], purb->actual_length);
 		schedule_work(&dev->restart_streaming);
 		return;
+	} else if (dev->bulk_timeout_running == 1) {
+		/* The URB handler has fired, so cancel timer which would
+		 * restart endpoint if we hadn't
+		 */
+		dprintk(1, "%s cancelling bulk timeout\n", __func__);
+		dev->bulk_timeout_running = 0;
+		del_timer(&dev->bulk_timeout);
 	}
 
 	/* Feed the transport payload into the kernel demux */
@@ -160,6 +176,11 @@ static int stop_urb_transfer(struct au0828_dev *dev)
 	if (!dev->urb_streaming)
 		return 0;
 
+	if (dev->bulk_timeout_running == 1) {
+		dev->bulk_timeout_running = 0;
+		del_timer(&dev->bulk_timeout);
+	}
+
 	dev->urb_streaming = false;
 	for (i = 0; i < URB_COUNT; i++) {
 		if (dev->urbs[i]) {
@@ -232,6 +253,11 @@ static int start_urb_transfer(struct au0828_dev *dev)
 	}
 
 	dev->urb_streaming = true;
+
+	/* If we don't valid data within 1 second, restart stream */
+	mod_timer(&dev->bulk_timeout, jiffies + (HZ));
+	dev->bulk_timeout_running = 1;
+
 	return 0;
 }
 
@@ -622,6 +648,10 @@ int au0828_dvb_register(struct au0828_dev *dev)
 		return ret;
 	}
 
+	dev->bulk_timeout.function = au0828_bulk_timeout;
+	dev->bulk_timeout.data = (unsigned long) dev;
+	init_timer(&dev->bulk_timeout);
+
 	return 0;
 }
 
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 88e5974..05e445f 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -195,6 +195,8 @@ struct au0828_dev {
 	/* Digital */
 	struct au0828_dvb		dvb;
 	struct work_struct              restart_streaming;
+	struct timer_list               bulk_timeout;
+	int                             bulk_timeout_running;
 
 #ifdef CONFIG_VIDEO_AU0828_V4L2
 	/* Analog */
-- 
1.9.1
