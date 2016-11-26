Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34573 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751218AbcKZOHo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Nov 2016 09:07:44 -0500
Received: by mail-io0-f196.google.com with SMTP id r94so14284009ioe.1
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2016 06:07:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAEAJfCMaaJbsJrx-hJfGnrx2K-sASOG7FCwACF0KbQgrhwE_A@mail.gmail.com>
References: <20161028085224.GA9826@arch-desktop> <CAAEAJfCMaaJbsJrx-hJfGnrx2K-sASOG7FCwACF0KbQgrhwE_A@mail.gmail.com>
From: Marcel Hasler <mahasler@gmail.com>
Date: Sat, 26 Nov 2016 15:07:03 +0100
Message-ID: <CAOJOY2Mc-4ZJOJu4QfYXQxwj=ubwm4M4Hr=YK3JYuCrxriM7Rg@mail.gmail.com>
Subject: Re: [PATCH] stk1160: Give the chip some time to retrieve data from
 AC97 codec.
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-11-20 18:37 GMT+01:00 Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>:
> On 28 October 2016 at 05:52, Marcel Hasler <mahasler@gmail.com> wrote:
>> The STK1160 needs some time to transfer data from the AC97 registers int=
o its own. On some
>> systems reading the chip's own registers to soon will return wrong value=
s. The "proper" way to
>> handle this would be to poll STK1160_AC97CTL_0 after every read or write=
 command until the
>> command bit has been cleared, but this may not be worth the hassle.
>>
>> Signed-off-by: Marcel Hasler <mahasler@gmail.com>
>> ---
>>  drivers/media/usb/stk1160/stk1160-ac97.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/us=
b/stk1160/stk1160-ac97.c
>> index 31bdd60d..caa65a8 100644
>> --- a/drivers/media/usb/stk1160/stk1160-ac97.c
>> +++ b/drivers/media/usb/stk1160/stk1160-ac97.c
>> @@ -20,6 +20,7 @@
>>   *
>>   */
>>
>> +#include <linux/delay.h>
>>  #include <linux/module.h>
>>
>>  #include "stk1160.h"
>> @@ -61,6 +62,9 @@ static u16 stk1160_read_ac97(struct stk1160 *dev, u16 =
reg)
>>          */
>>         stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8b);
>>
>> +       /* Give the chip some time to transfer data */
>> +       usleep_range(20, 40);
>> +
>
> I don't recall any issues with this. In any case, we only read the regist=
ers
> for debugging purposes, so it's not a big deal.
>

I actually just re-tested this, as I recently replaced my computer's
main board. I didn't happen with my old one, but it does with my new
one, just as with both of my notebooks.

> Maybe it would be better to expand the comment a little bit,
> using your commit log:
>
> ""
> The "proper" way to
> handle this would be to poll STK1160_AC97CTL_0 after
> every read or write command until the command bit
> has been cleared, but this may not be worth the hassle.
> ""
>
> This way, if the sleep proves problematic in the future,
> the "proper way" is already documented.
>
>>         /* Retrieve register value */
>>         stk1160_read_reg(dev, STK1160_AC97_CMD, &vall);
>>         stk1160_read_reg(dev, STK1160_AC97_CMD + 1, &valh);
>> --
>> 2.10.1
>>
>
>
>
> --
> Ezequiel Garc=C3=ADa, VanguardiaSur
> www.vanguardiasur.com.ar
