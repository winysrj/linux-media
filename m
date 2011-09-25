Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab1IYNAU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 09:00:20 -0400
Message-ID: <4E7F25D4.2080504@redhat.com>
Date: Sun, 25 Sep 2011 10:00:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v3] EM28xx - fix deadlock when unplugging and replugging
 a DVB adapter
References: <4E7E43A2.3020905@yahoo.com>
In-Reply-To: <4E7E43A2.3020905@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-09-2011 17:54, Chris Rankin escreveu:
> This fixes the deadlock that occurs with either multiple PCTV 290e adapters or when a single PCTV 290e adapter is replugged.
> 
> For DVB devices, the device lock must now *not* be held when adding/removing either a device or an extension to the respective lists. (Because em28xx_init_dvb() will want to take the lock instead).
> 
> Conversely, for Audio-Only devices, the device lock *must* be held when adding/removing either a device or an extension to the respective lists.
> 
> Signed-off-by: Chris Rankin <ranki...@yahoo.com>

Hmm... This would probably work better (not tested). Could you please test it
on your hardware?

From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Sat, 24 Sep 2011 16:54:58 -0300
Subject: [media] em28xx: fix deadlock when unplugging and replugging a DVB adapter

This fixes the deadlock that occurs with either multiple PCTV 290e
adapters or when a single PCTV 290e adapter is replugged.

For DVB devices, the device lock must now *not* be held when
adding/removing either a device or an extension to the respective lists.
(Because em28xx_init_dvb() will want to take the lock instead).

Conversely, for Audio-Only devices, the device lock *must* be held when
adding/removing either a device or an extension to the respective lists.

Based on a patch from Chris Rankin <rankincj@yahoo.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 7297d90..c92c177 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -3005,7 +3005,8 @@ static int em28xx_init_dev(struct em28xx **devhandle, struct usb_device *udev,
 		goto fail;
 	}
 
-	em28xx_init_extension(dev);
+	/* dev->lock needs to be holded */
+	__em28xx_init_extension(dev);
 
 	/* Save some power by putting tuner to sleep */
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
@@ -3301,10 +3302,10 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 		em28xx_release_resources(dev);
 	}
 
-	em28xx_close_extension(dev);
-
 	mutex_unlock(&dev->lock);
 
+	em28xx_close_extension(dev);
+
 	if (!dev->users) {
 		kfree(dev->alt_max_pkt_size);
 		kfree(dev);
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 804a4ab..afddfea 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -1218,16 +1218,22 @@ void em28xx_unregister_extension(struct em28xx_ops *ops)
 }
 EXPORT_SYMBOL(em28xx_unregister_extension);
 
-void em28xx_init_extension(struct em28xx *dev)
+/* Need to take the mutex lock before calling it */
+void __em28xx_init_extension(struct em28xx *dev)
 {
 	const struct em28xx_ops *ops = NULL;
 
-	mutex_lock(&em28xx_devlist_mutex);
 	list_add_tail(&dev->devlist, &em28xx_devlist);
 	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
 		if (ops->init)
 			ops->init(dev);
 	}
+}
+
+void em28xx_init_extension(struct em28xx *dev)
+{
+	mutex_lock(&em28xx_devlist_mutex);
+	__em28xx_init_extension(dev);
 	mutex_unlock(&em28xx_devlist_mutex);
 }
 
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 1626e4a..a5c1ba2 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -682,6 +682,7 @@ void em28xx_remove_from_devlist(struct em28xx *dev);
 void em28xx_add_into_devlist(struct em28xx *dev);
 int em28xx_register_extension(struct em28xx_ops *dev);
 void em28xx_unregister_extension(struct em28xx_ops *dev);
+void __em28xx_init_extension(struct em28xx *dev);
 void em28xx_init_extension(struct em28xx *dev);
 void em28xx_close_extension(struct em28xx *dev);
 
