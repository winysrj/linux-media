Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:32938 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752561AbeCBTfC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 14:35:02 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/8] media: em28xx: don't use coherent buffer for DMA transfers
Date: Fri,  2 Mar 2018 16:34:42 -0300
Message-Id: <fd94439fa7f8a09f795e7794f020af8ac26d5a0a.1520018558.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520018558.git.mchehab@s-opensource.com>
References: <cover.1520018558.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520018558.git.mchehab@s-opensource.com>
References: <cover.1520018558.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While coherent memory is cheap on x86, it may cause performance
impacts on other archs. As we don't have any good reason to
use it, let's change the logic by allocating memory via kmalloc()
and letting the USB core to do the DMA mapping and memory free
for us.

While here, also fixes an issue that it was not de-allocating
memories if something gets wrong during memory block
allocation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-core.c | 51 +++++++++++++++-------------------
 drivers/media/usb/em28xx/em28xx.h      |  2 +-
 2 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 1d0d8cc06103..932ab93a05a6 100644
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
 
@@ -942,37 +933,41 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
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
+
 			em28xx_uninit_usb_xfer(dev, mode);
+
+			for (i--; i >= 0; i--)
+				kfree(usb_bufs->buf[i]);
+
+			kfree(usb_bufs->buf);
+			usb_bufs->buf = NULL;
+
 			return -ENOMEM;
 		}
-		memset(usb_bufs->transfer_buffer[i], 0, sb_size);
+
+		urb->transfer_flags = URB_FREE_BUFFER;
 
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
+			urb->transfer_flags |= URB_ISO_ASAP;
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
