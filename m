Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:4068 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbeHHHn2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Aug 2018 03:43:28 -0400
From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: [PATCH v2 4/7] media: uniphier: add TS common file of HSC
Date: Wed,  8 Aug 2018 14:25:16 +0900
Message-Id: <20180808052519.14528-5-suzuki.katsuhiro@socionext.com>
In-Reply-To: <20180808052519.14528-1-suzuki.katsuhiro@socionext.com>
References: <20180808052519.14528-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add TS input/output code to start/stop configure the MPEG2-TS ports
of HSC for Socionext UniPhier SoCs.

Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>

---

Changes from v1:
  - Split from large patches
  - Fix include lines
---
 drivers/media/platform/uniphier/Makefile  |   2 +-
 drivers/media/platform/uniphier/hsc-reg.h |  41 +++++++
 drivers/media/platform/uniphier/hsc-ts.c  | 127 ++++++++++++++++++++++
 drivers/media/platform/uniphier/hsc.h     |   6 +
 4 files changed, 175 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/uniphier/hsc-ts.c

diff --git a/drivers/media/platform/uniphier/Makefile b/drivers/media/platform/uniphier/Makefile
index 59be2edf0c53..2ba03067644d 100644
--- a/drivers/media/platform/uniphier/Makefile
+++ b/drivers/media/platform/uniphier/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-uniphier-dvb-y += hsc-dma.o hsc-css.o
+uniphier-dvb-y += hsc-dma.o hsc-css.o hsc-ts.o
 
 obj-$(CONFIG_DVB_UNIPHIER) += uniphier-dvb.o
diff --git a/drivers/media/platform/uniphier/hsc-reg.h b/drivers/media/platform/uniphier/hsc-reg.h
index e5bc87658361..26f04b79178b 100644
--- a/drivers/media/platform/uniphier/hsc-reg.h
+++ b/drivers/media/platform/uniphier/hsc-reg.h
@@ -144,4 +144,45 @@
 #define   CSS_DPCTRL_DPSEL_TSI1            BIT(1)
 #define   CSS_DPCTRL_DPSEL_TSI0            BIT(0)
 
+/* TSI */
+#define TSI_SYNCCNTROL(i)                (0x7100 + (i) * 0x70)
+#define   TSI_SYNCCNTROL_FRAME_MASK        GENMASK(18, 16)
+#define   TSI_SYNCCNTROL_FRAME_EXTSYNC1    (0x0 << 16)
+#define   TSI_SYNCCNTROL_FRAME_EXTSYNC2    (0x1 << 16)
+#define TSI_CONFIG(i)                    (0x7104 + (i) * 0x70)
+#define   TSI_CONFIG_ATSMD_MASK            GENMASK(22, 21)
+#define   TSI_CONFIG_ATSMD_PCRPLL0         (0x0 << 21)
+#define   TSI_CONFIG_ATSMD_PCRPLL1         (0x1 << 21)
+#define   TSI_CONFIG_ATSMD_DPLL            (0x3 << 21)
+#define   TSI_CONFIG_ATSADD_ON             BIT(20)
+#define   TSI_CONFIG_STCMD_MASK            GENMASK(7, 6)
+#define   TSI_CONFIG_STCMD_PCRPLL0         (0x0 << 6)
+#define   TSI_CONFIG_STCMD_PCRPLL1         (0x1 << 6)
+#define   TSI_CONFIG_STCMD_DPLL            (0x3 << 6)
+#define   TSI_CONFIG_CHEN_START            BIT(0)
+#define TSI_RATEUPLMT(i)                 (0x7108 + (i) * 0x70)
+#define TSI_RATELOWLMT(i)                (0x710c + (i) * 0x70)
+#define TSI_CNTINTR(i)                   (0x7110 + (i) * 0x70)
+#define TSI_INTREN(i)                    (0x7114 + (i) * 0x70)
+#define   TSI_INTR_NTP                     BIT(13)
+#define   TSI_INTR_NTPCNT                  BIT(12)
+#define   TSI_INTR_PKTEND                  BIT(11)
+#define   TSI_INTR_PCR                     BIT(9)
+#define   TSI_INTR_LOAD                    BIT(8)
+#define   TSI_INTR_SERR                    BIT(7)
+#define   TSI_INTR_SOF                     BIT(6)
+#define   TSI_INTR_TOF                     BIT(5)
+#define   TSI_INTR_UL                      BIT(4)
+#define   TSI_INTR_LL                      BIT(3)
+#define   TSI_INTR_CNT                     BIT(2)
+#define   TSI_INTR_LOST                    BIT(1)
+#define   TSI_INTR_LOCK                    BIT(0)
+#define TSI_SYNCSTATUS(i)                (0x7118 + (i) * 0x70)
+#define   TSI_STAT_PKTST_ERR               BIT(21)
+#define   TSI_STAT_LARGE_ERR               BIT(20)
+#define   TSI_STAT_SMALL_ERR               BIT(19)
+#define   TSI_STAT_LOCK                    BIT(18)
+#define   TSI_STAT_SYNC                    BIT(17)
+#define   TSI_STAT_SEARCH                  BIT(16)
+
 #endif /* DVB_UNIPHIER_HSC_REG_H__ */
