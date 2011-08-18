Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4-vm0.bt.bullet.mail.ird.yahoo.com ([212.82.108.93]:32500
	"HELO nm4-vm0.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753245Ab1HRVfF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 17:35:05 -0400
Message-ID: <4E4D8583.4070606@yahoo.com>
Date: Thu, 18 Aug 2011 22:34:59 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] Latest version of em28xx / em28xx-dvb patch for PCTV
 290e
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com> <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com>
In-Reply-To: <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090704090006030603010603"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090704090006030603010603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 18/08/11 19:44, Devin Heitmueller wrote:
> You would be well served to break this into a patch series, as it tends to be 
> difficult to review a whole series of changes in a single patch.

Here are the first three patches:

- release the alt_max_pkt_size buffer.
- use atomic bit operations for em28xx_devused.
- use the correct amount of memory for snprintf().

Cheers,
Chris

Signed-of-by: Chris Rankin <rankincj@yahoo.com>


--------------090704090006030603010603
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
 

--------------090704090006030603010603
Content-Type: text/x-patch;
 name="EM28xx-snprintf.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-snprintf.diff"

--- linux-3.0/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-08-17 08:52:19.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-cards.c	2011-08-18 22:03:05.000000000 +0100
@@ -3085,7 +3085,7 @@
 		goto err;
 	}
 
-	snprintf(dev->name, 29, "em28xx #%d", nr);
+	snprintf(dev->name, sizeof(dev->name), "em28xx #%d", nr);
 	dev->devno = nr;
 	dev->model = id->driver_info;
 	dev->alt   = -1;

--------------090704090006030603010603
Content-Type: text/x-patch;
 name="EM28xx-video-leak.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-video-leak.diff"

--- linux-3.0/drivers/media/video/em28xx/em28xx-video.c.orig	2011-08-18 17:20:10.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-video.c	2011-08-18 17:20:33.000000000 +0100
@@ -2202,6 +2202,7 @@
 		   free the remaining resources */
 		if (dev->state & DEV_DISCONNECTED) {
 			em28xx_release_resources(dev);
+			kfree(dev->alt_max_pkt_size);
 			kfree(dev);
 			return 0;
 		}
--- linux-3.0/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-08-17 08:52:19.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-cards.c	2011-08-18 22:09:32.000000000 +0100
@@ -3128,6 +3128,7 @@
 	retval = em28xx_init_dev(&dev, udev, interface, nr);
 	if (retval) {
 		em28xx_devused &= ~(1<<dev->devno);
+		kfree(dev->alt_max_pkt_size);
 		mutex_unlock(&dev->lock);
 		kfree(dev);
 		goto err;

--------------090704090006030603010603--
