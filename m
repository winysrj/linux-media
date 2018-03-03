Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52930 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752394AbeCCUvX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 15:51:23 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 07/11] media: em28xx-cards: rework the em28xx probing code
Date: Sat,  3 Mar 2018 17:51:08 -0300
Message-Id: <38f1b999dacf0e024e3dd2b161b00f45874766c3.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a complex loop there with identifies the em28xx
endpoints. It has lots of identations inside, and big names,
making harder to understand.

Simplify it by moving the main logic into a static function.

While here, rename "interface" var to "intf".

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 253 +++++++++++++++++---------------
 1 file changed, 134 insertions(+), 119 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 01675f577008..2ac59d8fb594 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3341,13 +3341,13 @@ EXPORT_SYMBOL_GPL(em28xx_free_device);
  * allocates and inits the device structs, registers i2c bus and v4l device
  */
 static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
-			   struct usb_interface *interface,
+			   struct usb_interface *intf,
 			   int minor)
 {
 	int retval;
 	const char *chip_name = NULL;
 
-	dev->intf = interface;
+	dev->intf = intf;
 	mutex_init(&dev->ctrl_urb_lock);
 	spin_lock_init(&dev->slock);
 
@@ -3492,11 +3492,102 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 /* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
 #define hb_mult(wMaxPacketSize) (1 + (((wMaxPacketSize) >> 11) & 0x03))
 
+static void em28xx_check_usb_descriptor(struct em28xx *dev,
+					struct usb_device *udev,
+					struct usb_interface *intf,
+					int alt, int ep,
+					bool *has_vendor_audio,
+					bool *has_video,
+					bool *has_dvb)
+{
+	const struct usb_endpoint_descriptor *e;
+	int sizedescr, size;
+
+	/*
+	 * NOTE:
+	 *
+	 * Old logic with support for isoc transfers only was:
+	 *  0x82	isoc		=> analog
+	 *  0x83	isoc		=> audio
+	 *  0x84	isoc		=> digital
+	 *
+	 * New logic with support for bulk transfers
+	 *  0x82	isoc		=> analog
+	 *  0x82	bulk		=> analog
+	 *  0x83	isoc*		=> audio
+	 *  0x84	isoc		=> digital
+	 *  0x84	bulk		=> analog or digital**
+	 * (*: audio should always be isoc)
+	 * (**: analog, if ep 0x82 is isoc, otherwise digital)
+	 *
+	 * The new logic preserves backwards compatibility and
+	 * reflects the endpoint configurations we have seen
+	 * so far. But there might be devices for which this
+	 * logic is not sufficient...
+	 */
+
+	e = &intf->altsetting[alt].endpoint[ep].desc;
+
+	if (!usb_endpoint_dir_in(e))
+		return;
+
+	sizedescr = le16_to_cpu(e->wMaxPacketSize);
+	size = sizedescr & 0x7ff;
+
+	if (udev->speed == USB_SPEED_HIGH)
+		size = size * hb_mult(sizedescr);
+
+	/* Only inspect input endpoints */
+
+	switch (e->bEndpointAddress) {
+	case 0x82:
+		*has_video = true;
+		if (usb_endpoint_xfer_isoc(e)) {
+			dev->analog_ep_isoc = e->bEndpointAddress;
+			dev->alt_max_pkt_size_isoc[alt] = size;
+		} else if (usb_endpoint_xfer_bulk(e)) {
+			dev->analog_ep_bulk = e->bEndpointAddress;
+		}
+		return;
+	case 0x83:
+		if (usb_endpoint_xfer_isoc(e))
+			*has_vendor_audio = true;
+		else
+			dev_err(&intf->dev,
+				"error: skipping audio endpoint 0x83, because it uses bulk transfers !\n");
+		return;
+	case 0x84:
+		if (*has_video && (usb_endpoint_xfer_bulk(e))) {
+			dev->analog_ep_bulk = e->bEndpointAddress;
+		} else {
+			if (usb_endpoint_xfer_isoc(e)) {
+				if (size > dev->dvb_max_pkt_size_isoc) {
+					/*
+					 * 2) some manufacturers (e.g. Terratec)
+					 * disable endpoints by setting
+					 * wMaxPacketSize to 0 bytes for all
+					 * alt settings. So far, we've seen
+					 * this for DVB isoc endpoints only.
+					 */
+					*has_dvb = true;
+					dev->dvb_ep_isoc = e->bEndpointAddress;
+					dev->dvb_max_pkt_size_isoc = size;
+					dev->dvb_alt_isoc = alt;
+				}
+			} else {
+				*has_dvb = true;
+				dev->dvb_ep_bulk = e->bEndpointAddress;
+			}
+		}
+		return;
+	}
+}
+
 /*
  * em28xx_usb_probe()
  * checks for supported devices
  */
