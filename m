Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:47104 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753491AbdFSJhY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 05:37:24 -0400
Subject: Re: [PATCH v3 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Sylwester Nawrocki <snawrocki@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
References: <cover.1497630695.git.joabreu@synopsys.com>
 <d7f507ccec6f25f9be457c1c3f2f802b55377a1f.1497630695.git.joabreu@synopsys.com>
 <fd65183f-b577-9ac6-a56e-689121e82e73@kernel.org>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <b4b49f3c-3b07-5638-62b9-26a1fe68af98@synopsys.com>
Date: Mon, 19 Jun 2017 10:33:53 +0100
MIME-Version: 1.0
In-Reply-To: <fd65183f-b577-9ac6-a56e-689121e82e73@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,


Thanks again for the feedback!


On 18-06-2017 19:04, Sylwester Nawrocki wrote:
> On 06/16/2017 06:38 PM, Jose Abreu wrote:
>> This is an initial submission for the Synopsys Designware HDMI RX
>> Controller Driver. This driver interacts with a phy driver so that
>> a communication between them is created and a video pipeline is
>> configured.
>>
>> The controller + phy pipeline can then be integrated into a fully
>> featured system that can be able to receive video up to 4k@60Hz
>> with deep color 48bit RGB, depending on the platform. Although,
>> this initial version does not yet handle deep color modes.
>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>> +static int dw_hdmi_phy_init(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	struct dw_phy_pdata *phy = &dw_dev->phy_config;
>> +	struct platform_device_info pdevinfo;
>> +
>> +	memset(&pdevinfo, 0, sizeof(pdevinfo));
>> +
>> +	phy->funcs = &dw_hdmi_phy_funcs;
>> +	phy->funcs_arg = dw_dev;
>> +
>> +	pdevinfo.parent = dw_dev->dev;
>> +	pdevinfo.id = PLATFORM_DEVID_NONE;
>> +	pdevinfo.name = dw_dev->phy_drv;
>> +	pdevinfo.data = phy;
>> +	pdevinfo.size_data = sizeof(*phy);
>> +	pdevinfo.dma_mask = DMA_BIT_MASK(32);
>> +
>> +	request_module(pdevinfo.name);
>> +
>> +	dw_dev->phy_pdev = platform_device_register_full(&pdevinfo);
>> +	if (IS_ERR(dw_dev->phy_pdev)) {
>> +		dev_err(dw_dev->dev, "failed to register phy device\n");
>> +		return PTR_ERR(dw_dev->phy_pdev);
>> +	}
>> +
>> +	if (!dw_dev->phy_pdev->dev.driver) {
>> +		dev_err(dw_dev->dev, "failed to initialize phy driver\n");
>> +		goto err;
>> +	}
> I think this is not safe because there is nothing preventing unbinding 
> or unloading the driver at this point.
>
>> +	if (!try_module_get(dw_dev->phy_pdev->dev.driver->owner)) {
> So dw_dev->phy_pdev->dev.driver may be already NULL here.

How can I make sure it wont be NULL? Because I've seen other
media drivers do this and I don't think they do any kind of
locking, but they do this mainly for I2C subdevs.

>
>> +		dev_err(dw_dev->dev, "failed to get phy module\n");
>> +		goto err;
>> +	}
>> +
>> +	dw_dev->phy_sd = dev_get_drvdata(&dw_dev->phy_pdev->dev);
>> +	if (!dw_dev->phy_sd) {
>> +		dev_err(dw_dev->dev, "failed to get phy subdev\n");
>> +		goto err_put;
>> +	}
>> +
>> +	if (v4l2_device_register_subdev(&dw_dev->v4l2_dev, dw_dev->phy_sd)) {
>> +		dev_err(dw_dev->dev, "failed to register phy subdev\n");
>> +		goto err_put;
>> +	}
> I'd suggest usign v4l2-async API, so we use a common pattern for sub-device
> registration.  And with recent change [1] you could handle this PHY subdev
> in a standard way.  That might be more complicated than it is now but should 
> make any future platform integration easier.
>
> [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__patchwork.linuxtv.org_patch_41834&d=DwICaQ&c=DPL6_X_6JkXFx7AXWqB0tg&r=WHDsc6kcWAl4i96Vm5hJ_19IJiuxx_p_Rzo2g-uHDKw&m=uHTyp6WsEj6vN19Zc09HqSNUhCx62OI8u-tAgi-EVts&s=WjyPjIwN1uGvPoV7ZlcmzOgdptakzluHywuKRA8ZG8M&e= 

So I will instantiate phy driver and then wait for phy driver to
register into v4l2 core?

>
>> +	module_put(dw_dev->phy_pdev->dev.driver->owner);
>> +	return 0;
>> +
>> +err_put:
>> +	module_put(dw_dev->phy_pdev->dev.driver->owner);
>> +err:
>> +	platform_device_unregister(dw_dev->phy_pdev);
>> +	return -EINVAL;
>> +}
>> +
>> +static void dw_hdmi_phy_exit(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	if (!IS_ERR(dw_dev->phy_pdev))
>> +		platform_device_unregister(dw_dev->phy_pdev);
>> +}
>> +static int dw_hdmi_config_hdcp(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	for (i = 0; i < DW_HDMI_HDCP14_KEYS_SIZE; i += 2) {
>> +		for (j = 0; j < key_write_tries; j++) {
>> +			if (is_hdcp14_key_write_allowed(dw_dev))
>> +				break;
>> +			mdelay(10);
> usleep_range()? I've seen more (busy waiting) mdelay() calls in this
> patch series.

I will change.

>
>
>> +static int __dw_hdmi_power_on(struct dw_hdmi_dev *dw_dev, u32 input)
>> +{
>> +	unsigned long flags;
>> +	int ret;
>> +
>> +	ret = dw_hdmi_config(dw_dev, input);
>> +
>> +	spin_lock_irqsave(&dw_dev->lock, flags);
>> +	dw_dev->pending_config = false;
>> +	spin_unlock_irqrestore(&dw_dev->lock, flags);
>> +
>> +	return ret;
>> +}
>> +
>> +struct dw_hdmi_work_data {
>> +	struct dw_hdmi_dev *dw_dev;
>> +	struct work_struct work;
>> +	u32 input;
>> +};
>> +
>> +static void dw_hdmi_work_handler(struct work_struct *work)
>> +{
>> +	struct dw_hdmi_work_data *data = container_of(work,
>> +			struct dw_hdmi_work_data, work);
>> +
>> +	__dw_hdmi_power_on(data->dw_dev, data->input);
>> +	devm_kfree(data->dw_dev->dev, data);
>> +}
>> +
>> +static int dw_hdmi_power_on(struct dw_hdmi_dev *dw_dev, u32 input)
>> +{
>> +	struct dw_hdmi_work_data *data;
>> +	unsigned long flags;
>> +
>> +	data = devm_kzalloc(dw_dev->dev, sizeof(*data), GFP_KERNEL);
> Why use devm_{kzalloc, kfree} when dw_hdmi_power_on() is not only called
> in the device's probe() callback, but in other places, including interrupt 
> handler?  devm_* API is normally used when life time of a resource is more 
> or less equal to life time of struct device or its matched driver.  Were 
> there any specific reasons to not just use kzalloc()/kfree() ?

No specific reason, I just thought it would be safer because if I
cancel a work before it started then memory will remain
allocated. But I will change to kzalloc().

>
>> +	if (!data)
>> +		return -ENOMEM;
>> +
>> +	INIT_WORK(&data->work, dw_hdmi_work_handler);
>> +	data->dw_dev = dw_dev;
>> +	data->input = input;
>> +
>> +	spin_lock_irqsave(&dw_dev->lock, flags);
>> +	if (dw_dev->pending_config) {
>> +		devm_kfree(dw_dev->dev, data);
>> +		spin_unlock_irqrestore(&dw_dev->lock, flags);
>> +		return 0;
>> +	}
>> +
>> +	queue_work(dw_dev->wq, &data->work);
>> +	dw_dev->pending_config = true;
>> +	spin_unlock_irqrestore(&dw_dev->lock, flags);
>> +	return 0;
>> +}
>> +static irqreturn_t dw_hdmi_irq_handler(int irq, void *dev_data)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = dev_data;
>> +	u32 hdmi_ists = dw_hdmi_get_int_val(dw_dev, HDMI_ISTS, HDMI_IEN);
>> +	u32 md_ists = dw_hdmi_get_int_val(dw_dev, HDMI_MD_ISTS, HDMI_MD_IEN);
>> +
>> +	dw_hdmi_clear_ints(dw_dev);
>> +
>> +	if ((hdmi_ists & HDMI_ISTS_CLK_CHANGE) ||
>> +	    (hdmi_ists & HDMI_ISTS_PLL_LCK_CHG) || md_ists) {
>> +		dw_hdmi_power_off(dw_dev);
>> +		if (has_signal(dw_dev, dw_dev->configured_input))
>> +			dw_hdmi_power_on(dw_dev, dw_dev->configured_input);
>> +	}
>> +	return IRQ_HANDLED;
>> +}
>> +static int dw_hdmi_registered(struct v4l2_subdev *sd)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +	int ret;
>> +
>> +	ret = cec_register_adapter(dw_dev->cec_adap, dw_dev->dev);
>> +	if (ret) {
>> +		dev_err(dw_dev->dev, "failed to register CEC adapter\n");
>> +		cec_delete_adapter(dw_dev->cec_adap);
>> +		return ret;
>> +	}
>> +
>> +	cec_register_cec_notifier(dw_dev->cec_adap, dw_dev->cec_notifier);
>> +	dw_dev->registered = true;
>> +	return ret;
>> +}
>> +
>> +static void dw_hdmi_unregistered(struct v4l2_subdev *sd)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +	cec_unregister_adapter(dw_dev->cec_adap);
>> +	cec_notifier_put(dw_dev->cec_notifier);
>> +}
>> +
>> +static const struct v4l2_subdev_core_ops dw_hdmi_sd_core_ops = {
>> +	.log_status = dw_hdmi_log_status,
>> +	.subscribe_event = dw_hdmi_subscribe_event,
>> +};
>> +
>> +static const struct v4l2_subdev_video_ops dw_hdmi_sd_video_ops = {
>> +	.s_routing = dw_hdmi_s_routing,
>> +	.g_input_status = dw_hdmi_g_input_status,
>> +	.g_parm = dw_hdmi_g_parm,
>> +	.g_dv_timings = dw_hdmi_g_dv_timings,
>> +	.query_dv_timings = dw_hdmi_query_dv_timings,
>> +};
>> +
>> +static const struct v4l2_subdev_pad_ops dw_hdmi_sd_pad_ops = {
>> +	.enum_mbus_code = dw_hdmi_enum_mbus_code,
>> +	.get_fmt = dw_hdmi_get_fmt,
>> +	.set_fmt = dw_hdmi_set_fmt,
>> +	.dv_timings_cap = dw_hdmi_dv_timings_cap,
>> +	.enum_dv_timings = dw_hdmi_enum_dv_timings,
>> +};
>> +
>> +static const struct v4l2_subdev_ops dw_hdmi_sd_ops = {
>> +	.core = &dw_hdmi_sd_core_ops,
>> +	.video = &dw_hdmi_sd_video_ops,
>> +	.pad = &dw_hdmi_sd_pad_ops,
>> +};
>> +
>> +static const struct v4l2_subdev_internal_ops dw_hdmi_internal_ops = {
>> +	.registered = dw_hdmi_registered,
>> +	.unregistered = dw_hdmi_unregistered,
>> +};
>> +
>> +static int dw_hdmi_parse_dt(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	struct device_node *notifier, *np = dw_dev->of_node;
>> +	struct dw_phy_pdata *phy = &dw_dev->phy_config;
>> +
>> +	if (!np) {
>> +		dev_err(dw_dev->dev, "missing DT node\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* PHY properties parsing */
>> +	of_property_read_u8(np, "snps,hdmi-phy-jtag-addr",
>> +			&dw_dev->phy_jtag_addr);
>> +	if (!dw_dev->phy_jtag_addr) {
>> +		dev_err(dw_dev->dev, "missing hdmi-phy-jtag-addr in DT\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	of_property_read_u32(np, "snps,hdmi-phy-version", &phy->version);
>> +	if (!phy->version) {
>> +		dev_err(dw_dev->dev, "missing hdmi-phy-version in DT\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	of_property_read_u32(np, "snps,hdmi-phy-cfg-clk", &phy->cfg_clk);
>> +	if (!phy->cfg_clk) {
>> +		dev_err(dw_dev->dev, "missing hdmi-phy-cfg-clk in DT\n");
>> +		return -EINVAL;
>> +	}
> With changes as proposed in comments to patch "4/4 dt-bindings: ..." 
> you could use the common clk API for retrieving the clock rate, e.g. 
> devm_clk_get(), clk_get_rate().
>
> When the HDMI RX IP block gets integrated within some SoC I'd expect 
> the system clock controller to be already using the common clk DT 
> bindings. Unless for some reason the platform doesn't support CCF.

Yes, I will change.

>
>
>> +	if (of_property_read_string_index(np, "snps,hdmi-phy-driver", 0,
>> +				&dw_dev->phy_drv) < 0) {
>> +		dev_err(dw_dev->dev, "missing hdmi-phy-driver in DT\n");
> I don't think we can put Linux driver names in DT like this, it seems rather 
> a serious abuse.  With proposed changes to the DT binding you could reference 
> the PHY device by DT phandle or child node.
>
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* Controller properties parsing */
>> +	of_property_read_u32(np, "snps,hdmi-ctl-cfg-clk", &dw_dev->cfg_clk);
>> +	if (!dw_dev->cfg_clk) {
>> +		dev_err(dw_dev->dev, "missing hdmi-ctl-cfg-clk in DT\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +#if IS_ENABLED(CONFIG_VIDEO_DWC_HDMI_RX_CEC)
>> +	/* Notifier device parsing */
>> +	notifier = of_parse_phandle(np, "edid-phandle", 0);
>> +	if (!notifier) {
>> +		dev_err(dw_dev->dev, "missing edid-phandle in DT\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	dw_dev->notifier_pdev = of_find_device_by_node(np);
> Shouldn't this be:
> 	dw_dev->notifier_pdev = of_find_device_by_node(notifier);
> ?
>
> The caller of dw_hdmi_parse_dt() already knows about the device 
> associated with np.

Yeah, its a typo, it works by luck because in my setup np ==
notifier.

>
>> +	if (!dw_dev->notifier_pdev)
>> +		return -EPROBE_DEFER;
>> +#endif
>> +
>> +	return 0;
>> +}
>> +
>> +static int dw_hdmi_rx_probe(struct platform_device *pdev)
>> +{
>> +	/* Deferred work */
>> +	dw_dev->wq = create_workqueue(DW_HDMI_RX_DRVNAME);
> Have you considered using create_singlethread_workqueue() ? create_workqueue() 
> will spawn one thread per CPU.

Ok, will change.

>
>> +	if (!dw_dev->wq)
>> +		return -ENOMEM;
>> +
>> +	/* Registers mapping */
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res) {
>> +		ret = -ENXIO;
>> +		goto err_wq;
>> +	}
> You can drop res testing here, devm_ioremap_resource() verifies internally 
> if res is valid and returns proper error code.

Ok.

>
>> +	dw_dev->regs = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(dw_dev->regs)) {
>> +		ret = PTR_ERR(dw_dev->regs);
>> +		goto err_wq;
>> +	}
>
>> +	/* V4L2 initialization */
>> +	sd = &dw_dev->sd;
>> +	v4l2_subdev_init(sd, &dw_hdmi_sd_ops);
>> +	strlcpy(sd->name, DW_HDMI_RX_DRVNAME, sizeof(sd->name));
> sd->name should be unique, you could, for instance, do something like
>
> 	strlcpy(sd->name, dev_name(&pdev->dev), sizeof(sd->name));

Ok.

>
>> +	sd->internal_ops = &dw_hdmi_internal_ops;
>> +	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS;
>> +}
>> +
>> +static int dw_hdmi_rx_remove(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct v4l2_subdev *sd = dev_get_drvdata(dev);
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +	dev_dbg(dev, "%s\n", __func__);
>> +
>> +	dw_hdmi_disable_ints(dw_dev);
>> +	dw_hdmi_disable_hpd(dw_dev);
>> +	dw_hdmi_disable_scdc(dw_dev);
>> +	dw_hdmi_power_off(dw_dev);
>> +	dw_hdmi_phy_s_power(dw_dev, false);
>> +	flush_workqueue(dw_dev->wq);
>> +	destroy_workqueue(dw_dev->wq);
>> +	v4l2_device_unregister(&dw_dev->v4l2_dev);
>> +	dw_hdmi_phy_exit(dw_dev);> +	dev_info(dev, "driver removed\n");
>> +	return 0;
>> +}
>> +
>> +static struct platform_driver dw_hdmi_rx_driver = {
>> +	.probe = dw_hdmi_rx_probe,
>> +	.remove = dw_hdmi_rx_remove,
> I think we need also .of_match_table here.
>
>> +	.driver = {
>> +		.name = DW_HDMI_RX_DRVNAME,
>> +	}
>> +};
>> +module_platform_driver(dw_hdmi_rx_driver);
>> +#endif /* __DW_HDMI_RX_H__ */
>> diff --git a/include/media/dwc/dw-hdmi-rx-pdata.h b/include/media/dwc/dw-hdmi-rx-pdata.h
>> new file mode 100644
>> index 0000000..ff8554d
>> --- /dev/null
>> +++ b/include/media/dwc/dw-hdmi-rx-pdata.h
>> @@ -0,0 +1,63 @@
>> +#ifndef __DW_HDMI_RX_PDATA_H__
>> +#define __DW_HDMI_RX_PDATA_H__
>> +
>> +#define DW_HDMI_RX_DRVNAME			"dw-hdmi-rx"
>> +
>> +/* Notify events */
>> +#define DW_HDMI_NOTIFY_IS_OFF		1
>> +#define DW_HDMI_NOTIFY_INPUT_CHANGED	2
>> +#define DW_HDMI_NOTIFY_AUDIO_CHANGED	3
>> +#define DW_HDMI_NOTIFY_IS_STABLE	4
>> +
>> +/* HDCP 1.4 */
>> +#define DW_HDMI_HDCP14_BKSV_SIZE	2
>> +#define DW_HDMI_HDCP14_KEYS_SIZE	(2 * 40)
>> +
>> +struct dw_hdmi_hdcp14_key {
>> +	u32 seed;
>> +	u32 bksv[DW_HDMI_HDCP14_BKSV_SIZE];
>> +	u32 keys[DW_HDMI_HDCP14_KEYS_SIZE];
>> +	bool keys_valid;
>> +};
>> +
>> +struct dw_hdmi_rx_pdata {
>> +	/* Controller configuration */
>> +	unsigned int iref_clk; /* MHz */
> Is this field unused?

Yes, left overs from previous versions.

>
>> +	struct dw_hdmi_hdcp14_key hdcp14_keys;
>> +	/* 5V sense interface */
>> +	bool (*dw_5v_status)(void __iomem *regs, int input);
>> +	void (*dw_5v_clear)(void __iomem *regs);
>> +	void __iomem *dw_5v_arg;> +	/* Zcal interface */
>> +	void (*dw_zcal_reset)(void __iomem *regs);
>> +	bool (*dw_zcal_done)(void __iomem *regs);
>> +	void __iomem *dw_zcal_arg;
> I'm just wondering if these operations could be modeled with the regmap,
> so we could avoid callbacks in the platform data structure.

Hmm, I don't think that is safe because registers may not be
adjacent to each other. And maybe I was a little generous in
passing a __iomem argument, maybe it should be just void instead
because this can be not a regmap at all.

Best regards,
Jose Miguel Abreu

>  
>> +};
>> +#endif /* __DW_HDMI_RX_PDATA_H__ */
> --
> Regards,
> Sylwester
