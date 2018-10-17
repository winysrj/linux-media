Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:35347 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbeJQQXm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 12:23:42 -0400
Received: by mail-yb1-f194.google.com with SMTP id o63-v6so10020975yba.2
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2018 01:29:06 -0700 (PDT)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id l5-v6sm3748942ywm.70.2018.10.17.01.29.04
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Oct 2018 01:29:04 -0700 (PDT)
Received: by mail-yw1-f54.google.com with SMTP id j75-v6so10002805ywj.10
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2018 01:29:04 -0700 (PDT)
MIME-Version: 1.0
References: <20181017075242.21790-1-henryhsu@chromium.org> <13883852.6N9L7C0n48@avalon>
In-Reply-To: <13883852.6N9L7C0n48@avalon>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 17 Oct 2018 17:28:52 +0900
Message-ID: <CAAFQd5B+4x4aSUywtdukwgUmQNQsQsbK4sjedNphwNFteaTscg@mail.gmail.com>
Subject: Re: [PATCH] media: uvcvideo: Add boottime clock support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Heng-Ruey Hsu <henryhsu@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ricky Liang <jcliang@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Oct 17, 2018 at 5:02 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Heng-Ruey,
>
> Thank you for the patch.
>
> On Wednesday, 17 October 2018 10:52:42 EEST Heng-Ruey Hsu wrote:
> > Android requires camera timestamps to be reported with
> > CLOCK_BOOTTIME to sync timestamp with other sensor sources.
>
> What's the rationale behind this, why can't CLOCK_MONOTONIC work ? If the
> monotonic clock has shortcomings that make its use impossible for proper
> synchronization, then we should consider switching to CLOCK_BOOTTIME globally
> in V4L2, not in selected drivers only.
>

CLOCK_BOOTTIME includes the time spent in suspend, while
CLOCK_MONOTONIC doesn't. I can imagine the former being much more
useful for anything that cares about the actual, long term, time
tracking. Especially important since suspend is a very common event on
Android and doesn't stop the time flow there, i.e. applications might
wake up the device to perform various tasks at necessary times.

Generally, I'd see a V4L2_BUF_FLAG_TIMESTAMP_BOOTTIME flag being added
and user space being given choice to select the time stamp base it
needs, perhaps by setting the flag in v4l2_buffer struct at QBUF time?

Best regards,
Tomasz

> > Signed-off-by: Heng-Ruey Hsu <henryhsu@chromium.org>
> > ---
> >  drivers/media/usb/uvc/uvc_driver.c | 4 ++++
> >  drivers/media/usb/uvc/uvc_video.c  | 2 ++
> >  2 files changed, 6 insertions(+)
> >
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index d46dc432456c..a9658f38c586
> > 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -2287,6 +2287,8 @@ static int uvc_clock_param_get(char *buffer, const
> > struct kernel_param *kp) {
> >       if (uvc_clock_param == CLOCK_MONOTONIC)
> >               return sprintf(buffer, "CLOCK_MONOTONIC");
> > +     else if (uvc_clock_param == CLOCK_BOOTTIME)
> > +             return sprintf(buffer, "CLOCK_BOOTTIME");
> >       else
> >               return sprintf(buffer, "CLOCK_REALTIME");
> >  }
> > @@ -2298,6 +2300,8 @@ static int uvc_clock_param_set(const char *val, const
> > struct kernel_param *kp)
> >
> >       if (strcasecmp(val, "monotonic") == 0)
> >               uvc_clock_param = CLOCK_MONOTONIC;
> > +     else if (strcasecmp(val, "boottime") == 0)
> > +             uvc_clock_param = CLOCK_BOOTTIME;
> >       else if (strcasecmp(val, "realtime") == 0)
> >               uvc_clock_param = CLOCK_REALTIME;
> >       else
> > diff --git a/drivers/media/usb/uvc/uvc_video.c
> > b/drivers/media/usb/uvc/uvc_video.c index 86a99f461fd8..d4248d5cd9cd 100644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -425,6 +425,8 @@ static inline ktime_t uvc_video_get_time(void)
> >  {
> >       if (uvc_clock_param == CLOCK_MONOTONIC)
> >               return ktime_get();
> > +     else if (uvc_clock_param == CLOCK_BOOTTIME)
> > +             return ktime_get_boottime();
> >       else
> >               return ktime_get_real();
> >  }
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>
