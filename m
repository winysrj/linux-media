Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:4065 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbeHHHn3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Aug 2018 03:43:29 -0400
From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: [PATCH v2 5/7] media: uniphier: add ucode load common file of HSC
Date: Wed,  8 Aug 2018 14:25:17 +0900
Message-Id: <20180808052519.14528-6-suzuki.katsuhiro@socionext.com>
In-Reply-To: <20180808052519.14528-1-suzuki.katsuhiro@socionext.com>
References: <20180808052519.14528-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds code to load uCode and start the internal cores of HSC for
Socionext UniPhier SoCs.

Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>

---

Changes from v1:
  - Split from large patches
  - Fix include lines
---
 drivers/media/platform/uniphier/Makefile    |   2 +-
 drivers/media/platform/uniphier/hsc-reg.h   |  59 +++
 drivers/media/platform/uniphier/hsc-ucode.c | 416 ++++++++++++++++++++
 drivers/media/platform/uniphier/hsc.h       |   4 +
 4 files changed, 480 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/uniphier/hsc-ucode.c

diff --git a/drivers/media/platform/uniphier/Makefile b/drivers/media/platform/uniphier/Makefile
index 2ba03067644d..79b4dc44df94 100644
--- a/drivers/media/platform/uniphier/Makefile
+++ b/drivers/media/platform/uniphier/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-uniphier-dvb-y += hsc-dma.o hsc-css.o hsc-ts.o
+uniphier-dvb-y += hsc-dma.o hsc-css.o hsc-ts.o hsc-ucode.o
 
 obj-$(CONFIG_DVB_UNIPHIER) += uniphier-dvb.o
diff --git a/drivers/media/platform/uniphier/hsc-reg.h b/drivers/media/platform/uniphier/hsc-reg.h
index 26f04b79178b..1ca3ad55330f 100644
--- a/drivers/media/platform/uniphier/hsc-reg.h
+++ b/drivers/media/platform/uniphier/hsc-reg.h
@@ -8,6 +8,65 @@
 #ifndef DVB_UNIPHIER_HSC_REG_H__
 #define DVB_UNIPHIER_HSC_REG_H__
 
+/* IOB1, 2, 3 */
+#define IOB_PKTCNT                    0x1740
+#define IOB_PKTCNTRST                 0x1744
+#define IOB_PKTCNTST                  0x1744
+#define IOB_DUMMY_ENABLE              0x1748
+#define IOB_FORMATCHANGE_EN           0x174c
+#define IOB_UASSIST0                  0x1750
+#define IOB_UASSIST1                  0x1754
+#define IOB_URESERVE(i)               (0x1758 + (i) * 0x4)
+#define IOB_PCRRECEN                  IOB_URESERVE(2)
+#define IOB_UPARTIAL(i)               (0x1768 + (i) * 0x4)
+#define IOB_SPUINTREN                 0x1778
+
+#define IOB_HSCREV                    0x1a00
+#define IOB_SECCLK(i)                 (0x1a08 + (i) * 0x6c)
+#define IOB_SECTIMEH(i)               (0x1a0c + (i) * 0x6c)
+#define IOB_SECTIMEL(i)               (0x1a10 + (i) * 0x6c)
+#define IOB_RESET0                    0x1a14
+#define   IOB_RESET0_APCORE             BIT(20)
+#define IOB_RESET1                    0x1a18
+#define IOB_CLKSTOP                   0x1a1c
+#define IOB_DEBUG                     0x1a20
+#define   IOB_DEBUG_SPUHALT             BIT(0)
+#define IOB_INTREN(i)                 (0x1a24 + (i) * 0x8)
+#define IOB_INTRST(i)                 (0x1a28 + (i) * 0x8)
+#define IOB_INTREN0                   0x1a24
+#define IOB_INTRST0                   0x1a28
+#define IOB_INTREN0_1                 0x1a2c
+#define IOB_INTRST0_1                 0x1a30
+#define IOB_INTREN0_2                 0x1a34
+#define IOB_INTRST0_2                 0x1a38
+#define IOB_INTREN1                   0x1a3c
+#define IOB_INTRST1                   0x1a40
+#define IOB_INTREN1_1                 0x1a44
+#define IOB_INTRST1_1                 0x1a48
+#define IOB_INTREN2                   0x1a4c
+#define IOB_INTRST2                   0x1a50
+#define   INTR2_DRV                     BIT(31)
+#define   INTR2_CIP_FRMT(i)             BIT((i) + 16)
+#define   INTR2_CIP_NORMAL              BIT(16)
+#define   INTR2_SEC_CLK_A               BIT(15)
+#define   INTR2_SEC_CLK_S               BIT(14)
+#define   INTR2_MBC_CIP_W(i)            BIT((i) + 9)
+#define   INTR2_MBC_CIP_R(i)            BIT((i) + 4)
+#define   INTR2_CIP_AUTH_A              BIT(1)
+#define   INTR2_CIP_AUTH_S              BIT(0)
+#define IOB_INTREN3                   0x1a54
+#define IOB_INTRST3                   0x1a58
+#define   INTR3_DRV                     BIT(31)
+#define   INTR3_CIP_FRMT(i)             BIT((i) + 16)
+#define   INTR3_SEC_CLK_A               BIT(15)
+#define   INTR3_SEC_CLK_S               BIT(14)
+#define   INTR3_MBC_CIP_W(i)            BIT((i) + 9)
+#define   INTR3_MBC_CIP_R(i)            BIT((i) + 4)
+#define   INTR3_CIP_AUTH_A              BIT(1)
+#define   INTR3_CIP_AUTH_S              BIT(0)
+#define IOB_INTREN4                   0x1a5c
+#define IOB_INTRST4                   0x1a60
+
 /* MBC1-7 Common */
 #define CDMBC_STRT(i)                (0x2300 + ((i) - 1) * 0x4)
 #define CDMBC_PERFCNFG               0x230c
