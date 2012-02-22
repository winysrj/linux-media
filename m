Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:52962 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753295Ab2BVUeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 15:34:10 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: PnP support for the new ISA radio framework?
Date: Wed, 22 Feb 2012 21:33:29 +0100
Cc: linux-media@vger.kernel.org
References: <201202181733.34599.linux@rainbow-software.org>
In-Reply-To: <201202181733.34599.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202222133.34620.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 18 February 2012 17:33:32 Ondrej Zary wrote:
> Hello,
> there are some ISA radio cards with PnP support (e.g. SF16-FMI) but the new
> ISA radio framework has no PnP support.
>
> I got AOpen FX-3D/Pro Radio card which is AD1816 with Gemtek radio - and
> with PnP. But radio-gemtek fails to load because the radio I/O port is not
> enabled (and the driver does not support PnP).
>
> Tried to add PnP support to radio-isa but failed. Splitted non-isa_driver
> related parts from radio_isa_probe() to a separate function and tried to
> create radio_isa_pnp_probe() only to realize that I'm not able to access
> struct radio_isa_driver.
>
> radio_isa_probe() relies on the fact that "driver" (struct isa_driver) is
> the first element of struct radio_isa_driver, so these two structs have the
> same pointer:
> HW radio driver registers the driver by calling:
>   isa_register_driver(&gemtek_driver.driver, GEMTEK_MAX);
> radio_isa_probe() in radio-isa.c does:
>   struct radio_isa_driver *drv = pdev->platform_data;
>
> So adding struct pnp_driver to struct radio_isa_driver does not seem to be
> possible.

Adding PnP support to original radio-gemtek (before conversion to ISA radio
framework) is easy. A patch like this (mostly copied from radio-cadet) allows
radio on AOpen FX-3D/Pro Radio card to work.
But how to do this with the new driver?


--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -23,6 +23,7 @@
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/mutex.h>
 #include <linux/io.h>		/* outb, outb_p			*/
+#include <linux/pnp.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 
@@ -329,6 +330,46 @@ static int gemtek_verify(struct gemtek *gt, int port)
 	return 1;
 }
 
+#ifdef CONFIG_PNP
+
+static struct pnp_device_id gemtek_pnp_devices[] = {
+	/* AOpen FX-3D/Pro Radio */
+	{.id = "ADS7183", .driver_data = 0},
+	{.id = ""}
+};
+
+MODULE_DEVICE_TABLE(pnp, gemtek_pnp_devices);
+
+static int gemtek_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
+{
+	if (!dev)
+		return -ENODEV;
+	/* only support one device */
+	if (io > 0)
+		return -EBUSY;
+
+	if (!pnp_port_valid(dev, 0))
+		return -ENODEV;
+
+	io = pnp_port_start(dev, 0);
+
+	printk(KERN_INFO "radio-gemtek: PnP reports device at %#x\n", io);
+
+	return io;
+}
+
+static struct pnp_driver gemtek_pnp_driver = {
+	.name		= "radio-gemtek",
+	.id_table	= gemtek_pnp_devices,
+	.probe		= gemtek_pnp_probe,
+	.remove		= NULL,
+};
+
+#else
+static struct pnp_driver gemtek_pnp_driver;
+#endif
+
+
 /*
  * Automatic probing for card.
  */
@@ -536,8 +577,11 @@ static int __init gemtek_init(void)
 	mutex_init(&gt->lock);
 
 	gt->verified = -1;
+	if (io < 0)
+		pnp_register_driver(&gemtek_pnp_driver);
+	else
+		gemtek_probe(gt);
 	gt->io = io;
-	gemtek_probe(gt);
 	if (gt->io) {
 		if (!request_region(gt->io, 1, "gemtek")) {
 			v4l2_err(v4l2_dev, "I/O port 0x%x already in use.\n", gt->io);
@@ -608,6 +652,7 @@ static void __exit gemtek_exit(void)
 	video_unregister_device(&gt->vdev);
 	v4l2_device_unregister(&gt->v4l2_dev);
 	release_region(gt->io, 1);
+	pnp_unregister_driver(&gemtek_pnp_driver);
 }
 
 module_init(gemtek_init);


-- 
Ondrej Zary
