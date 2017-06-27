Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753292AbdF0Uew (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 16:34:52 -0400
Subject: Re: [PATCH v4 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <cover.1497978962.git.joabreu@synopsys.com>
 <314b7ae92c9924d0991e14ccad80ca937a2d7b07.1497978962.git.joabreu@synopsys.com>
 <e6f63454-2e87-6e93-50c3-2802e9357c2a@kernel.org>
 <2868c525-3edd-0fe1-cc6f-49a758f8c434@synopsys.com>
From: Sylwester Nawrocki <snawrocki@kernel.org>
Message-ID: <2153d8da-effc-fedd-a2ce-b1c9ee40a82c@kernel.org>
Date: Tue, 27 Jun 2017 22:34:46 +0200
MIME-Version: 1.0
In-Reply-To: <2868c525-3edd-0fe1-cc6f-49a758f8c434@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jose,

On 06/27/2017 10:43 AM, Jose Abreu wrote:
> On 25-06-2017 22:13, Sylwester Nawrocki wrote:
>> On 06/20/2017 07:26 PM, Jose Abreu wrote:
>>> This is an initial submission for the Synopsys Designware HDMI RX
>>> Controller Driver. This driver interacts with a phy driver so that
>>> a communication between them is created and a video pipeline is
>>> configured.
>>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>

>>> +static int dw_hdmi_phy_init(struct dw_hdmi_dev *dw_dev)
>>> +{
>>> +	struct dw_phy_pdata *phy = &dw_dev->phy_config;
>>> +	const struct of_device_id *of_id;
>>> +	struct of_dev_auxdata lookup;
>> 	struct of_dev_auxdata lookup = { };
>>
>> You could initialize to 0 here and...
>>
>>> +	struct device_node *child;
>>> +	const char *drvname;
>>> +	int ret;
>>> +
>>> +	child = dw_hdmi_get_phy_of_node(dw_dev, &of_id);
>>> +	if (!child || !of_id || !of_id->data) {
>>> +		dev_err(dw_dev->dev, "no supported phy found in DT\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	drvname = of_id->data;
>>> +	phy->funcs = &dw_hdmi_phy_funcs;
>>> +	phy->funcs_arg = dw_dev;
>>> +
>>> +	lookup.compatible = (char *)of_id->compatible;
>>> +	lookup.phys_addr = 0x0;
>>> +	lookup.name = NULL;
>>
>> ...drop these two assignments.
> 
> Ok.
> 
>>> +	lookup.platform_data = phy;
>>> +
>>> +	request_module(drvname);
>>
>> I'd say this request_module() is not needed when you use the v4l2-async
>> subnotifiers and the modules are properly installed in the file system.
>> I might be missing something though.
> 
> Hmm, well I didn't actually test without request_module but I
> think its needed, otherwise I would have to do:
> 
> modprobe phy_module
> modprobe controller_module
> 
> With request_module I just have to do:
> 
> modprobe controller_module

If you are sure you need it I'm not against that.  But assuming you have udev 
in your system it should also work like this, without request_module():

1. modprobe controller_module -> phy device is created in the kernel, uevent sent
2. udev receives uevent, finds matching module and does modprobe phy_module

Remaining part is as before: phy_module registers the driver which gets matched with 
phy device; probe() is called which registers v4l2 subdev which then is registered
to v4l2_device through the v4l2-async mechanism.

All this assumes udev is running and modules are installed in /lib/modules/$(uname -r).
E.g. there should be your module alias as shown by modinfo phy_module in
/lib/modules/$(uname -r)/modules.alias.

>>> +	ret = of_platform_populate(dw_dev->of_node, NULL, &lookup, dw_dev->dev);
>>> +	if (ret) {
>>> +		dev_err(dw_dev->dev, "failed to populate phy driver\n");
>>> +		return ret;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static void dw_hdmi_phy_exit(struct dw_hdmi_dev *dw_dev)
>>> +{
>>> +	of_platform_depopulate(dw_dev->dev);
>>> +}

>>> +static int dw_hdmi_v4l2_notify_complete(struct v4l2_async_notifier *notifier)
>>> +{
>>> +	struct dw_hdmi_dev *dw_dev = notifier_to_dw_dev(notifier);
>>> +	int ret;
>>> +
>>> +	ret = v4l2_device_register_subdev_nodes(&dw_dev->v4l2_dev);
>>
>> There shouldn't be multiple struct v4l2_device instances, instead we should
>> have only one created by the main driver. AFAIU, in your case it would be
>> driver associated with the dw-hdmi-soc DT node.  And normally such a top level
>> driver creates subdev device nodes when its all required sub-devices are
>> available.
>>
>> I think this patch could be useful for you:
>> https://patchwork.linuxtv.org/patch/41834
>>
>> With that the dw-hdmi-soc driver would have it's v4l2-async notifier's
>> notify_complete() callback called only when both the hdmi-rx and the
>> hdmi-phy subdevs are registered.
> 
> Yeah, I saw the patches. I just implemented this way because they
> are not merged yet, right?

I think these patches will be merged in v4.14-rc1, so together with your driver.
You could apply them locally and indicate that your series depends on them in 
the cover letter.

>>> +	if (ret) {
>>> +		dev_err(dw_dev->dev, "failed to register subdev nodes\n");
>>> +		return ret;
>>> +	}
>>> +
>>> +	return 0;
>>> +}

>>> +static int dw_hdmi_rx_probe(struct platform_device *pdev)
>>> +{
>>> +	/* V4L2 initialization */
>>> +	sd = &dw_dev->sd;
>>> +	v4l2_subdev_init(sd, &dw_hdmi_sd_ops);
>>> +	strlcpy(sd->name, dev_name(dev), sizeof(sd->name));
>>> +	sd->dev = dev;
>>> +	sd->internal_ops = &dw_hdmi_internal_ops;
>>> +	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS;
>>
>> Don't you also need V4L2_SUBDEV_FL_HAS_DEVNODE flag set?
> 
> Ouch. Yes I need otherwise the subdev will not be associated with
> the v4l2_device.

This flag indicates that the v4l2 subdev device node (/dev/v4l-subdev?)
should be created for this subdevice.

---
Regards,
Sylwester
 
