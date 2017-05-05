Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38832 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756036AbdEEIiu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 04:38:50 -0400
Date: Fri, 5 May 2017 10:38:45 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz
Subject: Re: [RFC 1/3] dt: bindings: Add a binding for flash devices
 associated to a sensor
Message-ID: <20170505083845.gwltdxxk4djbbfcf@earth>
References: <1493720749-31509-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493720749-31509-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170504142730.tq4k3paofmyk5jul@earth>
 <1e8d0a73-3f3f-410b-ca04-89fa35b1f0b9@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3ptuqwy2jrcze7a7"
Content-Disposition: inline
In-Reply-To: <1e8d0a73-3f3f-410b-ca04-89fa35b1f0b9@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3ptuqwy2jrcze7a7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, May 05, 2017 at 11:28:34AM +0300, Sakari Ailus wrote:
> Sebastian Reichel wrote:
> > On Tue, May 02, 2017 at 01:25:47PM +0300, Sakari Ailus wrote:
> > > +- flash: An array of phandles that refer to the flash light sources
> > > +  related to an image sensor. These could be e.g. LEDs. In case the =
LED
> > > +  driver drives more than a single LED, then the phandles here refer=
 to
> > > +  the child nodes of the LED driver describing individual LEDs. Only
> > > +  valid for device nodes that are related to an image sensor.
> >=20
> > s/driver/controller/g - DT describes HW. Otherwise
>=20
> Driver is hardware in this case. :-) The chip that acts as a current sink=
 or
> source for the LED is the driver. E.g. the adp1653 documentation describes
> the chip as "Compact, High Efficiency, High Power, Flash/Torch LED Driver
> with Dual Interface".
>=20
> It might be still possible to improve the wording. Software oriented folks
> are more likely to misunderstand the meaning of driver here, but controll=
er
> might seem ambiguous for hardware oriented people.
>=20
> How about:
>=20
> - flash: An array of phandles that refer to the flash light sources
>   related to an image sensor. These could be e.g. LEDs. In case the LED
>   driver (current sink or source chip for the LED(s)) drives more than a
>   single LED, then the phandles here refer to the child nodes of the LED
>   driver describing individual LEDs. Only valid for device nodes that are
>   related to an image sensor.

Maybe drop the last sentence? The requirement is already in the
first one. Otherwise:

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

--3ptuqwy2jrcze7a7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlkMOhIACgkQ2O7X88g7
+praIQ//dI4O5is/HDiHpHPpsKGT/eO2/yMlswrf1RhsjsC9vx4q0spngSg8pUYK
Wy6IuwAQn8VY9TWqMkufU0urO1F+AYlrV4g/r8Kfr89X82deTtwHtPpeUjIPI91B
TtSL/SvBNhzNWWwZzTdY/8pIORWHlOMdl538jeHo1dCQjQn4YdgIkrW4FiAwGLK4
z8yoRn5g4gAHJDkXO4EStUkDBKqoebYGKIvqBxdLArSeGYnETITIO6sjKP413pt1
KqtoWSzWti5+14BwyO0Q9bRwF6o8a1yFxagz2tsIkxlMiBd4rcBRa+xiPrpxiDcw
GchAmThqd6mxF9/sX+3cef3Cyg59wkf5UxFjguAUdRO7veQaL2WhAzts8AqdKpuC
egrnC/A9Vu1x+KcH3jIkARmX+MArgG7HMjPr4d2jIqPT916SBoSPRQPVlnBb3w1l
2KncnCdeFP4wcRRRKR8qvLrG23ZADAyOP7HVqRk3npNHK67+YY9GtjqejAQlCCrp
Q1gYuyA88kIZUCz3ditPCk7Uo8G4BYi8vWQ5Y1fxahrFHB39JYUeOEdZTyibI1mA
WjLzRcjJtndtkytycyiofAxMiEnG5lA8Kj5ItlXs6pAyYO4b19UG/W/4TzBtKkiA
dZv94WkNv6yDPwzNLNQiUA9NdXD+HX5DmuNymNudC04FitPGEdo=
=JffM
-----END PGP SIGNATURE-----

--3ptuqwy2jrcze7a7--
