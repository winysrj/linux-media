Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35506 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbcLCUlx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Dec 2016 15:41:53 -0500
Received: by mail-wm0-f42.google.com with SMTP id a197so46884908wmd.0
        for <linux-media@vger.kernel.org>; Sat, 03 Dec 2016 12:41:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161202090948.0efd0678@vento.lan>
References: <20161127110732.GA5338@arch-desktop> <20161127111236.GA1691@arch-desktop>
 <20161202090948.0efd0678@vento.lan>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Sat, 3 Dec 2016 17:41:37 -0300
Message-ID: <CAAEAJfBf53+eUS2EqSkYTokKFPKQrZRu=O4yLZwG0hpSpFreiQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] stk1160: Give the chip some time to retrieve data
 from AC97 codec.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Marcel Hasler <mahasler@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2 December 2016 at 08:09, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Sun, 27 Nov 2016 12:12:36 +0100
> Marcel Hasler <mahasler@gmail.com> escreveu:
>
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
>>  drivers/media/usb/stk1160/stk1160-ac97.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/us=
b/stk1160/stk1160-ac97.c
>> index 60327af..b39f51b 100644
>> --- a/drivers/media/usb/stk1160/stk1160-ac97.c
>> +++ b/drivers/media/usb/stk1160/stk1160-ac97.c
>> @@ -23,6 +23,7 @@
>>   *
>>   */
>>
>> +#include <linux/delay.h>
>>  #include <linux/module.h>
>>
>>  #include "stk1160.h"
>> @@ -64,6 +65,14 @@ static u16 stk1160_read_ac97(struct stk1160 *dev, u16=
 reg)
>>        */
>>       stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8b);
>>
>> +     /*
>> +      * Give the chip some time to transfer the data.
>> +      * The proper way would be to poll STK1160_AC97CTL_0
>> +      * until the command bit has been cleared, but this
>> +      * may not be worth the hassle.
>
> Why not? Relying on a fixed amount time is not nice.
>
> Take a look at em28xx_is_ac97_ready() function, at
> drivers/media/usb/em28xx/em28xx-core.c to see how this could be
> implemented instead.
>

We were reluctant to implement this properly because the read reg
function is only used for debugging purposes, to dump registers.

That said, it's not too much of a hassle to do it properly, and
we might have to if we are going to have our own mixer.

>
>> +      */
>> +     usleep_range(20, 40);
>> +
>
>>       /* Retrieve register value */
>>       stk1160_read_reg(dev, STK1160_AC97_CMD, &vall);
>>       stk1160_read_reg(dev, STK1160_AC97_CMD + 1, &valh);
>
>
>
> Thanks,
> Mauro



--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
