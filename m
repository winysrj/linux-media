Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f173.google.com ([209.85.210.173]:34228 "EHLO
        mail-wj0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbcKZPJ4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Nov 2016 10:09:56 -0500
Received: by mail-wj0-f173.google.com with SMTP id mp19so80506704wjc.1
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2016 07:08:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOJOY2OBcdhf+CKuP9wQQ9FiyHCmCUL5ugCTqmF7gyGJ9hd5TA@mail.gmail.com>
References: <cover.1477592284.git.mahasler@gmail.com> <20161027203515.GA847@arch-desktop>
 <CAAEAJfAiK+MmT7dY-eGV2QwL6voLzBnMhrjVy=au5zT83JtjqA@mail.gmail.com> <CAOJOY2OBcdhf+CKuP9wQQ9FiyHCmCUL5ugCTqmF7gyGJ9hd5TA@mail.gmail.com>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Sat, 26 Nov 2016 12:08:45 -0300
Message-ID: <CAAEAJfCfT3MrneZosWBvd5AFatMUBqcKo088YmCMN9oKPhsfVw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] stk1160: Add module param for setting the record gain.
To: Marcel Hasler <mahasler@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26 November 2016 at 10:52, Marcel Hasler <mahasler@gmail.com> wrote:
> 2016-11-20 18:36 GMT+01:00 Ezequiel Garcia <ezequiel@vanguardiasur.com.ar=
>:
>> On 27 October 2016 at 17:35, Marcel Hasler <mahasler@gmail.com> wrote:
>>> Allow setting a custom record gain for the internal AC97 codec (if avai=
lable). This can be
>>> a value between 0 and 15, 8 is the default and should be suitable for m=
ost users. The Windows
>>> driver also sets this to 8 without any possibility for changing it.
>>>
>>> Signed-off-by: Marcel Hasler <mahasler@gmail.com>
>>> ---
>>>  drivers/media/usb/stk1160/stk1160-ac97.c | 11 ++++++++++-
>>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/u=
sb/stk1160/stk1160-ac97.c
>>> index 6dbc39f..31bdd60d 100644
>>> --- a/drivers/media/usb/stk1160/stk1160-ac97.c
>>> +++ b/drivers/media/usb/stk1160/stk1160-ac97.c
>>> @@ -25,6 +25,11 @@
>>>  #include "stk1160.h"
>>>  #include "stk1160-reg.h"
>>>
>>> +static u8 gain =3D 8;
>>> +
>>> +module_param(gain, byte, 0444);
>>> +MODULE_PARM_DESC(gain, "Set capture gain level if AC97 codec is availa=
ble (0-15, default: 8)");
>>> +
>>>  static void stk1160_write_ac97(struct stk1160 *dev, u16 reg, u16 value=
)
>>>  {
>>>         /* Set codec register address */
>>> @@ -122,7 +127,11 @@ void stk1160_ac97_setup(struct stk1160 *dev)
>>>         stk1160_write_ac97(dev, 0x16, 0x0808); /* Aux volume */
>>>         stk1160_write_ac97(dev, 0x1a, 0x0404); /* Record select */
>>>         stk1160_write_ac97(dev, 0x02, 0x0000); /* Master volume */
>>> -       stk1160_write_ac97(dev, 0x1c, 0x0808); /* Record gain */
>>> +
>>> +       /* Record gain */
>>> +       gain =3D (gain > 15) ? 15 : gain;
>>> +       stk1160_info("Setting capture gain to %d.", gain);
>>
>> This message doesn't add anything useful, can we drop it?
>>
>
> I think it would make sense to have some kind of feedback, at least
> when the default value has been overridden. How about making this
> conditional?
>

Well, if the user passes a gain, requesting a non-default value, it is
expected that the gain be set by the driver. So printing a message
for something that is just as expected as "the driver will set the
parameter you told him to set".

User messages should only be printed when *unexpected* or otherwise
relevant events happen.
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
