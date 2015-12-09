Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63168 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbbLIN6i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2015 08:58:38 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v2 3/7] of: reserved_mem: add support for named reserved mem
 nodes
Date: Wed, 09 Dec 2015 14:58:18 +0100
Message-id: <1449669502-24601-4-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1449669502-24601-1-git-send-email-m.szyprowski@samsung.com>
References: <1449669502-24601-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch allows device drivers to initialize more than one reserved
memory region assigned to given device. When driver needs to use more
than one reserved memory region, it should allocate child devices and
initialize regions by index or name for each of its child devices.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c    | 104 ++++++++++++++++++++++++++++++++--------
 include/linux/of_reserved_mem.h |  31 ++++++++++--
 2 files changed, 112 insertions(+), 23 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index be77e75..a583480 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -21,6 +21,7 @@
 #include <linux/sizes.h>
 #include <linux/of_reserved_mem.h>
 #include <linux/sort.h>
+#include <linux/slab.h>
 
 #define MAX_RESERVED_REGIONS	16
 static struct reserved_mem reserved_mem[MAX_RESERVED_REGIONS];
@@ -281,53 +282,116 @@ static inline struct reserved_mem *__find_rmem(struct device_node *node)
 	return NULL;
 }
 
+struct rmem_assigned_device {
+	struct device *dev;
+	struct reserved_mem *rmem;
+	struct list_head list;
+};
+
+static LIST_HEAD(of_rmem_assigned_device_list);
+static DEFINE_MUTEX(of_rmem_assigned_device_mutex);
+
 /**
  * of_reserved_mem_device_init() - assign reserved memory region to given device
+ * @dev:	Pointer to the device to configure
+ * @np:		Pointer to the device_node with 'reserved-memory' property
+ * @idx:	Index of selected region
+ *
+ * This function assigns respective DMA-mapping operations based on reserved
+ * memory region specified by 'memory-region' property in @np node to the @dev
+ * device. When driver needs to use more than one reserved memory region, it
+ * should allocate child devices and initialize regions by name for each of
+ * child device.
  *
- * This function assign memory region pointed by "memory-region" device tree
- * property to the given device.
+ * Returns error code or zero on success.
  */
