Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44019 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbeK3Glt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 01:41:49 -0500
Received: by mail-yw1-f65.google.com with SMTP id l200so1251304ywe.10
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2018 11:35:17 -0800 (PST)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id t2sm2234003ywe.56.2018.11.29.11.35.15
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Nov 2018 11:35:15 -0800 (PST)
Received: by mail-yb1-f176.google.com with SMTP id o204-v6so1226748yba.9
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2018 11:35:15 -0800 (PST)
MIME-Version: 1.0
References: <20181004133739.19086-1-mjourdan@baylibre.com> <491c3f33-b51b-89cb-09f0-b48949d61efb@xs4all.nl>
In-Reply-To: <491c3f33-b51b-89cb-09f0-b48949d61efb@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 29 Nov 2018 11:35:03 -0800
Message-ID: <CAAFQd5DqY7zRR9SePWDCL0erB4x0pkBP7x2enuVvdjmyX+ASBw@mail.gmail.com>
Subject: Re: [PATCH] media: videodev2: add V4L2_FMT_FLAG_NO_SOURCE_CHANGE
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mjourdan@baylibre.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 29, 2018 at 1:01 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 10/04/2018 03:37 PM, Maxime Jourdan wrote:
> > When a v4l2 driver exposes V4L2_EVENT_SOURCE_CHANGE, some (usually
> > OUTPUT) formats may not be able to trigger this event.
> >
> > Add a enum_fmt format flag to tag those specific formats.
>
> I think I missed (or forgot) some discussion about this since I have no
> idea why this flag is needed. What's the use-case?

As far as I remember, the hardware/firmware Maxime has been working
with can't handle resolution changes for some coded formats. Perhaps
we should explain that better in the commit message and documentation
of the flag, though. Maxime, could you refresh my memory with the
details?

Best regards,
Tomasz

>
> Regards,
>
>         Hans
>
> >
> > Signed-off-by: Maxime Jourdan <mjourdan@baylibre.com>
> > ---
> >  Documentation/media/uapi/v4l/vidioc-enum-fmt.rst | 5 +++++
> >  include/uapi/linux/videodev2.h                   | 5 +++--
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
> > index 019c513df217..e0040b36ac43 100644
> > --- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
> > +++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
> > @@ -116,6 +116,11 @@ one until ``EINVAL`` is returned.
> >        - This format is not native to the device but emulated through
> >       software (usually libv4l2), where possible try to use a native
> >       format instead for better performance.
> > +    * - ``V4L2_FMT_FLAG_NO_SOURCE_CHANGE``
> > +      - 0x0004
> > +      - The event ``V4L2_EVENT_SOURCE_CHANGE`` is not supported
> > +     for this format.
> > +
> >
> >
> >  Return Value
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > index 3a65951ca51e..a28acee1cb52 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -723,8 +723,9 @@ struct v4l2_fmtdesc {
> >       __u32               reserved[4];
> >  };
> >
> > -#define V4L2_FMT_FLAG_COMPRESSED 0x0001
> > -#define V4L2_FMT_FLAG_EMULATED   0x0002
> > +#define V4L2_FMT_FLAG_COMPRESSED     0x0001
> > +#define V4L2_FMT_FLAG_EMULATED               0x0002
> > +#define V4L2_FMT_FLAG_NO_SOURCE_CHANGE       0x0004
> >
> >       /* Frame Size and frame rate enumeration */
> >  /*
> >
>
