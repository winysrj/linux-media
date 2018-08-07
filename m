Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50900 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbeHGJdG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Aug 2018 05:33:06 -0400
Message-ID: <94e3eaf26ed7d6859d74abad0a0dbc94a3308a2e.camel@bootlin.com>
Subject: Re: [PATCH v6 4/8] media: platform: Add Cedrus VPU decoder driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Tomasz Figa <tfiga@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg "
         "Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
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
Date: Tue, 07 Aug 2018 09:19:54 +0200
In-Reply-To: <CAAFQd5DgFDFupACthsz1iLpAeYRtUtEfzQC1E5XZQ6gPZAYi1Q@mail.gmail.com>
References: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
         <20180725100256.22833-5-paul.kocialkowski@bootlin.com>
         <b45a8a89-1313-7a08-206d-b93017724754@xs4all.nl>
         <dba0f9496b393c76f355398018b14ae06b2b18c9.camel@bootlin.com>
         <CAAFQd5DgFDFupACthsz1iLpAeYRtUtEfzQC1E5XZQ6gPZAYi1Q@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ZkudRXiEFCPQyFqeie9D"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-ZkudRXiEFCPQyFqeie9D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-08-06 at 23:10 +0900, Tomasz Figa wrote:
> Hi Paul,
>=20
> On Mon, Aug 6, 2018 at 10:50 PM Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> >=20
> > Hi Hans and thanks for the review!
> >=20
> > On Sat, 2018-08-04 at 14:18 +0200, Hans Verkuil wrote:
> > > Hi Paul,
> > >=20
> > > See below for my review comments. Mostly small fry, the main issue I =
found is
> > > that there is no support for VIDIOC_DECODER_CMD. That's the proper wa=
y of
> > > stopping a decoder. Don't rely on the deprecated allow_zero_bytesused=
 field.
> >=20
> > Mhh, it looks like this was kept around by negligence, but we do expect
> > that streamoff stops the decoder, not a zero bytesused field.
> >=20
> > Is it still required to implement the V4L2_DEC_CMD_STOP
> > VIDIOC_DECODER_CMD in that case? I read in the doc that this ioctl
> > should be optional.
>=20
> If I understand correctly that this decoder is stateless, there should
> be no need for any special flush sequence, since a 1:1 relation
> between OUTPUT and CAPTURE buffers is expected, which means that
> userspace can just stop queuing new OUTPUT buffers and keep dequeuing
> CAPTURE buffers until it matches all OUTPUT buffers queued before.

This is indeed a stateless decoder and I don't have any particular need
for a particular stop command indeed, since flushing remaining buffers
when stopping is already implemented at streamoff time.

> By the way, I guess we will also need some documentation for the
> stateless codec interface. Do you or Maxime (who sent the H264 part)
> have any plans to work on it? We have some internal documents, which
> should be convertible to rst using pandoc, but we might need some help
> with updating to latest request API and further editing. Alexandre
> (moved from Cc to To) is going to be looking into this.

As far as I'm concerned, I am interested in contributing to this
documentation although our priorities for the Allwinner VPU effort are
currently focused on H265 support. This might mean that my contributions
to this documentation will be made on a best-effort basis (as opposed to
during the workday). Either way, if someone was to come up with an
initial draft, I'd be happy to review it!

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-ZkudRXiEFCPQyFqeie9D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltpSBoACgkQ3cLmz3+f
v9FlHQgAif+K3qb4JnoZLXyOrb1AKLTQ2nfVxhYw2FmEAQ7QVRf0syn4vF/2nJpa
+b5Qe70Mhw8oz7ZmoRaHrFSu3h4y43+rrsE4h0BfBE9in407DM0w95S+0khDSXKl
Sxyo2uKVxAMoNqkT+/JW02KzkLJECajsigHzHuTPLQSNBY1GnngXLFMez70b4dKU
fpSn51oGBW8UY0/t5lU7oagLUajMCP0kRlw3Cm7X+dShk4gD/jOMbQj4Iv/Ol7PY
mBzX54Gq4v4OqM1K8gdT2oyO7U9gxXv/jk+QAvDt3hSClBxVag/glhNjLqmjWGfi
/idCyK30fT7MO9GqdlvyQ9fiv56N2Q==
=nmMH
-----END PGP SIGNATURE-----

--=-ZkudRXiEFCPQyFqeie9D--
