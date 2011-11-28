Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:62630 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab1K1Tqg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 14:46:36 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 3/5] tm6000: bugfix interrupt reset
Date: Mon, 28 Nov 2011 20:46:18 +0100
Message-Id: <1322509580-14460-3-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/video/tm6000/tm6000-core.c  |   49 -----------------------------
 drivers/media/video/tm6000/tm6000-video.c |   21 ++++++++++--
 2 files changed, 17 insertions(+), 53 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-core.c b/drivers/media/video/tm6000/tm6000-core.c
index c007e6d..920299e 100644
--- a/drivers/media/video/tm6000/tm6000-core.c
+++ b/drivers/media/video/tm6000/tm6000-core.c
@@ -599,55 +599,6 @@ int tm6000_init(struct tm6000_core *dev)
 	return rc;
 }
 
-int tm6000_reset(struct tm6000_core *dev)
-{
-	int pipe;
-	int err;
-
-	msleep(500);
-
-	err = usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, 0);
-	if (err < 0) {
-		tm6000_err("failed to select interface %d, alt. setting 0\n",
-				dev->isoc_in.bInterfaceNumber);
-		return err;
-	}
-
-	err = usb_reset_configuration(dev->udev);
-	if (err < 0) {
-		tm6000_err("failed to reset configuration\n");
-		return err;
-	}
-
-	if ((dev->quirks & TM6000_QUIRK_NO_USB_DELAY) == 0)
-		msleep(5);
-
-	/*
-	 * Not all devices have int_in defined
-	 */
-	if (!dev->int_in.endp)
-		return 0;
-
-	err = usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, 2);
-	if (err < 0) {
-		tm6000_err("failed to select interface %d, alt. setting 2\n",
-				dev->isoc_in.bInterfaceNumber);
-		return err;
-	}
-
-	msleep(5);
-
-	pipe = usb_rcvintpipe(dev->udev,
-			dev->int_in.endp->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
-
-	err = usb_clear_halt(dev->udev, pipe);
-	if (err < 0) {
-		tm6000_err("usb_clear_halt failed: %d\n", err);
-		return err;
-	}
-
-	return 0;
-}
 
 int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
 {
diff --git a/drivers/media/video/tm6000/tm6000-video.c b/drivers/media/video/tm6000/tm6000-video.c
index 1e5ace0..4db3535 100644
--- a/drivers/media/video/tm6000/tm6000-video.c
+++ b/drivers/media/video/tm6000/tm6000-video.c
@@ -1609,12 +1609,25 @@ static int tm6000_release(struct file *file)
 
 		tm6000_uninit_isoc(dev);
 
+		/* Stop interrupt USB pipe */
+		tm6000_ir_int_stop(dev);
+
+		usb_reset_configuration(dev->udev);
+
+		if (&dev->int_in)
+			usb_set_interface(dev->udev,
+			dev->isoc_in.bInterfaceNumber,
+			2);
+		else
+			usb_set_interface(dev->udev,
+			dev->isoc_in.bInterfaceNumber,
+			0);
+
+		/* Start interrupt USB pipe */
+		tm6000_ir_int_start(dev);
+
 		if (!fh->radio)
 			videobuf_mmap_free(&fh->vb_vidq);
-
-		err = tm6000_reset(dev);
-		if (err < 0)
-			dev_err(&vdev->dev, "reset failed: %d\n", err);
 	}
 
 	kfree(fh);
-- 
1.7.7

