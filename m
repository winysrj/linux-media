Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39761 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751587AbeB0RmN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 12:42:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC] media: em28xx: don't use coherent buffer for DMA transfers
Date: Tue, 27 Feb 2018 14:42:09 -0300
Message-Id: <df78951777f4edb8f627b043a12c710f0ba2497d.1519753238.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While coherent memory is cheap on x86, it has problems on
arm. So, stop using it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

I wrote this patch in order to check if this would make things better
for ISOCH transfers on Raspberry Pi3. It didn't. Yet, keep using
coherent memory at USB drivers seem an overkill.

So, I'm actually not sure if we should either go ahead and merge it
or not.

Comments? Tests?

 drivers/media/usb/em28xx/em28xx-core.c | 49 +++++++++++++++-------------------
 drivers/media/usb/em28xx/em28xx.h      |  2 +-
 2 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 1d0d8cc06103..6fadcb03093f 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -800,7 +800,6 @@ void em28xx_uninit_usb_xfer(struct em28xx *dev, enum em28xx_mode mode)
 {
 	struct urb *urb;
 	struct em28xx_usb_bufs *usb_bufs;
-	struct usb_device *udev = interface_to_usbdev(dev->intf);
 	int i;
 
 	em28xx_isocdbg("em28xx: called em28xx_uninit_usb_xfer in mode %d\n",
@@ -819,23 +818,16 @@ void em28xx_uninit_usb_xfer(struct em28xx *dev, enum em28xx_mode mode)
 			else
 				usb_unlink_urb(urb);
 
-			if (usb_bufs->transfer_buffer[i]) {
-				usb_free_coherent(udev,
-						  urb->transfer_buffer_length,
-						  usb_bufs->transfer_buffer[i],
-						  urb->transfer_dma);
-			}
 			usb_free_urb(urb);
 			usb_bufs->urb[i] = NULL;
 		}
-		usb_bufs->transfer_buffer[i] = NULL;
 	}
 
 	kfree(usb_bufs->urb);
-	kfree(usb_bufs->transfer_buffer);
+	kfree(usb_bufs->buf);
 
 	usb_bufs->urb = NULL;
-	usb_bufs->transfer_buffer = NULL;
+	usb_bufs->buf = NULL;
 	usb_bufs->num_bufs = 0;
 
 	em28xx_capture_start(dev, 0);
@@ -912,14 +904,13 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 
 	usb_bufs->num_bufs = num_bufs;
 
-	usb_bufs->urb = kzalloc(sizeof(void *)*num_bufs,  GFP_KERNEL);
+	usb_bufs->urb = kcalloc(sizeof(void *), num_bufs,  GFP_KERNEL);
 	if (!usb_bufs->urb)
 		return -ENOMEM;
 
-	usb_bufs->transfer_buffer = kzalloc(sizeof(void *)*num_bufs,
-					     GFP_KERNEL);
-	if (!usb_bufs->transfer_buffer) {
-		kfree(usb_bufs->urb);
+	usb_bufs->buf = kcalloc(sizeof(void *), num_bufs, GFP_KERNEL);
+	if (!usb_bufs->buf) {
+		kfree(usb_bufs->buf);
 		return -ENOMEM;
 	}
 
@@ -942,37 +933,39 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 		}
 		usb_bufs->urb[i] = urb;
 
-		usb_bufs->transfer_buffer[i] = usb_alloc_coherent(udev,
-			sb_size, GFP_KERNEL, &urb->transfer_dma);
-		if (!usb_bufs->transfer_buffer[i]) {
+		usb_bufs->buf[i] = kzalloc(sb_size, GFP_KERNEL);
+		if (!usb_bufs->buf[i]) {
 			dev_err(&dev->intf->dev,
 				"unable to allocate %i bytes for transfer buffer %i%s\n",
 			       sb_size, i,
 			       in_interrupt() ? " while in int" : "");
 			em28xx_uninit_usb_xfer(dev, mode);
+
+			while (i) {
+				kfree(usb_bufs->buf[i]);
+				i--;
+			}
+			kfree(usb_bufs->buf);
+
 			return -ENOMEM;
 		}
-		memset(usb_bufs->transfer_buffer[i], 0, sb_size);
 
 		if (xfer_bulk) { /* bulk */
 			pipe = usb_rcvbulkpipe(udev,
 					       mode == EM28XX_ANALOG_MODE ?
 					       dev->analog_ep_bulk :
 					       dev->dvb_ep_bulk);
-			usb_fill_bulk_urb(urb, udev, pipe,
-					  usb_bufs->transfer_buffer[i], sb_size,
-					  em28xx_irq_callback, dev);
-			urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
+			usb_fill_bulk_urb(urb, udev, pipe, usb_bufs->buf[i],
+					  sb_size, em28xx_irq_callback, dev);
+			urb->transfer_flags = URB_FREE_BUFFER;
 		} else { /* isoc */
 			pipe = usb_rcvisocpipe(udev,
 					       mode == EM28XX_ANALOG_MODE ?
 					       dev->analog_ep_isoc :
 					       dev->dvb_ep_isoc);
-			usb_fill_int_urb(urb, udev, pipe,
-					 usb_bufs->transfer_buffer[i], sb_size,
-					 em28xx_irq_callback, dev, 1);
-			urb->transfer_flags = URB_ISO_ASAP |
-					      URB_NO_TRANSFER_DMA_MAP;
+			usb_fill_int_urb(urb, udev, pipe, usb_bufs->buf[i],
+					 sb_size, em28xx_irq_callback, dev, 1);
+			urb->transfer_flags = URB_ISO_ASAP | URB_FREE_BUFFER;
 			k = 0;
 			for (j = 0; j < usb_bufs->num_packets; j++) {
 				urb->iso_frame_desc[j].offset = k;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 88084f24f033..bd6eaf642662 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -239,7 +239,7 @@ struct em28xx_usb_bufs {
 	struct urb			**urb;
 
 		/* transfer buffers for isoc/bulk transfer */
-	char				**transfer_buffer;
+	char				**buf;
 };
 
 struct em28xx_usb_ctl {
-- 
2.14.3
