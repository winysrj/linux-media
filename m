Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.141]:48282 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751042AbeAKGVg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 01:21:36 -0500
Reply-To: zhengsq@rock-chips.com
Subject: Re: [PATCH v5 2/4] media: ov5695: add support for OV5695 sensor
To: jacopo mondi <jacopo@jmondi.org>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
References: <1515549967-5302-1-git-send-email-zhengsq@rock-chips.com>
 <1515549967-5302-3-git-send-email-zhengsq@rock-chips.com>
 <20180110090836.GB6834@w540>
From: Shunqian Zheng <zhengsq@rock-chips.com>
Message-ID: <2ab51b3f-0c37-6c3d-6b2e-c7e767275380@rock-chips.com>
Date: Thu, 11 Jan 2018 14:21:17 +0800
MIME-Version: 1.0
In-Reply-To: <20180110090836.GB6834@w540>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,


On 2018年01月10日 17:08, jacopo mondi wrote:
> Hello Shunqian,
>
> On Wed, Jan 10, 2018 at 10:06:05AM +0800, Shunqian Zheng wrote:
>
> [snip]
>
>> +static int __ov5695_start_stream(struct ov5695 *ov5695)
>> +{
>> +	int ret;
>> +
>> +	ret = ov5695_write_array(ov5695->client, ov5695_global_regs);
>> +	if (ret)
>> +		return ret;
>> +	ret = ov5695_write_array(ov5695->client, ov5695->cur_mode->reg_list);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* In case these controls are set before streaming */
>> +	ret = __v4l2_ctrl_handler_setup(&ov5695->ctrl_handler);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return ov5695_write_reg(ov5695->client, OV5695_REG_CTRL_MODE,
>> +				OV5695_REG_VALUE_08BIT, OV5695_MODE_STREAMING);
>> +}
>> +
>> +static int __ov5695_stop_stream(struct ov5695 *ov5695)
>> +{
>> +	return ov5695_write_reg(ov5695->client, OV5695_REG_CTRL_MODE,
>> +				OV5695_REG_VALUE_08BIT, OV5695_MODE_SW_STANDBY);
>> +}
>> +
>> +static int ov5695_s_stream(struct v4l2_subdev *sd, int on)
>> +{
>> +	struct ov5695 *ov5695 = to_ov5695(sd);
>> +	struct i2c_client *client = ov5695->client;
>> +	int ret = 0;
>> +
>> +	mutex_lock(&ov5695->mutex);
>> +	on = !!on;
>> +	if (on == ov5695->streaming)
>> +		goto unlock_and_return;
>> +
>> +	if (on) {
>> +		ret = pm_runtime_get_sync(&client->dev);
>> +		if (ret < 0) {
>> +			pm_runtime_put_noidle(&client->dev);
>> +			goto unlock_and_return;
>> +		}
>> +
>> +		ret = __ov5695_start_stream(ov5695);
>> +		if (ret) {
>> +			v4l2_err(sd, "start stream failed while write regs\n");
>> +			pm_runtime_put(&client->dev);
>> +			goto unlock_and_return;
>> +		}
>> +	} else {
>> +		__ov5695_stop_stream(ov5695);
>> +		ret = pm_runtime_put(&client->dev);
> I would return the result of __ov5695_stop_stream() instead of
> pm_runtime_put().
>
> I know I asked for this, but if the first s_stream(0) fails, the
> sensor may not have been stopped but the interface will be put in
> "streaming = 0" state, preventing a second s_stream(0) to be issued
> because of your check "on == ov5695->streaming" a few lines above.
>
> I can't tell how bad this is. Imho is acceptable but I would like to
> hear someone else opinion here :)
How about not checking the return values of s_stream(0) branch?
It seems not much this driver can do if pm_runtime_put() fails.
>
>> +	}
>> +
>> +	ov5695->streaming = on;
>> +
>> +unlock_and_return:
>> +	mutex_unlock(&ov5695->mutex);
>> +
>> +	return ret;
>> +}
>> +
>> +
> [snip]
>
>> +static const struct of_device_id ov5695_of_match[] = {
>> +	{ .compatible = "ovti,ov5695" },
>> +	{},
>> +};
> If you don't list CONFIG_OF as a dependecy for this driver (which you
> should not imho), please guard this with:
>
> #if IS_ENABLED(CONFIG_OF)
>
> #endif
>
>> +
>> +static struct i2c_driver ov5695_i2c_driver = {
>> +	.driver = {
>> +		.name = "ov5695",
>> +		.owner = THIS_MODULE,
>> +		.pm = &ov5695_pm_ops,
>> +		.of_match_table = ov5695_of_match
>> +	},
>> +	.probe		= &ov5695_probe,
>> +	.remove		= &ov5695_remove,
>> +};
>> +
>> +module_i2c_driver(ov5695_i2c_driver);
>> +
>> +MODULE_DESCRIPTION("OmniVision ov5695 sensor driver");
>> +MODULE_LICENSE("GPL v2");
> As you've fixed my comments on v1, and with the above bits addressed:
>
> Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Thank you very much~
Shunqian
>
> Thanks
>     j
>
>> --
>> 1.9.1
>>
>
>
