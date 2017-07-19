Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:60815 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754052AbdGSLSz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 07:18:55 -0400
Date: Wed, 19 Jul 2017 13:18:43 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org, pavel@ucw.cz
Subject: Re: [PATCH 3/8] dt: bindings: Add a binding for referencing EEPROM
 from camera sensors
Message-ID: <20170719111843.kyoqtqonhdkyvrjz@flea>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-4-git-send-email-sakari.ailus@linux.intel.com>
 <20170719075255.yuar2xbeyisgl3we@flea>
 <20170719092106.xqichkcd6yepchxy@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="m2oixmv22ytf546p"
Content-Disposition: inline
In-Reply-To: <20170719092106.xqichkcd6yepchxy@kekkonen.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--m2oixmv22ytf546p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Wed, Jul 19, 2017 at 12:21:06PM +0300, Sakari Ailus wrote:
> On Wed, Jul 19, 2017 at 09:52:55AM +0200, Maxime Ripard wrote:
> > Hi Sakari,
> >=20
> > On Wed, Jun 14, 2017 at 12:47:14PM +0300, Sakari Ailus wrote:
> > > Many camera sensor devices contain EEPROM chips that describe the
> > > properties of a given unit --- the data is specific to a given unit c=
an
> > > thus is not stored e.g. in user space or the driver.
> > >=20
> > > Some sensors embed the EEPROM chip and it can be accessed through the
> > > sensor's I2C interface. This property is to be used for devices where=
 the
> > > EEPROM chip is accessed through a different I2C address than the sens=
or.
> > >=20
> > > The intent is to later provide this information to the user space.
> > >=20
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Acked-by: Pavel Machek <pavel@ucw.cz>
> > > Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> > > ---
> > >  Documentation/devicetree/bindings/media/video-interfaces.txt | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/media/video-interfaces=
=2Etxt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > > index a18d9b2..ae259924 100644
> > > --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > > +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > > @@ -76,6 +76,9 @@ Optional properties
> > > =20
> > >  - lens-focus: A phandle to the node of the focus lens controller.
> > > =20
> > > +- eeprom: A phandle to the node of the EEPROM describing the camera =
sensor
> > > +  (i.e. device specific calibration data), in case it differs from t=
he
> > > +  sensor node.
> >=20
> > Wouldn't it makes sense (especially if you want to provide user space
> > access) to reuse what nvmem provides for this?
>=20
> I wasn't aware of the nvmem bindings. Thanks for the pointer.
>=20
> These are EEPROM chips that already have bindings documented under
> Documentation/devicetree/bindings/eeprom as well as existing drivers under
> drivers/misc/eeprom. Is there a reason why we have separate eeprom and
> nvmem devices? Do you see issues in adding nvmem support for the existing
> eeprom drivers, other than it misses using the nvmem framework?

As far as I know, the nvmem framework has superseeded the
drivers/misc/eeprom one, and both AT24 and AT25's bindings are still
respected by their respective drivers in nvmem.

> There's also a small issue (or a big one, depending on which part of it y=
ou
> consider) of the EEPROM content being parsed in the user space. The sensor
> drivers do not use that information nor the contents are specific to the
> sensor alone, it is ultimately up to the system integrator what to put to
> the EEPROM. The typical size of an EEPROM is in perhaps one or two
> kilobytes so that there's a lot of room for storing different individual
> settings there.
>=20
> nvmem bindings require referring to individual data cells but it's rather
> the entire EEPROM contents that would be of interest here. I guess you
> could create a single node under the EEPROM chip that covers the entire
> chip. Or change the documentation to allow referring to the chip, rather
> than a node under it.

I'm not sure I really followed your thoughts here, but the fact that
the EEPROM are usually way larger than the data each and every driver
needs is indeed true. And this is exactly why we have cells, in order
to differentiate the camera calibration data, from the touchscreen
ones, and from the MAC address of the device.

I guess if you really need the whole EEPROM, yeah, a single big cell
would be the way to go I guess.

And there's currently a way to lockdown the EEPROM at the provider
level, I guess it would make sense to have the same kind of API for
the consumer too if the data are to be protected.

I'm not that involved in nvmem anymore, so the maintainer might have a
different opinion though :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--m2oixmv22ytf546p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZb0ATAAoJEBx+YmzsjxAgWQYP/R8NE5547ftQC695mv74j+U7
AWQ9LFMOdn5f6y/+5wODokhGE5avIy+uhWRIA5+asL7cJBnORA5a+sJmsxAAdMMR
Bvk2kGvXpSgdUi5ieGFA7bal0LmR4Yl4vZUudkNi68DmAuuQ0vrWsbdtAFtQbkwu
db0PFq1GT0OPukfc4SQCGcNf7XdS/hojhigVz2v7xY6FyWdFM3iqL+blbWfFa3hW
n6HaP2wO9fHXxX89GHxJ77fslLfGIbrYIbDEKs86FCA8iPzyOu2aTzg78+awm+od
DIKxWiaruD/d6D5z7fV/2NhbZZayl7ojitC5bvhd9s8rcI+MQA8uy31XSaXH5rqA
jgJd+68admX59oMiKjOJ0Gb+520JKuM3cvW8ux15h0HVrwZgRbSysor1+CwnypjU
ZGffJkpxyNWtHWsmcRx8jD0HgGd1NNpJtKtUUXsvKD+z65r/R0a60/Gx8acyiF1P
bkI4kcmSYNmmEn+9qTIzSeAFol7SdGfe7J2Cd3ZMiNX6eJBoy2STduxnFo1L+ixW
/5hF1beFxi5KfKK5aIRuWvm12kMwnXE1RMeRy9djkKtN3kJCGphtc1pDYeeuj1h9
GBJxgh5Eeq+Ou0FOsER8G+8MQCaqPDx+v8ykGkGSLqx2Gs1u2gtHn/HrB4luRs+h
lCBNYSBqCQwLEQVqpNKM
=m7xt
-----END PGP SIGNATURE-----

--m2oixmv22ytf546p--
