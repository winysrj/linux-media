Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:24808 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbbLGMJm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2015 07:09:42 -0500
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
Subject: [PATCH 3/7] of: reserved_mem: add support for named reserved mem nodes
Date: Mon, 07 Dec 2015 13:08:58 +0100
Message-id: <1449490142-27502-4-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1449490142-27502-1-git-send-email-m.szyprowski@samsung.com>
References: <1449490142-27502-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch allows device drivers to use more than one reserved memory
region assigned to given device. When NULL name is passed to
of_reserved_mem_device_init(), the default (first) region is used.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c    | 101 +++++++++++++++++++++++++++++++---------
 include/linux/of_reserved_mem.h |   6 ++-
 2 files changed, 84 insertions(+), 23 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 1a3556a9e9ea..0a0b23b73004 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -21,6 +21,7 @@
 #include <linux/sizes.h>
 #include <linux/of_reserved_mem.h>
 #include <linux/sort.h>
+#include <linux/slab.h>
 
 #define MAX_RESERVED_REGIONS	16
 static struct reserved_mem reserved_mem[MAX_RESERVED_REGIONS];
@@ -287,31 +288,84 @@ static inline struct reserved_mem *__find_rmem(struct device_node *node)
 	return NULL;
 }
 
+static struct reserved_mem *__node_to_rmem(struct device_node *node,
+					   const char *name)
+{
+	struct reserved_mem *rmem;
+	struct device_node *target;
+	int idx = 0;
+
+	if (!node)
+		return NULL;
+
+	if (name) {
+		idx = of_property_match_string(node,
+					       "memory-region-names", name);
+		if (idx < 0)
+			return NULL;
+	}
+
+	target = of_parse_phandle(node, "memory-region", idx);
+	if (!target)
+		return NULL;
+	rmem = __find_rmem(target);
+	of_node_put(target);
+
+	return rmem;
+}
+
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
+ * @name:	Optional name of the selected region (can be NULL)
+ *
+ * This function assigns respective DMA-mapping operations based on reserved
+ * memory regionspecified by 'memory-region' property in @np node, named @name
+ * to the @dev device. When NULL name is provided, the default (first) memory
+ * region is used. When driver needs to use more than one reserved memory
+ * region, it should allocate child devices and initialize regions by name for
+ * each of child device.
  *
- * This function assign memory region pointed by "memory-region" device tree
- * property to the given device.
+ * Returns error code or zero on success.
  */
-int of_reserved_mem_device_init(struct device *dev)
+int of_reserved_mem_device_init(struct device *dev, struct device_node *np,
+				const char *name)
 {
+	struct rmem_assigned_device *rd;
 	struct reserved_mem *rmem;
-	struct device_node *np;
 	int ret;
 
-	np = of_parse_phandle(dev->of_node, "memory-region", 0);
-	if (!np)
-		return -ENODEV;
-
-	rmem = __find_rmem(np);
-	of_node_put(np);
-
+	rmem = __node_to_rmem(np, name);
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
@@ -319,21 +373,26 @@ EXPORT_SYMBOL_GPL(of_reserved_mem_device_init);
 
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
index ad2f67054372..05dd38490657 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -28,14 +28,16 @@ typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem);
 	_OF_DECLARE(reservedmem, name, compat, init, reservedmem_of_init_fn)
 
 #ifdef CONFIG_OF_RESERVED_MEM
-int of_reserved_mem_device_init(struct device *dev);
+int of_reserved_mem_device_init(struct device *dev, struct device_node *np,
+				const char *name);
 void of_reserved_mem_device_release(struct device *dev);
 
 void fdt_init_reserved_mem(void);
 void fdt_reserved_mem_save_node(unsigned long node, const char *uname,
 			       phys_addr_t base, phys_addr_t size);
 #else
-static inline int of_reserved_mem_device_init(struct device *dev)
+static inline int of_reserved_mem_device_init(struct device *dev,
+				struct device_node *np, const char *name)
 {
 	return -ENOSYS;
 }
-- 
1.9.2

