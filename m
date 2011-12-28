Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hnelson.de ([83.169.43.49]:36056 "EHLO mail.hnelson.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab1L1Duz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 22:50:55 -0500
Date: Wed, 28 Dec 2011 04:50:45 +0100 (CET)
From: Holger Nelson <hnelson@hnelson.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Dennis Sperlich <dsperlich@googlemail.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: em28xx_isoc_dvb_max_packetsize for EM2884 (Terratec Cinergy HTC
 Stick)
In-Reply-To: <4EF86614.8050702@redhat.com>
Message-ID: <alpine.DEB.2.02.1112280438220.18133@nova.crius.de>
References: <4EF64AF4.2040705@gmail.com> <4EF70077.5040907@redhat.com> <4EF72D61.9090001@gmail.com> <4EF767CB.10705@redhat.com> <4EF78896.1060908@gmail.com> <alpine.DEB.2.02.1112260627170.17197@nova.crius.de> <4EF86614.8050702@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 26 Dec 2011, Mauro Carvalho Chehab wrote:

> I'm currently without time right now to work on a patch, but I think that several hacks
> inside the em28xx probe should be removed, including the one that detects the endpoint
> based on the packet size.
>
> As it is easier to code than to explain in words, the code below could be
> a start (ok, it doesn't compile, doesn't remove all hacks, doesn't free memory, etc...)
> Feel free to use it as a start for a real patch, if you wish.

I think, I filled the missing parts and removed most of the hacks in the 
probe code. The code works with my Cinergy HTC USB XS.

Holger

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
index a7cfded..8082914 100644
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
+	int i, nr, sizedescr, size;
  	const int ifnum = interface->altsetting[0].desc.bInterfaceNumber;
  	char *speed;
  	char descr[255] = "";
@@ -3124,56 +3123,69 @@ static int em28xx_usb_probe(struct usb_interface *interface,
  		goto err;
  	}

-	/* Get endpoints */
-	for (i = 0; i < interface->num_altsetting; i++) {
-		int ep;
+	/* allocate memory for our device state and initialize it */
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL) {
+		em28xx_err(DRIVER_NAME ": out of memory!\n");
+		retval = -ENOMEM;
+		goto err;
+	}

-		for (ep = 0; ep < interface->altsetting[i].desc.bNumEndpoints; ep++) {
-			struct usb_host_endpoint	*e;
-			e = &interface->altsetting[i].endpoint[ep];
+	/* compute alternate max packet sizes */
+	dev->alt_video_max_pkt_size = kmalloc(sizeof(dev->alt_video_max_pkt_size[0]) * interface->num_altsetting, GFP_KERNEL);
+	if (dev->alt_video_max_pkt_size == NULL) {
+		em28xx_errdev("out of memory!\n");
+		kfree(dev);
+		retval = -ENOMEM;
+		goto err;
+	}

-			if (e->desc.bEndpointAddress == 0x83)
-				has_audio = true;
-		}
+	dev->alt_dvb_max_pkt_size = kmalloc(sizeof(dev->alt_dvb_max_pkt_size[0]) * interface->num_altsetting, GFP_KERNEL);
+	if (dev->alt_dvb_max_pkt_size == NULL) {
+		em28xx_errdev("out of memory!\n");
+		kfree(dev->alt_video_max_pkt_size);
+		kfree(dev);
+		retval = -ENOMEM;
+		goto err;
  	}

-	endpoint = &interface->cur_altsetting->endpoint[0].desc;
+	/* Get endpoints */
+	for (i = 0; i < interface->num_altsetting; i++) {
+		int ep;

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
+		for (ep = 0; ep < interface->altsetting[i].desc.bNumEndpoints; ep++) {
+			const struct usb_endpoint_descriptor *e;
+ 
+			e = &interface->altsetting[i].endpoint[ep].desc;
+
+			sizedescr = le16_to_cpu(e->wMaxPacketSize);
+			size = sizedescr & 0x7fff;
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
+					dev->alt_video_max_pkt_size[i] = size;
+					break;
+				case EM28XX_EP_DIGITAL:
+					has_dvb = true;
+					dev->alt_dvb_max_pkt_size[i] = size;
+					break;
+				}
  			}
  		}
  	}
-
+ 
+	if (!(has_audio||has_video||has_dvb)) {
+        	retval=-ENODEV;
+		goto err_free_all;
+	}
+
  	switch (udev->speed) {
  	case USB_SPEED_LOW:
  		speed = "1.5";
@@ -3197,6 +3209,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
  			strlcat(descr, " ", sizeof(descr));
  		strlcat(descr, udev->product, sizeof(descr));
  	}
+
  	if (*descr)
  		strlcat(descr, " ", sizeof(descr));

