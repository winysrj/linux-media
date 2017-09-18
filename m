Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32950 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751924AbdIRK47 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 06:56:59 -0400
Date: Mon, 18 Sep 2017 12:56:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RESEND PATCH v2 4/6] dt: bindings: as3645a: Improve label
 documentation, DT example
Message-ID: <20170918105655.GA14591@amd>
References: <20170918102349.8935-1-sakari.ailus@linux.intel.com>
 <20170918102349.8935-5-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20170918102349.8935-5-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Specify the exact label used if the label property is omitted in DT, as
> well as use label in the example that conforms to LED device naming.
>=20
> @@ -69,11 +73,11 @@ Example
>  			flash-max-microamp =3D <320000>;
>  			led-max-microamp =3D <60000>;
>  			ams,input-max-microamp =3D <1750000>;
> -			label =3D "as3645a:flash";
> +			label =3D "as3645a:white:flash";
>  		};
>  		indicator@1 {
>  			reg =3D <0x1>;
>  			led-max-microamp =3D <10000>;
> -			label =3D "as3645a:indicator";
> +			label =3D "as3645a:red:indicator";
>  		};
>  	};

Ok, but userspace still has no chance to determine if this is flash
=66rom main camera or flash for front camera; todays smartphones have
flashes on both cameras.

So.. Can I suggset as3645a:white:main_camera_flash or main_flash or
=2E...?

Thanks,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlm/pncACgkQMOfwapXb+vJuqgCdH1bee2vh9lyEEt7Sa5YX50g3
kpIAnivXE1m31wGFd/GP2m0D6V2Srk5D
=UP2N
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
