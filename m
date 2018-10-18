Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40626 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbeJSBa2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 21:30:28 -0400
Received: by mail-ot1-f68.google.com with SMTP id w67so30538911ota.7
        for <linux-media@vger.kernel.org>; Thu, 18 Oct 2018 10:28:30 -0700 (PDT)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com. [209.85.167.171])
        by smtp.gmail.com with ESMTPSA id 111sm7333797otf.51.2018.10.18.10.28.27
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Oct 2018 10:28:27 -0700 (PDT)
Received: by mail-oi1-f171.google.com with SMTP id u197-v6so24650761oif.5
        for <linux-media@vger.kernel.org>; Thu, 18 Oct 2018 10:28:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAFQd5AL2CnnWLk+i133RRa36HTa0baFkezRhpTXf9YP0DSF1Q@mail.gmail.com>
References: <20181017075242.21790-1-henryhsu@chromium.org> <13883852.6N9L7C0n48@avalon>
 <CAAFQd5B+4x4aSUywtdukwgUmQNQsQsbK4sjedNphwNFteaTscg@mail.gmail.com>
 <2355808.GKno8i6Ks9@avalon> <CAAFQd5AL2CnnWLk+i133RRa36HTa0baFkezRhpTXf9YP0DSF1Q@mail.gmail.com>
From: Alexandru M Stan <amstan@chromium.org>
Date: Thu, 18 Oct 2018 10:28:06 -0700
Message-ID: <CAHNYxRwbSSp02Zr4a1z5gh0q6cHUUDnZCqRQU7QtP8LMe3Jp2A@mail.gmail.com>
Subject: Re: [PATCH] media: uvcvideo: Add boottime clock support
To: Tomasz Figa <tfiga@chromium.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        Heng-Ruey Hsu <henryhsu@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ricky Liang <jcliang@chromium.org>, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 17, 2018 at 9:31 PM, Tomasz Figa <tfiga@chromium.org> wrote:
> On Thu, Oct 18, 2018 at 5:50 AM Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>>
>> Hi Tomasz,
>>
>> On Wednesday, 17 October 2018 11:28:52 EEST Tomasz Figa wrote:
>> > On Wed, Oct 17, 2018 at 5:02 PM Laurent Pinchart wrote:
>> > > On Wednesday, 17 October 2018 10:52:42 EEST Heng-Ruey Hsu wrote:
>> > >> Android requires camera timestamps to be reported with
>> > >> CLOCK_BOOTTIME to sync timestamp with other sensor sources.
>> > >
>> > > What's the rationale behind this, why can't CLOCK_MONOTONIC work ? If the
>> > > monotonic clock has shortcomings that make its use impossible for proper
>> > > synchronization, then we should consider switching to CLOCK_BOOTTIME
>> > > globally in V4L2, not in selected drivers only.
>> >
>> > CLOCK_BOOTTIME includes the time spent in suspend, while
>> > CLOCK_MONOTONIC doesn't. I can imagine the former being much more
>> > useful for anything that cares about the actual, long term, time
>> > tracking. Especially important since suspend is a very common event on
>> > Android and doesn't stop the time flow there, i.e. applications might
>> > wake up the device to perform various tasks at necessary times.
>>
>> Sure, but this patch mentions timestamp synchronization with other sensors,
>> and from that point of view, I'd like to know what is wrong with the monotonic
>> clock if all devices use it.
>
> AFAIK the sensors mentioned there are not camera sensors, but rather
> things we normally put under IIO, e.g. accelerometers, gyroscopes and
> so on. I'm not sure how IIO deals with timestamps, but Android seems
> to operate in the CLOCK_BOTTIME domain. Let me add some IIO folks.
>
> Gwendal, Alexandru, do you think you could shed some light on how we
> handle IIO sensors timestamps across the kernel, Chrome OS and
> Android?

On our devices of interest have a specialized "sensor" that comes via
IIO (from the EC, cros-ec-ring driver) that can be used to more
accurately timestamp each frame (since it's recorded with very low
jitter by a realtime-ish OS). In some high level userspace thing
(specifically the Android Camera HAL) we try to pick the best
timestamp from the IIO, whatever's closest to what the V4L stuff gives
us.

I guess the Android convention is for sensor timestamps to be in
CLOCK_BOOTTIME (maybe because it likes sleeping so much). There's
probably no advantage to using one over the other, but the important
thing is that they have to be the same, otherwise the closest match
logic would fail.

Regards,
Alexandru Stan
