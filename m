Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45211 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbcGOQxg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 12:53:36 -0400
Message-ID: <1468601608.3819.4.camel@ndufresne.ca>
Subject: Re: [RFT PATCH v2] [media] exynos4-is: Fix
 fimc_is_parse_sensor_config() nodes handling
From: Nicolas Dufresne <nicolas@ndufresne.ca>
Reply-To: nicolas@ndufresne.ca
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
	linux-media@vger.kernel.org
Date: Fri, 15 Jul 2016 12:53:28 -0400
In-Reply-To: <5718D3DC.20004@osg.samsung.com>
References: <1458780100-8865-1-git-send-email-javier@osg.samsung.com>
	 <5718D3DC.20004@osg.samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-zfFVnl9Q9HSvyhtYsq97"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-zfFVnl9Q9HSvyhtYsq97
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 21 avril 2016 =C3=A0 09:21 -0400, Javier Martinez Canillas a
=C3=A9crit=C2=A0:
> Hello Sylwester,
>=20
> On 03/23/2016 08:41 PM, Javier Martinez Canillas wrote:
> > The same struct device_node * is used for looking up the I2C
> > sensor, OF
> > graph endpoint and port. So the reference count is incremented but
> > not
> > decremented for the endpoint and port nodes.
> >=20
> > Fix this by having separate pointers for each node looked up.
> >=20
> > Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> >=20
>=20
> Any comments about this patch?

Tested-by: Nicolas Dufresne <nicoas.dufresne@collabora.com>

Note: I could not verify that leak is gone, but I could verify that
this driver is still working properly after the change.

>=20
> Best regards,
--=-zfFVnl9Q9HSvyhtYsq97
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAleJFQgACgkQcVMCLawGqBzw1gCgrLdXDmeyHxgroK0KhpaOtGtt
RkwAn237ONhHecYuZEyvblC87xO1ky59
=lIY/
-----END PGP SIGNATURE-----

--=-zfFVnl9Q9HSvyhtYsq97--