diff --git a/drivers/media/platform/uniphier/hsc-ts.c b/drivers/media/platform/uniphier/hsc-ts.c
new file mode 100644
index 000000000000..bb70429301ad
--- /dev/null
+++ b/drivers/media/platform/uniphier/hsc-ts.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
+// MPEG2-TS input/output port setting.
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
+/* SBC1, 2 */
+#define SBC_ACE_DMA_EN                0x6000
+#define SBC_DMAPARAM21                0x6004
+#define SBC_ACE_INTREN                0x6008
+#define SBC_ACE_INTRST                0x600c
+#define SBC_DMA_STATUS0               0x6010
+#define SBC_DMA_STATUS1               0x6014
+#define SBC_DMAPARAMA(i)              (0x6018 + (i) * 0x04)
+#define   SBC_DMAPARAMA_OFFSET_MASK     GENMASK(31, 29)
+#define   SBC_DMAPARAMA_LOOPADDR_MASK   GENMASK(28, 23)
+#define   SBC_DMAPARAMA_COUNT_MASK      GENMASK(7, 0)
+#define SBC_DMAPARAMB(i)              (0x6038 + (i) * 0x04)
+
+#define PARAMA_OFFSET_TS      0x02
+#define PARAMA_LOOPADDR_TS    0x31
+#define PARAMA_COUNT_TS       0xc4
+
+static bool ts_in_is_valid(struct hsc_chip *chip, int tsi)
+{
+	return tsi < chip->spec->num_ts_in && chip->spec->ts_in[tsi].intr.valid;
+}
+
+static const struct hsc_spec_ts *ts_in_get_spec(struct hsc_chip *chip, int tsi)
+{
+	const struct hsc_spec_ts *spec = chip->spec->ts_in;
+
+	if (!ts_in_is_valid(chip, tsi))
+		return NULL;
+
+	return &spec[tsi];
+}
+
+int hsc_ts_in_set_enable(struct hsc_chip *chip, int tsi, bool en)
+{
+	struct regmap *r = chip->regmap;
+	const struct hsc_spec_ts *speci = ts_in_get_spec(chip, tsi);
+	u32 m, v;
+
+	if (!speci)
+		return -EINVAL;
+
+	m = TSI_SYNCCNTROL_FRAME_MASK;
+	v = TSI_SYNCCNTROL_FRAME_EXTSYNC2;
+	regmap_update_bits(r, TSI_SYNCCNTROL(tsi), m, v);
+
+	m = TSI_CONFIG_ATSMD_MASK | TSI_CONFIG_STCMD_MASK |
+		TSI_CONFIG_CHEN_START;
+	v = TSI_CONFIG_ATSMD_DPLL | TSI_CONFIG_STCMD_DPLL;
+	if (en)
+		v |= TSI_CONFIG_CHEN_START;
+	regmap_update_bits(r, TSI_CONFIG(tsi), m, v);
+
+	v = (en) ? ~0 : 0;
+	regmap_update_bits(r, TSI_INTREN(tsi),
+			   TSI_INTR_SERR | TSI_INTR_LOST, v);
+	regmap_update_bits(r, speci->intr.reg, BIT(speci->intr.sft), v);
+
+	return 0;
+}
+
+int hsc_ts_in_set_dmaparam(struct hsc_chip *chip, int tsi, int ifmt)
+{
+	struct regmap *r = chip->regmap;
+	u32 v, ats, offset, loop, cnt;
+
+	if (!ts_in_is_valid(chip, tsi))
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
+	regmap_update_bits(r, TSI_CONFIG(tsi), TSI_CONFIG_ATSADD_ON, ats);
+
+	v = FIELD_PREP(SBC_DMAPARAMA_OFFSET_MASK, offset) |
+		FIELD_PREP(SBC_DMAPARAMA_LOOPADDR_MASK, loop) |
+		FIELD_PREP(SBC_DMAPARAMA_COUNT_MASK, cnt);
+	regmap_write(r, SBC_DMAPARAMA(tsi), v);
+
+	return 0;
+}
+
+int hsc_ts_in_get_intr(struct hsc_chip *chip, int tsi, u32 *stat)
+{
+	struct regmap *r = chip->regmap;
+
+	if (!stat)
+		return -EINVAL;
+
+	regmap_read(r, TSI_SYNCSTATUS(tsi), stat);
+
+	return 0;
+}
+
+void hsc_ts_in_clear_intr(struct hsc_chip *chip, int tsi, u32 clear)
+{
+	struct regmap *r = chip->regmap;
+
+	regmap_write(r, TSI_SYNCSTATUS(tsi), clear);
+}
diff --git a/drivers/media/platform/uniphier/hsc.h b/drivers/media/platform/uniphier/hsc.h
index 1cbd17b475bf..a10b7a480193 100644
--- a/drivers/media/platform/uniphier/hsc.h
+++ b/drivers/media/platform/uniphier/hsc.h
@@ -346,6 +346,12 @@ int hsc_css_out_set_polarity(struct hsc_chip *chip, int out,
 int hsc_css_out_get_src(struct hsc_chip *chip, int *in, int out, bool *en);
 int hsc_css_out_set_src(struct hsc_chip *chip, int in, int out, bool en);
 
+/* TS */
+int hsc_ts_in_set_enable(struct hsc_chip *chip, int tsi, bool en);
+int hsc_ts_in_set_dmaparam(struct hsc_chip *chip, int tsi, int ifmt);
+int hsc_ts_in_get_intr(struct hsc_chip *chip, int tsi, u32 *st);
+void hsc_ts_in_clear_intr(struct hsc_chip *chip, int tsi, u32 clear);
+
 /* DMA */
 u64 hsc_rb_cnt(struct hsc_dma_buf *buf);
 u64 hsc_rb_cnt_to_end(struct hsc_dma_buf *buf);
-- 
2.18.0
