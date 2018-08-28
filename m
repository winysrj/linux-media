Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50363 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727176AbeH1Srn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 14:47:43 -0400
Date: Tue, 28 Aug 2018 16:55:28 +0200
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
Subject: Re: [PATCH v8 8/8] ARM: dts: sun8i-h3: Add Video Engine and reserved
 memory nodes
Message-ID: <20180828145528.pqihdem4cbe6nafp@flea>
References: <20180828073424.30247-1-paul.kocialkowski@bootlin.com>
 <20180828073424.30247-9-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gyrrncapvzrqsijt"
Content-Disposition: inline
In-Reply-To: <20180828073424.30247-9-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gyrrncapvzrqsijt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 28, 2018 at 09:34:24AM +0200, Paul Kocialkowski wrote:
> This adds nodes for the Video Engine and the associated reserved memory
> for the H3. Up to 96 MiB of memory are dedicated to the CMA pool.
>=20
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--gyrrncapvzrqsijt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluFYl8ACgkQ0rTAlCFN
r3QDgQ/9E6ZcQRCD8yG5Qk/Bz6xHuYpzWbrgPiFXBdM8v4B+Bi9QVGFKT5ALJGmA
EPvC/g1BAltLsz2oYKzUE+nhwRsQGtA3p7YY4RC1EWHOOiDURp2/8iJNFVz35srP
bfLi9amjcsnv+CAhd18vi8RSmtKgp+x9nK1jmAlAeWY5iK6RZVAQP3SYR6dK0pk8
EydH3jdc7w/yxKr861nUQrE5uRErNuizOB3NaqisJLoB5HSEKzb7iYZFbcYUI2Fj
Rih4wmsMZ3TPD2nJtCM+DTD/67wFfWC4cuFITUt1qtQpQ+OiSYlLIzrlH8fGNH1s
Wa4fcy2AmA3tzYcrI3RRMD2q1Q/sY2/Lowo6A4cNmjUomxYL7f99jgzANgNW7OHl
7uIKij2aHx2Ngx2z/5SQdrL8n7YJbKOG1iHm6iYcWu2Ui46CINrEQY/8w3RF0F1/
CHePMsT0lIteOjO4bq79J5s/yjQ4Fw0EBp/g9HZuM6ZvswML5wJGa7Qv3vTNFVlx
2kVpf4e5pJP+vewxVj/AgUyX/GZTpTQws+4EN/ZCnemzk/e5tGAhCDqOx0ldbmrX
5uJk5GL4f+FXI2oRIlOs1KhrvqHdlNDUZkS1rhx5qJ1rrgTAgyPHPJWMNCc6xOiQ
9zd4oxH4T4vMOkAbEgV/vJuNISqNTqKbOdC62+cYPyrDsmY1GQc=
=ZQ8R
-----END PGP SIGNATURE-----

--gyrrncapvzrqsijt--
