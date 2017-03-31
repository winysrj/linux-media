Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:33427 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932892AbdCaMUt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 08:20:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Patrice.chotard@st.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv6 01/10] media: add CEC notifier support
Date: Fri, 31 Mar 2017 14:20:27 +0200
Message-Id: <20170331122036.55706-2-hverkuil@xs4all.nl>
In-Reply-To: <20170331122036.55706-1-hverkuil@xs4all.nl>
References: <20170331122036.55706-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for CEC notifiers, which is used to convey CEC physical address
information from video drivers to their CEC counterpart driver(s).

Based on an earlier version from Russell King:

https://patchwork.kernel.org/patch/9277043/

The cec_notifier is a reference counted object containing the CEC physical address
state of a video device.

When a new notifier is registered the current state will be reported to
that notifier at registration time.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 MAINTAINERS                  |   4 +-
 drivers/media/Kconfig        |   4 ++
 drivers/media/Makefile       |   4 ++
 drivers/media/cec-notifier.c | 129 +++++++++++++++++++++++++++++++++++++++++++
 include/media/cec-notifier.h | 111 +++++++++++++++++++++++++++++++++++++
 5 files changed, 251 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/cec-notifier.c
 create mode 100644 include/media/cec-notifier.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 83a42ef1d1a7..cfb2670aa372 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3066,7 +3066,7 @@ F:	drivers/net/ieee802154/cc2520.c
 F:	include/linux/spi/cc2520.h
 F:	Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
 
-CEC DRIVER
+CEC FRAMEWORK
 M:	Hans Verkuil <hans.verkuil@cisco.com>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
@@ -3076,9 +3076,11 @@ F:	Documentation/media/kapi/cec-core.rst
 F:	Documentation/media/uapi/cec
 F:	drivers/media/cec/
 F:	drivers/media/cec-edid.c
+F:	drivers/media/cec-notifier.c
 F:	drivers/media/rc/keymaps/rc-cec.c
 F:	include/media/cec.h
 F:	include/media/cec-edid.h
+F:	include/media/cec-notifier.h
 F:	include/uapi/linux/cec.h
 F:	include/uapi/linux/cec-funcs.h
 
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 3512316e7a46..9e9ded44e8a8 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -99,6 +99,10 @@ config MEDIA_CEC_DEBUG
 config MEDIA_CEC_EDID
 	bool
 
+config MEDIA_CEC_NOTIFIER
+	bool
+	select MEDIA_CEC_EDID
+
 #
 # Media controller
 #	Selectable only for webcam/grabbers, as other drivers don't use it
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index d87ccb8eeabe..8b36a571d443 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -6,6 +6,10 @@ ifeq ($(CONFIG_MEDIA_CEC_EDID),y)
   obj-$(CONFIG_MEDIA_SUPPORT) += cec-edid.o
 endif
 
+ifeq ($(CONFIG_MEDIA_CEC_NOTIFIER),y)
+  obj-$(CONFIG_MEDIA_SUPPORT) += cec-notifier.o
+endif
+
 ifeq ($(CONFIG_MEDIA_CEC_SUPPORT),y)
   obj-$(CONFIG_MEDIA_SUPPORT) += cec/
 endif
