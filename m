Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933539Ab0DHThl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Apr 2010 15:37:41 -0400
Date: Thu, 8 Apr 2010 16:37:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/8] V4L/DVB: ir-core: Distinguish sysfs attributes for
 in-hardware and raw decoders
Message-ID: <20100408163717.1206e802@pedra>
In-Reply-To: <cover.1270754989.git.mchehab@redhat.com>
References: <cover.1270754989.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some devices have in-hardware Remote Controller decoder, while others
need a software decoder to get the IR code. As each software decoder
can be enabled/disabled individually, allowing multiple protocol
decoding capability.

On the other hand, hardware decoders have a limited protocol
support, often being able of decoding just one protocol each time.
So, each type needs a different set of capabilities to control the
supported protocol(s).

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index f509be2..67b2aa1 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -487,11 +487,19 @@ int __ir_input_register(struct input_dev *input_dev,
 	if (rc < 0)
 		goto out_table;
 
+	if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW) {
+		rc = ir_raw_event_register(input_dev);
+		if (rc < 0)
+			goto out_event;
+	}
+
 	IR_dprintk(1, "Registered input device on %s for %s remote.\n",
 		   driver_name, rc_tab->name);
 
 	return 0;
 
+out_event:
+	ir_unregister_class(input_dev);
 out_table:
 	kfree(ir_dev->rc_tab.scan);
 out_name:
@@ -508,22 +516,25 @@ EXPORT_SYMBOL_GPL(__ir_input_register);
 
  * This routine is used to free memory and de-register interfaces.
  */
-void ir_input_unregister(struct input_dev *dev)
+void ir_input_unregister(struct input_dev *input_dev)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 	struct ir_scancode_table *rc_tab;
 
 	if (!ir_dev)
 		return;
 
 	IR_dprintk(1, "Freed keycode table\n");
+
 	del_timer_sync(&ir_dev->timer_keyup);
+	if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW)
+		ir_raw_event_unregister(input_dev);
 	rc_tab = &ir_dev->rc_tab;
 	rc_tab->size = 0;
 	kfree(rc_tab->scan);
 	rc_tab->scan = NULL;
 
-	ir_unregister_class(dev);
+	ir_unregister_class(input_dev);
 
 	kfree(ir_dev->driver_name);
 	kfree(ir_dev);
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 4ba7074..5b121d8 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -82,7 +82,6 @@ int ir_raw_event_register(struct input_dev *input_dev)
 
 	return rc;
 }
-EXPORT_SYMBOL_GPL(ir_raw_event_register);
 
 void ir_raw_event_unregister(struct input_dev *input_dev)
 {
@@ -97,7 +96,6 @@ void ir_raw_event_unregister(struct input_dev *input_dev)
 	kfree(ir->raw);
 	ir->raw = NULL;
 }
