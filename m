Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:46123
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149Ab2FJQzn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 12:55:43 -0400
Date: Sun, 10 Jun 2012 12:55:30 -0400 (EDT)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: mchehab@infradead.org, linux-media@vger.kernel.org, joe@perches.com
Subject: Re: question about bt8xx/bttv-audio-hook.c, tvaudio.c
In-Reply-To: <201206091005.16782.hverkuil@xs4all.nl>
Message-ID: <alpine.DEB.2.02.1206101255080.1806@hadrien>
References: <alpine.DEB.2.02.1206060852460.1777@hadrien> <201206091005.16782.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 9 Jun 2012, Hans Verkuil wrote:

> On Wed June 6 2012 09:06:23 Julia Lawall wrote:
>> The files drivers/media/video/bt8xx/bttv-audio-hook.c and
>> drivers/media/video/tvaudio.c contain a number of occurrences of eg:
>>
>> mode |= V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
>>
>> and
>>
>> if (mode & V4L2_TUNER_MODE_MONO)
>>
>> (both from tvaudio.c)
>>
>> V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2 is suspicious because
>> V4L2_TUNER_MODE_LANG1 is 3 and V4L2_TUNER_MODE_LANG2 is 2, so the result
>> is just the same as V4L2_TUNER_MODE_LANG1.  Maybe
>> V4L2_TUNER_MODE_LANG1_LANG2 was intended?
>>
>> mode & V4L2_TUNER_MODE_MONO is suspicious because V4L2_TUNER_MODE_MONO is
>> 0.  Maybe & should be ==?
>>
>> If & is to be changed to == everywhere, then some new code may need to be
>> constructed to account for V4L2_TUNER_MODE_LANG1_LANG2.  For example, the
>> function tda8425_setmode has ifs for the other values, but not for this
>> one.  On the other hand, the function ta8874z_setmode already uses == (or
>> rather switch), and does not take V4L2_TUNER_MODE_LANG1_LANG2 into
>> account, so perhaps it is not appropriate in this context?
>
> I would have to analyse this more carefully, but the core issue here is that
> these drivers mixup the tuner audio reception bitmask flags (V4L2_TUNER_SUB_*)
> and the tuner audio modes (V4L2_TUNER_MODE_*, not a bitmask). This happened
> regularly in older drivers, and apparently these two are still not fixed.
>
> More info is here:
>
> http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-g-tuner
>
> I can't just replace one define with another, I would need to look carefully
> at the code to see what was intended.
>
> If you find more places where this happens, then please let us know. Otherwise
> this is something for us to fix.

No, I explicitly looked, but only found the problem in these two files.

julia
