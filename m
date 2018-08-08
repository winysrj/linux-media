Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:4074 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbeHHHnb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Aug 2018 03:43:31 -0400
From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: [PATCH v2 2/7] media: uniphier: add DMA common file of HSC
Date: Wed,  8 Aug 2018 14:25:14 +0900
Message-Id: <20180808052519.14528-3-suzuki.katsuhiro@socionext.com>
In-Reply-To: <20180808052519.14528-1-suzuki.katsuhiro@socionext.com>
References: <20180808052519.14528-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DMA code of HSC (High speed Stream Controller) driver for
Socionext UniPhier SoCs. The HSC enables to input and output
MPEG2-TS stream from/to outer world of SoC.

Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>

---

Changes from v1:
  - Add COMPILE_TEST, REGMAP_MMIO
  - Remove unneeded const
  - Replace enum that has special value into #define
  - Remove weird macro from register definitions
  - Use shift and mask instead of field_get/prop inline functions
  - Remove duplicated structures
  - Fix depended config
  - Fix include lines
---
 drivers/media/platform/Kconfig            |   1 +
 drivers/media/platform/Makefile           |   2 +
 drivers/media/platform/uniphier/Kconfig   |  11 +
 drivers/media/platform/uniphier/Makefile  |   4 +
 drivers/media/platform/uniphier/hsc-dma.c | 212 +++++++++++++
 drivers/media/platform/uniphier/hsc-reg.h | 118 ++++++++
 drivers/media/platform/uniphier/hsc.h     | 352 ++++++++++++++++++++++
 7 files changed, 700 insertions(+)
 create mode 100644 drivers/media/platform/uniphier/Kconfig
 create mode 100644 drivers/media/platform/uniphier/Makefile
 create mode 100644 drivers/media/platform/uniphier/hsc-dma.c
 create mode 100644 drivers/media/platform/uniphier/hsc-reg.h
 create mode 100644 drivers/media/platform/uniphier/hsc.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index e3079435565e..e7690fe3e7e4 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -528,6 +528,7 @@ menuconfig DVB_PLATFORM_DRIVERS
 
 if DVB_PLATFORM_DRIVERS
 source "drivers/media/platform/sti/c8sectpfe/Kconfig"
+source "drivers/media/platform/uniphier/Kconfig"
 endif #DVB_PLATFORM_DRIVERS
 
 menuconfig CEC_PLATFORM_DRIVERS
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 41322ab65802..ef763dac9d53 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -96,3 +96,5 @@ obj-$(CONFIG_VIDEO_QCOM_VENUS)		+= qcom/venus/
 obj-y					+= meson/
 
 obj-y					+= cros-ec-cec/