-EXPORT_SYMBOL_GPL(ir_raw_event_unregister);
 
 int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type)
 {
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index e177140..efde912 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -151,22 +151,26 @@ static int ir_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 static DEVICE_ATTR(current_protocol, S_IRUGO | S_IWUSR,
 		   show_protocol, store_protocol);
 
-static struct attribute *ir_dev_attrs[] = {
+static struct attribute *ir_hw_dev_attrs[] = {
 	&dev_attr_current_protocol.attr,
 	NULL,
 };
 
-static struct attribute_group ir_dev_attr_grp = {
-	.attrs	= ir_dev_attrs,
+static struct attribute_group ir_hw_dev_attr_grp = {
+	.attrs	= ir_hw_dev_attrs,
 };
 
-static const struct attribute_group *ir_dev_attr_groups[] = {
-	&ir_dev_attr_grp,
+static const struct attribute_group *ir_hw_dev_attr_groups[] = {
+	&ir_hw_dev_attr_grp,
 	NULL
 };
 
-static struct device_type ir_dev_type = {
-	.groups		= ir_dev_attr_groups,
+static struct device_type rc_dev_type = {
+	.groups		= ir_hw_dev_attr_groups,
+	.uevent		= ir_dev_uevent,
+};
+
+static struct device_type ir_raw_dev_type = {
 	.uevent		= ir_dev_uevent,
 };
 
@@ -180,7 +184,6 @@ int ir_register_class(struct input_dev *input_dev)
 {
 	int rc;
 	const char *path;
-
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 	int devno = find_first_zero_bit(&ir_core_dev_number,
 					IRRCV_NUM_DEVICES);
@@ -188,7 +191,11 @@ int ir_register_class(struct input_dev *input_dev)
 	if (unlikely(devno < 0))
 		return devno;
 
-	ir_dev->dev.type = &ir_dev_type;
+	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
+		ir_dev->dev.type = &rc_dev_type;
+	else
+		ir_dev->dev.type = &ir_raw_dev_type;
+
 	ir_dev->dev.class = &ir_input_class;
 	ir_dev->dev.parent = input_dev->dev.parent;
 	dev_set_name(&ir_dev->dev, "rc%d", devno);
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 7e95dc8..dc4faaf 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -854,6 +854,9 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	ir->props.open = saa7134_ir_open;
 	ir->props.close = saa7134_ir_close;
 
+	if (raw_decode)
+		ir->props.driver_type = RC_DRIVER_IR_RAW;
+
 	if (!raw_decode && allow_protocol_change) {
 		ir->props.allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
 		ir->props.change_protocol = saa7134_ir_change_protocol;
@@ -879,11 +882,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	err = ir_input_register(ir->dev, ir_codes, &ir->props, MODULE_NAME);
 	if (err)
 		goto err_out_free;
-	if (raw_decode) {
-		err = ir_raw_event_register(ir->dev);
-		if (err)
-			goto err_out_free;
-	}
 
 	/* the remote isn't as bouncy as a keyboard */
 	ir->dev->rep[REP_DELAY] = repeat_delay;
@@ -903,7 +901,6 @@ void saa7134_input_fini(struct saa7134_dev *dev)
 		return;
 
 	saa7134_ir_stop(dev);
-	ir_raw_event_unregister(dev->remote->dev);
 	ir_input_unregister(dev->remote->dev);
 	kfree(dev->remote);
 	dev->remote = NULL;
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 4397ea3..e9fa94f 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -26,6 +26,11 @@ extern int ir_core_debug;
 #define IR_dprintk(level, fmt, arg...)	if (ir_core_debug >= level) \
 	printk(KERN_DEBUG "%s: " fmt , __func__, ## arg)
 
+enum rc_driver_type {
+	RC_DRIVER_SCANCODE = 0,	/* Driver or hardware generates a scancode */
+	RC_DRIVER_IR_RAW,	/* Needs a Infra-Red pulse/space decoder */
+};
+
 enum raw_event_type {
 	IR_SPACE	= (1 << 0),
 	IR_PULSE	= (1 << 1),
@@ -35,6 +40,8 @@ enum raw_event_type {
 
 /**
  * struct ir_dev_props - Allow caller drivers to set special properties
+ * @driver_type: specifies if the driver or hardware have already a decoder,
+ *	or if it needs to use the IR raw event decoders to produce a scancode
  * @allowed_protos: bitmask with the supported IR_TYPE_* protocols
  * @scanmask: some hardware decoders are not capable of providing the full
  *	scancode to the application. As this is a hardware limit, we can't do
@@ -49,12 +56,13 @@ enum raw_event_type {
  *	is opened.
  */
 struct ir_dev_props {
-	unsigned long	allowed_protos;
-	u32		scanmask;
-	void 		*priv;
-	int		(*change_protocol)(void *priv, u64 ir_type);
-	int		(*open)(void *priv);
-	void		(*close)(void *priv);
+	enum rc_driver_type	driver_type;
+	unsigned long		allowed_protos;
+	u32			scanmask;
+	void 			*priv;
+	int			(*change_protocol)(void *priv, u64 ir_type);
+	int			(*open)(void *priv);
+	void			(*close)(void *priv);
 };
 
 struct ir_raw_event {
-- 
1.6.6.1


