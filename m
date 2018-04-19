Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:42258 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753610AbeDSOUc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 10:20:32 -0400
References: <20180419101812.30688-1-rui.silva@linaro.org> <20180419101812.30688-8-rui.silva@linaro.org> <1524145101.3416.7.camel@pengutronix.de>
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
Subject: Re: [PATCH 07/15] media: staging/imx: add 10 bit bayer support
In-reply-to: <1524145101.3416.7.camel@pengutronix.de>
Date: Thu, 19 Apr 2018 15:20:29 +0100
Message-ID: <m3fu3r9t1u.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philip,
Thanks for the review.

On Thu 19 Apr 2018 at 13:38, Philipp Zabel wrote:
> On Thu, 2018-04-19 at 11:18 +0100, Rui Miguel Silva wrote:
>> Some sensors can only output 10 bit bayer formats, like the 
>> OV2680. Add support
>> for that in imx-media.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> ---
>>  drivers/staging/media/imx/imx-media-utils.c | 24 
>>  +++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>> 
>> diff --git a/drivers/staging/media/imx/imx-media-utils.c 
>> b/drivers/staging/media/imx/imx-media-utils.c
>> index fab98fc0d6a0..99527daba29a 100644
>> --- a/drivers/staging/media/imx/imx-media-utils.c
>> +++ b/drivers/staging/media/imx/imx-media-utils.c
>> @@ -118,6 +118,30 @@ static const struct imx_media_pixfmt 
>> rgb_formats[] = {
>>  		.cs     = IPUV3_COLORSPACE_RGB,
>>  		.bpp    = 8,
>>  		.bayer  = true,
>> +	}, {
>> +		.fourcc = V4L2_PIX_FMT_SBGGR10,
>> +		.codes  = {MEDIA_BUS_FMT_SBGGR10_1X10},
>> +		.cs     = IPUV3_COLORSPACE_RGB,
>> +		.bpp    = 16,
>> +		.bayer  = true,
>> +	}, {
>> +		.fourcc = V4L2_PIX_FMT_SGBRG10,
>> +		.codes  = {MEDIA_BUS_FMT_SGBRG10_1X10},
>> +		.cs     = IPUV3_COLORSPACE_RGB,
>> +		.bpp    = 16,
>> +		.bayer  = true,
>> +	}, {
>> +		.fourcc = V4L2_PIX_FMT_SGRBG10,
>> +		.codes  = {MEDIA_BUS_FMT_SGRBG10_1X10},
>> +		.cs     = IPUV3_COLORSPACE_RGB,
>> +		.bpp    = 16,
>> +		.bayer  = true,
>> +	}, {
>> +		.fourcc = V4L2_PIX_FMT_SRGGB10,
>> +		.codes  = {MEDIA_BUS_FMT_SRGGB10_1X10},
>> +		.cs     = IPUV3_COLORSPACE_RGB,
>> +		.bpp    = 16,
>> +		.bayer  = true,
>
> This will break 10-bit bayer formats on i.MX6, which currently 
> stores
> them in memory expanded to 16-bit, as listed in the entries 
> below:

Oh, I see... i.MX7 also store it expanded, I will change my code 
to use
the format array as it is for i.MX6.

Thanks,
---
Cheers,
	Rui
