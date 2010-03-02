Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:37156 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944Ab0CBXmo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Mar 2010 18:42:44 -0500
Message-ID: <4B8DA270.1050301@freemail.hu>
Date: Wed, 03 Mar 2010 00:42:40 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [RFC, PATCH 2/3] gspca pac7302: separate LED handling
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

On Labtec Webcam 2200 there is a feedback LED which can be controlled
independent from the streaming. The feedback LED can be used from
user space application to show for example detected motion or to
distinguish between the preview and "on-air" state of the video stream.

The default value of the LED control is "Auto" which keeps the previous
behaviour: LED is off when the stream is off, LED is on if the stream is
on.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r d8fafa7d88dc linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	Thu Feb 18 19:02:51 2010 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	Wed Mar 03 00:10:19 2010 +0100
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
@@ -81,6 +85,10 @@
 /* specific webcam descriptor for pac7302 */
 struct sd {
 	struct gspca_dev gspca_dev;		/* !! must be the first item */
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	struct gspca_led feedback_led;
+	struct work_struct led_work;
+#endif

 	unsigned char brightness;
 	unsigned char contrast;
@@ -91,6 +99,7 @@
 	unsigned char gain;
 	unsigned char exposure;
 	unsigned char autogain;
+	unsigned char led;
 	__u8 hflip;
 	__u8 vflip;
 	u8 flags;
@@ -126,6 +135,7 @@
 static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);
+static void set_streaming_led(struct gspca_dev *gspca_dev, u8 streaming);

 static const struct ctrl sd_ctrls[] = {
 /* This control is pac7302 only */
@@ -550,6 +560,39 @@
 	/* not reached */
 }

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
+		    enum led_brightness brightness)
+{
+	u8 new_brightness;
+	struct gspca_led *led = container_of(led_cdev, struct gspca_led, led_cdev);
+	struct gspca_dev *gspca_dev = led->parent;
+	struct sd *sd = container_of(gspca_dev, struct sd, gspca_dev);
+
+	if (brightness == LED_OFF)
+		new_brightness = 0;
+	else
+		new_brightness = 1;
+
+	if (sd->led != new_brightness && gspca_dev->present) {
+		sd->led = new_brightness;
+		schedule_work(&sd->led_work);
+	}
+}
+#endif
+
 /* this function is called at probe time for pac7302 */
 static int sd_config(struct gspca_dev *gspca_dev,
 			const struct usb_device_id *id)
@@ -563,6 +606,20 @@
 	cam->cam_mode = vga_mode;	/* only 640x480 */
 	cam->nmodes = ARRAY_SIZE(vga_mode);

+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	INIT_WORK(&sd->led_work, led_work);
+	strncpy(sd->feedback_led.name, "video%d::feedback",
+		sizeof(sd->feedback_led.name));
+#ifdef CONFIG_LEDS_TRIGGERS
+	strncpy(sd->feedback_led.trigger_name, "video%d",
+		sizeof(sd->feedback_led.trigger_name));
+#endif
+	sd->feedback_led.led_cdev.brightness_set = led_set;
+	sd->feedback_led.parent = gspca_dev;
+	cam->leds = &sd->feedback_led;
+	cam->nleds = 1;
+#endif
+
 	sd->brightness = BRIGHTNESS_DEF;
 	sd->contrast = CONTRAST_DEF;
 	sd->colors = COLOR_DEF;
@@ -572,6 +629,7 @@
 	sd->gain = GAIN_DEF;
 	sd->exposure = EXPOSURE_DEF;
 	sd->autogain = AUTOGAIN_DEF;
+	sd->led = 0;
 	sd->hflip = HFLIP_DEF;
 	sd->vflip = VFLIP_DEF;
 	sd->flags = id->driver_info;
@@ -716,6 +774,27 @@
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
 /* this function is called at probe and resume time for pac7302 */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
@@ -747,27 +826,60 @@
 	atomic_set(&sd->avg_lum, -1);

 	/* start stream */
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x01);
+
+#if (defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)) && defined(CONFIG_LEDS_TRIGGERS)
+	led_trigger_event(&sd->feedback_led.led_trigger, LED_FULL);
+#elif defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	sd->feedback_led.led_cdev.brightness = sd->feedback_led.led_cdev.max_brightness;
+	if (!(sd->feedback_led.led_cdev.flags & LED_SUSPENDED))
+		sd->feedback_led.led_cdev.brightness_set(&sd->led_cdev,
+				sd->feedback_led.led_cdev.brightness);
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
+	led_trigger_event(&sd->feedback_led.led_trigger, LED_OFF);
+#elif defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	sd->feedback_led.led_cdev.brightness = LED_OFF;
+	if (!(sd->feedback_led.led_cdev.flags & LED_SUSPENDED))
+		sd->feedback_led.led_cdev.brightness_set(&sd->led_cdev,
+				sd->feedback_led.led_cdev.brightness);
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
+	led_trigger_event(&sd->feedback_led.led_trigger, LED_OFF);
+#elif defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	sd->feedback_led.led_cdev.brightness = LED_OFF;
+	if (!(sd->feedback_led.led_cdev.flags & LED_SUSPENDED))
+		sd->feedback_led.led_cdev.brightness_set(&sd->led_cdev,
+				sd->feedback_led.led_cdev.brightness);
+#endif
 }

 /* Include pac common sof detection functions */
@@ -1243,11 +1355,28 @@
 				THIS_MODULE);
 }

+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+static void sd_disconnect(struct usb_interface *intf)
+{
+	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
+	struct sd *sd = container_of(gspca_dev, struct sd, gspca_dev);
+
+	mutex_lock(&gspca_dev->usb_lock);
+	gspca_dev->present = 0;
+	mutex_unlock(&gspca_dev->usb_lock);
+
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
