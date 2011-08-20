Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm2.bt.bullet.mail.ukl.yahoo.com ([217.146.183.200]:28777 "HELO
	nm2.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752857Ab1HTLVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 07:21:08 -0400
Message-ID: <4E4F989F.1020900@yahoo.com>
Date: Sat, 20 Aug 2011 12:21:03 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/6] EM28xx - use atomic bit operations for devices-in-use
 mask
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com> <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com> <4E4D8DFD.5060800@yahoo.com> <4E4DFA65.4090508@redhat.com>
In-Reply-To: <4E4DFA65.4090508@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------060008020406070709000100"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060008020406070709000100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Use atomic bit operations for the em28xx_devused mask, to prevent an unlikely 
race condition should two adapters be plugged in simultaneously. The operations 
also clearer than explicit bit manipulation anyway.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>


--------------060008020406070709000100
Content-Type: text/x-patch;
 name="EM28xx-devused-bits.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-devused-bits.diff"

--- linux-3.0/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-08-18 22:24:12.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-cards.c	2011-08-18 22:22:14.000000000 +0100
@@ -60,7 +60,7 @@
 module_param_array(card,  int, NULL, 0444);
 MODULE_PARM_DESC(card,     "card type");
 
-/* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS */
+/* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS - 1 */
 static unsigned long em28xx_devused;
 
 struct em28xx_hash_table {
@@ -2763,7 +2763,7 @@
 	usb_put_dev(dev->udev);
 
 	/* Mark device as unused */
-	em28xx_devused &= ~(1 << dev->devno);
+	clear_bit(dev->devno, &em28xx_devused);
 };
 
 /*
@@ -2967,8 +2967,16 @@
 	ifnum = interface->altsetting[0].desc.bInterfaceNumber;
 
 	/* Check to see next free device and mark as used */
-	nr = find_first_zero_bit(&em28xx_devused, EM28XX_MAXBOARDS);
-	em28xx_devused |= 1<<nr;
+	do {
+		nr = find_first_zero_bit(&em28xx_devused, EM28XX_MAXBOARDS);
+		if (nr >= EM28XX_MAXBOARDS) {
+			/* No free device slots */
+			printk(DRIVER_NAME ": Supports only %i em28xx boards.\n",
+					EM28XX_MAXBOARDS);
+			retval = -ENOMEM;
+			goto err_no_slot;
+		}
+	} while (test_and_set_bit(nr, &em28xx_devused));
 
 	/* Don't register audio interfaces */
 	if (interface->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
@@ -2979,7 +2987,6 @@
 			ifnum,
 			interface->altsetting[0].desc.bInterfaceClass);
 
-		em28xx_devused &= ~(1<<nr);
 		retval = -ENODEV;
 		goto err;
 	}
@@ -3013,7 +3020,6 @@
 			em28xx_err(DRIVER_NAME " This is an anciliary "
 				"interface not used by the driver\n");
 
-			em28xx_devused &= ~(1<<nr);
 			retval = -ENODEV;
 			goto err;
 		}
@@ -3063,24 +3069,14 @@
 		printk(DRIVER_NAME ": Device initialization failed.\n");
 		printk(DRIVER_NAME ": Device must be connected to a high-speed"
 		       " USB 2.0 port.\n");
-		em28xx_devused &= ~(1<<nr);
 		retval = -ENODEV;
 		goto err;
 	}
 
-	if (nr >= EM28XX_MAXBOARDS) {
-		printk(DRIVER_NAME ": Supports only %i em28xx boards.\n",
-				EM28XX_MAXBOARDS);
-		em28xx_devused &= ~(1<<nr);
-		retval = -ENOMEM;
-		goto err;
-	}
-
 	/* allocate memory for our device state and initialize it */
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
 		em28xx_err(DRIVER_NAME ": out of memory!\n");
-		em28xx_devused &= ~(1<<nr);
 		retval = -ENOMEM;
 		goto err;
 	}
@@ -3107,7 +3103,6 @@
 
 	if (dev->alt_max_pkt_size == NULL) {
 		em28xx_errdev("out of memory!\n");
-		em28xx_devused &= ~(1<<nr);
 		kfree(dev);
 		retval = -ENOMEM;
 		goto err;
@@ -3127,7 +3122,6 @@
 	mutex_lock(&dev->lock);
 	retval = em28xx_init_dev(&dev, udev, interface, nr);
 	if (retval) {
-		em28xx_devused &= ~(1<<dev->devno);
 		kfree(dev->alt_max_pkt_size);
 		mutex_unlock(&dev->lock);
 		kfree(dev);
@@ -3147,6 +3141,10 @@
 	return 0;
 
 err:
+	clear_bit(nr, &em28xx_devused);
+
+err_no_slot:
+	usb_put_dev(udev);
 	return retval;
 }
 

--------------060008020406070709000100--
