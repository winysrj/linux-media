Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21102 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbbCBBtO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2015 20:49:14 -0500
Message-ID: <54F3C16E.9040703@atmel.com>
Date: Mon, 2 Mar 2015 09:48:30 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 2/4] media: ov2640: add async probe function
References: <1423560696-12304-1-git-send-email-josh.wu@atmel.com> <1423560696-12304-3-git-send-email-josh.wu@atmel.com> <Pine.LNX.4.64.1503012202460.2412@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1503012202460.2412@axis700.grange>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/2/2015 5:06 AM, Guennadi Liakhovetski wrote:
> Hi Josh,
>
> Thanks for a patch update. I think it looks good as a first step in your
> patch series, just a minor comment below:
>
> On Tue, 10 Feb 2015, Josh Wu wrote:
>
>> In async probe, there is a case that ov2640 is probed before the
>> host device which provided 'mclk'.
>> To support this async probe, we will get 'mclk' at first in the probe(),
>> if failed it will return -EPROBE_DEFER. That will let ov2640 wait for
>> the host device probed.
>>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>>
>> Changes in v5:
>> - don't change the ov2640_s_power() code.
>> - will get 'mclk' at the beginning of ov2640_probe().
>>
>> Changes in v4: None
>> Changes in v3: None
>> Changes in v2: None
>>
>>   drivers/media/i2c/soc_camera/ov2640.c | 29 +++++++++++++++++++----------
>>   1 file changed, 19 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
>> index 1fdce2f..057dd49 100644
>> --- a/drivers/media/i2c/soc_camera/ov2640.c
>> +++ b/drivers/media/i2c/soc_camera/ov2640.c
>> @@ -1068,6 +1068,10 @@ static int ov2640_probe(struct i2c_client *client,
>>   		return -ENOMEM;
>>   	}
>>   
>> +	priv->clk = v4l2_clk_get(&client->dev, "mclk");
>> +	if (IS_ERR(priv->clk))
>> +		return -EPROBE_DEFER;
>> +
>>   	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
>>   	v4l2_ctrl_handler_init(&priv->hdl, 2);
>>   	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
>> @@ -1075,24 +1079,28 @@ static int ov2640_probe(struct i2c_client *client,
>>   	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
>>   			V4L2_CID_HFLIP, 0, 1, 1, 0);
>>   	priv->subdev.ctrl_handler = &priv->hdl;
>> -	if (priv->hdl.error)
>> -		return priv->hdl.error;
>> -
>> -	priv->clk = v4l2_clk_get(&client->dev, "mclk");
>> -	if (IS_ERR(priv->clk)) {
>> -		ret = PTR_ERR(priv->clk);
>> -		goto eclkget;
>> +	if (priv->hdl.error) {
>> +		ret = priv->hdl.error;
>> +		goto err_clk;
>>   	}
>>   
>>   	ret = ov2640_video_probe(client);
>>   	if (ret) {
>> -		v4l2_clk_put(priv->clk);
>> -eclkget:
>> -		v4l2_ctrl_handler_free(&priv->hdl);
>> +		goto err_videoprobe;
> Since you add a "goto" here, you don't need an "else" after it, and the
> "probed" success message should go down, so, just make it
>
> 	ret = ov2640_video_probe(client);
> 	if (ret < 0)
> 		goto err_videoprobe;
>
> 	ret = v4l2_async_register_subdev(&priv->subdev);
> 	if (ret < 0)
> 		goto err_videoprobe;
>
> 	dev_info(&adapter->dev, "OV2640 Probed\n");
>
> 	return 0;
>
> err_...

Yes. This looks better.
I'll update and resend this patch. This change is independent and no 
need to resend the whole patch series.
Thanks.

Best Regards,
Josh Wu

>
> Thanks
> Guennadi
>
>>   	} else {
>>   		dev_info(&adapter->dev, "OV2640 Probed\n");
>>   	}
>>   
>> +	ret = v4l2_async_register_subdev(&priv->subdev);
>> +	if (ret < 0)
>> +		goto err_videoprobe;
>> +
>> +	return 0;
>> +
>> +err_videoprobe:
>> +	v4l2_ctrl_handler_free(&priv->hdl);
>> +err_clk:
>> +	v4l2_clk_put(priv->clk);
>>   	return ret;
>>   }
>>   
>> @@ -1100,6 +1108,7 @@ static int ov2640_remove(struct i2c_client *client)
>>   {
>>   	struct ov2640_priv       *priv = to_ov2640(client);
>>   
>> +	v4l2_async_unregister_subdev(&priv->subdev);
>>   	v4l2_clk_put(priv->clk);
>>   	v4l2_device_unregister_subdev(&priv->subdev);
>>   	v4l2_ctrl_handler_free(&priv->hdl);
>> -- 
>> 1.9.1
>>

