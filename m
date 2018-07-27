Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:38629 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730737AbeG0PZv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 11:25:51 -0400
Message-ID: <ec974f9dbf73dede2b82f81faafa68b04c7aec61.camel@bootlin.com>
Subject: Re: [PATCH 9/9] media: cedrus: Add H264 decoding support
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        nicolas.dufresne@collabora.com, Jens Kuske <jenskuske@gmail.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Date: Fri, 27 Jul 2018 16:03:44 +0200
In-Reply-To: <CAGb2v67k_bwATPiaRVifR0gnAaG56VztpW9WifOExQbLqm2Csg@mail.gmail.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-10-maxime.ripard@bootlin.com>
         <8c0b2fbec0302a15292d3629570ab1268fd306b8.camel@bootlin.com>
         <CAGb2v67k_bwATPiaRVifR0gnAaG56VztpW9WifOExQbLqm2Csg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-TetegmsUWJBkTobuJJEE"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-TetegmsUWJBkTobuJJEE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Chen-Yu,

On Fri, 2018-07-27 at 22:01 +0800, Chen-Yu Tsai wrote:
> On Fri, Jul 27, 2018 at 9:56 PM, Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> > Hi,
> >=20
> > On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> > > Introduce some basic H264 decoding support in cedrus. So far, only th=
e
> > > baseline profile videos have been tested, and some more advanced feat=
ures
> > > used in higher profiles are not even implemented.
> >=20
> > Here are two specific comments about things I noticed when going throug=
h
> > the h264 code.
> >=20
> > [...]
> >=20
> > > @@ -88,12 +101,37 @@ struct sunxi_cedrus_ctx {
> > >       struct work_struct run_work;
> > >       struct list_head src_list;
> > >       struct list_head dst_list;
> > > +
> > > +     union {
> > > +             struct {
> > > +                     void            *mv_col_buf;
> > > +                     dma_addr_t      mv_col_buf_dma;
> > > +                     ssize_t         mv_col_buf_size;
> > > +                     void            *neighbor_info_buf;
> > > +                     dma_addr_t      neighbor_info_buf_dma;
> >=20
> > Should be "neighbour" instead of "neighbor" and the same applies to mos=
t
> > variables related to this, as well as the register description.
>=20
> This just means you've been hanging out with people who use American
> English. :)

Oh wow, I honestly thought this was a typo. My mistake then!

Thanks for the heads-up!

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-TetegmsUWJBkTobuJJEE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltbJkAACgkQ3cLmz3+f
v9EWnwgAnt3yCgJkaA7JpP0nO0SFQDU7bzp6ZNBgG3eFwTAater8XW3PEQze6EH5
MnXBgOn6+Rld4kMmmrqFUwuUgj6c3ay3+8WWMol57dU/hgrsRfIFUbUMf/50jJi6
90inWBqxDMY9uTjy4pJmaaL4CXRwZQYG7IJcp0OB0SxY6lUXBpwyfuGvi6Q3uxGk
tCZFqgXLuW2gEcaEUmci+mkYv6qnF0d6ewHe2wjh8WxcC/+O8128om3aMtYuHHpT
gbnwzfDlacDFBb77paObOmtD6vTHeQ1UaZAsTPZgEKtKx8T811Gkmfy41FbknQo3
0FNd3ifcbHp3ctEc/2SFgOso9myUcg==
=MbB7
-----END PGP SIGNATURE-----

--=-TetegmsUWJBkTobuJJEE--
