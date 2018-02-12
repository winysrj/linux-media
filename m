Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60837 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932427AbeBLPCN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 10:02:13 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] media: rc: remove IR_dprintk() from rc-core
Date: Mon, 12 Feb 2018 15:02:08 +0000
Message-Id: <20180212150211.28355-2-sean@mess.org>
In-Reply-To: <20180212150211.28355-1-sean@mess.org>
References: <20180212150211.28355-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use dev_dbg() rather than custom debug function.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c  | 10 ++---
 drivers/media/rc/rc-ir-raw.c |  6 +--
 drivers/media/rc/rc-main.c   | 91 ++++++++++++++++++++++----------------------
 include/media/rc-core.h      |  7 ----
 4 files changed, 53 insertions(+), 61 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 1728f7f68324..645fe9c9367f 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -60,12 +60,12 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 		 * space with the maximum time value.
 		 */
 		sample = LIRC_SPACE(LIRC_VALUE_MASK);
-		IR_dprintk(2, "delivering reset sync space to lirc_dev\n");
+		dev_dbg(&dev->dev, "delivering reset sync space to lirc_dev\n");
 
 	/* Carrier reports */
 	} else if (ev.carrier_report) {
 		sample = LIRC_FREQUENCY(ev.carrier);
-		IR_dprintk(2, "carrier report (freq: %d)\n", sample);
+		dev_dbg(&dev->dev, "carrier report (freq: %d)\n", sample);
 
 	/* Packet end */
 	} else if (ev.timeout) {
@@ -77,7 +77,7 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 		dev->gap_duration = ev.duration;
 
 		sample = LIRC_TIMEOUT(ev.duration / 1000);
-		IR_dprintk(2, "timeout report (duration: %d)\n", sample);
+		dev_dbg(&dev->dev, "timeout report (duration: %d)\n", sample);
 
 	/* Normal sample */
 	} else {
@@ -98,8 +98,8 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 
 		sample = ev.pulse ? LIRC_PULSE(ev.duration / 1000) :
 					LIRC_SPACE(ev.duration / 1000);
-		IR_dprintk(2, "delivering %uus %s to lirc_dev\n",
-			   TO_US(ev.duration), TO_STR(ev.pulse));
+		dev_dbg(&dev->dev, "delivering %uus %s to lirc_dev\n",
+			TO_US(ev.duration), TO_STR(ev.pulse));
 	}
 
 	spin_lock_irqsave(&dev->lirc_fh_lock, flags);
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index ea96df49f176..6343f5e7ee5a 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -64,8 +64,8 @@ int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
 	if (!dev->raw)
 		return -EINVAL;
 
