Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53792 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdIRUyJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 16:54:09 -0400
Date: Mon, 18 Sep 2017 22:54:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, jacek.anaszewski@gmail.com
Subject: Re: [RESEND PATCH v2 4/6] dt: bindings: as3645a: Improve label
 documentation, DT example
Message-ID: <20170918205407.GA1849@amd>
References: <20170918102349.8935-1-sakari.ailus@linux.intel.com>
 <20170918102349.8935-5-sakari.ailus@linux.intel.com>
 <20170918105655.GA14591@amd>
 <20170918144923.dnhrxkirle3fvdfo@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20170918144923.dnhrxkirle3fvdfo@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-09-18 17:49:23, Sakari Ailus wrote:
> Hi Pavel,
>=20
> On Mon, Sep 18, 2017 at 12:56:55PM +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > > Specify the exact label used if the label property is omitted in DT, =
as
> > > well as use label in the example that conforms to LED device naming.
> > >=20
> > > @@ -69,11 +73,11 @@ Example
> > >  			flash-max-microamp =3D <320000>;
> > >  			led-max-microamp =3D <60000>;
> > >  			ams,input-max-microamp =3D <1750000>;
> > > -			label =3D "as3645a:flash";
> > > +			label =3D "as3645a:white:flash";
> > >  		};
> > >  		indicator@1 {
> > >  			reg =3D <0x1>;
> > >  			led-max-microamp =3D <10000>;
> > > -			label =3D "as3645a:indicator";
> > > +			label =3D "as3645a:red:indicator";
> > >  		};
> > >  	};
> >=20
> > Ok, but userspace still has no chance to determine if this is flash
> > from main camera or flash for front camera; todays smartphones have
> > flashes on both cameras.
> >=20
> > So.. Can I suggset as3645a:white:main_camera_flash or main_flash or
> > ....?
>=20
> If there's just a single one in the device, could you use that?
>=20
> Even if we name this so for N9 (and N900), the application still would on=
ly
> work with the two devices.

Well, I'd plan to name it on other devices, too.

> My suggestion would be to look for a flash LED, and perhaps the maximum
> current as well. That should generally work better than assumptions on the
> label.

If you just look for flash LED, you don't know if it is front one or
back one. Its true that if you have just one flash it is usually on
the back camera, but you can't know if maybe driver is not available
for the main flash.

Lets get this right, please "main_camera_flash" is 12 bytes more than
"flash", and it saves application logic.. more than 12 bytes, I'm sure.=20

> For association with a particular camera --- in the long run I'd propose =
to
> use Media controller / property API for that in the long run. We don't ha=
ve
> that yet though.

We don't have that yet. Plus simple applications may not want to talk
v4l2 ioctls....

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnAMm8ACgkQMOfwapXb+vKPigCaAx2L6G1ehx1bKrHjBe6YxTfb
KrUAoIx20jUf7Eo83qf+6CdWJ6Ea49gq
=z1/K
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
