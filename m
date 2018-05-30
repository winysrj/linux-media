Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:35850 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968819AbeE3JJw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 05:09:52 -0400
From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: [PATCH 3/8] media: uniphier: add submodules of HSC MPEG2-TS I/O driver
Date: Wed, 30 May 2018 18:09:41 +0900
Message-Id: <20180530090946.1635-4-suzuki.katsuhiro@socionext.com>
In-Reply-To: <20180530090946.1635-1-suzuki.katsuhiro@socionext.com>
References: <20180530090946.1635-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds submodules of HSC for UniPhier SoCs.
These work as follows:
  ucode: Load uCode and start subsystems
  css  : Switch stream path
  ts   : Receive MPEG2-TS clock and signal
  dma  : Transfer MPEG2-TS data bytes to main memory

Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
---
 drivers/media/platform/uniphier/Makefile    |   3 +
 drivers/media/platform/uniphier/hsc-css.c   | 258 ++++++++++++
 drivers/media/platform/uniphier/hsc-dma.c   | 302 ++++++++++++++
 drivers/media/platform/uniphier/hsc-ts.c    |  99 +++++
 drivers/media/platform/uniphier/hsc-ucode.c | 436 ++++++++++++++++++++
 5 files changed, 1098 insertions(+)
 create mode 100644 drivers/media/platform/uniphier/hsc-css.c
 create mode 100644 drivers/media/platform/uniphier/hsc-dma.c
 create mode 100644 drivers/media/platform/uniphier/hsc-ts.c
 create mode 100644 drivers/media/platform/uniphier/hsc-ucode.c

