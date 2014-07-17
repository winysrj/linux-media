Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32920 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbaGQVq2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 17:46:28 -0400
Message-ID: <53C84432.7050100@iki.fi>
Date: Fri, 18 Jul 2014 00:46:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Luis Alves <ljalvs@gmail.com>, Olli Salonen <olli.salonen@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] si2168: improve scanning performance by setting property
 0301 with a value from Windows driver.
References: <1405622607-27248-1-git-send-email-olli.salonen@iki.fi> <CAGj5WxCBwM3UZ1XW9aUez+nYaB46hxy6+NOWQqwdzFdd9aNq8A@mail.gmail.com>
In-Reply-To: <CAGj5WxCBwM3UZ1XW9aUez+nYaB46hxy6+NOWQqwdzFdd9aNq8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2014 10:09 PM, Luis Alves wrote:
> This would be best done during init and not every time on set_frontend.

I am perfectly fine it is done during set_frontend(), even it is static 
value. There were earlier tons of these 0x14 commands, including that 
one. I removed all that were same as default (command reports back 
existing value when new is set). It happens that Olli's Si2168-A30 chip 
has different default value than Si2168-B40 I have.

init() is perfect place for enabling chip, power-up blocks, start 
clocks, downloading firmware and loading "inittab". That command seems 
to belong tuning process itself.

I will apply that.

regards
Antti


>
> Regards,
> Luis
>
> On Thu, Jul 17, 2014 at 7:43 PM, Olli Salonen <olli.salonen@iki.fi> wrote:
>> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
>> ---
>>   drivers/media/dvb-frontends/si2168.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
>> index 0422925..56811e1 100644
>> --- a/drivers/media/dvb-frontends/si2168.c
>> +++ b/drivers/media/dvb-frontends/si2168.c
>> @@ -313,6 +313,13 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
>>          if (ret)
>>                  goto err;
>>
>> +       memcpy(cmd.args, "\x14\x00\x01\x03\x0c\x00", 6);
>> +       cmd.wlen = 6;
>> +       cmd.rlen = 4;
>> +       ret = si2168_cmd_execute(s, &cmd);
>> +       if (ret)
>> +               goto err;
>> +
>>          memcpy(cmd.args, "\x85", 1);
>>          cmd.wlen = 1;
>>          cmd.rlen = 1;
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
http://palosaari.fi/
