Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:37151 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934394AbaFSTMV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 15:12:21 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] media: soc_camera: pxa_camera device-tree support
References: <1402863436-30311-1-git-send-email-robert.jarzmik@free.fr>
	<1402863436-30311-2-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.1406190939470.22703@axis700.grange>
Date: Thu, 19 Jun 2014 21:12:19 +0200
In-Reply-To: <Pine.LNX.4.64.1406190939470.22703@axis700.grange> (Guennadi
	Liakhovetski's message of "Thu, 19 Jun 2014 10:16:59 +0200 (CEST)")
Message-ID: <87fvj0soh8.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> On Sun, 15 Jun 2014, Robert Jarzmik wrote:
>> +static const struct of_device_id pxacamera_dt_ids[] = {
>> +	{ .compatible = "mrvl,pxa_camera", },
>
> as Documentation/devicetree/bindings/vendor-prefixes.txt defines, it 
> should be "marvell."
OK, I'll ask for confirmation to Haojian and Grant, as marvell and mrvl are both
used, and I have many pending patches. So I'd like to be sure, and then amend
all my patches at once.

>> +	dev_info(dev, "RJK: %s()\n", __func__);
>
> I have nothing against attributing work to respective authors, but I don't 
> think this makes a lot of sense in the long run in the above form :) Once 
> you've verified that your binding is working and this function is working, 
> either remove this or make it more informative - maybe at the end of this 
> function, also listing a couple of important parameters, that you obtained 
> from DT.
Ah, debug leftover. RJK is my "special mark" for "remove me before
submitting". See how well it worked :)


>
>> +	err = of_property_read_u32(np, "mclk_10khz",
>> +				   (u32 *)&pdata->mclk_10khz);
>
> I think we'll be frowned upon for this :) PXA270 doesn't support CCF, does 
> it? Even if it doesn't we probably should use the standard 
> "clock-frequency" property in any case. Actually, I missed to mention on 
> this in my comments to your bindings documentation.

You're right. This should be the normal Hz clock stuff. For V2.
>>  	pcdev->pdata = pdev->dev.platform_data;
>> +	if (&pdev->dev.of_node && !pcdev->pdata)
>> +		err = pxa_camera_pdata_from_dt(&pdev->dev, &pdata_dt);
>> +	if (err < 0)
>> +		return err;
>> +	else
>> +		pcdev->pdata = &pdata_dt;
>
> This will Oops, if someone decides to dereference pcdev->pdata outside of 
> this function. pdata_dt is on stack and you store a pointer to it in your 
> device data... But since ->pdata doesn't seem to be used anywhere else in 
> this driver, maybe remove that struct member completely?
Yep, obliteration, good for me.
There is indeed no purpose in keeping this pdata in pcdev, its only purpose was
to get mclk and platform_flags. For V2 also.

>> +
>>  	pcdev->platform_flags = pcdev->pdata->flags;
>>  	if (!(pcdev->platform_flags & (PXA_CAMERA_DATAWIDTH_8 |
>>  			PXA_CAMERA_DATAWIDTH_9 | PXA_CAMERA_DATAWIDTH_10))) {
>> @@ -1799,10 +1872,17 @@ static const struct dev_pm_ops pxa_camera_pm = {
>>  	.resume		= pxa_camera_resume,
>>  };
>>  
>> +static const struct of_device_id pxa_camera_of_match[] = {
>> +	{ .compatible = "mrvl,pxa_camera", },
>
> Another thing I failed to comment upon: I think DT should contain only 
> hardware descriptions, nothing driver specific, and "pxa_camera" is more a 
> name of the driver, than the hardware? Maybe something like 
> "marvell,pxa27x-cif" would be suitable?
Yeah, sure, whatever you like.

Thanks for the review.

Cheers.

--
Robert