-	IR_dprintk(2, "sample: (%05dus %s)\n",
-		   TO_US(ev->duration), TO_STR(ev->pulse));
+	dev_dbg(&dev->dev, "sample: (%05dus %s)\n",
+		TO_US(ev->duration), TO_STR(ev->pulse));
 
 	if (!kfifo_put(&dev->raw->kfifo, *ev)) {
 		dev_err(&dev->dev, "IR event FIFO is full!\n");
@@ -167,7 +167,7 @@ void ir_raw_event_set_idle(struct rc_dev *dev, bool idle)
 	if (!dev->raw)
 		return;
 
-	IR_dprintk(2, "%s idle mode\n", idle ? "enter" : "leave");
+	dev_dbg(&dev->dev, "%s idle mode\n", idle ? "enter" : "leave");
 
 	if (idle) {
 		dev->raw->this_ev.timeout = true;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 1db8d38fed7c..4a952108ba1e 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -156,6 +156,7 @@ static struct rc_map_list empty_map = {
 
 /**
  * ir_create_table() - initializes a scancode table
+ * @dev:	the rc_dev device
  * @rc_map:	the rc_map to initialize
  * @name:	name to assign to the table
  * @rc_proto:	ir type to assign to the new table
@@ -166,7 +167,7 @@ static struct rc_map_list empty_map = {
  *
  * return:	zero on success or a negative error code
  */
-static int ir_create_table(struct rc_map *rc_map,
+static int ir_create_table(struct rc_dev *dev, struct rc_map *rc_map,
 			   const char *name, u64 rc_proto, size_t size)
 {
 	rc_map->name = kstrdup(name, GFP_KERNEL);
@@ -182,8 +183,8 @@ static int ir_create_table(struct rc_map *rc_map,
 		return -ENOMEM;
 	}
 
-	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
-		   rc_map->size, rc_map->alloc);
+	dev_dbg(&dev->dev, "Allocated space for %u keycode entries (%u bytes)\n",
+		rc_map->size, rc_map->alloc);
 	return 0;
 }
 
@@ -205,6 +206,7 @@ static void ir_free_table(struct rc_map *rc_map)
 
 /**
  * ir_resize_table() - resizes a scancode table if necessary
+ * @dev:	the rc_dev device
  * @rc_map:	the rc_map to resize
  * @gfp_flags:	gfp flags to use when allocating memory
  *
@@ -213,7 +215,8 @@ static void ir_free_table(struct rc_map *rc_map)
  *
  * return:	zero on success or a negative error code
  */
-static int ir_resize_table(struct rc_map *rc_map, gfp_t gfp_flags)
+static int ir_resize_table(struct rc_dev *dev, struct rc_map *rc_map,
+			   gfp_t gfp_flags)
 {
 	unsigned int oldalloc = rc_map->alloc;
 	unsigned int newalloc = oldalloc;
@@ -226,23 +229,21 @@ static int ir_resize_table(struct rc_map *rc_map, gfp_t gfp_flags)
 			return -ENOMEM;
 
 		newalloc *= 2;
-		IR_dprintk(1, "Growing table to %u bytes\n", newalloc);
+		dev_dbg(&dev->dev, "Growing table to %u bytes\n", newalloc);
 	}
 
 	if ((rc_map->len * 3 < rc_map->size) && (oldalloc > IR_TAB_MIN_SIZE)) {
 		/* Less than 1/3 of entries in use -> shrink keytable */
 		newalloc /= 2;
-		IR_dprintk(1, "Shrinking table to %u bytes\n", newalloc);
+		dev_dbg(&dev->dev, "Shrinking table to %u bytes\n", newalloc);
 	}
 
 	if (newalloc == oldalloc)
 		return 0;
 
 	newscan = kmalloc(newalloc, gfp_flags);
-	if (!newscan) {
-		IR_dprintk(1, "Failed to kmalloc %u bytes\n", newalloc);
+	if (!newscan)
 		return -ENOMEM;
-	}
 
 	memcpy(newscan, rc_map->scan, rc_map->len * sizeof(struct rc_map_table));
 	rc_map->scan = newscan;
@@ -275,16 +276,16 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
 
 	/* Did the user wish to remove the mapping? */
 	if (new_keycode == KEY_RESERVED || new_keycode == KEY_UNKNOWN) {
-		IR_dprintk(1, "#%d: Deleting scan 0x%04x\n",
-			   index, rc_map->scan[index].scancode);
+		dev_dbg(&dev->dev, "#%d: Deleting scan 0x%04x\n",
+			index, rc_map->scan[index].scancode);
 		rc_map->len--;
 		memmove(&rc_map->scan[index], &rc_map->scan[index+ 1],
 			(rc_map->len - index) * sizeof(struct rc_map_table));
 	} else {
-		IR_dprintk(1, "#%d: %s scan 0x%04x with key 0x%04x\n",
-			   index,
-			   old_keycode == KEY_RESERVED ? "New" : "Replacing",
-			   rc_map->scan[index].scancode, new_keycode);
+		dev_dbg(&dev->dev, "#%d: %s scan 0x%04x with key 0x%04x\n",
+			index,
+			old_keycode == KEY_RESERVED ? "New" : "Replacing",
+			rc_map->scan[index].scancode, new_keycode);
 		rc_map->scan[index].keycode = new_keycode;
 		__set_bit(new_keycode, dev->input_dev->keybit);
 	}
@@ -301,7 +302,7 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
 		}
 
 		/* Possibly shrink the keytable, failure is not a problem */
-		ir_resize_table(rc_map, GFP_ATOMIC);
+		ir_resize_table(dev, rc_map, GFP_ATOMIC);
 	}
 
 	return old_keycode;
@@ -352,7 +353,7 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
 
 	/* No previous mapping found, we might need to grow the table */
 	if (rc_map->size == rc_map->len) {
-		if (!resize || ir_resize_table(rc_map, GFP_ATOMIC))
+		if (!resize || ir_resize_table(dev, rc_map, GFP_ATOMIC))
 			return -1U;
 	}
 
@@ -431,8 +432,8 @@ static int ir_setkeytable(struct rc_dev *dev,
 	unsigned int i, index;
 	int rc;
 
-	rc = ir_create_table(rc_map, from->name,
-			     from->rc_proto, from->size);
+	rc = ir_create_table(dev, rc_map, from->name, from->rc_proto,
+			     from->size);
 	if (rc)
 		return rc;
 
@@ -576,8 +577,8 @@ u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode)
 	spin_unlock_irqrestore(&rc_map->lock, flags);
 
 	if (keycode != KEY_RESERVED)
-		IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
-			   dev->device_name, scancode, keycode);
+		dev_dbg(&dev->dev, "%s: scancode 0x%04x keycode 0x%02x\n",
+			dev->device_name, scancode, keycode);
 
 	return keycode;
 }
