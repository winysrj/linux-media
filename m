Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:53847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab1FSRnk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 13:43:40 -0400
Date: Sun, 19 Jun 2011 14:42:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org
Subject: [PATCH 10/11] [media] em28xx: Add support for devices with a
 separate audio interface
Message-ID: <20110619144230.29a46e8d@pedra>
In-Reply-To: <cover.1308503857.git.mchehab@redhat.com>
References: <cover.1308503857.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Some devices use a separate interface for the vendor audio class.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index 47f21a3..cff0768 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -3,9 +3,9 @@
  *
  *  Copyright (C) 2006 Markus Rechberger <mrechberger@gmail.com>
  *
- *  Copyright (C) 2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+ *  Copyright (C) 2007-2011 Mauro Carvalho Chehab <mchehab@redhat.com>
  *	- Port to work with the in-kernel driver
- *	- Several cleanups
+ *	- Cleanups, fixes, alsa-controls, etc.
  *
  *  This driver is based on my previous au600 usb pstn audio driver
  *  and inherits all the copyrights
@@ -281,24 +281,28 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 		return -ENODEV;
 	}
 
-	/* Sets volume, mute, etc */
-
-	dev->mute = 0;
-	mutex_lock(&dev->lock);
-	ret = em28xx_audio_analog_set(dev);
-	if (ret < 0)
-		goto err;
-
 	runtime->hw = snd_em28xx_hw_capture;
-	if (dev->alt == 0 && dev->adev.users == 0) {
-		dev->alt = 7;
-		dprintk("changing alternate number to 7\n");
-		usb_set_interface(dev->udev, 0, 7);
+	if ((dev->alt == 0 || dev->audio_ifnum) && dev->adev.users == 0) {
+		if (dev->audio_ifnum)
+			dev->alt = 1;
+		else
+			dev->alt = 7;
+
+		dprintk("changing alternate number on interface %d to %d\n",
+			dev->audio_ifnum, dev->alt);
+		usb_set_interface(dev->udev, dev->audio_ifnum, dev->alt);
+
+		/* Sets volume, mute, etc */
+		dev->mute = 0;
+		mutex_lock(&dev->lock);
+		ret = em28xx_audio_analog_set(dev);
+		if (ret < 0)
+			goto err;
+
+		dev->adev.users++;
+		mutex_unlock(&dev->lock);
 	}
 
-	dev->adev.users++;
-	mutex_unlock(&dev->lock);
-
 	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
 	dev->adev.capture_pcm_substream = substream;
 	runtime->private_data = dev;
@@ -635,17 +639,17 @@ static int em28xx_audio_init(struct em28xx *dev)
 	static int          devnr;
 	int                 err;
 
-	if (dev->has_alsa_audio != 1) {
+	if (!dev->has_alsa_audio || dev->audio_ifnum < 0) {
 		/* This device does not support the extension (in this case
 		   the device is expecting the snd-usb-audio module or
 		   doesn't have analog audio support at all) */
 		return 0;
 	}
 
-	printk(KERN_INFO "em28xx-audio.c: probing for em28x1 "
-			 "non standard usbaudio\n");
+	printk(KERN_INFO "em28xx-audio.c: probing for em28xx Audio Vendor Class\n");
 	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2006 Markus "
 			 "Rechberger\n");
+	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab\n");
 
 	err = snd_card_create(index[devnr], "Em28xx Audio", THIS_MODULE, 0,
 			      &card);
@@ -737,7 +741,7 @@ static void __exit em28xx_alsa_unregister(void)
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Markus Rechberger <mrechberger@gmail.com>");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
 MODULE_DESCRIPTION("Em28xx Audio driver");
 
 module_init(em28xx_alsa_register);
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index bbd67d7..c445bea 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2846,6 +2846,16 @@ static int em28xx_init_dev(struct em28xx **devhandle, struct usb_device *udev,
 		}
 	}
 
+	if (dev->is_audio_only) {
+		errCode = em28xx_audio_setup(dev);
+		if (errCode)
+			return -ENODEV;
+		em28xx_add_into_devlist(dev);
+		em28xx_init_extension(dev);
+
+		return 0;
+	}
+
 	/* Prepopulate cached GPO register content */
 	retval = em28xx_read_reg(dev, dev->reg_gpo_num);
 	if (retval >= 0)
@@ -2946,6 +2956,9 @@ fail_reg_devices:
 	return retval;
 }
 
