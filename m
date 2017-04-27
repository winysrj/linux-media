Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:55225 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755330AbdD0UeF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 16:34:05 -0400
Subject: [PATCH 2/6] rc-core: cleanup rc_register_device
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Thu, 27 Apr 2017 22:34:03 +0200
Message-ID: <149332524306.32431.8964878481747905258.stgit@zeus.hardeman.nu>
In-Reply-To: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
References: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device core infrastructure is based on the presumption that
once a driver calls device_add(), it must be ready to accept
userspace interaction.

This requires splitting rc_setup_rx_device() into two functions
and reorganizing rc_register_device() so that as much work
as possible is performed before calling device_add().

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-core-priv.h |    2 +
 drivers/media/rc/rc-ir-raw.c    |   34 ++++++++++++------
 drivers/media/rc/rc-main.c      |   75 +++++++++++++++++++++++++--------------
 3 files changed, 73 insertions(+), 38 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 0455b273c2fc..b3e7cac2c3ee 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -263,7 +263,9 @@ int ir_raw_gen_pl(struct ir_raw_event **ev, unsigned int max,
  * Routines from rc-raw.c to be used internally and by decoders
  */
 u64 ir_raw_get_allowed_protocols(void);
+int ir_raw_event_prepare(struct rc_dev *dev);
 int ir_raw_event_register(struct rc_dev *dev);
+void ir_raw_event_free(struct rc_dev *dev);
 void ir_raw_event_unregister(struct rc_dev *dev);
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 90f66dc7c0d7..ae7785c4fbe7 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -486,14 +486,18 @@ EXPORT_SYMBOL(ir_raw_encode_scancode);
 /*
  * Used to (un)register raw event clients
  */
-int ir_raw_event_register(struct rc_dev *dev)
+int ir_raw_event_prepare(struct rc_dev *dev)
 {
-	int rc;
-	struct ir_raw_handler *handler;
+	static bool raw_init; /* 'false' default value, raw decoders loaded? */
 
 	if (!dev)
 		return -EINVAL;
 
+	if (!raw_init) {
+		request_module("ir-lirc-codec");
+		raw_init = true;
+	}
+
 	dev->raw = kzalloc(sizeof(*dev->raw), GFP_KERNEL);
 	if (!dev->raw)
 		return -ENOMEM;
@@ -502,6 +506,13 @@ int ir_raw_event_register(struct rc_dev *dev)
 	dev->change_protocol = change_protocol;
 	INIT_KFIFO(dev->raw->kfifo);
 
+	return 0;
+}
+
+int ir_raw_event_register(struct rc_dev *dev)
+{
+	struct ir_raw_handler *handler;
+
 	/*
 	 * raw transmitters do not need any event registration
 	 * because the event is coming from userspace
@@ -510,10 +521,8 @@ int ir_raw_event_register(struct rc_dev *dev)
 		dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
 					       "rc%u", dev->minor);
 
-		if (IS_ERR(dev->raw->thread)) {
-			rc = PTR_ERR(dev->raw->thread);
-			goto out;
-		}
+		if (IS_ERR(dev->raw->thread))
+			return PTR_ERR(dev->raw->thread);
 	}
 
 	mutex_lock(&ir_raw_handler_lock);
@@ -524,11 +533,15 @@ int ir_raw_event_register(struct rc_dev *dev)
 	mutex_unlock(&ir_raw_handler_lock);
 
 	return 0;
+}
+
+void ir_raw_event_free(struct rc_dev *dev)
+{
+	if (!dev)
+		return;
 
-out:
 	kfree(dev->raw);
 	dev->raw = NULL;
-	return rc;
 }
 
 void ir_raw_event_unregister(struct rc_dev *dev)
@@ -547,8 +560,7 @@ void ir_raw_event_unregister(struct rc_dev *dev)
 			handler->raw_unregister(dev);
 	mutex_unlock(&ir_raw_handler_lock);
 
-	kfree(dev->raw);
-	dev->raw = NULL;
+	ir_raw_event_free(dev);
 }
 
 /*
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 802e559cc30e..44189366f232 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1663,7 +1663,7 @@ struct rc_dev *devm_rc_allocate_device(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(devm_rc_allocate_device);
 
-static int rc_setup_rx_device(struct rc_dev *dev)
+static int rc_prepare_rx_device(struct rc_dev *dev)
 {
 	int rc;
 	struct rc_map *rc_map;
@@ -1708,10 +1708,22 @@ static int rc_setup_rx_device(struct rc_dev *dev)
 	dev->input_dev->phys = dev->input_phys;
 	dev->input_dev->name = dev->input_name;
 
+	return 0;
+
+out_table:
+	ir_free_table(&dev->rc_map);
+
+	return rc;
+}
+
+static int rc_setup_rx_device(struct rc_dev *dev)
+{
+	int rc;
+
 	/* rc_open will be called here */
 	rc = input_register_device(dev->input_dev);
 	if (rc)
-		goto out_table;
+		return rc;
 
 	/*
 	 * Default delay of 250ms is too short for some protocols, especially
@@ -1729,27 +1741,23 @@ static int rc_setup_rx_device(struct rc_dev *dev)
 	dev->input_dev->rep[REP_PERIOD] = 125;
 
 	return 0;
-
-out_table:
-	ir_free_table(&dev->rc_map);
-
-	return rc;
 }
 
 static void rc_free_rx_device(struct rc_dev *dev)
 {
-	if (!dev || dev->driver_type == RC_DRIVER_IR_RAW_TX)
+	if (!dev)
 		return;
 
-	ir_free_table(&dev->rc_map);
+	if (dev->input_dev) {
+		input_unregister_device(dev->input_dev);
+		dev->input_dev = NULL;
+	}
 
-	input_unregister_device(dev->input_dev);
-	dev->input_dev = NULL;
+	ir_free_table(&dev->rc_map);
 }
 
 int rc_register_device(struct rc_dev *dev)
 {
-	static bool raw_init; /* 'false' default value, raw decoders loaded? */
 	const char *path;
 	int attr = 0;
 	int minor;
@@ -1776,30 +1784,39 @@ int rc_register_device(struct rc_dev *dev)
 		dev->sysfs_groups[attr++] = &rc_dev_wakeup_filter_attr_grp;
 	dev->sysfs_groups[attr++] = NULL;
 
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
+		rc = rc_prepare_rx_device(dev);
+		if (rc)
+			goto out_minor;
+	}
+
+	if (dev->driver_type == RC_DRIVER_IR_RAW ||
+	    dev->driver_type == RC_DRIVER_IR_RAW_TX) {
+		rc = ir_raw_event_prepare(dev);
+		if (rc < 0)
+			goto out_rx_free;
+	}
+
 	rc = device_add(&dev->dev);
 	if (rc)
-		goto out_unlock;
+		goto out_raw;
 
 	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
 	dev_info(&dev->dev, "%s as %s\n",
 		dev->input_name ?: "Unspecified device", path ?: "N/A");
 	kfree(path);
 
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
+		rc = rc_setup_rx_device(dev);
+		if (rc)
+			goto out_dev;
+	}
+
 	if (dev->driver_type == RC_DRIVER_IR_RAW ||
 	    dev->driver_type == RC_DRIVER_IR_RAW_TX) {
-		if (!raw_init) {
-			request_module_nowait("ir-lirc-codec");
-			raw_init = true;
-		}
 		rc = ir_raw_event_register(dev);
 		if (rc < 0)
-			goto out_dev;
-	}
-
-	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
-		rc = rc_setup_rx_device(dev);
-		if (rc)
-			goto out_raw;
+			goto out_rx;
 	}
 
 	/* Allow the RC sysfs nodes to be accessible */
@@ -1811,11 +1828,15 @@ int rc_register_device(struct rc_dev *dev)
 
 	return 0;
 
-out_raw:
-	ir_raw_event_unregister(dev);
+out_rx:
+	rc_free_rx_device(dev);
 out_dev:
 	device_del(&dev->dev);
-out_unlock:
+out_raw:
+	ir_raw_event_free(dev);
+out_rx_free:
+	ir_free_table(&dev->rc_map);
+out_minor:
 	ida_simple_remove(&rc_ida, minor);
 	return rc;
 }
