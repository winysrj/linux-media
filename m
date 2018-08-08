Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:4065 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbeHHHnb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Aug 2018 03:43:31 -0400
From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: [PATCH v2 6/7] media: uniphier: add platform driver module of HSC
Date: Wed,  8 Aug 2018 14:25:18 +0900
Message-Id: <20180808052519.14528-7-suzuki.katsuhiro@socionext.com>
In-Reply-To: <20180808052519.14528-1-suzuki.katsuhiro@socionext.com>
References: <20180808052519.14528-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds common platform driver module of HSC (High speed
Stream Controller) driver for Socionext UniPhier SoCs.

Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>

---

Changes from v1:
  - Add DMA mask
  - Fix compile error if build as module
  - Add missing MODULE_AUTHOR, DESCRIPTION and LICENSE
  - Replace enum that has special value into #define
  - Use hardware spec table to remove weird macro from register
    definitions
  - Fix include lines
---
 drivers/media/platform/uniphier/Makefile   |   2 +-
 drivers/media/platform/uniphier/hsc-core.c | 515 +++++++++++++++++++++
 drivers/media/platform/uniphier/hsc-reg.h  |  25 +
 drivers/media/platform/uniphier/hsc.h      |  10 +
 4 files changed, 551 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/uniphier/hsc-core.c

diff --git a/drivers/media/platform/uniphier/Makefile b/drivers/media/platform/uniphier/Makefile
index 79b4dc44df94..d17e001a7195 100644
--- a/drivers/media/platform/uniphier/Makefile
+++ b/drivers/media/platform/uniphier/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-uniphier-dvb-y += hsc-dma.o hsc-css.o hsc-ts.o hsc-ucode.o
+uniphier-dvb-y += hsc-dma.o hsc-css.o hsc-ts.o hsc-ucode.o hsc-core.o
 
 obj-$(CONFIG_DVB_UNIPHIER) += uniphier-dvb.o
