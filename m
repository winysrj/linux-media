Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33897 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754967AbeFNNrr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 09:47:47 -0400
Date: Thu, 14 Jun 2018 15:47:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Javier Martinez Canillas <javierm@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] media: omap3isp: zero-initialize the isp cam_xclk{a,b}
 initial data
Message-ID: <20180614134746.GA3893@amd>
References: <20180609083912.27807-1-javierm@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20180609083912.27807-1-javierm@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2018-06-09 10:39:12, Javier Martinez Canillas wrote:
> The struct clk_init_data defined in isp_xclk_init() is a variable in the
> stack but it's not explicitly zero-initialized. Because of that, in some
> cases the data structure contains values that confuses the clk framework.
>=20
> For example if the flags member has the CLK_IS_CRITICAL bit set, the clk
> framework will wrongly prepare the clock on registration. This leads to
> the isp_xclk_prepare() callback to be called which in turn calls to the
> omap3isp_get() function that increments the isp device reference counter.
>=20
> Since this omap3isp_get() call is unexpected, this leads to an unbalanced
> omap3isp_get() call that prevents the requested IRQ to be later enabled,
> due the refcount not being 0 when the correct omap3isp_get() call happens.
>=20
> Fixes: 9b28ee3c9122 ("[media] omap3isp: Use the common clock framework")
> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>

Tested-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlsicgIACgkQMOfwapXb+vIc+QCaA08BHdkBq3L8yBjYX29F9SY+
icQAnRv0bf7Aoyg1VCD/4+s73ttzV7i/
=Cwz9
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
