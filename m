Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33357 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751218AbcKZNuj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Nov 2016 08:50:39 -0500
Received: by mail-io0-f195.google.com with SMTP id j92so14305455ioi.0
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2016 05:50:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAEAJfAFxtnRkc9+iZtGSc=vJPGq1Aay6-aBKTD9S3_dLPLZWw@mail.gmail.com>
References: <cover.1477592284.git.mahasler@gmail.com> <20161027203454.GA32566@arch-desktop>
 <CAAEAJfAFxtnRkc9+iZtGSc=vJPGq1Aay6-aBKTD9S3_dLPLZWw@mail.gmail.com>
From: Marcel Hasler <mahasler@gmail.com>
Date: Sat, 26 Nov 2016 14:49:58 +0100
Message-ID: <CAOJOY2NHSeaMk57aAGnvLo7bQrDiLQXF74MeLpG1crXLzqK8=Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] stk1160: Check whether to use AC97 codec or
 internal ADC.
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-11-20 18:36 GMT+01:00 Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>:
> On 27 October 2016 at 17:34, Marcel Hasler <mahasler@gmail.com> wrote:
>> Some STK1160-based devices use the chip's internal 8-bit ADC. This is co=
nfigured through a strap
>> pin. The value of this and other pins can be read through the POSVA regi=
ster. If the internal
>> ADC is used, there's no point trying to setup the unavailable AC97 codec=
.
>>
>> Signed-off-by: Marcel Hasler <mahasler@gmail.com>
>> ---
>>  drivers/media/usb/stk1160/stk1160-ac97.c | 15 +++++++++++++++
>>  drivers/media/usb/stk1160/stk1160-core.c |  3 +--
>>  drivers/media/usb/stk1160/stk1160-reg.h  |  3 +++
>>  3 files changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/us=
b/stk1160/stk1160-ac97.c
>> index d3665ce..6dbc39f 100644
>> --- a/drivers/media/usb/stk1160/stk1160-ac97.c
>> +++ b/drivers/media/usb/stk1160/stk1160-ac97.c
>> @@ -90,8 +90,23 @@ void stk1160_ac97_dump_regs(struct stk1160 *dev)
>>  }
>>  #endif
>>
>> +int stk1160_has_ac97(struct stk1160 *dev)
>> +{
>> +       u8 value;
>> +
>> +       stk1160_read_reg(dev, STK1160_POSVA, &value);
>> +
>> +       /* Bit 2 high means internal ADC */
>> +       return !(value & 0x04);
>
> How about define a macro such as:
>
> diff --git a/drivers/media/usb/stk1160/stk1160-reg.h
> b/drivers/media/usb/stk1160/stk1160-reg.h
> index a4ab586fcee1..4922249d7d34 100644
> --- a/drivers/media/usb/stk1160/stk1160-reg.h
> +++ b/drivers/media/usb/stk1160/stk1160-reg.h
> @@ -28,6 +28,7 @@
>
>  /* Power-on Strapping Data */
>  #define STK1160_POSVA                  0x010
> +#define  STK1160_POSVA_ACSYNC          BIT(2)
>

Good idea, I'll do that.

> Also, the spec mentions another POSVA bit relevant
> to audio ACDOUT. Should we check that too?
>

Yes, that would make sense.

>> +}
>> +
>>  void stk1160_ac97_setup(struct stk1160 *dev)
>>  {
>> +       if (!stk1160_has_ac97(dev)) {
>> +               stk1160_info("Device uses internal 8-bit ADC, skipping A=
C97 setup.");
>> +               return;
>> +       }
>> +
>>         /* Two-step reset AC97 interface and hardware codec */
>>         stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x94);
>>         stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8c);
>> diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/us=
b/stk1160/stk1160-core.c
>> index f3c9b8a..c86eb61 100644
>> --- a/drivers/media/usb/stk1160/stk1160-core.c
>> +++ b/drivers/media/usb/stk1160/stk1160-core.c
>> @@ -20,8 +20,7 @@
>>   *
>>   * TODO:
>>   *
>> - * 1. (Try to) detect if we must register ac97 mixer
>> - * 2. Support stream at lower speed: lower frame rate or lower frame si=
ze.
>> + * 1. Support stream at lower speed: lower frame rate or lower frame si=
ze.
>>   *
>>   */
>>
>> diff --git a/drivers/media/usb/stk1160/stk1160-reg.h b/drivers/media/usb=
/stk1160/stk1160-reg.h
>> index 81ff3a1..a4ab586 100644
>> --- a/drivers/media/usb/stk1160/stk1160-reg.h
>> +++ b/drivers/media/usb/stk1160/stk1160-reg.h
>> @@ -26,6 +26,9 @@
>>  /* Remote Wakup Control */
>>  #define STK1160_RMCTL                  0x00c
>>
>> +/* Power-on Strapping Data */
>> +#define STK1160_POSVA                  0x010
>> +
>>  /*
>>   * Decoder Control Register:
>>   * This byte controls capture start/stop
>> --
>> 2.10.1
>>
>
>
>
> --
> Ezequiel Garc=C3=ADa, VanguardiaSur
> www.vanguardiasur.com.ar
