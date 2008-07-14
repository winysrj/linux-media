Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6E7RmZI018100
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 03:27:48 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6E7RMQP000376
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 03:27:23 -0400
Received: by ug-out-1314.google.com with SMTP id s2so205785uge.6
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 00:27:22 -0700 (PDT)
Date: Mon, 14 Jul 2008 09:27:33 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: David Brownell <david-b@pacbell.net>
Message-ID: <20080714072733.GA29908@ska.dandreoli.com>
References: <200807101914.10174.mb@bu3sch.de>
	<200807131300.35126.david-b@pacbell.net>
	<20080714052556.GA3470@ska.dandreoli.com>
	<200807132259.54360.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807132259.54360.david-b@pacbell.net>
Cc: video4linux-list@redhat.com, Michael Buesch <mb@bu3sch.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] Add bt8xxgpio driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sun, Jul 13, 2008 at 10:59:54PM -0700, David Brownell wrote:
> On Sunday 13 July 2008, Domenico Andreoli wrote:
> > Say that a given card has 4 relays attached to its GPIOs. Only the
> > card's driver may know about these relays and only the driver should
> > be able to set those GPIO directions. Moreover, driver should prevent
> > direction change for them, which are intended for output only.
> > 
> > While I figure out how to prevent user direction tampering, how about
> > making gpiolib know which are the initial directions?
> 
> I don't quite follow.  If you export the GPIOs to userspace using
> the (pending, to-appear-in-2.6.27) sysfs interface, you can use

I already tried it, very nifty. I used it to show my driver is working,
I could hear the relays and see the tester.. yuk!

Anyway I was too free to play with GPIOs, I would like to be able to
set limits at driver level. i.e. relay GPIOs should be output only and
no one, being another driver or user-space, should be able to change
their direction.

While I am able to enforce direction policy, I am not able to setup the
initial direction. Indeed it is set by gpiolib basing on the presence
of chip.direction_input.

cheers,
Domenico


This patch adds the gpiolib bttv sub-driver.

Every bttv card may define a set of available gpio ports which are
registered to gpiolib and then made available through kernel's generic
gpio interface.

--

State of the patch: working. RFC.

Index: v4l-dvb.git/drivers/media/video/bt8xx/Kconfig
===================================================================
--- v4l-dvb.git.orig/drivers/media/video/bt8xx/Kconfig	2008-07-14 06:33:54.000000000 +0200
+++ v4l-dvb.git/drivers/media/video/bt8xx/Kconfig	2008-07-14 06:33:58.000000000 +0200
@@ -21,6 +21,12 @@
 	  To compile this driver as a module, choose M here: the
 	  module will be called bttv.
 
+config VIDEO_BT848_GPIO
+	tristate "GPIO support for bt848 cards"
+	depends on VIDEO_BT848 && GPIOLIB
+	---help---
+	  This enables GPIOLIB bindings on BT848 boards.
+
 config VIDEO_BT848_DVB
 	bool "DVB/ATSC Support for bt878 based TV cards"
 	depends on VIDEO_BT848 && DVB_CORE
Index: v4l-dvb.git/drivers/media/video/bt8xx/Makefile
===================================================================
--- v4l-dvb.git.orig/drivers/media/video/bt8xx/Makefile	2008-07-14 06:33:54.000000000 +0200
+++ v4l-dvb.git/drivers/media/video/bt8xx/Makefile	2008-07-14 06:33:58.000000000 +0200
@@ -7,6 +7,7 @@
 		       bttv-input.o bttv-audio-hook.o
 
 obj-$(CONFIG_VIDEO_BT848) += bttv.o
+obj-$(CONFIG_VIDEO_BT848_GPIO) += bttv-gpiolib.o
 
 EXTRA_CFLAGS += -Idrivers/media/video
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
Index: v4l-dvb.git/drivers/media/video/bt8xx/bttv-cards.c
===================================================================
--- v4l-dvb.git.orig/drivers/media/video/bt8xx/bttv-cards.c	2008-07-14 06:33:54.000000000 +0200
+++ v4l-dvb.git/drivers/media/video/bt8xx/bttv-cards.c	2008-07-14 06:33:58.000000000 +0200
@@ -2162,6 +2162,7 @@
 		.gpiomask       = 0xdf,
 		.muxsel         = { 2 },
 		.pll            = PLL_28,
