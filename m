Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47105 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751445AbdB1MgZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 07:36:25 -0500
Date: Tue, 28 Feb 2017 13:35:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC 1/1] omap3isp: Ignore endpoints with invalid configuration
Message-ID: <20170228123534.GB4307@amd>
References: <1488283350-5695-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <1488283350-5695-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-02-28 14:02:30, Sakari Ailus wrote:
> If endpoint has an invalid configuration, ignore it instead of happily
> proceeding to use it nonetheless. Ignoring such an endpoint is better than
> failing since there could be multiple endpoints, only some of which are
> bad.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Pavel,
>=20
> How about this one? isp_fwnode_parse() is expected to return an error if
> there's one but currently it's quite shy. With this patch, the faulty
> endpoint is simply ignored. This is completely untested so far.

Does not seem to break anything.

Tested-by: Pavel Machek <pavel@ucw.cz>

								Pavel

>  drivers/media/platform/omap3isp/isp.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platfo=
rm/omap3isp/isp.c
> index 95850b9..8026221 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2120,10 +2120,12 @@ static int isp_fwnodes_parse(struct device *dev,
>  		if (!isd)
>  			goto error;
> =20
> -		notifier->subdevs[notifier->num_subdevs] =3D &isd->asd;
> +		if (isp_fwnode_parse(dev, fwn, isd)) {
> +			devm_kfree(dev, isd);
> +			continue;
> +		}
> =20
> -		if (isp_fwnode_parse(dev, fwn, isd))
> -			goto error;
> +		notifier->subdevs[notifier->num_subdevs] =3D &isd->asd;
> =20
>  		isd->asd.match.fwnode.fwn =3D
>  			fwnode_graph_get_remote_port_parent(fwn);

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli1bpYACgkQMOfwapXb+vJhNgCdFxC/8gIhpcj8CwvioEK1QCDg
UFIAn3IcX+IAnQMvplwxPMgKMcWR9SR2
=InL1
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
