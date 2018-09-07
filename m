Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:40138 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbeIGMeh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2018 08:34:37 -0400
Received: by mail-yb1-f195.google.com with SMTP id t71-v6so5147102ybi.7
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2018 00:54:54 -0700 (PDT)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id k186-v6sm2501841ywd.106.2018.09.07.00.54.51
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Sep 2018 00:54:52 -0700 (PDT)
Received: by mail-yw1-f50.google.com with SMTP id q129-v6so5080018ywg.8
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2018 00:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
 <20180613140714.1686-2-maxime.ripard@bootlin.com> <80e1d9cb49c6df06843e49332685f2b401023292.camel@collabora.com>
 <d8a30e78e6a33db10360995d800f2c0d19acc500.camel@collabora.com>
 <53987ca7a536a21b2eb49626d777a9bf894d6910.camel@bootlin.com>
 <CAAFQd5B68ArBgSj-Oso8=MzSrvVGB=h+MVO12qqgACmBrZtRkw@mail.gmail.com>
 <faca77cc213e4737c689f80ac5e830833bbe87ae.camel@bootlin.com> <CAAFQd5Az89KTS_+VBUMHX3Eice+OKQn66Hw0rBusf4g6rSJ7VA@mail.gmail.com>
In-Reply-To: <CAAFQd5Az89KTS_+VBUMHX3Eice+OKQn66Hw0rBusf4g6rSJ7VA@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 7 Sep 2018 16:54:40 +0900
Message-ID: <CAAFQd5DrCeDAvwBFt+Gh_mFcDRceO-nazDPDGoCVnGF=wj5aaQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] CHROMIUM: v4l: Add H264 low-level decoder API
 compound controls.
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
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
        jenskuske@gmail.com, linux-sunxi@googlegroups.com,
        thomas.petazzoni@bootlin.com, groeck@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 28, 2018 at 5:11 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> On Wed, Aug 22, 2018 at 11:45 PM Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> >
> > Hi,
> >
> > On Wed, 2018-08-22 at 22:38 +0900, Tomasz Figa wrote:
> > > On Wed, Aug 22, 2018 at 10:07 PM Paul Kocialkowski
> > > <paul.kocialkowski@bootlin.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > On Tue, 2018-08-21 at 13:07 -0400, Nicolas Dufresne wrote:
> > > > > Le mardi 21 ao=C3=BBt 2018 =C3=A0 13:58 -0300, Ezequiel Garcia a =
=C3=A9crit :
> > > > > > On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> > > > > > > From: Pawel Osciak <posciak@chromium.org>
> > > > > > >
> > > > > > > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > > > > > > Reviewed-by: Wu-cheng Li <wuchengli@chromium.org>
> > > > > > > Tested-by: Tomasz Figa <tfiga@chromium.org>
> > > > > > > [rebase44(groeck): include linux/types.h in v4l2-controls.h]
> > > > > > > Signed-off-by: Guenter Roeck <groeck@chromium.org>
> > > > > > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > > > > > ---
> > > > > > >
> > > > > >
> > > > > > [..]
> > > > > > > diff --git a/include/uapi/linux/videodev2.h
> > > > > > > b/include/uapi/linux/videodev2.h
> > > > > > > index 242a6bfa1440..4b4a1b25a0db 100644
> > > > > > > --- a/include/uapi/linux/videodev2.h
> > > > > > > +++ b/include/uapi/linux/videodev2.h
> > > > > > > @@ -626,6 +626,7 @@ struct v4l2_pix_format {
> > > > > > >  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4'=
) /*
> > > > > > > H264 with start codes */
> > > > > > >  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '=
1') /*
> > > > > > > H264 without start codes */
> > > > > > >  #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4'=
) /*
> > > > > > > H264 MVC */
> > > > > > > +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '=
4') /*
> > > > > > > H264 parsed slices */
> > > > > >
> > > > > > As pointed out by Tomasz, the Rockchip VPU driver expects start=
 codes
> > > > > > [1], so the userspace
> > > > > > should be aware of it. Perhaps we could document this pixel for=
mat
> > > > > > better as:
> > > > > >
> > > > > > #define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4')=
 /*
> > > > > > H264 parsed slices with start codes */
> > > > > >
> > > > > > And introduce another pixel format:
> > > > > >
> > > > > > #define V4L2_PIX_FMT_H264_SLICE_NO_SC v4l2_fourcc(TODO) /* H264
> > > > > > parsed slices without start codes */
> > > > > >
> > > > > > For cedrus to use, as it seems it doesn't need start codes.
> > > > >
> > > > > I must admit that this RK requirement is a bit weird for slice da=
ta.
> > > > > Though, userspace wise, always adding start-code would be compati=
ble,
> > > > > as the driver can just offset to remove it.
> > > >
> > > > This would mean that the stateless API no longer takes parsed bitst=
ream
> > > > data but effectively the full bitstream, which defeats the purpose =
of
> > > > the _SLICE pixel formats.
> > > >
> > >
> > > Not entirely. One of the purposes of the _SLICE pixel format was to
> > > specify it in a way that adds a requirement of providing the required
> > > controls by the client.
> >
> > I think we need to define what we want the stateless APIs (and these
> > formats) to precisely reflect conceptually. I've started discussing thi=
s
> > in the Request API and V4L2 capabilities thread.
> >
> > > > > Another option, because I'm not fan of adding dedicated formats f=
or
> > > > > this, the RK driver could use data_offset (in mplane v4l2 buffers=
),
> > > > > just write a start code there. I like this solution because I wou=
ld not
> > > > > be surprise if some drivers requires in fact an HW specific heade=
r,
> > > > > that the driver can generate as needed.
> > > >
> > > > I like this idea, because it implies that the driver should deal wi=
th
> > > > the specificities of the hardware, instead of making the blurrying =
the
> > > > lines of stateless API for covering these cases.
> > >
> > > The spec says
> > >
> > > "Offset in bytes to video data in the plane. Drivers must set this
> > > field when type refers to a capture stream, applications when it
> > > refers to an output stream."
> > >
> > > which would mean that user space would have to know to reserve some
> > > bytes at the beginning for the driver to add the start code there. (O=
r
> > > the driver memmove()ing the data forward when the buffer is queued,
> > > assuming that there is enough space in the buffer, but it should
> > > normally be the case.)
> > >
> > > Sounds like a pixel format with full bitstream data and some offsets
> > > to particular parts inside given inside a control might be the most
> > > flexible and cleanest solution.
> >
> > I can't help but think that bringing the whole bitstream over to the
> > kernel with a dedicated pix fmt just for the sake of having 3 start cod=
e
> > bytes is rather overkill anyway.
> >
> > I believe moving the data around to be the best call for this situation=
.
> > Or maybe there's a way to alloc more data *before* the bufer that is
> > exposed to userspace, so userspace can fill it normally and the driver
> > can bring-in the necessary heading start code bytes before the buffer?
>
> After thinking this over for some time, I believe it boils down to
> whether we can have an in-kernel library for turning H264 (and other
> codec) header structs back into a bitstream, if we end up with more
> than one driver need to do it. If that's fine, I think we're okay with
> having just the parsed pixel format around.
>
> Note that I didn't think about this with the Rockchip driver in mind,
> since it indeed only needs few bytes.

By the way, Alex posted an RFC with stateless codec interface documentation=
:
https://patchwork.kernel.org/patch/10583233/

I think we should move any discussion there, to have everything in one plac=
e.

Best regards,
Tomasz
