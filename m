Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53758 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758800AbcLPGMl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 01:12:41 -0500
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi.shyti@samsung.com>,
        Andi Shyti <andi@etezian.org>
Subject: [PATCH v5 2/6] [media] rc-main: split setup and unregister functions
Date: Fri, 16 Dec 2016 15:12:14 +0900
Message-id: <20161216061218.5906-3-andi.shyti@samsung.com>
In-reply-to: <20161216061218.5906-1-andi.shyti@samsung.com>
References: <20161216061218.5906-1-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the input device allocation, map and protocol handling to
different functions.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
Reviewed-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 143 +++++++++++++++++++++++++--------------------
 1 file changed, 81 insertions(+), 62 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index a6bbceb..7cc700d 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1436,16 +1436,12 @@ struct rc_dev *devm_rc_allocate_device(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(devm_rc_allocate_device);
 
-int rc_register_device(struct rc_dev *dev)
+static int rc_setup_rx_device(struct rc_dev *dev)
 {
-	static bool raw_init = false; /* raw decoders loaded? */
-	struct rc_map *rc_map;
-	const char *path;
-	int attr = 0;
-	int minor;
 	int rc;
+	struct rc_map *rc_map;
 
-	if (!dev || !dev->map_name)
+	if (!dev->map_name)
 		return -EINVAL;
 
 	rc_map = rc_map_get(dev->map_name);
@@ -1454,6 +1450,19 @@ int rc_register_device(struct rc_dev *dev)
 	if (!rc_map || !rc_map->scan || rc_map->size == 0)
 		return -EINVAL;
 
+	rc = ir_setkeytable(dev, rc_map);
+	if (rc)
+		return rc;
+
+	if (dev->change_protocol) {
+		u64 rc_type = (1ll << rc_map->rc_type);
+
+		rc = dev->change_protocol(dev, &rc_type);
+		if (rc < 0)
+			goto out_table;
+		dev->enabled_protocols = rc_type;
+	}
+
 	set_bit(EV_KEY, dev->input_dev->evbit);
 	set_bit(EV_REP, dev->input_dev->evbit);
 	set_bit(EV_MSC, dev->input_dev->evbit);
@@ -1463,6 +1472,61 @@ int rc_register_device(struct rc_dev *dev)
 	if (dev->close)
 		dev->input_dev->close = ir_close;
 
+	/*
+	 * Default delay of 250ms is too short for some protocols, especially
+	 * since the timeout is currently set to 250ms. Increase it to 500ms,
+	 * to avoid wrong repetition of the keycodes. Note that this must be
+	 * set after the call to input_register_device().
+	 */
+	dev->input_dev->rep[REP_DELAY] = 500;
+
+	/*
+	 * As a repeat event on protocols like RC-5 and NEC take as long as
+	 * 110/114ms, using 33ms as a repeat period is not the right thing
+	 * to do.
+	 */
+	dev->input_dev->rep[REP_PERIOD] = 125;
+
+	dev->input_dev->dev.parent = &dev->dev;
+	memcpy(&dev->input_dev->id, &dev->input_id, sizeof(dev->input_id));
+	dev->input_dev->phys = dev->input_phys;
+	dev->input_dev->name = dev->input_name;
+
+	/* rc_open will be called here */
+	rc = input_register_device(dev->input_dev);
+	if (rc)
+		goto out_table;
+
+	return 0;
+
+out_table:
+	ir_free_table(&dev->rc_map);
+
+	return rc;
+}
+
+static void rc_free_rx_device(struct rc_dev *dev)
+{
+	if (!dev)
+		return;
+
+	ir_free_table(&dev->rc_map);
+
+	input_unregister_device(dev->input_dev);
+	dev->input_dev = NULL;
+}
+
+int rc_register_device(struct rc_dev *dev)
+{
+	static bool raw_init = false; /* raw decoders loaded? */
+	const char *path;
+	int attr = 0;
+	int minor;
+	int rc;
+
+	if (!dev)
+		return -EINVAL;
+
 	minor = ida_simple_get(&rc_ida, 0, RC_DEV_MAX, GFP_KERNEL);
 	if (minor < 0)
 		return minor;
@@ -1486,39 +1550,15 @@ int rc_register_device(struct rc_dev *dev)
 	if (rc)
 		goto out_unlock;
 
-	rc = ir_setkeytable(dev, rc_map);
-	if (rc)
-		goto out_dev;
-
-	dev->input_dev->dev.parent = &dev->dev;
-	memcpy(&dev->input_dev->id, &dev->input_id, sizeof(dev->input_id));
-	dev->input_dev->phys = dev->input_phys;
-	dev->input_dev->name = dev->input_name;
-
-	rc = input_register_device(dev->input_dev);
-	if (rc)
-		goto out_table;
-
-	/*
-	 * Default delay of 250ms is too short for some protocols, especially
-	 * since the timeout is currently set to 250ms. Increase it to 500ms,
-	 * to avoid wrong repetition of the keycodes. Note that this must be
-	 * set after the call to input_register_device().
-	 */
-	dev->input_dev->rep[REP_DELAY] = 500;
-
-	/*
-	 * As a repeat event on protocols like RC-5 and NEC take as long as
-	 * 110/114ms, using 33ms as a repeat period is not the right thing
-	 * to do.
-	 */
-	dev->input_dev->rep[REP_PERIOD] = 125;
-
 	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
 	dev_info(&dev->dev, "%s as %s\n",
 		dev->input_name ?: "Unspecified device", path ?: "N/A");
 	kfree(path);
 
+	rc = rc_setup_rx_device(dev);
+	if (rc)
+		goto out_dev;
+
 	if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		if (!raw_init) {
 			request_module_nowait("ir-lirc-codec");
@@ -1526,36 +1566,20 @@ int rc_register_device(struct rc_dev *dev)
 		}
 		rc = ir_raw_event_register(dev);
 		if (rc < 0)
-			goto out_input;
-	}
-
-	if (dev->change_protocol) {
-		u64 rc_type = (1ll << rc_map->rc_type);
-		rc = dev->change_protocol(dev, &rc_type);
-		if (rc < 0)
-			goto out_raw;
-		dev->enabled_protocols = rc_type;
+			goto out_rx;
 	}
 
 	/* Allow the RC sysfs nodes to be accessible */
 	atomic_set(&dev->initialized, 1);
 
-	IR_dprintk(1, "Registered rc%u (driver: %s, remote: %s, mode %s)\n",
+	IR_dprintk(1, "Registered rc%u (driver: %s)\n",
 		   dev->minor,
-		   dev->driver_name ? dev->driver_name : "unknown",
-		   rc_map->name ? rc_map->name : "unknown",
-		   dev->driver_type == RC_DRIVER_IR_RAW ? "raw" : "cooked");
+		   dev->driver_name ? dev->driver_name : "unknown");
 
 	return 0;
 
-out_raw:
-	if (dev->driver_type == RC_DRIVER_IR_RAW)
-		ir_raw_event_unregister(dev);
-out_input:
-	input_unregister_device(dev->input_dev);
-	dev->input_dev = NULL;
-out_table:
-	ir_free_table(&dev->rc_map);
+out_rx:
+	rc_free_rx_device(dev);
 out_dev:
 	device_del(&dev->dev);
 out_unlock:
@@ -1601,12 +1625,7 @@ void rc_unregister_device(struct rc_dev *dev)
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
 
-	/* Freeing the table should also call the stop callback */
-	ir_free_table(&dev->rc_map);
-	IR_dprintk(1, "Freed keycode table\n");
-
-	input_unregister_device(dev->input_dev);
-	dev->input_dev = NULL;
+	rc_free_rx_device(dev);
 
 	device_del(&dev->dev);
 
-- 
2.10.2

