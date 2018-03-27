Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:46966 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752046AbeC0PRM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 11:17:12 -0400
Received: by mail-pf0-f195.google.com with SMTP id h69so3698955pfe.13
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 08:17:12 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hiranotaka@zng.info,
        Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 2/5] tuners: add new driver for Sharp qm1d1b0004 ISDB-S tuner
Date: Wed, 28 Mar 2018 00:15:59 +0900
Message-Id: <20180327151602.12250-3-tskd08@gmail.com>
In-Reply-To: <20180327151602.12250-1-tskd08@gmail.com>
References: <20180327151602.12250-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

The tuner is used in Earthsoft PT1/PT2 DVB boards,
and  the driver was extraced from (the former) va1j5jf8007s.c of PT1.
it might contain PT1 specific configs.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/tuners/Kconfig      |   7 +
 drivers/media/tuners/Makefile     |   1 +
 drivers/media/tuners/qm1d1b0004.c | 264 ++++++++++++++++++++++++++++++++++++++
 drivers/media/tuners/qm1d1b0004.h |  24 ++++
 4 files changed, 296 insertions(+)
 create mode 100644 drivers/media/tuners/qm1d1b0004.c
 create mode 100644 drivers/media/tuners/qm1d1b0004.h

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 6687514df97..147f3cd0bb9 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -284,4 +284,11 @@ config MEDIA_TUNER_QM1D1C0042
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Sharp QM1D1C0042 trellis coded 8PSK tuner driver.
+
+config MEDIA_TUNER_QM1D1B0004
+	tristate "Sharp QM1D1B0004 tuner"
+	depends on MEDIA_SUPPORT && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Sharp QM1D1B0004 ISDB-S tuner driver.
 endmenu
diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
index 0ff21f1c7ee..7b4f8423501 100644
--- a/drivers/media/tuners/Makefile
+++ b/drivers/media/tuners/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_MEDIA_TUNER_IT913X) += it913x.o
 obj-$(CONFIG_MEDIA_TUNER_R820T) += r820t.o
 obj-$(CONFIG_MEDIA_TUNER_MXL301RF) += mxl301rf.o
 obj-$(CONFIG_MEDIA_TUNER_QM1D1C0042) += qm1d1c0042.o
+obj-$(CONFIG_MEDIA_TUNER_QM1D1B0004) += qm1d1b0004.o
 obj-$(CONFIG_MEDIA_TUNER_M88RS6000T) += m88rs6000t.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18250) += tda18250.o
 
