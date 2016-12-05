Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36873 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbcLEWeP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 17:34:15 -0500
Received: by mail-wm0-f48.google.com with SMTP id t79so107813851wmt.0
        for <linux-media@vger.kernel.org>; Mon, 05 Dec 2016 14:34:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOJOY2M6QANNysnZ_C9G+fFg=a=wYQXGDr49LCYGE7KrbwkE4A@mail.gmail.com>
References: <20161127110732.GA5338@arch-desktop> <20161127111148.GA30483@arch-desktop>
 <20161202090558.29931492@vento.lan> <CAAEAJfCmQnQHWy+7kS4wuuBK7mubiKRpiDYCm9BHYjVR4yHGgA@mail.gmail.com>
 <CAOJOY2Nhi6aev=jwVeyuQMxKUAk-MfT0YLKsFfrUsAcZtdrysQ@mail.gmail.com>
 <CAAEAJfAoZCzh5c=C+8Um-KaZkRs_ip1kX04xZRm2bWrGLmMwjA@mail.gmail.com>
 <20161205101221.53613e57@vento.lan> <CAAEAJfD6sauJ_NyYtBmFAr5c_NGr8OuZwqnG1Ukk9-P7YNSypQ@mail.gmail.com>
 <CAOJOY2M6QANNysnZ_C9G+fFg=a=wYQXGDr49LCYGE7KrbwkE4A@mail.gmail.com>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Mon, 5 Dec 2016 19:34:13 -0300
Message-ID: <CAAEAJfB1zd3unS++ff5GhaszGNvaEPscsFozLEf4Ce2iBz_nLQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] stk1160: Add module param for setting the record gain.
To: Marcel Hasler <mahasler@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5 December 2016 at 18:06, Marcel Hasler <mahasler@gmail.com> wrote:
> Hello
>
> 2016-12-05 16:38 GMT+01:00 Ezequiel Garcia <ezequiel@vanguardiasur.com.ar=
>:
>> On 5 December 2016 at 09:12, Mauro Carvalho Chehab
>> <mchehab@s-opensource.com> wrote:
>>> Em Sun, 4 Dec 2016 15:25:25 -0300
>>> Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> escreveu:
>>>
>>>> On 4 December 2016 at 10:01, Marcel Hasler <mahasler@gmail.com> wrote:
>>>> > Hello
>>>> >
>>>> > 2016-12-03 21:46 GMT+01:00 Ezequiel Garcia <ezequiel@vanguardiasur.c=
om.ar>:
>>>> >> On 2 December 2016 at 08:05, Mauro Carvalho Chehab
>>>> >> <mchehab@s-opensource.com> wrote:
>>>> >>> Em Sun, 27 Nov 2016 12:11:48 +0100
>>>> >>> Marcel Hasler <mahasler@gmail.com> escreveu:
>>>> >>>
>>>> >>>> Allow setting a custom record gain for the internal AC97 codec (i=
f available). This can be
>>>> >>>> a value between 0 and 15, 8 is the default and should be suitable=
 for most users. The Windows
>>>> >>>> driver also sets this to 8 without any possibility for changing i=
t.
>>>> >>>
>>>> >>> The problem of removing the mixer is that you need this kind of
>>>> >>> crap to setup the volumes on a non-standard way.
>>>> >>>
>>>> >>
>>>> >> Right, that's a good point.
>>>> >>
>>>> >>> NACK.
>>>> >>>
>>>> >>> Instead, keep the alsa mixer. The way other drivers do (for exampl=
e,
>>>> >>> em28xx) is that they configure the mixer when an input is selected=
,
>>>> >>> increasing the volume of the active audio channel to 100% and muti=
ng
>>>> >>> the other audio channels. Yet, as the alsa mixer is exported, user=
s
>>>> >>> can change the mixer settings in runtime using some alsa (or pa)
>>>> >>> mixer application.
>>>> >>>
>>>> >>
>>>> >> Yeah, the AC97 mixer we are currently leveraging
>>>> >> exposes many controls that have no meaning in this device,
>>>> >> so removing that still looks like an improvement.
>>>> >>
>>>> >> I guess the proper way is creating our own mixer
>>>> >> (not using snd_ac97_mixer)  exposing only the record
>>>> >> gain knob.
>>>> >>
>>>> >> Marcel, what do you think?
>>>> >> --
>>>> >> Ezequiel Garc=C3=ADa, VanguardiaSur
>>>> >> www.vanguardiasur.com.ar
>>>> >
>>>> > As I have written before, the recording gain isn't actually meant to
>>>> > be changed by the user. In the official Windows driver this value is
>>>> > hard-coded to 8 and cannot be changed in any way. And there really i=
s
>>>> > no good reason why anyone should need to mess with it in the first
>>>> > place. The default value will give the best results in pretty much a=
ll
>>>> > cases and produces approximately the same volume as the internal 8-b=
it
>>>> > ADC whose gain cannot be changed at all, not even by a driver.
>>>> >
>>>> > I had considered writing a mixer but chose not to. If the gain setti=
ng
>>>> > is openly exposed to mixer applications, how do you tell the users
>>>> > that the value set by the driver already is the optimal and
>>>> > recommended value and that they shouldn't mess with the controls
>>>> > unless they really have to? By having a module parameter, this setti=
ng
>>>> > is practically hidden from the normal user but still is available to
>>>> > power-users if they think they really need it. In the end it's reall=
y
>>>> > just a compromise between hiding it completely and exposing it openl=
y.
>>>> > Also, this way the driver guarantees reproducible results, since
>>>> > there's no need to remember the positions of any volume sliders.
>>>> >
>>>>
>>>> Hm, right. I've never changed the record gain, and it's true that it
>>>> doens't really improve the volume. So, I would be OK with having
>>>> a module parameter.
>>>>
>>>> On the other side, we are exposing it currently, through the "Capture"
>>>> mixer control:
>>>>
>>>> Simple mixer control 'Capture',0
>>>>   Capabilities: cvolume cswitch cswitch-joined
>>>>   Capture channels: Front Left - Front Right
>>>>   Limits: Capture 0 - 15
>>>>   Front Left: Capture 10 [67%] [15.00dB] [on]
>>>>   Front Right: Capture 8 [53%] [12.00dB] [on]
>>>>
>>>> So, it would be user-friendly to keep the user interface and continue
>>>> to expose the same knob - even if the default is the optimal, etc.
>>>>
>>>> To be completely honest, I don't think any user is really relying
>>>> on any REC_GAIN / Capture setting, and I'm completely OK
>>>> with having a mixer control or a module parameter. It doesn't matter.
>>>
>>> If you're positive that *all* stk1160 use the ac97 mixer the
>>> same way, and that there's no sense on having a mixer for it,
>>> then it would be ok to remove it.
>>>
>>
>> Let's remove it then!
>>
>>> In such case, then why you need a modprobe parameter to allow
>>> setting the record level? If this mixer entry is not used,
>>> just set it to zero and be happy with that.
>>>
>>
>> Let's remove the module param too, then.
>
> I'm okay with that.
>
>>
>> Thanks,
>> --
>> Ezequiel Garc=C3=ADa, VanguardiaSur
>> www.vanguardiasur.com.ar
>
> I'm willing to prepare one final patchset, provided we can agree on
> and resolve all issues beforehand.
>
> So far the changes would be to remove the module param and to poll
> STK1160_AC97CTL_0 instead of using a fixed delay. It's probably better
> to also poll it before writing, although that never caused problems.
>

If that's too much trouble or too much of a hassle,
imaybe just remove the read_reg. It's not really
used right now, except for dumping the registers.
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
