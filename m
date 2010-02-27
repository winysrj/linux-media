Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:45782 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967911Ab0B0IRI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 03:17:08 -0500
Message-ID: <4B88D4FF.1000700@freemail.hu>
Date: Sat, 27 Feb 2010 09:17:03 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Richard Purdie <rpurdie@rpsys.net>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] gspca pac7302: allow controlling LED separately
References: <4B84CC9E.4030600@freemail.hu> <20100224082238.53c8f6f8@tele> <4B886566.8000600@freemail.hu>
In-Reply-To: <4B886566.8000600@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I missed the CONFIG_LEDS_CLASS_MODULE configuration option in the previous
version of this patch, now it is added.

Regards,

	Márton Németh
---
From: Márton Németh <nm127@freemail.hu>

On Labtec Webcam 2200 there is a feedback LED which can be controlled
independent from the streaming. The feedback LED can be used from
user space application to show for example detected motion or to
distinguish between the preview and "on-air" state of the video stream.

The default value of the LED trigger keeps the previous behaviour:
LED is off when the stream is off, LED is on if the stream is on.

The code is working in the following three cases:
 (1) when the LED subsystem ins not configured at all;
 (2) when the LED subsystem is available, but the LED triggers are not available and
 (3) when both the LED subsystem and LED triggers are configured.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r d8fafa7d88dc linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	Thu Feb 18 19:02:51 2010 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	Sat Feb 27 09:10:44 2010 +0100
@@ -6,6 +6,7 @@
  *
  * Separated from Pixart PAC7311 library by Márton Németh
  * Camera button input handling by Márton Németh <nm127@freemail.hu>
+ * LED control by Márton Németh <nm127@freemail.hu>
  * Copyright (C) 2009-2010 Márton Németh <nm127@freemail.hu>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -62,6 +63,7 @@
     0   | 0xc6       | setwhitebalance()
     0   | 0xc7       | setbluebalance()
     0   | 0xdc       | setbrightcont(), setcolors()
+    1   | 0x78       | set_streaming_led()
     3   | 0x02       | setexposure()
     3   | 0x10       | setgain()
     3   | 0x11       | setcolors(), setgain(), setexposure(), sethvflip()
@@ -72,6 +74,8 @@

 #include <linux/input.h>
 #include <media/v4l2-chip-ident.h>
+#include <linux/leds.h>
+#include <linux/workqueue.h>
 #include "gspca.h"

 MODULE_AUTHOR("Thomas Kaiser thomas@kaiser-linux.li");
@@ -91,6 +95,7 @@
 	unsigned char gain;
 	unsigned char exposure;
 	unsigned char autogain;
+	unsigned char led;
 	__u8 hflip;
 	__u8 vflip;
 	u8 flags;
@@ -101,6 +106,16 @@
 	u8 autogain_ignore_frames;

 	atomic_t avg_lum;
+
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	struct led_classdev led_cdev;
+	struct work_struct led_work;
+	char name[32];
+#ifdef CONFIG_LEDS_TRIGGERS
+	struct led_trigger led_trigger;
+	char trigger_name[32];
+#endif
+#endif
 };

 /* V4L2 controls supported by the driver */
@@ -572,6 +587,7 @@
 	sd->gain = GAIN_DEF;
 	sd->exposure = EXPOSURE_DEF;
 	sd->autogain = AUTOGAIN_DEF;
+	sd->led = 0;
 	sd->hflip = HFLIP_DEF;
 	sd->vflip = VFLIP_DEF;
 	sd->flags = id->driver_info;
@@ -716,6 +732,58 @@
 	reg_w(gspca_dev, 0x11, 0x01);
 }

+static void set_streaming_led(struct gspca_dev *gspca_dev, u8 streaming)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 data = 0;
+
+	if (sd->led) {
+		if (streaming)
+			data = 0x01;
+		else
+			data = 0x00;
+	} else {
+		if (streaming)
+			data = 0x41;
+		else
+			data = 0x40;
+	}
+
+	reg_w(gspca_dev, 0xff, 0x01);
+	reg_w(gspca_dev, 0x78, data);
+}
+
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+/* Set the LED, may sleep */
+static void led_work(struct work_struct *work)
+{
+	struct sd *sd = container_of(work, struct sd, led_work);
+	struct gspca_dev *gspca_dev = &sd->gspca_dev;
+
+	mutex_lock(&gspca_dev->usb_lock);
+	set_streaming_led(gspca_dev, gspca_dev->streaming);
+	mutex_unlock(&gspca_dev->usb_lock);
+}
+
+/* LED state set request, must not sleep */
+static void led_set(struct led_classdev *led_cdev,
+		    enum led_brightness value)
+{
+	u8 new_value;
+	struct sd *sd = container_of(led_cdev, struct sd, led_cdev);
+
+	if (value == LED_OFF)
+		new_value = 0;
+	else
+		new_value = 1;
+
+	if (sd->led != new_value) {
+		sd->led = new_value;
+		schedule_work(&sd->led_work);
+	}
+}
+#endif
+
 /* this function is called at probe and resume time for pac7302 */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
