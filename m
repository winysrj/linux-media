Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hnelson.de ([83.169.43.49]:44143 "EHLO mail.hnelson.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab1L1Wzn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Dec 2011 17:55:43 -0500
Date: Wed, 28 Dec 2011 23:55:41 +0100 (CET)
From: Holger Nelson <hnelson@hnelson.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Dennis Sperlich <dsperlich@googlemail.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH] em28xx: Reworked probe code to get rid of some hacks (was:
 Re: em28xx_isoc_dvb_max_packetsize for EM2884 (Terratec Cinergy HTC
 Stick))
In-Reply-To: <4EFB06F9.5020808@redhat.com>
Message-ID: <alpine.DEB.2.02.1112281539050.18133@nova.crius.de>
References: <4EF64AF4.2040705@gmail.com> <4EF70077.5040907@redhat.com> <4EF72D61.9090001@gmail.com> <4EF767CB.10705@redhat.com> <4EF78896.1060908@gmail.com> <alpine.DEB.2.02.1112260627170.17197@nova.crius.de> <4EF86614.8050702@redhat.com>
 <alpine.DEB.2.02.1112280438220.18133@nova.crius.de> <4EFB06F9.5020808@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reworked device probing to get rid of hacks to guess the maximum size of 
dvb iso transfer packets. The new code also selects the first alternate 
config which supports the largest possible iso transfers for dvb. 

Signed-off-by: Holger Nelson <hnelson@hnelson.de>

diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index cff0768..e2a7b77 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -193,7 +193,7 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
 
 		urb->dev = dev->udev;
 		urb->context = dev;
-		urb->pipe = usb_rcvisocpipe(dev->udev, 0x83);
+		urb->pipe = usb_rcvisocpipe(dev->udev, EM28XX_EP_AUDIO);
 		urb->transfer_flags = URB_ISO_ASAP;
 		urb->transfer_buffer = dev->adev.transfer_buffer[i];
 		urb->interval = 1;
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index a7cfded..027f769 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -3087,12 +3087,11 @@ unregister_dev:
 static int em28xx_usb_probe(struct usb_interface *interface,
 			    const struct usb_device_id *id)
 {
-	const struct usb_endpoint_descriptor *endpoint;
 	struct usb_device *udev;
 	struct em28xx *dev = NULL;
 	int retval;
-	bool is_audio_only = false, has_audio = false;
-	int i, nr, isoc_pipe;
+	bool has_audio = false, has_video = false, has_dvb = false;
+	int i, nr;
 	const int ifnum = interface->altsetting[0].desc.bInterfaceNumber;
 	char *speed;
 	char descr[255] = "";
@@ -3124,54 +3123,63 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		goto err;
 	}
 
+	/* allocate memory for our device state and initialize it */
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL) {
+		em28xx_err(DRIVER_NAME ": out of memory!\n");
+		retval = -ENOMEM;
+		goto err;
+	}
+
+	/* compute alternate max packet sizes */
+	dev->alt_max_pkt_size = kmalloc(sizeof(dev->alt_max_pkt_size[0]) * interface->num_altsetting, GFP_KERNEL);
+	if (dev->alt_max_pkt_size == NULL) {
+		em28xx_errdev("out of memory!\n");
+		kfree(dev);
+		retval = -ENOMEM;
+		goto err;
+	}
+
 	/* Get endpoints */
 	for (i = 0; i < interface->num_altsetting; i++) {
 		int ep;
 
 		for (ep = 0; ep < interface->altsetting[i].desc.bNumEndpoints; ep++) {
-			struct usb_host_endpoint	*e;
-			e = &interface->altsetting[i].endpoint[ep];
-
-			if (e->desc.bEndpointAddress == 0x83)
-				has_audio = true;
+			const struct usb_endpoint_descriptor *e;
+			int sizedescr, size;
+
+			e = &interface->altsetting[i].endpoint[ep].desc;
+
+			sizedescr = le16_to_cpu(e->wMaxPacketSize);
+			size = sizedescr & 0x7ff;
+
+			if (udev->speed == USB_SPEED_HIGH)
+				size = size * hb_mult(sizedescr);
+
+			if (usb_endpoint_xfer_isoc(e) && usb_endpoint_dir_in(e)) {
+				switch (e->bEndpointAddress) {
+				case EM28XX_EP_AUDIO:
+					has_audio = true;
+					break;
+				case EM28XX_EP_ANALOG:
+					has_video = true;
+					dev->alt_max_pkt_size[i] = size;
+					break;
+				case EM28XX_EP_DIGITAL:
+					has_dvb = true;
+					if (size > dev->dvb_max_pkt_size) {
+						dev->dvb_max_pkt_size = size;
+						dev->dvb_alt = i;
+					}
+					break;
+				}
+			}
 		}
 	}
 
