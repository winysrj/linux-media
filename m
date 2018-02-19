Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59796 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753009AbeBSPpG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 10:45:06 -0500
From: Maciej Purski <m.purski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
Cc: Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Russell King <linux@armlinux.org.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Hoegeun Kwon <hoegeun.kwon@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Maciej Purski <m.purski@samsung.com>
Subject: [PATCH 1/8] clk: Add clk_bulk_alloc functions
Date: Mon, 19 Feb 2018 16:43:59 +0100
Message-id: <1519055046-2399-2-git-send-email-m.purski@samsung.com>
In-reply-to: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
References: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
        <CGME20180219154456eucas1p15f4073beaf61312238f142f217a8bb3c@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a driver is going to use clk_bulk_get() function, it has to
initialize an array of clk_bulk_data, by filling its id fields.

Add a new function to the core, which dynamically allocates
clk_bulk_data array and fills its id fields. Add clk_bulk_free()
function, which frees the array allocated by clk_bulk_alloc() function.
Add a managed version of clk_bulk_alloc().

Signed-off-by: Maciej Purski <m.purski@samsung.com>
---
 drivers/clk/clk-bulk.c   | 16 ++++++++++++
 drivers/clk/clk-devres.c | 37 +++++++++++++++++++++++++---
 include/linux/clk.h      | 64 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-bulk.c b/drivers/clk/clk-bulk.c
index 4c10456..2f16941 100644
--- a/drivers/clk/clk-bulk.c
+++ b/drivers/clk/clk-bulk.c
@@ -19,6 +19,22 @@
 #include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/export.h>
+#include <linux/slab.h>
+
+struct clk_bulk_data *clk_bulk_alloc(int num_clocks, const char *const *clk_ids)
+{
+	struct clk_bulk_data *ptr;
+	int i;
+
+	ptr = kcalloc(num_clocks, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < num_clocks; i++)
+		ptr[i].id = clk_ids[i];
+
+	return ptr;
+}
 
 void clk_bulk_put(int num_clks, struct clk_bulk_data *clks)
 {
diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
index d854e26..2115b97 100644
--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -9,6 +9,39 @@
 #include <linux/export.h>
 #include <linux/gfp.h>
 
+struct clk_bulk_devres {
+	struct clk_bulk_data *clks;
+	int num_clks;
+};
+
+static void devm_clk_alloc_release(struct device *dev, void *res)
+{
+	struct clk_bulk_devres *devres = res;
+
+	clk_bulk_free(devres->clks);
+}
+
+struct clk_bulk_data *devm_clk_bulk_alloc(struct device *dev, int num_clks,
+					  const char *const *clk_ids)
+{
+	struct clk_bulk_data **ptr, *clk_bulk;
+
+	ptr = devres_alloc(devm_clk_alloc_release,
+			   num_clks * sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	clk_bulk = clk_bulk_alloc(num_clks, clk_ids);
+	if (clk_bulk) {
+		*ptr = clk_bulk;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return clk_bulk;
+}
+
 static void devm_clk_release(struct device *dev, void *res)
 {
 	clk_put(*(struct clk **)res);
@@ -34,10 +67,6 @@ struct clk *devm_clk_get(struct device *dev, const char *id)
 }
 EXPORT_SYMBOL(devm_clk_get);
 
-struct clk_bulk_devres {
-	struct clk_bulk_data *clks;
-	int num_clks;
-};
 
 static void devm_clk_bulk_release(struct device *dev, void *res)
 {
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 4c4ef9f..7d66f41 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/notifier.h>
+#include <linux/slab.h>
 
 struct device;
 struct clk;
@@ -240,6 +241,52 @@ static inline void clk_bulk_unprepare(int num_clks, struct clk_bulk_data *clks)
 #endif
 
 #ifdef CONFIG_HAVE_CLK
+
+/**
+ * clk_bulk_alloc - allocates an array of clk_bulk_data and fills their
+ *		    id field
+ * @num_clks: number of clk_bulk_data
+ * @clk_ids: array of clock consumer ID's
+ *
+ * This function allows drivers to dynamically create an array of clk_bulk_data
+ * and fill their id field in one operation. If successful, it allows calling
+ * clk_bulk_get on the pointer returned by this function.
+ *
+ * Returns a pointer to a clk_bulk_data array, or valid IS_ERR() condition
+ * containing errno.
+ */
+struct clk_bulk_data *clk_bulk_alloc(int num_clks, const char *const *clk_ids);
+
+/**
+ * devm_clk_bulk_alloc - allocates an array of clk_bulk_data and fills their
+ *			 id field
+ * @dev: device for clock "consumer"
+ * @num_clks: number of clk_bulk_data
+ * @clk_ids: array of clock consumer ID's
+ *
+ * This function allows drivers to dynamically create an array of clk_bulk_data
+ * and fill their id field in one operation with management, the array will
+ * automatically be freed when the device is unbound. If successful, it allows
+ * calling clk_bulk_get on the pointer returned by this function.
+ *
+ * Returns a pointer to a clk_bulk_data array, or valid IS_ERR() condition
+ * containing errno.
+ */
+struct clk_bulk_data *devm_clk_bulk_alloc(struct device *dev, int num_clks,
+					  const char * const *clk_ids);
+
+/**
+ * clk_bulk_free - frees the array of clk_bulk_data
+ * @clks: pointer to clk_bulk_data array
+ *
+ * This function frees the array allocated by clk_bulk_data. It must be called
+ * when all clks are freed.
+ */
+static inline void clk_bulk_free(struct clk_bulk_data *clks)
+{
+	kfree(clks);
+}
+
 /**
  * clk_get - lookup and obtain a reference to a clock producer.
  * @dev: device for clock "consumer"
@@ -598,6 +645,23 @@ struct clk *clk_get_sys(const char *dev_id, const char *con_id);
 
 #else /* !CONFIG_HAVE_CLK */
 
+static inline struct clk_bulk_data *clk_bulk_alloc(int num_clks,
+						   const char **clk_ids)
+{
+	return NULL;
+}
+
+static inline struct clk_bulk_data *devm_clk_bulk_alloc(struct device *dev,
+							int num_clks,
+							const char **clk_ids)
+{
+	return NULL;
+}
+
+static inline void clk_bulk_free(struct clk_bulk_data *clks)
+{
+}
+
 static inline struct clk *clk_get(struct device *dev, const char *id)
 {
 	return NULL;
-- 
2.7.4
