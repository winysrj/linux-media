Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65470 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2KHTMb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:31 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1754511eek.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:31 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 09/21] em28xx: create a common function for isoc and bulk URB allocation and setup
Date: Thu,  8 Nov 2012 20:11:41 +0200
Message-Id: <1352398313-3698-10-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename the existing function for isoc transfers em28xx_init_isoc
to em28xx_init_usb_xfer and extend it.
URB allocation and setup is now done depending on the USB
transfer type, which is selected with a new function parameter.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    6 +-
 drivers/media/usb/em28xx/em28xx-core.c  |  101 +++++++++++++++++--------------
 drivers/media/usb/em28xx/em28xx.h       |    4 +-
 3 Dateien geändert, 61 Zeilen hinzugefügt(+), 50 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index e474ccf..bfce34d 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3322,10 +3322,10 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 	if (has_dvb) {
 		/* pre-allocate DVB isoc transfer buffers */
-		retval = em28xx_alloc_isoc(dev, EM28XX_DIGITAL_MODE,
-					   EM28XX_DVB_NUM_ISOC_PACKETS,
+		retval = em28xx_alloc_urbs(dev, EM28XX_DIGITAL_MODE, 0,
 					   EM28XX_DVB_NUM_BUFS,
-					   dev->dvb_max_pkt_size);
+					   dev->dvb_max_pkt_size,
+					   EM28XX_DVB_NUM_ISOC_PACKETS);
 		if (retval) {
 			goto unlock_and_free;
 		}
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index a1ebd08..42388de 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -5,6 +5,7 @@
 		      Markus Rechberger <mrechberger@gmail.com>
 		      Mauro Carvalho Chehab <mchehab@infradead.org>
 		      Sascha Sommer <saschasommer@freenet.de>
+   Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
 
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -1035,10 +1036,10 @@ EXPORT_SYMBOL_GPL(em28xx_stop_urbs);
 /*
  * Allocate URBs
  */
-int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
-		      int num_packets, int num_bufs, int max_pkt_size)
+int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
+		      int num_bufs, int max_pkt_size, int packet_multiplier)
 {
-	struct em28xx_usb_bufs *isoc_bufs;
+	struct em28xx_usb_bufs *usb_bufs;
 	int i;
 	int sb_size, pipe;
 	struct urb *urb;
@@ -1047,49 +1048,52 @@ int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
 	em28xx_isocdbg("em28xx: called em28xx_alloc_isoc in mode %d\n", mode);
 
 	if (mode == EM28XX_DIGITAL_MODE)
-		isoc_bufs = &dev->usb_ctl.digital_bufs;
+		usb_bufs = &dev->usb_ctl.digital_bufs;
 	else
-		isoc_bufs = &dev->usb_ctl.analog_bufs;
+		usb_bufs = &dev->usb_ctl.analog_bufs;
 
 	/* De-allocates all pending stuff */
 	em28xx_uninit_usb_xfer(dev, mode);
 
-	isoc_bufs->num_bufs = num_bufs;
+	usb_bufs->num_bufs = num_bufs;
 
-	isoc_bufs->urb = kzalloc(sizeof(void *)*num_bufs,  GFP_KERNEL);
-	if (!isoc_bufs->urb) {
+	usb_bufs->urb = kzalloc(sizeof(void *)*num_bufs,  GFP_KERNEL);
+	if (!usb_bufs->urb) {
 		em28xx_errdev("cannot alloc memory for usb buffers\n");
 		return -ENOMEM;
 	}
 
-	isoc_bufs->transfer_buffer = kzalloc(sizeof(void *)*num_bufs,
+	usb_bufs->transfer_buffer = kzalloc(sizeof(void *)*num_bufs,
 					     GFP_KERNEL);
-	if (!isoc_bufs->transfer_buffer) {
+	if (!usb_bufs->transfer_buffer) {
 		em28xx_errdev("cannot allocate memory for usb transfer\n");
-		kfree(isoc_bufs->urb);
+		kfree(usb_bufs->urb);
 		return -ENOMEM;
 	}
 
-	isoc_bufs->max_pkt_size = max_pkt_size;
-	isoc_bufs->num_packets = num_packets;
+	usb_bufs->max_pkt_size = max_pkt_size;
+	if (xfer_bulk)
+		usb_bufs->num_packets = 0;
+	else
+		usb_bufs->num_packets = packet_multiplier;
 	dev->usb_ctl.vid_buf = NULL;
 	dev->usb_ctl.vbi_buf = NULL;
 
-	sb_size = isoc_bufs->num_packets * isoc_bufs->max_pkt_size;
+	sb_size = packet_multiplier * usb_bufs->max_pkt_size;
 
 	/* allocate urbs and transfer buffers */
-	for (i = 0; i < isoc_bufs->num_bufs; i++) {
-		urb = usb_alloc_urb(isoc_bufs->num_packets, GFP_KERNEL);
+	for (i = 0; i < usb_bufs->num_bufs; i++) {
+		urb = usb_alloc_urb(usb_bufs->num_packets, GFP_KERNEL);
 		if (!urb) {
 			em28xx_err("cannot alloc usb_ctl.urb %i\n", i);
 			em28xx_uninit_usb_xfer(dev, mode);
 			return -ENOMEM;
 		}
-		isoc_bufs->urb[i] = urb;
+		usb_bufs->urb[i] = urb;
 
-		isoc_bufs->transfer_buffer[i] = usb_alloc_coherent(dev->udev,
+		usb_bufs->transfer_buffer[i] = usb_alloc_coherent(dev->udev,
 			sb_size, GFP_KERNEL, &urb->transfer_dma);
-		if (!isoc_bufs->transfer_buffer[i]) {
+		if (!usb_bufs->transfer_buffer[i]) {
 			em28xx_err("unable to allocate %i bytes for transfer"
 					" buffer %i%s\n",
 					sb_size, i,
@@ -1097,35 +1101,42 @@ int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
 			em28xx_uninit_usb_xfer(dev, mode);
 			return -ENOMEM;
 		}
-		memset(isoc_bufs->transfer_buffer[i], 0, sb_size);
-
-		/* FIXME: this is a hack - should be
-			'desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK'
-			should also be using 'desc.bInterval'
-		 */
-		pipe = usb_rcvisocpipe(dev->udev,
-				       mode == EM28XX_ANALOG_MODE ?
-				       EM28XX_EP_ANALOG : EM28XX_EP_DIGITAL);
-
-		usb_fill_int_urb(urb, dev->udev, pipe,
-				 isoc_bufs->transfer_buffer[i], sb_size,
-				 em28xx_irq_callback, dev, 1);
-
-		urb->number_of_packets = isoc_bufs->num_packets;
-		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
-
-		k = 0;
-		for (j = 0; j < isoc_bufs->num_packets; j++) {
-			urb->iso_frame_desc[j].offset = k;
-			urb->iso_frame_desc[j].length =
-						isoc_bufs->max_pkt_size;
-			k += isoc_bufs->max_pkt_size;
+		memset(usb_bufs->transfer_buffer[i], 0, sb_size);
+
+		if (xfer_bulk) { /* bulk */
+			pipe = usb_rcvbulkpipe(dev->udev,
+					       mode == EM28XX_ANALOG_MODE ?
+					       EM28XX_EP_ANALOG :
+					       EM28XX_EP_DIGITAL);
+			usb_fill_bulk_urb(urb, dev->udev, pipe,
+					  usb_bufs->transfer_buffer[i], sb_size,
+					  em28xx_irq_callback, dev);
+			urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
+		} else { /* isoc */
+			pipe = usb_rcvisocpipe(dev->udev,
+					       mode == EM28XX_ANALOG_MODE ?
+					       EM28XX_EP_ANALOG :
+					       EM28XX_EP_DIGITAL);
+			usb_fill_int_urb(urb, dev->udev, pipe,
+					 usb_bufs->transfer_buffer[i], sb_size,
+					 em28xx_irq_callback, dev, 1);
+			urb->transfer_flags = URB_ISO_ASAP |
+					      URB_NO_TRANSFER_DMA_MAP;
+			k = 0;
+			for (j = 0; j < usb_bufs->num_packets; j++) {
+				urb->iso_frame_desc[j].offset = k;
+				urb->iso_frame_desc[j].length =
+							usb_bufs->max_pkt_size;
+				k += usb_bufs->max_pkt_size;
+			}
 		}
+
+		urb->number_of_packets = usb_bufs->num_packets;
 	}
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(em28xx_alloc_isoc);
+EXPORT_SYMBOL_GPL(em28xx_alloc_urbs);
 
 /*
  * Allocate URBs and start IRQ
@@ -1155,8 +1166,8 @@ int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
 	}
 
 	if (alloc) {
-		rc = em28xx_alloc_isoc(dev, mode, num_packets,
-				       num_bufs, max_pkt_size);
+		rc = em28xx_alloc_urbs(dev, mode, 0, num_bufs,
+				       max_pkt_size, num_packets);
 		if (rc)
 			return rc;
 	}
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 8fb3504..7bc2ddd 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -662,8 +662,8 @@ int em28xx_vbi_supported(struct em28xx *dev);
 int em28xx_set_outfmt(struct em28xx *dev);
 int em28xx_resolution_set(struct em28xx *dev);
 int em28xx_set_alternate(struct em28xx *dev);
-int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
-		      int num_packets, int num_bufs, int max_pkt_size);
+int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
+		      int num_bufs, int max_pkt_size, int packet_multiplier);
 int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
 		     int num_packets, int num_bufs, int max_pkt_size,
 		     int (*isoc_copy) (struct em28xx *dev, struct urb *urb));
-- 
1.7.10.4

