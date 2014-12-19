Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:38677 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751003AbaLSGL6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 01:11:58 -0500
Message-ID: <5493C1A8.4050204@atmel.com>
Date: Fri, 19 Dec 2014 14:11:52 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>,
	<linux-arm-kernel@lists.infradead.org>,
	<laurent.pinchart@ideasonboard.com>, <s.nawrocki@samsung.com>,
	<festevam@gmail.com>
Subject: Re: [PATCH v4 2/5] media: ov2640: add async probe function
References: <1418869646-17071-1-git-send-email-josh.wu@atmel.com> <1418869646-17071-3-git-send-email-josh.wu@atmel.com> <Pine.LNX.4.64.1412182237370.11953@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1412182237370.11953@axis700.grange>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

Thanks for the review.

On 12/19/2014 5:59 AM, Guennadi Liakhovetski wrote:
> Hi Josh,
>
> Thanks for your patches!
>
> On Thu, 18 Dec 2014, Josh Wu wrote:
>
>> To support async probe for ov2640, we need remove the code to get 'mclk'
>> in ov2640_probe() function. oterwise, if soc_camera host is not probed
>> in the moment, then we will fail to get 'mclk' and quit the ov2640_probe()
>> function.
>>
>> So in this patch, we move such 'mclk' getting code to ov2640_s_power()
>> function. That make ov2640 survive, as we can pass a NULL (priv-clk) to
>> soc_camera_set_power() function.
>>
>> And if soc_camera host is probed, the when ov2640_s_power() is called,
>> then we can get the 'mclk' and that make us enable/disable soc_camera
>> host's clock as well.
>>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>> v3 -> v4:
>> v2 -> v3:
>> v1 -> v2:
>>    no changes.
>>
>>   drivers/media/i2c/soc_camera/ov2640.c | 31 +++++++++++++++++++++----------
>>   1 file changed, 21 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
>> index 1fdce2f..9ee910d 100644
>> --- a/drivers/media/i2c/soc_camera/ov2640.c
>> +++ b/drivers/media/i2c/soc_camera/ov2640.c
>> @@ -739,6 +739,15 @@ static int ov2640_s_power(struct v4l2_subdev *sd, int on)
>>   	struct i2c_client *client = v4l2_get_subdevdata(sd);
>>   	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>>   	struct ov2640_priv *priv = to_ov2640(client);
>> +	struct v4l2_clk *clk;
>> +
>> +	if (!priv->clk) {
>> +		clk = v4l2_clk_get(&client->dev, "mclk");
>> +		if (IS_ERR(clk))
>> +			dev_warn(&client->dev, "Cannot get the mclk. maybe soc-camera host is not probed yet.\n");
>> +		else
>> +			priv->clk = clk;
>> +	}
>>   
>>   	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
>>   }
>> @@ -1078,21 +1087,21 @@ static int ov2640_probe(struct i2c_client *client,
>>   	if (priv->hdl.error)
>>   		return priv->hdl.error;
>>   
>> -	priv->clk = v4l2_clk_get(&client->dev, "mclk");
>> -	if (IS_ERR(priv->clk)) {
>> -		ret = PTR_ERR(priv->clk);
>> -		goto eclkget;
>> -	}
>> -
>>   	ret = ov2640_video_probe(client);
> The first thing the above ov2640_video_probe() function will do is call
> ov2640_s_power(), which will request the clock. So, by moving requesting
> the clock from ov2640_probe() to ov2640_s_power() doesn't change how
> probing will be performed, am I right?
yes, you are right. In this patch, the "mclk" will requested by 
ov2640_s_power().

The reason why I put the getting "mclk" code from ov2640_probe() to 
ov2640_s_power() is : as the "mclk" here is camera host's peripheral 
clock. That means ov2640 still can be probed properly (read ov2640 id) 
even no "mclk". So when I move this code to ov2640_s_power(), otherwise 
the ov2640_probe() will be failed or DEFER_PROBE.

Is this true for all camera host? If it's not true, then I think use 
-EPROBE_DEFER would be a proper way.


> Or are there any other patched,
> that change that, that I'm overseeing?
>
> If I'm right, then I would propose an approach, already used in other
> drivers instead of this one: return -EPROBE_DEFER if the clock isn't
> available during probing. See ef6672ea35b5bb64ab42e18c1a1ffc717c31588a for
> an example. Or did I misunderstand anything?
Actually months ago I already done a version of ov2640 patch which use 
-EPROBE_DEFER way.

But now I think the ov2640 can be probed correctly without "mclk", so it 
is no need to return -EPROBE_DEFER.
And the v4l2 asyn API can handle the synchronization of host. So I 
prefer to use this way.
What do you think about this?

Best Regards,
Josh Wu

>
> Thanks
> Guennadi
>
>>   	if (ret) {
>> -		v4l2_clk_put(priv->clk);
>> -eclkget:
>> -		v4l2_ctrl_handler_free(&priv->hdl);
>> +		goto evideoprobe;
>>   	} else {
>>   		dev_info(&adapter->dev, "OV2640 Probed\n");
>>   	}
>>   
>> +	ret = v4l2_async_register_subdev(&priv->subdev);
>> +	if (ret < 0)
>> +		goto evideoprobe;
>> +
>> +	return 0;
>> +
>> +evideoprobe:
>> +	v4l2_ctrl_handler_free(&priv->hdl);
>>   	return ret;
>>   }
>>   
>> @@ -1100,7 +1109,9 @@ static int ov2640_remove(struct i2c_client *client)
>>   {
>>   	struct ov2640_priv       *priv = to_ov2640(client);
>>   
>> -	v4l2_clk_put(priv->clk);
>> +	v4l2_async_unregister_subdev(&priv->subdev);
>> +	if (priv->clk)
>> +		v4l2_clk_put(priv->clk);
>>   	v4l2_device_unregister_subdev(&priv->subdev);
>>   	v4l2_ctrl_handler_free(&priv->hdl);
>>   	return 0;
>> -- 
>> 1.9.1
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

