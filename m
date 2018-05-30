Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:35842 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968832AbeE3JJw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 05:09:52 -0400
From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: [PATCH 6/8] media: uniphier: add common module of DVB adapter drivers
Date: Wed, 30 May 2018 18:09:44 +0900
Message-Id: <20180530090946.1635-7-suzuki.katsuhiro@socionext.com>
In-Reply-To: <20180530090946.1635-1-suzuki.katsuhiro@socionext.com>
References: <20180530090946.1635-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds common module for UniPhier DVB adapter drivers
that equipments tuners and demod that connected by I2C and
UniPhier demux.

Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
---
 drivers/media/platform/uniphier/Makefile      |  5 ++
 drivers/media/platform/uniphier/hsc-core.c    |  8 ---
 .../platform/uniphier/uniphier-adapter.c      | 54 +++++++++++++++++++
 .../platform/uniphier/uniphier-adapter.h      | 42 +++++++++++++++
 4 files changed, 101 insertions(+), 8 deletions(-)
 create mode 100644 drivers/media/platform/uniphier/uniphier-adapter.c
 create mode 100644 drivers/media/platform/uniphier/uniphier-adapter.h

diff --git a/drivers/media/platform/uniphier/Makefile b/drivers/media/platform/uniphier/Makefile
index 0622f04d9e68..9e75ad081b77 100644
--- a/drivers/media/platform/uniphier/Makefile
+++ b/drivers/media/platform/uniphier/Makefile
@@ -3,3 +3,8 @@ uniphier-dvb-y += hsc-core.o hsc-ucode.o hsc-css.o hsc-ts.o hsc-dma.o
 uniphier-dvb-$(CONFIG_DVB_UNIPHIER_LD11) += hsc-ld11.o
 
 obj-$(CONFIG_DVB_UNIPHIER) += uniphier-dvb.o
+
+ccflags-y += -Idrivers/media/dvb-frontends/
+ccflags-y += -Idrivers/media/tuners/
+
+uniphier-dvb-y += uniphier-adapter.o
diff --git a/drivers/media/platform/uniphier/hsc-core.c b/drivers/media/platform/uniphier/hsc-core.c
index cdb488e4df8c..a8d247cfd302 100644
--- a/drivers/media/platform/uniphier/hsc-core.c
+++ b/drivers/media/platform/uniphier/hsc-core.c
@@ -256,14 +256,6 @@ static void hsc_dmaif_feed_worker(struct work_struct *work)
 	dma_sync_single_for_cpu(dev, dmapos, cnt, DMA_FROM_DEVICE);
 	for (i = 0; i < cnt; i += SZ_M2TS_PKT) {
 		pkt = buf->virt + buf->rd_offs + i;
-
-		if (pkt[4] == 0x47 && pkt[5] == 0x1f && pkt[6] == 0xff)
-			continue;
-		if (pkt[5] & 0x80)
-			continue;
-		if (pkt[7] & 0xc0)
-			continue;
-
 		dvb_dmx_swfilter_packets(&tsif->demux, &pkt[4], 1);
 	}
 	dma_sync_single_for_device(dev, dmapos, cnt, DMA_FROM_DEVICE);
diff --git a/drivers/media/platform/uniphier/uniphier-adapter.c b/drivers/media/platform/uniphier/uniphier-adapter.c
new file mode 100644
index 000000000000..c895bbd9988e
--- /dev/null
+++ b/drivers/media/platform/uniphier/uniphier-adapter.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Socionext UniPhier LD20 adapter driver for ISDB.
+// Using Socionext MN884434 ISDB-S/ISDB-T demodulator and
+// SONY HELENE tuner.
+//
+// Copyright (c) 2018 Socionext Inc.
+
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+
+#include "hsc.h"
+#include "uniphier-adapter.h"
+
+int uniphier_adapter_demux_probe(struct uniphier_adapter_priv *priv)
+{
+	const struct uniphier_adapter_spec *spec = priv->spec;
+	struct device *dev = &priv->pdev->dev;
+	struct device_node *node;
+	int ret, i;
+
+	node = of_parse_phandle(dev->of_node, "demux", 0);
+	if (!node) {
+		dev_err(dev, "Failed to parse demux\n");
+		return -ENODEV;
+	}
+
+	priv->pdev_demux = of_find_device_by_node(node);
+	if (!priv->pdev_demux) {
+		dev_err(dev, "Failed to find demux device\n");
+		of_node_put(node);
+		return -ENODEV;
+	}
+	of_node_put(node);
+
+	priv->chip = platform_get_drvdata(priv->pdev_demux);
+
+	for (i = 0; i < spec->adapters; i++) {
+		ret = hsc_tsif_init(&priv->chip->tsif[i], &spec->hsc_conf[i]);
+		if (ret) {
+			dev_err(dev, "Failed to init TS I/F\n");
+			return ret;
+		}
+
+		ret = hsc_dmaif_init(&priv->chip->dmaif[i], &spec->hsc_conf[i]);
+		if (ret) {
+			dev_err(dev, "Failed to init DMA I/F\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/media/platform/uniphier/uniphier-adapter.h b/drivers/media/platform/uniphier/uniphier-adapter.h
new file mode 100644
index 000000000000..1faada3fd378
--- /dev/null
+++ b/drivers/media/platform/uniphier/uniphier-adapter.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
+ *
+ * Copyright (c) 2018 Socionext Inc.
+ */
+
+#ifndef DVB_UNIPHIER_ADAPTER_H__
+#define DVB_UNIPHIER_ADAPTER_H__
+
+struct uniphier_adapter_spec {
+	int adapters;
+	const struct hsc_conf *hsc_conf;
+	const struct i2c_board_info *demod_i2c_info;
+	const struct i2c_board_info *tuner_i2c_info;
+};
+
+struct uniphier_adapter_fe {
+	struct i2c_client *demod_i2c;
+	struct i2c_client *tuner_i2c;
+	struct dvb_frontend *fe;
+};
+
+struct uniphier_adapter_priv {
+	const struct uniphier_adapter_spec *spec;
+
+	struct platform_device *pdev;
+	struct hsc_chip *chip;
+
+	struct platform_device *pdev_demux;
+	struct clk *demod_mclk;
+	struct gpio_desc *demod_gpio;
+	struct i2c_adapter *demod_i2c_adapter;
+	struct gpio_desc *tuner_gpio;
+	struct i2c_adapter *tuner_i2c_adapter;
+
+	struct uniphier_adapter_fe *fe;
+};
+
+int uniphier_adapter_demux_probe(struct uniphier_adapter_priv *priv);
+
+#endif /* DVB_UNIPHIER_ADAPTER_H__ */
-- 
2.17.0
