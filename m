Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36912 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbbJUJWn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2015 05:22:43 -0400
Received: by wicfv8 with SMTP id fv8so65495634wic.0
        for <linux-media@vger.kernel.org>; Wed, 21 Oct 2015 02:22:41 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, treding@nvidia.com, sumit.semwal@linaro.org,
	tom.cooksey@arm.com, daniel.stone@collabora.com,
	linux-security-module@vger.kernel.org, xiaoquan.li@vivantecorp.com,
	labbott@redhat.com
Cc: tom.gall@linaro.org, linaro-mm-sig@lists.linaro.org,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v5 3/3] SMAF: add fake secure module
Date: Wed, 21 Oct 2015 11:22:20 +0200
Message-Id: <1445419340-11471-4-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1445419340-11471-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1445419340-11471-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This module is allow testing secure calls of SMAF.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/smaf/Kconfig           |  6 +++
 drivers/smaf/Makefile          |  1 +
 drivers/smaf/smaf-fakesecure.c | 92 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+)
 create mode 100644 drivers/smaf/smaf-fakesecure.c

diff --git a/drivers/smaf/Kconfig b/drivers/smaf/Kconfig
index 058ec4c..fd17005 100644
--- a/drivers/smaf/Kconfig
+++ b/drivers/smaf/Kconfig
@@ -9,3 +9,9 @@ config SMAF_CMA
 	depends on SMAF && HAVE_DMA_ATTRS
 	help
 	  Choose this option to enable CMA allocation within SMAF
+
+config SMAF_FAKE_SECURE
+	tristate "SMAF fake secure module"
+	depends on SMAF
+	help
+	  Choose this option to enable fake secure module for test purpose
diff --git a/drivers/smaf/Makefile b/drivers/smaf/Makefile
index 05bab01..00d5cd4 100644
--- a/drivers/smaf/Makefile
+++ b/drivers/smaf/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_SMAF) += smaf-core.o
 obj-$(CONFIG_SMAF_CMA) += smaf-cma.o
+obj-$(CONFIG_SMAF_FAKE_SECURE) += smaf-fakesecure.o
diff --git a/drivers/smaf/smaf-fakesecure.c b/drivers/smaf/smaf-fakesecure.c
new file mode 100644
index 0000000..75e12dd
--- /dev/null
+++ b/drivers/smaf/smaf-fakesecure.c
@@ -0,0 +1,92 @@
+/*
+ * smaf-fakesecure.c
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
+struct fake_private {
+	int magic;
+};
+
+static void *smaf_fakesecure_create(void)
+{
+	struct fake_private *priv;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv->magic = MAGIC;
+
+	return priv;
+}
+
+static int smaf_fakesecure_destroy(void *ctx)
+{
+	struct fake_private *priv = (struct fake_private *)ctx;
+
+	WARN_ON(!priv || (priv->magic != MAGIC));
+	kfree(priv);
+
+	return 0;
+}
+
+static bool smaf_fakesecure_grant_access(void *ctx,
+					 struct device *dev,
+					 size_t addr, size_t size,
+					 enum dma_data_direction direction)
+{
+	struct fake_private *priv = (struct fake_private *)ctx;
+
+	WARN_ON(!priv || (priv->magic != MAGIC));
+
+	return priv->magic == MAGIC;
+}
+
+static void smaf_fakesecure_revoke_access(void *ctx,
+					  struct device *dev,
+					  size_t addr, size_t size,
+					  enum dma_data_direction direction)
+{
+	struct fake_private *priv = (struct fake_private *)ctx;
+
+	WARN_ON(!priv || (priv->magic != MAGIC));
+}
+
+static bool smaf_fakesecure_allow_cpu_access(void *ctx,
+					     enum dma_data_direction direction)
+{
+	struct fake_private *priv = (struct fake_private *)ctx;
+
+	WARN_ON(!priv || (priv->magic != MAGIC));
+
+	return priv->magic == MAGIC;
+}
+
+static struct smaf_secure fake = {
+	.create_ctx = smaf_fakesecure_create,
+	.destroy_ctx = smaf_fakesecure_destroy,
+	.grant_access = smaf_fakesecure_grant_access,
+	.revoke_access = smaf_fakesecure_revoke_access,
+	.allow_cpu_access = smaf_fakesecure_allow_cpu_access,
+};
+
+static int __init smaf_fakesecure_init(void)
+{
+	return smaf_register_secure(&fake);
+}
+module_init(smaf_fakesecure_init);
+
+static void __exit smaf_fakesecure_deinit(void)
+{
+	smaf_unregister_secure(&fake);
+}
+module_exit(smaf_fakesecure_deinit);
+
+MODULE_DESCRIPTION("SMAF fake secure module for test purpose");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard@linaro.org>");
-- 
1.9.1

