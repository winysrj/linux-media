Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753486AbeFJAFj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Jun 2018 20:05:39 -0400
Date: Sun, 10 Jun 2018 02:05:35 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Javier Martinez Canillas <javierm@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2] media: omap3isp: zero-initialize the isp
 cam_xclk{a,b} initial data
Message-ID: <20180610000535.32ouofio7n5b6rmj@earth.universe>
References: <20180609122245.29636-1-javierm@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gmtdtfxmf372mvgo"
Content-Disposition: inline
In-Reply-To: <20180609122245.29636-1-javierm@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gmtdtfxmf372mvgo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Jun 09, 2018 at 02:22:45PM +0200, Javier Martinez Canillas wrote:
> The struct clk_init_data init variable is declared in the isp_xclk_init()
> function so is an automatic variable allocated in the stack. But it's not
> explicitly zero-initialized, so some init fields are left uninitialized.
>=20
> This causes the data structure to have undefined values that may confuse
> the common clock framework when the clock is registered.
>=20
> For example, the uninitialized .flags field could have the CLK_IS_CRITICAL
> bit set, causing the framework to wrongly prepare the clk on registration.
> This leads to the isp_xclk_prepare() callback being called, which in turn
> calls to the omap3isp_get() function that increments the isp dev refcount.
>=20
> Since this omap3isp_get() call is unexpected, this leads to an unbalanced
> omap3isp_get() call that prevents the requested IRQ to be later enabled,
> due the refcount not being 0 when the correct omap3isp_get() call happens.
>=20
> Fixes: 9b28ee3c9122 ("[media] omap3isp: Use the common clock framework")
> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>

good catch!

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>=20
> ---
>=20
> Changes in v2:
> - Correct some typos in the commit message.
>=20
>  drivers/media/platform/omap3isp/isp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platfo=
rm/omap3isp/isp.c
> index f22cf351e3e..ae0ef8b241a 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -300,7 +300,7 @@ static struct clk *isp_xclk_src_get(struct of_phandle=
_args *clkspec, void *data)
>  static int isp_xclk_init(struct isp_device *isp)
>  {
>  	struct device_node *np =3D isp->dev->of_node;
> -	struct clk_init_data init;
> +	struct clk_init_data init =3D { 0 };
>  	unsigned int i;
> =20
>  	for (i =3D 0; i < ARRAY_SIZE(isp->xclks); ++i)
> --=20
> 2.17.1
>=20

--gmtdtfxmf372mvgo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlsca0wACgkQ2O7X88g7
+pqSBxAAhvow3XuAgndl8DsB0DuK/iyz7Hjk7nqsaGMkHyG8bCv+q/d0+WwGhEq7
S7gg4GMz/qBKU4dBJDbzBFSULNmwrJOCE3zTMNLx2sub/MeRL/zTIwt4v9Ue8uRx
C9ldukWJmxuElvBSchmWdyAbgFGOCePjWvxxQumL3pTIzAGGoXU1JuwAcydThV+2
d3l4ZnRrRIhU6vcPbRi0T+6r5tFJbjJ5s7dpsDlqFsGISLE0WL4EoXx//eGnhoSS
hNmUwvkHsFJuBdMndNFGScCXNeR0CtvteSjGoDuxm1ziXdgupd/xZ2Wlf0OMt+9K
FdPGflCR8PTD4runnSFJaGm6Gf7cDl8ciZPoqKG2Z0hu13NtJ10hOvfuVN29sjx1
HdLuyqFwcQhlcafGZ8ZQ6OJw2EwbQq3EtXZm9zjcPsVFSi+1GYIYxM9w3r+RbZWd
ezjz/2XI0SdRiG4xNULQ2sGj8553aBzAdP313JHHso3f4EOyWgOTY7D1YjH4k30y
kmQ2RUF4ONAKX78BE4t8Xj9UximfJyk11MMHc0uum7AvxmqkOZjv/wHv3jGoJZ/P
18rnrcmbaG42fz+pYBqemVidoscmXPNdDx1L2qiAEbTU0Mp/QMnGbsbe6zmjx8XI
AW9wktfxYWLxszFambJtvHFNvoq+l9XtjBgRVWdLfNVHlJfHUOc=
=MbGL
-----END PGP SIGNATURE-----

--gmtdtfxmf372mvgo--
