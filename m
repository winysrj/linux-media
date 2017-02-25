Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39952 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752031AbdBYVxZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 16:53:25 -0500
Date: Sat, 25 Feb 2017 22:53:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: camera subdevice support was Re: [PATCH 1/4] v4l2:
 device_register_subdev_nodes: allow calling multiple times
Message-ID: <20170225215321.GA29886@amd>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225000918.GB23662@amd>
 <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Ok, I got the camera sensor to work. No subdevices support, so I don't
> > have focus (etc) working, but that's a start. I also had to remove
> > video-bus-switch support; but I guess it will be easier to use
> > video-multiplexer patches...=20
> >=20
> > I'll have patches over weekend.
>=20
> I briefly looked at what's there --- you do miss the video nodes for the
> non-sensor sub-devices, and they also don't show up in the media graph,
> right?

Yes.

> I guess they don't end up matching in the async list.

How should they get to the async list?

> I think we need to make the non-sensor sub-device support more generic;
> it's not just the OMAP 3 ISP that needs it. I think we need to document
> the property for the flash phandle as well; I can write one, or refresh
> an existing one that I believe already exists.
>=20
> How about calling it either simply "flash" or "camera-flash"? Similarly
> for lens: "lens" or "camera-lens". I have a vague feeling the "camera-"
> prefix is somewhat redundant, so I'd just go for "flash" or "lens".

Actually, I'd go for "flash" and "focus-coil". There may be other
lens properties, such as zoom, mirror movement, lens identification,
=2E..

> At the very least the property names must be generic (not hardware
> dependent) as this kind of functionality should be present in the
> framework rather than in individual drivers. That'll be for later
> though.

Agreed, that would be nice.

> Making the sub-device bus configuration a pointer should be in a separate
> patch. It makes sense since the entire configuration is not valid for all
> sub-devices attached to the ISP anymore. I think it originally was a
> separate patch, but they probably have been merged at some point. I can't
> find it right now anyway.

I believe I can find the patch. But I'm not sure if I can port it to
the fwnode infrastructure anytime soon...

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlix/NEACgkQMOfwapXb+vJ9CACfVFQAdqAqBlCrx+NU6FbqlLiT
SyIAoI2iYskZjmICUjPjvbXFqiaid217
=/h0s
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
