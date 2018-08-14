Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54539 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbeHNRIu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 13:08:50 -0400
Date: Tue, 14 Aug 2018 16:21:24 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 01/14] staging: media: tegra-vde: Support BSEV clock and
 reset
Message-ID: <20180814142124.GA21075@ulmo>
References: <20180813145027.16346-1-thierry.reding@gmail.com>
 <20180813145027.16346-2-thierry.reding@gmail.com>
 <2754354.GStWHyBo4g@dimapc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <2754354.GStWHyBo4g@dimapc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 13, 2018 at 06:09:46PM +0300, Dmitry Osipenko wrote:
> On Monday, 13 August 2018 17:50:14 MSK Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > The BSEV clock has a separate gate bit and can not be assumed to be
> > always enabled. Add explicit handling for the BSEV clock and reset.
> >=20
> > This fixes an issue on Tegra124 where the BSEV clock is not enabled
> > by default and therefore accessing the BSEV registers will hang the
> > CPU if the BSEV clock is not enabled and the reset not deasserted.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
>=20
> Are you sure that BSEV clock is really needed for T20/30? I've tried alre=
ady=20
> to disable the clock explicitly and everything kept working, though I'll =
try=20
> again.

I think you're right that these aren't strictly required for VDE to work
on Tegra20 and Tegra30. However, the BSEV clock and reset do exist on
those platforms, so I didn't see a reason why they shouldn't be handled
uniformly across all generations.

> The device-tree changes should be reflected in the binding documentation.

Indeed, I forgot to update that.

Thierry

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlty5WEACgkQ3SOs138+
s6EgTxAAqT6T2dMsu2O7ptA/ykaIKq/XqXUtLr+3V58Nnf+il/q0ND0uKsTHLIx1
T/qeA/1+ed8UMMOXIamTYg4rSIyeg+v44uonibYhhAP5t0PmIRVb5d80wfOQkiMd
4vDJUTY4+GAIJrw11WwWrnAca5qjXu/Z1KVsboIkoPQgiNDwRVyYA6NwVzr3ADzh
knKcklsropsztJFKiekQwTz8x33zxX6wvue2eYusFdayngzsNq30yxUTjD5sziOw
Q8Uv04jrwc3yDpsUNt01gG3DRxF1omrvO9RKL1PH+6AxPfnWugzvAOqTmFf+LrAN
6lQRFxFEeQTSslaLwF3xLfVE17r83KdKwaqeLwJ8/cWNCWv+oOqO4ZZSEoh319cB
w3QGhW7Xoo15geAngnfxvPihISpySNWeCYc5JzfnQ/sO4GbhN4Bt9mQVcKJzDoiK
nhUtMfQtuFWTO1SDwH2erlNwYFnoEDS251GA4cCKM+TFQlarNj0uJkqKnPY9+wfz
BNPEztyrjR60ZYvQ6x9vFUSWKbnzf/1JvLzLWP78mPKKTh1q1xsqNaNZ1zi9LDD8
sU9+UPXdJtprioynJTA4FkRqX7EF8UOpuAuroBij1sesxi+pqyI8twXt/MHNsq4o
Y6lhG+LY7PCpTkVooHwPRbbY1NBVpGPkVCA+h6017wOR5aQs2AY=
=jelr
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