-	endpoint = &interface->cur_altsetting->endpoint[0].desc;
-
-	/* check if the device has the iso in endpoint at the correct place */
-	if (usb_endpoint_xfer_isoc(endpoint)
-	    &&
-	    (interface->altsetting[1].endpoint[0].desc.wMaxPacketSize == 940)) {
-		/* It's a newer em2874/em2875 device */
-		isoc_pipe = 0;
-	} else {
-		int check_interface = 1;
-		isoc_pipe = 1;
-		endpoint = &interface->cur_altsetting->endpoint[1].desc;
-		if (!usb_endpoint_xfer_isoc(endpoint))
-			check_interface = 0;
-
-		if (usb_endpoint_dir_out(endpoint))
-			check_interface = 0;
-
-		if (!check_interface) {
-			if (has_audio) {
-				is_audio_only = true;
-			} else {
-				em28xx_err(DRIVER_NAME " video device (%04x:%04x): "
-					"interface %i, class %i found.\n",
-					le16_to_cpu(udev->descriptor.idVendor),
-					le16_to_cpu(udev->descriptor.idProduct),
-					ifnum,
-					interface->altsetting[0].desc.bInterfaceClass);
-				em28xx_err(DRIVER_NAME " This is an anciliary "
-					"interface not used by the driver\n");
-
-				retval = -ENODEV;
-				goto err;
-			}
-		}
+	if (!(has_audio || has_video || has_dvb)) {
+		retval=-ENODEV;
+		goto err_free;
 	}
 
 	switch (udev->speed) {
@@ -3197,6 +3205,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 			strlcat(descr, " ", sizeof(descr));
 		strlcat(descr, udev->product, sizeof(descr));
 	}
+
 	if (*descr)
 		strlcat(descr, " ", sizeof(descr));
 
@@ -3213,6 +3222,14 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		printk(KERN_INFO DRIVER_NAME
 		       ": Audio Vendor Class interface %i found\n",
 		       ifnum);
+	if (has_video)
+		printk(KERN_INFO DRIVER_NAME
+		       ": Video interface %i found\n",
+		       ifnum);
+	if (has_dvb)
+		printk(KERN_INFO DRIVER_NAME
+		       ": DVB interface %i found\n",
+		       ifnum);
 
 	/*
 	 * Make sure we have 480 Mbps of bandwidth, otherwise things like
@@ -3224,22 +3241,14 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		printk(DRIVER_NAME ": Device must be connected to a high-speed"
 		       " USB 2.0 port.\n");
 		retval = -ENODEV;
-		goto err;
-	}
-
-	/* allocate memory for our device state and initialize it */
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL) {
-		em28xx_err(DRIVER_NAME ": out of memory!\n");
-		retval = -ENOMEM;
-		goto err;
+		goto err_free;
 	}
 
 	snprintf(dev->name, sizeof(dev->name), "em28xx #%d", nr);
 	dev->devno = nr;
 	dev->model = id->driver_info;
 	dev->alt   = -1;
-	dev->is_audio_only = is_audio_only;
+	dev->is_audio_only = has_audio && !(has_video || has_dvb);
 	dev->has_alsa_audio = has_audio;
 	dev->audio_ifnum = ifnum;
 
@@ -3252,26 +3261,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		}
 	}
 
-	/* compute alternate max packet sizes */
 	dev->num_alt = interface->num_altsetting;
-	dev->alt_max_pkt_size = kmalloc(32 * dev->num_alt, GFP_KERNEL);
-
-	if (dev->alt_max_pkt_size == NULL) {
-		em28xx_errdev("out of memory!\n");
-		kfree(dev);
-		retval = -ENOMEM;
-		goto err;
-	}
-
-	for (i = 0; i < dev->num_alt ; i++) {
-		u16 tmp = le16_to_cpu(interface->altsetting[i].endpoint[isoc_pipe].desc.wMaxPacketSize);
-		unsigned int size = tmp & 0x7ff;
-
-		if (udev->speed == USB_SPEED_HIGH)
-			size = size * hb_mult(tmp);
-
-		dev->alt_max_pkt_size[i] = size;
-	}
 
 	if ((card[nr] >= 0) && (card[nr] < em28xx_bcount))
 		dev->model = card[nr];
@@ -3284,10 +3274,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	mutex_lock(&dev->lock);
 	retval = em28xx_init_dev(&dev, udev, interface, nr);
 	if (retval) {
-		mutex_unlock(&dev->lock);
-		kfree(dev->alt_max_pkt_size);
-		kfree(dev);
-		goto err;
+		goto unlock_and_free;
 	}
 
 	request_modules(dev);
@@ -3306,6 +3293,13 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 	return 0;
 
