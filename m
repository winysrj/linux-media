Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6DGGeLR022685
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 12:16:41 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6DGGDGm031395
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 12:16:24 -0400
Received: by ug-out-1314.google.com with SMTP id s2so146002uge.6
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 09:16:12 -0700 (PDT)
Resent-Message-ID: <20080713161623.GA32391@ska.dandreoli.com>
Date: Sun, 13 Jul 2008 17:43:33 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Message-ID: <20080713154333.GA32133@ska.dandreoli.com>
References: <200807101914.10174.mb@bu3sch.de> <20080710160258.4ddb5c61@gaivota>
	<20080713004248.GA12648@ska.dandreoli.com>
	<200807131215.12082.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807131215.12082.mb@bu3sch.de>
Cc: David Brownell <david-b@pacbell.net>, video4linux-list@redhat.com,
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

On Sun, Jul 13, 2008 at 12:15:11PM +0200, Michael Buesch wrote:
> On Sunday 13 July 2008 02:42:48 Domenico Andreoli wrote:
> > On Thu, Jul 10, 2008 at 04:02:58PM -0300, Mauro Carvalho Chehab wrote:
> > > 
> > > However, a much better alternative would be if you can rework on it to be a
> > > module that adds this functionality to the original driver, allowing to have
> > > both video control and gpio control, since, on a few cases like surveillance
> > > systems, the gpio's may be used for other things, like controlling security
> > > sensors, or switching a video commutter.
> > 
> > I need this. Is anybody working on it? If nobody is, I step forward.
> 
> Feel free to do so. I didn't want to go down the road to change bttv, as I don't
> need the bttv functionality (the card doesn't work as TV card anymore).

Here is a first incomplete patch I would like to discuss.

> So if you do that, please make sure that:
> - The driver can be loaded on cards that don't work as TV cards anymore.
>   I removed the tuner and other stuff from the card. I also detached all GPIO
>   pins. So the original bttv will get confused when trying to initialize it.
>   So there must be a way to load the bttv driver in "gpio-only" mode then.
> - In the gpio-only mode it must be possible to access _all_ GPIO pins, including
>   those that were originally used by the card itself.

Something respecting these conditions clearly conflicts with bttv
and looks like your bt8xxgpio driver. Indeed I do not see the need of
dropping it.

Currently my patch requires the bttv functionality, since it is done
to work toghether with bttv. Surely one must be able to use bttv only,
without gpiolib.

The definition of bttv_gpiolib_card[] in bttv-gpiolib.c stinks, it's aim
is to easily allow people to add their favourite card gpio configuration,
but I am pretty sure its initialization is completely wrong. Please
give me some suggestion.

cheers,
Domenico


This patch adds the gpiolib bttv sub-driver.

Every bttv card may define a set of available gpio ports which are
registered to gpiolib and then made available through kernel's generic
gpio interface.

--

State of the patch: unusable. RFC

Index: v4l-dvb.git/drivers/media/video/bt8xx/Kconfig
===================================================================
--- v4l-dvb.git.orig/drivers/media/video/bt8xx/Kconfig	2008-07-13 15:52:08.000000000 +0200
+++ v4l-dvb.git/drivers/media/video/bt8xx/Kconfig	2008-07-13 17:11:02.000000000 +0200
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
--- v4l-dvb.git.orig/drivers/media/video/bt8xx/Makefile	2008-07-13 15:52:08.000000000 +0200
+++ v4l-dvb.git/drivers/media/video/bt8xx/Makefile	2008-07-13 17:11:27.000000000 +0200
@@ -6,7 +6,11 @@
 		       bttv-risc.o bttv-vbi.o bttv-i2c.o bttv-gpio.o \
 		       bttv-input.o bttv-audio-hook.o
 
+#ifeq ($(CONFIG_VIDEO_BT848_GPIO),y)
+#endif
+
 obj-$(CONFIG_VIDEO_BT848) += bttv.o
+obj-$(CONFIG_VIDEO_BT848_GPIO) += bttv-gpiolib.o
 
 EXTRA_CFLAGS += -Idrivers/media/video
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
Index: v4l-dvb.git/drivers/media/video/bt8xx/bttv-cards.c
===================================================================
--- v4l-dvb.git.orig/drivers/media/video/bt8xx/bttv-cards.c	2008-07-13 15:52:08.000000000 +0200
+++ v4l-dvb.git/drivers/media/video/bt8xx/bttv-cards.c	2008-07-13 16:53:59.000000000 +0200
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
--- v4l-dvb.git.orig/drivers/media/video/bt8xx/bttv-driver.c	2008-07-13 15:52:08.000000000 +0200
+++ v4l-dvb.git/drivers/media/video/bt8xx/bttv-driver.c	2008-07-13 15:52:15.000000000 +0200
@@ -4455,6 +4455,10 @@
 		request_modules(btv);
 	}
 
