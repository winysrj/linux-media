Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53560 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbeIUCGh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 22:06:37 -0400
Date: Thu, 20 Sep 2018 22:21:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2 2/4] [media] ad5820: Add support for enable pin
Message-ID: <20180920202122.GA30748@amd>
References: <20180920161912.17063-2-ricardo.ribalda@gmail.com>
 <20180920184552.4919-1-ricardo.ribalda@gmail.com>
 <20180920185405.GA26589@amd>
 <CAPybu_2hjrq=r+kpAHKxX59gOXfbqGf9CUPh9CNqv7WGqJsrQQ@mail.gmail.com>
 <20180920190855.GC26589@amd>
 <CAPybu_2mNE7Jmfm2n60Z9Hk_iO+-zLgtu4xn72pJUSXBitVg=g@mail.gmail.com>
 <20180920201420.GA28766@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20180920201420.GA28766@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > ad5820: dac@0c {
> > > >    compatible =3D "adi,ad5820";
> > > >    reg =3D <0x0c>;
> > > >
> > > >    VANA-supply =3D <&pm8994_l23>;
> > > >    enable-gpios =3D <&msmgpio 26 GPIO_ACTIVE_HIGH>;
> > > > };
> > >
> > > Well, I'm sure you could have gpio-based regulator powered from
> > > pm8994_l23, and outputting to ad5820.
> > >
> > > Does ad5820 chip have a gpio input for enable?
> >=20
> > xshutdown pin:
> > http://www.analog.com/media/en/technical-documentation/data-sheets/AD58=
21.pdf
> >=20
> > (AD5820,AD5821, and AD5823 are compatibles, or at least that is waht
> > the module manufacturer says :)
>=20
> Aha, sorry for the noise.
>=20
> 2,3: Acked-by: Pavel Machek <pavel@ucw.cz>

And I forgot to mention. If ad5821 and ad5823 are compatible, it would
be good to mention it somewhere where it is easy to find... That can
save quite a bit of work to someone.

Thanks,
								Pavel


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlukAUIACgkQMOfwapXb+vKfkgCaAp3YUw8ANWqeDyzntNg6Sar4
sH0AmQHxE0BGFw/kcXRQXItye37lsY7y
=OWrj
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
