Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:44519 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751829AbdHGUVB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 16:21:01 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/6] [media] rc: saa7134: add trailing space for timely decoding
Date: Mon,  7 Aug 2017 21:20:55 +0100
Message-Id: <48379f4a1521dc1e6357a91d72b6591b06560099.1502137028.git.sean@mess.org>
In-Reply-To: <cover.1502137028.git.sean@mess.org>
References: <cover.1502137028.git.sean@mess.org>
In-Reply-To: <cover.1502137028.git.sean@mess.org>
References: <cover.1502137028.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The gpio-ir-recv driver adds timeouts which the saa7134 lacks; this
causes keypress not to arrive, and to only arrive once more IR is
received. This is what the commit below calls "ghost keypresses",
and it does not solve the issue completely.

This makes the IR on the HVR-1150 much more reliable and responsive.

Fixes: 3f5c4c73322e ("[media] rc: fix ghost keypresses with certain hw")

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/pci/saa7134/saa7134-input.c |  3 +++
 drivers/media/rc/gpio-ir-recv.c           | 21 ---------------------
 drivers/media/rc/rc-ir-raw.c              | 19 ++++++++++++++++++-
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 81e27ddcf6df..4b58c129be92 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -873,6 +873,9 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	rc->dev.parent = &dev->pci->dev;
 	rc->map_name = ir_codes;
 	rc->driver_name = MODULE_NAME;
+	rc->min_timeout = 1;
+	rc->timeout = IR_DEFAULT_TIMEOUT;
+	rc->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
 
 	err = rc_register_device(rc);
 	if (err)
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 561c27a4be64..512e31593a77 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -30,7 +30,6 @@ struct gpio_rc_dev {
 	struct rc_dev *rcdev;
 	int gpio_nr;
 	bool active_low;
-	struct timer_list flush_timer;
 };
 
 #ifdef CONFIG_OF
@@ -94,26 +93,10 @@ static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 	if (rc < 0)
 		goto err_get_value;
 
-	mod_timer(&gpio_dev->flush_timer,
-		  jiffies + nsecs_to_jiffies(gpio_dev->rcdev->timeout));
-
-	ir_raw_event_handle(gpio_dev->rcdev);
-
 err_get_value:
 	return IRQ_HANDLED;
 }
 
-static void flush_timer(unsigned long arg)
-{
-	struct gpio_rc_dev *gpio_dev = (struct gpio_rc_dev *)arg;
-	DEFINE_IR_RAW_EVENT(ev);
-
-	ev.timeout = true;
-	ev.duration = gpio_dev->rcdev->timeout;
-	ir_raw_event_store(gpio_dev->rcdev, &ev);
-	ir_raw_event_handle(gpio_dev->rcdev);
-}
-
 static int gpio_ir_recv_probe(struct platform_device *pdev)
 {
 	struct gpio_rc_dev *gpio_dev;
@@ -171,9 +154,6 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	gpio_dev->gpio_nr = pdata->gpio_nr;
 	gpio_dev->active_low = pdata->active_low;
 
-	setup_timer(&gpio_dev->flush_timer, flush_timer,
-		    (unsigned long)gpio_dev);
-
 	rc = gpio_request(pdata->gpio_nr, "gpio-ir-recv");
 	if (rc < 0)
 		goto err_gpio_request;
@@ -216,7 +196,6 @@ static int gpio_ir_recv_remove(struct platform_device *pdev)
 	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
 
 	free_irq(gpio_to_irq(gpio_dev->gpio_nr), gpio_dev);
-	del_timer_sync(&gpio_dev->flush_timer);
 	rc_unregister_device(gpio_dev->rcdev);
 	gpio_free(gpio_dev->gpio_nr);
 	kfree(gpio_dev);
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 07a694298119..ef5efd994eef 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -134,9 +134,13 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
 	dev->raw->last_event = now;
 	dev->raw->last_type = type;
 
-	if (!timer_pending(&dev->raw->edge_handle))
+	/* timer could be set to timeout (125ms by default) */
+	if (!timer_pending(&dev->raw->edge_handle) ||
+	    time_after(dev->raw->edge_handle.expires,
+		       jiffies + msecs_to_jiffies(15))) {
 		mod_timer(&dev->raw->edge_handle,
 			  jiffies + msecs_to_jiffies(15));
+	}
 
 	return rc;
 }
@@ -491,6 +495,19 @@ EXPORT_SYMBOL(ir_raw_encode_scancode);
 static void edge_handle(unsigned long arg)
 {
 	struct rc_dev *dev = (struct rc_dev *)arg;
+	ktime_t interval = ktime_get() - dev->raw->last_event;
+
+	if (interval >= dev->timeout) {
+		DEFINE_IR_RAW_EVENT(ev);
+
+		ev.timeout = true;
+		ev.duration = interval;
+
+		ir_raw_event_store(dev, &ev);
+	} else {
+		mod_timer(&dev->raw->edge_handle,
+			  jiffies + nsecs_to_jiffies(dev->timeout - interval));
+	}
 
 	ir_raw_event_handle(dev);
 }
-- 
2.13.4
