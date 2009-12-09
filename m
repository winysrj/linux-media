Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:58755 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750858AbZLIO2w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 09:28:52 -0500
To: linux-media@vger.kernel.org
Subject: [PATCH] [resend] radio-sf16fmi: add autoprobing
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Wed, 9 Dec 2009 15:28:51 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912091528.52289.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add automatic probing of ports 0x284 and 0x384 to radio-sf16fmi if no card is
found using PnP.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-source-2.6.31/drivers/media/radio/Kconfig.1	2009-11-28 21:40:32.000000000 +0100
+++ linux-source-2.6.31/drivers/media/radio/Kconfig	2009-11-28 21:32:58.000000000 +0100
@@ -199,10 +199,7 @@
 	tristate "SF16-FMI/SF16-FMP Radio"
 	depends on ISA && VIDEO_V4L2
 	---help---
-	  Choose Y here if you have one of these FM radio cards.  If you
-	  compile the driver into the kernel and your card is not PnP one, you
-	  have to add "sf16fm=<io>" to the kernel command line (I/O address is
-	  0x284 or 0x384).
+	  Choose Y here if you have one of these FM radio cards.
 
 	  In order to control your radio card, you will need to use programs
 	  that are compatible with the Video For Linux API.  Information on
--- linux-source-2.6.31/drivers/media/radio/radio-sf16fmi.c.1	2009-11-28 21:27:22.000000000 +0100
+++ linux-source-2.6.31/drivers/media/radio/radio-sf16fmi.c	2009-11-28 22:15:57.000000000 +0100
@@ -54,6 +54,7 @@ struct fmi
 
 static struct fmi fmi_card;
 static struct pnp_dev *dev;
+bool pnp_attached;
 
 /* freq is in 1/16 kHz to internal number, hw precision is 50 kHz */
 /* It is only useful to give freq in interval of 800 (=0.05Mhz),
@@ -316,26 +317,54 @@ static int __init fmi_init(void)
 {
 	struct fmi *fmi = &fmi_card;
 	struct v4l2_device *v4l2_dev = &fmi->v4l2_dev;
-	int res;
+	int res, i;
+	int probe_ports[] = { 0, 0x284, 0x384 };
 
-	if (io < 0)
-		io = isapnp_fmi_probe();
-	strlcpy(v4l2_dev->name, "sf16fmi", sizeof(v4l2_dev->name));
-	fmi->io = io;
-	if (fmi->io < 0) {
-		v4l2_err(v4l2_dev, "No PnP card found.\n");
-		return fmi->io;
+	if (io < 0) {
+		for (i = 0; i < ARRAY_SIZE(probe_ports); i++) {
+			io = probe_ports[i];
+			if (io == 0) {
+				io = isapnp_fmi_probe();
+				if (io < 0)
+					continue;
+				pnp_attached = 1;
+			}
+			if (!request_region(io, 2, "radio-sf16fmi")) {
+				if (pnp_attached)
+					pnp_device_detach(dev);
+				io = -1;
+				continue;
+			}
+			if (pnp_attached ||
+			    ((inb(io) & 0xf9) == 0xf9 && (inb(io) & 0x4) == 0))
+				break;
+			release_region(io, 2);
+			io = -1;
+		}
+	} else {
+		if (!request_region(io, 2, "radio-sf16fmi")) {
+			printk(KERN_ERR "radio-sf16fmi: port %#x already in use\n", io);
+			return -EBUSY;
+		}
+		if (inb(io) == 0xff) {
+			printk(KERN_ERR "radio-sf16fmi: card not present at %#x\n", io);
+			release_region(io, 2);
+			return -ENODEV;
+		}
 	}
-	if (!request_region(io, 2, "radio-sf16fmi")) {
-		v4l2_err(v4l2_dev, "port 0x%x already in use\n", fmi->io);
-		pnp_device_detach(dev);
-		return -EBUSY;
+	if (io < 0) {
+		printk(KERN_ERR "radio-sf16fmi: no cards found\n");
+		return -ENODEV;
 	}
 
+	strlcpy(v4l2_dev->name, "sf16fmi", sizeof(v4l2_dev->name));
+	fmi->io = io;
+
 	res = v4l2_device_register(NULL, v4l2_dev);
 	if (res < 0) {
 		release_region(fmi->io, 2);
-		pnp_device_detach(dev);
+		if (pnp_attached)
+			pnp_device_detach(dev);
 		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
 		return res;
 	}
@@ -352,7 +381,8 @@ static int __init fmi_init(void)
 	if (video_register_device(&fmi->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
 		v4l2_device_unregister(v4l2_dev);
 		release_region(fmi->io, 2);
-		pnp_device_detach(dev);
+		if (pnp_attached)
+			pnp_device_detach(dev);
 		return -EINVAL;
 	}
 
@@ -369,7 +399,7 @@ static void __exit fmi_exit(void)
 	video_unregister_device(&fmi->vdev);
 	v4l2_device_unregister(&fmi->v4l2_dev);
 	release_region(fmi->io, 2);
-	if (dev)
+	if (dev && pnp_attached)
 		pnp_device_detach(dev);
 }
 


-- 
Ondrej Zary
