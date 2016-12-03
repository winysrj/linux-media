Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36430 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbcLCUqb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Dec 2016 15:46:31 -0500
Received: by mail-wm0-f48.google.com with SMTP id g23so46957715wme.1
        for <linux-media@vger.kernel.org>; Sat, 03 Dec 2016 12:46:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161202090558.29931492@vento.lan>
References: <20161127110732.GA5338@arch-desktop> <20161127111148.GA30483@arch-desktop>
 <20161202090558.29931492@vento.lan>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Sat, 3 Dec 2016 17:46:29 -0300
Message-ID: <CAAEAJfCmQnQHWy+7kS4wuuBK7mubiKRpiDYCm9BHYjVR4yHGgA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] stk1160: Add module param for setting the record gain.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Marcel Hasler <mahasler@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2 December 2016 at 08:05, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Sun, 27 Nov 2016 12:11:48 +0100
> Marcel Hasler <mahasler@gmail.com> escreveu:
>
>> Allow setting a custom record gain for the internal AC97 codec (if avail=
able). This can be
>> a value between 0 and 15, 8 is the default and should be suitable for mo=
st users. The Windows
>> driver also sets this to 8 without any possibility for changing it.
>
> The problem of removing the mixer is that you need this kind of
> crap to setup the volumes on a non-standard way.
>

Right, that's a good point.

> NACK.
>
> Instead, keep the alsa mixer. The way other drivers do (for example,
> em28xx) is that they configure the mixer when an input is selected,
> increasing the volume of the active audio channel to 100% and muting
> the other audio channels. Yet, as the alsa mixer is exported, users
> can change the mixer settings in runtime using some alsa (or pa)
> mixer application.
>

Yeah, the AC97 mixer we are currently leveraging
exposes many controls that have no meaning in this device,
so removing that still looks like an improvement.

I guess the proper way is creating our own mixer
(not using snd_ac97_mixer)  exposing only the record
gain knob.

Marcel, what do you think?
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
