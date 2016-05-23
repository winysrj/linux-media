Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36208 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbcEWIJ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 04:09:26 -0400
Received: by mail-wm0-f52.google.com with SMTP id n129so64227948wmn.1
        for <linux-media@vger.kernel.org>; Mon, 23 May 2016 01:09:25 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, zoltan.kuscsik@linaro.org,
	sumit.semwal@linaro.org, cc.ma@mediatek.com,
	pascal.brand@linaro.org, joakim.bech@linaro.org,
	dan.caprita@windriver.com, emil.l.velikov@gmail.com
Cc: linaro-mm-sig@lists.linaro.org,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v8 3/3] SMAF: add test secure module
Date: Mon, 23 May 2016 10:09:03 +0200
Message-Id: <1463990943-10068-4-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1463990943-10068-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1463990943-10068-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This module is allow testing secure calls of SMAF.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/smaf/Kconfig           |  6 +++
 drivers/smaf/Makefile          |  1 +
 drivers/smaf/smaf-testsecure.c | 90 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 97 insertions(+)
 create mode 100644 drivers/smaf/smaf-testsecure.c

diff --git a/drivers/smaf/Kconfig b/drivers/smaf/Kconfig
index 058ec4c..aad1f05 100644
--- a/drivers/smaf/Kconfig
+++ b/drivers/smaf/Kconfig
@@ -9,3 +9,9 @@ config SMAF_CMA
 	depends on SMAF && HAVE_DMA_ATTRS
 	help
 	  Choose this option to enable CMA allocation within SMAF
+
+config SMAF_TEST_SECURE
+	tristate "SMAF secure module for test"
+	depends on SMAF
+	help
+	  Choose this option to enable secure module for test purpose
diff --git a/drivers/smaf/Makefile b/drivers/smaf/Makefile
index 05bab01b..bca6b9c 100644
--- a/drivers/smaf/Makefile
+++ b/drivers/smaf/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_SMAF) += smaf-core.o
 obj-$(CONFIG_SMAF_CMA) += smaf-cma.o
+obj-$(CONFIG_SMAF_TEST_SECURE) += smaf-testsecure.o
diff --git a/drivers/smaf/smaf-testsecure.c b/drivers/smaf/smaf-testsecure.c
new file mode 100644
index 0000000..823d0dc
--- /dev/null
+++ b/drivers/smaf/smaf-testsecure.c
@@ -0,0 +1,90 @@
+/*
+ * smaf-testsecure.c
+ *
+ * Copyright (C) Linaro SA 2015
+ * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org> for Linaro.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/smaf-secure.h>
+
+#define MAGIC 0xDEADBEEF
+
+struct test_private {
+	int magic;
+};
+
+#define to_priv(x) (struct test_private *)(x)
+
+static void *smaf_testsecure_create(void)
+{
+	struct test_private *priv;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return NULL;
+
+	priv->magic = MAGIC;
+
+	return priv;
+}
+
+static int smaf_testsecure_destroy(void *ctx)
+{
+	struct test_private *priv = to_priv(ctx);
+
+	WARN_ON(!priv || (priv->magic != MAGIC));
+	kfree(priv);
+
+	return 0;
+}
+
+static bool smaf_testsecure_grant_access(void *ctx,
+					 struct device *dev,
+					 size_t addr, size_t size,
+					 enum dma_data_direction direction)
+{
+	struct test_private *priv = to_priv(ctx);
+
+	WARN_ON(!priv || (priv->magic != MAGIC));
+	pr_debug("grant requested by device %s\n",
+		 dev->driver ? dev->driver->name : "cpu");
+
+	return priv->magic == MAGIC;
+}
+
+static void smaf_testsecure_revoke_access(void *ctx,
+					  struct device *dev,
+					  size_t addr, size_t size,
+					  enum dma_data_direction direction)
+{
+	struct test_private *priv = to_priv(ctx);
+
+	WARN_ON(!priv || (priv->magic != MAGIC));
+	pr_debug("revoke requested by device %s\n",
+		 dev->driver ? dev->driver->name : "cpu");
+}
+
+static struct smaf_secure test = {
+	.create_ctx = smaf_testsecure_create,
+	.destroy_ctx = smaf_testsecure_destroy,
+	.grant_access = smaf_testsecure_grant_access,
+	.revoke_access = smaf_testsecure_revoke_access,
+};
+
+static int __init smaf_testsecure_init(void)
+{
+	return smaf_register_secure(&test);
+}
+module_init(smaf_testsecure_init);
+
+static void __exit smaf_testsecure_deinit(void)
+{
+	smaf_unregister_secure(&test);
+}
+module_exit(smaf_testsecure_deinit);
+
+MODULE_DESCRIPTION("SMAF secure module for test purpose");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard@linaro.org>");
-- 
1.9.1

