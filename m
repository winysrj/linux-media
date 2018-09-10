Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:46855 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbeIJI0w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 04:26:52 -0400
Received: by mail-yb1-f194.google.com with SMTP id y20-v6so7416966ybi.13
        for <linux-media@vger.kernel.org>; Sun, 09 Sep 2018 20:34:58 -0700 (PDT)
Received: from mail-yw1-f47.google.com (mail-yw1-f47.google.com. [209.85.161.47])
        by smtp.gmail.com with ESMTPSA id m82-v6sm6863821ywm.19.2018.09.09.20.34.57
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Sep 2018 20:34:57 -0700 (PDT)
Received: by mail-yw1-f47.google.com with SMTP id i144-v6so1597928ywc.3
        for <linux-media@vger.kernel.org>; Sun, 09 Sep 2018 20:34:57 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-3-tfiga@chromium.org>
 <19062a24c3aa2cb9e0410cf2884b4589e44c263b.camel@collabora.com>
In-Reply-To: <19062a24c3aa2cb9e0410cf2884b4589e44c263b.camel@collabora.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 10 Sep 2018 12:34:45 +0900
Message-ID: <CAAFQd5A2xskpHpm8XqWoNKGt9As53Pft1NO32Ziys+PEJ2fh1A@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
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
        dave.stevenson@raspberrypi.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 8, 2018 at 5:17 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
>
> On Tue, 2018-07-24 at 23:06 +0900, Tomasz Figa wrote:
[snip]
> > +Querying capabilities
> > +=====================
> > +
> > +1. To enumerate the set of coded formats supported by the driver, the
> > +   client may call :c:func:`VIDIOC_ENUM_FMT` on ``CAPTURE``.
> > +
> > +   * The driver must always return the full set of supported formats,
> > +     irrespective of the format set on the ``OUTPUT`` queue.
> > +
> > +2. To enumerate the set of supported raw formats, the client may call
> > +   :c:func:`VIDIOC_ENUM_FMT` on ``OUTPUT``.
> > +
> > +   * The driver must return only the formats supported for the format
> > +     currently active on ``CAPTURE``.
> > +
>
> Paul and I where discussing about the default active format on CAPTURE
> and OUTPUT queues. That is, the format that is active (if any) right
> after driver probes.
>
> Currently, the v4l2-compliance tool tests the default active format,
> by requiring drivers to support:
>
>     fmt = g_fmt()
>     s_fmt(fmt)
>
> Is this actually required? Should we also require this for stateful
> and stateless codecs? If yes, should it be documented?

The general V4L2 principle is that drivers must maintain some sane
default state right from when they are exposed to the userspace. I'd
try to stick to the common V4L2 semantics, unless there is a very good
reason not to do so.

Note that we actually diverged from it on CAPTURE state for stateful
decoders, because we return an error, if any format-related ioctl is
called on CAPTURE queue before OUTPUT queue is initialized with a
valid coded format, either explicitly by the client or implicitly via
bitstream parsing. The reason was backwards compatibility with clients
which don't handle source change events. If that wasn't the case, we
could have made the CAPTURE queue completely independent and have the
format there reset with source change event, whenever it becomes
invalid due to things like resolution change or speculative
initialization miss, which would make things much more symmetrical.

Best regards,
Tomasz
