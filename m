Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35496 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751570AbdLEL1n (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Dec 2017 06:27:43 -0500
MIME-Version: 1.0
In-Reply-To: <5754191.7VT3CuYHXL@avalon>
References: <20171127132027.1734806-1-arnd@arndb.de> <20171127132027.1734806-2-arnd@arndb.de>
 <2878836.BpTQ5Kp5iv@avalon> <5754191.7VT3CuYHXL@avalon>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 5 Dec 2017 12:27:42 +0100
Message-ID: <CAK8P3a3JTVoV1EWyA0QQ5r4wuvDdtrsGmZYwYyUJis6SQrBrRQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] [media] uvc_video: use ktime_t for timestamps
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 5, 2017 at 1:58 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Arnd,
>
> On Tuesday, 5 December 2017 02:37:27 EET Laurent Pinchart wrote:
>> On Monday, 27 November 2017 15:19:54 EET Arnd Bergmann wrote:
>> > uvc_video_get_ts() returns a 'struct timespec', but all its users
>> > really want a nanoseconds variable anyway.
>> >
>> > Changing the deprecated ktime_get_ts/ktime_get_real_ts to ktime_get
>> > and ktime_get_real simplifies the code noticeably, while keeping
>> > the resulting numbers unchanged.
>> >
>> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> > ---
>> >
>> >  drivers/media/usb/uvc/uvc_video.c | 37 ++++++++++++---------------------
>> >  drivers/media/usb/uvc/uvcvideo.h  |  2 +-
>> >  2 files changed, 13 insertions(+), 26 deletions(-)
>
> [snip]
>
>> > -   struct timespec ts;
>> > +   u64 timestamp;
>
> [snip]
>
>> >     uvc_trace(UVC_TRACE_CLOCK, "%s: SOF %u.%06llu y %llu ts %llu "
>> >               "buf ts %llu (x1 %u/%u/%u x2 %u/%u/%u y1 %u y2 %u)\n",
>> >               stream->dev->name,
>> >               sof >> 16, div_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
>> > -             y, timespec_to_ns(&ts), vbuf->vb2_buf.timestamp,
>> > +             y, timestamp, vbuf->vb2_buf.timestamp,
>> >               x1, first->host_sof, first->dev_sof,
>> >               x2, last->host_sof, last->dev_sof, y1, y2);
>
> As you've done lots of work moving code away from timespec I figured out I
> would ask, what is the preferred way to print a ktime in secs.nsecs format ?
> Should I use ktime_to_timespec and print ts.tv_sec and ts.tv_nsec, or is there
> a better way ?

We had patches under discussion to add a special printk format string that
would pretty-print a date, but that never got merged. Usually there is a
tradeoff between runtime to convert the nanoseconds into a different format
and how useful you want it to be. ktime_to_timespec() can be a bit slow on
some architectures, since it has to do a 64-bit division, but then again
the sprintf logic also needs to do that. If the output isn't on a time-critical
path, you can use time64_to_tm and print it in years/months/days/hours/
minutes/seconds, but depending on where it gets printed, that may not
be easier to interpret than the seconds/nanoseconds or pure
nanoseconds.

       Arnd
