Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37570 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbcFYNGw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jun 2016 09:06:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <kamil@wypas.org>
Subject: [PATCHv19 05/14] cec: add HDMI CEC framework (core)
Date: Sat, 25 Jun 2016 15:06:29 +0200
Message-Id: <1466859998-17640-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1466859998-17640-1-git-send-email-hverkuil@xs4all.nl>
References: <1466859998-17640-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The added HDMI CEC framework provides a generic kernel interface for
HDMI CEC devices.

Note that the CEC framework is added to staging/media and that the
cec.h and cec-funcs.h headers are not exported yet. While the kABI
is mature, I would prefer to allow the uABI some more time before
it is mainlined in case it needs more tweaks.

This adds the cec-core.c, media/cec.h and cec-priv.h sources.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[k.debski@samsung.com: Merged CEC Updates commit by Hans Verkuil]
[k.debski@samsung.com: Merged Update author commit by Hans Verkuil]
[k.debski@samsung.com: code cleanup and fixes]
[k.debski@samsung.com: add missing CEC commands to match spec]
[k.debski@samsung.com: add RC framework support]
[k.debski@samsung.com: move and edit documentation]
[k.debski@samsung.com: add vendor id reporting]
[k.debski@samsung.com: reorder of API structs and add reserved fields]
[k.debski@samsung.com: fix handling of events and fix 32/64bit timespec problem]
[k.debski@samsung.com: add sequence number handling]
[k.debski@samsung.com: add passthrough mode]
[k.debski@samsung.com: fix CEC defines, add missing CEC 2.0 commands]
Signed-off-by: Kamil Debski <kamil@wypas.org>
---
 drivers/staging/media/cec/cec-core.c | 409 +++++++++++++++++++++++++++++++++++
 drivers/staging/media/cec/cec-priv.h |  56 +++++
 include/media/cec.h                  | 232 ++++++++++++++++++++
 3 files changed, 697 insertions(+)
 create mode 100644 drivers/staging/media/cec/cec-core.c
 create mode 100644 drivers/staging/media/cec/cec-priv.h
 create mode 100644 include/media/cec.h

