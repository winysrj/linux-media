Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:44326 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1762900AbdAKJTS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 04:19:18 -0500
Message-ID: <1484126353.4057.30.camel@mtkswgap22>
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
Date: Wed, 11 Jan 2017 17:19:13 +0800
In-Reply-To: <20170110172355.GA27008@gofer.mess.org>
References: <1484039631-25120-1-git-send-email-sean.wang@mediatek.com>
         <1484039631-25120-3-git-send-email-sean.wang@mediatek.com>
         <20170110110943.GA24889@gofer.mess.org>
         <1484056789.4057.17.camel@mtkswgap22>
         <20170110172355.GA27008@gofer.mess.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-01-10 at 17:23 +0000, Sean Young wrote:
> Hi Sean,
> 

> > > 
> > > The kernel guarantees that calls to the interrupt handler are serialised,
> > > no need to disable the interrupt in the handler.
> > 
> > agreed. I will save the mtk irq disable/enable and retest again.
> > 
> > 
> > > > +
> > > > +	/* Reset decoder state machine */
> > > > +	ir_raw_event_reset(ir->rc);
> > > 
> > > Not needed.
> > 
> > 
> > two reasons I added the line here
> > 
> > 1) 
> > I thought it is possible the decoder goes to the
> > middle state when getting the data not belonged
> > to the protocol. If so, that would cause the decoding
> > fails in the next time receiving the valid protocol data.
> 
> The last IR event submitted will always be a long space, that's enough
> to reset the decoders. Adding a ir_raw_event_reset() will do this
> more explicitly, rather than their state machines resetting themselves
> through the trailing space.

thanks for the detailed explanation :) i got it

but some hardware limitation let me can't do it in implicit way :(

reset decoder state machine explicitly is needed because 
1) the longest duration for space MTK IR hardware can record is not
safely long. e.g  12ms if rx resolution is 46us by default. There is
still the risk to satisfying every decoder to reset themselves through
long enough trailing spaces
 
2) the IRQ handler called guarantees that start of IR message is always
contained in and starting from register MTK_CHKDATA_REG(0). 

I will add these words for hardware limitation into comments in the
driver

