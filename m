Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:32784 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbcGMNrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 09:47:08 -0400
Message-ID: <1468417588.2867.6.camel@gmail.com>
Subject: Re: [PATCH 2/2] [media] s5p-g2d: Replace old driver with DRM version
From: Nicolas Dufresne <nicolas.dufresne@gmail.com>
Reply-To: nicolas@ndufresne.ca
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	David Airlie <airlied@linux.ie>, Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Date: Wed, 13 Jul 2016 09:46:28 -0400
In-Reply-To: <20160712200202.7496445e@recife.lan>
References: <1464096493-13378-1-git-send-email-k.kozlowski@samsung.com>
	<1464096493-13378-2-git-send-email-k.kozlowski@samsung.com>
	 <20160712200202.7496445e@recife.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-y01b2W7X6i6bCU4v/zIy"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-y01b2W7X6i6bCU4v/zIy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 12 juillet 2016 =C3=A0 20:02 -0300, Mauro Carvalho Chehab a =C3=A9=
crit=C2=A0:
> I suspect that you'll be applying this one via DRM tree, so:
>=20
> Em Tue, 24 May 2016 15:28:13 +0200
> Krzysztof Kozlowski <k.kozlowski@samsung.com> escreveu:
>=20
> > Remove the old non-DRM driver because it is now entirely supported
> by
> > exynos_drm_g2d driver.
> >=C2=A0
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>=20
> Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>=20
> PS.: If you prefer to apply this one via my tree, I'm ok too. Just
> let me know when the first patch gets merged upstream.

Just a note that this is effectively an API break.

cheers,
Nicolas
--=-y01b2W7X6i6bCU4v/zIy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAleGRjQACgkQcVMCLawGqBwL7QCePqdETcq62X5jzGbQvj7Bn135
YjMAnR1g59OdM4GdoHaaWGKDrWq/T4v7
=25bp
-----END PGP SIGNATURE-----

--=-y01b2W7X6i6bCU4v/zIy--

