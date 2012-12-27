Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:40297 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2L0XCi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 18:02:38 -0500
Received: by mail-ee0-f50.google.com with SMTP id b45so5033080eek.37
        for <linux-media@vger.kernel.org>; Thu, 27 Dec 2012 15:02:37 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/6] em28xx: refactor the code in em28xx_usb_disconnect()
Date: Fri, 28 Dec 2012 00:02:44 +0100
Message-Id: <1356649368-5426-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The main purpose of this patch is to move the call of em28xx_release_resources()
after the call of em28xx_close_extension().
This is necessary, because some resources might be needed/used by the extensions
fini() functions when they get closed.
Also mark the device as disconnected earlier in this function and unify the
em28xx_uninit_usb_xfer() calls for analog and digital mode.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   26 +++++++++++---------------
 1 Datei geändert, 11 Zeilen hinzugefügt(+), 15 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 8496a06..40c3e45 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3478,6 +3478,8 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 	if (!dev)
 		return;
 
+	dev->disconnected = 1;
+
 	if (dev->is_audio_only) {
 		mutex_lock(&dev->lock);
 		em28xx_close_extension(dev);
@@ -3489,32 +3491,26 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 
 	flush_request_modules(dev);
 
-	/* wait until all current v4l2 io is finished then deallocate
-	   resources */
 	mutex_lock(&dev->lock);
 
 	v4l2_device_disconnect(&dev->v4l2_dev);
 
 	if (dev->users) {
-		em28xx_warn
-		    ("device %s is open! Deregistration and memory "
-		     "deallocation are deferred on close.\n",
-		     video_device_node_name(dev->vdev));
+		em28xx_warn("device %s is open! Deregistration and memory deallocation are deferred on close.\n",
+			    video_device_node_name(dev->vdev));
 
-		em28xx_uninit_usb_xfer(dev, dev->mode);
-		dev->disconnected = 1;
-	} else {
-		dev->disconnected = 1;
-		em28xx_release_resources(dev);
+		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
+		em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
 	}
 
-	/* free DVB isoc buffers */
-	em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
+	em28xx_close_extension(dev);
+	/* NOTE: must be called BEFORE the resources are released */
+
+	if (!dev->users)
+		em28xx_release_resources(dev);
 
 	mutex_unlock(&dev->lock);
 
-	em28xx_close_extension(dev);
-
 	if (!dev->users) {
 		kfree(dev->alt_max_pkt_size_isoc);
 		kfree(dev);
-- 
1.7.10.4

