Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:41070 "EHLO
        www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728742AbeKBAGy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 20:06:54 -0400
Subject: Re: [PATCH] media: uvcvideo: Add boottime clock support
To: Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Alexandru Stan <amstan@chromium.org>,
        Gwendal Grignou <gwendal@chromium.org>,
        Heng-Ruey Hsu <henryhsu@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ricky Liang <jcliang@chromium.org>, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>
References: <20181017075242.21790-1-henryhsu@chromium.org>
 <CAAFQd5AL2CnnWLk+i133RRa36HTa0baFkezRhpTXf9YP0DSF1Q@mail.gmail.com>
 <CAHNYxRwbSSp02Zr4a1z5gh0q6cHUUDnZCqRQU7QtP8LMe3Jp2A@mail.gmail.com>
 <1610184.U7oo9Z4Yep@avalon>
 <CAAFQd5A7k2VgmawF-x=AcKhJiG-shrJiCP4Tu9054J0eE91+9w@mail.gmail.com>
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <d79e0857-c6ae-9e57-52e2-e596864a68f8@metafoo.de>
Date: Thu, 1 Nov 2018 16:03:27 +0100
MIME-Version: 1.0
In-Reply-To: <CAAFQd5A7k2VgmawF-x=AcKhJiG-shrJiCP4Tu9054J0eE91+9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/01/2018 03:30 PM, Tomasz Figa wrote:
> On Thu, Nov 1, 2018 at 11:03 PM Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>>
>> Hi Alexandru,
>>
>> On Thursday, 18 October 2018 20:28:06 EET Alexandru M Stan wrote:
>>> On Wed, Oct 17, 2018 at 9:31 PM, Tomasz Figa wrote:
>>>> On Thu, Oct 18, 2018 at 5:50 AM Laurent Pinchart wrote:
>>>>> On Wednesday, 17 October 2018 11:28:52 EEST Tomasz Figa wrote:
>>>>>> On Wed, Oct 17, 2018 at 5:02 PM Laurent Pinchart wrote:
>>>>>>> On Wednesday, 17 October 2018 10:52:42 EEST Heng-Ruey Hsu wrote:
>>>>>>>> Android requires camera timestamps to be reported with
>>>>>>>> CLOCK_BOOTTIME to sync timestamp with other sensor sources.
>>>>>>>
>>>>>>> What's the rationale behind this, why can't CLOCK_MONOTONIC work ? If
>>>>>>> the monotonic clock has shortcomings that make its use impossible for
>>>>>>> proper synchronization, then we should consider switching to
>>>>>>> CLOCK_BOOTTIME globally in V4L2, not in selected drivers only.
>>>>>>
>>>>>> CLOCK_BOOTTIME includes the time spent in suspend, while
>>>>>> CLOCK_MONOTONIC doesn't. I can imagine the former being much more
>>>>>> useful for anything that cares about the actual, long term, time
>>>>>> tracking. Especially important since suspend is a very common event on
>>>>>> Android and doesn't stop the time flow there, i.e. applications might
>>>>>> wake up the device to perform various tasks at necessary times.
>>>>>
>>>>> Sure, but this patch mentions timestamp synchronization with other
>>>>> sensors, and from that point of view, I'd like to know what is wrong with
>>>>> the monotonic clock if all devices use it.
>>>>
>>>> AFAIK the sensors mentioned there are not camera sensors, but rather
>>>> things we normally put under IIO, e.g. accelerometers, gyroscopes and
>>>> so on. I'm not sure how IIO deals with timestamps, but Android seems
>>>> to operate in the CLOCK_BOTTIME domain. Let me add some IIO folks.
>>>>
>>>> Gwendal, Alexandru, do you think you could shed some light on how we
>>>> handle IIO sensors timestamps across the kernel, Chrome OS and
>>>> Android?
>>>
>>> On our devices of interest have a specialized "sensor" that comes via
>>> IIO (from the EC, cros-ec-ring driver) that can be used to more
>>> accurately timestamp each frame (since it's recorded with very low
>>> jitter by a realtime-ish OS). In some high level userspace thing
>>> (specifically the Android Camera HAL) we try to pick the best
>>> timestamp from the IIO, whatever's closest to what the V4L stuff gives
>>> us.
>>>
>>> I guess the Android convention is for sensor timestamps to be in
>>> CLOCK_BOOTTIME (maybe because it likes sleeping so much). There's
>>> probably no advantage to using one over the other, but the important
>>> thing is that they have to be the same, otherwise the closest match
>>> logic would fail.
>>
>> That's my understanding too, I don't think CLOCK_BOOTTIME really brings much
>> benefit in this case,
> 
> I think it does have a significant benefit. CLOCK_MONOTONIC stops when
> the device is sleeping, but the sensors can still capture various
> actions. We would lose the time keeping of those actions if we use
> CLOCK_MONOTONIC.
> 
>> but it's important than all timestamps use the same
>> clock. The question is thus which clock we should select. Mainline mostly uses
>> CLOCK_MONOTONIC, and Android CLOCK_BOOTTIME. Would you like to submit patches
>> to switch Android to CLOCK_MONOTONIC ? :-)
> 
> Is it Android using CLOCK_BOOTTIME or the sensors (IIO?). I have
> almost zero familiarity with the IIO subsystem and was hoping someone
> from there could comment on what time domain is used for those
> sensors.

IIO has the option to choose between BOOTTIME or MONOTONIC (and a few
others) for the timestamp on a per device basis.

There was a bit of a discussion about this a while back. See
https://lkml.org/lkml/2018/7/10/432 and the following thread.