@@ -747,27 +815,60 @@
 	atomic_set(&sd->avg_lum, -1);

 	/* start stream */
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x01);
+
+#if (defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)) && defined(CONFIG_LEDS_TRIGGERS)
+	led_trigger_event(&sd->led_trigger, LED_FULL);
+#elif defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	sd->led_cdev.brightness = sd->led_cdev.max_brightness;
+	if (!(sd->led_cdev.flags & LED_SUSPENDED))
+		sd->led_cdev.brightness_set(&sd->led_cdev,
+				sd->led_cdev.brightness);
+#else
+	sd->led = 1;
+#endif
+	set_streaming_led(gspca_dev, 1);

 	return gspca_dev->usb_err;
 }

 static void sd_stopN(struct gspca_dev *gspca_dev)
 {
+	struct sd *sd = container_of(gspca_dev, struct sd, gspca_dev);

+#if !defined(CONFIG_LEDS_CLASS) && !defined(CONFIG_LEDS_CLASS_MODULE)
+	sd->led = 0;
+#endif
 	/* stop stream */
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x00);
+	set_streaming_led(gspca_dev, 0);
+#if (defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)) && defined(CONFIG_LEDS_TRIGGERS)
+	led_trigger_event(&sd->led_trigger, LED_OFF);
+#elif defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	sd->led_cdev.brightness = LED_OFF;
+	if (!(sd->led_cdev.flags & LED_SUSPENDED))
+		sd->led_cdev.brightness_set(&sd->led_cdev,
+				sd->led_cdev.brightness);
+#endif
 }

 /* called on streamoff with alt 0 and on disconnect for pac7302 */
 static void sd_stop0(struct gspca_dev *gspca_dev)
 {
+	struct sd *sd = container_of(gspca_dev, struct sd, gspca_dev);
+
 	if (!gspca_dev->present)
 		return;
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x40);
+#if !defined(CONFIG_LEDS_CLASS) && !defined(CONFIG_LEDS_CLASS_MODULE)
+	sd->led = 0;
+#endif
+	set_streaming_led(gspca_dev, 0);
+#if (defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)) && defined(CONFIG_LEDS_TRIGGERS)
+	led_trigger_event(&sd->led_trigger, LED_OFF);
+#elif defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	sd->led_cdev.brightness = LED_OFF;
+	if (!(sd->led_cdev.flags & LED_SUSPENDED))
+		sd->led_cdev.brightness_set(&sd->led_cdev,
+				sd->led_cdev.brightness);
+#endif
 }

 /* Include pac common sof detection functions */
@@ -1239,15 +1340,65 @@
 static int __devinit sd_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
-	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
+	int ret;
+
+	ret = gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
 				THIS_MODULE);
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	if (ret == 0) {
+		struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
+		struct sd *sd = container_of(gspca_dev, struct sd, gspca_dev);
+
+#ifdef CONFIG_LEDS_TRIGGERS
+		snprintf(sd->trigger_name, sizeof(sd->trigger_name),
+			"pac7302-%u", gspca_dev->vdev.num);
+		sd->led_trigger.name = sd->trigger_name;
+		sd->led_cdev.default_trigger = sd->trigger_name;
+#endif
+		snprintf(sd->name, sizeof(sd->name),
+			"pac7302-%u::camera", gspca_dev->vdev.num);
+		sd->led_cdev.name = sd->name;
+		sd->led_cdev.brightness_set = led_set;
+		sd->led_cdev.blink_set = NULL;
+		sd->led_cdev.flags = LED_CORE_SUSPENDRESUME;
+		INIT_WORK(&sd->led_work, led_work);
+		ret = led_classdev_register(&gspca_dev->dev->dev,
+					    &sd->led_cdev);
+		if (ret)
+			gspca_disconnect(intf);
+		else {
+#ifdef CONFIG_LEDS_TRIGGERS
+			led_trigger_register(&sd->led_trigger);
+#endif
+		}
+	}
+#endif
+
+	return ret;
 }

+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+static void sd_disconnect(struct usb_interface *intf)
+{
+	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
+	struct sd *sd = container_of(gspca_dev, struct sd, gspca_dev);
+
+#ifdef CONFIG_LEDS_TRIGGERS
+	led_trigger_unregister(&sd->led_trigger);
+#endif
+	led_classdev_unregister(&sd->led_cdev);
+	cancel_work_sync(&sd->led_work);
+	gspca_disconnect(intf);
+}
+#else
+#define sd_disconnect gspca_disconnect
+#endif
+
 static struct usb_driver sd_driver = {
 	.name = MODULE_NAME,
 	.id_table = device_table,
 	.probe = sd_probe,
-	.disconnect = gspca_disconnect,
+	.disconnect = sd_disconnect,
 #ifdef CONFIG_PM
 	.suspend = gspca_suspend,
 	.resume = gspca_resume,