diff --git a/drivers/media/tuners/qm1d1b0004.c b/drivers/media/tuners/qm1d1b0004.c
new file mode 100644
index 00000000000..9dac1b875c1
--- /dev/null
+++ b/drivers/media/tuners/qm1d1b0004.c
@@ -0,0 +1,264 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Sharp QM1D1B0004 satellite tuner
+ *
+ * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
+ *
+ * based on (former) drivers/media/pci/pt1/va1j5jf8007s.c.
+ */
+
+/*
+ * Note:
+ * Since the data-sheet of this tuner chip is not available,
+ * this driver lacks some tuner_ops and config options.
+ * In addition, the implementation might be dependent on the specific use
+ * in the FE module: VA1J5JF8007S and/or in the product: Earthsoft PT1/PT2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <media/dvb_frontend.h>
+#include "qm1d1b0004.h"
+
+/*
+ * Tuner I/F (copied from the former va1j5jf8007s.c)
+ * b[0] I2C addr
+ * b[1] "0":1, BG:2, divider_quotient[7:3]:5
+ * b[2] divider_quotient[2:0]:3, divider_remainder:5
+ * b[3] "111":3, LPF[3:2]:2, TM:1, "0":1, REF:1
+ * b[4] BANDX, PSC:1, LPF[1:0]:2, DIV:1, "0":1
+ *
+ * PLL frequency step :=
+ *    REF == 0 -> PLL XTL frequency(4MHz) / 8
+ *    REF == 1 -> PLL XTL frequency(4MHz) / 4
+ *
+ * PreScaler :=
+ *    PSC == 0 -> x32
+ *    PSC == 1 -> x16
+ *
+ * divider_quotient := (frequency / PLL frequency step) / PreScaler
+ * divider_remainder := (frequency / PLL frequency step) % PreScaler
+ *
+ * LPF := LPF Frequency / 1000 / 2 - 2
+ * LPF Frequency @ baudrate=28.86Mbps = 30000
+ *
+ * band (1..9)
+ *   band 1 (freq <  986000) -> DIV:1, BANDX:5, PSC:1
+ *   band 2 (freq < 1072000) -> DIV:1, BANDX:6, PSC:1
+ *   band 3 (freq < 1154000) -> DIV:1, BANDX:7, PSC:0
+ *   band 4 (freq < 1291000) -> DIV:0, BANDX:1, PSC:0
+ *   band 5 (freq < 1447000) -> DIV:0, BANDX:2, PSC:0
+ *   band 6 (freq < 1615000) -> DIV:0, BANDX:3, PSC:0
+ *   band 7 (freq < 1791000) -> DIV:0, BANDX:4, PSC:0
+ *   band 8 (freq < 1972000) -> DIV:0, BANDX:5, PSC:0
+ *   band 9 (freq < 2150000) -> DIV:0, BANDX:6, PSC:0
+ */
+
+#define QM1D1B0004_PSC_MASK (1 << 4)
+
+#define QM1D1B0004_XTL_FREQ 4000
+#define QM1D1B0004_LPF_FALLBACK 30000
+
+static const struct qm1d1b0004_config default_cfg = {
+	.lpf_freq = QM1D1B0004_CFG_LPF_DFLT,
+	.half_step = false,
+};
+
+struct qm1d1b0004_state {
+	struct qm1d1b0004_config cfg;
+	struct i2c_client *i2c;
+};
+
+
+struct qm1d1b0004_cb_map {
+	u32 frequency;
+	u8 cb;
+};
+
+static const struct qm1d1b0004_cb_map cb_maps[] = {
+	{  986000, 0xb2 },
+	{ 1072000, 0xd2 },
+	{ 1154000, 0xe2 },
+	{ 1291000, 0x20 },
+	{ 1447000, 0x40 },
+	{ 1615000, 0x60 },
+	{ 1791000, 0x80 },
+	{ 1972000, 0xa0 },
+};
+
+static u8 lookup_cb(u32 frequency)
+{
+	int i;
+	const struct qm1d1b0004_cb_map *map;
+
+	for (i = 0; i < ARRAY_SIZE(cb_maps); i++) {
+		map = &cb_maps[i];
+		if (frequency < map->frequency)
+			return map->cb;
+	}
+	return 0xc0;
+}
+
+static int qm1d1b0004_set_params(struct dvb_frontend *fe)
+{
+	struct qm1d1b0004_state *state;
+	u32 frequency, pll, lpf_freq;
+	u16 word;
+	u8 buf[4], cb, lpf;
+	int ret;
+
+	state = fe->tuner_priv;
+	frequency = fe->dtv_property_cache.frequency;
+
+	pll = QM1D1B0004_XTL_FREQ / 4;
+	if (state->cfg.half_step)
+		pll /= 2;
+	word = DIV_ROUND_CLOSEST(frequency, pll);
+	cb = lookup_cb(frequency);
+	if (cb & QM1D1B0004_PSC_MASK)
+		word = (word << 1 & ~0x1f) | (word & 0x0f);
+
+	/* step.1: set frequency with BG:2, TM:0(4MHZ), LPF:4MHz */
+	buf[0] = 0x40 | word >> 8;
+	buf[1] = word;
+	/* inconsisnten with the above I/F doc. maybe the doc is wrong */
+	buf[2] = 0xe0 | state->cfg.half_step;
+	buf[3] = cb;
+	ret = i2c_master_send(state->i2c, buf, 4);
+	if (ret < 0)
+		return ret;
+
+	/* step.2: set TM:1 */
+	buf[0] = 0xe4 | state->cfg.half_step;
+	ret = i2c_master_send(state->i2c, buf, 1);
+	if (ret < 0)
+		return ret;
+	msleep(20);
+
+	/* step.3: set LPF */
+	lpf_freq = state->cfg.lpf_freq;
+	if (lpf_freq == QM1D1B0004_CFG_LPF_DFLT)
+		lpf_freq = fe->dtv_property_cache.symbol_rate / 1000;
+	if (lpf_freq == 0)
+		lpf_freq = QM1D1B0004_LPF_FALLBACK;
+	lpf = DIV_ROUND_UP(lpf_freq, 2000) - 2;
+	buf[0] = 0xe4 | ((lpf & 0x0c) << 1) | state->cfg.half_step;
+	buf[1] = cb | ((lpf & 0x03) << 2);
+	ret = i2c_master_send(state->i2c, buf, 2);
+	if (ret < 0)
+		return ret;
+
+	/* step.4: read PLL lock? */
+	buf[0] = 0;
+	ret = i2c_master_recv(state->i2c, buf, 1);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+
+static int qm1d1b0004_set_config(struct dvb_frontend *fe, void *priv_cfg)
+{
+	struct qm1d1b0004_state *state;
+
+	state = fe->tuner_priv;
+	memcpy(&state->cfg, priv_cfg, sizeof(state->cfg));
+	return 0;
+}
+
+
+static int qm1d1b0004_init(struct dvb_frontend *fe)
+{
+	struct qm1d1b0004_state *state;
+	u8 buf[2] = {0xf8, 0x04};
+
+	state = fe->tuner_priv;
+	if (state->cfg.half_step)
+		buf[0] |= 0x01;
+
+	return i2c_master_send(state->i2c, buf, 2);
+}
+
+
+static const struct dvb_tuner_ops qm1d1b0004_ops = {
+	.info = {
+		.name = "Sharp qm1d1b0004",
+
+		.frequency_min =  950000,
+		.frequency_max = 2150000,
+	},
+
+	.init = qm1d1b0004_init,
+
+	.set_params = qm1d1b0004_set_params,
+	.set_config = qm1d1b0004_set_config,
+};
+
+static int
+qm1d1b0004_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	struct dvb_frontend *fe;
+	struct qm1d1b0004_config *cfg;
+	struct qm1d1b0004_state *state;
+	int ret;
+
+	cfg = client->dev.platform_data;
+	fe = cfg->fe;
+	i2c_set_clientdata(client, fe);
+
+	fe->tuner_priv = kzalloc(sizeof(struct qm1d1b0004_state), GFP_KERNEL);
+	if (!fe->tuner_priv) {
+		ret = -ENOMEM;
+		goto err_mem;
+	}
+
+	memcpy(&fe->ops.tuner_ops, &qm1d1b0004_ops, sizeof(fe->ops.tuner_ops));
+
+	state = fe->tuner_priv;
+	state->i2c = client;
+	ret = qm1d1b0004_set_config(fe, cfg);
+	if (ret != 0)
+		goto err_priv;
+
+	dev_info(&client->dev, "Sharp QM1D1B0004 attached.\n");
+	return 0;
+
+err_priv:
+	kfree(fe->tuner_priv);
+err_mem:
+	fe->tuner_priv = NULL;
+	return ret;
+}
+
+static int qm1d1b0004_remove(struct i2c_client *client)
+{
+	struct dvb_frontend *fe;
+
+	fe = i2c_get_clientdata(client);
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+	return 0;
+}
+
+
+static const struct i2c_device_id qm1d1b0004_id[] = {
+	{"qm1d1b0004", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, qm1d1b0004_id);
+
+static struct i2c_driver qm1d1b0004_driver = {
+	.driver = {
+		.name = "qm1d1b0004",
+	},
+	.probe    = qm1d1b0004_probe,
+	.remove   = qm1d1b0004_remove,
+	.id_table = qm1d1b0004_id,
+};
+
+module_i2c_driver(qm1d1b0004_driver);
+
+MODULE_DESCRIPTION("Sharp QM1D1B0004");
+MODULE_AUTHOR("Akihiro Tsukada");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/qm1d1b0004.h b/drivers/media/tuners/qm1d1b0004.h
new file mode 100644
index 00000000000..7734ed109a2
--- /dev/null
+++ b/drivers/media/tuners/qm1d1b0004.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Sharp QM1D1B0004 satellite tuner
+ *
+ * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
+ */
+
+#ifndef QM1D1B0004_H
+#define QM1D1B0004_H
+
+#include <media/dvb_frontend.h>
+
+struct qm1d1b0004_config {
+	struct dvb_frontend *fe;
+
+	u32 lpf_freq;   /* LPF frequency[kHz]. Default: symbol rate */
+	bool half_step; /* use PLL frequency step of 500Hz istead of 1000Hz */
+};
+
+/* special values indicating to use the default in qm1d1b0004_config */
+#define QM1D1B0004_CFG_PLL_DFLT 0
+#define QM1D1B0004_CFG_LPF_DFLT 0
+
+#endif
-- 
2.16.3
