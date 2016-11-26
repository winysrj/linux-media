Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35926 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751192AbcKZOAe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Nov 2016 09:00:34 -0500
Received: by mail-io0-f196.google.com with SMTP id k19so14250463iod.3
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2016 06:00:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAEAJfCMaaJbsJrx-hJfGnrx2K-sASOG7FCwACF0KbQgrhwE_A@mail.gmail.com>
References: <20161028085224.GA9826@arch-desktop> <CAAEAJfCMaaJbsJrx-hJfGnrx2K-sASOG7FCwACF0KbQgrhwE_A@mail.gmail.com>
From: Marcel Hasler <mahasler@gmail.com>
Date: Sat, 26 Nov 2016 14:59:53 +0100
Message-ID: <CAOJOY2OA+3RBkR+JEvOmUtePanw7k8UXTXU+6MyNzmD7SVDZsw@mail.gmail.com>
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

Of course, since the register dump isn't needed anymore, this function
could also be dropped. But then again, I think it would make sense to
keep it, even if it's just for documentation. There might be use for
it in the future. I'll add a comment as suggested. Let me know whether
I should remove the dump, I guess there's no need to keep it. I'll
then prepare a new patchset with all four patches as soon as I can.

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

Best regards
Marcel
