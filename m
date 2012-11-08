Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65470 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab2KHTM5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:57 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1754511eek.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:56 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 20/21] em28xx: improve USB endpoint logic, also use bulk transfers
Date: Thu,  8 Nov 2012 20:11:52 +0200
Message-Id: <1352398313-3698-21-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current enpoint logic ignores all bulk endpoints and uses
a fixed mapping between endpint addresses and the supported
data stream types (analog/audio/DVB):
  Ep 0x82, isoc	=> analog
  Ep 0x83, isoc	=> audio
  Ep 0x84, isoc	=> DVB

Now that the code can also do bulk transfers, the endpoint
logic has to be extended to also consider bulk endpoints.
The new logic preserves backwards compatibility and reflects
the endpoint configurations we have seen so far:
  Ep 0x82, isoc		=> analog
  Ep 0x82, bulk		=> analog
  Ep 0x83, isoc*	=> audio
  Ep 0x84, isoc		=> digital
  Ep 0x84, bulk		=> analog or digital**
 (*: audio should always be isoc)
 (**: analog, if ep 0x82 is isoc, otherwise digital)

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   97 +++++++++++++++++++++++++------
 drivers/media/usb/em28xx/em28xx-core.c  |   32 ++++++++--
 drivers/media/usb/em28xx/em28xx-dvb.c   |   34 +++++++----
 drivers/media/usb/em28xx/em28xx-reg.h   |    4 +-
 drivers/media/usb/em28xx/em28xx-video.c |   10 ++--
 drivers/media/usb/em28xx/em28xx.h       |   12 ++++
 6 Dateien geändert, 149 Zeilen hinzugefügt(+), 40 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 873b52f..a9344f0 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -6,6 +6,7 @@
 		      Markus Rechberger <mrechberger@gmail.com>
 		      Mauro Carvalho Chehab <mchehab@infradead.org>
 		      Sascha Sommer <saschasommer@freenet.de>
+   Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
 
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -3209,26 +3210,69 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 			if (udev->speed == USB_SPEED_HIGH)
 				size = size * hb_mult(sizedescr);
 
-			if (usb_endpoint_xfer_isoc(e) &&
-			    usb_endpoint_dir_in(e)) {
+			if (usb_endpoint_dir_in(e)) {
 				switch (e->bEndpointAddress) {
-				case EM28XX_EP_AUDIO:
-					has_audio = true;
-					break;
-				case EM28XX_EP_ANALOG:
+				case 0x82:
 					has_video = true;
-					dev->alt_max_pkt_size_isoc[i] = size;
+					if (usb_endpoint_xfer_isoc(e)) {
+						dev->analog_ep_isoc =
+							    e->bEndpointAddress;
+						dev->alt_max_pkt_size_isoc[i] = size;
+					} else if (usb_endpoint_xfer_bulk(e)) {
+						dev->analog_ep_bulk =
+							    e->bEndpointAddress;
+					}
+					break;
+				case 0x83:
+					if (usb_endpoint_xfer_isoc(e)) {
+						has_audio = true;
+					} else {
+						printk(KERN_INFO DRIVER_NAME
+						": error: skipping audio end"
+						"point 0x83, because it uses"
+						" bulk transfers !\n");
+					}
 					break;
-				case EM28XX_EP_DIGITAL:
-					has_dvb = true;
-					if (size > dev->dvb_max_pkt_size_isoc) {
-						dev->dvb_max_pkt_size_isoc =
-									  size;
-						dev->dvb_alt_isoc = i;
+				case 0x84:
+					if (has_video &&
+					    (usb_endpoint_xfer_bulk(e))) {
+						dev->analog_ep_bulk =
+							    e->bEndpointAddress;
+					} else {
+						has_dvb = true;
+						if (usb_endpoint_xfer_isoc(e)) {
+							dev->dvb_ep_isoc = e->bEndpointAddress;
+							if (size > dev->dvb_max_pkt_size_isoc) {
+								dev->dvb_max_pkt_size_isoc = size;
+								dev->dvb_alt_isoc = i;
+							}
+						} else {
+							dev->dvb_ep_bulk = e->bEndpointAddress;
+						}
 					}
 					break;
 				}
 			}
+			/* NOTE:
+			 * Old logic with support for isoc transfers only was:
+			 *  0x82	isoc		=> analog
+			 *  0x83	isoc		=> audio
+			 *  0x84	isoc		=> digital
+			 *
+			 * New logic with support for bulk transfers
+			 *  0x82	isoc		=> analog
+			 *  0x82	bulk		=> analog
+			 *  0x83	isoc*		=> audio
+			 *  0x84	isoc		=> digital
+			 *  0x84	bulk		=> analog or digital**
+			 * (*: audio should always be isoc)
+			 * (**: analog, if ep 0x82 is isoc, otherwise digital)
+			 *
+			 * The new logic preserves backwards compatibility and
+			 * reflects the endpoint configurations we have seen
+			 * so far. But there might be devices for which this
+			 * logic is not sufficient...
+			 */
 		}
 	}
 
