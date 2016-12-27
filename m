Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751539AbcL0X52 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Dec 2016 18:57:28 -0500
Date: Wed, 28 Dec 2016 00:57:21 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mark myself as mainainer for camera on N900
Message-ID: <20161227235721.xulzxdrwnb7feepn@earth>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161227092634.GK16630@valkosipuli.retiisi.org.uk>
 <20161227204558.GA23676@amd>
 <20161227205923.GA7859@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gcpm4ervip3yvwos"
Content-Disposition: inline
In-Reply-To: <20161227205923.GA7859@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gcpm4ervip3yvwos
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 27, 2016 at 09:59:23PM +0100, Pavel Machek wrote:
> Mark and Sakari as maintainers for Nokia N900 camera pieces.

^^^ missing me after Mark. Otherwise Mark looks like a name :)

> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> ---
>=20
> Hi!
>=20
> > Yeah, there was big flamewar about the permissions. In the end Linus
> > decided that everyone knows the octal numbers, but the constants are
> > tricky. It began with patch series with 1000 patches...
> >=20
> > > Btw. should we update maintainers as well? Would you like to put your=
self
> > > there? Feel free to add me, too...
> >=20
> > Ok, will do.
>=20
> Something like this? Actually, I guess we could merge ADP1653 entry
> there. Yes, it is random collection of devices, but are usually tested
> "together", so I believe one entry makes sense.
>=20
> (But I have no problem with having multiple entries, too.)
>=20
> Thanks,
> 								Pavel
>=20
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 63cefa6..1cb1d97 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8613,6 +8613,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/g=
it/lftan/nios2.git
>  S:	Maintained
>  F:	arch/nios2/
> =20
> +NOKIA N900 CAMERA SUPPORT (ET8EK8 SENSOR, AD5820 FOCUS)
> +M:	Pavel Machek <pavel@ucw.cz>
> +M:	Sakari Ailus <sakari.ailus@iki.fi>
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	drivers/media/i2c/et8ek8
> +F:	drivers/media/i2c/ad5820.c

Not sure if this is useful information, but I solved it like this
for N900 power supply drivers:

NOKIA N900 POWER SUPPLY DRIVERS
R:	Pali Roh=E1r <pali.rohar@gmail.com>
F:	include/linux/power/bq2415x_charger.h
F:	include/linux/power/bq27xxx_battery.h
F:	include/linux/power/isp1704_charger.h
F:	drivers/power/supply/bq2415x_charger.c
F:	drivers/power/supply/bq27xxx_battery.c
F:	drivers/power/supply/bq27xxx_battery_i2c.c
F:	drivers/power/supply/isp1704_charger.c
F:	drivers/power/supply/rx51_battery.c

TI BQ27XXX POWER SUPPLY DRIVER
R:	Andrew F. Davis <afd@ti.com>
F:	include/linux/power/bq27xxx_battery.h
F:	drivers/power/supply/bq27xxx_battery.c
F:	drivers/power/supply/bq27xxx_battery_i2c.c

POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
M:	Sebastian Reichel <sre@kernel.org>
L:	linux-pm@vger.kernel.org
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-power-supply=
=2Egit
S:	Maintained
F:	Documentation/devicetree/bindings/power/supply/
F:	include/linux/power_supply.h
F:	drivers/power/supply/

This makes it quite easy to see who applies patches and who should
be Cc'd for what reason:

$ ./scripts/get_maintainer.pl -f drivers/power/supply/bq27xxx_battery.c=20
"Pali Roh=E1r" <pali.rohar@gmail.com> (reviewer:NOKIA N900 POWER SUPPLY DRI=
VERS)
"Andrew F. Davis" <afd@ti.com> (reviewer:TI BQ27XXX POWER SUPPLY DRIVER)
Sebastian Reichel <sre@kernel.org> (maintainer:POWER SUPPLY CLASS/SUBSYSTEM=
 and DRIVERS)
linux-pm@vger.kernel.org (open list:POWER SUPPLY CLASS/SUBSYSTEM and DRIVER=
S)
linux-kernel@vger.kernel.org (open list)

-- Sebastian

--gcpm4ervip3yvwos
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlhi/98ACgkQ2O7X88g7
+pp7ohAAiHYDxwVufbuBRsZVfzUfNaUPqvycFMf2mOYIOJsBO3oFnedj49hiOb0G
nS3WUHpMvQNLsNs7GcdNxRrV+u9Ia9ecKWEYEwGHLoCGGyBaywjjIq0s9cPFeuB+
Zlfl/y0Jz7dRB7pxv6dLwZWDKDojNCaoP/USTO/lLD2rYfpbDdA94QY1zAJ+adkm
PdQ61jCDyrJVqYkjZfCA9+BvrOtI20FYZuY+jjhdfnPeBtkZstZ2DuCbB2wG4vD6
RsZLgq0CLXlLdIflx0YU+3zGiY0B1++kNtSYlRystFlL+2btAzGm7QeebNVASbqy
JXJaEHfVhvwro8Qt3bswlIHkaDQ2KwIQGvfR5dtSCoZebGP1B+Su31BE4koRMaPs
vaYros/wpczyIO5vSqjzOmO2xFtk8BcMULGYEy4G09PN3JkGNgM39KITKNdKgZE9
D/2K/AMhdt7v82bSy39E4o2jFYBQ+ydgRLs3joenMhufzWrBgXAb/arQ+h8iHs/N
qlKku6Mf9FEKojIJRFwUc5gAa2ncLpKnBZr+BJEGdbWPQskzp1GXb4KqcwuvXvQx
ZuohBP3dJqieROLo1tJrbURr5x+vC402WQAdndyrkyUvtiLyIbb8in2Qinj9uyzp
4pfAYNwbJz8J4vTMgKCCFhRWnvS17Ovr4zhE17/NpkTdvaFCMTA=
=qlIZ
-----END PGP SIGNATURE-----

--gcpm4ervip3yvwos--