diff --git a/drivers/media/platform/uniphier/hsc-ucode.c b/drivers/media/platform/uniphier/hsc-ucode.c
new file mode 100644
index 000000000000..9d9369914c48
--- /dev/null
+++ b/drivers/media/platform/uniphier/hsc-ucode.c
@@ -0,0 +1,416 @@
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
+#include <linux/regmap.h>
+
+#include "hsc.h"
+#include "hsc-reg.h"
+
+/* CIP SPU File */
+#define CIP_F_ID                         0x1540
+#define CIP_F_MODE                       0x1544
+#define CIP_F_CTRL                       0x1548
+#define CIP_F_SKIP                       0x154c
+#define CIP_F_PAYLOAD                    0x1560
+
+/* CIP file channel */
+#define CDMBC_CIPMODE(i)                 (0x24fc + (i) * 0x4)
+#define   CDMBC_CIPMODE_PUSH               BIT(0)
+#define CDMBC_CIPPRIORITY(i)             (0x2510 + (i) * 0x4)
+#define   CDMBC_CIPPRIORITY_PRIOR_MASK     GENMASK(1, 0)
+#define CDMBC_CH18ATTRIBUTE              (0x2524)
+
+/* UCODE DL */
+#define UCODE_REVISION_AM                0x10fd0
+#define CIP_UCODEADDR_AM1                0x10fd4
+#define CIP_UCODEADDR_AM0                0x10fd8
+#define CORRECTATS_CTRL                  0x10fdc
+#define UCODE_REVISION                   0x10fe0
+#define AM_UCODE_IGPGCTRL                0x10fe4
+#define REPDPLLCTRLEN                    0x10fe8
+#define UCODE_DLADDR1                    0x10fec
+#define UCODE_DLADDR0                    0x10ff0
+#define UCODE_ERRLOGCTRL                 0x10ff4
+
+struct hsc_cip_file_dma_param {
+	dma_addr_t cipr_start;
+	dma_addr_t cipw_start;
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
+	const struct hsc_spec_init_ram *rams = chip->spec->init_rams;
+	struct regmap *r = chip->regmap;
+	size_t i, s;
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
+
+	for (i = 0; i < chip->spec->num_init_rams; i++)
+		for (s = 0; s < rams[i].size; s += 4)
+			regmap_write(r, rams[i].addr + s, rams[i].pattern);
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
+				 const struct hsc_spec_dma *spec_r,
+				 const struct hsc_spec_dma *spec_w,
+				 struct hsc_cip_file_dma_param *p)
+{
+	struct regmap *r = chip->regmap;
+	dma_addr_t cipr_end, cipw_end;
+	u32 v;
+
+	/* For CIP Read */
+	v = FIELD_PREP(CDMBC_CHCTRL1_LINKCH1_MASK, 1) |
+		FIELD_PREP(CDMBC_CHCTRL1_STATSEL_MASK, 4) |
+		CDMBC_CHCTRL1_TYPE_INTERMIT;
+	regmap_write(r, CDMBC_CHCTRL1(spec_r->dma_ch), v);
+
+	regmap_write(r, CDMBC_CHCAUSECTRL(spec_r->dma_ch), 0);
+
+	v = FIELD_PREP(CDMBC_CHAMODE_ENDIAN_MASK, p->endian) |
+		FIELD_PREP(CDMBC_CHAMODE_AUPDT_MASK, 0) |
+		CDMBC_CHAMODE_TYPE_RB;
+	regmap_write(r, CDMBC_CHSRCAMODE(spec_r->dma_ch), v);
+
+	v = FIELD_PREP(CDMBC_CHAMODE_ENDIAN_MASK, 1) |
+		FIELD_PREP(CDMBC_CHAMODE_AUPDT_MASK, 2);
+	regmap_write(r, CDMBC_CHDSTAMODE(spec_r->dma_ch), v);
+
+	v = FIELD_PREP(CDMBC_CHDSTSTRTADRS_TID_MASK, 0xc) |
+		FIELD_PREP(CDMBC_CHDSTSTRTADRS_ID1_EN_MASK, p->id1_en) |
+		FIELD_PREP(CDMBC_CHDSTSTRTADRS_KEY_ID1_MASK, p->key_id1) |
+		FIELD_PREP(CDMBC_CHDSTSTRTADRS_KEY_ID0_MASK, p->key_id0);
+	regmap_write(r, CDMBC_CHDSTSTRTADRSD(spec_r->dma_ch), v);
+
+	regmap_write(r, CDMBC_CHSIZE(spec_r->dma_ch), p->inter_size);
+
+	cipr_end = p->cipr_start + p->total_size;
+	hsc_dma_rb_set_buffer(chip, spec_r->rb_ch, p->cipr_start, cipr_end);
+	hsc_dma_rb_set_rp(chip, spec_r->rb_ch, p->cipr_start);
+	hsc_dma_rb_set_wp(chip, spec_r->rb_ch, cipr_end);
+
+	/* For CIP Write */
+	v = FIELD_PREP(CDMBC_CHCTRL1_LINKCH1_MASK, 5) |
+		FIELD_PREP(CDMBC_CHCTRL1_STATSEL_MASK, 4) |
+		CDMBC_CHCTRL1_TYPE_INTERMIT |
+		CDMBC_CHCTRL1_IND_SIZE_UND;
+	regmap_write(r, CDMBC_CHCTRL1(spec_w->dma_ch), v);
+
+	v = FIELD_PREP(CDMBC_CHAMODE_ENDIAN_MASK, 1) |
+		FIELD_PREP(CDMBC_CHAMODE_AUPDT_MASK, 2);
+	regmap_write(r, CDMBC_CHSRCAMODE(spec_w->dma_ch), v);
+
+	v = FIELD_PREP(CDMBC_CHAMODE_ENDIAN_MASK, p->endian) |
+		FIELD_PREP(CDMBC_CHAMODE_AUPDT_MASK, 0) |
+		CDMBC_CHAMODE_TYPE_RB;
+	regmap_write(r, CDMBC_CHDSTAMODE(spec_w->dma_ch), v);
+
+	cipw_end = p->cipw_start + p->total_size;
+	hsc_dma_rb_set_buffer(chip, spec_w->rb_ch, p->cipw_start, cipw_end);
+	hsc_dma_rb_set_rp(chip, spec_w->rb_ch, cipw_end);
+	hsc_dma_rb_set_wp(chip, spec_w->rb_ch, p->cipw_start);
+
+	/* Transferring size */
+	regmap_write(r, CDMBC_ITSTEPS(spec_r->it_ch), p->total_size);
+
+	/* CIP settings */
+	regmap_write(r, CDMBC_CIPMODE(spec_r->cip_ch),
+		     (p->push) ? CDMBC_CIPMODE_PUSH : 0);
+
+	regmap_write(r, CDMBC_CIPPRIORITY(spec_r->cip_ch),
+		     FIELD_PREP(CDMBC_CIPPRIORITY_PRIOR_MASK, 3));
+}
+
+static void file_channel_start(struct hsc_chip *chip,
+			       const struct hsc_spec_dma *spec_r,
+			       const struct hsc_spec_dma *spec_w,
+			       bool push, bool mmu_en)
+{
+	struct regmap *r = chip->regmap;
+	u32 v;
+
+	regmap_write(r, CDMBC_CIPMODE(spec_r->cip_ch),
+		     (push) ? CDMBC_CIPMODE_PUSH : 0);
+
+	if (mmu_en) {
+		v = CDMBC_CHDDR_REG_LOAD_ON | CDMBC_CHDDR_AT_CHEN_ON;
+
+		/* Enable IOMMU for CIP-R and CIP-W */
+		regmap_write(r, CDMBC_CHDDR(spec_r->dma_ch),
+			     v | CDMBC_CHDDR_SET_MCB_RD);
+		regmap_write(r, CDMBC_CHDDR(spec_w->dma_ch),
+			     v | CDMBC_CHDDR_SET_MCB_WR);
+	}
+
+	v = 0x01000000 | (1 << spec_r->en.sft) | (1 << spec_w->en.sft);
+	regmap_write(r, CDMBC_STRT(1), v);
+}
+
+static void file_channel_wait(struct hsc_chip *chip,
+			      const struct hsc_spec_dma *spec)
+{
+	struct regmap *r = chip->regmap;
+	u32 v;
+
+	regmap_read(r, CDMBC_CHIR(spec->dma_ch), &v);
+	while (!(v & INTR_MBC_CH_WDONE)) {
+		usleep_range(1000, 10000);
+		regmap_read(r, CDMBC_CHIR(spec->dma_ch), &v);
+	};
+	regmap_write(r, CDMBC_CHIR(spec->dma_ch), v);
+
+	regmap_read(r, CDMBC_RBIR(spec->dma_ch), &v);
+	regmap_write(r, CDMBC_RBIR(spec->dma_ch), v);
+}
+
+static int ucode_load_dma(struct hsc_chip *chip, int mode)
+{
+	const struct hsc_spec_dma *spec_r, *spec_w;
+	struct regmap *r = chip->regmap;
+	struct hsc_ucode_buf *ucode;
+	struct hsc_cip_file_dma_param dma_p = {0};
+	u32 cip_f_ctrl;
+
+	spec_r = &chip->spec->dma_in[HSC_DMA_CIP_IN0];
+	spec_w = &chip->spec->dma_out[HSC_DMA_CIP_OUT0];
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
+	dma_p.cipr_start = ucode->phys_code;
+	dma_p.cipw_start = 0;
+	dma_p.inter_size = ucode->size_code;
+	dma_p.total_size = ucode->size_code;
+	dma_p.key_id1 = 0;
+	dma_p.key_id0 = 0;
+	dma_p.endian = 1;
+	dma_p.id1_en = 0;
+	file_channel_dma_set(chip, spec_r, spec_w, &dma_p);
+	file_channel_start(chip, spec_r, spec_w, true, false);
+
+	file_channel_wait(chip, spec_r);
+	file_channel_wait(chip, spec_w);
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
+	struct regmap *r = chip->regmap;
+	int ret;
+
+	core_start(chip);
+
+	ret = ucode_load(chip, HSC_UCODE_SPU_0);
+	if (ret)
+		return ret;
+
+	/* Start SPU core */
+	regmap_write(r, IOB_DEBUG, 0);
+
+	ret = ucode_load(chip, HSC_UCODE_ACE);
+	if (ret)
+		return ret;
+
+	/* Start AP core */
+	regmap_write(r, IOB_RESET0, 0);
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
diff --git a/drivers/media/platform/uniphier/hsc.h b/drivers/media/platform/uniphier/hsc.h
index a10b7a480193..bbfd90ffaad5 100644
--- a/drivers/media/platform/uniphier/hsc.h
+++ b/drivers/media/platform/uniphier/hsc.h
@@ -372,4 +372,8 @@ void hsc_dma_out_sync(struct hsc_dma *dma_out);
 int hsc_dma_out_get_intr(struct hsc_dma *dma_out, u32 *stat);
 void hsc_dma_out_clear_intr(struct hsc_dma *dma_out, u32 clear);
 
+/* UCODE DL */
+int hsc_ucode_load_all(struct hsc_chip *chip);
+int hsc_ucode_unload_all(struct hsc_chip *chip);
+
 #endif /* DVB_UNIPHIER_HSC_H__ */
-- 
2.18.0