diff --git a/drivers/media/platform/uniphier/hsc-core.c b/drivers/media/platform/uniphier/hsc-core.c
new file mode 100644
index 000000000000..464568e90297
--- /dev/null
+++ b/drivers/media/platform/uniphier/hsc-core.c
@@ -0,0 +1,515 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
+//
+// Copyright (c) 2018 Socionext Inc.
+
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+
+#include "hsc.h"
+#include "hsc-reg.h"
+
+#define SZ_TS_PKT      188
+#define SZ_M2TS_PKT    192
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nums);
+
+static int hsc_start_feed(struct dvb_demux_feed *feed)
+{
+	struct hsc_tsif *tsif = feed->demux->priv;
+	struct hsc_dmaif *dmaif = tsif->dmaif;
+	struct hsc_chip *chip = tsif->chip;
+
+	tsif->running = true;
+	dmaif->running = true;
+
+	hsc_ts_in_set_enable(chip, tsif->tsi, true);
+
+	hsc_dma_out_set_src_ts_in(&dmaif->dma_out, tsif->tsi);
+	hsc_dma_out_start(&dmaif->dma_out, true);
+
+	return 0;
+}
+
+static int hsc_stop_feed(struct dvb_demux_feed *feed)
+{
+	struct hsc_tsif *tsif = feed->demux->priv;
+	struct hsc_dmaif *dmaif = tsif->dmaif;
+	struct hsc_chip *chip = tsif->chip;
+
+	hsc_ts_in_set_enable(chip, tsif->tsi, false);
+
+	hsc_dma_out_start(&dmaif->dma_out, false);
+
+	tsif->running = false;
+	dmaif->running = false;
+
+	return 0;
+}
+
+int hsc_register_dvb(struct hsc_tsif *tsif)
+{
+	struct device *dev = &tsif->chip->pdev->dev;
+	int ret;
+
+	tsif->adapter.priv = tsif;
+	ret = dvb_register_adapter(&tsif->adapter, "uniphier-hsc",
+				   THIS_MODULE, dev, adapter_nums);
+	if (ret < 0) {
+		dev_err(dev, "Failed to register DVB adapter: %d\n", ret);
+		return ret;
+	}
+	tsif->valid_adapter = true;
+
+	tsif->demux.dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING;
+	tsif->demux.priv = tsif;
+	tsif->demux.feednum = 256;
+	tsif->demux.filternum = 256;
+	tsif->demux.start_feed = hsc_start_feed;
+	tsif->demux.stop_feed = hsc_stop_feed;
+	tsif->demux.write_to_decoder = NULL;
+	ret = dvb_dmx_init(&tsif->demux);
+	if (ret) {
+		dev_err(dev, "Failed to register demux: %d\n", ret);
+		goto err_out_adapter;
+	}
+	tsif->valid_demux = true;
+
+	tsif->dmxdev.filternum = 256;
+	tsif->dmxdev.demux = &tsif->demux.dmx;
+	tsif->dmxdev.capabilities = 0;
+	ret = dvb_dmxdev_init(&tsif->dmxdev, &tsif->adapter);
+	if (ret) {
+		dev_err(dev, "Failed to register demux dev: %d\n", ret);
+		goto err_out_dmx;
+	}
+	tsif->valid_dmxdev = true;
+
+	ret = dvb_register_frontend(&tsif->adapter, tsif->fe);
+	if (ret) {
+		dev_err(dev, "Failed to register adapter: %d\n", ret);
+		goto err_out_dmxdev;
+	}
+	tsif->valid_fe = true;
+
+	return 0;
+
+err_out_dmxdev:
+	dvb_dmxdev_release(&tsif->dmxdev);
+
+err_out_dmx:
+	dvb_dmx_release(&tsif->demux);
+
+err_out_adapter:
+	dvb_unregister_adapter(&tsif->adapter);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hsc_register_dvb);
+
+void hsc_unregister_dvb(struct hsc_tsif *tsif)
+{
+	if (tsif->valid_fe)
+		dvb_unregister_frontend(tsif->fe);
+	if (tsif->valid_dmxdev)
+		dvb_dmxdev_release(&tsif->dmxdev);
+	if (tsif->valid_demux)
+		dvb_dmx_release(&tsif->demux);
+	if (tsif->valid_adapter)
+		dvb_unregister_adapter(&tsif->adapter);
+}
+EXPORT_SYMBOL_GPL(hsc_unregister_dvb);
+
+static bool is_tsi_error(struct hsc_tsif *tsif, u32 status)
+{
+	if (status & (TSI_INTR_SERR | TSI_INTR_SOF | TSI_INTR_TOF))
+		return true;
+
+	return false;
+}
+
+static void hsc_tsif_recover_worker(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct hsc_tsif *tsif = container_of(dwork,
+		struct hsc_tsif, recover_work);
+	struct hsc_chip *chip = tsif->chip;
+
+	if (!tsif->running)
+		return;
+
+	hsc_ts_in_set_enable(chip, tsif->tsi, true);
+}
+
+static irqreturn_t hsc_tsif_irq(int irq, void *p)
+{
+	struct platform_device *pdev = p;
+	struct hsc_chip *chip = platform_get_drvdata(pdev);
+	irqreturn_t result = IRQ_NONE;
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(chip->tsif); i++) {
+		struct hsc_tsif *tsif = &chip->tsif[i];
+		u32 st;
+
+		if (!tsif->running)
+			continue;
+
+		ret = hsc_ts_in_get_intr(chip, tsif->tsi, &st);
+		if (ret || !st)
+			continue;
+
+		hsc_ts_in_clear_intr(chip, tsif->tsi, 0xffff);
+
+		if (is_tsi_error(tsif, st))
+			schedule_delayed_work(&tsif->recover_work,
+					      tsif->recover_delay);
+
+		result = IRQ_HANDLED;
+	}
+
+	return result;
+}
+
+int hsc_tsif_init(struct hsc_tsif *tsif, const struct hsc_conf *conf)
+{
+	struct hsc_chip *chip = tsif->chip;
+	int ret;
+
+	if (!conf)
+		return -EINVAL;
+
+	tsif->css_in = conf->css_in;
+	tsif->css_out = conf->css_out;
+	tsif->dpll = conf->dpll;
+
+	tsif->tsi = hsc_css_out_to_ts_in(tsif->css_out);
+	if (tsif->tsi == -1)
+		return -EINVAL;
+
+	tsif->dpll_src = hsc_css_out_to_dpll_src(tsif->css_out);
+	if (tsif->dpll_src == -1)
+		return -EINVAL;
+
+	ret = hsc_css_out_set_src(chip, tsif->css_in, tsif->css_out, true);
+	if (ret)
+		return ret;
+
+	ret = hsc_css_in_set_polarity(chip, tsif->css_in, false, false, false);
+	if (ret)
+		return ret;
+
+	ret = hsc_ts_in_set_dmaparam(chip, tsif->tsi, HSC_TSIF_MPEG2_TS_ATS);
+	if (ret)
+		return ret;
+
+	ret = hsc_dpll_set_src(chip, tsif->dpll, tsif->dpll_src);
+	if (ret)
+		return ret;
+
+	INIT_DELAYED_WORK(&tsif->recover_work, hsc_tsif_recover_worker);
+	tsif->recover_delay = HZ / 10;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hsc_tsif_init);
+
+void hsc_tsif_release(struct hsc_tsif *tsif)
+{
+	cancel_delayed_work(&tsif->recover_work);
+}
+EXPORT_SYMBOL_GPL(hsc_tsif_release);
+
+static void hsc_dmaif_feed_worker(struct work_struct *work)
+{
+	struct hsc_dmaif *dmaif = container_of(work,
+		struct hsc_dmaif, feed_work);
+	struct hsc_tsif *tsif = dmaif->tsif;
+	struct hsc_dma_buf *buf = &dmaif->buf_out;
+	struct device *dev = &dmaif->chip->pdev->dev;
+	dma_addr_t dmapos;
+	u8 *pkt;
+	u64 cnt, i;
+	int wrap = 0;
+
+	if (!dmaif->running)
+		return;
+
+retry:
+	spin_lock(&dmaif->lock);
+	hsc_dma_out_sync(&dmaif->dma_out);
+	spin_unlock(&dmaif->lock);
+
+	dmapos = buf->phys + buf->rd_offs;
+	cnt = hsc_rb_cnt_to_end(buf);
+	cnt = DIV_ROUND_DOWN_ULL(cnt, SZ_M2TS_PKT) * SZ_M2TS_PKT;
+
+	dma_sync_single_for_cpu(dev, dmapos, cnt, DMA_FROM_DEVICE);
+	for (i = 0; i < cnt; i += SZ_M2TS_PKT) {
+		pkt = buf->virt + buf->rd_offs + i;
+		dvb_dmx_swfilter_packets(&tsif->demux, &pkt[4], 1);
+	}
+	dma_sync_single_for_device(dev, dmapos, cnt, DMA_FROM_DEVICE);
+
+	spin_lock(&dmaif->lock);
+
+	buf->rd_offs += cnt;
+	if (buf->rd_offs >= buf->size)
+		buf->rd_offs -= buf->size;
+
+	buf->chk_offs = buf->wr_offs + buf->size_chk;
+	if (buf->chk_offs >= buf->size)
+		buf->chk_offs -= buf->size;
+
+	if (!wrap && hsc_rb_cnt(buf) >= buf->size_chk / 2) {
+		wrap = 1;
+		spin_unlock(&dmaif->lock);
+		goto retry;
+	}
+
+	hsc_dma_out_sync(&dmaif->dma_out);
+
+	spin_unlock(&dmaif->lock);
+}
+
+static irqreturn_t hsc_dmaif_irq(int irq, void *p)
+{
+	struct platform_device *pdev = p;
+	struct hsc_chip *chip = platform_get_drvdata(pdev);
+	irqreturn_t result = IRQ_NONE;
+	int i, ret;
+	u32 st;
+
+	for (i = 0; i < ARRAY_SIZE(chip->tsif); i++) {
+		struct hsc_dmaif *dmaif = &chip->dmaif[i];
+
+		if (!dmaif->running)
+			continue;
+
+		ret = hsc_dma_out_get_intr(&dmaif->dma_out, &st);
+		if (ret || !st)
+			continue;
+
+		hsc_dma_out_clear_intr(&dmaif->dma_out, 0xffff);
+
+		spin_lock(&dmaif->lock);
+		hsc_dma_out_sync(&dmaif->dma_out);
+		spin_unlock(&dmaif->lock);
+
+		schedule_work(&dmaif->feed_work);
+
+		result = IRQ_HANDLED;
+	}
+
+	return result;
+}
+
+int hsc_dmaif_init(struct hsc_dmaif *dmaif, const struct hsc_conf *conf)
+{
+	struct hsc_chip *chip = dmaif->chip;
+	struct hsc_dma_buf *buf = &dmaif->buf_out;
+	struct device *dev = &chip->pdev->dev;
+	int ret;
+
+	if (!conf)
+		return -EINVAL;
+
+	ret = hsc_dma_out_init(&dmaif->dma_out, chip, conf->dma_out, buf);
+	if (ret)
+		return ret;
+
+	buf->size = HSC_DMAIF_TS_BUFSIZE;
+	buf->size_chk = HSC_DMAIF_TS_BUFSIZE / 4;
+	buf->virt = dma_alloc_coherent(dev, buf->size, &buf->phys, GFP_KERNEL);
+	if (!buf->virt)
+		return -ENOMEM;
+
+	spin_lock_init(&dmaif->lock);
+	INIT_WORK(&dmaif->feed_work, hsc_dmaif_feed_worker);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hsc_dmaif_init);
+
+void hsc_dmaif_release(struct hsc_dmaif *dmaif)
+{
+	struct hsc_chip *chip = dmaif->chip;
+	struct device *dev = &chip->pdev->dev;
+
+	flush_scheduled_work();
+
+	dma_free_coherent(dev, dmaif->buf_out.size, dmaif->buf_out.virt,
+			  dmaif->buf_out.phys);
+}
+EXPORT_SYMBOL_GPL(hsc_dmaif_release);
+
+static const struct regmap_config hsc_regmap_config = {
+	.reg_bits      = 32,
+	.reg_stride    = 4,
+	.val_bits      = 32,
+	.max_register  = 0xffffc,
+	.cache_type    = REGCACHE_NONE,
+};
+
+static int hsc_probe(struct platform_device *pdev)
+{
+	struct hsc_chip *chip;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	void __iomem *preg;
+	int irq, ret, i;
+
+	chip = devm_kzalloc(dev, sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+	chip->pdev = pdev;
+
+	chip->spec = of_device_get_match_data(dev);
+	if (!chip->spec)
+		return -EINVAL;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	preg = devm_ioremap_resource(dev, res);
+	if (IS_ERR(preg))
+		return PTR_ERR(preg);
+
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(33));
+	if (ret)
+		return ret;
+
+	chip->regmap = devm_regmap_init_mmio(dev, preg,
+					     &hsc_regmap_config);
+	if (IS_ERR(chip->regmap))
+		return PTR_ERR(chip->regmap);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(dev, "Could not get irq for TS I/F\n");
+		return irq;
+	}
+
+	ret = devm_request_irq(dev, irq, hsc_tsif_irq, IRQF_SHARED,
+			       dev_name(dev), pdev);
+	if (ret)
+		return ret;
+
+	irq = platform_get_irq(pdev, 1);
+	if (irq < 0) {
+		dev_err(dev, "Could not get irq for DMA I/F\n");
+		return irq;
+	}
+
+	ret = devm_request_irq(dev, irq, hsc_dmaif_irq, IRQF_SHARED,
+			       dev_name(dev), pdev);
+	if (ret)
+		return ret;
+
+	chip->clk_stdmac = devm_clk_get(dev, "stdmac");
+	if (IS_ERR(chip->clk_stdmac))
+		return PTR_ERR(chip->clk_stdmac);
+
+	chip->clk_hsc = devm_clk_get(dev, "hsc");
+	if (IS_ERR(chip->clk_hsc))
+		return PTR_ERR(chip->clk_hsc);
+
+	chip->rst_stdmac = devm_reset_control_get_shared(dev, "stdmac");
+	if (IS_ERR(chip->rst_stdmac))
+		return PTR_ERR(chip->rst_stdmac);
+
+	chip->rst_hsc = devm_reset_control_get_shared(dev, "hsc");
+	if (IS_ERR(chip->rst_hsc))
+		return PTR_ERR(chip->rst_hsc);
+
+	ret = clk_prepare_enable(chip->clk_stdmac);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(chip->clk_hsc);
+	if (ret)
+		goto err_out_clk_stdmac;
+
+	ret = reset_control_deassert(chip->rst_stdmac);
+	if (ret)
+		goto err_out_clk_hsc;
+
+	ret = reset_control_deassert(chip->rst_hsc);
+	if (ret)
+		goto err_out_rst_stdmac;
+
+	ret = hsc_ucode_load_all(chip);
+	if (ret)
+		goto err_out_rst_hsc;
+
+	for (i = 0; i < HSC_STREAM_IF_NUM; i++) {
+		chip->dmaif[i].chip = chip;
+		chip->dmaif[i].tsif = &chip->tsif[i];
+		chip->tsif[i].chip = chip;
+		chip->tsif[i].dmaif = &chip->dmaif[i];
+	}
+
+	platform_set_drvdata(pdev, chip);
+
+	return 0;
+
+err_out_rst_hsc:
+	reset_control_assert(chip->rst_hsc);
+
+err_out_rst_stdmac:
+	reset_control_assert(chip->rst_stdmac);
+
+err_out_clk_hsc:
+	clk_disable_unprepare(chip->clk_hsc);
+
+err_out_clk_stdmac:
+	clk_disable_unprepare(chip->clk_stdmac);
+
+	return ret;
+}
+
+static int hsc_remove(struct platform_device *pdev)
+{
+	struct hsc_chip *chip = platform_get_drvdata(pdev);
+
+	hsc_ucode_unload_all(chip);
+
+	reset_control_assert(chip->rst_hsc);
+	reset_control_assert(chip->rst_stdmac);
+	clk_disable_unprepare(chip->clk_hsc);
+	clk_disable_unprepare(chip->clk_stdmac);
+
+	return 0;
+}
+
+static const struct of_device_id uniphier_hsc_of_match[] = {
+	{
+		.compatible = "socionext,uniphier-ld11-hsc",
+		.data = &uniphier_hsc_ld11_spec,
+	},
+	{
+		.compatible = "socionext,uniphier-ld20-hsc",
+		.data = &uniphier_hsc_ld20_spec,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, uniphier_hsc_of_match);
+
+static struct platform_driver uniphier_hsc_driver = {
+	.driver = {
+		.name = "uniphier-hsc",
+		.of_match_table = of_match_ptr(uniphier_hsc_of_match),
+	},
+	.probe  = hsc_probe,
+	.remove = hsc_remove,
+};
+module_platform_driver(uniphier_hsc_driver);
+
+MODULE_AUTHOR("Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>");
+MODULE_DESCRIPTION("UniPhier DVB driver for HSC.");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/platform/uniphier/hsc-reg.h b/drivers/media/platform/uniphier/hsc-reg.h
index 1ca3ad55330f..69aa37caefce 100644
--- a/drivers/media/platform/uniphier/hsc-reg.h
+++ b/drivers/media/platform/uniphier/hsc-reg.h
@@ -8,6 +8,31 @@
 #ifndef DVB_UNIPHIER_HSC_REG_H__
 #define DVB_UNIPHIER_HSC_REG_H__
 
+/* RAM Address */
+#define FLT_PATN_RAM_TOP_ADDR           0x0a000
+#define FLT_MASK_RAM_TOP_ADDR           0x0b000
+#define SHARE_MEMORY_0_NORMAL           0x10000
+#define SHARE_MEMORY_1_NORMAL           0x11000
+#define SHARE_MEMORY_2_NORMAL           0x12000
+#define SHARE_MEMORY_3_NORMAL           0x13000
+#define SHARE_MEMORY_4_NORMAL           0x14000
+#define SHARE_MEMORY_5_NORMAL           0x15000
+#define SHARE_MEMORY_6_NORMAL           0x16000
+#define SHARE_MEMORY_7_NORMAL           0x17000
+
+/* RAM size */
+#define FLT_PATN_RAM_SIZE               0x0800
+#define FLT_MASK_RAM_SIZE               0x0800
+#define FLT_PIDPATTERN_SIZE             0x0160
+#define SHARE_MEMORY_0_SIZE             0x1000
+#define SHARE_MEMORY_1_SIZE             0x1000
+#define SHARE_MEMORY_2_SIZE             0x1000
+#define SHARE_MEMORY_3_SIZE             0x1000
+#define SHARE_MEMORY_4_SIZE             0x1000
+#define SHARE_MEMORY_5_SIZE             0x1000
+#define SHARE_MEMORY_6_SIZE             0x1000
+#define SHARE_MEMORY_7_SIZE             0x1000
+
 /* IOB1, 2, 3 */
 #define IOB_PKTCNT                    0x1740
 #define IOB_PKTCNTRST                 0x1744
diff --git a/drivers/media/platform/uniphier/hsc.h b/drivers/media/platform/uniphier/hsc.h
index bbfd90ffaad5..e60c80ac55e6 100644
--- a/drivers/media/platform/uniphier/hsc.h
+++ b/drivers/media/platform/uniphier/hsc.h
@@ -376,4 +376,14 @@ void hsc_dma_out_clear_intr(struct hsc_dma *dma_out, u32 clear);
 int hsc_ucode_load_all(struct hsc_chip *chip);
 int hsc_ucode_unload_all(struct hsc_chip *chip);
 
+/* For Adapter */
+int hsc_register_dvb(struct hsc_tsif *tsif);
+void hsc_unregister_dvb(struct hsc_tsif *tsif);
+int hsc_tsif_init(struct hsc_tsif *tsif, const struct hsc_conf *conf);
+void hsc_tsif_release(struct hsc_tsif *tsif);
+int hsc_dmaif_init(struct hsc_dmaif *dmaif, const struct hsc_conf *conf);
+void hsc_dmaif_release(struct hsc_dmaif *dmaif);
+extern const struct hsc_spec uniphier_hsc_ld11_spec;
+extern const struct hsc_spec uniphier_hsc_ld20_spec;
+
 #endif /* DVB_UNIPHIER_HSC_H__ */
-- 
2.18.0
