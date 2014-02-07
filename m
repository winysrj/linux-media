Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:60074 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbaBGRVR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 12:21:17 -0500
Message-Id: <9f8bbe28b00160cab2cedffa3f8fb42121035964.1391792986.git.moinejf@free.fr>
In-Reply-To: <cover.1391792986.git.moinejf@free.fr>
References: <cover.1391792986.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Fri, 7 Feb 2014 17:53:27 +0100
Subject: [PATCH v3 2/2] drivers/base: declare phandle DT nodes as components
To: Russell King <rmk+kernel@arm.linux.org.uk>,
	devel@driverdev.osuosl.org
Cc: alsa-devel@alsa-project.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel@lists.freedesktop.org, Takashi Iwai <tiwai@suse.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Daniel Vetter <daniel@ffwll.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At system startup time, some devices depends on the availability of
some other devices before starting. The infrastructure for componentised
subsystems permits to handle this dependence, each driver defining
its own role.

This patch does an automatic creation of the lowest components in
case of DT. This permits simple devices to be part of complex
componentised subsystems without any specific code.

When created from DT, the device dependence is generally indicated by
phandle: a device which is pointed to by a phandle must be started
before the pointing device(s).

So, at device register time, the devices which are pointed to by a
phandle are declared as components, except when they declared
themselves as such in their probe function.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/base/component.c | 12 ++++++++++++
 drivers/base/core.c      | 18 ++++++++++++++++++
 include/linux/of.h       |  2 ++
 3 files changed, 32 insertions(+)

diff --git a/drivers/base/component.c b/drivers/base/component.c
index 0a39d7a..3cab26b 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 
 struct master {
 	struct list_head node;
@@ -336,6 +337,7 @@ EXPORT_SYMBOL_GPL(component_bind_all);
 int component_add(struct device *dev, const struct component_ops *ops)
 {
 	struct component *component;
+	struct device_node *np;
 	int ret;
 
 	component = kzalloc(sizeof(*component), GFP_KERNEL);
@@ -356,6 +358,11 @@ int component_add(struct device *dev, const struct component_ops *ops)
 
 		kfree(component);
 	}
+
+	np = dev->of_node;
+	if (np)
+		np->_flags |= OF_DEV_COMPONENT;
+
 	mutex_unlock(&component_mutex);
 
 	return ret < 0 ? ret : 0;
@@ -365,6 +372,7 @@ EXPORT_SYMBOL_GPL(component_add);
 void component_del(struct device *dev, const struct component_ops *ops)
 {
 	struct component *c, *component = NULL;
+	struct device_node *np;
 
 	mutex_lock(&component_mutex);
 	list_for_each_entry(c, &component_list, node)
@@ -377,6 +385,10 @@ void component_del(struct device *dev, const struct component_ops *ops)
 	if (component && component->master)
 		take_down_master(component->master);
 
+	np = dev->of_node;
+	if (np)
+		np->_flags &= ~OF_DEV_COMPONENT;
+
 	mutex_unlock(&component_mutex);
 
 	WARN_ON(!component);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2b56717..0517b91 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -27,6 +27,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/netdevice.h>
 #include <linux/sysfs.h>
+#include <linux/component.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -980,6 +981,7 @@ int device_add(struct device *dev)
 	struct device *parent = NULL;
 	struct kobject *kobj;
 	struct class_interface *class_intf;
+	struct device_node *np;
 	int error = -EINVAL;
 
 	dev = get_device(dev);
@@ -1088,6 +1090,15 @@ int device_add(struct device *dev)
 				class_intf->add_dev(dev, class_intf);
 		mutex_unlock(&dev->class->p->mutex);
 	}
+
+	/* if DT-created device referenced by phandle, create a component */
+	np = dev->of_node;
+	if (np && np->phandle &&
+	    !(np->_flags & OF_DEV_COMPONENT)) {
+		component_add(dev, NULL);
+		np->_flags |= OF_DEV_IMPLICIT_COMPONENT;
+	}
+
 done:
 	put_device(dev);
 	return error;
@@ -1189,10 +1200,17 @@ void device_del(struct device *dev)
 {
 	struct device *parent = dev->parent;
 	struct class_interface *class_intf;
+	struct device_node *np;
 
 	/* Notify clients of device removal.  This call must come
 	 * before dpm_sysfs_remove().
 	 */
+	np = dev->of_node;
+	if (np && (np->_flags & OF_DEV_COMPONENT)) {
+		component_del(dev, NULL);
+		np->_flags &= ~OF_DEV_IMPLICIT_COMPONENT;
+	}
+
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DEL_DEVICE, dev);
diff --git a/include/linux/of.h b/include/linux/of.h
index 70c64ba..40f1c34 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -59,6 +59,8 @@ struct device_node {
 	struct	proc_dir_entry *pde;	/* this node's proc directory */
 	struct	kref kref;
 	unsigned long _flags;
+#define OF_DEV_COMPONENT 1
+#define OF_DEV_IMPLICIT_COMPONENT 2
 	void	*data;
 #if defined(CONFIG_SPARC)
 	const char *path_component_name;
-- 
1.9.rc1

