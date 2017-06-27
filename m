Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:57212 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751473AbdF0Inu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 04:43:50 -0400
Subject: Re: [PATCH v4 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Sylwester Nawrocki <snawrocki@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
References: <cover.1497978962.git.joabreu@synopsys.com>
 <314b7ae92c9924d0991e14ccad80ca937a2d7b07.1497978962.git.joabreu@synopsys.com>
 <e6f63454-2e87-6e93-50c3-2802e9357c2a@kernel.org>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <2868c525-3edd-0fe1-cc6f-49a758f8c434@synopsys.com>
Date: Tue, 27 Jun 2017 09:43:43 +0100
MIME-Version: 1.0
In-Reply-To: <e6f63454-2e87-6e93-50c3-2802e9357c2a@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,


On 25-06-2017 22:13, Sylwester Nawrocki wrote:
> On 06/20/2017 07:26 PM, Jose Abreu wrote:
>> This is an initial submission for the Synopsys Designware HDMI RX
>> Controller Driver. This driver interacts with a phy driver so that
>> a communication between them is created and a video pipeline is
>> configured.
>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>> Cc: Carlos Palminha <palminha@synopsys.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sylwester Nawrocki <snawrocki@kernel.org>
>>
>> Changes from v3:
>> 	- Use v4l2 async API (Sylwester)
>> 	- Do not block waiting for phy
>> 	- Do not use busy waiting delays (Sylwester)
>> 	- Simplify dw_hdmi_power_on (Sylwester)
>> 	- Use clock API (Sylwester)
>> 	- Use compatible string (Sylwester)
>> 	- Minor fixes (Sylwester)
>> Changes from v2:
>> 	- Address review comments from Hans regarding CEC
>> 	- Use CEC notifier
>> 	- Enable SCDC
>> Changes from v1:
>> 	- Add support for CEC
>> 	- Correct typo errors
>> 	- Correctly detect interlaced video modes
>> 	- Correct VIC parsing
>> Changes from RFC:
>> 	- Add support for HDCP 1.4
>> 	- Fixup HDMI_VIC not being parsed (Hans)
>> 	- Send source change signal when powering off (Hans)
>> 	- Add a "wait stable delay"
>> 	- Detect interlaced video modes (Hans)
>> 	- Restrain g/s_register from reading/writing to HDCP regs (Hans)
>> ---
>>   drivers/media/platform/dwc/Kconfig      |   15 +
>>   drivers/media/platform/dwc/Makefile     |    1 +
>>   drivers/media/platform/dwc/dw-hdmi-rx.c | 1862 +++++++++++++++++++++++++++++++
>>   drivers/media/platform/dwc/dw-hdmi-rx.h |  441 ++++++++
>>   include/media/dwc/dw-hdmi-rx-pdata.h    |   97 ++
>>   5 files changed, 2416 insertions(+)
>>   create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.c
>>   create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.h
>>   create mode 100644 include/media/dwc/dw-hdmi-rx-pdata.h
>>
>> diff --git a/drivers/media/platform/dwc/dw-hdmi-rx.c b/drivers/media/platform/dwc/dw-hdmi-rx.c
>> new file mode 100644
>> index 0000000..22ee51d
>> --- /dev/null
>> +++ b/drivers/media/platform/dwc/dw-hdmi-rx.c
>> +static const struct of_device_id dw_hdmi_supported_phys[] = {
>> +	{ .compatible = "snps,dw-hdmi-phy-e405", .data = DW_PHY_E405_DRVNAME, },
>> +	{ },
>> +};
>> +
>> +static struct device_node *dw_hdmi_get_phy_of_node(struct dw_hdmi_dev *dw_dev,
>> +		const struct of_device_id **found_id)
>> +{
>> +	struct device_node *child = NULL;
>> +	const struct of_device_id *id;
>> +
>> +	for_each_child_of_node(dw_dev->of_node, child) {
>> +		id = of_match_node(dw_hdmi_supported_phys, child);
>> +		if (id)
>> +			break;
>> +	}
>> +
>> +	if (found_id)
>> +		*found_id = id;
>> +
>> +	return child;
>> +}
>> +
>> +static int dw_hdmi_phy_init(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	struct dw_phy_pdata *phy = &dw_dev->phy_config;
>> +	const struct of_device_id *of_id;
>> +	struct of_dev_auxdata lookup;
> 	struct of_dev_auxdata lookup = { };
>
> You could initialize to 0 here and...
>
>> +	struct device_node *child;
>> +	const char *drvname;
>> +	int ret;
>> +
>> +	child = dw_hdmi_get_phy_of_node(dw_dev, &of_id);
>> +	if (!child || !of_id || !of_id->data) {
>> +		dev_err(dw_dev->dev, "no supported phy found in DT\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	drvname = of_id->data;
>> +	phy->funcs = &dw_hdmi_phy_funcs;
>> +	phy->funcs_arg = dw_dev;
>> +
>> +	lookup.compatible = (char *)of_id->compatible;
>> +	lookup.phys_addr = 0x0;
>> +	lookup.name = NULL;
> ...drop these two assignments.

Ok.

>
>> +	lookup.platform_data = phy;
>> +
>> +	request_module(drvname);
> I'd say this request_module() is not needed when you use the v4l2-async 
> subnotifiers and the modules are properly installed in the file system.
> I might be missing something though.

Hmm, well I didn't actually test without request_module but I
think its needed, otherwise I would have to do:

modprobe phy_module
modprobe controller_module

With request_module I just have to do:

modprobe controller_module

>
>> +	ret = of_platform_populate(dw_dev->of_node, NULL, &lookup, dw_dev->dev);
>> +	if (ret) {
>> +		dev_err(dw_dev->dev, "failed to populate phy driver\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void dw_hdmi_phy_exit(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	of_platform_depopulate(dw_dev->dev);
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
>> +static const struct v4l2_subdev_internal_ops dw_hdmi_internal_ops = {
>> +	.registered = dw_hdmi_registered,
>> +	.unregistered = dw_hdmi_unregistered,
>> +};
>> +
>> +static int dw_hdmi_v4l2_notify_bound(struct v4l2_async_notifier *notifier,
>> +		struct v4l2_subdev *subdev, struct v4l2_async_subdev *asd)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = notifier_to_dw_dev(notifier);
>> +
>> +	if (dw_dev->phy_async_sd.match.fwnode.fwnode ==
>> +			of_fwnode_handle(subdev->dev->of_node)) {
>> +		dev_dbg(dw_dev->dev, "found new subdev '%s'\n", subdev->name);
>> +		dw_dev->phy_sd = subdev;
>> +		return 0;
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static void dw_hdmi_v4l2_notify_unbind(struct v4l2_async_notifier *notifier,
>> +		struct v4l2_subdev *subdev, struct v4l2_async_subdev *asd)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = notifier_to_dw_dev(notifier);
>> +
>> +	if (dw_dev->phy_sd == subdev) {
>> +		dev_dbg(dw_dev->dev, "unbinding '%s'\n", subdev->name);
>> +		dw_dev->phy_sd = NULL;
>> +	}
>> +}
>> +
>> +static int dw_hdmi_v4l2_notify_complete(struct v4l2_async_notifier *notifier)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = notifier_to_dw_dev(notifier);
>> +	int ret;
>> +
>> +	ret = v4l2_device_register_subdev_nodes(&dw_dev->v4l2_dev);
> There shouldn't be multiple struct v4l2_device instances, instead we should 
> have only one created by the main driver. AFAIU, in your case it would be 
> driver associated with the dw-hdmi-soc DT node.  And normally such a top level 
> driver creates subdev device nodes when its all required sub-devices are 
> available.
>
> I think this patch could be useful for you:
> https://urldefense.proofpoint.com/v2/url?u=https-3A__patchwork.linuxtv.org_patch_41834&d=DwICaQ&c=DPL6_X_6JkXFx7AXWqB0tg&r=WHDsc6kcWAl4i96Vm5hJ_19IJiuxx_p_Rzo2g-uHDKw&m=VfuOK5-A8h_JQk0lk74o48aav0T2PnwxhIr2sauw46Y&s=0GuG3FNbkmfVVMYQuP-Ed6zY9PnXnw7S4KgQhG52JF4&e= 
>
> With that the dw-hdmi-soc driver would have it's v4l2-async notifier's
> notify_complete() callback called only when both the hdmi-rx and the
> hdmi-phy subdevs are registered.

Yeah, I saw the patches. I just implemented this way because they
are not merged yet, right?

>
>> +	if (ret) {
>> +		dev_err(dw_dev->dev, "failed to register subdev nodes\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +static int dw_hdmi_parse_dt(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	ret = clk_prepare_enable(dw_dev->clk);
>> +	if (ret) {
>> +		dev_err(dw_dev->dev, "failed to enable cfg-clk\n");
>> +		return ret;
>> +	}
>> +
>> +	dw_dev->cfg_clk = clk_get_rate(dw_dev->clk) / 1000000;
> 1000000U ?

Ok.

>
>> +	if (!dw_dev->cfg_clk) {
>> +		dev_err(dw_dev->dev, "invalid cfg-clk frequency\n");
>> +		ret = -EINVAL;
>> +		goto err_clk;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_clk:
>> +	clk_disable_unprepare(dw_dev->clk);
>> +	return ret;
>> +}
>> +
>> +static int dw_hdmi_rx_probe(struct platform_device *pdev)
>> +{
>> +	/* V4L2 initialization */
>> +	sd = &dw_dev->sd;
>> +	v4l2_subdev_init(sd, &dw_hdmi_sd_ops);
>> +	strlcpy(sd->name, dev_name(dev), sizeof(sd->name));
>> +	sd->dev = dev;
>> +	sd->internal_ops = &dw_hdmi_internal_ops;
>> +	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS;
> Don't you also need V4L2_SUBDEV_FL_HAS_DEVNODE flag set?

Ouch. Yes I need otherwise the subdev will not be associated with
the v4l2_device.

>
>> +	/* Notifier for subdev binding */
>> +	ret = dw_hdmi_v4l2_init_notifier(dw_dev);
>> +	if (ret) {
>> +		dev_err(dev, "failed to init v4l2 notifier\n");
>> +		goto err_v4l2_dev;
>> +	}
>> +
>> +	/* Phy loading */
> s/Phy/PHY/ ?

Ok.

>
>> +	ret = dw_hdmi_phy_init(dw_dev);
>> +	if (ret)
>> +		goto err_v4l2_notifier;
>> +
>> +	ret = v4l2_async_register_subdev(sd);
>> +	if (ret) {
>> +		dev_err(dev, "failed to register subdev\n");
>> +		goto err_cec;
>> +	}
>> +
>> +	/* Fill initial format settings */
>> +	dw_dev->timings = timings_def;
>> +	dw_dev->mbus_code = MEDIA_BUS_FMT_BGR888_1X24;
>> +
>> +	/* All done */
> This comment seems unneeded.

Ok.

>
>> +	dev_set_drvdata(dev, sd);
>> +	dw_dev->state = HDMI_STATE_POWER_OFF;
>> +	dw_hdmi_detect_tx_5v(dw_dev);
>> +	dev_info(dev, "driver probed\n");
> dev_dbg()

Ok.

>
>> +	return 0;
>> +
>> +err_cec:
>> +	cec_delete_adapter(dw_dev->cec_adap);
>> +err_phy:
>> +	dw_hdmi_phy_exit(dw_dev);
>> +err_v4l2_notifier:
>> +	v4l2_async_notifier_unregister(&dw_dev->v4l2_notifier);
>> +err_v4l2_dev:
>> +	v4l2_device_unregister(&dw_dev->v4l2_dev);
>> +err_wq:
>> +	destroy_workqueue(dw_dev->wq);
>> +	return ret;
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
>> +	dw_hdmi_phy_exit(dw_dev);
>> +	v4l2_async_unregister_subdev(sd);
>> +	clk_disable_unprepare(dw_dev->clk);
>> +	dev_info(dev, "driver removed\n");
> dev_dbg()

Ok.

Thanks for the review!

Best regards,
Jose Miguel Abreu

>
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id dw_hdmi_rx_id[] = {
>> +	{ .compatible = "snps,dw-hdmi-rx" },
>> +	{ },
>> +};
>> +MODULE_DEVICE_TABLE(of, dw_hdmi_rx_id);
> --
> Regards,
> Sylwester