-int of_reserved_mem_device_init(struct device *dev)
+int of_reserved_mem_init(struct device *dev, struct device_node *np, int idx)
 {
+	struct rmem_assigned_device *rd;
+	struct device_node *target;
 	struct reserved_mem *rmem;
-	struct device_node *np;
 	int ret;
 
-	np = of_parse_phandle(dev->of_node, "memory-region", 0);
-	if (!np)
-		return -ENODEV;
+	if (!np || !dev)
+		return -EINVAL;
+
+	target = of_parse_phandle(np, "memory-region", idx);
+	if (!target)
+		return -EINVAL;
 
-	rmem = __find_rmem(np);
-	of_node_put(np);
+	rmem = __find_rmem(target);
+	of_node_put(target);
 
 	if (!rmem || !rmem->ops || !rmem->ops->device_init)
 		return -EINVAL;
 
+	rd = kmalloc(sizeof(struct rmem_assigned_device), GFP_KERNEL);
+	if (!rd)
+		return -ENOMEM;
+
 	ret = rmem->ops->device_init(rmem, dev);
-	if (ret == 0)
+	if (ret == 0) {
+		rd->dev = dev;
+		rd->rmem = rmem;
+
+		mutex_lock(&of_rmem_assigned_device_mutex);
+		list_add(&rd->list, &of_rmem_assigned_device_list);
+		mutex_unlock(&of_rmem_assigned_device_mutex);
+
 		dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
+	} else {
+		kfree(rd);
+	}
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(of_reserved_mem_device_init);
+EXPORT_SYMBOL_GPL(of_reserved_mem_init);
+
+/**
+ * of_reserved_mem_device_init() - assign reserved memory region to given device
+ * @dev:	Pointer to the device to configure
+ * @np:		Pointer to the device_node with 'reserved-memory' property
+ * @name:	Name of the selected region
+ *
+ * This function assigns respective DMA-mapping operations based on reserved
+ * memory region specified by 'memory-region' property in @np node, named @name
+ * to the @dev device.
+ *
+ * Returns error code or zero on success.
+ */
+int of_reserved_mem_init_by_name(struct device *dev, struct device_node *np,
+					   const char *name)
+{
+	int idx = of_property_match_string(np, "memory-region-names", name);
+
+	if (idx < 0)
+		return -EINVAL;
+	return of_reserved_mem_init(dev, np, idx);
+}
+EXPORT_SYMBOL_GPL(of_reserved_mem_init_by_name);
 
 /**
  * of_reserved_mem_device_release() - release reserved memory device structures
+ * @dev:	Pointer to the device to deconfigure
  *
  * This function releases structures allocated for memory region handling for
  * the given device.
  */
 void of_reserved_mem_device_release(struct device *dev)
 {
-	struct reserved_mem *rmem;
-	struct device_node *np;
-
-	np = of_parse_phandle(dev->of_node, "memory-region", 0);
-	if (!np)
-		return;
-
-	rmem = __find_rmem(np);
-	of_node_put(np);
+	struct rmem_assigned_device *rd;
+	struct reserved_mem *rmem = NULL;
+
+	mutex_lock(&of_rmem_assigned_device_mutex);
+	list_for_each_entry(rd, &of_rmem_assigned_device_list, list) {
+		if (rd->dev == dev) {
+			rmem = rd->rmem;
+			list_del(&rd->list);
+			kfree(rd);
+			break;
+		}
+	}
+	mutex_unlock(&of_rmem_assigned_device_mutex);
 
 	if (!rmem || !rmem->ops || !rmem->ops->device_release)
 		return;
diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index ad2f670..0b928ad 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -1,7 +1,8 @@
 #ifndef __OF_RESERVED_MEM_H
 #define __OF_RESERVED_MEM_H
 
-struct device;
+#include <linux/device.h>
+
 struct of_phandle_args;
 struct reserved_mem_ops;
 
@@ -28,14 +29,23 @@ typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem);
 	_OF_DECLARE(reservedmem, name, compat, init, reservedmem_of_init_fn)
 
 #ifdef CONFIG_OF_RESERVED_MEM
-int of_reserved_mem_device_init(struct device *dev);
+
+int of_reserved_mem_init(struct device *dev, struct device_node *np, int idx);
+int of_reserved_mem_init_by_name(struct device *dev, struct device_node *np,
+				const char *name);
 void of_reserved_mem_device_release(struct device *dev);
 
 void fdt_init_reserved_mem(void);
 void fdt_reserved_mem_save_node(unsigned long node, const char *uname,
 			       phys_addr_t base, phys_addr_t size);
 #else
-static inline int of_reserved_mem_device_init(struct device *dev)
+static inline int of_reserved_mem_init(struct device *dev,
+				struct device_node *np, int idx)
+{
+	return -ENOSYS;
+}
+static inline int of_reserved_mem_init_by_name(struct device *dev,
+				struct device_node *np, const char *name)
 {
 	return -ENOSYS;
 }
@@ -46,4 +56,19 @@ static inline void fdt_reserved_mem_save_node(unsigned long node,
 		const char *uname, phys_addr_t base, phys_addr_t size) { }
 #endif
 
+/**
+ * of_reserved_mem_device_init() - assign reserved memory region to given device
+ * @dev:	Pointer to the device to configure
+ *
+ * This function assigns respective DMA-mapping operations based on the first
+ * reserved memory region specified by 'memory-region' property in device tree
+ * node of the given device.
+ *
+ * Returns error code or zero on success.
+ */
+static inline int of_reserved_mem_device_init(struct device *dev)
+{
+	return of_reserved_mem_init(dev, dev->of_node, 0);
+}
+
 #endif /* __OF_RESERVED_MEM_H */
-- 
1.9.2

