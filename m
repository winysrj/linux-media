Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63764 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab3JDPfC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 11:35:02 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so4330493pad.9
        for <linux-media@vger.kernel.org>; Fri, 04 Oct 2013 08:35:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <524ED27F.2010803@iki.fi>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
	<1380895312-30863-6-git-send-email-hverkuil@xs4all.nl>
	<524ED27F.2010803@iki.fi>
Date: Fri, 4 Oct 2013 11:35:01 -0400
Message-ID: <CAOcJUbycPvr-Ts2xHMAaWO8nZvnaNfLbUOZZwEVhzQzYA3nU8w@mail.gmail.com>
Subject: Re: [PATCH 05/14] cxd2820r_core: fix sparse warnings
From: Michael Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 4, 2013 at 10:36 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 04.10.2013 17:01, Hans Verkuil wrote:
>>
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> drivers/media/dvb-frontends/cxd2820r_core.c:34:32: error: cannot size
>> expression
>> drivers/media/dvb-frontends/cxd2820r_core.c:68:32: error: cannot size
>> expression
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>
>
> Acked-by: Antti Palosaari <crope@iki.fi>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
>
>
>
>> Cc: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/dvb-frontends/cxd2820r_core.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c
>> b/drivers/media/dvb-frontends/cxd2820r_core.c
>> index 7ca5c69..d9eeeb1 100644
>> --- a/drivers/media/dvb-frontends/cxd2820r_core.c
>> +++ b/drivers/media/dvb-frontends/cxd2820r_core.c
>> @@ -31,7 +31,7 @@ static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv
>> *priv, u8 i2c, u8 reg,
>>                 {
>>                         .addr = i2c,
>>                         .flags = 0,
>> -                       .len = sizeof(buf),
>> +                       .len = len + 1,
>>                         .buf = buf,
>>                 }
>>         };
>> @@ -65,7 +65,7 @@ static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv
>> *priv, u8 i2c, u8 reg,
>>                 }, {
>>                         .addr = i2c,
>>                         .flags = I2C_M_RD,
>> -                       .len = sizeof(buf),
>> +                       .len = len,
>>                         .buf = buf,
>>                 }
>>         };
>>
>
>
> --
> http://palosaari.fi/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