+unlock_and_free:
+	mutex_unlock(&dev->lock);
+
+err_free:
+	kfree(dev->alt_max_pkt_size);
+	kfree(dev);
+
 err:
 	clear_bit(nr, &em28xx_devused);
 
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 804a4ab..bc1d5dd 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -1070,7 +1070,7 @@ int em28xx_init_isoc(struct em28xx *dev, int max_packets,
 			should also be using 'desc.bInterval'
 		 */
 		pipe = usb_rcvisocpipe(dev->udev,
-			dev->mode == EM28XX_ANALOG_MODE ? 0x82 : 0x84);
+			dev->mode == EM28XX_ANALOG_MODE ? EM28XX_EP_ANALOG : EM28XX_EP_DIGITAL);
 
 		usb_fill_int_urb(urb, dev->udev, pipe,
 				 dev->isoc_ctl.transfer_buffer[i], sb_size,
@@ -1108,62 +1108,6 @@ int em28xx_init_isoc(struct em28xx *dev, int max_packets,
 }
 EXPORT_SYMBOL_GPL(em28xx_init_isoc);
 
-/* Determine the packet size for the DVB stream for the given device
-   (underlying value programmed into the eeprom) */
-int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev)
-{
-	unsigned int chip_cfg2;
-	unsigned int packet_size;
-
-	switch (dev->chip_id) {
-	case CHIP_ID_EM2710:
-	case CHIP_ID_EM2750:
-	case CHIP_ID_EM2800:
-	case CHIP_ID_EM2820:
-	case CHIP_ID_EM2840:
-	case CHIP_ID_EM2860:
-		/* No DVB support */
-		return -EINVAL;
-	case CHIP_ID_EM2870:
-	case CHIP_ID_EM2883:
-		/* TS max packet size stored in bits 1-0 of R01 */
-		chip_cfg2 = em28xx_read_reg(dev, EM28XX_R01_CHIPCFG2);
-		switch (chip_cfg2 & EM28XX_CHIPCFG2_TS_PACKETSIZE_MASK) {
-		case EM28XX_CHIPCFG2_TS_PACKETSIZE_188:
-			packet_size = 188;
-			break;
-		case EM28XX_CHIPCFG2_TS_PACKETSIZE_376:
-			packet_size = 376;
-			break;
-		case EM28XX_CHIPCFG2_TS_PACKETSIZE_564:
-			packet_size = 564;
-			break;
-		case EM28XX_CHIPCFG2_TS_PACKETSIZE_752:
-			packet_size = 752;
-			break;
-		}
-		break;
-	case CHIP_ID_EM2874:
-		/*
-		 * FIXME: for now assumes 564 like it was before, but the
-		 * em2874 code should be added to return the proper value
-		 */
-		packet_size = 564;
-		break;
-	case CHIP_ID_EM2884:
-	case CHIP_ID_EM28174:
-	default:
-		/*
-		 * FIXME: same as em2874. 564 was enough for 22 Mbit DVB-T
-		 * but not enough for 44 Mbit DVB-C.
-		 */
-		packet_size = 752;
-	}
-
-	return packet_size;
-}
-EXPORT_SYMBOL_GPL(em28xx_isoc_dvb_max_packetsize);
-
 /*
  * em28xx_wake_i2c()
  * configure i2c attached devices
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 3868c1e..52ff128 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -163,12 +163,12 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 	struct em28xx *dev = dvb->adapter.priv;
 	int max_dvb_packet_size;
 
-	usb_set_interface(dev->udev, 0, 1);
+	usb_set_interface(dev->udev, 0, dev->dvb_alt);
 	rc = em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
 	if (rc < 0)
 		return rc;
 
-	max_dvb_packet_size = em28xx_isoc_dvb_max_packetsize(dev);
+	max_dvb_packet_size = dev->dvb_max_pkt_size;
 	if (max_dvb_packet_size < 0)
 		return max_dvb_packet_size;
 	dprintk(1, "Using %d buffers each with %d bytes\n",
diff --git a/drivers/media/video/em28xx/em28xx-reg.h b/drivers/media/video/em28xx/em28xx-reg.h
index 66f7923..2f62685 100644
--- a/drivers/media/video/em28xx/em28xx-reg.h
+++ b/drivers/media/video/em28xx/em28xx-reg.h
@@ -12,6 +12,11 @@
 #define EM_GPO_2   (1 << 2)
 #define EM_GPO_3   (1 << 3)
 
+/* em28xx endpoints */
+#define EM28XX_EP_ANALOG	0x82
+#define EM28XX_EP_AUDIO		0x83
+#define EM28XX_EP_DIGITAL	0x84
+
 /* em2800 registers */
 #define EM2800_R08_AUDIOSRC 0x08
 
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index b1199ef..85394cb 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -597,6 +597,8 @@ struct em28xx {
 	int max_pkt_size;	/* max packet size of isoc transaction */
 	int num_alt;		/* Number of alternative settings */
 	unsigned int *alt_max_pkt_size;	/* array of wMaxPacketSize */
+	int dvb_alt;				/* alternate for DVB */
+	unsigned int dvb_max_pkt_size;		/* wMaxPacketSize for DVB */
 	struct urb *urb[EM28XX_NUM_BUFS];	/* urb for isoc transfers */
 	char *transfer_buffer[EM28XX_NUM_BUFS];	/* transfer buffers for isoc
 						   transfer */
