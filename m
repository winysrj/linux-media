Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:49701 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaKJPoU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 10:44:20 -0500
Received: by mail-ie0-f172.google.com with SMTP id at20so9521287iec.17
        for <linux-media@vger.kernel.org>; Mon, 10 Nov 2014 07:44:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141110130659.GA8214@valkosipuli.retiisi.org.uk>
References: <CAGU7XX3ODOJ+xRk9GAJi8Wk8bj5LONR7WVFh3ujVM1oL=HBL7g@mail.gmail.com>
	<20141110130659.GA8214@valkosipuli.retiisi.org.uk>
Date: Mon, 10 Nov 2014 17:44:19 +0200
Message-ID: <CAGU7XX3_71aikhWqDeyVvZFSZg6Dpw=pR0scYfQnBuAz=ZbfCA@mail.gmail.com>
Subject: Re: [PATCH 1/1] v4l: omap4iss: Fix dual lane camera mode problem
From: Marina Vasilevsky <marinavasilevsky@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Now I understand that the rate is not correct.
I'll fix it and retest.

Thanks,
Marina

On Mon, Nov 10, 2014 at 3:06 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Marina,
>
> On Mon, Nov 10, 2014 at 10:11:31AM +0200, Marina Vasilevsky wrote:
>> ---
>>  drivers/staging/media/omap4iss/iss_csiphy.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/media/omap4iss/iss_csiphy.c
>> b/drivers/staging/media/omap4iss/iss_csiphy.c
>> index 7c3d55d..b6e0b32 100644
>> --- a/drivers/staging/media/omap4iss/iss_csiphy.c
>> +++ b/drivers/staging/media/omap4iss/iss_csiphy.c
>> @@ -196,8 +196,7 @@ int omap4iss_csiphy_config(struct iss_device *iss,
>>          return -EINVAL;
>>
>>      csi2_ddrclk_khz = pipe->external_rate / 1000
>> -        / (2 * csi2->phy->used_data_lanes)
>> -        * pipe->external_bpp;
>> +        / 2 * pipe->external_bpp;
>>
>>      /*
>>       * THS_TERM: Programmed value = ceil(12.5 ns/DDRClk period) - 1.
>> --
>>
>> Hello,
>>
>> I tested this fix with OMAP4 connected to OV5640 camera using 2 lanes.
>> Have anybody tested other camera with 2 lanes connected to OMAP?
>>
>> The value csi2_ddrclk_khz is different per camera.
>> I have also driver for OV7695. Current iss params structure does not
>> allow to configure it properly from board file.
>
> Are you certain the pixel rate value provided by the sensor driver is
> correct?
>
> The formula in iss_csiphy.c is fine as far as I understand.
>
> --
> Kind regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
