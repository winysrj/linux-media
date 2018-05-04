Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51967 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751172AbeEDIZf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 04:25:35 -0400
Message-ID: <1e27232735a0375f78f819c5f6b201aec475b1cd.camel@bootlin.com>
Subject: Re: [PATCH v2 05/10] media: v4l: Add definitions for MPEG2 frame
 format and header metadata
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg "
         "Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>, wens@csie.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 04 May 2018 10:24:03 +0200
In-Reply-To: <CAAFQd5Dq4OeshtFaoxFK2357+-_=hzh0C7W=zksTWtaDuDCiGg@mail.gmail.com>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
         <20180419154536.17846-1-paul.kocialkowski@bootlin.com>
         <CAAFQd5Dq4OeshtFaoxFK2357+-_=hzh0C7W=zksTWtaDuDCiGg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-U4fIwvrA8kmLG9u793QO"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-U4fIwvrA8kmLG9u793QO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 2018-04-20 at 09:51 +0000, Tomasz Figa wrote:
> Hi Paul,
>=20
> On Fri, Apr 20, 2018 at 12:46 AM Paul Kocialkowski <
> paul.kocialkowski@bootlin.com> wrote:
> [snip]
> > +struct v4l2_ctrl_mpeg2_frame_hdr {
> > +       __u32 slice_len;
> > +       __u32 slice_pos;
> > +       enum { MPEG1, MPEG2 } type;
>=20
> Is enum suitable for UAPI?

As it turns out, it's not :)

> > +
> > +       __u16 width;
> > +       __u16 height;
> > +
> > +       enum { PCT_I =3D 1, PCT_P, PCT_B, PCT_D } picture_coding_type;
>=20
> Ditto.
>=20
> > +       __u8 f_code[2][2];
> > +
> > +       __u8 intra_dc_precision;
> > +       __u8 picture_structure;
> > +       __u8 top_field_first;
> > +       __u8 frame_pred_frame_dct;
> > +       __u8 concealment_motion_vectors;
> > +       __u8 q_scale_type;
> > +       __u8 intra_vlc_format;
> > +       __u8 alternate_scan;
> > +
> > +       __u8 backward_ref_index;
> > +       __u8 forward_ref_index;
> > +};
> > +
> >   #endif
> > diff --git a/include/uapi/linux/videodev2.h
>=20
> b/include/uapi/linux/videodev2.h
> > index 31b5728b56e9..4b8336f7bcf0 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -635,6 +635,7 @@ struct v4l2_pix_format {
> >   #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L')
> > /*
>=20
> SMPTE 421M Annex L compliant stream */
> >   #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /*
> > VP8 */
> >   #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /*
> > VP9 */
> > +#define V4L2_PIX_FMT_MPEG2_FRAME v4l2_fourcc('M', 'G', '2', 'F') /*
>=20
> MPEG2 frame */
>=20
> >   /*  Vendor-specific formats   */
> >   #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /*
> > cpia1
>=20
> YUV */
> > @@ -1586,6 +1587,7 @@ struct v4l2_ext_control {
> >                  __u8 __user *p_u8;
> >                  __u16 __user *p_u16;
> >                  __u32 __user *p_u32;
> > +               struct v4l2_ctrl_mpeg2_frame_hdr __user
>=20
> *p_mpeg2_frame_hdr;
> >                  void __user *ptr;
> >          };
> >   } __attribute__ ((packed));
> > @@ -1631,6 +1633,7 @@ enum v4l2_ctrl_type {
> >          V4L2_CTRL_TYPE_U8            =3D 0x0100,
> >          V4L2_CTRL_TYPE_U16           =3D 0x0101,
> >          V4L2_CTRL_TYPE_U32           =3D 0x0102,
> > +       V4L2_CTRL_TYPE_MPEG2_FRAME_HDR =3D 0x0109,
>=20
> Why 0x0109?

Good catch. I see no reason in particular, so I'll probably make it
0x0103 eventually.

Cheers and thanks for the review!

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-U4fIwvrA8kmLG9u793QO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrsGKMACgkQ3cLmz3+f
v9Ggywf/buPoS1xRGzfgUMg0fQjA7nsPaat8ZmQFCQgezckDxvntqmMLn4fREdg2
AwEwsulx3K6j96CFfHN4kJSovAd2vcQ6hZf9tP7T006o60ltjwbhjNhOqI9zhLKB
EsJH/hEXkice1QA7LKYwor18ydoa8XD+jwM1/mOlerFFGyJHIMvDbFCTaD6JPffX
dcEo7S7fpoOBE0Bj6FlD6PtynHWVQcxJGdpPptCOrHAGot1LP+DJqu7xU93IvzwZ
dgEzpf5ZXY0U8zL0vyuyL4PmAEYyRnsUFosLNkhopVP/Ih/Ftz8gq3d21p8mMfxo
sVw4XL7FSN7tgafIe/mUrW1UfWH0og==
=9H7Z
-----END PGP SIGNATURE-----

--=-U4fIwvrA8kmLG9u793QO--
