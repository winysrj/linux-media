Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:37113 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915Ab0CBXm3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Mar 2010 18:42:29 -0500
Message-ID: <4B8DA25F.10602@freemail.hu>
Date: Wed, 03 Mar 2010 00:42:23 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [RFC, PATCH 1/3] gspca: add LEDs subsystem connection
References: <4B8A2158.6020701@freemail.hu>	<20100228202801.6986cb19@tele>	<4B8AC618.80200@freemail.hu> <20100301101806.7c7986be@tele>
In-Reply-To: <20100301101806.7c7986be@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

On some webcams one or more LEDs can be found. One type of these LEDs
are feedback LEDs: they usually shows the state of streaming mode.
The LED can be programmed to constantly switched off state (e.g. for
power saving reasons, preview mode) or on state (e.g. the application
shows motion detection or "on-air").

The second type of LEDs are used to create enough light for the sensor
for example visible or in infra-red light.

Both type of these LEDs can be handled using the LEDs subsystem. This
patch add support to connect a gspca based driver to the LEDs subsystem.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r d8fafa7d88dc linux/drivers/media/video/gspca/gspca.h
--- a/linux/drivers/media/video/gspca/gspca.h	Thu Feb 18 19:02:51 2010 +0100
+++ b/linux/drivers/media/video/gspca/gspca.h	Wed Mar 03 00:10:19 2010 +0100
@@ -7,6 +7,8 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <linux/mutex.h>
+#include <linux/leds.h>
+#include <linux/workqueue.h>
 #include "compat.h"

 /* compilation option */
@@ -53,14 +55,41 @@
 	int nrates;
 };

+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+/**
+ * struct gspca_led - data structure for one LED on a camera
+ * @led_cdev: the class device for the LED
+ * @name: place for the LED name which will appear under /sys/class/leds/
+ * @led_trigger: the trigger structure for the same LED
+ * @trigger_name: place for the trigger name which will appear in the file
+ *                /sys/class/leds/{led name}/trigger
+ * @parent: pointer to the parent gspca_dev
+ */
+struct gspca_led {
+	struct led_classdev led_cdev;
+	char name[32];
+#ifdef CONFIG_LEDS_TRIGGERS
+	struct led_trigger led_trigger;
+	char trigger_name[32];
+#endif
+	struct gspca_dev *parent;
+};
+#endif
+
 /* device information - set at probe time */
 struct cam {
 	const struct v4l2_pix_format *cam_mode;	/* size nmodes */
 	const struct framerates *mode_framerates; /* must have size nmode,
 						   * just like cam_mode */
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	struct gspca_led *leds;
+#endif
 	u32 bulk_size;		/* buffer size when image transfer by bulk */
 	u32 input_flags;	/* value for ENUM_INPUT status flags */
 	u8 nmodes;		/* size of cam_mode */
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	u8 nleds;		/* number of LEDs */
+#endif
 	u8 no_urb_create;	/* don't create transfer URBs */
 	u8 bulk_nurbs;		/* number of URBs in bulk mode
 				 * - cannot be > MAX_NURBS
diff -r d8fafa7d88dc linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Thu Feb 18 19:02:51 2010 +0100
+++ b/linux/drivers/media/video/gspca/gspca.c	Wed Mar 03 00:10:19 2010 +0100
@@ -4,6 +4,7 @@
  * Copyright (C) 2008-2009 Jean-Francois Moine (http://moinejf.free.fr)
  *
  * Camera button input handling by Márton Németh
+ * LED subsystem connection by Márton Németh
  * Copyright (C) 2009-2010 Márton Németh <nm127@freemail.hu>
  *
  * This program is free software; you can redistribute it and/or modify it
@@ -2256,6 +2257,76 @@
 	.release = gspca_release,
 };

+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+/**
+ * gspca_create_name() - Create a name using format string and a number
+ * @name: format string on input, e.g. "video%d::feedback". The format string
+ *        may contain one and only one %d format specifier. The created name
+ *        will be put on the same location and the original format string will
+ *        be overwritten.
+ * @length: the length of the buffer in bytes pointed by the name parameter
+ * @num: the number to use when creating the name
+ *
+ * Returns zero on success.
+ */
+static int gspca_create_name(char *name, unsigned int length, int num)
+{
+	char buffer[32];
+	unsigned int l;
+
+	/* TODO: check format string: it shall contain one and only one %d */
+
+	l = min(length, sizeof(buffer));
+	snprintf(buffer, l, name, num);
+	strlcpy(name, buffer, l);
+
+	return 0;
+}
+
+static void gspca_leds_register(struct gspca_dev *gspca_dev) {
+	int i;
+	int ret;
+
+	for (i = 0; i < gspca_dev->cam.nleds; i++) {
+#ifdef CONFIG_LEDS_TRIGGERS
+		gspca_create_name(gspca_dev->cam.leds[i].trigger_name,
+				  sizeof(gspca_dev->cam.leds[i].trigger_name),
+				  gspca_dev->vdev.num);
+		gspca_dev->cam.leds[i].led_trigger.name = gspca_dev->cam.leds[i].trigger_name;
+		gspca_dev->cam.leds[i].led_cdev.default_trigger = gspca_dev->cam.leds[i].trigger_name;
+#endif
+		gspca_create_name(gspca_dev->cam.leds[i].name,
+				  sizeof(gspca_dev->cam.leds[i].name),
+				  gspca_dev->vdev.num);
+
+		gspca_dev->cam.leds[i].led_cdev.name = gspca_dev->cam.leds[i].name;
+		gspca_dev->cam.leds[i].led_cdev.blink_set = NULL;
+		gspca_dev->cam.leds[i].led_cdev.flags = LED_CORE_SUSPENDRESUME;
+		ret = led_classdev_register(&gspca_dev->dev->dev,
+					    &gspca_dev->cam.leds[i].led_cdev);
+		if (!ret) {
+#ifdef CONFIG_LEDS_TRIGGERS
+			led_trigger_register(&gspca_dev->cam.leds[i].led_trigger);
+#endif
+		}
+	}
+}
+
+static void gspca_leds_unregister(struct gspca_dev *gspca_dev)
+{
+	int i;
+	for (i = 0; i < gspca_dev->cam.nleds; i++) {
+#ifdef CONFIG_LEDS_TRIGGERS
+		led_trigger_unregister(&gspca_dev->cam.leds[i].led_trigger);
+#endif
+		led_classdev_unregister(&gspca_dev->cam.leds[i].led_cdev);
+	}
+}
+#else
+#define gspca_leds_register(gspca_dev)
+#define gspca_leds_disconnect(gspca_dev)
+#endif
+
 /*
  * probe and create a new gspca device
  *
@@ -2342,6 +2413,8 @@
 	if (ret == 0)
 		ret = gspca_input_create_urb(gspca_dev);

+	gspca_leds_register(gspca_dev);
+
 	return 0;
 out:
 	kfree(gspca_dev->usb_buf);
@@ -2386,6 +2459,8 @@
 	gspca_dev->dev = NULL;
 	mutex_unlock(&gspca_dev->usb_lock);

+	gspca_leds_unregister(gspca_dev);
+
 	usb_set_intfdata(intf, NULL);

 	/* release the device */