@@ -3213,6 +3226,14 @@ static int em28xx_usb_probe(struct usb_interface *interface,
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
@@ -3224,22 +3245,14 @@ static int em28xx_usb_probe(struct usb_interface *interface,
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
+		goto err_free_all;
  	}

  	snprintf(dev->name, sizeof(dev->name), "em28xx #%d", nr);
  	dev->devno = nr;
  	dev->model = id->driver_info;
  	dev->alt   = -1;
-	dev->is_audio_only = is_audio_only;
+	dev->is_audio_only = has_audio&&!(has_video||has_dvb);
  	dev->has_alsa_audio = has_audio;
  	dev->audio_ifnum = ifnum;

@@ -3252,26 +3265,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
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
@@ -3285,9 +3279,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
  	retval = em28xx_init_dev(&dev, udev, interface, nr);
  	if (retval) {
  		mutex_unlock(&dev->lock);
-		kfree(dev->alt_max_pkt_size);
-		kfree(dev);
-		goto err;
+		goto err_free_all;
  	}

  	request_modules(dev);
@@ -3306,6 +3298,11 @@ static int em28xx_usb_probe(struct usb_interface *interface,

  	return 0;

+err_free_all:
+	kfree(dev->alt_dvb_max_pkt_size);
+	kfree(dev->alt_video_max_pkt_size);
+	kfree(dev);
+
  err:
  	clear_bit(nr, &em28xx_devused);

@@ -3369,7 +3366,8 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
  	em28xx_close_extension(dev);

  	if (!dev->users) {
-		kfree(dev->alt_max_pkt_size);
+		kfree(dev->alt_dvb_max_pkt_size);
+		kfree(dev->alt_video_max_pkt_size);
  		kfree(dev);
  	}
  }
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 804a4ab..74608f9 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -829,14 +829,14 @@ int em28xx_set_alternate(struct em28xx *dev)

  	for (i = 0; i < dev->num_alt; i++) {
  		/* stop when the selected alt setting offers enough bandwidth */
-		if (dev->alt_max_pkt_size[i] >= min_pkt_size) {
+		if (dev->alt_video_max_pkt_size[i] >= min_pkt_size) {
  			dev->alt = i;
  			break;
  		/* otherwise make sure that we end up with the maximum bandwidth
  		   because the min_pkt_size equation might be wrong...
  		*/
-		} else if (dev->alt_max_pkt_size[i] >
-			   dev->alt_max_pkt_size[dev->alt])
+		} else if (dev->alt_video_max_pkt_size[i] >
+			   dev->alt_video_max_pkt_size[dev->alt])
  			dev->alt = i;
  	}

@@ -844,7 +844,7 @@ set_alt:
  	if (dev->alt != prev_alt) {
  		em28xx_coredbg("minimum isoc packet size: %u (alt=%d)\n",
  				min_pkt_size, dev->alt);
-		dev->max_pkt_size = dev->alt_max_pkt_size[dev->alt];
+		dev->max_pkt_size = dev->alt_video_max_pkt_size[dev->alt];
  		em28xx_coredbg("setting alternate %d with wMaxPacketSize=%u\n",
  			       dev->alt, dev->max_pkt_size);
  		errCode = usb_set_interface(dev->udev, 0, dev->alt);
@@ -1070,7 +1070,7 @@ int em28xx_init_isoc(struct em28xx *dev, int max_packets,
  			should also be using 'desc.bInterval'
  		 */
  		pipe = usb_rcvisocpipe(dev->udev,
-			dev->mode == EM28XX_ANALOG_MODE ? 0x82 : 0x84);
+			dev->mode == EM28XX_ANALOG_MODE ? EM28XX_EP_ANALOG : EM28XX_EP_DIGITAL);

  		usb_fill_int_urb(urb, dev->udev, pipe,
  				 dev->isoc_ctl.transfer_buffer[i], sb_size,
@@ -1144,20 +1144,10 @@ int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev)
  		}
  		break;
  	case CHIP_ID_EM2874:
-		/*
-		 * FIXME: for now assumes 564 like it was before, but the
-		 * em2874 code should be added to return the proper value
-		 */
-		packet_size = 564;
-		break;
  	case CHIP_ID_EM2884:
  	case CHIP_ID_EM28174:
  	default:
-		/*
-		 * FIXME: same as em2874. 564 was enough for 22 Mbit DVB-T
-		 * but not enough for 44 Mbit DVB-C.
-		 */
-		packet_size = 752;
+		packet_size = dev->alt_dvb_max_pkt_size[1];;
  	}

  	return packet_size;
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

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 9b4557a..af9f0b7 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -2254,7 +2254,8 @@ static int em28xx_v4l2_close(struct file *filp)
  		   free the remaining resources */
  		if (dev->state & DEV_DISCONNECTED) {
  			em28xx_release_resources(dev);
-			kfree(dev->alt_max_pkt_size);
+			kfree(dev->alt_dvb_max_pkt_size);
+			kfree(dev->alt_video_max_pkt_size);
  			kfree(dev);
  			return 0;
  		}
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index b1199ef..f73f028 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -596,7 +596,8 @@ struct em28xx {
  	int alt;		/* alternate */
  	int max_pkt_size;	/* max packet size of isoc transaction */
  	int num_alt;		/* Number of alternative settings */
-	unsigned int *alt_max_pkt_size;	/* array of wMaxPacketSize */
+	unsigned int *alt_video_max_pkt_size;	/* array of wMaxPacketSize */
+	unsigned int *alt_dvb_max_pkt_size;	/* array of wMaxPacketSize */
  	struct urb *urb[EM28XX_NUM_BUFS];	/* urb for isoc transfers */
  	char *transfer_buffer[EM28XX_NUM_BUFS];	/* transfer buffers for isoc
  						   transfer */
