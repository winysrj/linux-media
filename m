Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47382 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbeHVR2Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 13:28:16 -0400
Message-ID: <2550f0d2fd955922c8d6508573ac78487315bf25.camel@collabora.com>
Subject: Re: [PATCH 1/9] CHROMIUM: v4l: Add H264 low-level decoder API
 compound controls.
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Pawel Osciak <posciak@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg "
         "Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        jenskuske@gmail.com, linux-sunxi@googlegroups.com,
        thomas.petazzoni@bootlin.com, groeck@chromium.org
Date: Wed, 22 Aug 2018 10:03:05 -0400
In-Reply-To: <CAAFQd5AybueM-rhy8bMbRHHZmwBP08-cWB11NadcUQAb6XJ1SA@mail.gmail.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-2-maxime.ripard@bootlin.com>
         <80e1d9cb49c6df06843e49332685f2b401023292.camel@collabora.com>
         <20180822091557.gtnlgoebyv6yttzf@flea>
         <CAAFQd5ANvKF2+GEXQTnRsdYVzJTtBOhv7nFahV=2W-9_QXwY4g@mail.gmail.com>
         <e6324ea983d34403199044ae30e932cd728c8ad4.camel@bootlin.com>
         <CAAFQd5AybueM-rhy8bMbRHHZmwBP08-cWB11NadcUQAb6XJ1SA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-O9f5ftoJBAVQZuKAhDT7"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-O9f5ftoJBAVQZuKAhDT7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 22 ao=C3=BBt 2018 =C3=A0 22:24 +0900, Tomasz Figa a =C3=A9crit =
:
> On Wed, Aug 22, 2018 at 10:03 PM Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> >=20
> > Hi,
> >=20
> > On Wed, 2018-08-22 at 18:54 +0900, Tomasz Figa wrote:
> > > On Wed, Aug 22, 2018 at 6:16 PM Maxime Ripard <maxime.ripard@bootlin.=
com> wrote:
> > > >=20
> > > > Hi,
> > > >=20
> > > > On Tue, Aug 21, 2018 at 01:58:38PM -0300, Ezequiel Garcia wrote:
> > > > > On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> > > > > > From: Pawel Osciak <posciak@chromium.org>
> > > > > >=20
> > > > > > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > > > > > Reviewed-by: Wu-cheng Li <wuchengli@chromium.org>
> > > > > > Tested-by: Tomasz Figa <tfiga@chromium.org>
> > > > > > [rebase44(groeck): include linux/types.h in v4l2-controls.h]
> > > > > > Signed-off-by: Guenter Roeck <groeck@chromium.org>
> > > > > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > > > > ---
> > > > > >=20
> > > > >=20
> > > > > [..]
> > > > > > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linu=
x/videodev2.h
> > > > > > index 242a6bfa1440..4b4a1b25a0db 100644
> > > > > > --- a/include/uapi/linux/videodev2.h
> > > > > > +++ b/include/uapi/linux/videodev2.h
> > > > > > @@ -626,6 +626,7 @@ struct v4l2_pix_format {
> > > > > >  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') =
/* H264 with start codes */
> > > > > >  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1'=
) /* H264 without start codes */
> > > > > >  #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') =
/* H264 MVC */
> > > > > > +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4'=
) /* H264 parsed slices */
> > > > >=20
> > > > > As pointed out by Tomasz, the Rockchip VPU driver expects start c=
odes [1], so the userspace
> > > > > should be aware of it. Perhaps we could document this pixel forma=
t better as:
> > > > >=20
> > > > > #define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /=
* H264 parsed slices with start codes */
> > > >=20
> > > > I'm not sure this is something we want to do at that point. libva
> > > > doesn't give the start code, so this is only going to make the life=
 of
