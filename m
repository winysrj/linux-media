Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:42083 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732619AbeHGR0B (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 13:26:01 -0400
Received: by mail-yb0-f196.google.com with SMTP id c10-v6so6722953ybf.9
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 08:11:14 -0700 (PDT)
Received: from mail-yb0-f171.google.com (mail-yb0-f171.google.com. [209.85.213.171])
        by smtp.gmail.com with ESMTPSA id 79-v6sm707814ywp.71.2018.08.07.08.11.12
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Aug 2018 08:11:12 -0700 (PDT)
Received: by mail-yb0-f171.google.com with SMTP id n10-v6so2433015ybd.7
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 08:11:12 -0700 (PDT)
MIME-Version: 1.0
References: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
 <2251357.uoA9bQP17p@jernej-laptop> <5b8f8406620166903db35832489e0f2d314b4191.camel@bootlin.com>
 <2378753.ggmX2zm38T@jernej-laptop>
In-Reply-To: <2378753.ggmX2zm38T@jernej-laptop>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 8 Aug 2018 00:10:59 +0900
Message-ID: <CAAFQd5AtRz3aP2DpFk46_5MuDcFxx594MBMeu73UaZvBuZOp+A@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v6 4/8] media: platform: Add Cedrus VPU
 decoder driver
To: jernej.skrabec@gmail.com
Cc: linux-sunxi@googlegroups.com,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        thomas.petazzoni@bootlin.com,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        ayaka <ayaka@soulik.info>, Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 8, 2018 at 12:05 AM Jernej =C5=A0krabec <jernej.skrabec@gmail.c=
om> wrote:
>
> Dne torek, 07. avgust 2018 ob 14:31:03 CEST je Paul Kocialkowski napisal(=
a):
> > Hi,
> >
> > On Fri, 2018-07-27 at 16:58 +0200, Jernej =C5=A0krabec wrote:
> > > Dne petek, 27. julij 2018 ob 16:03:41 CEST je Jernej =C5=A0krabec nap=
isal(a):
> > > > Hi!
> > > >
> > > > Dne sreda, 25. julij 2018 ob 12:02:52 CEST je Paul Kocialkowski
> napisal(a):
> > > > > This introduces the Cedrus VPU driver that supports the VPU found=
 in
> > > > > Allwinner SoCs, also known as Video Engine. It is implemented thr=
ough
> > > > > a v4l2 m2m decoder device and a media device (used for media
> > > > > requests).
> > > > > So far, it only supports MPEG2 decoding.
> > > > >
> > > > > Since this VPU is stateless, synchronization with media requests =
is
> > > > > required in order to ensure consistency between frame headers tha=
t
> > > > > contain metadata about the frame to process and the raw slice dat=
a
> > > > > that
> > > > > is used to generate the frame.
> > > > >
> > > > > This driver was made possible thanks to the long-standing effort
> > > > > carried out by the linux-sunxi community in the interest of rever=
se
> > > > > engineering, documenting and implementing support for Allwinner V=
PU.
> > > > >
> > > > > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > > > > ---
> > > >
> > > > <snip>
> > > >
> > > > > +void cedrus_dst_format_set(struct cedrus_dev *dev,
> > > > > +                          struct v4l2_pix_format_mplane *fmt)
> > > > > +{
> > > > > +       unsigned int width =3D fmt->width;
> > > > > +       unsigned int height =3D fmt->height;
> > > > > +       u32 chroma_size;
> > > > > +       u32 reg;
> > > > > +
> > > > > +       switch (fmt->pixelformat) {
> > > > > +       case V4L2_PIX_FMT_NV12:
> > > > > +               chroma_size =3D ALIGN(width, 32) * ALIGN(height /=
 2, 32);
> > > >
> > > > After some testing, it turns out that right aligment for untiled fo=
rmat
> > > > is
> > > > 16.
> > > >
> > > > > +
> > > > > +               reg =3D VE_PRIMARY_OUT_FMT_NV12 |
> > > > > +                     VE_SECONDARY_SPECIAL_OUT_FMT_NV12;
> > > > > +               cedrus_write(dev, VE_PRIMARY_OUT_FMT, reg);
> > > > > +
> > > > > +               reg =3D VE_CHROMA_BUF_LEN_SDRT(chroma_size / 2) |
> > > > > +                     VE_SECONDARY_OUT_FMT_SPECIAL;
> > > > > +               cedrus_write(dev, VE_CHROMA_BUF_LEN, reg);
> > > > > +
> > > > > +               reg =3D chroma_size / 2;
> > > > > +               cedrus_write(dev, VE_PRIMARY_CHROMA_BUF_LEN, reg)=
;
> > > > > +
> > > > > +               reg =3D VE_PRIMARY_FB_LINE_STRIDE_LUMA(ALIGN(widt=
h, 32)) |
> > > >
> > > > ^ that one should be aligned to 16
> > > >
> > > > > +                     VE_PRIMARY_FB_LINE_STRIDE_CHROMA(ALIGN(widt=
h / 2, 16));
> > >
> > > It seems that CHROMA has to be aligned to 8 ^
> >
> > I think the issue here is that the divider should be applied after the
> > alignment, not before, such as: ALIGN(width, 16) / 2, which also
> > provides a 8-aligned value.
> >
> > Feel free to let me know if that causes any particular issue!
>
> I think this is only semantics, it doesn't really matter if it is aligned=
 to
> 16 first and then divided by 2 or divided by 2 and then aligned to 8.

It depends if |width| is always expected to be aligned to 2. For
example, given |width| =3D 17,

ALIGN(17, 16) =3D 32, 32 / 2 =3D 16
17 / 2 =3D 8, ALIGN(8, 8) =3D 8

Best regards,
Tomasz
