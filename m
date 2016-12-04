Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37401 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbcLDSZ2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Dec 2016 13:25:28 -0500
Received: by mail-wm0-f53.google.com with SMTP id t79so61833327wmt.0
        for <linux-media@vger.kernel.org>; Sun, 04 Dec 2016 10:25:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOJOY2Nhi6aev=jwVeyuQMxKUAk-MfT0YLKsFfrUsAcZtdrysQ@mail.gmail.com>
References: <20161127110732.GA5338@arch-desktop> <20161127111148.GA30483@arch-desktop>
 <20161202090558.29931492@vento.lan> <CAAEAJfCmQnQHWy+7kS4wuuBK7mubiKRpiDYCm9BHYjVR4yHGgA@mail.gmail.com>
 <CAOJOY2Nhi6aev=jwVeyuQMxKUAk-MfT0YLKsFfrUsAcZtdrysQ@mail.gmail.com>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Sun, 4 Dec 2016 15:25:25 -0300
Message-ID: <CAAEAJfAoZCzh5c=C+8Um-KaZkRs_ip1kX04xZRm2bWrGLmMwjA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] stk1160: Add module param for setting the record gain.
To: Marcel Hasler <mahasler@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4 December 2016 at 10:01, Marcel Hasler <mahasler@gmail.com> wrote:
> Hello
>
> 2016-12-03 21:46 GMT+01:00 Ezequiel Garcia <ezequiel@vanguardiasur.com.ar=
>:
>> On 2 December 2016 at 08:05, Mauro Carvalho Chehab
>> <mchehab@s-opensource.com> wrote:
>>> Em Sun, 27 Nov 2016 12:11:48 +0100
>>> Marcel Hasler <mahasler@gmail.com> escreveu:
>>>
>>>> Allow setting a custom record gain for the internal AC97 codec (if ava=
ilable). This can be
>>>> a value between 0 and 15, 8 is the default and should be suitable for =
most users. The Windows
>>>> driver also sets this to 8 without any possibility for changing it.
>>>
>>> The problem of removing the mixer is that you need this kind of
>>> crap to setup the volumes on a non-standard way.
>>>
>>
>> Right, that's a good point.
>>
>>> NACK.
>>>
>>> Instead, keep the alsa mixer. The way other drivers do (for example,
>>> em28xx) is that they configure the mixer when an input is selected,
>>> increasing the volume of the active audio channel to 100% and muting
>>> the other audio channels. Yet, as the alsa mixer is exported, users
>>> can change the mixer settings in runtime using some alsa (or pa)
>>> mixer application.
>>>
>>
>> Yeah, the AC97 mixer we are currently leveraging
>> exposes many controls that have no meaning in this device,
>> so removing that still looks like an improvement.
>>
>> I guess the proper way is creating our own mixer
>> (not using snd_ac97_mixer)  exposing only the record
>> gain knob.
>>
>> Marcel, what do you think?
>> --
>> Ezequiel Garc=C3=ADa, VanguardiaSur
>> www.vanguardiasur.com.ar
>
> As I have written before, the recording gain isn't actually meant to
> be changed by the user. In the official Windows driver this value is
> hard-coded to 8 and cannot be changed in any way. And there really is
> no good reason why anyone should need to mess with it in the first
> place. The default value will give the best results in pretty much all
> cases and produces approximately the same volume as the internal 8-bit
> ADC whose gain cannot be changed at all, not even by a driver.
>
> I had considered writing a mixer but chose not to. If the gain setting
> is openly exposed to mixer applications, how do you tell the users
> that the value set by the driver already is the optimal and
> recommended value and that they shouldn't mess with the controls
> unless they really have to? By having a module parameter, this setting
> is practically hidden from the normal user but still is available to
> power-users if they think they really need it. In the end it's really
> just a compromise between hiding it completely and exposing it openly.
> Also, this way the driver guarantees reproducible results, since
> there's no need to remember the positions of any volume sliders.
>

Hm, right. I've never changed the record gain, and it's true that it
doens't really improve the volume. So, I would be OK with having
a module parameter.

On the other side, we are exposing it currently, through the "Capture"
mixer control:

Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch cswitch-joined
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 15
  Front Left: Capture 10 [67%] [15.00dB] [on]
  Front Right: Capture 8 [53%] [12.00dB] [on]

So, it would be user-friendly to keep the user interface and continue
to expose the same knob - even if the default is the optimal, etc.

To be completely honest, I don't think any user is really relying
on any REC_GAIN / Capture setting, and I'm completely OK
with having a mixer control or a module parameter. It doesn't matter.

What matters here, is getting rid of the stupid AC97 mixer,
with a dozen of playback and capture controls that have no meaning
whatsoever.

> Either way, if you still think this solution is "crap", feel free to
> modify the patches in any way you see fit. I've wasted too much time
> on this already, and since I'm not being paid for it, I don't intend
> to put any more effort into this.
>

FWIW, I don't think your patches are crap. Quite the opposite,
it's refreshing to see such good stuff being submitted.

After the click noise you fixed in snd-usb-audio, removing the mixer
is the last TODO thing in this driver. So I really appreciate all the time
you have put in it.
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
