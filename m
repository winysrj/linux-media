Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36347 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932871AbeDXIq0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 04:46:26 -0400
References: <20180423134750.30403-1-rui.silva@linaro.org> <20180423134750.30403-7-rui.silva@linaro.org> <1524498503.3396.5.camel@pengutronix.de>
From: Rui Miguel Silva <rmfrfs@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 06/15] media: staging/imx: add imx7 capture subsystem
In-reply-to: <1524498503.3396.5.camel@pengutronix.de>
Date: Tue, 24 Apr 2018 09:46:22 +0100
Message-ID: <m3tvs1dmap.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,
On Mon 23 Apr 2018 at 15:48, Philipp Zabel wrote:
> On Mon, 2018-04-23 at 14:47 +0100, Rui Miguel Silva wrote:
>> Add imx7 capture subsystem to imx-media core to allow the use 
>> some of the
>> existing modules for i.MX5/6 with i.MX7 SoC.
>> 
>> Since i.MX7 does not have an IPU unset the ipu_present flag to 
>> differentiate
>> some runtime behaviors.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> ---
>>  drivers/staging/media/imx/imx-media-dev.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/drivers/staging/media/imx/imx-media-dev.c 
>> b/drivers/staging/media/imx/imx-media-dev.c
>> index c0f277adeebe..be68235c4caa 100644
>> --- a/drivers/staging/media/imx/imx-media-dev.c
>> +++ b/drivers/staging/media/imx/imx-media-dev.c
>> @@ -486,6 +486,9 @@ static int imx_media_probe(struct 
>> platform_device *pdev)
>>  
>>  	imxmd->ipu_present = true;
>>  
>> +	if (of_device_is_compatible(node, 
>> "fsl,imx7-capture-subsystem"))
>> +		imxmd->ipu_present = false;
>> +
>
> Is this something of_match_device should be used for?

Yeah, good point. I will develop your suggestion.

---
Cheers,
	Rui

>
>>  	if (imxmd->ipu_present) {
>>  		ret = imx_media_add_internal_subdevs(imxmd);
>>  		if (ret) {
>> @@ -543,6 +546,7 @@ static int imx_media_remove(struct 
>> platform_device *pdev)
>>  
>>  static const struct of_device_id imx_media_dt_ids[] = {
>>  	{ .compatible = "fsl,imx-capture-subsystem" },
>> +	{ .compatible = "fsl,imx7-capture-subsystem" },
>>  	{ /* sentinel */ }
>>  };
>>  MODULE_DEVICE_TABLE(of, imx_media_dt_ids);
>
> regards
> Philipp
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
