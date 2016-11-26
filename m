Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38512 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbcKZPEh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Nov 2016 10:04:37 -0500
Received: by mail-wm0-f50.google.com with SMTP id f82so115793699wmf.1
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2016 07:04:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOJOY2MnWdBfXYeKyi_-yTZuTCohtT25T284Lk-JGE5Qe24HOQ@mail.gmail.com>
References: <cover.1477592284.git.mahasler@gmail.com> <20161027203434.GA31859@arch-desktop>
 <CAAEAJfDe256zcu+=CCSAZNWPEEH3Hd_Vp-VakQfgbF1yra0BPQ@mail.gmail.com> <CAOJOY2MnWdBfXYeKyi_-yTZuTCohtT25T284Lk-JGE5Qe24HOQ@mail.gmail.com>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Sat, 26 Nov 2016 12:04:28 -0300
Message-ID: <CAAEAJfA5cJWgC23xMaX7xpyFnaR6gaZXh-MLdMM8CA32db9c4Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] stk1160: Remove stk1160-mixer and setup internal
 AC97 codec automatically.
To: Marcel Hasler <mahasler@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26 November 2016 at 10:38, Marcel Hasler <mahasler@gmail.com> wrote:
> Hello, and thanks for your feedback.
>
> 2016-11-20 18:36 GMT+01:00 Ezequiel Garcia <ezequiel@vanguardiasur.com.ar=
>:
>> Marcel,
>>
>> On 27 October 2016 at 17:34, Marcel Hasler <mahasler@gmail.com> wrote:
>>> Exposing all the channels of the device's internal AC97 codec to usersp=
ace is unnecessary and
>>> confusing. Instead the driver should setup the codec with proper values=
. This patch removes the
>>> mixer and sets up the codec using optimal values, i.e. the same values =
set by the Windows
>>> driver. This also makes the device work out-of-the-box, without the nee=
d for the user to
>>> reconfigure the device every time it's plugged in.
>>>
>>> Signed-off-by: Marcel Hasler <mahasler@gmail.com>
>>
>> This patch is *awesome*.
>>
>> You've re-written the file ;-), so if you want to put your
>> copyright on stk1160-ac97.c, be my guest.
>>
>
> Thanks, will do :-)
>
>> Also, just a minor comment, see below.
>>
>>> ---
>>>  drivers/media/usb/stk1160/Kconfig        |  10 +--
>>>  drivers/media/usb/stk1160/Makefile       |   4 +-
>>>  drivers/media/usb/stk1160/stk1160-ac97.c | 121 +++++++++++------------=
--------
>>>  drivers/media/usb/stk1160/stk1160-core.c |   5 +-
>>>  drivers/media/usb/stk1160/stk1160.h      |   9 +--
>>>  5 files changed, 47 insertions(+), 102 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/stk1160/Kconfig b/drivers/media/usb/stk1=
160/Kconfig
>>> index 95584c1..22dff4f 100644
>>> --- a/drivers/media/usb/stk1160/Kconfig
>>> +++ b/drivers/media/usb/stk1160/Kconfig
>>> @@ -8,17 +8,9 @@ config VIDEO_STK1160_COMMON
>>>           To compile this driver as a module, choose M here: the
>>>           module will be called stk1160
>>>
>>> -config VIDEO_STK1160_AC97
>>> -       bool "STK1160 AC97 codec support"
>>> -       depends on VIDEO_STK1160_COMMON && SND
>>> -
>>> -       ---help---
>>> -         Enables AC97 codec support for stk1160 driver.
>>> -
>>>  config VIDEO_STK1160
>>>         tristate
>>> -       depends on (!VIDEO_STK1160_AC97 || (SND=3D'n') || SND) && VIDEO=
_STK1160_COMMON
>>> +       depends on VIDEO_STK1160_COMMON
>>>         default y
>>>         select VIDEOBUF2_VMALLOC
>>>         select VIDEO_SAA711X
>>> -       select SND_AC97_CODEC if SND
>>> diff --git a/drivers/media/usb/stk1160/Makefile b/drivers/media/usb/stk=
1160/Makefile
>>> index dfe3e90..42d0546 100644
>>> --- a/drivers/media/usb/stk1160/Makefile
>>> +++ b/drivers/media/usb/stk1160/Makefile
>>> @@ -1,10 +1,8 @@
>>> -obj-stk1160-ac97-$(CONFIG_VIDEO_STK1160_AC97) :=3D stk1160-ac97.o
>>> -
>>>  stk1160-y :=3D   stk1160-core.o \
>>>                 stk1160-v4l.o \
>>>                 stk1160-video.o \
>>>                 stk1160-i2c.o \
>>> -               $(obj-stk1160-ac97-y)
>>> +               stk1160-ac97.o
>>>
>>>  obj-$(CONFIG_VIDEO_STK1160) +=3D stk1160.o
>>>
>>> diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/u=
sb/stk1160/stk1160-ac97.c
>>> index 2dd308f..d3665ce 100644
>>> --- a/drivers/media/usb/stk1160/stk1160-ac97.c
>>> +++ b/drivers/media/usb/stk1160/stk1160-ac97.c
>>> @@ -21,19 +21,12 @@
>>>   */
>>>
>>>  #include <linux/module.h>
>>> -#include <sound/core.h>
>>> -#include <sound/initval.h>
>>> -#include <sound/ac97_codec.h>
>>>
>>>  #include "stk1160.h"
>>>  #include "stk1160-reg.h"
>>>
>>> -static struct snd_ac97 *stk1160_ac97;
>>> -
>>> -static void stk1160_write_ac97(struct snd_ac97 *ac97, u16 reg, u16 val=
ue)
>>> +static void stk1160_write_ac97(struct stk1160 *dev, u16 reg, u16 value=
)
>>>  {
>>> -       struct stk1160 *dev =3D ac97->private_data;
>>> -
>>>         /* Set codec register address */
>>>         stk1160_write_reg(dev, STK1160_AC97_ADDR, reg);
>>>
>>> @@ -48,9 +41,9 @@ static void stk1160_write_ac97(struct snd_ac97 *ac97,=
 u16 reg, u16 value)
>>>         stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8c);
>>>  }
>>>
>>> -static u16 stk1160_read_ac97(struct snd_ac97 *ac97, u16 reg)
>>> +#ifdef DEBUG
>>> +static u16 stk1160_read_ac97(struct stk1160 *dev, u16 reg)
>>>  {
>>> -       struct stk1160 *dev =3D ac97->private_data;
>>>         u8 vall =3D 0;
>>>         u8 valh =3D 0;
>>>
>>> @@ -70,81 +63,53 @@ static u16 stk1160_read_ac97(struct snd_ac97 *ac97,=
 u16 reg)
>>>         return (valh << 8) | vall;
>>>  }
>>>
>>> -static void stk1160_reset_ac97(struct snd_ac97 *ac97)
>>> +void stk1160_ac97_dump_regs(struct stk1160 *dev)
>>
>> static void stk1160_ac97_dump_regs ?
>>
>
> Right, this was just to test the issue addressed in the last patch
> that I submitted separately. I didn't know at that point, whether the
> issue was with writing or reading the registers, or both. This can of
> course be removed, since it's not really needed for anything anymore.
>

I'm not opposed to keeping the dump. Remove it if you think
it's useless, or keep it if you think it has debugging value.

I'm fine either way.
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
