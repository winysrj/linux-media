Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:36798 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932997AbdABOTU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jan 2017 09:19:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/4] video: add hotplug detect notifier support
Date: Mon,  2 Jan 2017 15:19:04 +0100
Message-Id: <1483366747-34288-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1483366747-34288-1-git-send-email-hverkuil@xs4all.nl>
References: <1483366747-34288-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for video hotplug detect and EDID/ELD notifiers, which is used
to convey information from video drivers to their CEC and audio counterparts.

Based on an earlier version from Russell King:

https://patchwork.kernel.org/patch/9277043/

The hpd_notifier is a reference counted object containing the HPD/EDID/ELD state
of a video device.

When a new notifier is registered the current state will be reported to
that notifier at registration time.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/video/Kconfig        |   3 +
 drivers/video/Makefile       |   1 +
 drivers/video/hpd-notifier.c | 134 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/hpd-notifier.h | 109 +++++++++++++++++++++++++++++++++++
 4 files changed, 247 insertions(+)
 create mode 100644 drivers/video/hpd-notifier.c
 create mode 100644 include/linux/hpd-notifier.h

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 3c20af9..cddc860 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -36,6 +36,9 @@ config VIDEOMODE_HELPERS
 config HDMI
 	bool
 
+config HPD_NOTIFIERS
+	bool
+
 if VT
 	source "drivers/video/console/Kconfig"
 endif
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 9ad3c17..424698b 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_VGASTATE)            += vgastate.o
 obj-$(CONFIG_HDMI)                += hdmi.o
+obj-$(CONFIG_HPD_NOTIFIERS)       += hpd-notifier.o
 
 obj-$(CONFIG_VT)		  += console/
 obj-$(CONFIG_LOGO)		  += logo/
