Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48146 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbbBVQLy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 11:11:54 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 10/10] [media] siano: register media controller earlier
Date: Sun, 22 Feb 2015 13:11:41 -0300
Message-Id: <1424621501-17466-11-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
References: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to initialize the media controller earlier, as the core
will call the smsdvb hotplug during register time. Ok, this is
an async operation, so, when the module is not loaded, the media
controller works.

However, if the module is already loaded, nothing will be
registered at the media controller, as it will load too late.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/smscoreapi.c |  7 ++++++-
 drivers/media/common/siano/smscoreapi.h |  3 ++-
 drivers/media/usb/siano/smsusb.c        | 17 +++++++++++------
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index cb7515ba2193..2a8d9a36d6f0 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -653,7 +653,8 @@ smscore_buffer_t *smscore_createbuffer(u8 *buffer, void *common_buffer,
  * @return 0 on success, <0 on error.
  */
 int smscore_register_device(struct smsdevice_params_t *params,
-			    struct smscore_device_t **coredev)
+			    struct smscore_device_t **coredev,
+			    void *mdev)
 {
 	struct smscore_device_t *dev;
 	u8 *buffer;
@@ -662,6 +663,10 @@ int smscore_register_device(struct smsdevice_params_t *params,
 	if (!dev)
 		return -ENOMEM;
 
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	dev->media_dev = mdev;
+#endif
+
 	/* init list entry so it could be safe in smscore_unregister_device */
 	INIT_LIST_HEAD(&dev->entry);
 
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 6ff8f64a3794..eb8bd689b936 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -1123,7 +1123,8 @@ extern int smscore_register_hotplug(hotplug_t hotplug);
 extern void smscore_unregister_hotplug(hotplug_t hotplug);
 
 extern int smscore_register_device(struct smsdevice_params_t *params,
-				   struct smscore_device_t **coredev);
+				   struct smscore_device_t **coredev,
+				   void *mdev);
 extern void smscore_unregister_device(struct smscore_device_t *coredev);
 
 extern int smscore_start_device(struct smscore_device_t *coredev);
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 7d57b2677130..37fc1ef84575 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -340,12 +340,12 @@ static void smsusb_term_device(struct usb_interface *intf)
 	usb_set_intfdata(intf, NULL);
 }
 
-static void siano_media_device_register(struct smsusb_device_t *dev)
+static void *siano_media_device_register(struct smsusb_device_t *dev,
+					int board_id)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	struct media_device *mdev;
 	struct usb_device *udev = dev->udev;
-	int board_id = smscore_get_board_id(dev->coredev);
 	struct sms_board *board = sms_get_board(board_id);
 	int ret;
 
@@ -369,10 +369,11 @@ static void siano_media_device_register(struct smsusb_device_t *dev)
 		return;
 	}
 
-	dev->coredev->media_dev = mdev;
-
 	pr_info("media controller created\n");
 
+	return mdev;
+#else
+	return NULL;
 #endif
 }
 
@@ -380,6 +381,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 {
 	struct smsdevice_params_t params;
 	struct smsusb_device_t *dev;
+	void *mdev;
 	int i, rc;
 
 	/* create device object */
@@ -433,11 +435,15 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	params.context = dev;
 	usb_make_path(dev->udev, params.devpath, sizeof(params.devpath));
 
+	mdev = siano_media_device_register(dev, board_id);
+
 	/* register in smscore */
-	rc = smscore_register_device(&params, &dev->coredev);
+	rc = smscore_register_device(&params, &dev->coredev, mdev);
 	if (rc < 0) {
 		pr_err("smscore_register_device(...) failed, rc %d\n", rc);
 		smsusb_term_device(intf);
+		media_device_unregister(mdev);
+		kfree(mdev);
 		return rc;
 	}
 
@@ -469,7 +475,6 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	}
 
 	pr_debug("device 0x%p created\n", dev);
-	siano_media_device_register(dev);
 
 	return rc;
 }
-- 
2.1.0

