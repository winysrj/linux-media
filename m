Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35814 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbcLDNCj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Dec 2016 08:02:39 -0500
Received: by mail-io0-f195.google.com with SMTP id h133so9052310ioe.2
        for <linux-media@vger.kernel.org>; Sun, 04 Dec 2016 05:02:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAEAJfCmQnQHWy+7kS4wuuBK7mubiKRpiDYCm9BHYjVR4yHGgA@mail.gmail.com>
References: <20161127110732.GA5338@arch-desktop> <20161127111148.GA30483@arch-desktop>
 <20161202090558.29931492@vento.lan> <CAAEAJfCmQnQHWy+7kS4wuuBK7mubiKRpiDYCm9BHYjVR4yHGgA@mail.gmail.com>
From: Marcel Hasler <mahasler@gmail.com>
Date: Sun, 4 Dec 2016 14:01:57 +0100
Message-ID: <CAOJOY2Nhi6aev=jwVeyuQMxKUAk-MfT0YLKsFfrUsAcZtdrysQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] stk1160: Add module param for setting the record gain.
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

2016-12-03 21:46 GMT+01:00 Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>:
> On 2 December 2016 at 08:05, Mauro Carvalho Chehab
> <mchehab@s-opensource.com> wrote:
>> Em Sun, 27 Nov 2016 12:11:48 +0100
>> Marcel Hasler <mahasler@gmail.com> escreveu:
>>
>>> Allow setting a custom record gain for the internal AC97 codec (if avai=
lable). This can be
>>> a value between 0 and 15, 8 is the default and should be suitable for m=
ost users. The Windows
>>> driver also sets this to 8 without any possibility for changing it.
>>
>> The problem of removing the mixer is that you need this kind of
>> crap to setup the volumes on a non-standard way.
>>
>
> Right, that's a good point.
>
>> NACK.
>>
>> Instead, keep the alsa mixer. The way other drivers do (for example,
>> em28xx) is that they configure the mixer when an input is selected,
>> increasing the volume of the active audio channel to 100% and muting
>> the other audio channels. Yet, as the alsa mixer is exported, users
>> can change the mixer settings in runtime using some alsa (or pa)
>> mixer application.
>>
>
> Yeah, the AC97 mixer we are currently leveraging
> exposes many controls that have no meaning in this device,
> so removing that still looks like an improvement.
>
> I guess the proper way is creating our own mixer
> (not using snd_ac97_mixer)  exposing only the record
> gain knob.
>
> Marcel, what do you think?
> --
> Ezequiel Garc=C3=ADa, VanguardiaSur
> www.vanguardiasur.com.ar

As I have written before, the recording gain isn't actually meant to
be changed by the user. In the official Windows driver this value is
hard-coded to 8 and cannot be changed in any way. And there really is
no good reason why anyone should need to mess with it in the first
place. The default value will give the best results in pretty much all
cases and produces approximately the same volume as the internal 8-bit
ADC whose gain cannot be changed at all, not even by a driver.

I had considered writing a mixer but chose not to. If the gain setting
is openly exposed to mixer applications, how do you tell the users
that the value set by the driver already is the optimal and
recommended value and that they shouldn't mess with the controls
unless they really have to? By having a module parameter, this setting
is practically hidden from the normal user but still is available to
power-users if they think they really need it. In the end it's really
just a compromise between hiding it completely and exposing it openly.
Also, this way the driver guarantees reproducible results, since
there's no need to remember the positions of any volume sliders.

Either way, if you still think this solution is "crap", feel free to
modify the patches in any way you see fit. I've wasted too much time
on this already, and since I'm not being paid for it, I don't intend
to put any more effort into this.

Best regards
Marcel
