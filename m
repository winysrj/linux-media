Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33833 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdI0JWQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 05:22:16 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: andreyknvl@google.com, mchehab@kernel.org, kcc@google.com,
        dvyukov@google.com, mchehab@s-opensource.com,
        javier@osg.samsung.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller@googlegroups.com
Subject: [RFT] [media] siano: FIX use-after-free in worker_thread
Date: Wed, 27 Sep 2017 14:51:05 +0530
Message-Id: <eba212d6d5b631365c5881b0ef4e16a9a8ea8cf6.1506502997.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If CONFIG_MEDIA_CONTROLLER_DVB is enable, We are not releasing
media device and memory on any failure or disconnect a device.

Adding structure media_device 'mdev' as part of 'smsusb_device_t'
structure to make proper handle for media device.
Now releasing a media device and memory on failure. It's allocate
first in siano_media_device_register() and it should be freed last
in smsusb_disconnect().

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
This bug report by Andrey Konovalov "usb/media/smsusb: use-after-free in
worker_thread".

 drivers/media/usb/siano/smsusb.c | 45 ++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 8c1f926..66936b3 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -69,6 +69,9 @@ struct smsusb_device_t {
 	unsigned char in_ep;
 	unsigned char out_ep;
 	enum smsusb_state state;
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	struct media_device *mdev;
+#endif
 };
 
 static int smsusb_submit_urb(struct smsusb_device_t *dev,
@@ -359,6 +362,13 @@ static void smsusb_term_device(struct usb_interface *intf)
 		if (dev->coredev)
 			smscore_unregister_device(dev->coredev);
 
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+		if (dev->mdev) {
+			media_device_unregister(dev->mdev);
+			media_device_cleanup(dev->mdev);
+			kfree(dev->mdev);
+		}
+#endif
 		pr_debug("device 0x%p destroyed\n", dev);
 		kfree(dev);
 	}
@@ -370,27 +380,28 @@ static void *siano_media_device_register(struct smsusb_device_t *dev,
 					int board_id)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	struct media_device *mdev;
 	struct usb_device *udev = dev->udev;
 	struct sms_board *board = sms_get_board(board_id);
 	int ret;
 
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
-	if (!mdev)
+	dev->mdev = kzalloc(sizeof(*dev->mdev), GFP_KERNEL);
+	if (!dev->mdev)
 		return NULL;
 
-	media_device_usb_init(mdev, udev, board->name);
 
-	ret = media_device_register(mdev);
+	media_device_usb_init(dev->mdev, udev, board->name);
+
+	ret = media_device_register(dev->mdev);
 	if (ret) {
-		media_device_cleanup(mdev);
-		kfree(mdev);
+		media_device_cleanup(dev->mdev);
+		kfree(dev->mdev);
+		dev->mdev = NULL;
 		return NULL;
 	}
 
 	pr_info("media controller created\n");
 
-	return mdev;
+	return dev->mdev;
 #else
 	return NULL;
 #endif
@@ -458,12 +469,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	rc = smscore_register_device(&params, &dev->coredev, mdev);
 	if (rc < 0) {
 		pr_err("smscore_register_device(...) failed, rc %d\n", rc);
-		smsusb_term_device(intf);
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
-		media_device_unregister(mdev);
-#endif
-		kfree(mdev);
-		return rc;
+		goto err_smsusb_init;
 	}
 
 	smscore_set_board_id(dev->coredev, board_id);
@@ -480,8 +486,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	rc = smsusb_start_streaming(dev);
 	if (rc < 0) {
 		pr_err("smsusb_start_streaming(...) failed\n");
-		smsusb_term_device(intf);
-		return rc;
+		goto err_smsusb_init;
 	}
 
 	dev->state = SMSUSB_ACTIVE;
@@ -489,13 +494,17 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	rc = smscore_start_device(dev->coredev);
 	if (rc < 0) {
 		pr_err("smscore_start_device(...) failed\n");
-		smsusb_term_device(intf);
-		return rc;
+		goto err_smsusb_init;
 	}
 
 	pr_debug("device 0x%p created\n", dev);
 
 	return rc;
+
+err_smsusb_init:
+	smsusb_term_device(intf);
+
+	return rc;
 }
 
 static int smsusb_probe(struct usb_interface *intf,
-- 
1.9.1
