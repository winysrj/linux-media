Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f43.google.com ([209.85.161.43]:42712 "EHLO
        mail-yw1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbeH0Hsg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 03:48:36 -0400
Received: by mail-yw1-f43.google.com with SMTP id n207-v6so5105980ywn.9
        for <linux-media@vger.kernel.org>; Sun, 26 Aug 2018 21:03:46 -0700 (PDT)
Received: from mail-yw1-f45.google.com (mail-yw1-f45.google.com. [209.85.161.45])
        by smtp.gmail.com with ESMTPSA id s63-v6sm6107845ywd.63.2018.08.26.21.03.43
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Aug 2018 21:03:43 -0700 (PDT)
Received: by mail-yw1-f45.google.com with SMTP id m62-v6so3614380ywd.6
        for <linux-media@vger.kernel.org>; Sun, 26 Aug 2018 21:03:43 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <1534770242.5445.13.camel@pengutronix.de> <CAAFQd5BBOh7nPZ70aaWiSuygGSOTiAQrOm0V9UPgFqqBgZf_LA@mail.gmail.com>
 <1534774398.5445.32.camel@pengutronix.de> <CAAFQd5ACR7wQO7k6PfBg2rJEe81pQvnCzd2yp8AEkU+iLXQXPw@mail.gmail.com>
 <1534779232.5445.34.camel@pengutronix.de>
In-Reply-To: <1534779232.5445.34.camel@pengutronix.de>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 27 Aug 2018 13:03:31 +0900
Message-ID: <CAAFQd5BuUaW45+jLCn6TAkEBogfcWAGgZSPwLygFGsEsE5XZ2A@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Pawel Osciak <posciak@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
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

Hi Philipp,

On Tue, Aug 21, 2018 at 12:34 AM Philipp Zabel <p.zabel@pengutronix.de> wrote:
>
> On Mon, 2018-08-20 at 23:27 +0900, Tomasz Figa wrote:
> [...]
> > +3. Start queuing buffers to ``OUTPUT`` queue containing stream data after
> > > > > > +   the seek until a suitable resume point is found.
> > > > > > +
> > > > > > +   .. note::
> > > > > > +
> > > > > > +      There is no requirement to begin queuing stream starting exactly from
> > > > > > +      a resume point (e.g. SPS or a keyframe). The driver must handle any
> > > > > > +      data queued and must keep processing the queued buffers until it
> > > > > > +      finds a suitable resume point. While looking for a resume point, the
> > > > >
> > > > > I think the definition of a resume point is too vague in this place.
> > > > > Can the driver decide whether or not a keyframe without SPS is a
> > > > > suitable resume point? Or do drivers have to parse and store SPS/PPS if
> > > > > the hardware does not support resuming from a keyframe without sending
> > > > > SPS/PPS again?
> > > >
> > > > The thing is that existing drivers implement and user space clients
> > > > rely on the behavior described above, so we cannot really change it
> > > > anymore.
> > >
> > > My point is that I'm not exactly sure what that behaviour is, given the
> > > description.
> > >
> > > Must a driver be able to resume from a keyframe even if userspace never
> > > pushes SPS/PPS again?
> > > If so, I think it should be mentioned more explicitly than just via an
> > > example in parentheses, to make it clear to all driver developers that
> > > this is a requirement that userspace is going to rely on.
> > >
> > > Or, if that is not the case, is a driver free to define "SPS only" as
> > > its "suitable resume point" and to discard all input including keyframes
> > > until the next SPS/PPS is pushed?
> > >
> > > It would be better to clearly define what a "suitable resume point" has
> > > to be per codec, and not let the drivers decide for themselves, if at
> > > all possible. Otherwise we'd need a away to inform userspace about the
> > > per-driver definition.
> >
> > The intention here is that there is exactly no requirement for the
> > user space to seek to any kind of resume point
>
> No question about this.
>
> > and so there is no point in defining such.
>
> I don't agree. Let me give an example:
>
> Assume userspace wants to play back a simple h.264 stream that has
> SPS/PPS exactly once, in the beginning.
>
> If drivers are allowed to resume from SPS/PPS only, and have no way to
> communicate this to userspace, userspace always has to assume that
> resuming from keyframes alone is not possible. So it has to store
> SPS/PPS and resubmit them with every seek, even if a specific driver
> wouldn't require it: Otherwise those drivers that don't store SPS/PPS
> themselves (or in hardware) would be allowed to just drop everything
> after the first seek.
> This effectively would make resending SPS/PPS mandatory, which doesn't
> fit well with the intention of letting userspace just seek anywhere and
> start feeding data (or: NAL units) into the driver blindly.
>

I'd say that such video is broken by design, because you cannot play
back any arbitrary later part of it without decoding it from the
beginning.

However, if the hardware keeps SPS/PPS across seeks (and that should
normally be the case), the case could be handled by the user space
letting the decoder initialize with the first frames and only then
seeking, which would probably be the typical case of a user opening a
video file and then moving the seek bar to desired position (or
clicking a bookmark).

If the hardware doesn't keep SPS/PPS across seeks, stateless API could
arguably be a better candidate for it, since it mandates the user
space to keep SPS/PPS around.

> > The only requirement here is that the
> > hardware/driver keeps processing the source stream until it finds a
> > resume point suitable for it - if the hardware keeps SPS/PPS in its
> > state then just a keyframe; if it doesn't then SPS/PPS.
>
> Yes, but the difference between those two might be very relevant to
> userspace behaviour.
>
> > Note that this is a documentation of the user space API, not a driver
> > implementation guide. We may want to create the latter separately,
> > though.
>
> This is a good point, I keep switching the perspective from which I look
> at this document.
> Even for userspace it would make sense to be as specific as possible,
> though. Otherwise, doesn't userspace always have to assume the worst?
>

That's right, a generic user space is expected to handle all the
possible cases possible with the interface it's using. This is
precisely why I'd like to avoid introducing the case where user space
needs to carry state around. The API is for stateful hardware, which
is expected to carry all the needed state around itself.

> > H264 is a bit special here, because one may still seek to a key frame,
> > but past the relevant SPS/PPS headers. In this case, there is no way
> > for the hardware to know that the SPS/PPS it has in its local state is
> > not the one that applies to the frame. It may be worth adding that
> > such case leads to undefined results, but must not cause crash nor a
> > fatal decode error.
> >
> > What do you think?
>
> That sounds like a good idea. I haven't thought about seeking over a
> SPS/PPS change. Of course userspace must not expect correct results in
> this case without providing the new SPS/PPS.
>

>From what I talked with Pawel, our hardware (s5p-mfc, mtk-vcodec) will
just notice that the frames refer to a different SPS/PPS (based on
seq_parameter_set_id, I assume) and keep dropping frames until next
corresponding header is encountered.

> > > > Do we have hardware for which this wouldn't work to the point that the
> > > > driver couldn't even continue with a bunch of frames corrupted? If
> > > > only frame corruption is a problem, we can add a control to tell the
> > > > user space to seek to resume points and it can happen in an
> > > > incremental patch.
> > >
> > > The coda driver currently can't seek at all, it always stops and
> > > restarts the sequence. So depending on the above I might have to either
> > > find and store SPS/PPS in software, or figure out how to make the
> > > firmware flush the bitstream buffer and restart without actually
> > > stopping the sequence.
> > > I'm sure the hardware is capable of this, it's more a question of what
> > > behaviour is actually intended, and whether I have enough information
> > > about the firmware interface to implement it.
> >
> > What happens if you just keep feeding it with next frames?
>
> As long as they are well formed, it should just decode them, possibly
> with artifacts due to mismatched reference buffers. There is an I-Frame
> search mode that should be usable to skip to the next resume point, as
> well, so I'm sure coda will end up not needing the
> NEEDS_SEEK_TO_RESUME_POINT flag below. I'm just not certain at this
> point whether I'll be able to (or: whether I'll have to) keep the
> SPS/PPS state across seeks. I have seen so many decoder hangs with
> malformed input on i.MX53 that I couldn't recover from, that I'm wary
> to make any guarantees without flushing the bitstream buffer first.

Based on the above, I believe the answer is that your hardware/driver
needs to keep SPS/PPS around. Is there a good way to do it with Coda?
We definitely don't want to do any parsing inside the driver.

>
> > If that would result only in corrupted frames, I suppose the control (say
> > V4L2_CID_MPEG_VIDEO_NEEDS_SEEK_TO_RESUME_POINT) would solve the
> > problem?
>
> For this to be useful, userspace needs to know what a resume point is in
> the first place, though.

That would be defined in the context of that control and particular
pixel format, since there is no general, yet precise enough definition
that could apply to all codecs. Right now, I would like to defer
adding such constraints until there is really a hardware which needs
it and it can't be handled using stateless API.

Best regards,
Tomasz