+
+obj-$(CONFIG_DVB_UNIPHIER)		+= uniphier/
diff --git a/drivers/media/platform/uniphier/Kconfig b/drivers/media/platform/uniphier/Kconfig
new file mode 100644
index 000000000000..b96b98d98400
--- /dev/null
+++ b/drivers/media/platform/uniphier/Kconfig
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0
+config DVB_UNIPHIER
+	tristate "Socionext UniPhier Frontend"
+	depends on DVB_CORE && OF
+	depends on ARCH_UNIPHIER || COMPILE_TEST
+	select FW_LOADER
+	select REGMAP_MMIO
+	help
+	  Driver for UniPhier frontend for MPEG2-TS input/output,
+	  demux and descramble.
+	  Say Y when you want to support this frontend.
diff --git a/drivers/media/platform/uniphier/Makefile b/drivers/media/platform/uniphier/Makefile
new file mode 100644
index 000000000000..c3d67a148dbe
--- /dev/null
+++ b/drivers/media/platform/uniphier/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+uniphier-dvb-y += hsc-dma.o
+
+obj-$(CONFIG_DVB_UNIPHIER) += uniphier-dvb.o
diff --git a/drivers/media/platform/uniphier/hsc-dma.c b/drivers/media/platform/uniphier/hsc-dma.c
new file mode 100644
index 000000000000..f5a58d81dffe
--- /dev/null
+++ b/drivers/media/platform/uniphier/hsc-dma.c
@@ -0,0 +1,212 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
+// MPEG2-TS DMA control.
+//
+// Copyright (c) 2018 Socionext Inc.
+
+#include <linux/bitfield.h>
+#include <linux/kernel.h>
+#include <linux/regmap.h>
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
+void hsc_dma_rb_set_buffer(struct hsc_chip *chip, int rb_ch, u64 bg, u64 ed)
+{
+	struct regmap *r = chip->regmap;
+
+	regmap_write(r, CDMBC_RBBGNADRSD(rb_ch), bg);
+	regmap_write(r, CDMBC_RBBGNADRSU(rb_ch), bg >> 32);
+	regmap_write(r, CDMBC_RBENDADRSD(rb_ch), ed);
+	regmap_write(r, CDMBC_RBENDADRSU(rb_ch), ed >> 32);
+}
+
+u64 hsc_dma_rb_get_rp(struct hsc_chip *chip, int rb_ch)
+{
+	struct regmap *r = chip->regmap;
+	u32 d, u;
+
+	regmap_read(r, CDMBC_RBRDPTRD(rb_ch), &d);
+	regmap_read(r, CDMBC_RBRDPTRU(rb_ch), &u);
+
+	return ((u64)u << 32) | d;
+}
+
+void hsc_dma_rb_set_rp(struct hsc_chip *chip, int rb_ch, u64 pos)
+{
+	struct regmap *r = chip->regmap;
+
+	regmap_write(r, CDMBC_RBRDPTRD(rb_ch), pos);
+	regmap_write(r, CDMBC_RBRDPTRU(rb_ch), pos >> 32);
+}
+
+u64 hsc_dma_rb_get_wp(struct hsc_chip *chip, int rb_ch)
+{
+	struct regmap *r = chip->regmap;
+	u32 d, u;
+
+	regmap_read(r, CDMBC_RBWRPTRD(rb_ch), &d);
+	regmap_read(r, CDMBC_RBWRPTRU(rb_ch), &u);
+
+	return ((u64)u << 32) | d;
+}
+
+void hsc_dma_rb_set_wp(struct hsc_chip *chip, int rb_ch, u64 pos)
+{
+	struct regmap *r = chip->regmap;
+
+	regmap_write(r, CDMBC_RBWRPTRD(rb_ch), pos);
+	regmap_write(r, CDMBC_RBWRPTRU(rb_ch), pos >> 32);
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
+			   const struct hsc_reg_cmn *dma_en, bool en)
+{
+	struct regmap *r = chip->regmap;
+	u32 v;
+	bool now;
+
+	regmap_read(r, dma_en->reg, &v);
+	now = !!(v & BIT(dma_en->sft));
+
+	/* Toggle DMA state if needed */
+	if ((en && !now) || (!en && now))
+		regmap_write(r, dma_en->reg, BIT(dma_en->sft));
+}
+
+static bool dma_out_is_valid(struct hsc_chip *chip, int out)
+{
+	return out < chip->spec->num_dma_out ||
+		chip->spec->dma_out[out].intr.valid;
+}
+
+int hsc_dma_out_init(struct hsc_dma *dma_out, struct hsc_chip *chip,
+		     int id, struct hsc_dma_buf *buf)
+{
+	if (!dma_out || !dma_out_is_valid(chip, id))
+		return -EINVAL;
+
+	dma_out->chip = chip;
+	dma_out->id = id;
+	dma_out->spec = &chip->spec->dma_out[id];
+	dma_out->buf = buf;
+
+	return 0;
+}
+
+void hsc_dma_out_set_src_ts_in(struct hsc_dma *dma_out, int tsi)
+{
+	struct regmap *r = dma_out->chip->regmap;
+	const struct hsc_spec_dma *spec = dma_out->spec;
+	u32 m, v;
+
+	m = CDMBC_CHTDCTRLH_STREM_MASK | CDMBC_CHTDCTRLH_ALL_EN;
+	v = FIELD_PREP(CDMBC_CHTDCTRLH_STREM_MASK, tsi) |
+		CDMBC_CHTDCTRLH_ALL_EN;
+	regmap_update_bits(r, CDMBC_CHTDCTRLH(spec->td_ch), m, v);
+}
+
+void hsc_dma_out_start(struct hsc_dma *dma_out, bool en)
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
+	hsc_dma_rb_set_buffer(chip, spec->rb_ch, bg, ed);
+
+	buf->rd_offs = 0;
+	buf->wr_offs = 0;
+	buf->chk_offs = buf->size_chk;
+	hsc_dma_rb_set_rp(chip, spec->rb_ch, buf->rd_offs + buf->phys);
+	hsc_dma_rb_set_wp(chip, spec->rb_ch, buf->wr_offs + buf->phys);
+	dma_set_chkp(chip, spec->dma_ch, buf->chk_offs + buf->phys);
+
+	regmap_update_bits(r, CDMBC_CHDSTAMODE(spec->dma_ch),
+			   CDMBC_CHAMODE_TYPE_RB, ~0);
+	regmap_update_bits(r, CDMBC_CHCTRL1(spec->dma_ch),
+			   CDMBC_CHCTRL1_IND_SIZE_UND, ~0);
+
+	v = (en) ? ~0 : 0;
+	regmap_update_bits(r, CDMBC_CHIE(spec->dma_ch), CDMBC_CHI_TRANSIT, v);
+	regmap_update_bits(r, spec->intr.reg, BIT(spec->intr.sft), v);
+
+	dma_set_enable(chip, spec->dma_ch, &spec->en, en);
+}
+
+void hsc_dma_out_sync(struct hsc_dma *dma_out)
+{
+	struct hsc_chip *chip = dma_out->chip;
+	const struct hsc_spec_dma *spec = dma_out->spec;
+	struct hsc_dma_buf *buf = dma_out->buf;
+
+	hsc_dma_rb_set_rp(chip, spec->rb_ch, buf->rd_offs + buf->phys);
+	buf->wr_offs = hsc_dma_rb_get_wp(chip, spec->rb_ch) - buf->phys;
+	dma_set_chkp(chip, spec->dma_ch, buf->chk_offs + buf->phys);
+}
+
+int hsc_dma_out_get_intr(struct hsc_dma *dma_out, u32 *stat)
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
+void hsc_dma_out_clear_intr(struct hsc_dma *dma_out, u32 clear)
+{
+	struct regmap *r = dma_out->chip->regmap;
+
+	regmap_write(r, CDMBC_CHIR(dma_out->spec->dma_ch), clear);
+}
diff --git a/drivers/media/platform/uniphier/hsc-reg.h b/drivers/media/platform/uniphier/hsc-reg.h
new file mode 100644
index 000000000000..2d87960c9b97
--- /dev/null
+++ b/drivers/media/platform/uniphier/hsc-reg.h
@@ -0,0 +1,118 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
+ *
+ * Copyright (c) 2018 Socionext Inc.
+ */
+
+#ifndef DVB_UNIPHIER_HSC_REG_H__
+#define DVB_UNIPHIER_HSC_REG_H__
+
+/* MBC1-7 Common */
+#define CDMBC_STRT(i)                (0x2300 + ((i) - 1) * 0x4)
+#define CDMBC_PERFCNFG               0x230c
+#define CDMBC_STAT(i)                (0x2320 + (i) * 0x4)
+#define CDMBC_PARTRESET(i)           (0x234c + (i) * 0x4)
+#define CDMBC_MONNUM                 0x2358
+#define CDMBC_MONDAT                 0x235c
+#define CDMBC_PRC0CHIE0              0x2380
+#define CDMBC_PRC0RBIE0              0x2384
+#define CDMBC_PRC1CHIE0              0x2388
+#define CDMBC_PRC2CHIE0              0x2390
+#define CDMBC_PRC2RBIE0              0x2394
+#define CDMBC_SOFTFLRQ               0x239c
+#define CDMBC_TDSTRT                 0x23a0
+
+#define INTR_MBC_CH_END              BIT(15)
+#define INTR_MBC_CH_STOP             BIT(13)
+#define INTR_MBC_CH_ADDR             BIT(6)
+#define INTR_MBC_CH_IWDONE           BIT(3)
+#define INTR_MBC_CH_WDONE            BIT(1)
+
+/* MBC DMA channel, only for output DMA */
+#define CDMBC_CHTDCTRLH(i)            (0x23a4 + (i) * 0x10)
+#define   CDMBC_CHTDCTRLH_STREM_MASK    GENMASK(20, 16)
+#define   CDMBC_CHTDCTRLH_NOT_FLT       BIT(7)
+#define   CDMBC_CHTDCTRLH_ALL_EN        BIT(6)
+#define CDMBC_CHTDCTRLU(i)            (0x23a8 + (i) * 0x10)
+
+/* MBC DMA channel */
+#define CDMBC_CHCTRL1(i)                  (0x2540 + (i) * 0x50)
+#define   CDMBC_CHCTRL1_LINKCH1_MASK        GENMASK(12, 10)
+#define   CDMBC_CHCTRL1_STATSEL_MASK        GENMASK(9, 7)
+#define   CDMBC_CHCTRL1_TYPE_INTERMIT       BIT(1)
+#define   CDMBC_CHCTRL1_IND_SIZE_UND        BIT(0)
+#define CDMBC_CHCTRL2(i)                  (0x2544 + (i) * 0x50)
+#define CDMBC_CHDDR(i)                    (0x2548 + (i) * 0x50)
+#define   CDMBC_CHDDR_REG_LOAD_ON           BIT(4)
+#define   CDMBC_CHDDR_AT_CHEN_ON            BIT(3)
+#define   CDMBC_CHDDR_SET_MCB_MASK          GENMASK(2, 1)
+#define   CDMBC_CHDDR_SET_MCB_WR            (0x0 << 1)
+#define   CDMBC_CHDDR_SET_MCB_RD            (0x3 << 1)
+#define   CDMBC_CHDDR_SET_DDR_1             BIT(0)
+#define CDMBC_CHCAUSECTRL(i)              (0x254c + (i) * 0x50)
+#define   CDMBC_CHCAUSECTRL_MODE_MASK       BIT(31)
+#define   CDMBC_CHCAUSECTRL_CSEL2_MASK      GENMASK(20, 12)
+#define   CDMBC_CHCAUSECTRL_CSEL1_MASK      GENMASK(8, 0)
+#define CDMBC_CHSTAT(i)                   (0x2550 + (i) * 0x50)
+#define CDMBC_CHIR(i)                     (0x2554 + (i) * 0x50)
+#define CDMBC_CHIE(i)                     (0x2558 + (i) * 0x50)
+#define CDMBC_CHID(i)                     (0x255c + (i) * 0x50)
+#define   CDMBC_CHI_STOPPED                 BIT(13)
+#define   CDMBC_CHI_TRANSIT                 BIT(6)
+#define   CDMBC_CHI_STARTING                BIT(1)
+#define CDMBC_CHSRCAMODE(i)               (0x2560 + (i) * 0x50)
+#define CDMBC_CHDSTAMODE(i)               (0x2564 + (i) * 0x50)
+#define   CDMBC_CHAMODE_TUNIT_MASK          GENMASK(29, 28)
+#define   CDMBC_CHAMODE_ENDIAN_MASK         GENMASK(17, 16)
+#define   CDMBC_CHAMODE_AUPDT_MASK          GENMASK(5, 4)
+#define   CDMBC_CHAMODE_TYPE_RB             BIT(2)
+#define CDMBC_CHSRCSTRTADRSD(i)           (0x2568 + (i) * 0x50)
+#define CDMBC_CHSRCSTRTADRSU(i)           (0x256c + (i) * 0x50)
+#define CDMBC_CHDSTSTRTADRSD(i)           (0x2570 + (i) * 0x50)
+#define CDMBC_CHDSTSTRTADRSU(i)           (0x2574 + (i) * 0x50)
+#define   CDMBC_CHDSTSTRTADRS_TID_MASK      GENMASK(31, 28)
+#define   CDMBC_CHDSTSTRTADRS_ID1_EN_MASK   BIT(15)
+#define   CDMBC_CHDSTSTRTADRS_KEY_ID1_MASK  GENMASK(12, 8)
+#define   CDMBC_CHDSTSTRTADRS_KEY_ID0_MASK  GENMASK(4, 0)
+#define CDMBC_CHSIZE(i)                   (0x2578 + (i) * 0x50)
+#define CDMBC_CHIRADRSD(i)                (0x2580 + (i) * 0x50)
+#define CDMBC_CHIRADRSU(i)                (0x2584 + (i) * 0x50)
+#define CDMBC_CHDST1STUSIZE(i)            (0x258C + (i) * 0x50)
+
+/* MBC DMA intermit transfer, only for input DMA */
+#define CDMBC_ITCTRL(i)              (0x3000 + (i) * 0x20)
+#define CDMBC_ITSTEPS(i)             (0x3018 + (i) * 0x20)
+
+/* MBC ring buffer */
+#define CDMBC_RBBGNADRS(i)           (0x3200 + (i) * 0x40)
+#define CDMBC_RBBGNADRSD(i)          (0x3200 + (i) * 0x40)
+#define CDMBC_RBBGNADRSU(i)          (0x3204 + (i) * 0x40)
+#define CDMBC_RBENDADRS(i)           (0x3208 + (i) * 0x40)
+#define CDMBC_RBENDADRSD(i)          (0x3208 + (i) * 0x40)
+#define CDMBC_RBENDADRSU(i)          (0x320C + (i) * 0x40)
+#define CDMBC_RBIR(i)                (0x3214 + (i) * 0x40)
+#define CDMBC_RBIE(i)                (0x3218 + (i) * 0x40)
+#define CDMBC_RBID(i)                (0x321c + (i) * 0x40)
+#define CDMBC_RBRDPTR(i)             (0x3220 + (i) * 0x40)
+#define CDMBC_RBRDPTRD(i)            (0x3220 + (i) * 0x40)
+#define CDMBC_RBRDPTRU(i)            (0x3224 + (i) * 0x40)
+#define CDMBC_RBWRPTR(i)             (0x3228 + (i) * 0x40)
+#define CDMBC_RBWRPTRD(i)            (0x3228 + (i) * 0x40)
+#define CDMBC_RBWRPTRU(i)            (0x322C + (i) * 0x40)
+#define CDMBC_RBERRCNFG(i)           (0x3238 + (i) * 0x40)
+
+/* MBC Rate */
+#define CDMBC_RCNMSKCYC(i)           (MBC6_TOP_ADDR + 0x000 + (i) * 0x04)
+
+/* MBC Address Transfer */
+#define CDMBC_CHPSIZE(i)             (0x3c00 + ((i) - 1) * 0x48)
+#define CDMBC_CHATCTRL(i)            (0x3c04 + ((i) - 1) * 0x48)
+#define CDMBC_CHBTPAGE(i, j)         (0x3c08 + ((i) - 1) * 0x48 + (j) * 0x10)
+#define CDMBC_CHBTPAGED(i, j)        (0x3c08 + ((i) - 1) * 0x48 + (j) * 0x10)
+#define CDMBC_CHBTPAGEU(i, j)        (0x3c0C + ((i) - 1) * 0x48 + (j) * 0x10)
+#define CDMBC_CHATPAGE(i, j)         (0x3c10 + ((i) - 1) * 0x48 + (j) * 0x10)
+#define CDMBC_CHATPAGED(i, j)        (0x3c10 + ((i) - 1) * 0x48 + (j) * 0x10)
+#define CDMBC_CHATPAGEU(i, j)        (0x3c14 + ((i) - 1) * 0x48 + (j) * 0x10)
+
+#endif /* DVB_UNIPHIER_HSC_REG_H__ */
diff --git a/drivers/media/platform/uniphier/hsc.h b/drivers/media/platform/uniphier/hsc.h
new file mode 100644
index 000000000000..fddc66df81c7
--- /dev/null
+++ b/drivers/media/platform/uniphier/hsc.h
@@ -0,0 +1,352 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
+ *
+ * Copyright (c) 2018 Socionext Inc.
+ */
+
+#ifndef DVB_UNIPHIER_HSC_H__
+#define DVB_UNIPHIER_HSC_H__
+
+#include <linux/gpio/consumer.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+
+#include <media/dmxdev.h>
+#include <media/dvbdev.h>
+#include <media/dvb_demux.h>
+#include <media/dvb_frontend.h>
+
+enum {
+	HSC_CORE_0,
+	HSC_CORE_1,
+	HSC_CORE_2,
+};
+
+enum {
+	HSC_UCODE_SPU_0,
+	HSC_UCODE_SPU_1,
+	HSC_UCODE_ACE,
+};
+
+enum {
+	HSC_TSIF_MPEG2_TS,
+	HSC_TSIF_MPEG2_TS_ATS,
+};
+
+/* DPLL */
+#define HSC_DPLL0       0
+#define HSC_DPLL1       1
+#define HSC_DPLL2       2
+#define HSC_DPLL3       3
+
+#define HSC_DPLL_NUM    4
+
+/* Clock source of DPLL */
+#define HSC_DPLL_SRC_NONE    -1
+#define HSC_DPLL_SRC_TSI0    0
+#define HSC_DPLL_SRC_TSI1    1
+#define HSC_DPLL_SRC_TSI2    2
+#define HSC_DPLL_SRC_TSI3    3
+#define HSC_DPLL_SRC_TSI4    4
+#define HSC_DPLL_SRC_TSI5    5
+#define HSC_DPLL_SRC_TSI6    6
+#define HSC_DPLL_SRC_TSI7    7
+#define HSC_DPLL_SRC_TSI8    8
+#define HSC_DPLL_SRC_TSI9    9
+#define HSC_DPLL_SRC_REP0    10
+#define HSC_DPLL_SRC_REP1    11
+#define HSC_DPLL_SRC_REP2    12
+#define HSC_DPLL_SRC_REP3    13
+#define HSC_DPLL_SRC_REP4    14
+#define HSC_DPLL_SRC_REP5    15
+
+#define HSC_DPLL_SRC_NUM     16
+
+/* Port to send to CSS */
+#define HSC_CSS_IN_1394_0          0
+#define HSC_CSS_IN_1394_1          1
+#define HSC_CSS_IN_1394_2          2
+#define HSC_CSS_IN_1394_3          3
+#define HSC_CSS_IN_DMD0            4
+#define HSC_CSS_IN_DMD1            5
+#define HSC_CSS_IN_SRLTS0          6
+#define HSC_CSS_IN_SRLTS1          7
+#define HSC_CSS_IN_SRLTS2          8
+#define HSC_CSS_IN_SRLTS3          9
+#define HSC_CSS_IN_SRLTS4          10
+#define HSC_CSS_IN_SRLTS5          11
+#define HSC_CSS_IN_SRLTS6          12
+#define HSC_CSS_IN_SRLTS7          13
+#define HSC_CSS_IN_PARTS0          16
+#define HSC_CSS_IN_PARTS1          17
+#define HSC_CSS_IN_PARTS2          18
+#define HSC_CSS_IN_PARTS3          19
+#define HSC_CSS_IN_TSO0            24
+#define HSC_CSS_IN_TSO1            25
+#define HSC_CSS_IN_TSO2            26
+#define HSC_CSS_IN_TSO3            27
+#define HSC_CSS_IN_ENCORDER0_IN    28
+#define HSC_CSS_IN_ENCORDER1_IN    29
+
+/* Port to receive from CSS */
+#define HSC_CSS_OUT_SRLTS0         0
+#define HSC_CSS_OUT_SRLTS1         1
+#define HSC_CSS_OUT_SRLTS2         2
+#define HSC_CSS_OUT_SRLTS3         3
+#define HSC_CSS_OUT_TSI0           4
+#define HSC_CSS_OUT_TSI1           5
+#define HSC_CSS_OUT_TSI2           6
+#define HSC_CSS_OUT_TSI3           7
+#define HSC_CSS_OUT_TSI4           8
+#define HSC_CSS_OUT_TSI5           9
+#define HSC_CSS_OUT_TSI6           10
+#define HSC_CSS_OUT_TSI7           11
+#define HSC_CSS_OUT_TSI8           12
+#define HSC_CSS_OUT_TSI9           13
+#define HSC_CSS_OUT_PARTS0         16
+#define HSC_CSS_OUT_PARTS1         17
+#define HSC_CSS_OUT_PKTFF0         20
+#define HSC_CSS_OUT_PKTFF1         21
+
+/* TS input interface */
+#define HSC_TS_IN0                 0
+#define HSC_TS_IN1                 1
+#define HSC_TS_IN2                 2
+#define HSC_TS_IN3                 3
+#define HSC_TS_IN4                 4
+#define HSC_TS_IN5                 5
+#define HSC_TS_IN6                 6
+#define HSC_TS_IN7                 7
+#define HSC_TS_IN8                 8
+#define HSC_TS_IN9                 9
+
+/* TS output interface */
+#define HSC_TS_OUT0                0
+#define HSC_TS_OUT1                1
+#define HSC_TS_OUT2                2
+#define HSC_TS_OUT3                3
+#define HSC_TS_OUT4                4
+#define HSC_TS_OUT5                5
+#define HSC_TS_OUT6                6
+#define HSC_TS_OUT7                7
+#define HSC_TS_OUT8                8
+#define HSC_TS_OUT9                9
+
+/* DMA to read from memory (Replay DMA) */
+#define HSC_DMA_IN0                0
+#define HSC_DMA_IN1                1
+#define HSC_DMA_IN2                2
+#define HSC_DMA_IN3                3
+#define HSC_DMA_IN4                4
+#define HSC_DMA_IN5                5
+#define HSC_DMA_IN6                6
+#define HSC_DMA_IN7                7
+#define HSC_DMA_IN8                8
+#define HSC_DMA_IN9                9
+#define HSC_DMA_CIP_IN0            10
+#define HSC_DMA_CIP_IN1            11
+
+/* DMA to write to memory (Record DMA) */
+#define HSC_DMA_OUT0               0
+#define HSC_DMA_OUT1               1
+#define HSC_DMA_OUT2               2
+#define HSC_DMA_OUT3               3
+#define HSC_DMA_OUT4               4
+#define HSC_DMA_OUT5               5
+#define HSC_DMA_OUT6               6
+#define HSC_DMA_OUT7               7
+#define HSC_DMA_OUT8               8
+#define HSC_DMA_OUT9               9
+#define HSC_DMA_CIP_OUT0           10
+#define HSC_DMA_CIP_OUT1           11
+
+#define HSC_STREAM_IF_NUM    2
+
+#define HSC_DMAIF_TS_BUFSIZE    (192 * 1024 * 5)
+
+struct hsc_ucode_buf {
+	void *buf_code;
+	dma_addr_t phys_code;
+	size_t size_code;
+	void *buf_data;
+	dma_addr_t phys_data;
+	size_t size_data;
+};
+
+struct hsc_spec_ucode {
+	const char *name_code;
+	const char *name_data;
+};
+
+struct hsc_spec_init_ram {
+	u32 addr;
+	size_t size;
+	u32 pattern;
+};
+
+struct hsc_reg_cmn {
+	int valid;
+	u32 reg;
+	int sft;
+};
+
+struct hsc_reg_css_pol {
+	int valid;
+	u32 reg;
+	int sft_sync;
+	int sft_val;
+	int sft_clk;
+};
+
+struct hsc_reg_css_sel {
+	int valid;
+	u32 reg;
+	u32 mask;
+	int sft;
+};
+
+struct hsc_spec_css {
+	struct hsc_reg_css_pol pol;
+	struct hsc_reg_css_sel sel;
+};
+
+struct hsc_spec_ts {
+	struct hsc_reg_cmn intr;
+};
+
+struct hsc_spec_dma {
+	/* DMA channel for CDMBC_CH* registers */
+	int dma_ch;
+	/* Ring buffer channel for CDMBC_RB* registers */
+	int rb_ch;
+	/* CIP file channel for CDMBC_CIP* registers */
+	int cip_ch;
+	/* Intermit transfer channel for CDMBC_IT* registers */
+	int it_ch;
+	/* DMA channel (output only) for CDMBC_CHTDCTR* registers */
+	int td_ch;
+	struct hsc_reg_cmn en;
+	struct hsc_reg_cmn intr;
+
+};
+
+struct hsc_spec {
+	struct hsc_spec_ucode ucode_spu;
+	struct hsc_spec_ucode ucode_ace;
+	const struct hsc_spec_init_ram *init_rams;
+	size_t num_init_rams;
+	const struct hsc_spec_css *css_in;
+	size_t num_css_in;
+	const struct hsc_spec_css *css_out;
+	size_t num_css_out;
+	const struct hsc_spec_ts *ts_in;
+	size_t num_ts_in;
+	const struct hsc_spec_dma *dma_in;
+	size_t num_dma_in;
+	const struct hsc_spec_dma *dma_out;
+	size_t num_dma_out;
+};
+
+struct hsc_tsif {
+	struct hsc_chip *chip;
+
+	struct dvb_adapter adapter;
+	struct dvb_demux demux;
+	struct dmxdev dmxdev;
+	struct dvb_frontend *fe;
+	int valid_adapter;
+	int valid_demux;
+	int valid_dmxdev;
+	int valid_fe;
+
+	int css_in;
+	int css_out;
+	int tsi;
+	int dpll;
+	int dpll_src;
+	struct hsc_dmaif *dmaif;
+
+	int running;
+	struct delayed_work recover_work;
+	unsigned long recover_delay;
+};
+
+struct hsc_dma {
+	struct hsc_chip *chip;
+
+	int id;
+	const struct hsc_spec_dma *spec;
+	struct hsc_dma_buf *buf;
+};
+
+struct hsc_dma_buf {
+	void *virt;
+	dma_addr_t phys;
+	u64 size;
+	u64 size_chk;
+	u64 rd_offs;
+	u64 wr_offs;
+	u64 chk_offs;
+};
+
+struct hsc_dmaif {
+	struct hsc_chip *chip;
+
+	struct hsc_dma_buf buf_out;
+	struct hsc_dma dma_out;
+
+	struct hsc_tsif *tsif;
+
+	/* guard read/write pointer of DMA buffer from interrupt handler */
+	spinlock_t lock;
+	int running;
+	struct work_struct feed_work;
+};
+
+struct hsc_chip {
+	const struct hsc_spec *spec;
+	short *adapter_nums;
+
+	struct platform_device *pdev;
+	struct regmap *regmap;
+	struct clk *clk_stdmac;
+	struct clk *clk_hsc;
+	struct reset_control *rst_stdmac;
+	struct reset_control *rst_hsc;
+
+	struct hsc_dmaif dmaif[HSC_STREAM_IF_NUM];
+	struct hsc_tsif tsif[HSC_STREAM_IF_NUM];
+
+	struct hsc_ucode_buf ucode_spu;
+	struct hsc_ucode_buf ucode_am;
+};
+
+struct hsc_conf {
+	int css_in;
+	int css_out;
+	int dpll;
+	int dma_out;
+};
+
+/* DMA */
+u64 hsc_rb_cnt(struct hsc_dma_buf *buf);
+u64 hsc_rb_cnt_to_end(struct hsc_dma_buf *buf);
+u64 hsc_rb_space(struct hsc_dma_buf *buf);
+u64 hsc_rb_space_to_end(struct hsc_dma_buf *buf);
+
+void hsc_dma_rb_set_buffer(struct hsc_chip *chip, int rb_ch, u64 bg, u64 ed);
+u64 hsc_dma_rb_get_rp(struct hsc_chip *chip, int rb_ch);
+void hsc_dma_rb_set_rp(struct hsc_chip *chip, int rb_ch, u64 pos);
+u64 hsc_dma_rb_get_wp(struct hsc_chip *chip, int rb_ch);
+void hsc_dma_rb_set_wp(struct hsc_chip *chip, int rb_ch, u64 pos);
+
+int hsc_dma_out_init(struct hsc_dma *dma_out, struct hsc_chip *chip,
+		     int id, struct hsc_dma_buf *buf);
+void hsc_dma_out_set_src_ts_in(struct hsc_dma *dma_out, int tsi);
+void hsc_dma_out_start(struct hsc_dma *dma_out, bool en);
+void hsc_dma_out_sync(struct hsc_dma *dma_out);
+int hsc_dma_out_get_intr(struct hsc_dma *dma_out, u32 *stat);
+void hsc_dma_out_clear_intr(struct hsc_dma *dma_out, u32 clear);
+
+#endif /* DVB_UNIPHIER_HSC_H__ */
-- 
2.18.0
