Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34484 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdGGQP2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 12:15:28 -0400
Date: Fri, 7 Jul 2017 18:15:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rob Herring <robh@kernel.org>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>
Subject: Re: [PATCH 4/4] [media] rc: pwm-ir-tx: add new driver
Message-ID: <20170707161524.GA11857@amd>
References: <cover.1498992850.git.sean@mess.org>
 <88fa0219db3388fad7bcc7b20cf30dd41e763aee.1498992850.git.sean@mess.org>
 <20170707135928.6cs6vx7z6lj3birp@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20170707135928.6cs6vx7z6lj3birp@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-07-07 08:59:28, Rob Herring wrote:
> On Sun, Jul 02, 2017 at 12:06:13PM +0100, Sean Young wrote:
> > This is new driver which uses pwm, so it is more power-efficient
> > than the bit banging gpio-ir-tx driver.
> >=20
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  .../devicetree/bindings/leds/irled/pwm-ir-tx.txt   |  13 ++
>=20
> Please make this a separate patch.

Come on... The driver is trivial, and you even quoted the binding
below. Saying "Acked-by:" would not have been that much additional
work...

Thanks,
								Pavel


> >  drivers/media/rc/Kconfig                           |  12 ++
> >  drivers/media/rc/Makefile                          |   1 +
> >  drivers/media/rc/pwm-ir-tx.c                       | 165 +++++++++++++=
++++++++
> >  4 files changed, 191 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/leds/irled/pwm-ir=
-tx.txt
> >  create mode 100644 drivers/media/rc/pwm-ir-tx.c
> >=20
> > diff --git a/Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt=
 b/Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt
> > new file mode 100644
> > index 0000000..6887a71
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt
> > @@ -0,0 +1,13 @@
> > +Device tree bindings for IR LED connected through pwm pin which is use=
d as
> > +IR transmitter.
> > +
> > +Required properties:
> > +- compatible: should be "pwm-ir-tx".
> > +- pwms : PWM property to point to the PWM device (phandle)/port (id) a=
nd to
> > +  specify the period time to be used: <&phandle id period_ns>;
> > +
> > +Example:
> > +	irled {
> > +		compatible =3D "pwm-ir-tx";
> > +		pwms =3D <&pwm0 0 10000000>;
> > +	};

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllfs5wACgkQMOfwapXb+vJDsACeNBDIT0Mqy0SRsqnw4tRQ9uvn
wtUAn19JLMxWhpJwI23ctK8xll6vdJ82
=DDld
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
