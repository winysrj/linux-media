Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:39024 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751810AbdF3GD0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 02:03:26 -0400
From: <sean.wang@mediatek.com>
To: <mchehab@osg.samsung.com>, <sean@mess.org>, <hdegoede@redhat.com>,
        <hkallweit1@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <matthias.bgg@gmail.com>
CC: <andi.shyti@samsung.com>, <hverkuil@xs4all.nl>,
        <ivo.g.dimitrov.75@gmail.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH v1 3/4] media: rc: mtk-cir: add support for MediaTek MT7622 SoC
Date: Fri, 30 Jun 2017 14:03:06 +0800
Message-ID: <37ff7a2deabfddfd899613caf13209754e9ac68a.1498794408.git.sean.wang@mediatek.com>
In-Reply-To: <cover.1498794408.git.sean.wang@mediatek.com>
References: <cover.1498794408.git.sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sean Wang <sean.wang@mediatek.com>

This patch adds driver for CIR controller on MT7622 SoC. It has similar
handling logic as the previously MT7623 does, but there are some
differences in the register and field definition. So for ease portability
and maintenance, those differences all are being kept inside the platform
data as other drivers usually do. Currently testing successfully on NEC
and SONY remote controller.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/media/rc/mtk-cir.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/rc/mtk-cir.c b/drivers/media/rc/mtk-cir.c
index 32b1031..6672772 100644
--- a/drivers/media/rc/mtk-cir.c
+++ b/drivers/media/rc/mtk-cir.c
@@ -84,6 +84,13 @@ static const u32 mt7623_regs[] = {
 	[MTK_IRINT_CLR_REG] =	0xd0,
 };
 
+static const u32 mt7622_regs[] = {
+	[MTK_IRCLR_REG] =	0x18,
+	[MTK_CHKDATA_REG] =	0x30,
+	[MTK_IRINT_EN_REG] =	0x1c,
+	[MTK_IRINT_CLR_REG] =	0x20,
+};
+
 struct mtk_field_type {
 	u32 reg;
 	u8 offset;
@@ -113,6 +120,11 @@ static const struct mtk_field_type mt7623_fields[] = {
 	[MTK_HW_PERIOD] = {0x10, 0, GENMASK(7, 0)},
 };
 
+static const struct mtk_field_type mt7622_fields[] = {
+	[MTK_CHK_PERIOD] = {0x24, 0, GENMASK(24, 0)},
+	[MTK_HW_PERIOD] = {0x10, 0, GENMASK(24, 0)},
+};
+
 /*
  * struct mtk_ir -	This is the main datasructure for holding the state
  *			of the driver
@@ -268,8 +280,17 @@ static const struct mtk_ir_data mt7623_data = {
 	.div	= 4,
 };
 
+static const struct mtk_ir_data mt7622_data = {
+	.regs = mt7622_regs,
+	.fields = mt7622_fields,
+	.ok_count = 0xf,
+	.hw_period = 0xffff,
+	.div	= 32,
+};
+
 static const struct of_device_id mtk_ir_match[] = {
 	{ .compatible = "mediatek,mt7623-cir", .data = &mt7623_data},
+	{ .compatible = "mediatek,mt7622-cir", .data = &mt7622_data},
 	{},
 };
 MODULE_DEVICE_TABLE(of, mtk_ir_match);
-- 
2.7.4
