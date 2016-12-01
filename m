Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f172.google.com ([209.85.210.172]:33206 "EHLO
        mail-wj0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932933AbcLATtq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2016 14:49:46 -0500
Received: by mail-wj0-f172.google.com with SMTP id xy5so214027960wjc.0
        for <linux-media@vger.kernel.org>; Thu, 01 Dec 2016 11:49:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161127110732.GA5338@arch-desktop>
References: <20161127110732.GA5338@arch-desktop>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Thu, 1 Dec 2016 16:49:43 -0300
Message-ID: <CAAEAJfBxxUNZPnpUvfO63bDBD8pY7Tjh6-9JPZ-Tmu8yypm3cg@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] stk1160: Let the driver setup the device's
 internal AC97 codec
To: Marcel Hasler <mahasler@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27 November 2016 at 08:07, Marcel Hasler <mahasler@gmail.com> wrote:
> This patchset is a result of my attempt to fix a bug (https://bugzilla.ke=
rnel.org/show_bug.cgi?id=3D180071) that eventually turned out to be caused =
by a missing quirk in snd-usb-audio. My idea was to remove the AC97 interfa=
ce and setup the codec using the same values and in the same order as the W=
indows driver does, hoping there might be some "magic" sequence that would =
make the sound work the way it should. Although this didn't help to fix the=
 problem, I found these changes to be useful nevertheless.
>
> IMHO, having all of the AC97 codec's channels exposed to userspace is con=
fusing since most of them have no meaning for this device anyway. Changing =
these values in alsamixer has either no effect at all or may even reduce th=
e sound quality since it can actually increase the line-in DC offset (sligh=
tly).
>
> In addition, having to re-select the correct capture channel everytime th=
e device has been plugged in is annoying. At least on my systems the mixer =
setup is only saved if the device is plugged in during shutdown/reboot. I a=
lso get error messages in my kernel log when I unplug the device because so=
me process (probably the AC97 driver) ist trying to read from the device af=
ter it has been removed. Either way the device should work out-of-the-box w=
ithout the need for the user to manually setup channels.
>
> The first patch in the set therefore removes the 'stk1160-mixer' and lets=
 the driver setup the AC97 codec using the same values as the Windows drive=
r. Although some of the values seem to be defaults I let the driver set the=
m either way, just to be sure.
>
> The second patch adds a check to determine whether the device is strapped=
 to use the internal 8-bit ADC or an external chip. There's currently no ch=
eck in place to determine whether the device uses AC-link or I2S, but then =
again I haven't heard of any of these devices actually using an I2S chip. I=
f the device uses the internal ADC the AC97 setup can be skipped. I impleme=
nted the check inside stk1160-ac97. It could just as well be in stk1160-cor=
e but this way just seemed cleaner. If at some point the need arises to che=
ck other power-on strap values, it might make sense to refactor this then.
>
> The third patch adds a new module parameter for setting the record gain m=
anually since the AC97 chip is no longer exposed to userspace. The Windows =
driver doesn't allow this value to be changed but instead always sets it to=
 8 (of 15). While this should be fine for most users, some may prefer somet=
hing higher.
>
> The fourth patch addresses an issue when reading from the AC97 chip too s=
oon, resulting in corrupt data.
>
> Changes from version 2:
> * Added copyright notice
> * Added defines for POSVA bytes and bits
> * Added check for ACDOUT bit to determine whether audio is disabled compl=
etely
> * Removed info output for gain setting
> * Added fourth patch which had been submitted independently before
> * Expanded comment on AC97 read delay
>
> Marcel Hasler (4):
>   stk1160: Remove stk1160-mixer and setup internal AC97 codec automatical=
ly.
>   stk1160: Check whether to use AC97 codec.
>   stk1160: Add module param for setting the record gain.
>   stk1160: Give the chip some time to retrieve data from AC97 codec.
>

For the whole set:

Acked-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>

--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