+	/* add gpiolib subdevice */
+	if (bttv_tvcards[btv->c.type].has_gpiolib)
+		bttv_sub_add_device(&btv->c, "gpiolib");
+
 	bttv_input_init(btv);
 
 	/* everything is fine */
Index: v4l-dvb.git/drivers/media/video/bt8xx/bttv-gpiolib.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ v4l-dvb.git/drivers/media/video/bt8xx/bttv-gpiolib.c	2008-07-13 17:23:56.000000000 +0200
@@ -0,0 +1,153 @@
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
+static struct bttv_gpiolib_card {
+	unsigned int has_gpiolib:1;
+	u16 ngpio;
+	int gpiobase;
+} bttv_gpiolib_cards[] = {
+	[BTTV_BOARD_IVC200] = {
+		.has_gpiolib    = 1,
+		.ngpio          = 24,
+		.gpiobase       = -1,
+	},
+};
+
+struct bttv_gpiolib_device {
+	struct bttv_sub_device *sub;
+	struct gpio_chip chip;
+};
+
+#define gpio_to_btv(gpio)   container_of(\
+                              container_of(gpio, struct bttv_gpiolib_device, chip)->sub->core, \
+                                struct bttv, c);
+
+static int bttv_gpiolib_direction_input(struct gpio_chip *gpio, unsigned nr)
+{
+	struct bttv *btv = gpio_to_btv(gpio);
+
+	// TODO
+
+	return 0;
+}
+
+static int bttv_gpiolib_get(struct gpio_chip *gpio, unsigned nr)
+{
+	struct bttv *btv = gpio_to_btv(gpio);
+
+	// TODO
+
+	return 0;
+}
+
+static int bttv_gpiolib_direction_output(struct gpio_chip *gpio, unsigned nr, int val)
+{
+	struct bttv *btv = gpio_to_btv(gpio);
+
+	// TODO
+
+	return 0;
+}
+
+static void bttv_gpiolib_set(struct gpio_chip *gpio, unsigned nr, int val)
+{
+	struct bttv *btv = gpio_to_btv(gpio);
+
+	// TODO
+}
+
+static int __devinit bttv_gpiolib_probe(struct bttv_sub_device *sub)
+{
+	int ret;
+	struct bttv_gpiolib_device *device;
+
+	if(!(device = kzalloc(sizeof(struct bttv_gpiolib_device), GFP_KERNEL)))
+		return -ENOMEM;
+
+	device->sub = sub;
+	device->chip.label = sub->dev.bus_id;
+	device->chip.owner = THIS_MODULE;
+
+	device->chip.ngpio = bttv_gpiolib_cards[sub->core->type].ngpio;
+	device->chip.base = bttv_gpiolib_cards[sub->core->type].gpiobase;
+
+	device->chip.direction_input = bttv_gpiolib_direction_input;
+	device->chip.direction_output = bttv_gpiolib_direction_output;
+	device->chip.get = bttv_gpiolib_get;
+	device->chip.set = bttv_gpiolib_set;
+
+	device->chip.dbg_show = NULL;
+	device->chip.can_sleep = 0;
+
+	ret = gpiochip_add(&device->chip);
+	if(ret) {
+		kfree(device);
+		return ret;
+	}
+
+	dev_set_drvdata(&sub->dev, device);
+	return 0;
+}
+
+static void __devexit bttv_gpiolib_remove(struct bttv_sub_device *sub)
+{
+	int ret;
+	struct bttv_gpiolib_device *device = dev_get_drvdata(&sub->dev);
+
+	while((ret = gpiochip_remove(&device->chip)) != 0) {
+		printk(KERN_INFO "error unregistering chip %s: %d\n", device->chip.label, ret);
+		schedule();
+	}
+
+	kfree(device);
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
--- v4l-dvb.git.orig/drivers/media/video/bt8xx/bttv.h	2008-07-13 15:52:08.000000000 +0200
+++ v4l-dvb.git/drivers/media/video/bt8xx/bttv.h	2008-07-13 16:53:42.000000000 +0200
@@ -249,6 +249,8 @@
 	void (*audio_mode_gpio)(struct bttv *btv, struct v4l2_tuner *tuner, int set);
 
 	void (*muxsel_hook)(struct bttv *btv, unsigned int input);
+
+	unsigned int has_gpiolib:1;
 };
 
 extern struct tvcard bttv_tvcards[];


-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