@@ -596,7 +597,7 @@ static void ir_do_keyup(struct rc_dev *dev, bool sync)
 	if (!dev->keypressed)
 		return;
 
-	IR_dprintk(1, "keyup key 0x%04x\n", dev->last_keycode);
+	dev_dbg(&dev->dev, "keyup key 0x%04x\n", dev->last_keycode);
 	del_timer(&dev->timer_repeat);
 	input_report_key(dev->input_dev, dev->last_keycode, 0);
 	led_trigger_event(led_feedback, LED_OFF);
@@ -751,8 +752,8 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_proto protocol,
 		/* Register a keypress */
 		dev->keypressed = true;
 
-		IR_dprintk(1, "%s: key down event, key 0x%04x, protocol 0x%04x, scancode 0x%08x\n",
-			   dev->device_name, keycode, protocol, scancode);
+		dev_dbg(&dev->dev, "%s: key down event, key 0x%04x, protocol 0x%04x, scancode 0x%08x\n",
+			dev->device_name, keycode, protocol, scancode);
 		input_report_key(dev->input_dev, keycode, 1);
 
 		led_trigger_event(led_feedback, LED_FULL);
@@ -1056,8 +1057,8 @@ static ssize_t show_protocols(struct device *device,
 
 	mutex_unlock(&dev->lock);
 
-	IR_dprintk(1, "%s: allowed - 0x%llx, enabled - 0x%llx\n",
-		   __func__, (long long)allowed, (long long)enabled);
+	dev_dbg(&dev->dev, "%s: allowed - 0x%llx, enabled - 0x%llx\n",
+		__func__, (long long)allowed, (long long)enabled);
 
 	for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
 		if (allowed & enabled & proto_names[i].type)
@@ -1083,6 +1084,7 @@ static ssize_t show_protocols(struct device *device,
 
 /**
  * parse_protocol_change() - parses a protocol change request
+ * @dev:	rc_dev device
  * @protocols:	pointer to the bitmask of current protocols
  * @buf:	pointer to the buffer with a list of changes
  *
@@ -1092,7 +1094,8 @@ static ssize_t show_protocols(struct device *device,
  * Writing "none" will disable all protocols.
  * Returns the number of changes performed or a negative error code.
  */
-static int parse_protocol_change(u64 *protocols, const char *buf)
+static int parse_protocol_change(struct rc_dev *dev, u64 *protocols,
+				 const char *buf)
 {
 	const char *tmp;
 	unsigned count = 0;
@@ -1128,7 +1131,8 @@ static int parse_protocol_change(u64 *protocols, const char *buf)
 			if (!strcasecmp(tmp, "lirc"))
 				mask = 0;
 			else {
-				IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
+				dev_dbg(&dev->dev, "Unknown protocol: '%s'\n",
+					tmp);
 				return -EINVAL;
 			}
 		}
@@ -1144,7 +1148,7 @@ static int parse_protocol_change(u64 *protocols, const char *buf)
 	}
 
 	if (!count) {
-		IR_dprintk(1, "Protocol not specified\n");
+		dev_dbg(&dev->dev, "Protocol not specified\n");
 		return -EINVAL;
 	}
 
@@ -1217,12 +1221,12 @@ static ssize_t store_protocols(struct device *device,
 	u64 old_protocols, new_protocols;
 	ssize_t rc;
 
-	IR_dprintk(1, "Normal protocol change requested\n");
+	dev_dbg(&dev->dev, "Normal protocol change requested\n");
 	current_protocols = &dev->enabled_protocols;
 	filter = &dev->scancode_filter;
 
 	if (!dev->change_protocol) {
-		IR_dprintk(1, "Protocol switching not supported\n");
+		dev_dbg(&dev->dev, "Protocol switching not supported\n");
 		return -EINVAL;
 	}
 
@@ -1230,14 +1234,14 @@ static ssize_t store_protocols(struct device *device,
 
 	old_protocols = *current_protocols;
 	new_protocols = old_protocols;
-	rc = parse_protocol_change(&new_protocols, buf);
+	rc = parse_protocol_change(dev, &new_protocols, buf);
 	if (rc < 0)
 		goto out;
 
 	rc = dev->change_protocol(dev, &new_protocols);
 	if (rc < 0) {
-		IR_dprintk(1, "Error setting protocols to 0x%llx\n",
-			   (long long)new_protocols);
+		dev_dbg(&dev->dev, "Error setting protocols to 0x%llx\n",
+			(long long)new_protocols);
 		goto out;
 	}
 
@@ -1246,8 +1250,8 @@ static ssize_t store_protocols(struct device *device,
 
 	if (new_protocols != old_protocols) {
 		*current_protocols = new_protocols;
-		IR_dprintk(1, "Protocols changed to 0x%llx\n",
-			   (long long)new_protocols);
+		dev_dbg(&dev->dev, "Protocols changed to 0x%llx\n",
+			(long long)new_protocols);
 	}
 
 	/*
@@ -1435,8 +1439,8 @@ static ssize_t show_wakeup_protocols(struct device *device,
 
 	mutex_unlock(&dev->lock);
 
-	IR_dprintk(1, "%s: allowed - 0x%llx, enabled - %d\n",
-		   __func__, (long long)allowed, enabled);
+	dev_dbg(&dev->dev, "%s: allowed - 0x%llx, enabled - %d\n",
+		__func__, (long long)allowed, enabled);
 
 	for (i = 0; i < ARRAY_SIZE(protocols); i++) {
 		if (allowed & (1ULL << i)) {
@@ -1511,7 +1515,7 @@ static ssize_t store_wakeup_protocols(struct device *device,
 
 	if (dev->wakeup_protocol != protocol) {
 		dev->wakeup_protocol = protocol;
-		IR_dprintk(1, "Wakeup protocol changed to %d\n", protocol);
+		dev_dbg(&dev->dev, "Wakeup protocol changed to %d\n", protocol);
 
 		if (protocol == RC_PROTO_RC6_MCE)
 			dev->scancode_wakeup_filter.data = 0x800f0000;
@@ -1874,9 +1878,8 @@ int rc_register_device(struct rc_dev *dev)
 
 	dev->registered = true;
 
-	IR_dprintk(1, "Registered rc%u (driver: %s)\n",
-		   dev->minor,
-		   dev->driver_name ? dev->driver_name : "unknown");
+	dev_dbg(&dev->dev, "Registered rc%u (driver: %s)\n", dev->minor,
+		dev->driver_name ? dev->driver_name : "unknown");
 
 	return 0;
 
@@ -1994,9 +1997,5 @@ static void __exit rc_core_exit(void)
 subsys_initcall(rc_core_init);
 module_exit(rc_core_exit);
 
-int rc_core_debug;    /* ir_debug level (0,1,2) */
-EXPORT_SYMBOL_GPL(rc_core_debug);
-module_param_named(debug, rc_core_debug, int, 0644);
-
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL v2");
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index aed4272d47f5..fc3a92668bab 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -23,13 +23,6 @@
 #include <linux/timer.h>
 #include <media/rc-map.h>
 
-extern int rc_core_debug;
-#define IR_dprintk(level, fmt, ...)				\
-do {								\
-	if (rc_core_debug >= level)				\
-		printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);	\
-} while (0)
-
 /**
  * enum rc_driver_type - type of the RC driver.
  *
-- 
2.14.3
