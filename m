Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:44924 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbeHHFeM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 01:34:12 -0400
Received: by mail-yw1-f68.google.com with SMTP id l9-v6so540717ywc.11
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 20:16:43 -0700 (PDT)
Received: from mail-yw1-f46.google.com (mail-yw1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id z125-v6sm3749352ywg.57.2018.08.07.20.16.40
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Aug 2018 20:16:41 -0700 (PDT)
Received: by mail-yw1-f46.google.com with SMTP id r184-v6so551400ywg.6
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 20:16:40 -0700 (PDT)
MIME-Version: 1.0
References: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
 <20180725100256.22833-5-paul.kocialkowski@bootlin.com> <b45a8a89-1313-7a08-206d-b93017724754@xs4all.nl>
 <dba0f9496b393c76f355398018b14ae06b2b18c9.camel@bootlin.com>
 <CAAFQd5DgFDFupACthsz1iLpAeYRtUtEfzQC1E5XZQ6gPZAYi1Q@mail.gmail.com> <94e3eaf26ed7d6859d74abad0a0dbc94a3308a2e.camel@bootlin.com>
In-Reply-To: <94e3eaf26ed7d6859d74abad0a0dbc94a3308a2e.camel@bootlin.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 8 Aug 2018 12:16:28 +0900
Message-ID: <CAAFQd5A-EbQixAq7Umk6mgHvEmjjSvrwNL8GTGF-pmgswtn2ig@mail.gmail.com>
Subject: Re: [PATCH v6 4/8] media: platform: Add Cedrus VPU decoder driver
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        thomas.petazzoni@bootlin.com, linux-sunxi@googlegroups.com,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        ayaka <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 7, 2018 at 4:20 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> Hi,
>
> On Mon, 2018-08-06 at 23:10 +0900, Tomasz Figa wrote:
> > Hi Paul,
> >
> > On Mon, Aug 6, 2018 at 10:50 PM Paul Kocialkowski
> > <paul.kocialkowski@bootlin.com> wrote:
> > >
> > > Hi Hans and thanks for the review!
> > >
> > > On Sat, 2018-08-04 at 14:18 +0200, Hans Verkuil wrote:
> > > > Hi Paul,
> > > >
> > > > See below for my review comments. Mostly small fry, the main issue I found is
> > > > that there is no support for VIDIOC_DECODER_CMD. That's the proper way of
> > > > stopping a decoder. Don't rely on the deprecated allow_zero_bytesused field.
> > >
> > > Mhh, it looks like this was kept around by negligence, but we do expect
> > > that streamoff stops the decoder, not a zero bytesused field.
> > >
> > > Is it still required to implement the V4L2_DEC_CMD_STOP
> > > VIDIOC_DECODER_CMD in that case? I read in the doc that this ioctl
> > > should be optional.
> >
> > If I understand correctly that this decoder is stateless, there should
> > be no need for any special flush sequence, since a 1:1 relation
> > between OUTPUT and CAPTURE buffers is expected, which means that
> > userspace can just stop queuing new OUTPUT buffers and keep dequeuing
> > CAPTURE buffers until it matches all OUTPUT buffers queued before.
>
> This is indeed a stateless decoder and I don't have any particular need
> for a particular stop command indeed, since flushing remaining buffers
> when stopping is already implemented at streamoff time.
>

Do you mean implemented in user space or the driver? Obviously the
latter is against the API specification, since VIDIOC_STREAMOFF is
expected to instantly stop any pending hardware operations and
gracefully discard any queued buffers or processing results.

> > By the way, I guess we will also need some documentation for the
> > stateless codec interface. Do you or Maxime (who sent the H264 part)
> > have any plans to work on it? We have some internal documents, which
> > should be convertible to rst using pandoc, but we might need some help
> > with updating to latest request API and further editing. Alexandre
> > (moved from Cc to To) is going to be looking into this.
>
> As far as I'm concerned, I am interested in contributing to this
> documentation although our priorities for the Allwinner VPU effort are
> currently focused on H265 support. This might mean that my contributions
> to this documentation will be made on a best-effort basis (as opposed to
> during the workday). Either way, if someone was to come up with an
> initial draft, I'd be happy to review it!

I've talked with Alex and he should be able to convert our internal
document and post it as the initial draft RFC. Help with review will
be definitely appreciated, thanks!

Note that we shouldn't repeat the same mistake as with stateful codecs
and allow merging drivers without the API being specified. That led to
drivers doing this their own ways and having to account for those
quirks in the stateful codec API specification we're working on right
now.

Best regards,
Tomasz
