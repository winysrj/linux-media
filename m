Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:13677 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S934754AbdAJN76 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jan 2017 08:59:58 -0500
Message-ID: <1484056789.4057.17.camel@mtkswgap22>
Subject: Re: [PATCH v2 2/2] media: rc: add driver for IR remote receiver on
 MT7623 SoC
From: Sean Wang <sean.wang@mediatek.com>
To: Sean Young <sean@mess.org>
CC: <mchehab@osg.samsung.com>, <hdegoede@redhat.com>,
        <hkallweit1@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <matthias.bgg@gmail.com>,
        <andi.shyti@samsung.com>, <hverkuil@xs4all.nl>,
        <ivo.g.dimitrov.75@gmail.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <keyhaede@gmail.com>
Date: Tue, 10 Jan 2017 21:59:49 +0800
In-Reply-To: <20170110110943.GA24889@gofer.mess.org>
References: <1484039631-25120-1-git-send-email-sean.wang@mediatek.com>
         <1484039631-25120-3-git-send-email-sean.wang@mediatek.com>
         <20170110110943.GA24889@gofer.mess.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-01-10 at 11:09 +0000, Sean Young wrote:

> > +#include <linux/clk.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/module.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/reset.h>
> > +#include <media/rc-core.h>
> > +
> > +#define MTK_IR_DEV KBUILD_MODNAME
> 
> You could remove this #define and just use KBUILD_MODNAME

I preferred to use MTK_IR_DEV internally that helps
renaming in the future if necessary.
>  
> > +
> > +/* Register to enable PWM and IR */
> > +#define MTK_CONFIG_HIGH_REG       0x0c
> > +/* Enable IR pulse width detection */
> > +#define MTK_PWM_EN		  BIT(13)
> > +/* Enable IR hardware function */
> > +#define MTK_IR_EN		  BIT(0)
> > +
> > +/* Register to setting sample period */
> > +#define MTK_CONFIG_LOW_REG        0x10
> > +/* Field to set sample period */
> > +#define CHK_PERIOD		  DIV_ROUND_CLOSEST(MTK_IR_SAMPLE,  \
> > +						    MTK_IR_CLK_PERIOD)
> > +#define MTK_CHK_PERIOD            (((CHK_PERIOD) << 8) & (GENMASK(20, 8)))
> > +#define MTK_CHK_PERIOD_MASK	  (GENMASK(20, 8))
> > +
> > +/* Register to clear state of state machine */
> > +#define MTK_IRCLR_REG             0x20
> > +/* Bit to restart IR receiving */
> > +#define MTK_IRCLR		  BIT(0)
> > +
> > +/* Register containing pulse width data */
> > +#define MTK_CHKDATA_REG(i)        (0x88 + 4 * (i))
> > +#define MTK_WIDTH_MASK		  (GENMASK(7, 0))
> > +
> > +/* Register to enable IR interrupt */
> > +#define MTK_IRINT_EN_REG          0xcc
> > +/* Bit to enable interrupt */
> > +#define MTK_IRINT_EN		  BIT(0)
> > +
> > +/* Register to ack IR interrupt */
> > +#define MTK_IRINT_CLR_REG         0xd0
> > +/* Bit to clear interrupt status */
> > +#define MTK_IRINT_CLR		  BIT(0)
> > +
> > +/* Maximum count of samples */
> > +#define MTK_MAX_SAMPLES		  0xff
> > +/* Indicate the end of IR message */
> > +#define MTK_IR_END(v, p)	  ((v) == MTK_MAX_SAMPLES && (p) == 0)
> > +/* Number of registers to record the pulse width */
> > +#define MTK_CHKDATA_SZ		  17
> > +/* Source clock frequency */
> > +#define MTK_IR_BASE_CLK		  273000000
> > +/* Frequency after IR internal divider */
> > +#define MTK_IR_CLK_FREQ		  (MTK_IR_BASE_CLK / 4)

> > +static irqreturn_t mtk_ir_irq(int irqno, void *dev_id)
> > +{
> > +	struct mtk_ir *ir = dev_id;
> > +	u8  wid = 0;
> > +	u32 i, j, val;
> > +	DEFINE_IR_RAW_EVENT(rawir);
> > +
> > +	mtk_irq_disable(ir, MTK_IRINT_EN);
> 
> The kernel guarantees that calls to the interrupt handler are serialised,
> no need to disable the interrupt in the handler.

agreed. I will save the mtk irq disable/enable and retest again.


> > +
> > +	/* Reset decoder state machine */
> > +	ir_raw_event_reset(ir->rc);
> 
> Not needed.


two reasons I added the line here

1) 
I thought it is possible the decoder goes to the
middle state when getting the data not belonged
to the protocol. If so, that would cause the decoding
fails in the next time receiving the valid protocol data.

