Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44982 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752423AbdFOMvX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 08:51:23 -0400
Date: Thu, 15 Jun 2017 14:51:19 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org, pavel@ucw.cz
Subject: Re: [PATCH 5/8] v4l2-flash: Flash ops aren't mandatory
Message-ID: <20170615125118.ja4ghpyzdwa5qkvh@earth>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-6-git-send-email-sakari.ailus@linux.intel.com>
 <20170615092425.xcgeiu65yxawczr5@earth>
 <20170615123209.GD12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ih6uqwmmuphhrzuf"
Content-Disposition: inline
In-Reply-To: <20170615123209.GD12407@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ih6uqwmmuphhrzuf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 15, 2017 at 03:32:10PM +0300, Sakari Ailus wrote:
> On Thu, Jun 15, 2017 at 11:24:26AM +0200, Sebastian Reichel wrote:
> > On Wed, Jun 14, 2017 at 12:47:16PM +0300, Sakari Ailus wrote:
> > > None of the flash operations are not mandatory and therefore there sh=
ould
> > > be no need for the flash ops structure either. Accept NULL.
> >=20
> > I think you negated one time too much :). Otherwise:
> >=20
> > Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
>=20
> Thanks!
>=20
> The new one reads:
>=20
> None of the flash operations are mandatory and therefore there should be =
no
> need for the flash ops structure either. Accept NULL.

Fine with me.

-- Sebastian

--ih6uqwmmuphhrzuf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAllCgsYACgkQ2O7X88g7
+pqjCQ/+M2CPvVg20s0qtvUk8dzJUxgHoBo4yLLeGMAHlJiG2ma/ma0OvwBW8tN1
tbQyU4gXl7s4vdmRT/dHJhwxhdIfTM5DWG1KpWf5rSDzw7yvL0KMbnIFwPcq2Gcg
xRl5llGBjiPYPnzh2jr5u04MQSHCgHPYn723yiLhIhPgmjmiIeGLT01/eNGN9flE
N142iAyV1HNHpf17nDk6Tq/VqH2x/oW/qEfGbDOlWbvV3qP2ljNlxpP5bzJK1kMe
3GFL+KAOObeSk3ZsRvH9MgNsifB0yE0B8Ljo3gwpv7+yv2FjLkyQiPe/JSL/HGHF
fvXwjxRXY7KQidk/QNKLvOK1wOicQxUq68pbbkyblpxekeJqFdIXY3aEUoX1w8oB
zaYYQouQU+PtUe34QQKme1EYkNfMw7V8/PtV8qfNszXosVeqHDYQXYegQJ2V5bcf
whybbt6dwiPgb8JroJ7st/Fod8UBy1jS6/XSb93VcGl0MPXbnngf09FrranBPG68
VY9DmkS3wPPqWlx9+faBqmPlpSeDcBROLrwGXAy69aMc6Nw3Chh3+VSdE6LG8+SX
Rk6GUboyi3MzyZoJ6zCCJNsMQKUVKh2GrS7j9aIk37UkIv492AKPEZ7z3EcLU9JV
q7ekfu/TWjjxVhwPFm7CQrODcf2mpGwP1BLdRZW8FXQNKGeoVK8=
=Jbq8
-----END PGP SIGNATURE-----

--ih6uqwmmuphhrzuf--