+/* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
+#define hb_mult(wMaxPacketSize) (1 + (((wMaxPacketSize) >> 11) & 0x03))
+
 /*
  * em28xx_usb_probe()
  * checks for supported devices
@@ -2955,15 +2968,15 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 {
 	const struct usb_endpoint_descriptor *endpoint;
 	struct usb_device *udev;
-	struct usb_interface *uif;
 	struct em28xx *dev = NULL;
 	int retval;
-	int i, nr, ifnum, isoc_pipe;
+	bool is_audio_only = false, has_audio = false;
+	int i, nr, isoc_pipe;
+	const int ifnum = interface->altsetting[0].desc.bInterfaceNumber;
 	char *speed;
 	char descr[255] = "";
 
 	udev = usb_get_dev(interface_to_usbdev(interface));
-	ifnum = interface->altsetting[0].desc.bInterfaceNumber;
 
 	/* Check to see next free device and mark as used */
 	nr = find_first_zero_bit(&em28xx_devused, EM28XX_MAXBOARDS);
@@ -2983,6 +2996,19 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		goto err;
 	}
 
+	/* Get endpoints */
+	for (i = 0; i < interface->num_altsetting; i++) {
+		int ep;
+
+		for (ep = 0; ep < interface->altsetting[i].desc.bNumEndpoints; ep++) {
+			struct usb_host_endpoint	*e;
+			e = &interface->altsetting[i].endpoint[ep];
+
+			if (e->desc.bEndpointAddress == 0x83)
+				has_audio = true;
+		}
+	}
+
 	endpoint = &interface->cur_altsetting->endpoint[0].desc;
 
 	/* check if the device has the iso in endpoint at the correct place */
@@ -3002,19 +3028,22 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 			check_interface = 0;
 
 		if (!check_interface) {
-			em28xx_err(DRIVER_NAME " video device (%04x:%04x): "
-				"interface %i, class %i found.\n",
-				le16_to_cpu(udev->descriptor.idVendor),
-				le16_to_cpu(udev->descriptor.idProduct),
-				ifnum,
-				interface->altsetting[0].desc.bInterfaceClass);
+			if (has_audio) {
+				is_audio_only = true;
+			} else {
+				em28xx_err(DRIVER_NAME " video device (%04x:%04x): "
+					"interface %i, class %i found.\n",
+					le16_to_cpu(udev->descriptor.idVendor),
+					le16_to_cpu(udev->descriptor.idProduct),
+					ifnum,
+					interface->altsetting[0].desc.bInterfaceClass);
+				em28xx_err(DRIVER_NAME " This is an anciliary "
+					"interface not used by the driver\n");
 
-			em28xx_err(DRIVER_NAME " This is an anciliary "
-				"interface not used by the driver\n");
-
-			em28xx_devused &= ~(1<<nr);
-			retval = -ENODEV;
-			goto err;
+				em28xx_devused &= ~(1<<nr);
+				retval = -ENODEV;
+				goto err;
+			}
 		}
 	}
 
@@ -3044,8 +3073,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	if (*descr)
 		strlcat(descr, " ", sizeof(descr));
 
-	printk(DRIVER_NAME ": New device %s@ %s Mbps "
-		"(%04x:%04x, interface %d, class %d)\n",
+	printk(KERN_INFO DRIVER_NAME
+		": New device %s@ %s Mbps (%04x:%04x, interface %d, class %d)\n",
 		descr,
 		speed,
 		le16_to_cpu(udev->descriptor.idVendor),
@@ -3053,6 +3082,11 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		ifnum,
 		interface->altsetting->desc.bInterfaceNumber);
 
+	if (has_audio)
+		printk(KERN_INFO DRIVER_NAME
+		       ": Audio Vendor Class interface %i found\n",
+		       ifnum);
+
 	/*
 	 * Make sure we have 480 Mbps of bandwidth, otherwise things like
 	 * video stream wouldn't likely work, since 12 Mbps is generally
@@ -3088,10 +3122,13 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	dev->devno = nr;
 	dev->model = id->driver_info;
 	dev->alt   = -1;
+	dev->is_audio_only = is_audio_only;
+	dev->has_alsa_audio = has_audio;
+	dev->audio_ifnum = ifnum;
 
 	/* Checks if audio is provided by some interface */
 	for (i = 0; i < udev->config->desc.bNumInterfaces; i++) {
-		uif = udev->config->interface[i];
+		struct usb_interface *uif = udev->config->interface[i];
 		if (uif->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
 			dev->has_audio_class = 1;
 			break;
@@ -3099,9 +3136,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	}
 
 	/* compute alternate max packet sizes */
-	uif = udev->actconfig->interface[0];
-
-	dev->num_alt = uif->num_altsetting;
+	dev->num_alt = interface->num_altsetting;
 	dev->alt_max_pkt_size = kmalloc(32 * dev->num_alt, GFP_KERNEL);
 
 	if (dev->alt_max_pkt_size == NULL) {
@@ -3113,14 +3148,21 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	}
 
 	for (i = 0; i < dev->num_alt ; i++) {
-		u16 tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].desc.wMaxPacketSize);
-		dev->alt_max_pkt_size[i] =
-		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
+		u16 tmp = le16_to_cpu(interface->altsetting[i].endpoint[isoc_pipe].desc.wMaxPacketSize);
+		unsigned int size = tmp & 0x7ff;
+
+		if (udev->speed == USB_SPEED_HIGH)
+			size = size * hb_mult(tmp);
+
+		dev->alt_max_pkt_size[i] = size;
 	}
 
 	if ((card[nr] >= 0) && (card[nr] < em28xx_bcount))
 		dev->model = card[nr];
 