diff --git a/drivers/staging/media/cec/cec-core.c b/drivers/staging/media/cec/cec-core.c
new file mode 100644
index 0000000..61a1e69
--- /dev/null
+++ b/drivers/staging/media/cec/cec-core.c
@@ -0,0 +1,409 @@
+/*
+ * cec-core.c - HDMI Consumer Electronics Control framework - Core
+ *
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/kmod.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include "cec-priv.h"
+
+#define CEC_NUM_DEVICES	256
+#define CEC_NAME	"cec"
+
+int cec_debug;
+module_param_named(debug, cec_debug, int, 0644);
+MODULE_PARM_DESC(debug, "debug level (0-2)");
+
+static dev_t cec_dev_t;
+
+/* Active devices */
+static DEFINE_MUTEX(cec_devnode_lock);
+static DECLARE_BITMAP(cec_devnode_nums, CEC_NUM_DEVICES);
+
+static struct dentry *top_cec_dir;
+
+/* dev to cec_devnode */
+#define to_cec_devnode(cd) container_of(cd, struct cec_devnode, dev)
+
+int cec_get_device(struct cec_devnode *devnode)
+{
+	/*
+	 * Check if the cec device is available. This needs to be done with
+	 * the cec_devnode_lock held to prevent an open/unregister race:
+	 * without the lock, the device could be unregistered and freed between
+	 * the devnode->registered check and get_device() calls, leading to
+	 * a crash.
+	 */
+	mutex_lock(&cec_devnode_lock);
+	/*
+	 * return ENXIO if the cec device has been removed
+	 * already or if it is not registered anymore.
+	 */
+	if (!devnode->registered) {
+		mutex_unlock(&cec_devnode_lock);
+		return -ENXIO;
+	}
+	/* and increase the device refcount */
+	get_device(&devnode->dev);
+	mutex_unlock(&cec_devnode_lock);
+	return 0;
+}
+
+void cec_put_device(struct cec_devnode *devnode)
+{
+	mutex_lock(&cec_devnode_lock);
+	put_device(&devnode->dev);
+	mutex_unlock(&cec_devnode_lock);
+}
+
+/* Called when the last user of the cec device exits. */
+static void cec_devnode_release(struct device *cd)
+{
+	struct cec_devnode *devnode = to_cec_devnode(cd);
+
+	mutex_lock(&cec_devnode_lock);
+
+	/* Mark device node number as free */
+	clear_bit(devnode->minor, cec_devnode_nums);
+
+	mutex_unlock(&cec_devnode_lock);
+	cec_delete_adapter(to_cec_adapter(devnode));
+}
+
+static struct bus_type cec_bus_type = {
+	.name = CEC_NAME,
+};
+
+/*
+ * Register a cec device node
+ *
+ * The registration code assigns minor numbers and registers the new device node
+ * with the kernel. An error is returned if no free minor number can be found,
+ * or if the registration of the device node fails.
+ *
+ * Zero is returned on success.
+ *
+ * Note that if the cec_devnode_register call fails, the release() callback of
+ * the cec_devnode structure is *not* called, so the caller is responsible for
+ * freeing any data.
+ */
+static int __must_check cec_devnode_register(struct cec_devnode *devnode,
+					     struct module *owner)
+{
+	int minor;
+	int ret;
+
+	/* Initialization */
+	INIT_LIST_HEAD(&devnode->fhs);
+	mutex_init(&devnode->fhs_lock);
+
+	/* Part 1: Find a free minor number */
+	mutex_lock(&cec_devnode_lock);
+	minor = find_next_zero_bit(cec_devnode_nums, CEC_NUM_DEVICES, 0);
+	if (minor == CEC_NUM_DEVICES) {
+		mutex_unlock(&cec_devnode_lock);
+		pr_err("could not get a free minor\n");
+		return -ENFILE;
+	}
+
+	set_bit(minor, cec_devnode_nums);
+	mutex_unlock(&cec_devnode_lock);
+
+	devnode->minor = minor;
+	devnode->dev.bus = &cec_bus_type;
+	devnode->dev.devt = MKDEV(MAJOR(cec_dev_t), minor);
+	devnode->dev.release = cec_devnode_release;
+	devnode->dev.parent = devnode->parent;
+	dev_set_name(&devnode->dev, "cec%d", devnode->minor);
+	device_initialize(&devnode->dev);
+
+	/* Part 2: Initialize and register the character device */
+	cdev_init(&devnode->cdev, &cec_devnode_fops);
+	devnode->cdev.kobj.parent = &devnode->dev.kobj;
+	devnode->cdev.owner = owner;
+
+	ret = cdev_add(&devnode->cdev, devnode->dev.devt, 1);
+	if (ret < 0) {
+		pr_err("%s: cdev_add failed\n", __func__);
+		goto clr_bit;
+	}
+
+	ret = device_add(&devnode->dev);
+	if (ret)
+		goto cdev_del;
+
+	devnode->registered = true;
+	return 0;
+
+cdev_del:
+	cdev_del(&devnode->cdev);
+clr_bit:
+	clear_bit(devnode->minor, cec_devnode_nums);
+	return ret;
+}
+
+/*
+ * Unregister a cec device node
+ *
+ * This unregisters the passed device. Future open calls will be met with
+ * errors.
+ *
+ * This function can safely be called if the device node has never been
+ * registered or has already been unregistered.
+ */
+static void cec_devnode_unregister(struct cec_devnode *devnode)
+{
+	struct cec_fh *fh;
+
+	/* Check if devnode was never registered or already unregistered */
+	if (!devnode->registered || devnode->unregistered)
+		return;
+
+	mutex_lock(&devnode->fhs_lock);
+	list_for_each_entry(fh, &devnode->fhs, list)
+		wake_up_interruptible(&fh->wait);
+	mutex_unlock(&devnode->fhs_lock);
+
+	devnode->registered = false;
+	devnode->unregistered = true;
+	device_del(&devnode->dev);
+	cdev_del(&devnode->cdev);
+	put_device(&devnode->dev);
+}
+
+struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
+					 void *priv, const char *name, u32 caps,
+					 u8 available_las, struct device *parent)
+{
+	struct cec_adapter *adap;
+	int res;
+
+	if (WARN_ON(!parent))
+		return ERR_PTR(-EINVAL);
+	if (WARN_ON(!caps))
+		return ERR_PTR(-EINVAL);
+	if (WARN_ON(!ops))
+		return ERR_PTR(-EINVAL);
+	if (WARN_ON(!available_las || available_las > CEC_MAX_LOG_ADDRS))
+		return ERR_PTR(-EINVAL);
+	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
+	if (!adap)
+		return ERR_PTR(-ENOMEM);
+	adap->owner = parent->driver->owner;
+	adap->devnode.parent = parent;
+	strlcpy(adap->name, name, sizeof(adap->name));
+	adap->phys_addr = CEC_PHYS_ADDR_INVALID;
+	adap->log_addrs.cec_version = CEC_OP_CEC_VERSION_2_0;
+	adap->log_addrs.vendor_id = CEC_VENDOR_ID_NONE;
+	adap->capabilities = caps;
+	adap->available_log_addrs = available_las;
+	adap->sequence = 0;
+	adap->ops = ops;
+	adap->priv = priv;
+	memset(adap->phys_addrs, 0xff, sizeof(adap->phys_addrs));
+	mutex_init(&adap->lock);
+	INIT_LIST_HEAD(&adap->transmit_queue);
+	INIT_LIST_HEAD(&adap->wait_queue);
+	init_waitqueue_head(&adap->kthread_waitq);
+
+	adap->kthread = kthread_run(cec_thread_func, adap, "cec-%s", name);
+	if (IS_ERR(adap->kthread)) {
+		pr_err("cec-%s: kernel_thread() failed\n", name);
+		res = PTR_ERR(adap->kthread);
+		kfree(adap);
+		return ERR_PTR(res);
+	}
+
+	if (!(caps & CEC_CAP_RC))
+		return adap;
+
+#if IS_ENABLED(CONFIG_RC_CORE)
+	/* Prepare the RC input device */
+	adap->rc = rc_allocate_device();
+	if (!adap->rc) {
+		pr_err("cec-%s: failed to allocate memory for rc_dev\n",
+		       name);
+		kthread_stop(adap->kthread);
+		kfree(adap);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	snprintf(adap->input_name, sizeof(adap->input_name),
+		 "RC for %s", name);
+	snprintf(adap->input_phys, sizeof(adap->input_phys),
+		 "%s/input0", name);
+
+	adap->rc->input_name = adap->input_name;
+	adap->rc->input_phys = adap->input_phys;
+	adap->rc->input_id.bustype = BUS_CEC;
+	adap->rc->input_id.vendor = 0;
+	adap->rc->input_id.product = 0;
+	adap->rc->input_id.version = 1;
+	adap->rc->dev.parent = parent;
+	adap->rc->driver_type = RC_DRIVER_SCANCODE;
+	adap->rc->driver_name = CEC_NAME;
+	adap->rc->allowed_protocols = RC_BIT_CEC;
+	adap->rc->priv = adap;
+	adap->rc->map_name = RC_MAP_CEC;
+	adap->rc->timeout = MS_TO_NS(100);
+#else
+	adap->capabilities &= ~CEC_CAP_RC;
+#endif
+	return adap;
+}
+EXPORT_SYMBOL_GPL(cec_allocate_adapter);
+
+int cec_register_adapter(struct cec_adapter *adap)
+{
+	int res;
+
+	if (IS_ERR_OR_NULL(adap))
+		return 0;
+
+#if IS_ENABLED(CONFIG_RC_CORE)
+	if (adap->capabilities & CEC_CAP_RC) {
+		res = rc_register_device(adap->rc);
+
+		if (res) {
+			pr_err("cec-%s: failed to prepare input device\n",
+			       adap->name);
+			rc_free_device(adap->rc);
+			adap->rc = NULL;
+			return res;
+		}
+	}
+#endif
+
+	res = cec_devnode_register(&adap->devnode, adap->owner);
+	if (res) {
+#if IS_ENABLED(CONFIG_RC_CORE)
+		/* Note: rc_unregister also calls rc_free */
+		rc_unregister_device(adap->rc);
+		adap->rc = NULL;
+#endif
+		return res;
+	}
+
+	dev_set_drvdata(&adap->devnode.dev, adap);
+#ifdef CONFIG_MEDIA_CEC_DEBUG
+	if (!top_cec_dir)
+		return 0;
+
+	adap->cec_dir = debugfs_create_dir(dev_name(&adap->devnode.dev), top_cec_dir);
+	if (IS_ERR_OR_NULL(adap->cec_dir)) {
+		pr_warn("cec-%s: Failed to create debugfs dir\n", adap->name);
+		return 0;
+	}
+	adap->status_file = debugfs_create_devm_seqfile(&adap->devnode.dev,
+		"status", adap->cec_dir, cec_adap_status);
+	if (IS_ERR_OR_NULL(adap->status_file)) {
+		pr_warn("cec-%s: Failed to create status file\n", adap->name);
+		debugfs_remove_recursive(adap->cec_dir);
+		adap->cec_dir = NULL;
+	}
+#endif
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cec_register_adapter);
+
+void cec_unregister_adapter(struct cec_adapter *adap)
+{
+	if (IS_ERR_OR_NULL(adap))
+		return;
+
+#if IS_ENABLED(CONFIG_RC_CORE)
+	/* Note: rc_unregister also calls rc_free */
+	rc_unregister_device(adap->rc);
+	adap->rc = NULL;
+#endif
+	debugfs_remove_recursive(adap->cec_dir);
+	cec_devnode_unregister(&adap->devnode);
+}
+EXPORT_SYMBOL_GPL(cec_unregister_adapter);
+
+void cec_delete_adapter(struct cec_adapter *adap)
+{
+	if (IS_ERR_OR_NULL(adap))
+		return;
+	mutex_lock(&adap->lock);
+	__cec_s_phys_addr(adap, CEC_PHYS_ADDR_INVALID, false);
+	mutex_unlock(&adap->lock);
+	kthread_stop(adap->kthread);
+	if (adap->kthread_config)
+		kthread_stop(adap->kthread_config);
+#if IS_ENABLED(CONFIG_RC_CORE)
+	if (adap->rc)
+		rc_free_device(adap->rc);
+#endif
+	kfree(adap);
+}
+EXPORT_SYMBOL_GPL(cec_delete_adapter);
+
+/*
+ *	Initialise cec for linux
+ */
+static int __init cec_devnode_init(void)
+{
+	int ret;
+
+	pr_info("Linux cec interface: v0.10\n");
+	ret = alloc_chrdev_region(&cec_dev_t, 0, CEC_NUM_DEVICES,
+				  CEC_NAME);
+	if (ret < 0) {
+		pr_warn("cec: unable to allocate major\n");
+		return ret;
+	}
+
+#ifdef CONFIG_MEDIA_CEC_DEBUG
+	top_cec_dir = debugfs_create_dir("cec", NULL);
+	if (IS_ERR_OR_NULL(top_cec_dir)) {
+		pr_warn("cec: Failed to create debugfs cec dir\n");
+		top_cec_dir = NULL;
+	}
+#endif
+
+	ret = bus_register(&cec_bus_type);
+	if (ret < 0) {
+		unregister_chrdev_region(cec_dev_t, CEC_NUM_DEVICES);
+		pr_warn("cec: bus_register failed\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void __exit cec_devnode_exit(void)
+{
+	debugfs_remove_recursive(top_cec_dir);
+	bus_unregister(&cec_bus_type);
+	unregister_chrdev_region(cec_dev_t, CEC_NUM_DEVICES);
+}
+
+subsys_initcall(cec_devnode_init);
+module_exit(cec_devnode_exit)
+
+MODULE_AUTHOR("Hans Verkuil <hans.verkuil@cisco.com>");
+MODULE_DESCRIPTION("Device node registration for cec drivers");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/media/cec/cec-priv.h b/drivers/staging/media/cec/cec-priv.h
new file mode 100644
index 0000000..70767a7
--- /dev/null
+++ b/drivers/staging/media/cec/cec-priv.h
@@ -0,0 +1,56 @@
+/*
+ * cec-priv.h - HDMI Consumer Electronics Control internal header
+ *
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _CEC_PRIV_H
+#define _CEC_PRIV_H
+
+#include <linux/cec-funcs.h>
+#include <media/cec.h>
+
+#define dprintk(lvl, fmt, arg...)					\
+	do {								\
+		if (lvl <= cec_debug)					\
+			pr_info("cec-%s: " fmt, adap->name, ## arg);	\
+	} while (0)
+
+/* devnode to cec_adapter */
+#define to_cec_adapter(node) container_of(node, struct cec_adapter, devnode)
+
+/* cec-core.c */
+extern int cec_debug;
+int cec_get_device(struct cec_devnode *devnode);
+void cec_put_device(struct cec_devnode *devnode);
+
+/* cec-adap.c */
+int cec_monitor_all_cnt_inc(struct cec_adapter *adap);
+void cec_monitor_all_cnt_dec(struct cec_adapter *adap);
+int cec_adap_status(struct seq_file *file, void *priv);
+int cec_thread_func(void *_adap);
+void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block);
+int __cec_s_log_addrs(struct cec_adapter *adap,
+		      struct cec_log_addrs *log_addrs, bool block);
+int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
+			struct cec_fh *fh, bool block);
+void cec_queue_event_fh(struct cec_fh *fh,
+			const struct cec_event *new_ev, u64 ts);
+
+/* cec-api.c */
+extern const struct file_operations cec_devnode_fops;
+
+#endif
diff --git a/include/media/cec.h b/include/media/cec.h
new file mode 100644
index 0000000..9a791c0
--- /dev/null
+++ b/include/media/cec.h
@@ -0,0 +1,232 @@
+/*
+ * cec - HDMI Consumer Electronics Control support header
+ *
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _MEDIA_CEC_H
+#define _MEDIA_CEC_H
+
+#include <linux/poll.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/cdev.h>
+#include <linux/kthread.h>
+#include <linux/timer.h>
+#include <linux/cec-funcs.h>
+#include <media/rc-core.h>
+#include <media/cec-edid.h>
+
+/**
+ * struct cec_devnode - cec device node
+ * @dev:	cec device
+ * @cdev:	cec character device
+ * @parent:	parent device
+ * @minor:	device node minor number
+ * @registered:	the device was correctly registered
+ * @unregistered: the device was unregistered
+ * @fhs_lock:	lock to control access to the filehandle list
+ * @fhs:	the list of open filehandles (cec_fh)
+ *
+ * This structure represents a cec-related device node.
+ *
+ * The @parent is a physical device. It must be set by core or device drivers
+ * before registering the node.
+ */
+struct cec_devnode {
+	/* sysfs */
+	struct device dev;
+	struct cdev cdev;
+	struct device *parent;
+
+	/* device info */
+	int minor;
+	bool registered;
+	bool unregistered;
+	struct mutex fhs_lock;
+	struct list_head fhs;
+};
+
+struct cec_adapter;
+struct cec_data;
+
+struct cec_data {
+	struct list_head list;
+	struct list_head xfer_list;
+	struct cec_adapter *adap;
+	struct cec_msg msg;
+	struct cec_fh *fh;
+	struct delayed_work work;
+	struct completion c;
+	u8 attempts;
+	bool new_initiator;
+	bool blocking;
+	bool completed;
+};
+
+struct cec_msg_entry {
+	struct list_head	list;
+	struct cec_msg		msg;
+};
+
+#define CEC_NUM_EVENTS		CEC_EVENT_LOST_MSGS
+
+struct cec_fh {
+	struct list_head	list;
+	struct list_head	xfer_list;
+	struct cec_adapter	*adap;
+	u8			mode_initiator;
+	u8			mode_follower;
+
+	/* Events */
+	wait_queue_head_t	wait;
+	unsigned int		pending_events;
+	struct cec_event	events[CEC_NUM_EVENTS];
+	struct mutex		lock;
+	struct list_head	msgs; /* queued messages */
+	unsigned int		queued_msgs;
+};
+
+#define CEC_SIGNAL_FREE_TIME_RETRY		3
+#define CEC_SIGNAL_FREE_TIME_NEW_INITIATOR	5
+#define CEC_SIGNAL_FREE_TIME_NEXT_XFER		7
+
+/* The nominal data bit period is 2.4 ms */
+#define CEC_FREE_TIME_TO_USEC(ft)		((ft) * 2400)
+
+struct cec_adap_ops {
+	/* Low-level callbacks */
+	int (*adap_enable)(struct cec_adapter *adap, bool enable);
+	int (*adap_monitor_all_enable)(struct cec_adapter *adap, bool enable);
+	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
+	int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
+			     u32 signal_free_time, struct cec_msg *msg);
+	void (*adap_status)(struct cec_adapter *adap, struct seq_file *file);
+
+	/* High-level CEC message callback */
+	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
+};
+
+/*
+ * The minimum message length you can receive (excepting poll messages) is 2.
+ * With a transfer rate of at most 36 bytes per second this makes 18 messages
+ * per second worst case.
+ *
+ * We queue at most 3 seconds worth of messages. The CEC specification requires
+ * that messages are replied to within a second, so 3 seconds should give more
+ * than enough margin. Since most messages are actually more than 2 bytes, this
+ * is in practice a lot more than 3 seconds.
+ */
+#define CEC_MAX_MSG_QUEUE_SZ		(18 * 3)
+
+struct cec_adapter {
+	struct module *owner;
+	char name[32];
+	struct cec_devnode devnode;
+	struct mutex lock;
+	struct rc_dev *rc;
+
+	struct list_head transmit_queue;
+	struct list_head wait_queue;
+	struct cec_data *transmitting;
+
+	struct task_struct *kthread_config;
+	struct completion config_completion;
+
+	struct task_struct *kthread;
+	wait_queue_head_t kthread_waitq;
+	wait_queue_head_t waitq;
+
+	const struct cec_adap_ops *ops;
+	void *priv;
+	u32 capabilities;
+	u8 available_log_addrs;
+
+	u16 phys_addr;
+	bool is_configuring;
+	bool is_configured;
+	u32 monitor_all_cnt;
+	u32 follower_cnt;
+	struct cec_fh *cec_follower;
+	struct cec_fh *cec_initiator;
+	bool passthrough;
+	struct cec_log_addrs log_addrs;
+
+	struct dentry *cec_dir;
+	struct dentry *status_file;
+
+	u16 phys_addrs[15];
+	u32 sequence;
+
+	char input_name[32];
+	char input_phys[32];
+	char input_drv[32];
+};
+
+static inline bool cec_has_log_addr(const struct cec_adapter *adap, u8 log_addr)
+{
+	return adap->log_addrs.log_addr_mask & (1 << log_addr);
+}
+
+static inline bool cec_is_sink(const struct cec_adapter *adap)
+{
+	return adap->phys_addr == 0;
+}
+
+#if IS_ENABLED(CONFIG_MEDIA_CEC)
+struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
+		void *priv, const char *name, u32 caps, u8 available_las,
+		struct device *parent);
+int cec_register_adapter(struct cec_adapter *adap);
+void cec_unregister_adapter(struct cec_adapter *adap);
+void cec_delete_adapter(struct cec_adapter *adap);
+
+int cec_s_log_addrs(struct cec_adapter *adap, struct cec_log_addrs *log_addrs,
+		    bool block);
+void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr,
+		     bool block);
+int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
+		     bool block);
+
+/* Called by the adapter */
+void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
+		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt);
+void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
+
+#else
+
+static inline int cec_register_adapter(struct cec_adapter *adap)
+{
+	return 0;
+}
+
+static inline void cec_unregister_adapter(struct cec_adapter *adap)
+{
+}
+
+static inline void cec_delete_adapter(struct cec_adapter *adap)
+{
+}
+
+static inline void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr,
+				   bool block)
+{
+}
+
+#endif
+
+#endif /* _MEDIA_CEC_H */
-- 
2.8.1

