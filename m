Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50196 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab3L1MQ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 20/24] em28xx: Fix em28xx deplock
Date: Sat, 28 Dec 2013 10:16:12 -0200
Message-Id: <1388232976-20061-21-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

When em28xx extensions are loaded/removed, there are two locks:

a single static em28xx_devlist_mutex that registers each extension
and the struct em28xx dev->lock.

When extensions are registered, em28xx_devlist_mutex is taken first,
and then dev->lock.

Be sure that, when extensions are being removed, the same order
will be used.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 10 ++++++----
 drivers/media/usb/em28xx/em28xx-core.c  |  2 ++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 4fe742429f2c..16383f46dae9 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3334,9 +3334,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 	dev->disconnected = 1;
 
 	if (dev->is_audio_only) {
-		mutex_lock(&dev->lock);
 		em28xx_close_extension(dev);
-		mutex_unlock(&dev->lock);
 		return;
 	}
 
@@ -3355,19 +3353,23 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
 		em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
 	}
+	mutex_unlock(&dev->lock);
 
 	em28xx_close_extension(dev);
+
 	/* NOTE: must be called BEFORE the resources are released */
 
+	mutex_lock(&dev->lock);
 	if (!dev->users)
 		em28xx_release_resources(dev);
 
-	mutex_unlock(&dev->lock);
-
 	if (!dev->users) {
+		mutex_unlock(&dev->lock);
 		kfree(dev->alt_max_pkt_size_isoc);
 		kfree(dev);
+		return;
 	}
+	mutex_unlock(&dev->lock);
 }
 
 static struct usb_driver em28xx_usb_driver = {
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 2ad84ff1fc4f..d6928d83fb2a 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1098,8 +1098,10 @@ void em28xx_close_extension(struct em28xx *dev)
 
 	mutex_lock(&em28xx_devlist_mutex);
 	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
+		mutex_lock(&dev->lock);
 		if (ops->fini)
 			ops->fini(dev);
+		mutex_unlock(&dev->lock);
 	}
 	list_del(&dev->devlist);
 	mutex_unlock(&em28xx_devlist_mutex);
-- 
1.8.3.1

