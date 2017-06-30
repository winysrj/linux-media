Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:47302 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751920AbdF3GD1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 02:03:27 -0400
From: <sean.wang@mediatek.com>
To: <mchehab@osg.samsung.com>, <sean@mess.org>, <hdegoede@redhat.com>,
        <hkallweit1@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <matthias.bgg@gmail.com>
CC: <andi.shyti@samsung.com>, <hverkuil@xs4all.nl>,
        <ivo.g.dimitrov.75@gmail.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH v1 2/4] media: rc: mtk-cir: add platform data to adapt into various hardware
Date: Fri, 30 Jun 2017 14:03:05 +0800
Message-ID: <b48f5edc7894155d972bc27fed89de51f0405924.1498794408.git.sean.wang@mediatek.com>
In-Reply-To: <cover.1498794408.git.sean.wang@mediatek.com>
References: <cover.1498794408.git.sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sean Wang <sean.wang@mediatek.com>

This patch is the preparation patch in order to adapt into various
hardware through adding platform data which holds specific characteristics
and differences among MediaTek supported CIR devices instead of the old
way defining those data in the static way as macro has. And the existing
logic would be slightly changed to operate on those data which the actual
device depends on.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/media/rc/mtk-cir.c | 221 +++++++++++++++++++++++++++++++++------------
 1 file changed, 165 insertions(+), 56 deletions(-)

diff --git a/drivers/media/rc/mtk-cir.c b/drivers/media/rc/mtk-cir.c
index f1e164e..32b1031 100644
--- a/drivers/media/rc/mtk-cir.c
+++ b/drivers/media/rc/mtk-cir.c
@@ -25,35 +25,28 @@
 
 /* Register to enable PWM and IR */
 #define MTK_CONFIG_HIGH_REG       0x0c
-/* Enable IR pulse width detection */
+
+/* Bit to enable IR pulse width detection */
 #define MTK_PWM_EN		  BIT(13)
-/* Enable IR hardware function */
-#define MTK_IR_EN		  BIT(0)
 
-/* Register to setting sample period */
-#define MTK_CONFIG_LOW_REG        0x10
-/* Field to set sample period */
-#define CHK_PERIOD		  DIV_ROUND_CLOSEST(MTK_IR_SAMPLE,  \
-						    MTK_IR_CLK_PERIOD)
-#define MTK_CHK_PERIOD            (((CHK_PERIOD) << 8) & (GENMASK(20, 8)))
-#define MTK_CHK_PERIOD_MASK	  (GENMASK(20, 8))
+/*
+ * Register to setting ok count whose unit based on hardware sampling period
+ * indicating IR receiving completion and then making IRQ fires
+ */
+#define MTK_OK_COUNT(x)		  (((x) & GENMASK(23, 16)) << 16)
+
+/* Bit to enable IR hardware function */
+#define MTK_IR_EN		  BIT(0)
 
-/* Register to clear state of state machine */
-#define MTK_IRCLR_REG             0x20
 /* Bit to restart IR receiving */
 #define MTK_IRCLR		  BIT(0)
 
-/* Register containing pulse width data */
-#define MTK_CHKDATA_REG(i)        (0x88 + 4 * (i))
+/* Fields containing pulse width data */
 #define MTK_WIDTH_MASK		  (GENMASK(7, 0))
 
-/* Register to enable IR interrupt */
-#define MTK_IRINT_EN_REG          0xcc
 /* Bit to enable interrupt */
 #define MTK_IRINT_EN		  BIT(0)
 
-/* Register to ack IR interrupt */
-#define MTK_IRINT_CLR_REG         0xd0
 /* Bit to clear interrupt status */
 #define MTK_IRINT_CLR		  BIT(0)
 
@@ -63,24 +56,73 @@
 #define MTK_IR_END(v, p)	  ((v) == MTK_MAX_SAMPLES && (p) == 0)
 /* Number of registers to record the pulse width */
 #define MTK_CHKDATA_SZ		  17
-/* Source clock frequency */
-#define MTK_IR_BASE_CLK		  273000000
-/* Frequency after IR internal divider */
-#define MTK_IR_CLK_FREQ		  (MTK_IR_BASE_CLK / 4)
-/* Period for MTK_IR_CLK in ns*/
-#define MTK_IR_CLK_PERIOD	  DIV_ROUND_CLOSEST(1000000000ul,  \
-						    MTK_IR_CLK_FREQ)
 /* Sample period in ns */
