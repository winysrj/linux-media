Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42416 "EHLO
        mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751140AbdFBQyz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 12:54:55 -0400
Date: Fri, 2 Jun 2017 17:54:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Tim Harvey <tharvey@gateworks.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Message-ID: <20170602165447.kflg2u6ovdrwcwjo@sirena.org.uk>
References: <CAJ+vNU1TOOSf-PoXw1oGTVhGNp2w=X2KAmpYtT8c32GRju2kEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aftmt334f7tolisr"
Content-Disposition: inline
In-Reply-To: <CAJ+vNU1TOOSf-PoXw1oGTVhGNp2w=X2KAmpYtT8c32GRju2kEQ@mail.gmail.com>
Subject: Re: regmap for i2c pages
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--aftmt334f7tolisr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 01, 2017 at 11:37:43PM -0700, Tim Harvey wrote:

> I believe this is a very common i2c register mechanism but I'm not
> clear what the best way to use i2c regmap for this is. I'm reading
> that regmap 'handles register pages' but I'm not clear if that's the
> same thing I'm looking for. If so, are there any examples of this? I
> see several i2c drivers that reference pages but it looks to me that
> each page is a different i2c slave address which is something
> different.

You're looking for regmap_range (search for window in regmap.h).

--aftmt334f7tolisr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlkxmFMACgkQJNaLcl1U
h9DNpwf/UPa0+48wnCqpY9pxU63YTKEzn6jEYFlXDJsMwJHxut4FM1CSoEi2aubn
ntOpKSj7llZkhZR8c+pfOw/hLx7Gi1EevzEk5Tg7BtRbcaPXoG3j93Eah1tNawuc
mAPwFdb4sQYD2UIxXN5Z6NYcntvB0hyCDcPJK18tHsvBp8UE/+WNGc2Azowg/3si
reIzkT7t1f7ksTQEDClr7UoIgnuBgWbZ8mgFsYaTyMextFoHclBY+npk2DPeU1uB
XVxnb6gjcUmlIaMZMDs3+1Ts1qe9VQEzrC/GkPwxZ7LpgnQZ59WFuYYoId4HGZFt
XDSNc7AmqQvK4w0QPJcFHo3eJ24yPQ==
=shLt
-----END PGP SIGNATURE-----

--aftmt334f7tolisr--
