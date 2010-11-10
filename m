Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:13767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab0KJDP2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 22:15:28 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAA3FSPU003389
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 9 Nov 2010 22:15:28 -0500
Received: from pedra (vpn-229-171.phx2.redhat.com [10.3.229.171])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oAA3DKlY031781
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 9 Nov 2010 22:15:27 -0500
Date: Wed, 10 Nov 2010 01:13:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] [media] rc-core: Merge rc-sysfs.c into rc-main.c
Message-ID: <20101110011310.766f64f0@pedra>
In-Reply-To: <cover.1289358255.git.mchehab@redhat.com>
References: <cover.1289358255.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 delete mode 100644 drivers/media/rc/rc-sysfs.c

diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 479a8f4..5a1112c 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -1,5 +1,5 @@
 ir-common-objs  := ir-functions.o
-rc-core-objs	:= rc-main.o rc-sysfs.o rc-raw.o rc-map.o
+rc-core-objs	:= rc-main.o rc-raw.o rc-map.o
 
 obj-y += keymaps/
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index af7119f..3942673 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1,6 +1,6 @@
-/* ir-keytable.c - handle IR scancode->keycode tables
+/* rc-core.c - handle IR scancode->keycode tables
  *
- * Copyright (C) 2009 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -15,8 +15,14 @@
 
 #include <linux/input.h>
 #include <linux/slab.h>
+#include <linux/device.h>
 #include "rc-core-priv.h"
 
+#define IRRCV_NUM_DEVICES	256
+
+/* bit array to represent IR sysfs device number */
+static unsigned long ir_core_dev_number;
+
 /* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
 #define IR_TAB_MIN_SIZE	256
 #define IR_TAB_MAX_SIZE	8192
@@ -625,6 +631,345 @@ void ir_input_unregister(struct input_dev *input_dev)
 }
 EXPORT_SYMBOL_GPL(ir_input_unregister);
 
+/* class for /sys/class/rc */
+static char *ir_devnode(struct device *dev, mode_t *mode)
+{
+	return kasprintf(GFP_KERNEL, "rc/%s", dev_name(dev));
+}
+
+static struct class ir_input_class = {
+	.name		= "rc",
+	.devnode	= ir_devnode,
+};
+
+static struct {
+	u64	type;
+	char	*name;
+} proto_names[] = {
+	{ IR_TYPE_UNKNOWN,	"unknown"	},
+	{ IR_TYPE_RC5,		"rc-5"		},
+	{ IR_TYPE_NEC,		"nec"		},
+	{ IR_TYPE_RC6,		"rc-6"		},
+	{ IR_TYPE_JVC,		"jvc"		},
+	{ IR_TYPE_SONY,		"sony"		},
+	{ IR_TYPE_RC5_SZ,	"rc-5-sz"	},
+	{ IR_TYPE_LIRC,		"lirc"		},
+};
+
+#define PROTO_NONE	"none"
+
+/**
+ * show_protocols() - shows the current IR protocol(s)
+ * @d:		the device descriptor
+ * @mattr:	the device attribute struct (unused)
+ * @buf:	a pointer to the output buffer
+ *
+ * This routine is a callback routine for input read the IR protocol type(s).
+ * it is trigged by reading /sys/class/rc/rc?/protocols.
+ * It returns the protocol names of supported protocols.
+ * Enabled protocols are printed in brackets.
+ */
+static ssize_t show_protocols(struct device *d,
+			      struct device_attribute *mattr, char *buf)
+{
+	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
+	u64 allowed, enabled;
+	char *tmp = buf;
+	int i;
+
+	/* Device is being removed */
+	if (!ir_dev)
+		return -EINVAL;
+
+	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
+		enabled = ir_dev->rc_tab.ir_type;
+		allowed = ir_dev->props->allowed_protos;
+	} else if (ir_dev->raw) {
+		enabled = ir_dev->raw->enabled_protocols;
+		allowed = ir_raw_get_allowed_protocols();
+	} else
+		return sprintf(tmp, "[builtin]\n");
+
+	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
+		   (long long)allowed,
+		   (long long)enabled);
+
+	for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
+		if (allowed & enabled & proto_names[i].type)
+			tmp += sprintf(tmp, "[%s] ", proto_names[i].name);
+		else if (allowed & proto_names[i].type)
+			tmp += sprintf(tmp, "%s ", proto_names[i].name);
+	}
+
+	if (tmp != buf)
+		tmp--;
+	*tmp = '\n';
+	return tmp + 1 - buf;
+}
+
+/**
+ * store_protocols() - changes the current IR protocol(s)
+ * @d:		the device descriptor
+ * @mattr:	the device attribute struct (unused)
+ * @buf:	a pointer to the input buffer
+ * @len:	length of the input buffer
+ *
+ * This routine is a callback routine for changing the IR protocol type.
+ * It is trigged by writing to /sys/class/rc/rc?/protocols.
+ * Writing "+proto" will add a protocol to the list of enabled protocols.
+ * Writing "-proto" will remove a protocol from the list of enabled protocols.
+ * Writing "proto" will enable only "proto".
+ * Writing "none" will disable all protocols.
+ * Returns -EINVAL if an invalid protocol combination or unknown protocol name
+ * is used, otherwise @len.
+ */
+static ssize_t store_protocols(struct device *d,
+			       struct device_attribute *mattr,
+			       const char *data,
+			       size_t len)
+{
+	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
+	bool enable, disable;
+	const char *tmp;
+	u64 type;
+	u64 mask;
+	int rc, i, count = 0;
+	unsigned long flags;
+
+	/* Device is being removed */
+	if (!ir_dev)
+		return -EINVAL;
+
+	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
+		type = ir_dev->rc_tab.ir_type;
+	else if (ir_dev->raw)
+		type = ir_dev->raw->enabled_protocols;
+	else {
+		IR_dprintk(1, "Protocol switching not supported\n");
+		return -EINVAL;
+	}
+
+	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
+		if (!*tmp)
+			break;
+
+		if (*tmp == '+') {
+			enable = true;
+			disable = false;
+			tmp++;
+		} else if (*tmp == '-') {
+			enable = false;
+			disable = true;
+			tmp++;
+		} else {
+			enable = false;
+			disable = false;
+		}
+
+		if (!enable && !disable && !strncasecmp(tmp, PROTO_NONE, sizeof(PROTO_NONE))) {
+			tmp += sizeof(PROTO_NONE);
+			mask = 0;
+			count++;
+		} else {
+			for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
+				if (!strncasecmp(tmp, proto_names[i].name, strlen(proto_names[i].name))) {
+					tmp += strlen(proto_names[i].name);
+					mask = proto_names[i].type;
+					break;
+				}
+			}
+			if (i == ARRAY_SIZE(proto_names)) {
+				IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
+				return -EINVAL;
+			}
+			count++;
+		}
+
+		if (enable)
+			type |= mask;
+		else if (disable)
+			type &= ~mask;
+		else
+			type = mask;
+	}
+
+	if (!count) {
+		IR_dprintk(1, "Protocol not specified\n");
+		return -EINVAL;
+	}
+
+	if (ir_dev->props && ir_dev->props->change_protocol) {
+		rc = ir_dev->props->change_protocol(ir_dev->props->priv,
+						    type);
+		if (rc < 0) {
+			IR_dprintk(1, "Error setting protocols to 0x%llx\n",
+				   (long long)type);
+			return -EINVAL;
+		}
+	}
+
+	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
+		spin_lock_irqsave(&ir_dev->rc_tab.lock, flags);
+		ir_dev->rc_tab.ir_type = type;
+		spin_unlock_irqrestore(&ir_dev->rc_tab.lock, flags);
+	} else {
+		ir_dev->raw->enabled_protocols = type;
+	}
+
+	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
+		   (long long)type);
+
+	return len;
+}
+
+#define ADD_HOTPLUG_VAR(fmt, val...)					\
+	do {								\
+		int err = add_uevent_var(env, fmt, val);		\
+		if (err)						\
+			return err;					\
+	} while (0)
+
+static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
+{
+	struct ir_input_dev *ir_dev = dev_get_drvdata(device);
+
+	if (ir_dev->rc_tab.name)
+		ADD_HOTPLUG_VAR("NAME=%s", ir_dev->rc_tab.name);
+	if (ir_dev->driver_name)
+		ADD_HOTPLUG_VAR("DRV_NAME=%s", ir_dev->driver_name);
+
+	return 0;
+}
+
+/*
+ * Static device attribute struct with the sysfs attributes for IR's
+ */
+static DEVICE_ATTR(protocols, S_IRUGO | S_IWUSR,
+		   show_protocols, store_protocols);
+
+static struct attribute *rc_dev_attrs[] = {
+	&dev_attr_protocols.attr,
+	NULL,
+};
+
+static struct attribute_group rc_dev_attr_grp = {
+	.attrs	= rc_dev_attrs,
+};
+
+static const struct attribute_group *rc_dev_attr_groups[] = {
+	&rc_dev_attr_grp,
+	NULL
+};
+
+static struct device_type rc_dev_type = {
+	.groups		= rc_dev_attr_groups,
+	.uevent		= rc_dev_uevent,
+};
+
+/**
+ * ir_register_class() - creates the sysfs for /sys/class/rc/rc?
+ * @input_dev:	the struct input_dev descriptor of the device
+ *
+ * This routine is used to register the syfs code for IR class
+ */
+int ir_register_class(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	int devno = find_first_zero_bit(&ir_core_dev_number,
+					IRRCV_NUM_DEVICES);
+
+	if (unlikely(devno < 0))
+		return devno;
+
+	ir_dev->dev.type = &rc_dev_type;
+	ir_dev->devno = devno;
+
+	ir_dev->dev.class = &ir_input_class;
+	ir_dev->dev.parent = input_dev->dev.parent;
+	input_dev->dev.parent = &ir_dev->dev;
+	dev_set_name(&ir_dev->dev, "rc%d", devno);
+	dev_set_drvdata(&ir_dev->dev, ir_dev);
+	return  device_register(&ir_dev->dev);
+};
+
+/**
+ * ir_register_input - registers ir input device with input subsystem
+ * @input_dev:	the struct input_dev descriptor of the device
+ */
+
+int ir_register_input(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	int rc;
+	const char *path;
+
+
+	rc = input_register_device(input_dev);
+	if (rc < 0) {
+		device_del(&ir_dev->dev);
+		return rc;
+	}
+
+	__module_get(THIS_MODULE);
+
+	path = kobject_get_path(&ir_dev->dev.kobj, GFP_KERNEL);
+	printk(KERN_INFO "%s: %s as %s\n",
+		dev_name(&ir_dev->dev),
+		input_dev->name ? input_dev->name : "Unspecified device",
+		path ? path : "N/A");
+	kfree(path);
+
+	set_bit(ir_dev->devno, &ir_core_dev_number);
+	return 0;
+}
+
+/**
+ * ir_unregister_class() - removes the sysfs for sysfs for
+ *			   /sys/class/rc/rc?
+ * @input_dev:	the struct input_dev descriptor of the device
+ *
+ * This routine is used to unregister the syfs code for IR class
+ */
+void ir_unregister_class(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+
+	input_set_drvdata(input_dev, NULL);
+	clear_bit(ir_dev->devno, &ir_core_dev_number);
+	input_unregister_device(input_dev);
+	device_del(&ir_dev->dev);
+
+	module_put(THIS_MODULE);
+}
+
+/*
+ * Init/exit code for the module. Basically, creates/removes /sys/class/rc
+ */
+
+static int __init ir_core_init(void)
+{
+	int rc = class_register(&ir_input_class);
+	if (rc) {
+		printk(KERN_ERR "ir_core: unable to register rc class\n");
+		return rc;
+	}
+
+	/* Initialize/load the decoders/keymap code that will be used */
+	ir_raw_init();
+	ir_rcmap_init();
+
+	return 0;
+}
+
+static void __exit ir_core_exit(void)
+{
+	class_unregister(&ir_input_class);
+	ir_rcmap_cleanup();
+}
+
+module_init(ir_core_init);
+module_exit(ir_core_exit);
+
 int ir_core_debug;    /* ir_debug level (0,1,2) */
 EXPORT_SYMBOL_GPL(ir_core_debug);
 module_param_named(debug, ir_core_debug, int, 0644);
