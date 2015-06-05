Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49075 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520AbbFEO2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 10:28:06 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Raphael Poggi <poggi.raph@gmail.com>,
	Tapasweni Pathak <tapaswenipathak@gmail.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	Amber Thrall <amber.rose.thrall@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Gulsah Kose <gulsah.1004@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH 11/11] [media] lirc_imon: simplify error handling code
Date: Fri,  5 Jun 2015 11:27:44 -0300
Message-Id: <5f0e2a6814539e958b33d43defd405a84df9ffac.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using a state machine and a switch with lots of
fall-trough, use gotos and cleanup the error handling loop.

That removes those two smatch warnings:
	drivers/staging/media/lirc/lirc_imon.c:933 imon_probe() warn: possible memory leak of 'context'
	drivers/staging/media/lirc/lirc_imon.c:933 imon_probe() warn: possible memory leak of 'driver'

And make the error handling code more standard.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 335b98a54237..62ec9f70dae4 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -693,10 +693,9 @@ static int imon_probe(struct usb_interface *interface,
 	int ifnum;
 	int lirc_minor = 0;
 	int num_endpts;
-	int retval = 0;
+	int retval = -ENOMEM;
 	int display_ep_found = 0;
 	int ir_ep_found = 0;
-	int alloc_status = 0;
 	int vfd_proto_6p = 0;
 	struct imon_context *context = NULL;
 	int i;
@@ -706,10 +705,8 @@ static int imon_probe(struct usb_interface *interface,
 	mutex_lock(&driver_lock);
 
 	context = kzalloc(sizeof(struct imon_context), GFP_KERNEL);
-	if (!context) {
-		alloc_status = 1;
-		goto alloc_status_switch;
-	}
+	if (!context)
+		goto driver_unlock;
 
 	/*
 	 * Try to auto-detect the type of display if the user hasn't set
@@ -775,8 +772,7 @@ static int imon_probe(struct usb_interface *interface,
 		dev_err(dev, "%s: no valid input (IR) endpoint found.\n",
 			__func__);
 		retval = -ENODEV;
-		alloc_status = 2;
-		goto alloc_status_switch;
+		goto free_context;
 	}
 
 	/* Determine if display requires 6 packets */
@@ -790,31 +786,26 @@ static int imon_probe(struct usb_interface *interface,
 
 	driver = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
 	if (!driver) {
-		alloc_status = 2;
-		goto alloc_status_switch;
+		goto free_context;
 	}
 	rbuf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
 	if (!rbuf) {
-		alloc_status = 3;
-		goto alloc_status_switch;
+		goto free_driver;
 	}
 	if (lirc_buffer_init(rbuf, BUF_CHUNK_SIZE, BUF_SIZE)) {
 		dev_err(dev, "%s: lirc_buffer_init failed\n", __func__);
-		alloc_status = 4;
-		goto alloc_status_switch;
+		goto free_rbuf;
 	}
 	rx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!rx_urb) {
 		dev_err(dev, "%s: usb_alloc_urb failed for IR urb\n", __func__);
-		alloc_status = 5;
-		goto alloc_status_switch;
+		goto free_lirc_buf;
 	}
 	tx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!tx_urb) {
 		dev_err(dev, "%s: usb_alloc_urb failed for display urb\n",
 		    __func__);
-		alloc_status = 6;
-		goto alloc_status_switch;
+		goto free_rx_urb;
 	}
 
 	mutex_init(&context->ctx_lock);
@@ -840,11 +831,11 @@ static int imon_probe(struct usb_interface *interface,
 	lirc_minor = lirc_register_driver(driver);
 	if (lirc_minor < 0) {
 		dev_err(dev, "%s: lirc_register_driver failed\n", __func__);
-		alloc_status = 7;
-		goto unlock;
-	} else
-		dev_info(dev, "Registered iMON driver (lirc minor: %d)\n",
-			 lirc_minor);
+		goto free_tx_urb;
+	}
+
+	dev_info(dev, "Registered iMON driver (lirc minor: %d)\n",
+			lirc_minor);
 
 	/* Needed while unregistering! */
 	driver->minor = lirc_minor;
@@ -872,11 +863,9 @@ static int imon_probe(struct usb_interface *interface,
 		context->rx_endpoint->bInterval);
 
 	retval = usb_submit_urb(context->rx_urb, GFP_KERNEL);
-
 	if (retval) {
 		dev_err(dev, "usb_submit_urb failed for intf0 (%d)\n", retval);
-		alloc_status = 8;
-		goto unlock;
+		goto unregister_lirc;
 	}
 
 	usb_set_intfdata(interface, context);
@@ -895,39 +884,31 @@ static int imon_probe(struct usb_interface *interface,
 	dev_info(dev, "iMON device (%04x:%04x, intf%d) on usb<%d:%d> initialized\n",
 		vendor, product, ifnum, usbdev->bus->busnum, usbdev->devnum);
 
-unlock:
-	mutex_unlock(&context->ctx_lock);
-alloc_status_switch:
+	/* Everything went fine. Just unlock and return retval (with is 0) */
+	goto driver_unlock;
 
-	switch (alloc_status) {
-	case 8:
-		lirc_unregister_driver(driver->minor);
-	case 7:
-		usb_free_urb(tx_urb);
-	case 6:
-		usb_free_urb(rx_urb);
-		/* fall-through */
-	case 5:
-		if (rbuf)
-			lirc_buffer_free(rbuf);
-		/* fall-through */
-	case 4:
-		kfree(rbuf);
-		/* fall-through */
-	case 3:
-		kfree(driver);
-		/* fall-through */
-	case 2:
-		kfree(context);
-		context = NULL;
-	case 1:
-		if (retval != -ENODEV)
-			retval = -ENOMEM;
-		break;
-	case 0:
-		retval = 0;
-	}
+unregister_lirc:
+	lirc_unregister_driver(driver->minor);
 
+free_tx_urb:
+	usb_free_urb(tx_urb);
+
+free_rx_urb:
+	usb_free_urb(rx_urb);
+
+free_lirc_buf:
+	lirc_buffer_free(rbuf);
+
+free_rbuf:
+	kfree(rbuf);
+
+free_driver:
+	kfree(driver);
+free_context:
+	kfree(context);
+	context = NULL;
+
+driver_unlock:
 	mutex_unlock(&driver_lock);
 
 	return retval;
-- 
2.4.2

