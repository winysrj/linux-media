Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35939 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752710AbeDSOC0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 10:02:26 -0400
Received: by mail-wr0-f196.google.com with SMTP id q13-v6so14400898wre.3
        for <linux-media@vger.kernel.org>; Thu, 19 Apr 2018 07:02:25 -0700 (PDT)
References: <20180419101812.30688-1-rui.silva@linaro.org> <20180419101812.30688-2-rui.silva@linaro.org> <20180419120606.p32pl5at7wky7u3y@mwanda>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH 01/15] media: staging/imx: add support to media dev for no IPU systems
In-reply-to: <20180419120606.p32pl5at7wky7u3y@mwanda>
Date: Thu, 19 Apr 2018 15:02:21 +0100
Message-ID: <m3k1t39tw2.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,
Thanks for this and the other reviews.

On Thu 19 Apr 2018 at 12:06, Dan Carpenter wrote:
> On Thu, Apr 19, 2018 at 11:17:58AM +0100, Rui Miguel Silva 
> wrote:
>> Some i.MX SoC do not have IPU, like the i.MX7, add to the the 
>> media device
>> infrastructure support to be used in this type of systems that 
>> do not have
>> internal subdevices besides the CSI.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> ---
>>  drivers/staging/media/imx/imx-media-dev.c        | 16 
>>  +++++++++++-----
>>  .../staging/media/imx/imx-media-internal-sd.c    |  3 +++
>>  drivers/staging/media/imx/imx-media.h            |  3 +++
>>  3 files changed, 17 insertions(+), 5 deletions(-)
>> 
>> diff --git a/drivers/staging/media/imx/imx-media-dev.c 
>> b/drivers/staging/media/imx/imx-media-dev.c
>> index f67ec8e27093..a8afe0ec4134 100644
>> --- a/drivers/staging/media/imx/imx-media-dev.c
>> +++ b/drivers/staging/media/imx/imx-media-dev.c
>> @@ -92,6 +92,9 @@ static int imx_media_get_ipu(struct 
>> imx_media_dev *imxmd,
>>  	struct ipu_soc *ipu;
>>  	int ipu_id;
>>  
>> +	if (imxmd->no_ipu_present)
>
> It's sort of nicer if variables don't have a negative built in 
> because
> otherwise you get confusing double negatives like "if (!no_ipu) 
> {".
> It's not hard to invert the varible in this case, because the 
> only thing
> we need to change is imx_media_probe() to set:
>
> +	imxmd->ipu_present = true;

Yeah, my code was like this till last minute, and I also dislike 
the
double negatives... but since the logic that reset the variable 
would
only be done in a later patch I switched the logic.

But You are right I could just had the initialization here to 
true.
Will take this in account in v2.

---
Cheers,
	Rui