-static int em28xx_usb_probe(struct usb_interface *interface,
+static int em28xx_usb_probe(struct usb_interface *intf,
 			    const struct usb_device_id *id)
 {
 	struct usb_device *udev;
@@ -3504,17 +3595,17 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	int retval;
 	bool has_vendor_audio = false, has_video = false, has_dvb = false;
 	int i, nr, try_bulk;
-	const int ifnum = interface->altsetting[0].desc.bInterfaceNumber;
+	const int ifnum = intf->altsetting[0].desc.bInterfaceNumber;
 	char *speed;
 
-	udev = usb_get_dev(interface_to_usbdev(interface));
+	udev = usb_get_dev(interface_to_usbdev(intf));
 
 	/* Check to see next free device and mark as used */
 	do {
 		nr = find_first_zero_bit(em28xx_devused, EM28XX_MAXBOARDS);
 		if (nr >= EM28XX_MAXBOARDS) {
 			/* No free device slots */
-			dev_err(&interface->dev,
+			dev_err(&intf->dev,
 				"Driver supports up to %i em28xx boards.\n",
 			       EM28XX_MAXBOARDS);
 			retval = -ENOMEM;
@@ -3523,13 +3614,13 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	} while (test_and_set_bit(nr, em28xx_devused));
 
 	/* Don't register audio interfaces */
-	if (interface->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
-		dev_err(&interface->dev,
+	if (intf->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
+		dev_err(&intf->dev,
 			"audio device (%04x:%04x): interface %i, class %i\n",
 			le16_to_cpu(udev->descriptor.idVendor),
 			le16_to_cpu(udev->descriptor.idProduct),
 			ifnum,
-			interface->altsetting[0].desc.bInterfaceClass);
+			intf->altsetting[0].desc.bInterfaceClass);
 
 		retval = -ENODEV;
 		goto err;
@@ -3543,9 +3634,9 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	}
 
 	/* compute alternate max packet sizes */
-	dev->alt_max_pkt_size_isoc =
-				kmalloc(sizeof(dev->alt_max_pkt_size_isoc[0]) *
-					interface->num_altsetting, GFP_KERNEL);
+	dev->alt_max_pkt_size_isoc = kcalloc(intf->num_altsetting,
+					     sizeof(dev->alt_max_pkt_size_isoc[0]),
+					     GFP_KERNEL);
 	if (!dev->alt_max_pkt_size_isoc) {
 		kfree(dev);
 		retval = -ENOMEM;
@@ -3553,93 +3644,17 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	}
 
 	/* Get endpoints */
-	for (i = 0; i < interface->num_altsetting; i++) {
+	for (i = 0; i < intf->num_altsetting; i++) {
 		int ep;
 
 		for (ep = 0;
-		     ep < interface->altsetting[i].desc.bNumEndpoints;
-		     ep++) {
-			const struct usb_endpoint_descriptor *e;
-			int sizedescr, size;
-
-			e = &interface->altsetting[i].endpoint[ep].desc;
-
-			sizedescr = le16_to_cpu(e->wMaxPacketSize);
-			size = sizedescr & 0x7ff;
-
-			if (udev->speed == USB_SPEED_HIGH)
-				size = size * hb_mult(sizedescr);
-
-			if (usb_endpoint_dir_in(e)) {
-				switch (e->bEndpointAddress) {
-				case 0x82:
-					has_video = true;
-					if (usb_endpoint_xfer_isoc(e)) {
-						dev->analog_ep_isoc =
-							    e->bEndpointAddress;
-						dev->alt_max_pkt_size_isoc[i] = size;
-					} else if (usb_endpoint_xfer_bulk(e)) {
-						dev->analog_ep_bulk =
-							    e->bEndpointAddress;
-					}
-					break;
-				case 0x83:
-					if (usb_endpoint_xfer_isoc(e)) {
-						has_vendor_audio = true;
-					} else {
-						dev_err(&interface->dev,
-							"error: skipping audio endpoint 0x83, because it uses bulk transfers !\n");
-					}
-					break;
-				case 0x84:
-					if (has_video &&
-					    (usb_endpoint_xfer_bulk(e))) {
-						dev->analog_ep_bulk =
-							    e->bEndpointAddress;
-					} else {
-						if (usb_endpoint_xfer_isoc(e)) {
-							if (size > dev->dvb_max_pkt_size_isoc) {
-								has_dvb = true; /* see NOTE (~) */
-								dev->dvb_ep_isoc = e->bEndpointAddress;
-								dev->dvb_max_pkt_size_isoc = size;
-								dev->dvb_alt_isoc = i;
-							}
-						} else {
-							has_dvb = true;
-							dev->dvb_ep_bulk = e->bEndpointAddress;
-						}
-					}
-					break;
-				}
-			}
-			/*
-			 * NOTE:
-			 * Old logic with support for isoc transfers only was:
-			 *  0x82	isoc		=> analog
-			 *  0x83	isoc		=> audio
-			 *  0x84	isoc		=> digital
-			 *
-			 * New logic with support for bulk transfers
-			 *  0x82	isoc		=> analog
-			 *  0x82	bulk		=> analog
-			 *  0x83	isoc*		=> audio
-			 *  0x84	isoc		=> digital
-			 *  0x84	bulk		=> analog or digital**
-			 * (*: audio should always be isoc)
-			 * (**: analog, if ep 0x82 is isoc, otherwise digital)
-			 *
-			 * The new logic preserves backwards compatibility and
-			 * reflects the endpoint configurations we have seen
-			 * so far. But there might be devices for which this
-			 * logic is not sufficient...
-			 */
-			/*
-			 * NOTE (~): some manufacturers (e.g. Terratec) disable
-			 * endpoints by setting wMaxPacketSize to 0 bytes for
-			 * all alt settings. So far, we've seen this for
-			 * DVB isoc endpoints only.
-			 */
-		}
+		     ep < intf->altsetting[i].desc.bNumEndpoints;
+		     ep++)
+			em28xx_check_usb_descriptor(dev, udev, intf,
+						    i, ep,
+						    &has_vendor_audio,
+						    &has_video,
+						    &has_dvb);
 	}
 
 	if (!(has_vendor_audio || has_video || has_dvb)) {
@@ -3662,7 +3677,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		speed = "unknown";
 	}
 
-	dev_err(&interface->dev,
+	dev_err(&intf->dev,
 		"New device %s %s @ %s Mbps (%04x:%04x, interface %d, class %d)\n",
 		udev->manufacturer ? udev->manufacturer : "",
 		udev->product ? udev->product : "",
@@ -3670,7 +3685,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		le16_to_cpu(udev->descriptor.idVendor),
 		le16_to_cpu(udev->descriptor.idProduct),
 		ifnum,
-		interface->altsetting->desc.bInterfaceNumber);
+		intf->altsetting->desc.bInterfaceNumber);
 
 	/*
 	 * Make sure we have 480 Mbps of bandwidth, otherwise things like
@@ -3678,8 +3693,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	 * not enough even for most Digital TV streams.
 	 */
 	if (udev->speed != USB_SPEED_HIGH && disable_usb_speed_check == 0) {
-		dev_err(&interface->dev, "Device initialization failed.\n");
-		dev_err(&interface->dev,
+		dev_err(&intf->dev, "Device initialization failed.\n");
+		dev_err(&intf->dev,
 			"Device must be connected to a high-speed USB 2.0 port.\n");
 		retval = -ENODEV;
 		goto err_free;
@@ -3693,17 +3708,17 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	dev->ifnum = ifnum;
 
 	if (has_vendor_audio) {
-		dev_err(&interface->dev,
+		dev_err(&intf->dev,
 			"Audio interface %i found (Vendor Class)\n", ifnum);
 		dev->usb_audio_type = EM28XX_USB_AUDIO_VENDOR;
 	}
-	/* Checks if audio is provided by a USB Audio Class interface */
+	/* Checks if audio is provided by a USB Audio Class intf */
 	for (i = 0; i < udev->config->desc.bNumInterfaces; i++) {
 		struct usb_interface *uif = udev->config->interface[i];
 
 		if (uif->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
 			if (has_vendor_audio)
-				dev_err(&interface->dev,
+				dev_err(&intf->dev,
 					"em28xx: device seems to have vendor AND usb audio class interfaces !\n"
 					"\t\tThe vendor interface will be ignored. Please contact the developers <linux-media@vger.kernel.org>\n");
 			dev->usb_audio_type = EM28XX_USB_AUDIO_CLASS;
@@ -3712,27 +3727,27 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	}
 
 	if (has_video)
-		dev_err(&interface->dev, "Video interface %i found:%s%s\n",
+		dev_err(&intf->dev, "Video interface %i found:%s%s\n",
 			ifnum,
 			dev->analog_ep_bulk ? " bulk" : "",
 			dev->analog_ep_isoc ? " isoc" : "");
 	if (has_dvb)
-		dev_err(&interface->dev, "DVB interface %i found:%s%s\n",
+		dev_err(&intf->dev, "DVB interface %i found:%s%s\n",
 			ifnum,
 			dev->dvb_ep_bulk ? " bulk" : "",
 			dev->dvb_ep_isoc ? " isoc" : "");
 
-	dev->num_alt = interface->num_altsetting;
+	dev->num_alt = intf->num_altsetting;
 
 	if ((unsigned int)card[nr] < em28xx_bcount)
 		dev->model = card[nr];
 
-	/* save our data pointer in this interface device */
-	usb_set_intfdata(interface, dev);
+	/* save our data pointer in this intf device */
+	usb_set_intfdata(intf, dev);
 
 	/* allocate device struct and check if the device is a webcam */
 	mutex_init(&dev->lock);
-	retval = em28xx_init_dev(dev, udev, interface, nr);
+	retval = em28xx_init_dev(dev, udev, intf, nr);
 	if (retval)
 		goto err_free;
 
@@ -3749,7 +3764,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	if (has_video &&
 	    dev->board.decoder == EM28XX_NODECODER &&
 	    dev->em28xx_sensor == EM28XX_NOSENSOR) {
-		dev_err(&interface->dev,
+		dev_err(&intf->dev,
 			"Currently, V4L2 is not supported on this model\n");
 		has_video = false;
 		dev->has_video = false;
@@ -3759,13 +3774,13 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	if (has_video) {
 		if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
 			dev->analog_xfer_bulk = 1;
-		dev_err(&interface->dev, "analog set to %s mode.\n",
+		dev_err(&intf->dev, "analog set to %s mode.\n",
 			dev->analog_xfer_bulk ? "bulk" : "isoc");
 	}
 	if (has_dvb) {
 		if (!dev->dvb_ep_isoc || (try_bulk && dev->dvb_ep_bulk))
 			dev->dvb_xfer_bulk = 1;
-		dev_err(&interface->dev, "dvb set to %s mode.\n",
+		dev_err(&intf->dev, "dvb set to %s mode.\n",
 			dev->dvb_xfer_bulk ? "bulk" : "isoc");
 	}
 
@@ -3801,12 +3816,12 @@ static int em28xx_usb_probe(struct usb_interface *interface,
  * called when the device gets disconnected
  * video device will be unregistered on v4l2_close in case it is still open
  */
-static void em28xx_usb_disconnect(struct usb_interface *interface)
+static void em28xx_usb_disconnect(struct usb_interface *intf)
 {
 	struct em28xx *dev;
 
-	dev = usb_get_intfdata(interface);
-	usb_set_intfdata(interface, NULL);
+	dev = usb_get_intfdata(intf);
+	usb_set_intfdata(intf, NULL);
 
 	if (!dev)
 		return;
@@ -3823,23 +3838,23 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 	kref_put(&dev->ref, em28xx_free_device);
 }
 
-static int em28xx_usb_suspend(struct usb_interface *interface,
+static int em28xx_usb_suspend(struct usb_interface *intf,
 			      pm_message_t message)
 {
 	struct em28xx *dev;
 
-	dev = usb_get_intfdata(interface);
+	dev = usb_get_intfdata(intf);
 	if (!dev)
 		return 0;
 	em28xx_suspend_extension(dev);
 	return 0;
 }
 
-static int em28xx_usb_resume(struct usb_interface *interface)
+static int em28xx_usb_resume(struct usb_interface *intf)
 {
 	struct em28xx *dev;
 
-	dev = usb_get_intfdata(interface);
+	dev = usb_get_intfdata(intf);
 	if (!dev)
 		return 0;
 	em28xx_resume_extension(dev);
-- 
2.14.3
