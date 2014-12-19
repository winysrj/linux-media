Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53930 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751762AbaLSV7Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 16:59:24 -0500
Date: Fri, 19 Dec 2014 19:20:11 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 02/13] pinctrl: sun6i: Add A31s pinctrl support
Message-ID: <20141219182011.GS4820@lukather>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
 <1418836704-15689-3-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFRfxei4j9xfgtfb"
Content-Disposition: inline
In-Reply-To: <1418836704-15689-3-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--UFRfxei4j9xfgtfb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2014 at 06:18:13PM +0100, Hans de Goede wrote:
> The A31s is a stripped down version of the A31, as such it is missing some
> pins and some functions on some pins.
>=20
> The new pinctrl-sun6i-a31s.c this commit adds is a copy of pinctrl-sun6i-=
a31s.c

I guess you meant pinctrl-sun6i-a31.c for the second one, right?

> with the missing pins and functions removed.
>=20
> Note there is no a31s specific version of pinctrl-sun6i-a31-r.c, as the
> prcm pins are identical between the A31 and the A31s.
>=20
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

We should probably refactor it at some point like mvebu does though to
deal with similar pin sets like this and the A31.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--UFRfxei4j9xfgtfb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUlGxbAAoJEBx+YmzsjxAgclYP/2x9Ba71Kdya9e8aP0NRAbon
TVgV3CtH1bfNLDbBff0f4dQ8EEMA8wdryh1TR2GQUypVWKVX39FadacxhcfLQiX9
+BkvJYEBEw6aLThy0XYcnsh7jYz+qp713ZTG2/oswmr57GY3l9UIwCxre6bHEPgd
iuTC6BRzNCxVvudsDVQpun8GaHQ1De2WMsjXPBOAUNjk8qWcl1BcG/emivfwWu17
0JEdH90WLrdo70pR9D5mSW7J6ceFjhTTx59Fo5RhuHgM5rELnsha7YKmIRA19taW
EsJhCEsflQEOMmkBCD+eLfGOckDXDkX/XrdRRe8kSa9FbT4vnRbw41X2ViDcpliu
5XQvFGvXJO/91pzPqBNEb4huGPTA34DXD2kbpRPxw/HpWZPhRCpdS43Haa+RrKju
eL1dEWMnzGXVDXSYntx5Z9+yboEWikVAF9yuBKxRaU7905Cl/2uWKfMSi1myo+ve
+ath5y54agoQ5j+xpbLD3gej1Dmt99BUWHK5tgN/pxuTtWsC/aRMb7xuZHLe+RoZ
tykRqhjOsQIDb5Elk020Xrx/fOns1eY/w1ZbimLC0LJ7T8nhiPMUsYOQ6t9KK4g+
E3MM8Ssjk3uYoZfB7qHhOEd/R4dFz2pqL47YjEi7ZH5yA52xzhRhqyJ7QqeHNgeh
f98Np/TTIiyG4900ecKH
=tYMr
-----END PGP SIGNATURE-----

--UFRfxei4j9xfgtfb--
