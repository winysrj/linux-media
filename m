Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:42379 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaFXWEM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 18:04:12 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so1054972wgh.35
        for <linux-media@vger.kernel.org>; Tue, 24 Jun 2014 15:04:11 -0700 (PDT)
Date: Wed, 25 Jun 2014 00:04:07 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Eric =?utf-8?Q?B=C3=A9nard?= <eric@eukrea.com>
Cc: Denis Carikli <denis@eukrea.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devel@driverdev.osuosl.org, Russell King <linux@arm.linux.org.uk>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v14 08/10] drm/panel: Add Eukrea mbimxsd51 displays.
Message-ID: <20140624220404.GA30155@mithrandir>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com>
 <1402913484-25910-8-git-send-email-denis@eukrea.com>
 <20140624214926.GA30039@mithrandir>
 <20140624235639.487429ad@e6520eb>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20140624235639.487429ad@e6520eb>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2014 at 11:56:39PM +0200, Eric B=C3=A9nard wrote:
> Hi Thierry,
>=20
> Le Tue, 24 Jun 2014 23:49:37 +0200,
> Thierry Reding <thierry.reding@gmail.com> a =C3=A9crit :
>=20
> > On Mon, Jun 16, 2014 at 12:11:22PM +0200, Denis Carikli wrote:
> > [...]
> > > diff --git a/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51=
-dvi-svga.txt b/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dv=
i-svga.txt
> > [...]
> > > @@ -0,0 +1,7 @@
> > > +Eukrea DVI-SVGA (800x600 pixels) DVI output.
> > [...]
> > > diff --git a/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51=
-dvi-vga.txt b/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi=
-vga.txt
> > [...]
> > > @@ -0,0 +1,7 @@
> > > +Eukrea DVI-VGA (640x480 pixels) DVI output.
> >=20
> > DVI outputs shouldn't be using the panel framework and this binding at
> > all. DVI usually has the means to determine all of this by itself. Why
> > do you need to represent this as a panel in device tree?
> >=20
> because on this very simple display board, we only have DVI LVDS signals
> without the I2C to detect the display.

That's unfortunate. In that case perhaps a better approach would be to
add a video timings node to the device that provides the DVI output?

The panel bindings are really for internal panels and should define all
of their properties. That's also why they need a specific compatible
string.

What the above two bindings define are really "connectors" with a fixed
resolution rather than panels.

Thierry

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTqfXUAAoJEN0jrNd/PrOhfzMP/2KnbQR781te8wsWlzDpejFf
LIaSgQG9t36w3Gl4ZU+ji5dMMfnYimoomxlRK5kglZ8xuiA0I9EsHsor1A71+LKh
g2byFQBD7a8R2F2NEEM3UJuTSRYaWKp7fHL6yfrgZ+6LWz1GsgEALrYTi1NKjENt
/vvAYmPo4PqXEG7nvP+iOV7YcL7FwHJTwdvclpsMjxwWSjFqY+7aHULZGeND8wgY
DCF0xdGlFz3t65F08yUciaFCpJpXDURUEKVnc4wrCB2QvHGUb3CecvDI1bEDWsEB
e47KwE1vugN6gpCMF+OWYRlGfeQZjyX73Gmh0pPcTR9PUFceVIwOqSb8ulJf6CC7
OSVWJUa63/DpgxAnLUCm0zVmgeDoyEQ9CX/Knc/t3TSqpaB1ggH+h3egKqAjHEvt
XkwAk55qJYOONmZMbZ89Hp8LkUlvHYQ7To5FQhtxXv96VY65O5IzW/yV8JNuLmN/
rDGHtuW6mnMUjhTf1o2j5SdtGIIc8dAyykh5wi+roK5u60RrwWrBMYz2w3e9CY3x
2lB7blV3IKmNVk+NFK9ML7UQjRXM3OH+0UhVjZf0KqvyL7n0LIW3sdqsWbLx7bzT
tPvygVzutGfrYIkFTWa8xDV1zVAEv0ayEgJB3ilHvR5W/9w1+TjWj1kuIj80ITxK
BwSydfcGVt8pEuiEEOyb
=0HU8
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
