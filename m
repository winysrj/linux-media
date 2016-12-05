Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f169.google.com ([209.85.210.169]:35231 "EHLO
        mail-wj0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752124AbcLEPif (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 10:38:35 -0500
Received: by mail-wj0-f169.google.com with SMTP id v7so293760111wjy.2
        for <linux-media@vger.kernel.org>; Mon, 05 Dec 2016 07:38:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161205101221.53613e57@vento.lan>
References: <20161127110732.GA5338@arch-desktop> <20161127111148.GA30483@arch-desktop>
 <20161202090558.29931492@vento.lan> <CAAEAJfCmQnQHWy+7kS4wuuBK7mubiKRpiDYCm9BHYjVR4yHGgA@mail.gmail.com>
 <CAOJOY2Nhi6aev=jwVeyuQMxKUAk-MfT0YLKsFfrUsAcZtdrysQ@mail.gmail.com>
 <CAAEAJfAoZCzh5c=C+8Um-KaZkRs_ip1kX04xZRm2bWrGLmMwjA@mail.gmail.com> <20161205101221.53613e57@vento.lan>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Mon, 5 Dec 2016 12:38:31 -0300
Message-ID: <CAAEAJfD6sauJ_NyYtBmFAr5c_NGr8OuZwqnG1Ukk9-P7YNSypQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] stk1160: Add module param for setting the record gain.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Marcel Hasler <mahasler@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5 December 2016 at 09:12, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Sun, 4 Dec 2016 15:25:25 -0300
> Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> escreveu:
>
>> On 4 December 2016 at 10:01, Marcel Hasler <mahasler@gmail.com> wrote:
>> > Hello
>> >
>> > 2016-12-03 21:46 GMT+01:00 Ezequiel Garcia <ezequiel@vanguardiasur.com=
.ar>:
>> >> On 2 December 2016 at 08:05, Mauro Carvalho Chehab
>> >> <mchehab@s-opensource.com> wrote:
>> >>> Em Sun, 27 Nov 2016 12:11:48 +0100
>> >>> Marcel Hasler <mahasler@gmail.com> escreveu:
>> >>>
>> >>>> Allow setting a custom record gain for the internal AC97 codec (if =
available). This can be
>> >>>> a value between 0 and 15, 8 is the default and should be suitable f=
or most users. The Windows
>> >>>> driver also sets this to 8 without any possibility for changing it.
>> >>>
>> >>> The problem of removing the mixer is that you need this kind of
>> >>> crap to setup the volumes on a non-standard way.
>> >>>
>> >>
>> >> Right, that's a good point.
>> >>
>> >>> NACK.
>> >>>
>> >>> Instead, keep the alsa mixer. The way other drivers do (for example,
>> >>> em28xx) is that they configure the mixer when an input is selected,
>> >>> increasing the volume of the active audio channel to 100% and muting
>> >>> the other audio channels. Yet, as the alsa mixer is exported, users
>> >>> can change the mixer settings in runtime using some alsa (or pa)
>> >>> mixer application.
>> >>>
>> >>
>> >> Yeah, the AC97 mixer we are currently leveraging
>> >> exposes many controls that have no meaning in this device,
>> >> so removing that still looks like an improvement.
>> >>
>> >> I guess the proper way is creating our own mixer
>> >> (not using snd_ac97_mixer)  exposing only the record
>> >> gain knob.
>> >>
>> >> Marcel, what do you think?
>> >> --
>> >> Ezequiel Garc=C3=ADa, VanguardiaSur
>> >> www.vanguardiasur.com.ar
>> >
>> > As I have written before, the recording gain isn't actually meant to
>> > be changed by the user. In the official Windows driver this value is
>> > hard-coded to 8 and cannot be changed in any way. And there really is
>> > no good reason why anyone should need to mess with it in the first
>> > place. The default value will give the best results in pretty much all
>> > cases and produces approximately the same volume as the internal 8-bit
>> > ADC whose gain cannot be changed at all, not even by a driver.
>> >
>> > I had considered writing a mixer but chose not to. If the gain setting
>> > is openly exposed to mixer applications, how do you tell the users
>> > that the value set by the driver already is the optimal and
>> > recommended value and that they shouldn't mess with the controls
>> > unless they really have to? By having a module parameter, this setting
>> > is practically hidden from the normal user but still is available to
>> > power-users if they think they really need it. In the end it's really
>> > just a compromise between hiding it completely and exposing it openly.
>> > Also, this way the driver guarantees reproducible results, since
>> > there's no need to remember the positions of any volume sliders.
>> >
>>
>> Hm, right. I've never changed the record gain, and it's true that it
>> doens't really improve the volume. So, I would be OK with having
>> a module parameter.
>>
>> On the other side, we are exposing it currently, through the "Capture"
>> mixer control:
>>
>> Simple mixer control 'Capture',0
>>   Capabilities: cvolume cswitch cswitch-joined
>>   Capture channels: Front Left - Front Right
>>   Limits: Capture 0 - 15
>>   Front Left: Capture 10 [67%] [15.00dB] [on]
>>   Front Right: Capture 8 [53%] [12.00dB] [on]
>>
>> So, it would be user-friendly to keep the user interface and continue
>> to expose the same knob - even if the default is the optimal, etc.
>>
>> To be completely honest, I don't think any user is really relying
>> on any REC_GAIN / Capture setting, and I'm completely OK
>> with having a mixer control or a module parameter. It doesn't matter.
>
> If you're positive that *all* stk1160 use the ac97 mixer the
> same way, and that there's no sense on having a mixer for it,
> then it would be ok to remove it.
>

Let's remove it then!

> In such case, then why you need a modprobe parameter to allow
> setting the record level? If this mixer entry is not used,
> just set it to zero and be happy with that.
>

Let's remove the module param too, then.

Thanks,
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
