Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53407 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbeIUB7f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 21:59:35 -0400
Date: Thu, 20 Sep 2018 22:14:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2 2/4] [media] ad5820: Add support for enable pin
Message-ID: <20180920201420.GA28766@amd>
References: <20180920161912.17063-2-ricardo.ribalda@gmail.com>
 <20180920184552.4919-1-ricardo.ribalda@gmail.com>
 <20180920185405.GA26589@amd>
 <CAPybu_2hjrq=r+kpAHKxX59gOXfbqGf9CUPh9CNqv7WGqJsrQQ@mail.gmail.com>
 <20180920190855.GC26589@amd>
 <CAPybu_2mNE7Jmfm2n60Z9Hk_iO+-zLgtu4xn72pJUSXBitVg=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <CAPybu_2mNE7Jmfm2n60Z9Hk_iO+-zLgtu4xn72pJUSXBitVg=g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2018-09-20 21:12:44, Ricardo Ribalda Delgado wrote:
> On Thu, Sep 20, 2018 at 9:08 PM Pavel Machek <pavel@ucw.cz> wrote:
> >
> > On Thu 2018-09-20 21:06:16, Ricardo Ribalda Delgado wrote:
> > > Hi Pavel
> > >
> > > On Thu, Sep 20, 2018 at 8:54 PM Pavel Machek <pavel@ucw.cz> wrote:
> > > >
> > > > On Thu 2018-09-20 20:45:52, Ricardo Ribalda Delgado wrote:
> > > > > This patch adds support for a programmable enable pin. It can be =
used in
> > > > > situations where the ANA-vcc is not configurable (dummy-regulator=
), or
> > > > > just to have a more fine control of the power saving.
> > > > >
> > > > > The use of the enable pin is optional.
> > > > >
> > > > > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> > > >
> > > > Do we really want to do that?
> > > >
> > > > Would it make more sense to add gpio-regulator and connect ad5820 to
> > > > it in such case?
> > > >
> > >
> > > My board (based on db820c)  has both:
> > >
> > > ad5820: dac@0c {
> > >    compatible =3D "adi,ad5820";
> > >    reg =3D <0x0c>;
> > >
> > >    VANA-supply =3D <&pm8994_l23>;
> > >    enable-gpios =3D <&msmgpio 26 GPIO_ACTIVE_HIGH>;
> > > };
> >
> > Well, I'm sure you could have gpio-based regulator powered from
> > pm8994_l23, and outputting to ad5820.
> >
> > Does ad5820 chip have a gpio input for enable?
>=20
> xshutdown pin:
> http://www.analog.com/media/en/technical-documentation/data-sheets/AD5821=
=2Epdf
>=20
> (AD5820,AD5821, and AD5823 are compatibles, or at least that is waht
> the module manufacturer says :)

Aha, sorry for the noise.

2,3: Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAluj/5wACgkQMOfwapXb+vLWCQCePWD+ay3G+of16Itk/4RyVzzv
auMAn3Lj14BEIoJDo8pHFjDoPnZnx4GI
=VFDe
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
