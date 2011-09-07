Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab1IGD35 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 23:29:57 -0400
Message-ID: <4E66E532.4050402@redhat.com>
Date: Wed, 07 Sep 2011 00:29:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 01/10] alsa_stream: port changes made on xawtv3
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com> <CAGoCfiy2hnH0Xoz_+Q8JgcB-tzuTGbfv8QdK0kv+ttP7t+EZKg@mail.gmail.com> <CAGoCfixa0pr048=-P3OUkZ2HMaY471eNO79BON0vjSVa1eRcTw@mail.gmail.com>
In-Reply-To: <CAGoCfixa0pr048=-P3OUkZ2HMaY471eNO79BON0vjSVa1eRcTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-09-2011 00:20, Devin Heitmueller escreveu:
> On Tue, Sep 6, 2011 at 10:58 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> On Tue, Sep 6, 2011 at 11:29 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> There are several issues with the original alsa_stream code that got
>>> fixed on xawtv3, made by me and by Hans de Goede. Basically, the
>>> code were re-written, in order to follow the alsa best practises.
>>>
>>> Backport the changes from xawtv, in order to make it to work on a
>>> wider range of V4L and sound adapters.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> Mauro,
>>
>> What tuners did you test this patch with?  I went ahead and did a git
>> pull of your patch series into my local git tree, and now my DVC-90
>> (an em28xx device) is capturing at 32 KHz instead of 48 (this is one
>> of the snd-usb-audio based devices, not em28xx-alsa).
>>
>> Note I tested immediately before pulling your patch series and the
>> audio capture was working fine.
>>
>> I think this patch series is going in the right direction in general,
>> but this patch in particular seems to cause a regression.  Is this
>> something you want to investigate?  I think we need to hold off on
>> pulling this series into the new tvtime master until this problem is
>> resolved.
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller - Kernel Labs
>> http://www.kernellabs.com
>>
> 
> Spent a few minutes digging into this.  Looks like the snd-usb-audio
> driver advertises 8-48KHz.  However, it seems that it only captures
> successfully at 48 KHz.
> 
> I made the following hack and it started working:
> 
> diff --git a/src/alsa_stream.c b/src/alsa_stream.c
> index b6a41a5..57e3c3d 100644
> --- a/src/alsa_stream.c
> +++ b/src/alsa_stream.c
> @@ -261,7 +261,7 @@ static int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle,
>         fprintf(error_fp, "alsa: Will search a common rate between %u and %u\n",
>                 ratemin, ratemax);
> 
> -    for (i = ratemin; i <= ratemax; i+= 100) {
> +    for (i = ratemax; i >= ratemin; i-= 100) {
>         err = snd_pcm_hw_params_set_rate_near(chandle, c_hwparams, &i, 0);
>         if (err)
>             continue;
> 
> Basically the above starts at the *maximum* capture resolution and
> works its way down.  One might argue that this heuristic makes more
> sense anyway - why *wouldn't* you want the highest quality audio
> possible by default (rather than the lowest)?

That change makes sense to me. Yet, you should try to disable pulseaudio
and see what's the _real_ speed that the audio announces. On Fedora,
just removing pulsaudio-oss-plugin (or something like that) is enough.

It seems doubtful that my em2820 WinTV USB2 is different than yours.
I suspect that pulseaudio is passing the "extra" range, offering to
interpolate the data.

> Even with that patch though, I hit severe underrun/overrun conditions
> at 30ms of latency (to the point where the audio is interrupted dozens
> of times per second).

Yes, it is the same here: 30ms on my notebook is not enough for WinTV
USB2 (it is OK with HVR-950).

> Turned it up to 50ms and it's much better.
> That said, of course such a change would impact lipsync, so perhaps we
> need to be adjusting the periods instead.

We've added a parameter for that on xawtv3 (--alsa-latency). We've parametrized
it at the alsa stream function call. So, all it needs is to add a new parameter
at tvtime config file.

> ALSA has never been my area of expertise, so I look to you and Hans to
> offer some suggestions.
> 
> Devin
> 

