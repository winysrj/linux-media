Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53712 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbeIUCN5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 22:13:57 -0400
Date: Thu, 20 Sep 2018 22:28:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/4] [media] ad5820: DT new optional field enable-gpios
Message-ID: <20180920202840.GA31044@amd>
References: <20180920161912.17063-1-ricardo.ribalda@gmail.com>
 <20180920161912.17063-3-ricardo.ribalda@gmail.com>
 <1939782.bRt5jKDIiS@avalon>
 <2983018.WjSXnZMEY4@avalon>
 <CAPybu_2Ke7qAx=3LRX6aEbGSD56Z+RhWKX=gEXR6WCgyOegxEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <CAPybu_2Ke7qAx=3LRX6aEbGSD56Z+RhWKX=gEXR6WCgyOegxEw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2018-09-20 22:25:54, Ricardo Ribalda Delgado wrote:
> Hi
> On Thu, Sep 20, 2018 at 10:23 PM Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> >
> > On Thursday, 20 September 2018 23:21:28 EEST Laurent Pinchart wrote:
> > > Hi Ricardo,
> > >
> > > Thank you for the patch.
> > >
> > > On Thursday, 20 September 2018 19:19:11 EEST Ricardo Ribalda Delgado =
wrote:
> > > > Document new enable-gpio field. It can be used to disable the part
> > > > without turning down its regulator.
> > > >
> > > > Cc: devicetree@vger.kernel.org
> > > > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> > > > ---
> > > >
> > > >  Documentation/devicetree/bindings/media/i2c/ad5820.txt | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > > > b/Documentation/devicetree/bindings/media/i2c/ad5820.txt index
> > > > 5940ca11c021..07d577bb37f7 100644
> > > > --- a/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > > > +++ b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > > >
> > > > @@ -8,6 +8,11 @@ Required Properties:
> > > >    - VANA-supply: supply of voltage for VANA pin
> > > >
> > > > +Optional properties:
> > > > +
> > > > +   - enable-gpios : GPIO spec for the XSHUTDOWN pin.
> > >
> > > xshutdown is active-low, so enable is active-high. Should this be doc=
umented
> > > explicitly, to avoid polarity errors ? Maybe something along the line=
s of
> > >
> > > - enable-gpios: GPIO spec for the XSHUTDOWN pin. Note that the polari=
ty of
> > > the enable GPIO is the opposite of the XSHUTDOWN pin (asserting the e=
nable
> > > GPIO deasserts the XSHUTDOWN signal and vice versa).
>=20
> Agreed
>=20
> >
> > Or alternatively you could name the property xshutdown-gpios, as explai=
ned in
> > my (incorrect) review of 2/4.
>=20
> I have double negatives :). If there is no other option I will rename
> it xshutdown, but I want to give it a try to enable.

I think enable is fine.

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlukAvgACgkQMOfwapXb+vKwZgCeM/O6ef+EQUJCEEyJ6OnPsaC+
3p4AniB7FLELDJ+pEh3iebiI5PzkLqwc
=+ulO
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