@@ -3289,6 +3333,12 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		goto err_free;
 	}
 
+	/* Select USB transfer types to use */
+	if (has_video && !dev->analog_ep_isoc)
+		dev->analog_xfer_bulk = 1;
+	if (has_dvb && !dev->dvb_ep_isoc)
+		dev->dvb_xfer_bulk = 1;
+
 	snprintf(dev->name, sizeof(dev->name), "em28xx #%d", nr);
 	dev->devno = nr;
 	dev->model = id->driver_info;
@@ -3323,12 +3373,23 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	}
 
 	if (has_dvb) {
-		/* pre-allocate DVB isoc transfer buffers */
-		retval = em28xx_alloc_urbs(dev, EM28XX_DIGITAL_MODE, 0,
-					   EM28XX_DVB_NUM_BUFS,
-					   dev->dvb_max_pkt_size_isoc,
-					   EM28XX_DVB_NUM_ISOC_PACKETS);
+		/* pre-allocate DVB usb transfer buffers */
+		if (dev->dvb_xfer_bulk) {
+			retval = em28xx_alloc_urbs(dev, EM28XX_DIGITAL_MODE,
+					    dev->dvb_xfer_bulk,
+					    EM28XX_DVB_NUM_BUFS,
+					    512,
+					    EM28XX_DVB_BULK_PACKET_MULTIPLIER);
+		} else {
+			retval = em28xx_alloc_urbs(dev, EM28XX_DIGITAL_MODE,
+					    dev->dvb_xfer_bulk,
+					    EM28XX_DVB_NUM_BUFS,
+					    dev->dvb_max_pkt_size_isoc,
+					    EM28XX_DVB_NUM_ISOC_PACKETS);
+		}
 		if (retval) {
+			printk(DRIVER_NAME ": Failed to pre-allocate USB"
+			       " transfer buffers for DVB.\n");
 			goto unlock_and_free;
 		}
 	}
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 06d5734..c78d38b 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -847,11 +847,13 @@ set_alt:
 	if (dev->alt != prev_alt) {
 		if (dev->analog_xfer_bulk) {
 			dev->max_pkt_size = 512; /* USB 2.0 spec */
+			dev->packet_multiplier = EM28XX_BULK_PACKET_MULTIPLIER;
 		} else { /* isoc */
 			em28xx_coredbg("minimum isoc packet size: "
 				       "%u (alt=%d)\n", min_pkt_size, dev->alt);
 			dev->max_pkt_size =
 					  dev->alt_max_pkt_size_isoc[dev->alt];
+			dev->packet_multiplier = EM28XX_NUM_ISOC_PACKETS;
 		}
 		em28xx_coredbg("setting alternate %d with wMaxPacketSize=%u\n",
 			       dev->alt, dev->max_pkt_size);
@@ -1054,10 +1056,28 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 
 	em28xx_isocdbg("em28xx: called em28xx_alloc_isoc in mode %d\n", mode);
 
-	if (mode == EM28XX_DIGITAL_MODE)
+	/* Check mode and if we have an endpoint for the selected
+	   transfer type, select buffer				 */
+	if (mode == EM28XX_DIGITAL_MODE) {
+		if ((xfer_bulk && !dev->dvb_ep_bulk) ||
+		    (!xfer_bulk && !dev->dvb_ep_isoc)) {
+			em28xx_errdev("no endpoint for DVB mode and "
+				      "transfer type %d\n", xfer_bulk > 0);
+			return -EINVAL;
+		}
 		usb_bufs = &dev->usb_ctl.digital_bufs;
-	else
+	} else if (mode == EM28XX_ANALOG_MODE) {
+		if ((xfer_bulk && !dev->analog_ep_bulk) ||
+		    (!xfer_bulk && !dev->analog_ep_isoc)) {
+			em28xx_errdev("no endpoint for analog mode and "
+				      "transfer type %d\n", xfer_bulk > 0);
+			return -EINVAL;
+		}
 		usb_bufs = &dev->usb_ctl.analog_bufs;
+	} else {
+		em28xx_errdev("invalid mode selected\n");
+		return -EINVAL;
+	}
 
 	/* De-allocates all pending stuff */
 	em28xx_uninit_usb_xfer(dev, mode);
@@ -1113,8 +1133,8 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 		if (xfer_bulk) { /* bulk */
 			pipe = usb_rcvbulkpipe(dev->udev,
 					       mode == EM28XX_ANALOG_MODE ?
-					       EM28XX_EP_ANALOG :
-					       EM28XX_EP_DIGITAL);
+					       dev->analog_ep_bulk :
+					       dev->dvb_ep_bulk);
 			usb_fill_bulk_urb(urb, dev->udev, pipe,
 					  usb_bufs->transfer_buffer[i], sb_size,
 					  em28xx_irq_callback, dev);
@@ -1122,8 +1142,8 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 		} else { /* isoc */
 			pipe = usb_rcvisocpipe(dev->udev,
 					       mode == EM28XX_ANALOG_MODE ?
-					       EM28XX_EP_ANALOG :
-					       EM28XX_EP_DIGITAL);
+					       dev->analog_ep_isoc :
+					       dev->dvb_ep_isoc);
 			usb_fill_int_urb(urb, dev->udev, pipe,
 					 usb_bufs->transfer_buffer[i], sb_size,
 					 em28xx_irq_callback, dev, 1);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 3fc7e27..8d44e40 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -176,25 +176,39 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 {
 	int rc;
 	struct em28xx *dev = dvb->adapter.priv;
-	int max_dvb_packet_size;
+	int dvb_max_packet_size, packet_multiplier, dvb_alt;
+
+	if (dev->dvb_xfer_bulk) {
+		if (!dev->dvb_ep_bulk)
+			return -ENODEV;
+		dvb_max_packet_size = 512; /* USB 2.0 spec */
+		packet_multiplier = EM28XX_DVB_BULK_PACKET_MULTIPLIER;
+		dvb_alt = 0;
+	} else { /* isoc */
+		if (!dev->dvb_ep_isoc)
+			return -ENODEV;
+		dvb_max_packet_size = dev->dvb_max_pkt_size_isoc;
+		if (dvb_max_packet_size < 0)
+			return dvb_max_packet_size;
+		packet_multiplier = EM28XX_DVB_NUM_ISOC_PACKETS;
+		dvb_alt = dev->dvb_alt_isoc;
+	}
 
-	usb_set_interface(dev->udev, 0, dev->dvb_alt_isoc);
+	usb_set_interface(dev->udev, 0, dvb_alt);
 	rc = em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
 	if (rc < 0)
 		return rc;
 
-	max_dvb_packet_size = dev->dvb_max_pkt_size_isoc;
-	if (max_dvb_packet_size < 0)
-		return max_dvb_packet_size;
 	dprintk(1, "Using %d buffers each with %d x %d bytes\n",
 		EM28XX_DVB_NUM_BUFS,
-		EM28XX_DVB_NUM_ISOC_PACKETS,
-		max_dvb_packet_size);
+		packet_multiplier,
+		dvb_max_packet_size);
 
