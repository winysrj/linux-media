Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40319 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaHNFWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 01:22:40 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so1730463wib.16
        for <linux-media@vger.kernel.org>; Wed, 13 Aug 2014 22:22:38 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 Aug 2014 08:22:38 +0300
Message-ID: <CAAZRmGyJkCcBSsyYHW_dCUCPvM4aKcwy4gPGosLa7zc7m_cTqg@mail.gmail.com>
Subject: Re: [PATCH 2/6] em28xx: add ts mode setting for PCTV 461e
From: Olli Salonen <olli.salonen@iki.fi>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Indeed, the patch is correct, but the description should say:

em28xx: add ts mode setting for PCTV 292e
TS mode must be set in the existing PCTV 292e driver.

Thanks for your reviews!

On 13 August 2014 02:23, Antti Palosaari <crope@iki.fi> wrote:
> Acked-by: Antti Palosaari <crope@iki.fi>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
>
> PCTV 461e is satellite receiver whilst that one should be PCTV 292e. I will
> fix the type, no new patch needed.
>
> Antti
>
>
> On 08/11/2014 10:58 PM, Olli Salonen wrote:
>>
>> TS mode must be set in the existing PCTV 461e driver.
>>
>> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
>> ---
>>   drivers/media/usb/em28xx/em28xx-dvb.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c
>> b/drivers/media/usb/em28xx/em28xx-dvb.c
>> index d8e9760..0645793 100644
>> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
>> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
>> @@ -1535,6 +1535,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
>>                         /* attach demod */
>>                         si2168_config.i2c_adapter = &adapter;
>>                         si2168_config.fe = &dvb->fe[0];
>> +                       si2168_config.ts_mode = SI2168_TS_PARALLEL;
>>                         memset(&info, 0, sizeof(struct i2c_board_info));
>>                         strlcpy(info.type, "si2168", I2C_NAME_SIZE);
>>                         info.addr = 0x64;
>>
>
> --
> http://palosaari.fi/
