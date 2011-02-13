Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:9432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab1BMRbN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 12:31:13 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1DHVDPC027537
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 13 Feb 2011 12:31:13 -0500
Received: from pedra (vpn-239-52.phx2.redhat.com [10.3.239.52])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1DHT5kN015438
	for <linux-media@vger.kernel.org>; Sun, 13 Feb 2011 12:31:13 -0500
Date: Sun, 13 Feb 2011 15:28:53 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/5] [media] cx231xx: Simplify interface checking logic at
 probe
Message-ID: <20110213152853.760eaff3@pedra>
In-Reply-To: <cover.1297617986.git.mchehab@redhat.com>
References: <cover.1297617986.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Just a cleanup patch. Removes one indent level by moving
the return -ENODEV to happen before the device register
logic, if the interface is not the audio/video (int 1).

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 588f3e8..ca2b24b 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -844,110 +844,110 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	udev = usb_get_dev(interface_to_usbdev(interface));
 	ifnum = interface->altsetting[0].desc.bInterfaceNumber;
 
-	if (ifnum == 1) {
-		/*
-		 * Interface number 0 - IR interface
-		 */
-		/* Check to see next free device and mark as used */
-		nr = find_first_zero_bit(&cx231xx_devused, CX231XX_MAXBOARDS);
-		cx231xx_devused |= 1 << nr;
+	/*
+	 * Interface number 0 - IR interface (handled by mceusb driver)
+	 * Interface number 1 - AV interface (handled by this driver)
+	 */
+	if (ifnum != 1)
+		return -ENODEV;
 
-		if (nr >= CX231XX_MAXBOARDS) {
-			cx231xx_err(DRIVER_NAME
+	/* Check to see next free device and mark as used */
+	nr = find_first_zero_bit(&cx231xx_devused, CX231XX_MAXBOARDS);
+	cx231xx_devused |= 1 << nr;
+
+	if (nr >= CX231XX_MAXBOARDS) {
+		cx231xx_err(DRIVER_NAME
 		 ": Supports only %i cx231xx boards.\n", CX231XX_MAXBOARDS);
-			cx231xx_devused &= ~(1 << nr);
-			return -ENOMEM;
-		}
-
-		/* allocate memory for our device state and initialize it */
-		dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-		if (dev == NULL) {
-			cx231xx_err(DRIVER_NAME ": out of memory!\n");
-			cx231xx_devused &= ~(1 << nr);
-			return -ENOMEM;
-		}
-
-		snprintf(dev->name, 29, "cx231xx #%d", nr);
-		dev->devno = nr;
-		dev->model = id->driver_info;
-		dev->video_mode.alt = -1;
-		dev->interface_count++;
-
-		/* reset gpio dir and value */
-		dev->gpio_dir = 0;
-		dev->gpio_val = 0;
-		dev->xc_fw_load_done = 0;
-		dev->has_alsa_audio = 1;
-		dev->power_mode = -1;
-		atomic_set(&dev->devlist_count, 0);
-
-		/* 0 - vbi ; 1 -sliced cc mode */
-		dev->vbi_or_sliced_cc_mode = 0;
-
-		/* get maximum no.of IAD interfaces */
-		assoc_desc = udev->actconfig->intf_assoc[0];
-		dev->max_iad_interface_count = assoc_desc->bInterfaceCount;
-
-		/* init CIR module TBD */
-
-		/* store the current interface */
-		lif = interface;
-
-		/*mode_tv: digital=1 or analog=0*/
-		dev->mode_tv = 0;
-
-		dev->USE_ISO = transfer_mode;
-
-		switch (udev->speed) {
-		case USB_SPEED_LOW:
-			speed = "1.5";
-			break;
-		case USB_SPEED_UNKNOWN:
-		case USB_SPEED_FULL:
-			speed = "12";
-			break;
-		case USB_SPEED_HIGH:
-			speed = "480";
-			break;
-		default:
-			speed = "unknown";
-		}
-
-		if (udev->manufacturer)
-			strlcpy(descr, udev->manufacturer, sizeof(descr));
-
-		if (udev->product) {
-			if (*descr)
-				strlcat(descr, " ", sizeof(descr));
-			strlcat(descr, udev->product, sizeof(descr));
-		}
+		cx231xx_devused &= ~(1 << nr);
+		return -ENOMEM;
+	}
+
+	/* allocate memory for our device state and initialize it */
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL) {
+		cx231xx_err(DRIVER_NAME ": out of memory!\n");
+		cx231xx_devused &= ~(1 << nr);
+		return -ENOMEM;
+	}
+
+	snprintf(dev->name, 29, "cx231xx #%d", nr);
+	dev->devno = nr;
+	dev->model = id->driver_info;
+	dev->video_mode.alt = -1;
+
+	dev->interface_count++;
+	/* reset gpio dir and value */
+	dev->gpio_dir = 0;
+	dev->gpio_val = 0;
+	dev->xc_fw_load_done = 0;
+	dev->has_alsa_audio = 1;
+	dev->power_mode = -1;
+	atomic_set(&dev->devlist_count, 0);
+
+	/* 0 - vbi ; 1 -sliced cc mode */
+	dev->vbi_or_sliced_cc_mode = 0;
+
+	/* get maximum no.of IAD interfaces */
+	assoc_desc = udev->actconfig->intf_assoc[0];
+	dev->max_iad_interface_count = assoc_desc->bInterfaceCount;
+
+	/* init CIR module TBD */
+
+	/* store the current interface */
+	lif = interface;
+
+	/*mode_tv: digital=1 or analog=0*/
+	dev->mode_tv = 0;
+
+	dev->USE_ISO = transfer_mode;
+
+	switch (udev->speed) {
+	case USB_SPEED_LOW:
+		speed = "1.5";
+		break;
+	case USB_SPEED_UNKNOWN:
+	case USB_SPEED_FULL:
+		speed = "12";
+		break;
+	case USB_SPEED_HIGH:
+		speed = "480";
+		break;
+	default:
+		speed = "unknown";
+	}
+
+	if (udev->manufacturer)
+		strlcpy(descr, udev->manufacturer, sizeof(descr));
+
+	if (udev->product) {
 		if (*descr)
 			strlcat(descr, " ", sizeof(descr));
+		strlcat(descr, udev->product, sizeof(descr));
+	}
+	if (*descr)
+		strlcat(descr, " ", sizeof(descr));
 
-		cx231xx_info("New device %s@ %s Mbps "
-		     "(%04x:%04x) with %d interfaces\n",
-		     descr,
-		     speed,
-		     le16_to_cpu(udev->descriptor.idVendor),
-		     le16_to_cpu(udev->descriptor.idProduct),
-		     dev->max_iad_interface_count);
+	cx231xx_info("New device %s@ %s Mbps "
+	     "(%04x:%04x) with %d interfaces\n",
+	     descr,
+	     speed,
+	     le16_to_cpu(udev->descriptor.idVendor),
+	     le16_to_cpu(udev->descriptor.idProduct),
+	     dev->max_iad_interface_count);
 
-		/* store the interface 0 back */
-		lif = udev->actconfig->interface[0];
+	/* store the interface 0 back */
+	lif = udev->actconfig->interface[0];
 
-		/* increment interface count */
-		dev->interface_count++;
+	/* increment interface count */
+	dev->interface_count++;
 
-		/* get device number */
-		nr = dev->devno;
+	/* get device number */
+	nr = dev->devno;
 
-		assoc_desc = udev->actconfig->intf_assoc[0];
-		if (assoc_desc->bFirstInterface != ifnum) {
-			cx231xx_err(DRIVER_NAME ": Not found "
-				    "matching IAD interface\n");
-			return -ENODEV;
-		}
-	} else {
+	assoc_desc = udev->actconfig->intf_assoc[0];
+	if (assoc_desc->bFirstInterface != ifnum) {
+		cx231xx_err(DRIVER_NAME ": Not found "
+			    "matching IAD interface\n");
 		return -ENODEV;
 	}
 
-- 
1.7.1