diff --git a/drivers/media/rc/rc-sysfs.c b/drivers/media/rc/rc-sysfs.c
deleted file mode 100644
index a5f81d1..0000000
--- a/drivers/media/rc/rc-sysfs.c
+++ /dev/null
@@ -1,362 +0,0 @@
-/* ir-sysfs.c - sysfs interface for RC devices (/sys/class/rc)
- *
- * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
-
-#include <linux/slab.h>
-#include <linux/input.h>
-#include <linux/device.h>
-#include "rc-core-priv.h"
-
-#define IRRCV_NUM_DEVICES	256
-
-/* bit array to represent IR sysfs device number */
-static unsigned long ir_core_dev_number;
-
-/* class for /sys/class/rc */
-static char *ir_devnode(struct device *dev, mode_t *mode)
-{
-	return kasprintf(GFP_KERNEL, "rc/%s", dev_name(dev));
-}
-
-static struct class ir_input_class = {
-	.name		= "rc",
-	.devnode	= ir_devnode,
-};
-
-static struct {
-	u64	type;
-	char	*name;
-} proto_names[] = {
-	{ IR_TYPE_UNKNOWN,	"unknown"	},
-	{ IR_TYPE_RC5,		"rc-5"		},
-	{ IR_TYPE_NEC,		"nec"		},
-	{ IR_TYPE_RC6,		"rc-6"		},
-	{ IR_TYPE_JVC,		"jvc"		},
-	{ IR_TYPE_SONY,		"sony"		},
-	{ IR_TYPE_RC5_SZ,	"rc-5-sz"	},
-	{ IR_TYPE_LIRC,		"lirc"		},
-};
-
-#define PROTO_NONE	"none"
-
-/**
- * show_protocols() - shows the current IR protocol(s)
- * @d:		the device descriptor
- * @mattr:	the device attribute struct (unused)
- * @buf:	a pointer to the output buffer
- *
- * This routine is a callback routine for input read the IR protocol type(s).
- * it is trigged by reading /sys/class/rc/rc?/protocols.
- * It returns the protocol names of supported protocols.
- * Enabled protocols are printed in brackets.
- */
-static ssize_t show_protocols(struct device *d,
-			      struct device_attribute *mattr, char *buf)
-{
-	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
-	u64 allowed, enabled;
-	char *tmp = buf;
-	int i;
-
-	/* Device is being removed */
-	if (!ir_dev)
-		return -EINVAL;
-
-	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
-		enabled = ir_dev->rc_tab.ir_type;
-		allowed = ir_dev->props->allowed_protos;
-	} else if (ir_dev->raw) {
-		enabled = ir_dev->raw->enabled_protocols;
-		allowed = ir_raw_get_allowed_protocols();
-	} else
-		return sprintf(tmp, "[builtin]\n");
-
-	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
-		   (long long)allowed,
-		   (long long)enabled);
-
-	for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
-		if (allowed & enabled & proto_names[i].type)
-			tmp += sprintf(tmp, "[%s] ", proto_names[i].name);
-		else if (allowed & proto_names[i].type)
-			tmp += sprintf(tmp, "%s ", proto_names[i].name);
-	}
-
-	if (tmp != buf)
-		tmp--;
-	*tmp = '\n';
-	return tmp + 1 - buf;
-}
-
-/**
- * store_protocols() - changes the current IR protocol(s)
- * @d:		the device descriptor
- * @mattr:	the device attribute struct (unused)
- * @buf:	a pointer to the input buffer
- * @len:	length of the input buffer
- *
- * This routine is a callback routine for changing the IR protocol type.
- * It is trigged by writing to /sys/class/rc/rc?/protocols.
- * Writing "+proto" will add a protocol to the list of enabled protocols.
- * Writing "-proto" will remove a protocol from the list of enabled protocols.
- * Writing "proto" will enable only "proto".
- * Writing "none" will disable all protocols.
- * Returns -EINVAL if an invalid protocol combination or unknown protocol name
- * is used, otherwise @len.
- */
-static ssize_t store_protocols(struct device *d,
-			       struct device_attribute *mattr,
-			       const char *data,
-			       size_t len)
-{
-	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
-	bool enable, disable;
-	const char *tmp;
-	u64 type;
-	u64 mask;
-	int rc, i, count = 0;
-	unsigned long flags;
-
-	/* Device is being removed */
-	if (!ir_dev)
-		return -EINVAL;
-
-	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
-		type = ir_dev->rc_tab.ir_type;
-	else if (ir_dev->raw)
-		type = ir_dev->raw->enabled_protocols;
-	else {
-		IR_dprintk(1, "Protocol switching not supported\n");
-		return -EINVAL;
-	}
-
-	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
-		if (!*tmp)
-			break;
-
-		if (*tmp == '+') {
-			enable = true;
-			disable = false;
-			tmp++;
-		} else if (*tmp == '-') {
-			enable = false;
-			disable = true;
-			tmp++;
-		} else {
-			enable = false;
-			disable = false;
-		}
-
-		if (!enable && !disable && !strncasecmp(tmp, PROTO_NONE, sizeof(PROTO_NONE))) {
-			tmp += sizeof(PROTO_NONE);
-			mask = 0;
-			count++;
-		} else {
-			for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
-				if (!strncasecmp(tmp, proto_names[i].name, strlen(proto_names[i].name))) {
-					tmp += strlen(proto_names[i].name);
-					mask = proto_names[i].type;
-					break;
-				}
-			}
-			if (i == ARRAY_SIZE(proto_names)) {
-				IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
-				return -EINVAL;
-			}
-			count++;
-		}
-
-		if (enable)
-			type |= mask;
-		else if (disable)
-			type &= ~mask;
-		else
-			type = mask;
-	}
-
-	if (!count) {
-		IR_dprintk(1, "Protocol not specified\n");
-		return -EINVAL;
-	}
-
-	if (ir_dev->props && ir_dev->props->change_protocol) {
-		rc = ir_dev->props->change_protocol(ir_dev->props->priv,
-						    type);
-		if (rc < 0) {
-			IR_dprintk(1, "Error setting protocols to 0x%llx\n",
-				   (long long)type);
-			return -EINVAL;
-		}
-	}
-
-	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
-		spin_lock_irqsave(&ir_dev->rc_tab.lock, flags);
-		ir_dev->rc_tab.ir_type = type;
-		spin_unlock_irqrestore(&ir_dev->rc_tab.lock, flags);
-	} else {
-		ir_dev->raw->enabled_protocols = type;
-	}
-
-	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
-		   (long long)type);
-
-	return len;
-}
-
-#define ADD_HOTPLUG_VAR(fmt, val...)					\
-	do {								\
-		int err = add_uevent_var(env, fmt, val);		\
-		if (err)						\
-			return err;					\
-	} while (0)
-
-static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
-{
-	struct ir_input_dev *ir_dev = dev_get_drvdata(device);
-
-	if (ir_dev->rc_tab.name)
-		ADD_HOTPLUG_VAR("NAME=%s", ir_dev->rc_tab.name);
-	if (ir_dev->driver_name)
-		ADD_HOTPLUG_VAR("DRV_NAME=%s", ir_dev->driver_name);
-
-	return 0;
-}
-
-/*
- * Static device attribute struct with the sysfs attributes for IR's
- */
-static DEVICE_ATTR(protocols, S_IRUGO | S_IWUSR,
-		   show_protocols, store_protocols);
-
-static struct attribute *rc_dev_attrs[] = {
-	&dev_attr_protocols.attr,
-	NULL,
-};
-
-static struct attribute_group rc_dev_attr_grp = {
-	.attrs	= rc_dev_attrs,
-};
-
-static const struct attribute_group *rc_dev_attr_groups[] = {
-	&rc_dev_attr_grp,
-	NULL
-};
-
-static struct device_type rc_dev_type = {
-	.groups		= rc_dev_attr_groups,
-	.uevent		= rc_dev_uevent,
-};
-
-/**
- * ir_register_class() - creates the sysfs for /sys/class/rc/rc?
- * @input_dev:	the struct input_dev descriptor of the device
- *
- * This routine is used to register the syfs code for IR class
- */
-int ir_register_class(struct input_dev *input_dev)
-{
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	int devno = find_first_zero_bit(&ir_core_dev_number,
-					IRRCV_NUM_DEVICES);
-
-	if (unlikely(devno < 0))
-		return devno;
-
-	ir_dev->dev.type = &rc_dev_type;
-	ir_dev->devno = devno;
-
-	ir_dev->dev.class = &ir_input_class;
-	ir_dev->dev.parent = input_dev->dev.parent;
-	input_dev->dev.parent = &ir_dev->dev;
-	dev_set_name(&ir_dev->dev, "rc%d", devno);
-	dev_set_drvdata(&ir_dev->dev, ir_dev);
-	return  device_register(&ir_dev->dev);
-};
-
-/**
- * ir_register_input - registers ir input device with input subsystem
- * @input_dev:	the struct input_dev descriptor of the device
- */
-
-int ir_register_input(struct input_dev *input_dev)
-{
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	int rc;
-	const char *path;
-
-
-	rc = input_register_device(input_dev);
-	if (rc < 0) {
-		device_del(&ir_dev->dev);
-		return rc;
-	}
-
-	__module_get(THIS_MODULE);
-
-	path = kobject_get_path(&ir_dev->dev.kobj, GFP_KERNEL);
-	printk(KERN_INFO "%s: %s as %s\n",
-		dev_name(&ir_dev->dev),
-		input_dev->name ? input_dev->name : "Unspecified device",
-		path ? path : "N/A");
-	kfree(path);
-
-	set_bit(ir_dev->devno, &ir_core_dev_number);
-	return 0;
-}
-
-/**
- * ir_unregister_class() - removes the sysfs for sysfs for
- *			   /sys/class/rc/rc?
- * @input_dev:	the struct input_dev descriptor of the device
- *
- * This routine is used to unregister the syfs code for IR class
- */
-void ir_unregister_class(struct input_dev *input_dev)
-{
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-
-	input_set_drvdata(input_dev, NULL);
-	clear_bit(ir_dev->devno, &ir_core_dev_number);
-	input_unregister_device(input_dev);
-	device_del(&ir_dev->dev);
-
-	module_put(THIS_MODULE);
-}
-
-/*
- * Init/exit code for the module. Basically, creates/removes /sys/class/rc
- */
-
-static int __init ir_core_init(void)
-{
-	int rc = class_register(&ir_input_class);
-	if (rc) {
-		printk(KERN_ERR "ir_core: unable to register rc class\n");
-		return rc;
-	}
-
-	/* Initialize/load the decoders/keymap code that will be used */
-	ir_raw_init();
-	ir_rcmap_init();
-
-	return 0;
-}
-
-static void __exit ir_core_exit(void)
-{
-	class_unregister(&ir_input_class);
-	ir_rcmap_cleanup();
-}
-
-module_init(ir_core_init);
-module_exit(ir_core_exit);
-- 
1.7.1


