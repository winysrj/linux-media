Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50300 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727176AbeH1SrS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 14:47:18 -0400
Date: Tue, 28 Aug 2018 16:55:04 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v8 6/8] ARM: dts: sun7i-a20: Add Video Engine and
 reserved memory nodes
Message-ID: <20180828145504.473xga3lur372wld@flea>
References: <20180828073424.30247-1-paul.kocialkowski@bootlin.com>
 <20180828073424.30247-7-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ifhmj27lpg6g3hp7"
Content-Disposition: inline
In-Reply-To: <20180828073424.30247-7-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ifhmj27lpg6g3hp7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 28, 2018 at 09:34:22AM +0200, Paul Kocialkowski wrote:
> This adds nodes for the Video Engine and the associated reserved memory
> for the A20. Up to 96 MiB of memory are dedicated to the CMA pool.
>=20
> The VPU can only map the first 256 MiB of DRAM, so the reserved memory
> pool has to be located in that area. Following Allwinner's decision in
> downstream software, the last 96 MiB of the first 256 MiB of RAM are
> reserved for this purpose.
>=20
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--ifhmj27lpg6g3hp7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluFYkcACgkQ0rTAlCFN
r3Ruhw/9H/CwJUUps5X06oALsGrRrPryhFd3Sg5aVuXqfz45Nv7lvCZmeG7wrLC3
z5i2qxPn4PJ6bvU5g8mvwZr826LInoA603RalM/r1+AV9Shmj1USJ4LeFIab4Olg
ac2uL3aLCSQb8IqKKZ+dqOCQXBeVNMJYVQFrnOuOe3il8yiItnyPcCR4jPSEY+oB
aXbZ+7NraNFrmgn4lZvcUroe9fcvTf8pwwUeBP05R1iVTKlrgd5ufv5JPSBcUDeR
SLiXYIeGKp0xP2uoZSfcuffkMA68twRtUtf1lEeOTeRV2+AOHoMUXdcf184R7iaH
dfrVxgwhSyuM6yKvIq7f+DOKPTk4ar4MLblk3SiLz3ElGAIndm43P94phJLNwd6A
bubZU/L63/RtbRoH+E4rEPj1GfB12+zl9W2FcO7MJpQdTt2qnqjmVUmT4cfD17bQ
wqgCaBUD5nxk8NjRDECard4CzjqrAUVnbcd2BaIz0VOLWJjrwBOAwwUBVbVE7oMB
7O+SfKagNxpdkzBrmjM2Vq+72Xcta3ZyQW1osmP7cmJ+EmR5n07O+x1GAHzcNpqh
AW6p4To5ol0Mj/2dOU7hh6pRweGUUD0WOfVOYCGykPcfLtTE2UwxFc4GDdZwh7hU
GSVcj5FRRNRMbgvrLFdcOE8Fdo8Q6cdr+RHX28TQbtNxHmK8bJQ=
=HK38
-----END PGP SIGNATURE-----

--ifhmj27lpg6g3hp7--