2) 
the mtk hardware register always contains the start of 
IR message. So force to sync the state between 
HW and ir-core.



> > +
> > +	/* First message must be pulse */
> > +	rawir.pulse = false;
> 
> pulse = true?

becasue of rawir.pulse = !rawir.pulse does as below
so the initial value is set as false.

> > +
> > +	/* Handle all pulse and space IR controller captures */
> > +	for (i = 0 ; i < MTK_CHKDATA_SZ ; i++) {
> > +		val = mtk_r32(ir, MTK_CHKDATA_REG(i));
> > +		dev_dbg(ir->dev, "@reg%d=0x%08x\n", i, val);
> > +
> > +		for (j = 0 ; j < 4 ; j++) {
> > +			wid = (val & (MTK_WIDTH_MASK << j * 8)) >> j * 8;
> > +			rawir.pulse = !rawir.pulse;
> > +			rawir.duration = wid * (MTK_IR_SAMPLE + 1);
> > +			ir_raw_event_store_with_filter(ir->rc, &rawir);
> > +		}
> 
> In v1 you would break out of the loop if the ir message was shorter, but
> now you are always passing on 68 pulses and spaces. Is that right?

as I asked in the previous mail list as below i copied from it, so i
made some changes ...

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> I had another question. I found multiple and same IR messages being
> received when using SONY remote controller. Should driver needs to
> report each message or only one of these to the upper layer ?

In general the driver shouldn't try to change any IR message, this
should be done in rc-core if necessary.

rc-core should handle this correctly. If the same key is received twice
within IR_KEYPRESS_TIMEOUT (250ms) then it not reported to the input
layer.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

for example:
the 68 pulse/spaces might contains 2.x IR messages when I
pressed one key on SONY remote control. 

the v1 proposed is passing only one IR message into ir-core ; 
the v2 done is passing all IR messages even including the last
incomplete message into ir-core. 

But I was still afraid the state machine can't  go back to initial state
after receiving these incomplete data. 

So the ir_raw_event_reset() call in the beginning of ISR seems becoming
more important.

> > +	}
> > +
> > +	/* The maximum number of edges the IR controller can
> > +	 * hold is MTK_CHKDATA_SZ * 4. So if received IR messages
> > +	 * is over the limit, the last incomplete IR message would
> > +	 * be appended trailing space and still would be sent into
> > +	 * ir-rc-raw to decode. That helps it is possible that it
> > +	 * has enough information to decode a scancode even if the
> > +	 * trailing end of the message is missing.
> > +	 */
> > +	if (!MTK_IR_END(wid, rawir.pulse)) {
> > +		rawir.pulse = false;
> > +		rawir.duration = MTK_MAX_SAMPLES * (MTK_IR_SAMPLE + 1);
> > +		ir_raw_event_store_with_filter(ir->rc, &rawir);
> > +	}
> > +
> > +	ir_raw_event_handle(ir->rc);
> > +
> > +	/* Restart controller for the next receive */
> > +	mtk_w32_mask(ir, 0x1, MTK_IRCLR, MTK_IRCLR_REG);
> > +
> > +	/* Clear interrupt status */
> > +	mtk_w32_mask(ir, 0x1, MTK_IRINT_CLR, MTK_IRINT_CLR_REG);
> > +
> > +	/* Enable interrupt */
> > +	mtk_irq_enable(ir, MTK_IRINT_EN);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static int mtk_ir_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct device_node *dn = dev->of_node;
> > +	struct resource *res;
> > +	struct mtk_ir *ir;
> > +	u32 val;
> > +	int ret = 0;
> > +	const char *map_name;
> > +
> > +	ir = devm_kzalloc(dev, sizeof(struct mtk_ir), GFP_KERNEL);
> > +	if (!ir)
> > +		return -ENOMEM;
> > +
> > +	ir->dev = dev;
> > +
> > +	if (!of_device_is_compatible(dn, "mediatek,mt7623-cir"))
> > +		return -ENODEV;
> > +
> > +	ir->clk = devm_clk_get(dev, "clk");
> > +	if (IS_ERR(ir->clk)) {
> > +		dev_err(dev, "failed to get a ir clock.\n");
> > +		return PTR_ERR(ir->clk);
> > +	}
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	ir->base = devm_ioremap_resource(dev, res);
> > +	if (IS_ERR(ir->base)) {
> > +		dev_err(dev, "failed to map registers\n");
> > +		return PTR_ERR(ir->base);
> > +	}
> > +
> > +	ir->rc = devm_rc_allocate_device(dev, RC_DRIVER_IR_RAW);
> > +	if (!ir->rc) {
> > +		dev_err(dev, "failed to allocate device\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	ir->rc->priv = ir;
> > +	ir->rc->input_name = MTK_IR_DEV;
> > +	ir->rc->input_phys = MTK_IR_DEV "/input0";
> > +	ir->rc->input_id.bustype = BUS_HOST;
> > +	ir->rc->input_id.vendor = 0x0001;
> > +	ir->rc->input_id.product = 0x0001;
> > +	ir->rc->input_id.version = 0x0001;
> > +	map_name = of_get_property(dn, "linux,rc-map-name", NULL);
> > +	ir->rc->map_name = map_name ?: RC_MAP_EMPTY;
> > +	ir->rc->dev.parent = dev;
> > +	ir->rc->driver_name = MTK_IR_DEV;
> > +	ir->rc->allowed_protocols = RC_BIT_ALL;
> > +	ir->rc->rx_resolution = MTK_IR_SAMPLE;
> > +	ir->rc->timeout = MTK_MAX_SAMPLES * (MTK_IR_SAMPLE + 1);
> > +
> > +	ret = devm_rc_register_device(dev, ir->rc);
> 
> Here you do devm_rc_register_device()

does it have problem ?


> > +	if (ret) {
> > +		dev_err(dev, "failed to register rc device\n");
> > +		return ret;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, ir);
> > +
> > +	ir->irq = platform_get_irq(pdev, 0);
> > +	if (ir->irq < 0) {
> > +		dev_err(dev, "no irq resource\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	/* Enable interrupt after proper hardware
> > +	 * setup and IRQ handler registration
> > +	 */
> > +	if (clk_prepare_enable(ir->clk)) {
> > +		dev_err(dev, "try to enable ir_clk failed\n");
> > +		ret = -EINVAL;
> > +		goto exit_clkdisable_clk;
> > +	}
> > +
> > +	mtk_irq_disable(ir, MTK_IRINT_EN);
> > +
> > +	ret = devm_request_irq(dev, ir->irq, mtk_ir_irq, 0, MTK_IR_DEV, ir);
> > +	if (ret) {
> > +		dev_err(dev, "failed request irq\n");
> > +		goto exit_clkdisable_clk;
> > +	}
> > +
> > +	/* Enable IR and PWM */
> > +	val = mtk_r32(ir, MTK_CONFIG_HIGH_REG);
> > +	val |= MTK_PWM_EN | MTK_IR_EN;
> > +	mtk_w32(ir, val, MTK_CONFIG_HIGH_REG);
> > +
> > +	/* Setting sample period */
> > +	mtk_w32_mask(ir, MTK_CHK_PERIOD, MTK_CHK_PERIOD_MASK,
> > +		     MTK_CONFIG_LOW_REG);
> > +
> > +	mtk_irq_enable(ir, MTK_IRINT_EN);
> > +
> > +	dev_info(dev, "Initialized MT7623 IR driver, sample period = %luus\n",
> > +		 DIV_ROUND_CLOSEST(MTK_IR_SAMPLE, 1000));
> > +
> > +	return 0;
> > +
> > +exit_clkdisable_clk:
> > +	clk_disable_unprepare(ir->clk);
> > +
> > +	return ret;
> > +}
> > +
> > +static int mtk_ir_remove(struct platform_device *pdev)
> > +{
> > +	struct mtk_ir *ir = platform_get_drvdata(pdev);
> > +
> > +	/* Avoid contention between remove handler and
> > +	 * IRQ handler so that disabling IR interrupt and
> > +	 * waiting for pending IRQ handler to complete
> > +	 */
> > +	mtk_irq_disable(ir, MTK_IRINT_EN);
> > +	synchronize_irq(ir->irq);
> > +
> > +	clk_disable_unprepare(ir->clk);
> > +
> > +	rc_unregister_device(ir->rc);
> 
> Yet here you explicitly call rc_unregister_device(). Since it was registered
> with the devm call, this call is not needed and will lead to double frees etc

bug :( .  I will fix it ..

> > +
> > +	return 0;
> > +}
> > +
> > +static const struct of_device_id mtk_ir_match[] = {
> > +	{ .compatible = "mediatek,mt7623-cir" },
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, mtk_ir_match);
> > +
> > +static struct platform_driver mtk_ir_driver = {
> > +	.probe          = mtk_ir_probe,
> > +	.remove         = mtk_ir_remove,
> > +	.driver = {
> > +		.name = MTK_IR_DEV,
> > +		.of_match_table = mtk_ir_match,
> > +	},
> > +};
> > +
> > +module_platform_driver(mtk_ir_driver);
> > +
> > +MODULE_DESCRIPTION("Mediatek IR Receiver Controller Driver");
> > +MODULE_AUTHOR("Sean Wang <sean.wang@mediatek.com>");
> > +MODULE_LICENSE("GPL");
> > -- 
> > 2.7.4
> > 


