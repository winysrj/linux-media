Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49879 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbaIWOGS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 10:06:18 -0400
Date: Tue, 23 Sep 2014 16:06:13 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] drm: panel: simple-panel: add bus format information
 for foxlink panel
Message-ID: <20140923140612.GB5982@ulmo>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
 <1406031827-12432-6-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <1406031827-12432-6-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2014 at 02:23:47PM +0200, Boris BREZILLON wrote:
> Foxlink's fl500wvr00-a0t supports RGB888 format.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/gpu/drm/panel/panel-simple.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel=
/panel-simple.c
> index 42fd6d1..f1e49fd 100644
> --- a/drivers/gpu/drm/panel/panel-simple.c
> +++ b/drivers/gpu/drm/panel/panel-simple.c
> @@ -428,6 +428,7 @@ static const struct panel_desc foxlink_fl500wvr00_a0t=
 =3D {
>  		.width =3D 108,
>  		.height =3D 65,
>  	},
> +	.bus_format =3D VIDEO_BUS_FMT_RGB888_1X24,

This is really equivalent to .bpc =3D 8. Didn't you say you had other
use-cases where .bpc wasn't sufficient?

Thierry

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUIX5UAAoJEN0jrNd/PrOh978P/AwkG0E2cje1IL7DuT0+mMzH
jve3XfrooQ5hvChRzJNawNb/r6qoBrxFsfW5mz4Cd0vduLuvUBhRUfNXefvHTMZO
ERCMz2OjDFwvS91ShBB/DyGlX1puDQgea7KiICjoPTX/Gh9eXzmpqerwQv9K6bRN
82ypV2KEGg49bonJSipHYZNqnQbaRjTR/YfMuN2XRoXTFKLcDnUk0NE7H3N04jsz
eDTBCVQ2Os9E71MEyHFbY+O39HKnA98Hqr/25I+/kV1cV/mRWKMjeZJVXFD7KEgN
QoM4ec0C9uydDIaYuJRuqUUUlc6plXoc40Gx6xNJ5LtisEuBLteQyBZIsOgpy0de
mTzTqA8q3KJtWEZ7Cwjeqo0WYkRHTB5wDs+SOlBDPESMx4a9F2BkQZWoWMdCkZRv
HWE/zecn84NSq92v6W8yHENkjgSfVXl0Wnucd9eui9O3Zd8fadNruo76zh6Q6KIZ
7yMNnNEpCgdz9cix6NNnSwrtKFan9QV42hTtGrGHHXxZBOMU37l7JHPOZ+0F4ydX
OddmQAOAVmuyzjLGMkLFt/YCqOejMCABcviTW6hjAEv4eBMCkxu70caagsYEY5Cu
Cdp3mbuvp+bR7xfU6tGQHqarsauwfAYEmdeZA4COL3A4rATgLvHs+sO+zP6j/oQJ
vvb7FnmpKBg6gCkATnU3
=t+tM
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
