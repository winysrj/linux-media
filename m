Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:46391 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbeJILoG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 07:44:06 -0400
Received: by mail-yb1-f196.google.com with SMTP id o8-v6so92059ybk.13
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2018 21:29:08 -0700 (PDT)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id r5-v6sm14749619ywr.80.2018.10.08.21.29.07
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Oct 2018 21:29:07 -0700 (PDT)
Received: by mail-yw1-f54.google.com with SMTP id e201-v6so110068ywa.3
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2018 21:29:07 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <37a8faea-a226-2d52-36d4-f9df194623cc@xs4all.nl> <CAAFQd5BgGEBmd8gNGc-qqtUtLo=Mh8U+TVTWRsKYMv1LmeBQMA@mail.gmail.com>
 <CAAFQd5Ba+8_wpCr2D2OUSRt-PbRUPk4MV1OxMzEetntL169fBA@mail.gmail.com> <1dc5fd0b-61f0-545a-fea6-bd90721e144b@xs4all.nl>
In-Reply-To: <1dc5fd0b-61f0-545a-fea6-bd90721e144b@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 9 Oct 2018 13:23:47 +0900
Message-ID: <CAAFQd5DKhed1M8X61VjBd0gXtJb-8qrz5ncPyppff5LmyoqO8w@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 8, 2018 at 9:22 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 09/19/2018 12:17 PM, Tomasz Figa wrote:
> > Hi Hans,
> >
> > On Thu, Jul 26, 2018 at 7:20 PM Tomasz Figa <tfiga@chromium.org> wrote:
> >>
> >> Hi Hans,
> >>
> >> On Wed, Jul 25, 2018 at 8:59 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>>
> >>> Hi Tomasz,
> >>>
> >>> Many, many thanks for working on this! It's a great document and when done
> >>> it will be very useful indeed.
> >>>
> >>> Review comments follow...
> >>
> >> Thanks for review!
> >>
> >>>
> >>> On 24/07/18 16:06, Tomasz Figa wrote:
> > [snip]
> >>>> +13. Allocate destination (raw format) buffers via :c:func:`VIDIOC_REQBUFS`
> >>>> +    on the ``CAPTURE`` queue.
> >>>> +
> >>>> +    * **Required fields:**
> >>>> +
> >>>> +      ``count``
> >>>> +          requested number of buffers to allocate; greater than zero
> >>>> +
> >>>> +      ``type``
> >>>> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> >>>> +
> >>>> +      ``memory``
> >>>> +          follows standard semantics
> >>>> +
> >>>> +    * **Return fields:**
> >>>> +
> >>>> +      ``count``
> >>>> +          adjusted to allocated number of buffers
> >>>> +
> >>>> +    * The driver must adjust count to minimum of required number of
> >>>> +      destination buffers for given format and stream configuration and the
> >>>> +      count passed. The client must check this value after the ioctl
> >>>> +      returns to get the number of buffers allocated.
> >>>> +
> >>>> +    .. note::
> >>>> +
> >>>> +       To allocate more than minimum number of buffers (for pipeline
> >>>> +       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``) to
> >>>> +       get minimum number of buffers required, and pass the obtained value
> >>>> +       plus the number of additional buffers needed in count to
> >>>> +       :c:func:`VIDIOC_REQBUFS`.
> >>>
> >>>
> >>> I think we should mention here the option of using VIDIOC_CREATE_BUFS in order
> >>> to allocate buffers larger than the current CAPTURE format in order to accommodate
> >>> future resolution changes.
> >>
> >> Ack.
> >>
> >
> > I'm about to add a paragraph to describe this, but there is one detail
> > to iron out.
> >
> > The VIDIOC_CREATE_BUFS ioctl accepts a v4l2_format struct. Userspace
> > needs to fill in this struct and the specs says that
> >
> >   "Usually this will be done using the VIDIOC_TRY_FMT or VIDIOC_G_FMT
> > ioctls to ensure that the requested format is supported by the
> > driver."
> >
> > However, in case of a decoder, those calls would fixup the format to
> > match the currently parsed stream, which would likely resolve to the
> > current coded resolution (~hardware alignment). How do we get a format
> > for the desired maximum resolution?
>
> You would call G_FMT to get the current format/resolution, then update
> width and height and call TRY_FMT.
>
> Although to be honest you can also just set pixelformat and width/height
> and zero everything else and call TRY_FMT directly, skipping the G_FMT
> ioctl.
>

Wouldn't TRY_FMT adjust the width and height back to match current stream?

Best regards,
Tomasz
