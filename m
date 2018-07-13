Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59754 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbeGML1f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 07:27:35 -0400
Date: Fri, 13 Jul 2018 13:13:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 1/2] media: dt-bindings: bind nokia,n900-ir to generic
 pwm-ir-tx driver
Message-ID: <20180713111320.GB31525@amd>
References: <20180713095936.17673-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <20180713095936.17673-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  .../devicetree/bindings/media/nokia,n900-ir   | 20 -------------------
>  arch/arm/boot/dts/omap3-n900.dts              |  2 +-
>  drivers/media/rc/pwm-ir-tx.c                  |  1 +
>  3 files changed, 2 insertions(+), 21 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/media/nokia,n900-ir
>=20
> diff --git a/Documentation/devicetree/bindings/media/nokia,n900-ir b/Docu=
mentation/devicetree/bindings/media/nokia,n900-ir
> deleted file mode 100644
> index 13a18ce37dd1..000000000000
> --- a/Documentation/devicetree/bindings/media/nokia,n900-ir
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -Device-Tree bindings for LIRC TX driver for Nokia N900(RX51)
> -
> -Required properties:
> -	- compatible: should be "nokia,n900-ir".
> -	- pwms: specifies PWM used for IR signal transmission.
> -
> -Example node:
> -
> -	pwm9: dmtimer-pwm@9 {
> -		compatible =3D "ti,omap-dmtimer-pwm";
> -		ti,timers =3D <&timer9>;
> -		ti,clock-source =3D <0x00>; /* timer_sys_ck */
> -		#pwm-cells =3D <3>;
> -	};
> -
> -	ir: n900-ir {
> -		compatible =3D "nokia,n900-ir";
> -
> -		pwms =3D <&pwm9 0 26316 0>; /* 38000 Hz */
> -	};

Removing documentation is bad idea, I guess. The binding still exists
and new kernels should still support it.


> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n=
900.dts
> index 182a53991c90..fd12dea15799 100644
> --- a/arch/arm/boot/dts/omap3-n900.dts
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -154,7 +154,7 @@
>  	};
> =20
>  	ir: n900-ir {
> -		compatible =3D "nokia,n900-ir";
> +		compatible =3D "nokia,n900-ir", "pwm-ir-tx";
>  		pwms =3D <&pwm9 0 26316 0>; /* 38000 Hz */
>  	};
> =20

No problem.

> diff --git a/drivers/media/rc/pwm-ir-tx.c b/drivers/media/rc/pwm-ir-tx.c
> index 27d0f5837a76..272947b430c8 100644
> --- a/drivers/media/rc/pwm-ir-tx.c
> +++ b/drivers/media/rc/pwm-ir-tx.c
> @@ -30,6 +30,7 @@ struct pwm_ir {
>  };
> =20
>  static const struct of_device_id pwm_ir_of_match[] =3D {
> +	{ .compatible =3D "nokia,n900-ir" },
>  	{ .compatible =3D "pwm-ir-tx", },
>  	{ },
>  };

Good idea.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltIiVAACgkQMOfwapXb+vJfPQCglZVd0Saj1tTnKc90WywQddJz
/W4AoK8tSr9ca1mdPDV5eJfZtiIxhrSx
=imlT
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