diff --git a/drivers/media/platform/uniphier/Makefile b/drivers/media/platform/uniphier/Makefile
index f66554cd5c45..92536bc56b31 100644
--- a/drivers/media/platform/uniphier/Makefile
+++ b/drivers/media/platform/uniphier/Makefile
@@ -1 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
+uniphier-dvb-y += hsc-ucode.o hsc-css.o hsc-ts.o hsc-dma.o
+
+obj-$(CONFIG_DVB_UNIPHIER) += uniphier-dvb.o
diff --git a/drivers/media/platform/uniphier/hsc-css.c b/drivers/media/platform/uniphier/hsc-css.c
new file mode 100644
index 000000000000..baa0a15ca98e
--- /dev/null
+++ b/drivers/media/platform/uniphier/hsc-css.c
@@ -0,0 +1,258 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
+// CSS (Cross Stream Switch) connects MPEG2-TS input port and output port.
+//
+// Copyright (c) 2018 Socionext Inc.
+
+#include <linux/bitfield.h>
+#include <linux/kernel.h>
+
+#include "hsc.h"
+#include "hsc-reg.h"
+
+enum HSC_TS_IN hsc_css_out_to_ts_in(enum HSC_CSS_OUT out)
+{
+	if (out >= HSC_CSS_OUT_TSI0 && out <= HSC_CSS_OUT_TSI9)
+		return HSC_TSI0 + (out - HSC_CSS_OUT_TSI0);
+
+	return -1;
+}
+
+enum HSC_DPLL_SRC hsc_css_out_to_dpll_src(enum HSC_CSS_OUT out)
+{
+	if (out >= HSC_CSS_OUT_TSI0 && out <= HSC_CSS_OUT_TSI9)
+		return HSC_DPLL_SRC_TSI0 + (out - HSC_CSS_OUT_TSI0);
+
+	return -1;
+}
+
+static bool css_in_is_valid(struct hsc_chip *chip, enum HSC_CSS_IN in)
+{
+	if (in >= chip->spec->num_css_in)
+		return false;
+
+	return true;
+}
+
+static bool css_out_is_valid(struct hsc_chip *chip, enum HSC_CSS_OUT out)
+{
+	if (out >= chip->spec->num_css_out)
+		return false;
+
+	return true;
+}
+
+static const struct hsc_spec_css_in *css_in_get_spec(struct hsc_chip *chip,
+						     enum HSC_CSS_IN in)
+{
+	const struct hsc_spec_css_in *spec = chip->spec->css_in;
+
+	if (!css_in_is_valid(chip, in))
+		return NULL;
+
+	return &spec[in];
+}
+
+static const struct hsc_spec_css_out *css_out_get_spec(struct hsc_chip *chip,
+						       enum HSC_CSS_OUT out)
+{
+	const struct hsc_spec_css_out *spec = chip->spec->css_out;
+
+	if (!css_out_is_valid(chip, out))
+		return NULL;
+
+	return &spec[out];
+}
+
+int hsc_dpll_get_src(struct hsc_chip *chip, enum HSC_DPLL dpll,
+		     enum HSC_DPLL_SRC *src)
+{
+	struct regmap *r = chip->regmap;
+	u32 v;
+
+	if (!src || dpll >= HSC_DPLL_NUM)
+		return -EINVAL;
+
+	regmap_read(r, CSS_DPCTRL(dpll), &v);
+	*src = ffs(v & CSS_DPCTRL_DPSEL_MASK) - 1;
+
+	return 0;
+}
+
+/**
+ * Select source clock of DPLL.
+ *
+ * @dpll: ID of DPLL
+ * @src : ID of clock source or HSC_DPLL_SRC_NONE to disconnect
+ */
+int hsc_dpll_set_src(struct hsc_chip *chip, enum HSC_DPLL dpll,
+		     enum HSC_DPLL_SRC src)
+{
+	struct regmap *r = chip->regmap;
+	u32 v = 0;
+
+	if (dpll >= HSC_DPLL_NUM || src >= HSC_DPLL_SRC_NUM)
+		return -EINVAL;
+
+	if (src != HSC_DPLL_SRC_NONE)
+		v = 1 << src;
+
+	regmap_write(r, CSS_DPCTRL(dpll), v);
+
+	return 0;
+}
+
+static int hsc_css_get_polarity(struct hsc_chip *chip,
+				const struct hsc_css_pol *pol,
+				bool *sync_bit, bool *val_bit, bool *clk_fall)
+{
+	struct regmap *r = chip->regmap;
+	u32 v;
+
+	if (!sync_bit || !val_bit || !clk_fall || !pol->valid)
+		return -EINVAL;
+
+	regmap_read(r, pol->reg, &v);
+
+	*sync_bit = !!(v & BIT(pol->sft_sync));
+	*val_bit = !!(v & BIT(pol->sft_val));
+	*clk_fall = !!(v & BIT(pol->sft_clk));
+
+	return 0;
+}
+
+/**
+ * Setup signal polarity of TS signals.
+ *
+ * @sync_bit : true : The sync signal keeps only 1bit period.
+ *             false: The sync signal keeps during 8bits period.
+ * @valid_bit: true : The valid signal does not keep during 8bits period.
+ *             false: The valid signal keeps during 8bits period.
+ * @clk_fall : true : Latch the data at falling edge of clock signal.
+ *             false: Latch the data at rising edge of clock signal.
+ */
+static int hsc_css_set_polarity(struct hsc_chip *chip,
+				const struct hsc_css_pol *pol,
+				bool sync_bit, bool val_bit, bool clk_fall)
+{
+	struct regmap *r = chip->regmap;
+	u32 m = 0, v = 0;
+
+	if (!pol->valid)
+		return -EINVAL;
+
+	if (pol->sft_sync != -1) {
+		m |= BIT(pol->sft_sync);
+		if (sync_bit)
+			v |= BIT(pol->sft_sync);
+	}
+
+	if (pol->sft_val != -1) {
+		m |= BIT(pol->sft_val);
+		if (val_bit)
+			v |= BIT(pol->sft_val);
+	}
+
+	if (pol->sft_clk != -1) {
+		m |= BIT(pol->sft_clk);
+		if (clk_fall)
+			v |= BIT(pol->sft_clk);
+	}
+
+	regmap_update_bits(r, pol->reg, m, v);
+
+	return 0;
+}
+
+int hsc_css_in_get_polarity(struct hsc_chip *chip, enum HSC_CSS_IN in,
+			    bool *sync_bit, bool *val_bit, bool *clk_fall)
+{
+	const struct hsc_spec_css_in *speci = css_in_get_spec(chip, in);
+
+	if (!speci)
+		return -EINVAL;
+
+	return hsc_css_get_polarity(chip, &speci->pol,
+				    sync_bit, val_bit, clk_fall);
+}
+
+int hsc_css_in_set_polarity(struct hsc_chip *chip, enum HSC_CSS_IN in,
+			    bool sync_bit, bool val_bit, bool clk_fall)
+{
+	const struct hsc_spec_css_in *speci = css_in_get_spec(chip, in);
+
+	if (!speci)
+		return -EINVAL;
+
+	return hsc_css_set_polarity(chip, &speci->pol,
+				    sync_bit, val_bit, clk_fall);
+}
+
+int hsc_css_out_get_polarity(struct hsc_chip *chip, enum HSC_CSS_OUT out,
+			     bool *sync_bit, bool *val_bit, bool *clk_fall)
+{
+	const struct hsc_spec_css_out *speco = css_out_get_spec(chip, out);
+
+	if (!speco)
+		return -EINVAL;
+
+	return hsc_css_get_polarity(chip, &speco->pol,
+				    sync_bit, val_bit, clk_fall);
+}
+
+int hsc_css_out_set_polarity(struct hsc_chip *chip, enum HSC_CSS_OUT out,
+			     bool sync_bit, bool val_bit, bool clk_fall)
+{
+	const struct hsc_spec_css_out *speco = css_out_get_spec(chip, out);
+
+	if (!speco)
+		return -EINVAL;
+
+	return hsc_css_set_polarity(chip, &speco->pol,
+				    sync_bit, val_bit, clk_fall);
+}
+
+int hsc_css_out_get_src(struct hsc_chip *chip, enum HSC_CSS_IN *in,
+			enum HSC_CSS_OUT out, bool *en)
+{
+	struct regmap *r = chip->regmap;
+	const struct hsc_spec_css_out *speco = css_out_get_spec(chip, out);
+	u32 v;
+
+	if (!in || !en || !speco || !speco->sel.valid)
+		return -EINVAL;
+
+	regmap_read(r, speco->sel.reg, &v);
+	*in = field_get(speco->sel.mask, v);
+
+	regmap_read(r, CSS_OUTPUTENABLE, &v);
+	*en = !!(v & BIT(out));
+
+	return 0;
+}
+
+/**
+ * Connect the input port and output port using CSS (Cross Stream Switch).
+ *
+ * @in   : Input port number.
+ * @out  : Output port number.
+ * @en   : false: Disable this path.
+ *         true : Enable this path.
+ */
+int hsc_css_out_set_src(struct hsc_chip *chip, enum HSC_CSS_IN in,
+			enum HSC_CSS_OUT out, bool en)
+{
+	struct regmap *r = chip->regmap;
+	const struct hsc_spec_css_out *speco = css_out_get_spec(chip, out);
+
+	if (!css_in_is_valid(chip, in) || !speco || !speco->sel.valid)
+		return -EINVAL;
+
+	regmap_update_bits(r, speco->sel.reg, speco->sel.mask,
+			   field_prep(speco->sel.mask, in));
+
+	regmap_update_bits(r, CSS_OUTPUTENABLE, BIT(out), (en) ? ~0 : 0);
+
+	return 0;
+}
diff --git a/drivers/media/platform/uniphier/hsc-dma.c b/drivers/media/platform/uniphier/hsc-dma.c
new file mode 100644
index 000000000000..0b3e471a68f7
--- /dev/null
+++ b/drivers/media/platform/uniphier/hsc-dma.c
@@ -0,0 +1,302 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
+// MPEG2-TS DMA control.
+//
+// Copyright (c) 2018 Socionext Inc.
+
+#include <linux/bitfield.h>
+#include <linux/kernel.h>
+
+#include "hsc.h"
+#include "hsc-reg.h"
+
+u64 hsc_rb_cnt(struct hsc_dma_buf *buf)
+{
+	if (buf->rd_offs <= buf->wr_offs)
+		return buf->wr_offs - buf->rd_offs;
+	else
+		return buf->size - (buf->rd_offs - buf->wr_offs);
+}
+
+u64 hsc_rb_cnt_to_end(struct hsc_dma_buf *buf)
+{
+	if (buf->rd_offs <= buf->wr_offs)
+		return buf->wr_offs - buf->rd_offs;
+	else
+		return buf->size - buf->rd_offs;
+}
+
+u64 hsc_rb_space(struct hsc_dma_buf *buf)
+{
+	if (buf->rd_offs <= buf->wr_offs)
+		return buf->size - (buf->wr_offs - buf->rd_offs) - 8;
+	else
+		return buf->rd_offs - buf->wr_offs - 8;
+}
+
+u64 hsc_rb_space_to_end(struct hsc_dma_buf *buf)
+{
+	if (buf->rd_offs > buf->wr_offs)
+		return buf->rd_offs - buf->wr_offs - 8;
+	else if (buf->rd_offs > 0)
+		return buf->size - buf->wr_offs;
+	else
+		return buf->size - buf->wr_offs - 8;
+}
+
+static void dma_set_buffer(struct hsc_chip *chip, int dma_ch,
+			   u64 bg, u64 ed)
+{
+	struct regmap *r = chip->regmap;
+
+	regmap_write(r, CDMBC_RBBGNADRSD(dma_ch), bg);
+	regmap_write(r, CDMBC_RBBGNADRSU(dma_ch), bg >> 32);
+	regmap_write(r, CDMBC_RBENDADRSD(dma_ch), ed);
+	regmap_write(r, CDMBC_RBENDADRSU(dma_ch), ed >> 32);
+}
+
+static u64 dma_get_rp(struct hsc_chip *chip, int dma_ch)
+{
+	struct regmap *r = chip->regmap;
+	u32 d, u;
+
+	regmap_read(r, CDMBC_RBRDPTRD(dma_ch), &d);
+	regmap_read(r, CDMBC_RBRDPTRU(dma_ch), &u);
+
+	return ((u64)u << 32) | d;
+}
+
+static void dma_set_rp(struct hsc_chip *chip, int dma_ch, u64 pos)
+{
+	struct regmap *r = chip->regmap;
+
+	regmap_write(r, CDMBC_RBRDPTRD(dma_ch), pos);
+	regmap_write(r, CDMBC_RBRDPTRU(dma_ch), pos >> 32);
+}
+
+static u64 dma_get_wp(struct hsc_chip *chip, int dma_ch)
+{
+	struct regmap *r = chip->regmap;
+	u32 d, u;
+
+	regmap_read(r, CDMBC_RBWRPTRD(dma_ch), &d);
+	regmap_read(r, CDMBC_RBWRPTRU(dma_ch), &u);
+
+	return ((u64)u << 32) | d;
+}
+
+static void dma_set_wp(struct hsc_chip *chip, int dma_ch, u64 pos)
+{
+	struct regmap *r = chip->regmap;
+
+	regmap_write(r, CDMBC_RBWRPTRD(dma_ch), pos);
+	regmap_write(r, CDMBC_RBWRPTRU(dma_ch), pos >> 32);
+}
+
+static void dma_set_chkp(struct hsc_chip *chip, int dma_ch, u64 pos)
+{
+	struct regmap *r = chip->regmap;
+
+	regmap_write(r, CDMBC_CHIRADRSD(dma_ch), pos);
+	regmap_write(r, CDMBC_CHIRADRSU(dma_ch), pos >> 32);
+}
+
+static void dma_set_enable(struct hsc_chip *chip, int dma_ch,
+			   const struct hsc_dma_en *dma_en, bool en)
+{
+	struct regmap *r = chip->regmap;
+	u32 v;
+	bool now;
+
+	regmap_read(r, dma_en->reg, &v);
+	now = !!(v & BIT(dma_en->sft_toggle));
+
+	/* Toggle DMA state if needed */
+	if ((en && !now) || (!en && now))
+		regmap_write(r, dma_en->reg, BIT(dma_en->sft_toggle));
+}
+
+static bool dma_in_is_valid(struct hsc_chip *chip, enum HSC_DMA_IN in)
+{
+	if (in >= chip->spec->num_dma_in ||
+	    !chip->spec->dma_in[in].intr.valid)
+		return false;
+
+	return true;
+}
+
+int hsc_dma_in_init(struct hsc_dma_in *dma_in, struct hsc_chip *chip,
+		    enum HSC_DMA_IN in, struct hsc_dma_buf *buf)
+{
+	if (!dma_in || !dma_in_is_valid(chip, in))
+		return -EINVAL;
+
+	dma_in->chip = chip;
+	dma_in->id = in;
+	dma_in->spec = &chip->spec->dma_in[in];
+	dma_in->buf = buf;
+
+	return 0;
+}
+
+void hsc_dma_in_start(struct hsc_dma_in *dma_in, bool en)
+{
+	struct hsc_chip *chip = dma_in->chip;
+	const struct hsc_spec_dma *spec = dma_in->spec;
+	struct hsc_dma_buf *buf = dma_in->buf;
+	struct regmap *r = chip->regmap;
+	u64 bg, ed;
+	u32 v;
+
+	bg = buf->phys;
+	ed = buf->phys + buf->size;
+	dma_set_buffer(chip, spec->dma_ch, bg, ed);
+
+	buf->rd_offs = 0;
+	buf->wr_offs = 0;
+	buf->chk_offs = buf->size_chk;
+	dma_set_rp(chip, spec->dma_ch, buf->rd_offs + buf->phys);
+	dma_set_wp(chip, spec->dma_ch, buf->wr_offs + buf->phys);
+	dma_set_chkp(chip, spec->dma_ch, buf->chk_offs + buf->phys);
+
+	regmap_update_bits(r, CDMBC_CHSRCAMODE(spec->dma_ch),
+			   CDMBC_CHAMODE_TYPE_RB, ~0);
+	regmap_update_bits(r, CDMBC_CHCTRL1(spec->dma_ch),
+			   CDMBC_CHCTRL1_IND_SIZE_UND, ~0);
+
+	v = (en) ? ~0 : 0;
+	regmap_update_bits(r, CDMBC_CHIE(spec->dma_ch), CDMBC_CHI_TRANSIT, v);
+	regmap_update_bits(r, spec->intr.reg, BIT(spec->intr.sft_intr), v);
+
+	dma_set_enable(chip, spec->dma_ch, &spec->en, en);
+}
+
+void hsc_dma_in_sync(struct hsc_dma_in *dma_in)
+{
+	struct hsc_chip *chip = dma_in->chip;
+	const struct hsc_spec_dma *spec = dma_in->spec;
+	struct hsc_dma_buf *buf = dma_in->buf;
+
+	buf->rd_offs = dma_get_rp(chip, spec->dma_ch) - buf->phys;
+	dma_set_wp(chip, spec->dma_ch, buf->rd_offs + buf->phys);
+	dma_set_chkp(chip, spec->dma_ch, buf->chk_offs + buf->phys);
+}
+
+int hsc_dma_in_get_intr(struct hsc_dma_in *dma_in, u32 *stat)
+{
+	struct regmap *r = dma_in->chip->regmap;
+
+	if (!stat)
+		return -EINVAL;
+
+	regmap_read(r, CDMBC_CHID(dma_in->spec->dma_ch), stat);
+
+	return 0;
+}
+
+void hsc_dma_in_clear_intr(struct hsc_dma_in *dma_in, u32 v)
+{
+	struct regmap *r = dma_in->chip->regmap;
+
+	regmap_write(r, CDMBC_CHIR(dma_in->spec->dma_ch), v);
+}
+
+static bool dma_out_is_valid(struct hsc_chip *chip, enum HSC_DMA_OUT out)
+{
+	if (out >= chip->spec->num_dma_out ||
+	    !chip->spec->dma_out[out].intr.valid)
+		return false;
+
+	return true;
+}
+
+int hsc_dma_out_init(struct hsc_dma_out *dma_out, struct hsc_chip *chip,
+		     enum HSC_DMA_OUT out, struct hsc_dma_buf *buf)
+{
+	if (!dma_out || !dma_out_is_valid(chip, out))
+		return -EINVAL;
+
+	dma_out->chip = chip;
+	dma_out->id = out;
+	dma_out->spec = &chip->spec->dma_out[out];
+	dma_out->buf = buf;
+
+	return 0;
+}
+
+void hsc_dma_out_set_src_ts_in(struct hsc_dma_out *dma_out,
+			       enum HSC_TS_IN ts_in)
+{
+	struct regmap *r = dma_out->chip->regmap;
+	const struct hsc_spec_dma *spec = dma_out->spec;
+	u32 m, v;
+
+	m = CDMBC_CHTDCTRLH_STREM_MASK |
+		CDMBC_CHTDCTRLH_ALL_EN;
+	v = FIELD_PREP(CDMBC_CHTDCTRLH_STREM_MASK, ts_in) |
+		CDMBC_CHTDCTRLH_ALL_EN;
+	regmap_update_bits(r, CDMBC_CHTDCTRLH(spec->dma_ch), m, v);
+}
+
+void hsc_dma_out_start(struct hsc_dma_out *dma_out, bool en)
+{
+	struct hsc_chip *chip = dma_out->chip;
+	const struct hsc_spec_dma *spec = dma_out->spec;
+	struct hsc_dma_buf *buf = dma_out->buf;
+	struct regmap *r = chip->regmap;
+	u64 bg, ed;
+	u32 v;
+
+	bg = buf->phys;
+	ed = buf->phys + buf->size;
+	dma_set_buffer(chip, spec->dma_ch, bg, ed);
+
+	buf->rd_offs = 0;
+	buf->wr_offs = 0;
+	buf->chk_offs = buf->size_chk;
+	dma_set_rp(chip, spec->dma_ch, buf->rd_offs + buf->phys);
+	dma_set_wp(chip, spec->dma_ch, buf->wr_offs + buf->phys);
+	dma_set_chkp(chip, spec->dma_ch, buf->chk_offs + buf->phys);
+
+	regmap_update_bits(r, CDMBC_CHDSTAMODE(spec->dma_ch),
+			   CDMBC_CHAMODE_TYPE_RB, ~0);
+	regmap_update_bits(r, CDMBC_CHCTRL1(spec->dma_ch),
+			   CDMBC_CHCTRL1_IND_SIZE_UND, ~0);
+
+	v = (en) ? ~0 : 0;
+	regmap_update_bits(r, CDMBC_CHIE(spec->dma_ch), CDMBC_CHI_TRANSIT, v);
+	regmap_update_bits(r, spec->intr.reg, BIT(spec->intr.sft_intr), v);
+
+	dma_set_enable(chip, spec->dma_ch, &spec->en, en);
+}
+
+void hsc_dma_out_sync(struct hsc_dma_out *dma_out)
+{
+	struct hsc_chip *chip = dma_out->chip;
+	const struct hsc_spec_dma *spec = dma_out->spec;
+	struct hsc_dma_buf *buf = dma_out->buf;
+
+	dma_set_rp(chip, spec->dma_ch, buf->rd_offs + buf->phys);
+	buf->wr_offs = dma_get_wp(chip, spec->dma_ch) - buf->phys;
+	dma_set_chkp(chip, spec->dma_ch, buf->chk_offs + buf->phys);
+}
+
+int hsc_dma_out_get_intr(struct hsc_dma_out *dma_out, u32 *stat)
+{
+	struct regmap *r = dma_out->chip->regmap;
+
+	if (!stat)
+		return -EINVAL;
+
+	regmap_read(r, CDMBC_CHID(dma_out->spec->dma_ch), stat);
+
+	return 0;
+}
+
+void hsc_dma_out_clear_intr(struct hsc_dma_out *dma_out, u32 clear)
+{
+	struct regmap *r = dma_out->chip->regmap;
+
+	regmap_write(r, CDMBC_CHIR(dma_out->spec->dma_ch), clear);
+}
diff --git a/drivers/media/platform/uniphier/hsc-ts.c b/drivers/media/platform/uniphier/hsc-ts.c
new file mode 100644
index 000000000000..4539c3280021
--- /dev/null
+++ b/drivers/media/platform/uniphier/hsc-ts.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
+// MPEG2-TS input/output port setting.
+//
+// Copyright (c) 2018 Socionext Inc.
+
+#include <linux/bitfield.h>
+#include <linux/kernel.h>
+
+#include "hsc.h"
+#include "hsc-reg.h"
+
+#define PARAMA_OFFSET_TS      0x02
+#define PARAMA_LOOPADDR_TS    0x31
+#define PARAMA_COUNT_TS       0xc4
+
+static bool ts_in_is_valid(struct hsc_chip *chip, enum HSC_TS_IN in)
+{
+	if (in >= chip->spec->num_ts_in || !chip->spec->ts_in[in].intr.valid)
+		return false;
+
+	return true;
+}
+
+static const struct hsc_spec_ts *ts_in_get_spec(struct hsc_chip *chip,
+						enum HSC_TS_IN in)
+{
+	const struct hsc_spec_ts *spec = chip->spec->ts_in;
+
+	if (!ts_in_is_valid(chip, in))
+		return NULL;
+
+	return &spec[in];
+}
+
+int hsc_ts_in_set_enable(struct hsc_chip *chip, enum HSC_TS_IN in, bool en)
+{
+	struct regmap *r = chip->regmap;
+	const struct hsc_spec_ts *speci = ts_in_get_spec(chip, in);
+	u32 m, v;
+
+	if (!speci)
+		return -EINVAL;
+
+	m = TSI_SYNCCNTROL_FRAME_MASK;
+	v = TSI_SYNCCNTROL_FRAME_EXTSYNC2;
+	regmap_update_bits(r, TSI_SYNCCNTROL(in), m, v);
+
+	m = TSI_CONFIG_ATSMD_MASK | TSI_CONFIG_STCMD_MASK |
+		TSI_CONFIG_CHEN_START;
+	v = TSI_CONFIG_ATSMD_DPLL | TSI_CONFIG_STCMD_DPLL;
+	if (en)
+		v |= TSI_CONFIG_CHEN_START;
+	regmap_update_bits(r, TSI_CONFIG(in), m, v);
+
+	v = (en) ? ~0 : 0;
+	regmap_update_bits(r, TSI_INTREN(in),
+			   TSI_INTR_SERR | TSI_INTR_LOST, v);
+	regmap_update_bits(r, speci->intr.reg, BIT(speci->intr.sft_intr), v);
+
+	return 0;
+}
+
+int hsc_ts_in_set_dmaparam(struct hsc_chip *chip, enum HSC_TS_IN in,
+			   enum HSC_TSIF_FMT ifmt)
+{
+	struct regmap *r = chip->regmap;
+	u32 v, ats, offset, loop, cnt;
+
+	if (!ts_in_is_valid(chip, in))
+		return -EINVAL;
+
+	switch (ifmt) {
+	case HSC_TSIF_MPEG2_TS:
+		ats = 0;
+		offset = PARAMA_OFFSET_TS;
+		loop = PARAMA_LOOPADDR_TS;
+		cnt = PARAMA_COUNT_TS;
+		break;
+	case HSC_TSIF_MPEG2_TS_ATS:
+		ats = TSI_CONFIG_ATSADD_ON;
+		offset = PARAMA_OFFSET_TS;
+		loop = PARAMA_LOOPADDR_TS;
+		cnt = PARAMA_COUNT_TS;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	regmap_update_bits(r, TSI_CONFIG(in), TSI_CONFIG_ATSADD_ON, ats);
+
+	v = FIELD_PREP(SBC_DMAPARAMA_OFFSET_MASK, offset) |
+		FIELD_PREP(SBC_DMAPARAMA_LOOPADDR_MASK, loop) |
+		FIELD_PREP(SBC_DMAPARAMA_COUNT_MASK, cnt);
+	regmap_write(r, SBC_DMAPARAMA(in), v);
+
+	return 0;
+}
diff --git a/drivers/media/platform/uniphier/hsc-ucode.c b/drivers/media/platform/uniphier/hsc-ucode.c
new file mode 100644
index 000000000000..bad1d70b0968
--- /dev/null
+++ b/drivers/media/platform/uniphier/hsc-ucode.c
@@ -0,0 +1,436 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
+// Core init and uCode loader.
+//
+// Copyright (c) 2018 Socionext Inc.
+
+#include <linux/bitfield.h>
+#include <linux/firmware.h>
+#include <linux/kernel.h>
+
+#include "hsc.h"
+#include "hsc-reg.h"
+
+struct hsc_cip_file_dma_param {
+	u32 cip_file_ch;
+	dma_addr_t cip_r_sdram;
+	dma_addr_t cip_w_sdram;
+	size_t inter_size;
+	size_t total_size;
+	u8 key_id1;
+	u8 key_id0;
+	u8 endian;
+	int id1_en;
+	int push;
+};
+
+static void core_start(struct hsc_chip *chip)
+{
+	struct regmap *r = chip->regmap;
+
+	regmap_write(r, IOB_RESET0, ~0);
+	regmap_write(r, IOB_RESET1, ~0);
+
+	regmap_write(r, IOB_CLKSTOP, 0);
+	/* Deassert all internal resets, but AP core is later for uCode */
+	regmap_write(r, IOB_RESET0, IOB_RESET0_APCORE);
+	regmap_write(r, IOB_RESET1, 0);
+
+	/* Halt SPU for uCode */
+	regmap_write(r, IOB_DEBUG, IOB_DEBUG_SPUHALT);
+}
+
+static void core_stop(struct hsc_chip *chip)
+{
+	struct regmap *r = chip->regmap;
+
+	regmap_write(r, IOB_RESET0, 0);
+	regmap_write(r, IOB_RESET1, 0);
+
+	regmap_write(r, IOB_CLKSTOP, ~0);
+}
+
+static void core_clear_ram(struct hsc_chip *chip)
+{
+	struct regmap *r = chip->regmap;
+	const struct hsc_spec_init_ram *rams = chip->spec->init_rams;
+	size_t i, s;
+
+	for (i = 0; i < chip->spec->num_init_rams; i++)
+		for (s = 0; s < rams[i].size; s += 4)
+			regmap_write(r, rams[i].addr + s, rams[i].pattern);
+}
+
+static void core_start_spu(struct hsc_chip *chip)
+{
+	struct regmap *r = chip->regmap;
+
+	regmap_write(r, IOB_DEBUG, 0);
+}
+
+static void core_start_ap(struct hsc_chip *chip)
+{
+	struct regmap *r = chip->regmap;
+
+	regmap_write(r, IOB_RESET0, 0);
+}
+
+static int ucode_set_data_addr(struct hsc_chip *chip, int mode)
+{
+	struct regmap *r = chip->regmap;
+	dma_addr_t addr;
+
+	switch (mode) {
+	case HSC_UCODE_SPU_0:
+	case HSC_UCODE_SPU_1:
+		addr = chip->ucode_spu.phys_data;
+		regmap_write(r, UCODE_DLADDR0, addr);
+		regmap_write(r, UCODE_DLADDR1, addr >> 32);
+		break;
+	case HSC_UCODE_ACE:
+		addr = chip->ucode_am.phys_data;
+		regmap_write(r, CIP_UCODEADDR_AM0, addr);
+		regmap_write(r, CIP_UCODEADDR_AM1, addr >> 32);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void file_channel_dma_set(struct hsc_chip *chip,
+				 struct hsc_cip_file_dma_param *p)
+{
+	struct regmap *r = chip->regmap;
+	u32 cipr_rsc_no;
+	u32 cipw_rsc_no;
+	dma_addr_t cipr_sdram_start;
+	dma_addr_t cipw_sdram_start;
+	dma_addr_t cipr_sdram_end;
+	dma_addr_t cipw_sdram_end;
+	u32 v;
+
+	cipr_rsc_no = HSC_CIP_FILE_TO_CIPR_DMCH(p->cip_file_ch);
+	cipw_rsc_no = HSC_CIP_FILE_TO_CIPW_DMCH(p->cip_file_ch);
+	cipr_sdram_start = p->cip_r_sdram;
+	cipw_sdram_start = p->cip_w_sdram;
+	cipr_sdram_end = p->cip_r_sdram + p->total_size;
+	cipw_sdram_end = p->cip_w_sdram + p->total_size;
+
+	/* For CIP Read */
+	v = FIELD_PREP(CDMBC_CHCTRL1_LINKCH1_MASK, 1) |
+		FIELD_PREP(CDMBC_CHCTRL1_STATSEL_MASK, 4) |
+		CDMBC_CHCTRL1_TYPE_INTERMIT;
+	regmap_write(r, CDMBC_CHCTRL1(cipr_rsc_no), v);
+
+	regmap_write(r, CDMBC_CHCAUSECTRL(cipr_rsc_no), 0);
+
+	v = FIELD_PREP(CDMBC_CHAMODE_ENDIAN_MASK, p->endian) |
+		FIELD_PREP(CDMBC_CHAMODE_AUPDT_MASK, 0) |
+		CDMBC_CHAMODE_TYPE_RB;
+	regmap_write(r, CDMBC_CHSRCAMODE(cipr_rsc_no), v);
+
+	v = FIELD_PREP(CDMBC_CHAMODE_ENDIAN_MASK, 1) |
+		FIELD_PREP(CDMBC_CHAMODE_AUPDT_MASK, 2);
+	regmap_write(r, CDMBC_CHDSTAMODE(cipr_rsc_no), v);
+
+	v = FIELD_PREP(CDMBC_CHDSTSTRTADRS_TID_MASK, 0xc) |
+		FIELD_PREP(CDMBC_CHDSTSTRTADRS_ID1_EN_MASK, p->id1_en) |
+		FIELD_PREP(CDMBC_CHDSTSTRTADRS_KEY_ID1_MASK, p->key_id1) |
+		FIELD_PREP(CDMBC_CHDSTSTRTADRS_KEY_ID0_MASK, p->key_id0);
+	regmap_write(r, CDMBC_CHDSTSTRTADRSD(cipr_rsc_no), v);
+
+	regmap_write(r, CDMBC_CHSIZE(cipr_rsc_no), p->inter_size);
+
+	/* For CIP Write */
+	v = FIELD_PREP(CDMBC_CHCTRL1_LINKCH1_MASK, 5) |
+		FIELD_PREP(CDMBC_CHCTRL1_STATSEL_MASK, 4) |
+		CDMBC_CHCTRL1_TYPE_INTERMIT |
+		CDMBC_CHCTRL1_IND_SIZE_UND;
+	regmap_write(r, CDMBC_CHCTRL1(cipw_rsc_no), v);
+
+	v = FIELD_PREP(CDMBC_CHAMODE_ENDIAN_MASK, 1) |
+		FIELD_PREP(CDMBC_CHAMODE_AUPDT_MASK, 2);
+	regmap_write(r, CDMBC_CHSRCAMODE(cipw_rsc_no), v);
+
+	v = FIELD_PREP(CDMBC_CHAMODE_ENDIAN_MASK, p->endian) |
+		FIELD_PREP(CDMBC_CHAMODE_AUPDT_MASK, 0) |
+		CDMBC_CHAMODE_TYPE_RB;
+	regmap_write(r, CDMBC_CHDSTAMODE(cipw_rsc_no), v);
+
+	/* Transferring size */
+	regmap_write(r, CDMBC_ITSTEPS(cipr_rsc_no), p->total_size);
+
+	/* For ring buffer */
+	regmap_write(r, CDMBC_RBBGNADRSD(cipr_rsc_no), cipr_sdram_start);
+	regmap_write(r, CDMBC_RBENDADRSD(cipr_rsc_no), cipr_sdram_end);
+	regmap_write(r, CDMBC_RBRDPTRD(cipr_rsc_no), cipr_sdram_start);
+	regmap_write(r, CDMBC_RBWRPTRD(cipr_rsc_no), cipr_sdram_end);
+
+	regmap_write(r, CDMBC_RBBGNADRSU(cipr_rsc_no), cipr_sdram_start >> 32);
+	regmap_write(r, CDMBC_RBENDADRSU(cipr_rsc_no), cipr_sdram_end >> 32);
+	regmap_write(r, CDMBC_RBRDPTRU(cipr_rsc_no), cipr_sdram_start >> 32);
+	regmap_write(r, CDMBC_RBWRPTRU(cipr_rsc_no), cipr_sdram_end >> 32);
+
+	regmap_write(r, CDMBC_RBBGNADRSD(cipw_rsc_no), cipw_sdram_start);
+	regmap_write(r, CDMBC_RBENDADRSD(cipw_rsc_no), cipw_sdram_end);
+	regmap_write(r, CDMBC_RBRDPTRD(cipw_rsc_no), cipw_sdram_end);
+	regmap_write(r, CDMBC_RBWRPTRD(cipw_rsc_no), cipw_sdram_start);
+
+	regmap_write(r, CDMBC_RBBGNADRSU(cipw_rsc_no), cipw_sdram_start >> 32);
+	regmap_write(r, CDMBC_RBENDADRSU(cipw_rsc_no), cipw_sdram_end >> 32);
+	regmap_write(r, CDMBC_RBRDPTRU(cipw_rsc_no), cipw_sdram_end >> 32);
+	regmap_write(r, CDMBC_RBWRPTRU(cipw_rsc_no), cipw_sdram_start >> 32);
+
+	/* Transfer settings */
+	regmap_write(r, CDMBC_CIPMODE(p->cip_file_ch),
+		     (p->push) ? CDMBC_CIPMODE_PUSH : 0);
+
+	regmap_write(r, CDMBC_CIPPRIORITY(p->cip_file_ch),
+		     FIELD_PREP(CDMBC_CIPPRIORITY_PRIOR_MASK, 3));
+}
+
+static void file_channel_start(struct hsc_chip *chip, int cip_file_ch,
+			       bool push, bool mmu_en)
+{
+	struct regmap *r = chip->regmap;
+	int cipr_rsc_no, cipw_rsc_no;
+	int cipr_tdbp_no, cipw_tdbp_no;
+	u32 v = 0;
+
+	cipr_rsc_no = HSC_CIP_FILE_TO_CIPR_DMCH(cip_file_ch);
+	cipw_rsc_no = HSC_CIP_FILE_TO_CIPW_DMCH(cip_file_ch);
+	cipr_tdbp_no = HSC_CIP_FILE_TO_CIPR(cip_file_ch);
+	cipw_tdbp_no = HSC_CIP_FILE_TO_CIPW(cip_file_ch);
+
+	regmap_write(r, CDMBC_CIPMODE(cip_file_ch),
+		     (push) ? CDMBC_CIPMODE_PUSH : 0);
+
+	if (mmu_en) {
+		v = CDMBC_CHDDR_REG_LOAD_ON | CDMBC_CHDDR_AT_CHEN_ON;
+
+		/* Enable IOMMU for CIP-R and CIP-W */
+		regmap_write(r, CDMBC_CHDDR(cipr_rsc_no),
+			     v | CDMBC_CHDDR_SET_MCB_RD);
+		regmap_write(r, CDMBC_CHDDR(cipw_rsc_no),
+			     v | CDMBC_CHDDR_SET_MCB_WR);
+	}
+
+	v = 0x01000000 | (1 << cipr_tdbp_no) | (1 << cipw_tdbp_no);
+	regmap_write(r, CDMBC_STRT(1), v);
+}
+
+static int ucode_load_dma(struct hsc_chip *chip, int mode)
+{
+	struct regmap *r = chip->regmap;
+	struct hsc_ucode_buf *ucode;
+	struct hsc_cip_file_dma_param dma_p = {0};
+	u32 cip_f_ctrl, v;
+
+	switch (mode) {
+	case HSC_UCODE_SPU_0:
+	case HSC_UCODE_SPU_1:
+		ucode = &chip->ucode_spu;
+		cip_f_ctrl = 0x2f090001;
+		break;
+	case HSC_UCODE_ACE:
+		ucode = &chip->ucode_am;
+		cip_f_ctrl = 0x3f090001;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	regmap_write(r, CIP_F_CTRL, cip_f_ctrl);
+
+	regmap_write(r, IOB_INTREN(HSC_INTR_IOB_2),
+		     INTR2_CIP_AUTH_S |
+		     INTR2_MBC_CIP_R(0) | INTR2_MBC_CIP_W(0));
+
+	dma_p.cip_file_ch = HSC_CIP_FILE_NO_0;
+	dma_p.cip_r_sdram = ucode->phys_code;
+	dma_p.cip_w_sdram = 0;
+	dma_p.inter_size = ucode->size_code;
+	dma_p.total_size = ucode->size_code;
+	dma_p.key_id1 = 0;
+	dma_p.key_id0 = 0;
+	dma_p.endian = 1;
+	dma_p.id1_en = 0;
+	file_channel_dma_set(chip, &dma_p);
+	file_channel_start(chip, HSC_CIP_FILE_NO_0, true, false);
+
+	do {
+		regmap_read(r, CDMBC_CHIR(HSC_MBC_DMCH_CIP0_R), &v);
+		msleep(20);
+	} while (!(v & INTR_MBC_CH_WDONE));
+	regmap_write(r, CDMBC_CHIR(HSC_MBC_DMCH_CIP0_R), v);
+
+	do {
+		regmap_read(r, CDMBC_CHIR(HSC_MBC_DMCH_CIP0_W), &v);
+		msleep(20);
+	} while (!(v & INTR_MBC_CH_WDONE));
+	regmap_write(r, CDMBC_CHIR(HSC_MBC_DMCH_CIP0_W), v);
+
+	regmap_read(r, CDMBC_RBIR(HSC_MBC_DMCH_CIP0_R), &v);
+	regmap_write(r, CDMBC_RBIR(HSC_MBC_DMCH_CIP0_R), v);
+
+	regmap_read(r, CDMBC_RBIR(HSC_MBC_DMCH_CIP0_W), &v);
+	regmap_write(r, CDMBC_RBIR(HSC_MBC_DMCH_CIP0_W), v);
+
+	/* Clear & disable interrupt */
+	regmap_read(r, IOB_INTRST(HSC_INTR_IOB_2), &v);
+	regmap_write(r, IOB_INTRST(HSC_INTR_IOB_2), v);
+
+	regmap_write(r, IOB_INTREN(HSC_INTR_IOB_2), 0);
+
+	return 0;
+}
+
+static int ucode_load(struct hsc_chip *chip, int mode)
+{
+	struct device *dev = &chip->pdev->dev;
+	const struct hsc_spec_ucode *spec;
+	struct hsc_ucode_buf *ucode;
+	const struct firmware *firm_code, *firm_data;
+	int ret;
+
+	switch (mode) {
+	case HSC_UCODE_SPU_0:
+	case HSC_UCODE_SPU_1:
+		spec = &chip->spec->ucode_spu;
+		ucode = &chip->ucode_spu;
+		break;
+	case HSC_UCODE_ACE:
+		spec = &chip->spec->ucode_ace;
+		ucode = &chip->ucode_am;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = request_firmware(&firm_code, spec->name_code, dev);
+	if (ret) {
+		dev_err(dev, "Failed to load firmware '%s'.\n",
+			spec->name_code);
+		return ret;
+	}
+
+	ret = request_firmware(&firm_data, spec->name_data, dev);
+	if (ret) {
+		dev_err(dev, "Failed to load firmware '%s'.\n",
+			spec->name_data);
+		goto err_firm_code;
+	}
+
+	ucode->buf_code = dma_alloc_coherent(dev, firm_code->size,
+					     &ucode->phys_code, GFP_KERNEL);
+	if (!ucode->buf_code) {
+		ret = -ENOMEM;
+		goto err_firm_data;
+	}
+	ucode->size_code = firm_code->size;
+
+	ucode->buf_data = dma_alloc_coherent(dev, firm_data->size,
+					     &ucode->phys_data, GFP_KERNEL);
+	if (!ucode->buf_data) {
+		ret = -ENOMEM;
+		goto err_buf_code;
+	}
+	ucode->size_data = firm_data->size;
+
+	memcpy(ucode->buf_code, firm_code->data, firm_code->size);
+	memcpy(ucode->buf_data, firm_data->data, firm_data->size);
+
+	ret = ucode_set_data_addr(chip, mode);
+	if (ret)
+		goto err_buf_data;
+
+	ret = ucode_load_dma(chip, mode);
+	if (ret)
+		goto err_buf_data;
+
+	release_firmware(firm_data);
+	release_firmware(firm_code);
+
+	return 0;
+
+err_buf_data:
+	dma_free_coherent(dev, ucode->size_data, ucode->buf_data,
+			  ucode->phys_data);
+
+err_buf_code:
+	dma_free_coherent(dev, ucode->size_code, ucode->buf_code,
+			  ucode->phys_code);
+
+err_firm_data:
+	release_firmware(firm_data);
+
+err_firm_code:
+	release_firmware(firm_code);
+
+	return ret;
+}
+
+static int ucode_unload(struct hsc_chip *chip, int mode)
+{
+	struct device *dev = &chip->pdev->dev;
+	struct hsc_ucode_buf *ucode;
+
+	switch (mode) {
+	case HSC_UCODE_SPU_0:
+	case HSC_UCODE_SPU_1:
+		ucode = &chip->ucode_spu;
+		break;
+	case HSC_UCODE_ACE:
+		ucode = &chip->ucode_am;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	dma_free_coherent(dev, ucode->size_data, ucode->buf_data,
+			  ucode->phys_data);
+	dma_free_coherent(dev, ucode->size_code, ucode->buf_code,
+			  ucode->phys_code);
+
+	return 0;
+}
+
+int hsc_ucode_load_all(struct hsc_chip *chip)
+{
+	int ret;
+
+	core_start(chip);
+	core_clear_ram(chip);
+
+	ret = ucode_load(chip, HSC_UCODE_SPU_0);
+	if (ret)
+		return ret;
+	core_start_spu(chip);
+
+	ret = ucode_load(chip, HSC_UCODE_ACE);
+	if (ret)
+		return ret;
+	core_start_ap(chip);
+
+	return 0;
+}
+
+int hsc_ucode_unload_all(struct hsc_chip *chip)
+{
+	int ret;
+
+	core_stop(chip);
+
+	ret = ucode_unload(chip, HSC_UCODE_SPU_0);
+	if (ret)
+		return ret;
+
+	ret = ucode_unload(chip, HSC_UCODE_ACE);
+	if (ret)
+		return ret;
+
+	return 0;
+}
-- 
2.17.0