-	return em28xx_init_usb_xfer(dev, EM28XX_DIGITAL_MODE, 0,
+	return em28xx_init_usb_xfer(dev, EM28XX_DIGITAL_MODE,
+				    dev->dvb_xfer_bulk,
 				    EM28XX_DVB_NUM_BUFS,
-				    max_dvb_packet_size,
-				    EM28XX_DVB_NUM_ISOC_PACKETS,
+				    dvb_max_packet_size,
+				    packet_multiplier,
 				    em28xx_dvb_urb_data_copy);
 }
 
diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 6ff3682..8cd3acf 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -13,9 +13,9 @@
 #define EM_GPO_3   (1 << 3)
 
 /* em28xx endpoints */
-#define EM28XX_EP_ANALOG	0x82
+/* 0x82:   (always ?) analog */
 #define EM28XX_EP_AUDIO		0x83
-#define EM28XX_EP_DIGITAL	0x84
+/* 0x84:   digital or analog */
 
 /* em2800 registers */
 #define EM2800_R08_AUDIOSRC 0x08
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 8767c06..4ec54fd 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -788,16 +788,18 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 
 	if (urb_init) {
 		if (em28xx_vbi_supported(dev) == 1)
-			rc = em28xx_init_usb_xfer(dev, EM28XX_ANALOG_MODE, 0,
+			rc = em28xx_init_usb_xfer(dev, EM28XX_ANALOG_MODE,
+						  dev->analog_xfer_bulk,
 						  EM28XX_NUM_BUFS,
 						  dev->max_pkt_size,
-						  EM28XX_NUM_ISOC_PACKETS,
+						  dev->packet_multiplier,
 						  em28xx_urb_data_copy_vbi);
 		else
-			rc = em28xx_init_usb_xfer(dev, EM28XX_ANALOG_MODE, 0,
+			rc = em28xx_init_usb_xfer(dev, EM28XX_ANALOG_MODE,
+						  dev->analog_xfer_bulk,
 						  EM28XX_NUM_BUFS,
 						  dev->max_pkt_size,
-						  EM28XX_NUM_ISOC_PACKETS,
+						  dev->packet_multiplier,
 						  em28xx_urb_data_copy);
 		if (rc < 0)
 			goto fail;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index f5be522..aa413bd 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -165,6 +165,12 @@
 #define EM28XX_NUM_ISOC_PACKETS 64
 #define EM28XX_DVB_NUM_ISOC_PACKETS 64
 
+/* bulk transfers: transfer buffer size = packet size * packet multiplier
+   USB 2.0 spec says bulk packet size is always 512 bytes
+ */
+#define EM28XX_BULK_PACKET_MULTIPLIER 384
+#define EM28XX_DVB_BULK_PACKET_MULTIPLIER 384
+
 #define EM28XX_INTERLACED_DEFAULT 1
 
 /*
@@ -584,8 +590,14 @@ struct em28xx {
 
 	/* usb transfer */
 	struct usb_device *udev;	/* the usb device */
+	u8 analog_ep_isoc;	/* address of isoc endpoint for analog */
+	u8 analog_ep_bulk;	/* address of bulk endpoint for analog */
+	u8 dvb_ep_isoc;		/* address of isoc endpoint for DVB */
+	u8 dvb_ep_bulk;		/* address of bulk endpoint for DVC */
 	int alt;		/* alternate setting */
 	int max_pkt_size;	/* max packet size of the selected ep at alt */
+	int packet_multiplier;	/* multiplier for wMaxPacketSize, used for
+				   URB buffer size definition */
 	int num_alt;		/* number of alternative settings */
 	unsigned int *alt_max_pkt_size_isoc; /* array of isoc wMaxPacketSize */
 	unsigned int analog_xfer_bulk:1;	/* use bulk instead of isoc
-- 
1.7.10.4