diff --git a/drivers/video/hpd-notifier.c b/drivers/video/hpd-notifier.c
new file mode 100644
index 0000000..54f7a6b
--- /dev/null
+++ b/drivers/video/hpd-notifier.c
@@ -0,0 +1,134 @@
+#include <linux/export.h>
+#include <linux/hpd-notifier.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+
+static LIST_HEAD(hpd_notifiers);
+static DEFINE_MUTEX(hpd_notifiers_lock);
+
+struct hpd_notifier *hpd_notifier_get(struct device *dev)
+{
+	struct hpd_notifier *n;
+
+	mutex_lock(&hpd_notifiers_lock);
+	list_for_each_entry(n, &hpd_notifiers, head) {
+		if (n->dev == dev) {
+			mutex_unlock(&hpd_notifiers_lock);
+			kref_get(&n->kref);
+			return n;
+		}
+	}
+	n = kzalloc(sizeof(*n), GFP_KERNEL);
+	if (!n)
+		goto unlock;
+	n->dev = dev;
+	mutex_init(&n->lock);
+	BLOCKING_INIT_NOTIFIER_HEAD(&n->notifiers);
+	kref_init(&n->kref);
+	list_add_tail(&n->head, &hpd_notifiers);
+unlock:
+	mutex_unlock(&hpd_notifiers_lock);
+	return n;
+}
+EXPORT_SYMBOL_GPL(hpd_notifier_get);
+
+static void hpd_notifier_release(struct kref *kref)
+{
+	struct hpd_notifier *n =
+		container_of(kref, struct hpd_notifier, kref);
+
+	mutex_lock(&hpd_notifiers_lock);
+	list_del(&n->head);
+	mutex_unlock(&hpd_notifiers_lock);
+	kfree(n->edid);
+	kfree(n);
+}
+
+void hpd_notifier_put(struct hpd_notifier *n)
+{
+	kref_put(&n->kref, hpd_notifier_release);
+}
+EXPORT_SYMBOL_GPL(hpd_notifier_put);
+
+int hpd_notifier_register(struct hpd_notifier *n, struct notifier_block *nb)
+{
+	int ret = blocking_notifier_chain_register(&n->notifiers, nb);
+
+	if (ret)
+		return ret;
+	kref_get(&n->kref);
+	mutex_lock(&n->lock);
+	if (n->connected) {
+		blocking_notifier_call_chain(&n->notifiers, HPD_CONNECTED, n);
+		if (n->edid_size)
+			blocking_notifier_call_chain(&n->notifiers, HPD_NEW_EDID, n);
+		if (n->has_eld)
+			blocking_notifier_call_chain(&n->notifiers, HPD_NEW_ELD, n);
+	}
+	mutex_unlock(&n->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hpd_notifier_register);
+
+int hpd_notifier_unregister(struct hpd_notifier *n, struct notifier_block *nb)
+{
+	int ret = blocking_notifier_chain_unregister(&n->notifiers, nb);
+
+	if (ret == 0)
+		hpd_notifier_put(n);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hpd_notifier_unregister);
+
+void hpd_event_connect(struct hpd_notifier *n)
+{
+	mutex_lock(&n->lock);
+	n->connected = true;
+	blocking_notifier_call_chain(&n->notifiers, HPD_CONNECTED, n);
+	mutex_unlock(&n->lock);
+}
+EXPORT_SYMBOL_GPL(hpd_event_connect);
+
+void hpd_event_disconnect(struct hpd_notifier *n)
+{
+	mutex_lock(&n->lock);
+	n->connected = false;
+	n->has_eld = false;
+	n->edid_size = 0;
+	blocking_notifier_call_chain(&n->notifiers, HPD_DISCONNECTED, n);
+	mutex_unlock(&n->lock);
+}
+EXPORT_SYMBOL_GPL(hpd_event_disconnect);
+
+int hpd_event_new_edid(struct hpd_notifier *n, const void *edid, size_t size)
+{
+	mutex_lock(&n->lock);
+	if (n->edid_allocated_size < size) {
+		void *p = kmalloc(size, GFP_KERNEL);
+
+		if (p == NULL) {
+			mutex_unlock(&n->lock);
+			return -ENOMEM;
+		}
+		kfree(n->edid);
+		n->edid = p;
+		n->edid_allocated_size = size;
+	}
+	memcpy(n->edid, edid, size);
+	n->edid_size = size;
+	blocking_notifier_call_chain(&n->notifiers, HPD_NEW_EDID, n);
+	mutex_unlock(&n->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hpd_event_new_edid);
+
+void hpd_event_new_eld(struct hpd_notifier *n, const u8 eld[128])
+{
+	mutex_lock(&n->lock);
+	memcpy(n->eld, eld, sizeof(n->eld));
+	n->has_eld = true;
+	blocking_notifier_call_chain(&n->notifiers, HPD_NEW_ELD, n);
+	mutex_unlock(&n->lock);
+}
+EXPORT_SYMBOL_GPL(hpd_event_new_eld);
diff --git a/include/linux/hpd-notifier.h b/include/linux/hpd-notifier.h
new file mode 100644
index 0000000..4dcb451
--- /dev/null
+++ b/include/linux/hpd-notifier.h
@@ -0,0 +1,109 @@
+/*
+ * hpd-notifier.h - notify interested parties of (dis)connect and EDID
+ * events
+ *
+ * Copyright 2016 Russell King <rmk+kernel@arm.linux.org.uk>
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ */
+
+#ifndef LINUX_HPD_NOTIFIER_H
+#define LINUX_HPD_NOTIFIER_H
+
+#include <linux/types.h>
+#include <linux/notifier.h>
+#include <linux/kref.h>
+
+enum {
+	HPD_CONNECTED,
+	HPD_DISCONNECTED,
+	HPD_NEW_EDID,
+	HPD_NEW_ELD,
+};
+
+struct device;
+
+struct hpd_notifier {
+	struct mutex lock;
+	struct list_head head;
+	struct kref kref;
+	struct blocking_notifier_head notifiers;
+	struct device *dev;
+
+	/* Current state */
+	bool connected;
+	bool has_eld;
+	unsigned char eld[128];
+	void *edid;
+	size_t edid_size;
+	size_t edid_allocated_size;
+};
+
+/**
+ * hpd_notifier_get - find or create a new hpd_notifier for the given device.
+ * @dev: device that sends the events.
+ *
+ * If a notifier for device @dev already exists, then increase the refcount
+ * and return that notifier.
+ *
+ * If it doesn't exist, then allocate a new notifier struct and return a
+ * pointer to that new struct.
+ *
+ * Return NULL if the memory could not be allocated.
+ */
+struct hpd_notifier *hpd_notifier_get(struct device *dev);
+
+/**
+ * hpd_notifier_put - decrease refcount and delete when the refcount reaches 0.
+ * @n: notifier
+ */
+void hpd_notifier_put(struct hpd_notifier *n);
+
+/**
+ * hpd_notifier_register - register the notifier with the notifier_block.
+ * @n: the HPD notifier
+ * @nb: the notifier_block
+ */
+int hpd_notifier_register(struct hpd_notifier *n, struct notifier_block *nb);
+
+/**
+ * hpd_notifier_unregister - unregister the notifier with the notifier_block.
+ * @n: the HPD notifier
+ * @nb: the notifier_block
+ */
+int hpd_notifier_unregister(struct hpd_notifier *n, struct notifier_block *nb);
+
+/**
+ * hpd_event_connect - send a connect event.
+ * @n: the HPD notifier
+ *
+ * Send an HPD_CONNECTED event to any registered parties.
+ */
+void hpd_event_connect(struct hpd_notifier *n);
+
+/**
+ * hpd_event_disconnect - send a disconnect event.
+ * @n: the HPD notifier
+ *
+ * Send an HPD_DISCONNECTED event to any registered parties.
+ */
+void hpd_event_disconnect(struct hpd_notifier *n);
+
+/**
+ * hpd_event_new_edid - send a new EDID event.
+ * @n: the HPD notifier
+ *
+ * Send an HPD_NEW_EDID event to any registered parties.
+ * This function will make a copy the EDID so it can return -ENOMEM if
+ * no memory could be allocated.
+ */
+int hpd_event_new_edid(struct hpd_notifier *n, const void *edid, size_t size);
+
+/**
+ * hpd_event_new_eld - send a new ELD event.
+ * @n: the HPD notifier
+ *
+ * Send an HPD_NEW_ELD event to any registered parties.
+ */
+void hpd_event_new_eld(struct hpd_notifier *n, const u8 eld[128]);
+
+#endif
-- 
2.8.1

