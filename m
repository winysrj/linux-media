Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64348 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab1IGDmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 23:42:07 -0400
Received: by bke11 with SMTP id 11so6039418bke.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 20:42:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiw7vjprc_skYYAXy9sTA7zkYEWtzXy9tEmJD+q8aazPog@mail.gmail.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
	<CAGoCfiy2hnH0Xoz_+Q8JgcB-tzuTGbfv8QdK0kv+ttP7t+EZKg@mail.gmail.com>
	<CAGoCfixa0pr048=-P3OUkZ2HMaY471eNO79BON0vjSVa1eRcTw@mail.gmail.com>
	<4E66E532.4050402@redhat.com>
	<CAGoCfiw7vjprc_skYYAXy9sTA7zkYEWtzXy9tEmJD+q8aazPog@mail.gmail.com>
Date: Tue, 6 Sep 2011 23:42:05 -0400
Message-ID: <CAGoCfiw-QnfVVwOhejwbMmb+K2F0VDwN_L-6E37w+=jKYGGFkg@mail.gmail.com>
Subject: Re: [PATCH 01/10] alsa_stream: port changes made on xawtv3
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 6, 2011 at 11:37 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Tue, Sep 6, 2011 at 11:29 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>>> Basically the above starts at the *maximum* capture resolution and
>>> works its way down.  One might argue that this heuristic makes more
>>> sense anyway - why *wouldn't* you want the highest quality audio
>>> possible by default (rather than the lowest)?
>>
>> That change makes sense to me. Yet, you should try to disable pulseaudio
>> and see what's the _real_ speed that the audio announces. On Fedora,
>> just removing pulsaudio-oss-plugin (or something like that) is enough.
>>
>> It seems doubtful that my em2820 WinTV USB2 is different than yours.
>> I suspect that pulseaudio is passing the "extra" range, offering to
>> interpolate the data.
>
> I disabled pulseaudio and the capture device is advertising the exact
> same range (8-48 KHz).  Seems to be behaving the same way as well.
>
> So while I'm usually willing to blame things on Pulse, this doesn't
> look like the case here.
>
>>> Even with that patch though, I hit severe underrun/overrun conditions
>>> at 30ms of latency (to the point where the audio is interrupted dozens
>>> of times per second).
>>
>> Yes, it is the same here: 30ms on my notebook is not enough for WinTV
>> USB2 (it is OK with HVR-950).
>>
>>> Turned it up to 50ms and it's much better.
>>> That said, of course such a change would impact lipsync, so perhaps we
>>> need to be adjusting the periods instead.
>>
>> We've added a parameter for that on xawtv3 (--alsa-latency). We've parametrized
>> it at the alsa stream function call. So, all it needs is to add a new parameter
>> at tvtime config file.
>
> Ugh.  We really need some sort of heuristic to do this.  It's
> unreasonable to expect users to know about some magic parameter buried
> in a config file which causes it to start working.  Perhaps a counter
> that increments whenever an underrun is hit, and after a certain
> number it automatically restarts the stream with a higher latency.  Or
> perhaps we're just making some poor choice in terms of the
> buffers/periods for a given rate.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

One more thing worth noting before I quit for the night:

What audio processor is on your WinTV USB 2 device?  The DVC-90 has an
emp202.  Perhaps the WInTV uses a different audio processor (while
still using an em2820 as the bridge)?  That might explain why your
device advertises effectively only one capture rate (32), while mine
advertises a whole range (8-48).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
