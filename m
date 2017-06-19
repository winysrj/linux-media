Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752478AbdFSWKR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 18:10:17 -0400
Subject: Re: [PATCH v3 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <cover.1497630695.git.joabreu@synopsys.com>
 <d7f507ccec6f25f9be457c1c3f2f802b55377a1f.1497630695.git.joabreu@synopsys.com>
 <fd65183f-b577-9ac6-a56e-689121e82e73@kernel.org>
 <b4b49f3c-3b07-5638-62b9-26a1fe68af98@synopsys.com>
From: Sylwester Nawrocki <snawrocki@kernel.org>
Message-ID: <c75953dc-c5aa-d9ec-e255-dfa6d03df64f@kernel.org>
Date: Tue, 20 Jun 2017 00:10:07 +0200
MIME-Version: 1.0
In-Reply-To: <b4b49f3c-3b07-5638-62b9-26a1fe68af98@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/19/2017 11:33 AM, Jose Abreu wrote:
> On 18-06-2017 19:04, Sylwester Nawrocki wrote:
>> On 06/16/2017 06:38 PM, Jose Abreu wrote:
>>> This is an initial submission for the Synopsys Designware HDMI RX
>>> Controller Driver. This driver interacts with a phy driver so that
>>> a communication between them is created and a video pipeline is
>>> configured.
>>>
>>> The controller + phy pipeline can then be integrated into a fully
>>> featured system that can be able to receive video up to 4k@60Hz
>>> with deep color 48bit RGB, depending on the platform. Although,
>>> this initial version does not yet handle deep color modes.
>>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>>>
>>> +static int dw_hdmi_phy_init(struct dw_hdmi_dev *dw_dev)
>>> +{

>>> +	request_module(pdevinfo.name);
>>> +
>>> +	dw_dev->phy_pdev = platform_device_register_full(&pdevinfo);
>>> +	if (IS_ERR(dw_dev->phy_pdev)) {
>>> +		dev_err(dw_dev->dev, "failed to register phy device\n");
>>> +		return PTR_ERR(dw_dev->phy_pdev);
>>> +	}
>>> +
>>> +	if (!dw_dev->phy_pdev->dev.driver) {
>>> +		dev_err(dw_dev->dev, "failed to initialize phy driver\n");
>>> +		goto err;
>>> +	}
>> I think this is not safe because there is nothing preventing unbinding
>> or unloading the driver at this point.
>>
>>> +	if (!try_module_get(dw_dev->phy_pdev->dev.driver->owner)) {
>> So dw_dev->phy_pdev->dev.driver may be already NULL here.
> 
> How can I make sure it wont be NULL? Because I've seen other
> media drivers do this and I don't think they do any kind of
> locking, but they do this mainly for I2C subdevs.

You could do device_lock(dev)/device_unlock(dev) to avoid possible races. 
And setting 'suppress_bind_attrs' field in the sub-device drivers would 
disable sysfs unbind attributes, so sub-device driver wouldn't get unbound
unexpectedly trough sysfs.
 
>>> +		dev_err(dw_dev->dev, "failed to get phy module\n");
>>> +		goto err;
>>> +	}
>>> +
>>> +	dw_dev->phy_sd = dev_get_drvdata(&dw_dev->phy_pdev->dev);
>>> +	if (!dw_dev->phy_sd) {
>>> +		dev_err(dw_dev->dev, "failed to get phy subdev\n");
>>> +		goto err_put;
>>> +	}
>>> +
>>> +	if (v4l2_device_register_subdev(&dw_dev->v4l2_dev, dw_dev->phy_sd)) {
>>> +		dev_err(dw_dev->dev, "failed to register phy subdev\n");
>>> +		goto err_put;
>>> +	}
>>
>> I'd suggest usign v4l2-async API, so we use a common pattern for sub-device
>> registration.  And with recent change [1] you could handle this PHY subdev
>> in a standard way.  That might be more complicated than it is now but should
>> make any future platform integration easier.

> So I will instantiate phy driver and then wait for phy driver to
> register into v4l2 core?

Yes, for instance the RX controller driver registers a notifier, instantiates
the child PHY device and then waits until the PHY driver completes initialization.

>>> +	module_put(dw_dev->phy_pdev->dev.driver->owner);
>>> +	return 0;
>>> +
>>> +err_put:
>>> +	module_put(dw_dev->phy_pdev->dev.driver->owner);
>>> +err:
>>> +	platform_device_unregister(dw_dev->phy_pdev);
>>> +	return -EINVAL;
>>> +}

>>> +static int dw_hdmi_power_on(struct dw_hdmi_dev *dw_dev, u32 input)
>>> +{
>>> +	struct dw_hdmi_work_data *data;
>>> +	unsigned long flags;
>>> +
>>> +	data = devm_kzalloc(dw_dev->dev, sizeof(*data), GFP_KERNEL);
>>
>> Why use devm_{kzalloc, kfree} when dw_hdmi_power_on() is not only called
>> in the device's probe() callback, but in other places, including interrupt
>> handler?  devm_* API is normally used when life time of a resource is more
>> or less equal to life time of struct device or its matched driver.  Were
>> there any specific reasons to not just use kzalloc()/kfree() ?
> 
> No specific reason, I just thought it would be safer because if I
> cancel a work before it started then memory will remain
> allocated. But I will change to kzalloc().

OK, I overlooked such situation. Since you allow one job queued maybe
just embed struct work_struct in struct dw_hdmi_dev and retrieve it with
container_of() macro in the work handler and use additional field in
struct dw_hdmi_dev protected with dw_dev->lock for passing the input 
index?

>>> +	if (!data)
>>> +		return -ENOMEM;
>>> +
>>> +	INIT_WORK(&data->work, dw_hdmi_work_handler);
>>> +	data->dw_dev = dw_dev;
>>> +	data->input = input;
>>> +
>>> +	spin_lock_irqsave(&dw_dev->lock, flags);
>>> +	if (dw_dev->pending_config) {
>>> +		devm_kfree(dw_dev->dev, data);
>>> +		spin_unlock_irqrestore(&dw_dev->lock, flags);
>>> +		return 0;
>>> +	}
>>> +
>>> +	queue_work(dw_dev->wq, &data->work);
>>> +	dw_dev->pending_config = true;
>>> +	spin_unlock_irqrestore(&dw_dev->lock, flags);
>>> +	return 0;
>>> +}

>>> +struct dw_hdmi_rx_pdata {
>>> +	/* Controller configuration */

>>> +	struct dw_hdmi_hdcp14_key hdcp14_keys;
>>> +	/* 5V sense interface */
>>> +	bool (*dw_5v_status)(void __iomem *regs, int input);
>>> +	void (*dw_5v_clear)(void __iomem *regs);
>>> +	void __iomem *dw_5v_arg;> +	/* Zcal interface */
>>> +	void (*dw_zcal_reset)(void __iomem *regs);
>>> +	bool (*dw_zcal_done)(void __iomem *regs);
>>> +	void __iomem *dw_zcal_arg;
>>
>> I'm just wondering if these operations could be modeled with the regmap,
>> so we could avoid callbacks in the platform data structure.
> 
> Hmm, I don't think that is safe because registers may not be
> adjacent to each other. And maybe I was a little generous in
> passing a __iomem argument, maybe it should be just void instead
> because this can be not a regmap at all.

I meant two separate regmaps, but it's not that good anyway, since
register address and register bit fields not specific to the HDMI RX
block would need to be handled in this driver.

--
Regards,
Sylwester 