+	/* save our data pointer in this interface device */
+	usb_set_intfdata(interface, dev);
+
 	/* allocate device struct */
 	mutex_init(&dev->lock);
 	mutex_lock(&dev->lock);
@@ -3132,9 +3174,6 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		goto err;
 	}
 
-	/* save our data pointer in this interface device */
-	usb_set_intfdata(interface, dev);
-
 	request_modules(dev);
 
 	/* Should be the last thing to do, to avoid newer udev's to
@@ -3163,6 +3202,13 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 	if (!dev)
 		return;
 
+	if (dev->is_audio_only) {
+		mutex_lock(&dev->lock);
+		em28xx_close_extension(dev);
+		mutex_unlock(&dev->lock);
+		return;
+	}
+
 	em28xx_info("disconnecting %s\n", dev->vdev->name);
 
 	flush_request_modules(dev);
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 752d4ed..16c9b73 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -499,17 +499,13 @@ int em28xx_audio_setup(struct em28xx *dev)
 	if (dev->chip_id == CHIP_ID_EM2870 || dev->chip_id == CHIP_ID_EM2874
 		|| dev->chip_id == CHIP_ID_EM28174) {
 		/* Digital only device - don't load any alsa module */
-		dev->audio_mode.has_audio = 0;
-		dev->has_audio_class = 0;
-		dev->has_alsa_audio = 0;
+		dev->audio_mode.has_audio = false;
+		dev->has_audio_class = false;
+		dev->has_alsa_audio = false;
 		return 0;
 	}
 
-	/* If device doesn't support Usb Audio Class, use vendor class */
-	if (!dev->has_audio_class)
-		dev->has_alsa_audio = 1;
-
-	dev->audio_mode.has_audio = 1;
+	dev->audio_mode.has_audio = true;
 
 	/* See how this device is configured */
 	cfg = em28xx_read_reg(dev, EM28XX_R00_CHIPCFG);
@@ -519,8 +515,8 @@ int em28xx_audio_setup(struct em28xx *dev)
 		cfg = EM28XX_CHIPCFG_AC97; /* Be conservative */
 	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) == 0x00) {
 		/* The device doesn't have vendor audio at all */
-		dev->has_alsa_audio = 0;
-		dev->audio_mode.has_audio = 0;
+		dev->has_alsa_audio = false;
+		dev->audio_mode.has_audio = false;
 		return 0;
 	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
 		   EM28XX_CHIPCFG_I2S_3_SAMPRATES) {
@@ -549,8 +545,8 @@ int em28xx_audio_setup(struct em28xx *dev)
 		 */
 		em28xx_warn("AC97 chip type couldn't be determined\n");
 		dev->audio_mode.ac97 = EM28XX_NO_AC97;
-		dev->has_alsa_audio = 0;
-		dev->audio_mode.has_audio = 0;
+		dev->has_alsa_audio = false;
+		dev->audio_mode.has_audio = false;
 		goto init_audio;
 	}
 
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index f9b77b4..e03849f 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -487,6 +487,8 @@ struct em28xx {
 	int devno;		/* marks the number of this device */
 	enum em28xx_chip_id chip_id;
 
+	int audio_ifnum;
+
 	struct v4l2_device v4l2_dev;
 	struct em28xx_board board;
 
@@ -503,6 +505,7 @@ struct em28xx {
 
 	unsigned int has_audio_class:1;
 	unsigned int has_alsa_audio:1;
+	unsigned int is_audio_only:1;
 
 	/* Controls audio streaming */
 	struct work_struct wq_trigger;              /* Trigger to start/stop audio for alsa module */
-- 
1.7.1