> > > > the sane controllers more difficult. And if you need to have the st=
art
> > > > code and parse it, then you're not so stateless anymore.
> > >=20
> > > I might not remember correctly, but Rockchip decoder does some slice
> > > parsing on its own (despite not doing any higher level parsing).
> > > Probably that's why it needs those start codes.
> >=20
> > The VPU found on Allwinner platforms also provides a mechanism to parse
> > the bitstream data via a dedicated interface through the VPU registers.
> > It is used in libvdpau-sunxi but not in our driver, because we don't
> > want to be doing bitstream parsing in the kernel.
> >=20
> > It would be good to know if this is just a feature of the Rockchip VPU
> > hardware that can be skipped (like on Allwinner) or if it's a hard
> > requirement in its decoding pipeline.
>=20
> It's a hard requirement for its decoding pipeline, but...
>=20
> > Also, maybe it only concerns the
> > slice header? It is already part of the slice data (provided by VAAPI)
> > for H.264/H.265 and an offset is provided to the beginning of the coded
> > video data.
>=20
> Yes, it seems to be only the slice header.
>=20
> >=20
> > > I wonder if libva is the best reference here. It's been designed
> > > almost entirely by Intel for Intel video hardware. We want something
> > > that could work with a wide range of devices and avoid something like
> > > a need to create a semi-stateless API few months later. In fact,
> > > hardware from another vendor, we're working with, also does parsing o=
f
> > > slice headers internally. Moreover, we have some weird
> > > kind-of-stateful decoders, which cannot fully deal with bitstream on
> > > its own, e.g. cannot parse formats, cannot handle resolution changes,
> > > need H264 bitstream NALUs split into separate buffers, etc.
> > >=20
> > > As I suggested some time ago, having the full bitstream in the buffer=
,
> > > with offsets of particular units included in respective controls,
> > > would be the most scalable thing. If really needed, we could add flag=
s
> > > telling the driver that particular units are present, so one's
> > > implementation of libva could put only raw slice data in the buffers.
> > > But perhaps it's libva which needs some amendment?
> >=20
> > If the raw bitstream is needed, I think it would make more sense to use
> > the already-existing formats for stateful VPUs along with the controls
> > for stateless ones instead of having the full bitstream in the
> > V4L2_PIX_FMT_*_SLICE formats.
>=20
> It may indeed make sense to separate this based on pixel format.
> However, how do we tell the client that it needs to provide those
> controls? Current concept was based entirely on pixel format, so I
> guess that would mean creating something like
> V4L2_PIX_FMT_*_NOT_REALLY_SLICE (_PARSED, _STATELESS?). Might be okay,
> though...
>=20
> >=20
> > I would also be tempted to say that reconstructing the needed parts of
> > the bitstream in-driver for these half-way VPUs would be a better
> > approach than blurrying the line between how (and what) data should be
> > passed for stateful and stateless VPUs at the API level. Stateless
> > should only cover what's in the slice NAL unit RBSP, which excludes the
> > start code detection bytes. It is no longer parsed data otherwise.
>=20
> I'm not sure where such decision comes from. In particular, Chromium,
> from which this code originates, includes start codes in
> V4L2_PIX_FMT_H264_SLICE. As I mentioned earlier, we can't design this
> API based only on 1 type of hardware semantics. The stateless API
> should cover any kind of codec that needs user space assistance in
> processing the stream, which in practice would be almost everything
> for which stateful API doesn't work.

Well, be aware that in most of today's use case, Chromium bitstream
handling is suboptimal since the startcode are crafted by Chromium.
Most of today's use case uses ISOMP4 container, which does not hold
start codes but AVC headers.

If we step back a little, the start codes are designed for randomly
accessing bytes. It's a mark made to be able to randomly scan and find
the start of a NAL. In a well framed stream, they are useless. Then AVC
header is designed to announce the size of the following block, if we
pass only one NAL by buffer, this is not very useful either. Both seems
trivial to reconstruct if the HW requires it.

>=20
> That said, since pixel format essentially specifies the buffer
> contents, having such cases differentiated based on the pixel format
> doesn't sound insane.

As of today, that's what the pixel formats tries to do with these
_NO_SC postfix (the current naming is generally ambiguous though).

>=20
> Best regards,
> Tomasz

--=-O9f5ftoJBAVQZuKAhDT7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW31tGQAKCRBxUwItrAao
HIGkAKCgkBKCJNCAYfiVGp4ochL2PrI0nQCdHEQ5iJuIyzNaKHWrmWONRL1TQFc=
=Ew/g
-----END PGP SIGNATURE-----

--=-O9f5ftoJBAVQZuKAhDT7--
