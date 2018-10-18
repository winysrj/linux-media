Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:40543 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbeJRMbE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 08:31:04 -0400
Received: by mail-yw1-f68.google.com with SMTP id l79-v6so11295948ywc.7
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2018 21:32:02 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id 198-v6sm52548ywf.49.2018.10.17.21.32.00
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Oct 2018 21:32:00 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id m184-v6so238216ybm.0
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2018 21:32:00 -0700 (PDT)
MIME-Version: 1.0
References: <20181017075242.21790-1-henryhsu@chromium.org> <13883852.6N9L7C0n48@avalon>
 <CAAFQd5B+4x4aSUywtdukwgUmQNQsQsbK4sjedNphwNFteaTscg@mail.gmail.com> <2355808.GKno8i6Ks9@avalon>
In-Reply-To: <2355808.GKno8i6Ks9@avalon>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 18 Oct 2018 13:31:48 +0900
Message-ID: <CAAFQd5AL2CnnWLk+i133RRa36HTa0baFkezRhpTXf9YP0DSF1Q@mail.gmail.com>
Subject: Re: [PATCH] media: uvcvideo: Add boottime clock support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        gwendal@chromium.org, amstan@chromium.org
Cc: Heng-Ruey Hsu <henryhsu@chromium.org>,
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

On Thu, Oct 18, 2018 at 5:50 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Tomasz,
>
> On Wednesday, 17 October 2018 11:28:52 EEST Tomasz Figa wrote:
> > On Wed, Oct 17, 2018 at 5:02 PM Laurent Pinchart wrote:
> > > On Wednesday, 17 October 2018 10:52:42 EEST Heng-Ruey Hsu wrote:
> > >> Android requires camera timestamps to be reported with
> > >> CLOCK_BOOTTIME to sync timestamp with other sensor sources.
> > >
> > > What's the rationale behind this, why can't CLOCK_MONOTONIC work ? If the
> > > monotonic clock has shortcomings that make its use impossible for proper
> > > synchronization, then we should consider switching to CLOCK_BOOTTIME
> > > globally in V4L2, not in selected drivers only.
> >
> > CLOCK_BOOTTIME includes the time spent in suspend, while
> > CLOCK_MONOTONIC doesn't. I can imagine the former being much more
> > useful for anything that cares about the actual, long term, time
> > tracking. Especially important since suspend is a very common event on
> > Android and doesn't stop the time flow there, i.e. applications might
> > wake up the device to perform various tasks at necessary times.
>
> Sure, but this patch mentions timestamp synchronization with other sensors,
> and from that point of view, I'd like to know what is wrong with the monotonic
> clock if all devices use it.

AFAIK the sensors mentioned there are not camera sensors, but rather
things we normally put under IIO, e.g. accelerometers, gyroscopes and
so on. I'm not sure how IIO deals with timestamps, but Android seems
to operate in the CLOCK_BOTTIME domain. Let me add some IIO folks.

Gwendal, Alexandru, do you think you could shed some light on how we
handle IIO sensors timestamps across the kernel, Chrome OS and
Android?

>
> > Generally, I'd see a V4L2_BUF_FLAG_TIMESTAMP_BOOTTIME flag being added
> > and user space being given choice to select the time stamp base it
> > needs, perhaps by setting the flag in v4l2_buffer struct at QBUF time?
>
> I would indeed prefer a mechanism specified at the V4L2 API level, with an
> implementation in the V4L2 core, over a module parameter. If the goal is to
> use the boottime clock for synchronization purpose, we need to make sure that
> all drivers will support it correctly. Patching drivers one by one doesn't
> really scale.

Agreed.

Best regards,
Tomasz
