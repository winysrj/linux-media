Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43693 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaADN7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 08:59:17 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v4 15/22] [media] em28xx: Fix em28xx deplock
Date: Sat,  4 Jan 2014 08:55:44 -0200
Message-Id: <1388832951-11195-16-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When em28xx extensions are loaded/removed, there are two locks:

a single static em28xx_devlist_mutex that registers each extension
and the struct em28xx dev->lock.

When extensions are registered, em28xx_devlist_mutex is taken first,
and then dev->lock.

Be sure that, when extensions are being removed, the same order
will be used.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 5 +++--
 drivers/media/usb/em28xx/em28xx-core.c  | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 4fe742429f2c..36aec50e5c3b 100644
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
 
@@ -3355,10 +3353,13 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
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
 
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 2ad84ff1fc4f..97cc83c3c287 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1097,10 +1097,12 @@ void em28xx_close_extension(struct em28xx *dev)
 	const struct em28xx_ops *ops = NULL;
 
 	mutex_lock(&em28xx_devlist_mutex);
+	mutex_lock(&dev->lock);
 	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
 		if (ops->fini)
 			ops->fini(dev);
 	}
+	mutex_unlock(&dev->lock);
 	list_del(&dev->devlist);
 	mutex_unlock(&em28xx_devlist_mutex);
 }
-- 
1.8.3.1

