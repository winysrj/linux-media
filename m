Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:46351 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbeHVQ5W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 12:57:22 -0400
Received: by mail-yb0-f194.google.com with SMTP id y20-v6so643703ybi.13
        for <linux-media@vger.kernel.org>; Wed, 22 Aug 2018 06:32:26 -0700 (PDT)
Received: from mail-yb0-f175.google.com (mail-yb0-f175.google.com. [209.85.213.175])
        by smtp.gmail.com with ESMTPSA id n187-v6sm1055619ywn.76.2018.08.22.06.32.24
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Aug 2018 06:32:24 -0700 (PDT)
Received: by mail-yb0-f175.google.com with SMTP id l16-v6so646518ybk.11
        for <linux-media@vger.kernel.org>; Wed, 22 Aug 2018 06:32:24 -0700 (PDT)
MIME-Version: 1.0
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
 <20180613140714.1686-2-maxime.ripard@bootlin.com> <80e1d9cb49c6df06843e49332685f2b401023292.camel@collabora.com>
 <20180822091557.gtnlgoebyv6yttzf@flea> <CAAFQd5ANvKF2+GEXQTnRsdYVzJTtBOhv7nFahV=2W-9_QXwY4g@mail.gmail.com>
 <e6324ea983d34403199044ae30e932cd728c8ad4.camel@bootlin.com>
In-Reply-To: <e6324ea983d34403199044ae30e932cd728c8ad4.camel@bootlin.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 22 Aug 2018 22:24:23 +0900
Message-ID: <CAAFQd5AybueM-rhy8bMbRHHZmwBP08-cWB11NadcUQAb6XJ1SA@mail.gmail.com>
Subject: Re: [PATCH 1/9] CHROMIUM: v4l: Add H264 low-level decoder API
 compound controls.
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Pawel Osciak <posciak@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        jenskuske@gmail.com, linux-sunxi@googlegroups.com,
        thomas.petazzoni@bootlin.com, groeck@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 22, 2018 at 10:03 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> Hi,
>
> On Wed, 2018-08-22 at 18:54 +0900, Tomasz Figa wrote:
> > On Wed, Aug 22, 2018 at 6:16 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > >
> > > Hi,
> > >
> > > On Tue, Aug 21, 2018 at 01:58:38PM -0300, Ezequiel Garcia wrote:
> > > > On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> > > > > From: Pawel Osciak <posciak@chromium.org>
> > > > >
> > > > > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > > > > Reviewed-by: Wu-cheng Li <wuchengli@chromium.org>
> > > > > Tested-by: Tomasz Figa <tfiga@chromium.org>
> > > > > [rebase44(groeck): include linux/types.h in v4l2-controls.h]
> > > > > Signed-off-by: Guenter Roeck <groeck@chromium.org>
> > > > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > > > ---
> > > > >
> > > >
> > > > [..]
> > > > > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > > > > index 242a6bfa1440..4b4a1b25a0db 100644
> > > > > --- a/include/uapi/linux/videodev2.h
> > > > > +++ b/include/uapi/linux/videodev2.h
> > > > > @@ -626,6 +626,7 @@ struct v4l2_pix_format {
> > > > >  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
> > > > >  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264 without start codes */
> > > > >  #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 MVC */
> > > > > +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* H264 parsed slices */
> > > >
> > > > As pointed out by Tomasz, the Rockchip VPU driver expects start codes [1], so the userspace
> > > > should be aware of it. Perhaps we could document this pixel format better as:
> > > >
> > > > #define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* H264 parsed slices with start codes */
> > >
> > > I'm not sure this is something we want to do at that point. libva
> > > doesn't give the start code, so this is only going to make the life of
> > > the sane controllers more difficult. And if you need to have the start
> > > code and parse it, then you're not so stateless anymore.
> >
> > I might not remember correctly, but Rockchip decoder does some slice
> > parsing on its own (despite not doing any higher level parsing).
> > Probably that's why it needs those start codes.
>
> The VPU found on Allwinner platforms also provides a mechanism to parse
> the bitstream data via a dedicated interface through the VPU registers.
> It is used in libvdpau-sunxi but not in our driver, because we don't
> want to be doing bitstream parsing in the kernel.
>
> It would be good to know if this is just a feature of the Rockchip VPU
> hardware that can be skipped (like on Allwinner) or if it's a hard
> requirement in its decoding pipeline.

It's a hard requirement for its decoding pipeline, but...

> Also, maybe it only concerns the
> slice header? It is already part of the slice data (provided by VAAPI)
> for H.264/H.265 and an offset is provided to the beginning of the coded
> video data.

Yes, it seems to be only the slice header.

>
> > I wonder if libva is the best reference here. It's been designed
> > almost entirely by Intel for Intel video hardware. We want something
> > that could work with a wide range of devices and avoid something like
> > a need to create a semi-stateless API few months later. In fact,
> > hardware from another vendor, we're working with, also does parsing of
> > slice headers internally. Moreover, we have some weird
> > kind-of-stateful decoders, which cannot fully deal with bitstream on
> > its own, e.g. cannot parse formats, cannot handle resolution changes,
> > need H264 bitstream NALUs split into separate buffers, etc.
> >
> > As I suggested some time ago, having the full bitstream in the buffer,
> > with offsets of particular units included in respective controls,
> > would be the most scalable thing. If really needed, we could add flags
> > telling the driver that particular units are present, so one's
> > implementation of libva could put only raw slice data in the buffers.
> > But perhaps it's libva which needs some amendment?
>
> If the raw bitstream is needed, I think it would make more sense to use
> the already-existing formats for stateful VPUs along with the controls
> for stateless ones instead of having the full bitstream in the
> V4L2_PIX_FMT_*_SLICE formats.

It may indeed make sense to separate this based on pixel format.
However, how do we tell the client that it needs to provide those
controls? Current concept was based entirely on pixel format, so I
guess that would mean creating something like
V4L2_PIX_FMT_*_NOT_REALLY_SLICE (_PARSED, _STATELESS?). Might be okay,
though...

>
> I would also be tempted to say that reconstructing the needed parts of
> the bitstream in-driver for these half-way VPUs would be a better
> approach than blurrying the line between how (and what) data should be
> passed for stateful and stateless VPUs at the API level. Stateless
> should only cover what's in the slice NAL unit RBSP, which excludes the
> start code detection bytes. It is no longer parsed data otherwise.

I'm not sure where such decision comes from. In particular, Chromium,
from which this code originates, includes start codes in
V4L2_PIX_FMT_H264_SLICE. As I mentioned earlier, we can't design this
API based only on 1 type of hardware semantics. The stateless API
should cover any kind of codec that needs user space assistance in
processing the stream, which in practice would be almost everything
for which stateful API doesn't work.

That said, since pixel format essentially specifies the buffer
contents, having such cases differentiated based on the pixel format
doesn't sound insane.

Best regards,
Tomasz
