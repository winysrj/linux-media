Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab1IGQe1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Sep 2011 12:34:27 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p87GYQ55011355
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 7 Sep 2011 12:34:27 -0400
Message-ID: <4E67686E.8000502@redhat.com>
Date: Wed, 07 Sep 2011 09:49:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 01/10] alsa_stream: port changes made on xawtv3
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com> <CAGoCfiy2hnH0Xoz_+Q8JgcB-tzuTGbfv8QdK0kv+ttP7t+EZKg@mail.gmail.com> <CAGoCfixa0pr048=-P3OUkZ2HMaY471eNO79BON0vjSVa1eRcTw@mail.gmail.com> <4E66E532.4050402@redhat.com> <CAGoCfiw7vjprc_skYYAXy9sTA7zkYEWtzXy9tEmJD+q8aazPog@mail.gmail.com>
In-Reply-To: <CAGoCfiw7vjprc_skYYAXy9sTA7zkYEWtzXy9tEmJD+q8aazPog@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-09-2011 00:37, Devin Heitmueller escreveu:
> On Tue, Sep 6, 2011 at 11:29 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>>> Basically the above starts at the *maximum* capture resolution and
>>> works its way down.  One might argue that this heuristic makes more
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
> same range (8-48 KHz).  Seems to be behaving the same way as well.


Hmm... just checked with WinTV USB2:
[    3.819236] msp3400 15-0044: MSP3445G-B8 found @ 0x88 (em28xx #0)

While this device uses snd-usb-audio, it is a non-AC97 adapter. So,
we may expect it to be different from yours. 

Its A/D works at a fixed rate of 32 kHZ, according with MSP34x5G datasheet,
so snd-usb-audio is working properly here.

> So while I'm usually willing to blame things on Pulse, this doesn't
> look like the case here.

That's good. One less problem to deal with.

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
> Ugh.  We really need some sort of heuristic to do this.  It's
> unreasonable to expect users to know about some magic parameter buried
> in a config file which causes it to start working.

Agreed, but still it makes sense to allow users to adjust, as extra delays
might be needed on really slow machines.

> Perhaps a counter
> that increments whenever an underrun is hit, and after a certain
> number it automatically restarts the stream with a higher latency.  Or
> perhaps we're just making some poor choice in terms of the
> buffers/periods for a given rate.
> 
> Devin
> 