-#define MTK_IR_SAMPLE		  (MTK_IR_CLK_PERIOD * 0xc00)
+#define MTK_IR_SAMPLE		  46000
+
+enum mtk_fields {
+	/* Register to setting software sampling period */
+	MTK_CHK_PERIOD,
+	/* Register to setting hardware sampling period */
+	MTK_HW_PERIOD,
+};
+
+enum mtk_regs {
+	/* Register to clear state of state machine */
+	MTK_IRCLR_REG,
+	/* Register containing pulse width data */
+	MTK_CHKDATA_REG,
+	/* Register to enable IR interrupt */
+	MTK_IRINT_EN_REG,
+	/* Register to ack IR interrupt */
+	MTK_IRINT_CLR_REG
+};
+
+static const u32 mt7623_regs[] = {
+	[MTK_IRCLR_REG] =	0x20,
+	[MTK_CHKDATA_REG] =	0x88,
+	[MTK_IRINT_EN_REG] =	0xcc,
+	[MTK_IRINT_CLR_REG] =	0xd0,
+};
+
+struct mtk_field_type {
+	u32 reg;
+	u8 offset;
+	u32 mask;
+};
+
+/*
+ * struct mtk_ir_data -	This is the structure holding all differences among
+			various hardwares
+ * @regs:		The pointer to the array holding registers offset
+ * @fields:		The pointer to the array holding fields location
+ * @div:		The internal divisor for the based reference clock
+ * @ok_count:		The count indicating the completion of IR data
+ *			receiving when count is reached
+ * @hw_period:		The value indicating the hardware sampling period
+ */
+struct mtk_ir_data {
+	const u32 *regs;
+	const struct mtk_field_type *fields;
+	u8 div;
+	u8 ok_count;
+	u32 hw_period;
+};
+
+static const struct mtk_field_type mt7623_fields[] = {
+	[MTK_CHK_PERIOD] = {0x10, 8, GENMASK(20, 8)},
+	[MTK_HW_PERIOD] = {0x10, 0, GENMASK(7, 0)},
+};
 
 /*
  * struct mtk_ir -	This is the main datasructure for holding the state
  *			of the driver
  * @dev:		The device pointer
  * @rc:			The rc instrance
- * @irq:		The IRQ that we are using
  * @base:		The mapped register i/o base
- * @clk:		The clock that we are using
+ * @irq:		The IRQ that we are using
+ * @clk:		The clock that IR internal is using
+ * @bus:		The clock that software decoder is using
+ * @data:		Holding specific data for vaious platform
  */
 struct mtk_ir {
 	struct device	*dev;
@@ -88,8 +130,36 @@ struct mtk_ir {
 	void __iomem	*base;
 	int		irq;
 	struct clk	*clk;
+	struct clk	*bus;
+	const struct mtk_ir_data *data;
 };
 
+static inline u32 mtk_chkdata_reg(struct mtk_ir *ir, u32 i)
+{
+	return ir->data->regs[MTK_CHKDATA_REG] + 4 * i;
+}
+
+static inline u32 mtk_chk_period(struct mtk_ir *ir)
+{
+	u32 val;
+
+	/* Period of raw software sampling in ns */
+	val = DIV_ROUND_CLOSEST(1000000000ul,
+				clk_get_rate(ir->bus) / ir->data->div);
+
+	/*
+	 * Period for software decoder used in the
+	 * unit of raw software sampling
+	 */
+	val = DIV_ROUND_CLOSEST(MTK_IR_SAMPLE, val);
+
+	dev_dbg(ir->dev, "@pwm clk  = \t%lu\n",
+		clk_get_rate(ir->bus) / ir->data->div);
+	dev_dbg(ir->dev, "@chkperiod = %08x\n", val);
+
+	return val;
+}
+
 static void mtk_w32_mask(struct mtk_ir *ir, u32 val, u32 mask, unsigned int reg)
 {
 	u32 tmp;
@@ -113,16 +183,16 @@ static inline void mtk_irq_disable(struct mtk_ir *ir, u32 mask)
 {
 	u32 val;
 
-	val = mtk_r32(ir, MTK_IRINT_EN_REG);
-	mtk_w32(ir, val & ~mask, MTK_IRINT_EN_REG);
+	val = mtk_r32(ir, ir->data->regs[MTK_IRINT_EN_REG]);
+	mtk_w32(ir, val & ~mask, ir->data->regs[MTK_IRINT_EN_REG]);
 }
 
 static inline void mtk_irq_enable(struct mtk_ir *ir, u32 mask)
 {
 	u32 val;
 
-	val = mtk_r32(ir, MTK_IRINT_EN_REG);
-	mtk_w32(ir, val | mask, MTK_IRINT_EN_REG);
+	val = mtk_r32(ir, ir->data->regs[MTK_IRINT_EN_REG]);
+	mtk_w32(ir, val | mask, ir->data->regs[MTK_IRINT_EN_REG]);
 }
 
 static irqreturn_t mtk_ir_irq(int irqno, void *dev_id)
@@ -140,7 +210,7 @@ static irqreturn_t mtk_ir_irq(int irqno, void *dev_id)
 	 * every decoder to reset themselves through long enough
 	 * trailing spaces and 2) the IRQ handler guarantees that
 	 * start of IR message is always contained in and starting
-	 * from register MTK_CHKDATA_REG(0).
+	 * from register mtk_chkdata_reg(ir, i).
 	 */
 	ir_raw_event_reset(ir->rc);
 
@@ -149,7 +219,7 @@ static irqreturn_t mtk_ir_irq(int irqno, void *dev_id)
 
 	/* Handle all pulse and space IR controller captures */
 	for (i = 0 ; i < MTK_CHKDATA_SZ ; i++) {
-		val = mtk_r32(ir, MTK_CHKDATA_REG(i));
+		val = mtk_r32(ir, mtk_chkdata_reg(ir, i));
 		dev_dbg(ir->dev, "@reg%d=0x%08x\n", i, val);
 
 		for (j = 0 ; j < 4 ; j++) {
@@ -181,18 +251,35 @@ static irqreturn_t mtk_ir_irq(int irqno, void *dev_id)
 	 * Restart controller for the next receive that would
 	 * clear up all CHKDATA registers
 	 */
-	mtk_w32_mask(ir, 0x1, MTK_IRCLR, MTK_IRCLR_REG);
+	mtk_w32_mask(ir, 0x1, MTK_IRCLR, ir->data->regs[MTK_IRCLR_REG]);
 
 	/* Clear interrupt status */
-	mtk_w32_mask(ir, 0x1, MTK_IRINT_CLR, MTK_IRINT_CLR_REG);
+	mtk_w32_mask(ir, 0x1, MTK_IRINT_CLR,
+		     ir->data->regs[MTK_IRINT_CLR_REG]);
 
 	return IRQ_HANDLED;
 }
 
+static const struct mtk_ir_data mt7623_data = {
+	.regs = mt7623_regs,
+	.fields = mt7623_fields,
+	.ok_count = 0xf,
+	.hw_period = 0xff,
+	.div	= 4,
+};
+
+static const struct of_device_id mtk_ir_match[] = {
+	{ .compatible = "mediatek,mt7623-cir", .data = &mt7623_data},
+	{},
+};
+MODULE_DEVICE_TABLE(of, mtk_ir_match);
+
 static int mtk_ir_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *dn = dev->of_node;
+	const struct of_device_id *of_id =
+		of_match_device(mtk_ir_match, &pdev->dev);
 	struct resource *res;
 	struct mtk_ir *ir;
 	u32 val;
@@ -204,9 +291,7 @@ static int mtk_ir_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ir->dev = dev;
-
-	if (!of_device_is_compatible(dn, "mediatek,mt7623-cir"))
-		return -ENODEV;
+	ir->data = of_id->data;
 
 	ir->clk = devm_clk_get(dev, "clk");
 	if (IS_ERR(ir->clk)) {
@@ -214,6 +299,15 @@ static int mtk_ir_probe(struct platform_device *pdev)
 		return PTR_ERR(ir->clk);
 	}
 
+	ir->bus = devm_clk_get(dev, "bus");
+	if (IS_ERR(ir->bus)) {
+		/*
+		 * For compatibility with older device trees try unnamed
+		 * ir->bus uses the same clock as ir->clock.
+		 */
+		ir->bus = ir->clk;
+	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	ir->base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(ir->base)) {
@@ -256,40 +350,60 @@ static int mtk_ir_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	/*
-	 * Enable interrupt after proper hardware
-	 * setup and IRQ handler registration
-	 */
 	if (clk_prepare_enable(ir->clk)) {
 		dev_err(dev, "try to enable ir_clk failed\n");
+		return -EINVAL;
+	}
+
+	if (clk_prepare_enable(ir->bus)) {
+		dev_err(dev, "try to enable ir_clk failed\n");
 		ret = -EINVAL;
 		goto exit_clkdisable_clk;
 	}
 
+	/*
+	 * Enable interrupt after proper hardware
+	 * setup and IRQ handler registration
+	 */
 	mtk_irq_disable(ir, MTK_IRINT_EN);
 
 	ret = devm_request_irq(dev, ir->irq, mtk_ir_irq, 0, MTK_IR_DEV, ir);
 	if (ret) {
 		dev_err(dev, "failed request irq\n");
-		goto exit_clkdisable_clk;
+		goto exit_clkdisable_bus;
 	}
 
+	/*
+	 * Setup software sample period as the reference of software decoder
+	 */
+	val = (mtk_chk_period(ir) << ir->data->fields[MTK_CHK_PERIOD].offset) &
+	       ir->data->fields[MTK_CHK_PERIOD].mask;
+	mtk_w32_mask(ir, val, ir->data->fields[MTK_CHK_PERIOD].mask,
+		     ir->data->fields[MTK_CHK_PERIOD].reg);
+
+	/*
+	 * Setup hardware sampling period used to setup the proper timeout for
+	 * indicating end of IR receiving completion
+	 */
+	val = (ir->data->hw_period << ir->data->fields[MTK_HW_PERIOD].offset) &
+	       ir->data->fields[MTK_HW_PERIOD].mask;
+	mtk_w32_mask(ir, val, ir->data->fields[MTK_HW_PERIOD].mask,
+		     ir->data->fields[MTK_HW_PERIOD].reg);
+
 	/* Enable IR and PWM */
 	val = mtk_r32(ir, MTK_CONFIG_HIGH_REG);
-	val |= MTK_PWM_EN | MTK_IR_EN;
+	val |= MTK_OK_COUNT(ir->data->ok_count) |  MTK_PWM_EN | MTK_IR_EN;
 	mtk_w32(ir, val, MTK_CONFIG_HIGH_REG);
 
-	/* Setting sample period */
-	mtk_w32_mask(ir, MTK_CHK_PERIOD, MTK_CHK_PERIOD_MASK,
-		     MTK_CONFIG_LOW_REG);
-
 	mtk_irq_enable(ir, MTK_IRINT_EN);
 
-	dev_info(dev, "Initialized MT7623 IR driver, sample period = %luus\n",
+	dev_info(dev, "Initialized MT7623 IR driver, sample period = %dus\n",
 		 DIV_ROUND_CLOSEST(MTK_IR_SAMPLE, 1000));
 
 	return 0;
 
+exit_clkdisable_bus:
+	clk_disable_unprepare(ir->bus);
 exit_clkdisable_clk:
 	clk_disable_unprepare(ir->clk);
 
@@ -308,17 +422,12 @@ static int mtk_ir_remove(struct platform_device *pdev)
 	mtk_irq_disable(ir, MTK_IRINT_EN);
 	synchronize_irq(ir->irq);
 
+	clk_disable_unprepare(ir->bus);
 	clk_disable_unprepare(ir->clk);
 
 	return 0;
 }
 
-static const struct of_device_id mtk_ir_match[] = {
-	{ .compatible = "mediatek,mt7623-cir" },
-	{},
-};
-MODULE_DEVICE_TABLE(of, mtk_ir_match);
-
 static struct platform_driver mtk_ir_driver = {
 	.probe          = mtk_ir_probe,
 	.remove         = mtk_ir_remove,
-- 
2.7.4
