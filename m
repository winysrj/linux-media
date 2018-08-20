Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51719 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbeHTSuG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 14:50:06 -0400
Message-ID: <1534779232.5445.34.camel@pengutronix.de>
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
Date: Mon, 20 Aug 2018 17:33:52 +0200
In-Reply-To: <CAAFQd5ACR7wQO7k6PfBg2rJEe81pQvnCzd2yp8AEkU+iLXQXPw@mail.gmail.com>
References: <20180724140621.59624-1-tfiga@chromium.org>
         <20180724140621.59624-2-tfiga@chromium.org>
         <1534770242.5445.13.camel@pengutronix.de>
         <CAAFQd5BBOh7nPZ70aaWiSuygGSOTiAQrOm0V9UPgFqqBgZf_LA@mail.gmail.com>
         <1534774398.5445.32.camel@pengutronix.de>
         <CAAFQd5ACR7wQO7k6PfBg2rJEe81pQvnCzd2yp8AEkU+iLXQXPw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-08-20 at 23:27 +0900, Tomasz Figa wrote:
[...]
> +3. Start queuing buffers to ``OUTPUT`` queue containing stream data after
> > > > > +   the seek until a suitable resume point is found.
> > > > > +
> > > > > +   .. note::
> > > > > +
> > > > > +      There is no requirement to begin queuing stream starting exactly from
> > > > > +      a resume point (e.g. SPS or a keyframe). The driver must handle any
> > > > > +      data queued and must keep processing the queued buffers until it
> > > > > +      finds a suitable resume point. While looking for a resume point, the
> > > > 
> > > > I think the definition of a resume point is too vague in this place.
> > > > Can the driver decide whether or not a keyframe without SPS is a
> > > > suitable resume point? Or do drivers have to parse and store SPS/PPS if
> > > > the hardware does not support resuming from a keyframe without sending
> > > > SPS/PPS again?
> > > 
> > > The thing is that existing drivers implement and user space clients
> > > rely on the behavior described above, so we cannot really change it
> > > anymore.
> > 
> > My point is that I'm not exactly sure what that behaviour is, given the
> > description.
> > 
> > Must a driver be able to resume from a keyframe even if userspace never
> > pushes SPS/PPS again?
> > If so, I think it should be mentioned more explicitly than just via an
> > example in parentheses, to make it clear to all driver developers that
> > this is a requirement that userspace is going to rely on.
> > 
> > Or, if that is not the case, is a driver free to define "SPS only" as
> > its "suitable resume point" and to discard all input including keyframes
> > until the next SPS/PPS is pushed?
> > 
> > It would be better to clearly define what a "suitable resume point" has
> > to be per codec, and not let the drivers decide for themselves, if at
> > all possible. Otherwise we'd need a away to inform userspace about the
> > per-driver definition.
> 
> The intention here is that there is exactly no requirement for the
> user space to seek to any kind of resume point

No question about this.

> and so there is no point in defining such.

I don't agree. Let me give an example:

Assume userspace wants to play back a simple h.264 stream that has
SPS/PPS exactly once, in the beginning.

If drivers are allowed to resume from SPS/PPS only, and have no way to
communicate this to userspace, userspace always has to assume that
resuming from keyframes alone is not possible. So it has to store
SPS/PPS and resubmit them with every seek, even if a specific driver
wouldn't require it: Otherwise those drivers that don't store SPS/PPS
themselves (or in hardware) would be allowed to just drop everything
after the first seek.
This effectively would make resending SPS/PPS mandatory, which doesn't
fit well with the intention of letting userspace just seek anywhere and
start feeding data (or: NAL units) into the driver blindly.

> The only requirement here is that the
> hardware/driver keeps processing the source stream until it finds a
> resume point suitable for it - if the hardware keeps SPS/PPS in its
> state then just a keyframe; if it doesn't then SPS/PPS.

Yes, but the difference between those two might be very relevant to
userspace behaviour.

> Note that this is a documentation of the user space API, not a driver
> implementation guide. We may want to create the latter separately,
> though.

This is a good point, I keep switching the perspective from which I look
at this document.
Even for userspace it would make sense to be as specific as possible,
though. Otherwise, doesn't userspace always have to assume the worst?

> H264 is a bit special here, because one may still seek to a key frame,
> but past the relevant SPS/PPS headers. In this case, there is no way
> for the hardware to know that the SPS/PPS it has in its local state is
> not the one that applies to the frame. It may be worth adding that
> such case leads to undefined results, but must not cause crash nor a
> fatal decode error.
> 
> What do you think?

That sounds like a good idea. I haven't thought about seeking over a
SPS/PPS change. Of course userspace must not expect correct results in
this case without providing the new SPS/PPS.

> > > Do we have hardware for which this wouldn't work to the point that the
> > > driver couldn't even continue with a bunch of frames corrupted? If
> > > only frame corruption is a problem, we can add a control to tell the
> > > user space to seek to resume points and it can happen in an
> > > incremental patch.
> > 
> > The coda driver currently can't seek at all, it always stops and
> > restarts the sequence. So depending on the above I might have to either
> > find and store SPS/PPS in software, or figure out how to make the
> > firmware flush the bitstream buffer and restart without actually
> > stopping the sequence.
> > I'm sure the hardware is capable of this, it's more a question of what
> > behaviour is actually intended, and whether I have enough information
> > about the firmware interface to implement it.
> 
> What happens if you just keep feeding it with next frames?

As long as they are well formed, it should just decode them, possibly
with artifacts due to mismatched reference buffers. There is an I-Frame
search mode that should be usable to skip to the next resume point, as
well, so I'm sure coda will end up not needing the
NEEDS_SEEK_TO_RESUME_POINT flag below. I'm just not certain at this
point whether I'll be able to (or: whether I'll have to) keep the
SPS/PPS state across seeks. I have seen so many decoder hangs with
malformed input on i.MX53 that I couldn't recover from, that I'm wary
to make any guarantees without flushing the bitstream buffer first.

> If that would result only in corrupted frames, I suppose the control (say
> V4L2_CID_MPEG_VIDEO_NEEDS_SEEK_TO_RESUME_POINT) would solve the
> problem?

For this to be useful, userspace needs to know what a resume point is in
the first place, though.

regards
Philipp