> > 2) 
> > the mtk hardware register always contains the start of 
> > IR message. So force to sync the state between 
> > HW and ir-core.
> > 
> > 
> > 
> > > > +
> > > > +	/* First message must be pulse */
> > > > +	rawir.pulse = false;
> > > 
> > > pulse = true?
> > 
> > becasue of rawir.pulse = !rawir.pulse does as below
> > so the initial value is set as false.
> 
> Ah, sorry, of course. :)
> 
> > > > +
> > > > +	/* Handle all pulse and space IR controller captures */
> > > > +	for (i = 0 ; i < MTK_CHKDATA_SZ ; i++) {
> > > > +		val = mtk_r32(ir, MTK_CHKDATA_REG(i));
> > > > +		dev_dbg(ir->dev, "@reg%d=0x%08x\n", i, val);
> > > > +
> > > > +		for (j = 0 ; j < 4 ; j++) {
> > > > +			wid = (val & (MTK_WIDTH_MASK << j * 8)) >> j * 8;
> > > > +			rawir.pulse = !rawir.pulse;
> > > > +			rawir.duration = wid * (MTK_IR_SAMPLE + 1);
> > > > +			ir_raw_event_store_with_filter(ir->rc, &rawir);
> > > > +		}
> > > 
> > > In v1 you would break out of the loop if the ir message was shorter, but
> > > now you are always passing on 68 pulses and spaces. Is that right?
> > 
> > as I asked in the previous mail list as below i copied from it, so i
> > made some changes ...
> > 
> > """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> > > I had another question. I found multiple and same IR messages being
> > > received when using SONY remote controller. Should driver needs to
> > > report each message or only one of these to the upper layer ?
> > 
> > In general the driver shouldn't try to change any IR message, this
> > should be done in rc-core if necessary.
> > 
> > rc-core should handle this correctly. If the same key is received twice
> > within IR_KEYPRESS_TIMEOUT (250ms) then it not reported to the input
> > layer.
> > """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> > 
> > for example:
> > the 68 pulse/spaces might contains 2.x IR messages when I
> > pressed one key on SONY remote control. 
> > 
> > the v1 proposed is passing only one IR message into ir-core ; 
> > the v2 done is passing all IR messages even including the last
> > incomplete message into ir-core. 
> 
> Yes, agreed. Sorry if I wasn't clear. I just wanted to make sure you've
> thought about what happens when the IR message is short (e.g. rc-5 with
> 23 pulse-spaces). Are the remaining registers 0 or do we get stale data
> from a previous transmit?

Before exit from this IRQ handler , mtk_w32_mask(ir, 0x1, MTK_IRCLR,
MTK_IRCLR_REG) would be done that causes all registers used to store 
pulses and spaces to be cleared, so no stale data appears in the next 
transmit.


> > But I was still afraid the state machine can't  go back to initial state
> > after receiving these incomplete data. 
> > 
> > So the ir_raw_event_reset() call in the beginning of ISR seems becoming
> > more important.
> > 
> > > > +	}
> > > > +
> > > > +	/* The maximum number of edges the IR controller can
> > > > +	 * hold is MTK_CHKDATA_SZ * 4. So if received IR messages
> > > > +	 * is over the limit, the last incomplete IR message would
> > > > +	 * be appended trailing space and still would be sent into
> > > > +	 * ir-rc-raw to decode. That helps it is possible that it
> > > > +	 * has enough information to decode a scancode even if the
> > > > +	 * trailing end of the message is missing.
> > > > +	 */
> > > > +	if (!MTK_IR_END(wid, rawir.pulse)) {
> > > > +		rawir.pulse = false;
> > > > +		rawir.duration = MTK_MAX_SAMPLES * (MTK_IR_SAMPLE + 1);
> > > > +		ir_raw_event_store_with_filter(ir->rc, &rawir);
> > > > +	}
> 
> See here you add a long space if one was not added already.
> 
> > > > +
> > > > +	ir_raw_event_handle(ir->rc);
> > > > +
> > > > +	/* Restart controller for the next receive */
> > > > +	mtk_w32_mask(ir, 0x1, MTK_IRCLR, MTK_IRCLR_REG);
> > > > +
> > > > +	/* Clear interrupt status */
> > > > +	mtk_w32_mask(ir, 0x1, MTK_IRINT_CLR, MTK_IRINT_CLR_REG);
> > > > +
> > > > +	/* Enable interrupt */
> > > > +	mtk_irq_enable(ir, MTK_IRINT_EN);
> > > > +
> > > > +	return IRQ_HANDLED;
> > > > +}
> > > > +
> > > > +static int mtk_ir_probe(struct platform_device *pdev)
> > > > +{
> > > > +	struct device *dev = &pdev->dev;
> > > > +	struct device_node *dn = dev->of_node;
> > > > +	struct resource *res;
> > > > +	struct mtk_ir *ir;
> > > > +	u32 val;
> > > > +	int ret = 0;
> > > > +	const char *map_name;
> > > > +
> > > > +	ir = devm_kzalloc(dev, sizeof(struct mtk_ir), GFP_KERNEL);
> > > > +	if (!ir)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	ir->dev = dev;
> > > > +
> > > > +	if (!of_device_is_compatible(dn, "mediatek,mt7623-cir"))
> > > > +		return -ENODEV;
> > > > +
> > > > +	ir->clk = devm_clk_get(dev, "clk");
> > > > +	if (IS_ERR(ir->clk)) {
> > > > +		dev_err(dev, "failed to get a ir clock.\n");
> > > > +		return PTR_ERR(ir->clk);
> > > > +	}
> > > > +
> > > > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > > +	ir->base = devm_ioremap_resource(dev, res);
> > > > +	if (IS_ERR(ir->base)) {
> > > > +		dev_err(dev, "failed to map registers\n");
> > > > +		return PTR_ERR(ir->base);
> > > > +	}
> > > > +
> > > > +	ir->rc = devm_rc_allocate_device(dev, RC_DRIVER_IR_RAW);
> > > > +	if (!ir->rc) {
> > > > +		dev_err(dev, "failed to allocate device\n");
> > > > +		return -ENOMEM;
> > > > +	}
> > > > +
> > > > +	ir->rc->priv = ir;
> > > > +	ir->rc->input_name = MTK_IR_DEV;
> > > > +	ir->rc->input_phys = MTK_IR_DEV "/input0";
> > > > +	ir->rc->input_id.bustype = BUS_HOST;
> > > > +	ir->rc->input_id.vendor = 0x0001;
> > > > +	ir->rc->input_id.product = 0x0001;
> > > > +	ir->rc->input_id.version = 0x0001;
> > > > +	map_name = of_get_property(dn, "linux,rc-map-name", NULL);
> > > > +	ir->rc->map_name = map_name ?: RC_MAP_EMPTY;
> > > > +	ir->rc->dev.parent = dev;
> > > > +	ir->rc->driver_name = MTK_IR_DEV;
> > > > +	ir->rc->allowed_protocols = RC_BIT_ALL;
> > > > +	ir->rc->rx_resolution = MTK_IR_SAMPLE;
> > > > +	ir->rc->timeout = MTK_MAX_SAMPLES * (MTK_IR_SAMPLE + 1);
> > > > +
> > > > +	ret = devm_rc_register_device(dev, ir->rc);
> > > 
> > > Here you do devm_rc_register_device()
> > 
> > does it have problem ?
> 
> Sorry, no. I just wanted to highlight wrt a comment below.
> > 
> > 
> > > > +	if (ret) {
> > > > +		dev_err(dev, "failed to register rc device\n");
> > > > +		return ret;
> > > > +	}
> > > > +
> > > > +	platform_set_drvdata(pdev, ir);
> > > > +
> > > > +	ir->irq = platform_get_irq(pdev, 0);
> > > > +	if (ir->irq < 0) {
> > > > +		dev_err(dev, "no irq resource\n");
> > > > +		return -ENODEV;
> > > > +	}
> > > > +
> > > > +	/* Enable interrupt after proper hardware
> > > > +	 * setup and IRQ handler registration
> > > > +	 */
> > > > +	if (clk_prepare_enable(ir->clk)) {
> > > > +		dev_err(dev, "try to enable ir_clk failed\n");
> > > > +		ret = -EINVAL;
> > > > +		goto exit_clkdisable_clk;
> > > > +	}
> > > > +
> > > > +	mtk_irq_disable(ir, MTK_IRINT_EN);
> > > > +
> > > > +	ret = devm_request_irq(dev, ir->irq, mtk_ir_irq, 0, MTK_IR_DEV, ir);
> > > > +	if (ret) {
> > > > +		dev_err(dev, "failed request irq\n");
> > > > +		goto exit_clkdisable_clk;
> > > > +	}
> > > > +
> > > > +	/* Enable IR and PWM */
> > > > +	val = mtk_r32(ir, MTK_CONFIG_HIGH_REG);
> > > > +	val |= MTK_PWM_EN | MTK_IR_EN;
> > > > +	mtk_w32(ir, val, MTK_CONFIG_HIGH_REG);
> > > > +
> > > > +	/* Setting sample period */
> > > > +	mtk_w32_mask(ir, MTK_CHK_PERIOD, MTK_CHK_PERIOD_MASK,
> > > > +		     MTK_CONFIG_LOW_REG);
> > > > +
> > > > +	mtk_irq_enable(ir, MTK_IRINT_EN);
> > > > +
> > > > +	dev_info(dev, "Initialized MT7623 IR driver, sample period = %luus\n",
> > > > +		 DIV_ROUND_CLOSEST(MTK_IR_SAMPLE, 1000));
> > > > +
> > > > +	return 0;
> > > > +
> > > > +exit_clkdisable_clk:
> > > > +	clk_disable_unprepare(ir->clk);
> > > > +
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static int mtk_ir_remove(struct platform_device *pdev)
> > > > +{
> > > > +	struct mtk_ir *ir = platform_get_drvdata(pdev);
> > > > +
> > > > +	/* Avoid contention between remove handler and
> > > > +	 * IRQ handler so that disabling IR interrupt and
> > > > +	 * waiting for pending IRQ handler to complete
> > > > +	 */
> > > > +	mtk_irq_disable(ir, MTK_IRINT_EN);
> > > > +	synchronize_irq(ir->irq);
> > > > +
> > > > +	clk_disable_unprepare(ir->clk);
> > > > +
> > > > +	rc_unregister_device(ir->rc);
> > > 
> > > Yet here you explicitly call rc_unregister_device(). Since it was registered
> > > with the devm call, this call is not needed and will lead to double frees etc
> > 
> > bug :( .  I will fix it ..
> > 
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static const struct of_device_id mtk_ir_match[] = {
> > > > +	{ .compatible = "mediatek,mt7623-cir" },
> > > > +	{},
> > > > +};
> > > > +MODULE_DEVICE_TABLE(of, mtk_ir_match);
> > > > +
> > > > +static struct platform_driver mtk_ir_driver = {
> > > > +	.probe          = mtk_ir_probe,
> > > > +	.remove         = mtk_ir_remove,
> > > > +	.driver = {
> > > > +		.name = MTK_IR_DEV,
> > > > +		.of_match_table = mtk_ir_match,
> > > > +	},
> > > > +};
> > > > +
> > > > +module_platform_driver(mtk_ir_driver);
> > > > +
> > > > +MODULE_DESCRIPTION("Mediatek IR Receiver Controller Driver");
> > > > +MODULE_AUTHOR("Sean Wang <sean.wang@mediatek.com>");
> > > > +MODULE_LICENSE("GPL");
> > > > -- 
> > > > 2.7.4
> > > > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


