Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:46459 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbeHTQ20 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 12:28:26 -0400
Received: by mail-yw1-f67.google.com with SMTP id j131-v6so1020411ywc.13
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2018 06:12:50 -0700 (PDT)
Received: from mail-yb0-f177.google.com (mail-yb0-f177.google.com. [209.85.213.177])
        by smtp.gmail.com with ESMTPSA id q194-v6sm4594849ywg.91.2018.08.20.06.12.47
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Aug 2018 06:12:48 -0700 (PDT)
Received: by mail-yb0-f177.google.com with SMTP id l16-v6so4553625ybk.11
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2018 06:12:47 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <1534770242.5445.13.camel@pengutronix.de>
In-Reply-To: <1534770242.5445.13.camel@pengutronix.de>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 20 Aug 2018 22:12:35 +0900
Message-ID: <CAAFQd5BBOh7nPZ70aaWiSuygGSOTiAQrOm0V9UPgFqqBgZf_LA@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 20, 2018 at 10:04 PM Philipp Zabel <p.zabel@pengutronix.de> wrote:
>
> On Tue, 2018-07-24 at 23:06 +0900, Tomasz Figa wrote:
> [...]
> > +Seek
> > +====
> > +
> > +Seek is controlled by the ``OUTPUT`` queue, as it is the source of
> > +bitstream data. ``CAPTURE`` queue remains unchanged/unaffected.
> > +
> > +1. Stop the ``OUTPUT`` queue to begin the seek sequence via
> > +   :c:func:`VIDIOC_STREAMOFF`.
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +   * The driver must drop all the pending ``OUTPUT`` buffers and they are
> > +     treated as returned to the client (following standard semantics).
> > +
> > +2. Restart the ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +   * The driver must be put in a state after seek and be ready to
> > +     accept new source bitstream buffers.
> > +
> > +3. Start queuing buffers to ``OUTPUT`` queue containing stream data after
> > +   the seek until a suitable resume point is found.
> > +
> > +   .. note::
> > +
> > +      There is no requirement to begin queuing stream starting exactly from
> > +      a resume point (e.g. SPS or a keyframe). The driver must handle any
> > +      data queued and must keep processing the queued buffers until it
> > +      finds a suitable resume point. While looking for a resume point, the
>
> I think the definition of a resume point is too vague in this place.
> Can the driver decide whether or not a keyframe without SPS is a
> suitable resume point? Or do drivers have to parse and store SPS/PPS if
> the hardware does not support resuming from a keyframe without sending
> SPS/PPS again?

The thing is that existing drivers implement and user space clients
rely on the behavior described above, so we cannot really change it
anymore.

Do we have hardware for which this wouldn't work to the point that the
driver couldn't even continue with a bunch of frames corrupted? If
only frame corruption is a problem, we can add a control to tell the
user space to seek to resume points and it can happen in an
incremental patch.

Best regards,
Tomasz
