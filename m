Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:34236 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbeHFQUO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 12:20:14 -0400
Received: by mail-yb0-f193.google.com with SMTP id e9-v6so5343794ybq.1
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2018 07:10:56 -0700 (PDT)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id e85-v6sm623496ywa.77.2018.08.06.07.10.53
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Aug 2018 07:10:54 -0700 (PDT)
Received: by mail-yw1-f54.google.com with SMTP id j68-v6so3631891ywg.1
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2018 07:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
 <20180725100256.22833-5-paul.kocialkowski@bootlin.com> <b45a8a89-1313-7a08-206d-b93017724754@xs4all.nl>
 <dba0f9496b393c76f355398018b14ae06b2b18c9.camel@bootlin.com>
In-Reply-To: <dba0f9496b393c76f355398018b14ae06b2b18c9.camel@bootlin.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 6 Aug 2018 23:10:40 +0900
Message-ID: <CAAFQd5DgFDFupACthsz1iLpAeYRtUtEfzQC1E5XZQ6gPZAYi1Q@mail.gmail.com>
Subject: Re: [PATCH v6 4/8] media: platform: Add Cedrus VPU decoder driver
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
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

Hi Paul,

On Mon, Aug 6, 2018 at 10:50 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> Hi Hans and thanks for the review!
>
> On Sat, 2018-08-04 at 14:18 +0200, Hans Verkuil wrote:
> > Hi Paul,
> >
> > See below for my review comments. Mostly small fry, the main issue I found is
> > that there is no support for VIDIOC_DECODER_CMD. That's the proper way of
> > stopping a decoder. Don't rely on the deprecated allow_zero_bytesused field.
>
> Mhh, it looks like this was kept around by negligence, but we do expect
> that streamoff stops the decoder, not a zero bytesused field.
>
> Is it still required to implement the V4L2_DEC_CMD_STOP
> VIDIOC_DECODER_CMD in that case? I read in the doc that this ioctl
> should be optional.

If I understand correctly that this decoder is stateless, there should
be no need for any special flush sequence, since a 1:1 relation
between OUTPUT and CAPTURE buffers is expected, which means that
userspace can just stop queuing new OUTPUT buffers and keep dequeuing
CAPTURE buffers until it matches all OUTPUT buffers queued before.

By the way, I guess we will also need some documentation for the
stateless codec interface. Do you or Maxime (who sent the H264 part)
have any plans to work on it? We have some internal documents, which
should be convertible to rst using pandoc, but we might need some help
with updating to latest request API and further editing. Alexandre
(moved from Cc to To) is going to be looking into this.

Best regards,
Tomasz
