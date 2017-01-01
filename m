Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f181.google.com ([209.85.210.181]:34410 "EHLO
        mail-wj0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932128AbdAAQLV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 1 Jan 2017 11:11:21 -0500
Received: by mail-wj0-f181.google.com with SMTP id sd9so225681059wjb.1
        for <linux-media@vger.kernel.org>; Sun, 01 Jan 2017 08:11:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161215221146.GA9398@arch-desktop>
References: <20161215221146.GA9398@arch-desktop>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Sun, 1 Jan 2017 13:11:18 -0300
Message-ID: <CAAEAJfDvN6jQc6wPjaWJ=Nhspsg-wWH7Mz=gcQnRiC52k+j_uQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] stk1160: Let the driver setup the device's
 internal AC97 codec
To: Marcel Hasler <mahasler@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15 December 2016 at 19:11, Marcel Hasler <mahasler@gmail.com> wrote:
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
 to use the internal 8-bit ADC or an external chip, or whether audio is dis=
abled altogether. There's currently no check in place to determine whether =
the device uses AC-link or I2S, but then again I haven't heard of any of th=
ese devices actually using an I2S chip. If the device uses the internal ADC=
 the AC97 setup can be skipped. I implemented the check inside stk1160-ac97=
. It could just as well be in stk1160-core but this way just seemed cleaner=
. If at some point the need arises to check other power-on strap values, it=
 might make sense to refactor this then.
>
> The third patch addresses an issue when reading from the AC97 chip too so=
on, resulting in corrupt data.
>
> Changes from version 3:
> * Removed module param
> * Implemented polling read/write bits
>
> Marcel Hasler (3):
>   stk1160: Remove stk1160-mixer and setup internal AC97 codec automatical=
ly.
>   stk1160: Check whether to use AC97 codec.
>   stk1160: Wait for completion of transfers to and from AC97 codec.
>

For the whole set:

Acked-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>

--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
