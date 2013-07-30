Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:55457 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608Ab3G3XKE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 19:10:04 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH 2/5] [media] rc: add feedback led trigger for rc keypresses
Date: Wed, 31 Jul 2013 00:00:01 +0100
Message-Id: <1375225204-5082-2-git-send-email-sean@mess.org>
In-Reply-To: <1375225204-5082-1-git-send-email-sean@mess.org>
References: <1375225204-5082-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many devices with an ir receiver also have a feedback led. Add the
led trigger to support this.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 1cf382a..628ac2a 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -16,6 +16,7 @@
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/input.h>
+#include <linux/leds.h>
 #include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/module.h>
@@ -31,6 +32,7 @@
 /* Used to keep track of known keymaps */
 static LIST_HEAD(rc_map_list);
 static DEFINE_SPINLOCK(rc_map_lock);
+static struct led_trigger *led_feedback;
 
 static struct rc_map_list *seek_rc_map(const char *name)
 {
@@ -535,6 +537,7 @@ static void ir_do_keyup(struct rc_dev *dev, bool sync)
 
 	IR_dprintk(1, "keyup key 0x%04x\n", dev->last_keycode);
 	input_report_key(dev->input_dev, dev->last_keycode, 0);
+	led_trigger_event(led_feedback, LED_OFF);
 	if (sync)
 		input_sync(dev->input_dev);
 	dev->keypressed = false;
@@ -648,6 +651,7 @@ static void ir_do_keydown(struct rc_dev *dev, int scancode,
 		input_report_key(dev->input_dev, keycode, 1);
 	}
 
+	led_trigger_event(led_feedback, LED_FULL);
 	input_sync(dev->input_dev);
 }
 
@@ -1184,6 +1188,7 @@ static int __init rc_core_init(void)
 		return rc;
 	}
 
+	led_trigger_register_simple("rc-feedback", &led_feedback);
 	rc_map_register(&empty_map);
 
 	return 0;
@@ -1192,6 +1197,7 @@ static int __init rc_core_init(void)
 static void __exit rc_core_exit(void)
 {
 	class_unregister(&rc_class);
+	led_trigger_unregister_simple(led_feedback);
 	rc_map_unregister(&empty_map);
 }
 
-- 
1.8.3.1

