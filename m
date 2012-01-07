Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.enix.org ([193.19.211.146]:35192 "EHLO smtp.enix.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab2AGOBx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 09:01:53 -0500
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: linux-media@vger.kernel.org, dheitmueller@kernellabs.com,
	srinivasa.deevi@conexant.com
Cc: gregory.clement@free-electrons.com,
	maxime.ripard@free-electrons.com,
	michael.opdenacker@free-electrons.com
Subject: [PATCH 2/4] cx231xx: fix crash after load/unload/load of module
Date: Sat,  7 Jan 2012 14:52:38 +0100
Message-Id: <1325944360-28964-3-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1325944360-28964-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1325944360-28964-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following sequence of commands was triggering a kernel crash in
cdev_get():

 modprobe cx231xx
 rmmod cx231xx
 modprobe cx231xx
 v4l2grab -n 1

The problem was that cx231xx_usb_disconnect() was not doing anything
because the test:

	if (!dev->udev)
		return;

was reached (i.e, dev->udev was NULL).

This is due to the fact that the 'dev' pointer placed as intfdata into
the usb_interface structure had the wrong value, because
cx231xx_probe() was doing the usb_set_intfdata() on the wrong
usb_interface structure. For some reason, cx231xx_probe() was doing
the following:

static int cx231xx_usb_probe(struct usb_interface *interface,
			     const struct usb_device_id *id)
{
        struct usb_interface *lif = NULL;
	[...]
        /* store the current interface */
        lif = interface;
	[...]
        /* store the interface 0 back */
        lif = udev->actconfig->interface[0];
	[...]
	usb_set_intfdata(lif, dev);
	[...]
	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
	[...]
}

So, the usb_set_intfdata() was done on udev->actconfig->interface[0]
and not on the 'interface' passed as argument to the ->probe() and
->disconnect() hooks. Later on, v4l2_device_register() was
initializing the intfdata of the correct usb_interface structure as a
pointer to the v4l2_device structure.

Upon unregistration, the ->disconnect() hook was getting the intfdata
of the usb_interface passed as argument... and casted it to a 'struct
cx231xx *' while it was in fact a 'struct v4l2_device *'.

The correct fix seems to just be to set the intfdata on the proper
interface from the beginning. Now, loading/unloading/reloading the
driver allows to use the device properly.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/media/video/cx231xx/cx231xx-cards.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 53dae2a..bfcc8ab 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -1135,7 +1135,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	cx231xx_info("registering interface %d\n", ifnum);
 
 	/* save our data pointer in this interface device */
-	usb_set_intfdata(lif, dev);
+	usb_set_intfdata(interface, dev);
 
 	/*
 	 * AV device initialization - only done at the last interface
@@ -1157,7 +1157,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		v4l2_device_unregister(&dev->v4l2_dev);
 		kfree(dev);
 		dev = NULL;
-		usb_set_intfdata(lif, NULL);
+		usb_set_intfdata(interface, NULL);
 
 		return retval;
 	}
-- 
1.7.4.1

