Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36766 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751192AbcKZNxW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Nov 2016 08:53:22 -0500
Received: by mail-io0-f196.google.com with SMTP id k19so14229813iod.3
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2016 05:53:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAEAJfAiK+MmT7dY-eGV2QwL6voLzBnMhrjVy=au5zT83JtjqA@mail.gmail.com>
References: <cover.1477592284.git.mahasler@gmail.com> <20161027203515.GA847@arch-desktop>
 <CAAEAJfAiK+MmT7dY-eGV2QwL6voLzBnMhrjVy=au5zT83JtjqA@mail.gmail.com>
From: Marcel Hasler <mahasler@gmail.com>
Date: Sat, 26 Nov 2016 14:52:40 +0100
Message-ID: <CAOJOY2OBcdhf+CKuP9wQQ9FiyHCmCUL5ugCTqmF7gyGJ9hd5TA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] stk1160: Add module param for setting the record gain.
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-11-20 18:36 GMT+01:00 Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>:
> On 27 October 2016 at 17:35, Marcel Hasler <mahasler@gmail.com> wrote:
>> Allow setting a custom record gain for the internal AC97 codec (if avail=
able). This can be
>> a value between 0 and 15, 8 is the default and should be suitable for mo=
st users. The Windows
>> driver also sets this to 8 without any possibility for changing it.
>>
>> Signed-off-by: Marcel Hasler <mahasler@gmail.com>
>> ---
>>  drivers/media/usb/stk1160/stk1160-ac97.c | 11 ++++++++++-
>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/us=
b/stk1160/stk1160-ac97.c
>> index 6dbc39f..31bdd60d 100644
>> --- a/drivers/media/usb/stk1160/stk1160-ac97.c
>> +++ b/drivers/media/usb/stk1160/stk1160-ac97.c
>> @@ -25,6 +25,11 @@
>>  #include "stk1160.h"
>>  #include "stk1160-reg.h"
>>
>> +static u8 gain =3D 8;
>> +
>> +module_param(gain, byte, 0444);
>> +MODULE_PARM_DESC(gain, "Set capture gain level if AC97 codec is availab=
le (0-15, default: 8)");
>> +
>>  static void stk1160_write_ac97(struct stk1160 *dev, u16 reg, u16 value)
>>  {
>>         /* Set codec register address */
>> @@ -122,7 +127,11 @@ void stk1160_ac97_setup(struct stk1160 *dev)
>>         stk1160_write_ac97(dev, 0x16, 0x0808); /* Aux volume */
>>         stk1160_write_ac97(dev, 0x1a, 0x0404); /* Record select */
>>         stk1160_write_ac97(dev, 0x02, 0x0000); /* Master volume */
>> -       stk1160_write_ac97(dev, 0x1c, 0x0808); /* Record gain */
>> +
>> +       /* Record gain */
>> +       gain =3D (gain > 15) ? 15 : gain;
>> +       stk1160_info("Setting capture gain to %d.", gain);
>
> This message doesn't add anything useful, can we drop it?
>

I think it would make sense to have some kind of feedback, at least
when the default value has been overridden. How about making this
conditional?

>> +       stk1160_write_ac97(dev, 0x1c, (gain<<8) | gain);
>>
>>  #ifdef DEBUG
>>         stk1160_ac97_dump_regs(dev);
>> --
>> 2.10.1
>>
>
>
>
> --
> Ezequiel Garc=C3=ADa, VanguardiaSur
> www.vanguardiasur.com.ar
