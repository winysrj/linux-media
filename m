Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60549 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbeHTR3M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 13:29:12 -0400
Message-ID: <1534774398.5445.32.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com,
        Tiffany Lin =?UTF-8?Q?=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?=
        <tiffany.lin@mediatek.com>,
        Andrew-CT Chen =?UTF-8?Q?=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Date: Mon, 20 Aug 2018 16:13:18 +0200
In-Reply-To: <CAAFQd5BBOh7nPZ70aaWiSuygGSOTiAQrOm0V9UPgFqqBgZf_LA@mail.gmail.com>
References: <20180724140621.59624-1-tfiga@chromium.org>
         <20180724140621.59624-2-tfiga@chromium.org>
         <1534770242.5445.13.camel@pengutronix.de>
         <CAAFQd5BBOh7nPZ70aaWiSuygGSOTiAQrOm0V9UPgFqqBgZf_LA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Mon, 2018-08-20 at 22:12 +0900, Tomasz Figa wrote:
> On Mon, Aug 20, 2018 at 10:04 PM Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > 
> > On Tue, 2018-07-24 at 23:06 +0900, Tomasz Figa wrote:
> > [...]
> > > +Seek
> > > +====
> > > +
> > > +Seek is controlled by the ``OUTPUT`` queue, as it is the source of
> > > +bitstream data. ``CAPTURE`` queue remains unchanged/unaffected.
> > > +
> > > +1. Stop the ``OUTPUT`` queue to begin the seek sequence via
> > > +   :c:func:`VIDIOC_STREAMOFF`.
> > > +
> > > +   * **Required fields:**
> > > +
> > > +     ``type``
> > > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > > +
> > > +   * The driver must drop all the pending ``OUTPUT`` buffers and they are
> > > +     treated as returned to the client (following standard semantics).
> > > +
> > > +2. Restart the ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`
> > > +
> > > +   * **Required fields:**
> > > +
> > > +     ``type``
> > > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > > +
> > > +   * The driver must be put in a state after seek and be ready to
> > > +     accept new source bitstream buffers.
> > > +
> > > +3. Start queuing buffers to ``OUTPUT`` queue containing stream data after
> > > +   the seek until a suitable resume point is found.
> > > +
> > > +   .. note::
> > > +
> > > +      There is no requirement to begin queuing stream starting exactly from
> > > +      a resume point (e.g. SPS or a keyframe). The driver must handle any
> > > +      data queued and must keep processing the queued buffers until it
> > > +      finds a suitable resume point. While looking for a resume point, the
> > 
> > I think the definition of a resume point is too vague in this place.
> > Can the driver decide whether or not a keyframe without SPS is a
> > suitable resume point? Or do drivers have to parse and store SPS/PPS if
> > the hardware does not support resuming from a keyframe without sending
> > SPS/PPS again?
> 
> The thing is that existing drivers implement and user space clients
> rely on the behavior described above, so we cannot really change it
> anymore.

My point is that I'm not exactly sure what that behaviour is, given the
description.

Must a driver be able to resume from a keyframe even if userspace never
pushes SPS/PPS again?
If so, I think it should be mentioned more explicitly than just via an
example in parentheses, to make it clear to all driver developers that
this is a requirement that userspace is going to rely on.

Or, if that is not the case, is a driver free to define "SPS only" as
its "suitable resume point" and to discard all input including keyframes
until the next SPS/PPS is pushed?

It would be better to clearly define what a "suitable resume point" has
to be per codec, and not let the drivers decide for themselves, if at
all possible. Otherwise we'd need a away to inform userspace about the
per-driver definition.

> Do we have hardware for which this wouldn't work to the point that the
> driver couldn't even continue with a bunch of frames corrupted? If
> only frame corruption is a problem, we can add a control to tell the
> user space to seek to resume points and it can happen in an
> incremental patch.

The coda driver currently can't seek at all, it always stops and
restarts the sequence. So depending on the above I might have to either
find and store SPS/PPS in software, or figure out how to make the
firmware flush the bitstream buffer and restart without actually
stopping the sequence.
I'm sure the hardware is capable of this, it's more a question of what
behaviour is actually intended, and whether I have enough information
about the firmware interface to implement it.

regards
Philipp