diff --git a/drivers/media/cec-notifier.c b/drivers/media/cec-notifier.c
new file mode 100644
index 000000000000..1afeede8071a
--- /dev/null
+++ b/drivers/media/cec-notifier.c
@@ -0,0 +1,129 @@
+/*
+ * cec-notifier.c - notify CEC drivers of physical address changes
+ *
+ * Copyright 2016 Russell King <rmk+kernel@arm.linux.org.uk>
+ * Copyright 2016-2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
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
+#include <linux/export.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/kref.h>
+
+#include <media/cec-notifier.h>
+#include <drm/drm_edid.h>
+
+struct cec_notifier {
+	struct mutex lock;
+	struct list_head head;
+	struct kref kref;
+	struct device *dev;
+	struct cec_adapter *cec_adap;
+	void (*callback)(struct cec_adapter *adap, u16 pa);
+
+	u16 phys_addr;
+};
+
+static LIST_HEAD(cec_notifiers);
+static DEFINE_MUTEX(cec_notifiers_lock);
+
+struct cec_notifier *cec_notifier_get(struct device *dev)
+{
+	struct cec_notifier *n;
+
+	mutex_lock(&cec_notifiers_lock);
+	list_for_each_entry(n, &cec_notifiers, head) {
+		if (n->dev == dev) {
+			mutex_unlock(&cec_notifiers_lock);
+			kref_get(&n->kref);
+			return n;
+		}
+	}
+	n = kzalloc(sizeof(*n), GFP_KERNEL);
+	if (!n)
+		goto unlock;
+	n->dev = dev;
+	n->phys_addr = CEC_PHYS_ADDR_INVALID;
+	mutex_init(&n->lock);
+	kref_init(&n->kref);
+	list_add_tail(&n->head, &cec_notifiers);
+unlock:
+	mutex_unlock(&cec_notifiers_lock);
+	return n;
+}
+EXPORT_SYMBOL_GPL(cec_notifier_get);
+
+static void cec_notifier_release(struct kref *kref)
+{
+	struct cec_notifier *n =
+		container_of(kref, struct cec_notifier, kref);
+
+	list_del(&n->head);
+	kfree(n);
+}
+
+void cec_notifier_put(struct cec_notifier *n)
+{
+	mutex_lock(&cec_notifiers_lock);
+	kref_put(&n->kref, cec_notifier_release);
+	mutex_unlock(&cec_notifiers_lock);
+}
+EXPORT_SYMBOL_GPL(cec_notifier_put);
+
+void cec_notifier_set_phys_addr(struct cec_notifier *n, u16 pa)
+{
+	mutex_lock(&n->lock);
+	n->phys_addr = pa;
+	if (n->callback)
+		n->callback(n->cec_adap, n->phys_addr);
+	mutex_unlock(&n->lock);
+}
+EXPORT_SYMBOL_GPL(cec_notifier_set_phys_addr);
+
+void cec_notifier_set_phys_addr_from_edid(struct cec_notifier *n,
+					  const struct edid *edid)
+{
+	u16 pa = CEC_PHYS_ADDR_INVALID;
+
+	if (edid && edid->extensions)
+		pa = cec_get_edid_phys_addr((const u8 *)edid,
+				EDID_LENGTH * (edid->extensions + 1), NULL);
+	cec_notifier_set_phys_addr(n, pa);
+}
+EXPORT_SYMBOL_GPL(cec_notifier_set_phys_addr_from_edid);
+
+void cec_notifier_register(struct cec_notifier *n,
+			   struct cec_adapter *adap,
+			   void (*callback)(struct cec_adapter *adap, u16 pa))
+{
+	kref_get(&n->kref);
+	mutex_lock(&n->lock);
+	n->cec_adap = adap;
+	n->callback = callback;
+	n->callback(adap, n->phys_addr);
+	mutex_unlock(&n->lock);
+}
+EXPORT_SYMBOL_GPL(cec_notifier_register);
+
+void cec_notifier_unregister(struct cec_notifier *n)
+{
+	mutex_lock(&n->lock);
+	n->callback = NULL;
+	mutex_unlock(&n->lock);
+	cec_notifier_put(n);
+}
+EXPORT_SYMBOL_GPL(cec_notifier_unregister);
diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
new file mode 100644
index 000000000000..035712e0993d
--- /dev/null
+++ b/include/media/cec-notifier.h
@@ -0,0 +1,111 @@
+/*
+ * cec-notifier.h - notify CEC drivers of physical address changes
+ *
+ * Copyright 2016 Russell King <rmk+kernel@arm.linux.org.uk>
+ * Copyright 2016-2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
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
+#ifndef LINUX_CEC_NOTIFIER_H
+#define LINUX_CEC_NOTIFIER_H
+
+#include <linux/types.h>
+#include <media/cec-edid.h>
+
+struct device;
+struct edid;
+struct cec_adapter;
+struct cec_notifier;
+
+#ifdef CONFIG_MEDIA_CEC_NOTIFIER
+
+/**
+ * cec_notifier_get - find or create a new cec_notifier for the given device.
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
+struct cec_notifier *cec_notifier_get(struct device *dev);
+
+/**
+ * cec_notifier_put - decrease refcount and delete when the refcount reaches 0.
+ * @n: notifier
+ */
+void cec_notifier_put(struct cec_notifier *n);
+
+/**
+ * cec_notifier_set_phys_addr - set a new physical address.
+ * @n: the CEC notifier
+ * @pa: the CEC physical address
+ *
+ * Set a new CEC physical address.
+ */
+void cec_notifier_set_phys_addr(struct cec_notifier *n, u16 pa);
+
+/**
+ * cec_notifier_set_phys_addr_from_edid - set parse the PA from the EDID.
+ * @n: the CEC notifier
+ * @edid: the struct edid pointer
+ *
+ * Parses the EDID to obtain the new CEC physical address and set it.
+ */
+void cec_notifier_set_phys_addr_from_edid(struct cec_notifier *n,
+					  const struct edid *edid);
+
+/**
+ * cec_notifier_register - register a callback with the notifier
+ * @n: the CEC notifier
+ * @adap: the CEC adapter, passed as argument to the callback function
+ * @callback: the callback function
+ */
+void cec_notifier_register(struct cec_notifier *n,
+			   struct cec_adapter *adap,
+			   void (*callback)(struct cec_adapter *adap, u16 pa));
+
+/**
+ * cec_notifier_unregister - unregister the callback from the notifier.
+ * @n: the CEC notifier
+ */
+void cec_notifier_unregister(struct cec_notifier *n);
+
+#else
+static inline struct cec_notifier *cec_notifier_get(struct device *dev)
+{
+	/* A non-NULL pointer is expected on success */
+	return (struct cec_notifier *)0xdeadfeed;
+}
+
+static inline void cec_notifier_put(struct cec_notifier *n)
+{
+}
+
+static inline void cec_notifier_set_phys_addr(struct cec_notifier *n, u16 pa)
+{
+}
+
+static inline void cec_notifier_set_phys_addr_from_edid(struct cec_notifier *n,
+							const struct edid *edid)
+{
+}
+
+#endif
+
+#endif
-- 
2.11.0