+		.has_gpiolib    = 1,
 	},
 	[BTTV_BOARD_XGUARD] = {
 		.name           = "Grand X-Guard / Trust 814PCI",
Index: v4l-dvb.git/drivers/media/video/bt8xx/bttv-driver.c
===================================================================
--- v4l-dvb.git.orig/drivers/media/video/bt8xx/bttv-driver.c	2008-07-14 06:33:55.000000000 +0200
+++ v4l-dvb.git/drivers/media/video/bt8xx/bttv-driver.c	2008-07-14 06:33:58.000000000 +0200
@@ -4455,6 +4455,12 @@
 		request_modules(btv);
 	}
 
+#ifdef CONFIG_VIDEO_BT848_GPIO_MODULE
+	/* add gpiolib subdevice */
+	if (bttv_tvcards[btv->c.type].has_gpiolib)
+		bttv_sub_add_device(&btv->c, "gpiolib");
+#endif
+
 	bttv_input_init(btv);
 
 	/* everything is fine */
Index: v4l-dvb.git/drivers/media/video/bt8xx/bttv-gpiolib.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ v4l-dvb.git/drivers/media/video/bt8xx/bttv-gpiolib.c	2008-07-14 08:32:01.000000000 +0200
@@ -0,0 +1,235 @@
+/*
+ * Bt8xx based GPIOLIB driver
+ *
+ * Copyright (C) 2008 Domenico Andreoli <cavok@dandreoli.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+
+#include <asm/gpio.h>
+
+#include "bttvp.h"
+
+struct bttv_gpiolib_device {
+	struct bttv_sub_device *sub;
+	struct gpio_chip chip;
+
+	u32 in_mask;
+	u32 out_mask;
+	u32 out;
+};
+
+static u32 nr_to_mask(struct bttv_gpiolib_device *dev, unsigned nr)
+{
+	u32 io_mask = dev->in_mask | dev->out_mask;
+	int shift = 0;
+
+	while(io_mask && nr) {
+		nr -= io_mask & 1;
+		io_mask >>= 1;
+		shift++;
+	}
+
+	return 1 << shift;
+}
+
+static void bttv_gpiolib_inout(struct bttv_core *core, u32 mask, u32 outbits, u32 outvals)
+{
+	struct bttv *btv = container_of(core, struct bttv, c);
+	unsigned long flags;
+	u32 data;
+
+	spin_lock_irqsave(&btv->gpio_lock, flags);
+
+	/* set direction */
+	data = btread(BT848_GPIO_OUT_EN);
+	data &= ~mask;
+	data |= mask & outbits;
+	btwrite(data, BT848_GPIO_OUT_EN);
+
+	mask &= outbits;
+	if(mask) {
+		/* set output values */
+		data = btread(BT848_GPIO_DATA);
+		data &= ~mask;
+		data |= mask & outvals;
+		btwrite(data, BT848_GPIO_DATA);
+	}
+
+	spin_unlock_irqrestore(&btv->gpio_lock, flags);
+}
+
+static int bttv_gpiolib_direction_input(struct gpio_chip *gpio, unsigned nr)
+{
+	struct bttv_gpiolib_device *dev = container_of(gpio, struct bttv_gpiolib_device, chip);
+	u32 mask = nr_to_mask(dev, nr);
+
+	if(!(mask & dev->in_mask))
+		return -EPERM;
+
+	bttv_gpiolib_inout(dev->sub->core, mask, 0, 0);
+	return 0;
+}
+
+static int bttv_gpiolib_direction_output(struct gpio_chip *gpio, unsigned nr, int val)
+{
+	struct bttv_gpiolib_device *dev = container_of(gpio, struct bttv_gpiolib_device, chip);
+	u32 mask = nr_to_mask(dev, nr);
+
+	if(!(mask & dev->out_mask))
+		return -EPERM;
+
+	bttv_gpiolib_inout(dev->sub->core, mask, mask, val ? mask : 0);
+	return 0;
+}
+
+static int bttv_gpiolib_get(struct gpio_chip *gpio, unsigned nr)
+{
+	u32 data;
+	unsigned long flags;
+	struct bttv_gpiolib_device *dev = container_of(gpio, struct bttv_gpiolib_device, chip);
+	struct bttv *btv = container_of(dev->sub->core, struct bttv, c);
+
+	spin_lock_irqsave(&btv->gpio_lock, flags);
+	data = btread(BT848_GPIO_DATA);
+	spin_unlock_irqrestore(&btv->gpio_lock, flags);
+
+	return !!(data & nr_to_mask(dev, nr));
+}
+
+static void bttv_gpiolib_set(struct gpio_chip *gpio, unsigned nr, int val)
+{
+	u32 data;
+	unsigned long flags;
+	struct bttv_gpiolib_device *dev = container_of(gpio, struct bttv_gpiolib_device, chip);
+	struct bttv *btv = container_of(dev->sub->core, struct bttv, c);
+	u32 mask = nr_to_mask(dev, nr);
+
+	spin_lock_irqsave(&btv->gpio_lock, flags);
+	data = btread(BT848_GPIO_DATA);
+	data &= ~mask;
+	data |= val ? mask : 0;
+	btwrite(data, BT848_GPIO_DATA);
+	spin_unlock_irqrestore(&btv->gpio_lock, flags);
+}
+
+static int bttv_gpiolib_setup(unsigned int type, struct bttv_gpiolib_device *dev)
+{
+	switch(type) {
+		case BTTV_BOARD_IVC200:
+			dev->in_mask  = 0x0f;
+			dev->out_mask = 0xff;
+			break;
+
+		default:
+			printk(KERN_ERR "card type %d: missing gpiolib configuration\n", type);
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __devinit bttv_gpiolib_probe(struct bttv_sub_device *sub)
+{
+	struct bttv_gpiolib_device *dev;
+	u32 io_mask;
+	int ret;
+
+	dev = kzalloc(sizeof(struct bttv_gpiolib_device), GFP_KERNEL);
+	if(!dev)
+		return -ENOMEM;
+
+	ret = bttv_gpiolib_setup(sub->core->type, dev);
+	if(ret) {
+		kfree(dev);
+		return ret;
+	}
+
+	io_mask = dev->in_mask | dev->out_mask;
+	if(!io_mask) {
+		printk(KERN_ERR "card type %d: missing GPIOs configuration\n", sub->core->type);
+		kfree(dev);
+		return -EINVAL;
+	}
+
+	/* set direction and output values */
+	bttv_gpiolib_inout(sub->core, io_mask, dev->out_mask, dev->out);
+
+	while(io_mask) {
+		dev->chip.ngpio++;
+		io_mask >>= 1;
+	}
+
+	dev->sub = sub;
+	dev->chip.label = sub->dev.bus_id;
+	dev->chip.owner = THIS_MODULE;
+
+	dev->chip.base = -1;
+	dev->chip.direction_input = bttv_gpiolib_direction_input;
+	dev->chip.direction_output = bttv_gpiolib_direction_output;
+	dev->chip.get = bttv_gpiolib_get;
+	dev->chip.set = bttv_gpiolib_set;
+
+	ret = gpiochip_add(&dev->chip);
+	if(ret) {
+		printk(KERN_ERR "error adding gpio chip %s: %d\n", dev->chip.label, ret);
+		kfree(dev);
+		return ret;
+	}
+
+	dev_set_drvdata(&sub->dev, dev);
+	return 0;
+}
+
+static void __devexit bttv_gpiolib_remove(struct bttv_sub_device *sub)
+{
+	struct bttv_gpiolib_device *dev = dev_get_drvdata(&sub->dev);
+	int ret;
+
+	ret = gpiochip_remove(&dev->chip);
+	if(ret)
+		printk(KERN_ERR "error removing gpio chip %s: %d). leaking memory...\n", dev->chip.label, ret);
+	else
+		kfree(dev);
+}
+
+static struct bttv_sub_driver driver = {
+	.drv = {
+		.name		= "bttv-gpiolib",
+	},
+	.probe		= bttv_gpiolib_probe,
+	.remove		= bttv_gpiolib_remove,
+};
+
+static int __init bttv_gpiolib_init(void)
+{
+	return bttv_sub_register(&driver, "gpiolib");
+}
+
+static void __exit bttv_gpiolib_exit(void)
+{
+	bttv_sub_unregister(&driver);
+}
+
+module_init(bttv_gpiolib_init);
+module_exit(bttv_gpiolib_exit);
+
+MODULE_DESCRIPTION("Bt8xx based GPIOLIB driver");
+MODULE_AUTHOR("Domenico Andreoli <cavok@dandreoli.com>");
+MODULE_LICENSE("GPL");
Index: v4l-dvb.git/drivers/media/video/bt8xx/bttv.h
===================================================================
--- v4l-dvb.git.orig/drivers/media/video/bt8xx/bttv.h	2008-07-14 06:33:54.000000000 +0200
+++ v4l-dvb.git/drivers/media/video/bt8xx/bttv.h	2008-07-14 06:33:58.000000000 +0200
@@ -249,6 +249,8 @@
 	void (*audio_mode_gpio)(struct bttv *btv, struct v4l2_tuner *tuner, int set);
 
 	void (*muxsel_hook)(struct bttv *btv, unsigned int input);
+
+	bool has_gpiolib;
 };
 
 extern struct tvcard bttv_tvcards[];


-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
