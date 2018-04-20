Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:54911 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753539AbeDTHX3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 03:23:29 -0400
Date: Fri, 20 Apr 2018 09:23:16 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>
Subject: Re: [PATCH v2 01/10] media: v4l2-ctrls: Add missing v4l2 ctrl unlock
Message-ID: <20180420072316.sifritx54mppgwz3@flea>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
 <20180419154124.17512-2-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yqpvzbuk2a5n4355"
Content-Disposition: inline
In-Reply-To: <20180419154124.17512-2-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yqpvzbuk2a5n4355
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 19, 2018 at 05:41:15PM +0200, Paul Kocialkowski wrote:
> This adds a missing v4l2_ctrl_unlock call that is required to avoid
> deadlocks.

Maybe you can explain what the deadlock scenario is?

> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-co=
re/v4l2-ctrls.c
> index f67e9f5531fa..ba05a8b9a095 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -3614,10 +3614,12 @@ void v4l2_ctrl_request_complete(struct media_requ=
est *req,
>  			continue;
> =20
>  		v4l2_ctrl_lock(ctrl);
> +
>  		if (ref->req)
>  			ptr_to_ptr(ctrl, ref->req->p_req, ref->p_req);
>  		else
>  			ptr_to_ptr(ctrl, ctrl->p_cur, ref->p_req);
> +

I'm not sure that this is relevant in this patch.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--yqpvzbuk2a5n4355
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrZlVcACgkQ0rTAlCFN
r3Ta5g//U10D/ucGkinLguIgg52ZcwICCeHZjAnqkWjobQv9c6ehmRQoSvUadY+I
7tr4APQa1bOeBfXDheWw2GicNmefCYOFAHxXjdRsIoTJeTJRvLYlSqGVfP4rF9mP
6s69+J2zbTLiSGSDajNV6akt4te9JB3ribKl1ayzRnXmWgA79yNXNDcfBDVZZYMB
xMtoKrsR9sheG2AYdFNHo7+BLzpJsp9kCOguwTUbDXy6mcC9APrpWMUmFRRPeTtk
ZBZJopxNGlSQixq5b8a4CTx4abQoWj+ccSTY0JwHUsaV6XuMqhPVE56KM70m0MlF
xS41Qn9y6p2hTSmXDIsB4pqF6Ii+OOJtZXAqj0OPBTSxKDNNy6JegNCvJOuZxVRI
lDDTpXbABTt4BM/3wpd3Zn59Mn4t72NlGQI2uJoj99nnE/0vCr+fGVCNLqMyZ89n
tNZhp5vDWp6pxjj64m3Me9Qf0GKjJaHUuWDqLmhnIBUTyFoi/f/tJLza6diehJXD
2lMyWwE4m/NL7RO2Y9835nhdNvPTy2/Pc15HMOd3ZNlhHWQUbTNZUdN4fIyfbOKc
xwQg5lMf5Gn2RFxXLC9+/jjNsQ0APbr9e/Qw6Vive2foe63mF0DXSBGLPRk7tgID
lAy2ty+JVhKVRXrbvQxgf5WaAwXTu28tiqz1qAP8Nk3eNZO/X1s=
=UQpD
-----END PGP SIGNATURE-----

--yqpvzbuk2a5n4355--
