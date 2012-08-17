Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54286 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2HQEra (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 00:47:30 -0400
Received: by qaas11 with SMTP id s11so1261546qaa.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 21:47:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120816165656.GB29636@valkosipuli.retiisi.org.uk>
References: <1345116570-27335-1-git-send-email-sachin.kamat@linaro.org>
	<20120816165656.GB29636@valkosipuli.retiisi.org.uk>
Date: Fri, 17 Aug 2012 10:17:29 +0530
Message-ID: <CAK9yfHwT-2Y2=YjCAYFkRcp_+B93s2YiuhV0o8FjP+P5hv=w_w@mail.gmail.com>
Subject: Re: [PATCH] smiapp: Use devm_kzalloc() in smiapp-core.c file
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for reviewing the patch.

On 16 August 2012 22:26, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Sachin,
>
> Thanks for the patch.
>
> On Thu, Aug 16, 2012 at 04:59:30PM +0530, Sachin Kamat wrote:
>> devm_kzalloc is a device managed function and makes code a bit
>> smaller and cleaner.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>> This patch is based on Mauro's re-organized tree
>> (media_tree staging/for_v3.7) and is compile tested.
>> ---
>>  drivers/media/i2c/smiapp/smiapp-core.c |   11 ++---------
>>  1 files changed, 2 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
>> index 1cf914d..7d4280e 100644
>> --- a/drivers/media/i2c/smiapp/smiapp-core.c
>> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
>> @@ -2801,12 +2801,11 @@ static int smiapp_probe(struct i2c_client *client,
>>                       const struct i2c_device_id *devid)
>>  {
>>       struct smiapp_sensor *sensor;
>> -     int rval;
>>
>>       if (client->dev.platform_data == NULL)
>>               return -ENODEV;
>>
>> -     sensor = kzalloc(sizeof(*sensor), GFP_KERNEL);
>> +     sensor = devm_kzalloc(&client->dev, sizeof(*sensor), GFP_KERNEL);
>>       if (sensor == NULL)
>>               return -ENOMEM;
>>
>
> I think the same should be done to sensor->nvm. Would you like to change the
> patch to incorporate the change? I'm fine doing that as well.

Sure. I will send the updated patch shortly. I have also expanded the
scope of the patch to
use other devm_* functions too.

>
> Cheers,
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     jabber/XMPP/Gmail: sailus@retiisi.org.uk



-- 
With warm regards,
Sachin
