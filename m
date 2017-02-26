Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50349 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdBZIiz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Feb 2017 03:38:55 -0500
Date: Sun, 26 Feb 2017 09:38:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: camera subdevice support was Re: [PATCH 1/4] v4l2:
 device_register_subdev_nodes: allow calling multiple times
Message-ID: <20170226083851.GA8840@amd>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225000918.GB23662@amd>
 <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
 <20170225215321.GA29886@amd>
 <20170225231754.GY16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <20170225231754.GY16975@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Ahoj! :-)

> > > > Ok, I got the camera sensor to work. No subdevices support, so I do=
n't
> > > > have focus (etc) working, but that's a start. I also had to remove
> > > > video-bus-switch support; but I guess it will be easier to use
> > > > video-multiplexer patches...=20
> > > >=20
> > > > I'll have patches over weekend.
> > >=20
> > > I briefly looked at what's there --- you do miss the video nodes for =
the
> > > non-sensor sub-devices, and they also don't show up in the media grap=
h,
> > > right?
> >=20
> > Yes.
> >=20
> > > I guess they don't end up matching in the async list.
> >=20
> > How should they get to the async list?
>=20
> The patch you referred to does that. The problem is, it does make the bus
> configuration a pointer as well. There should be two patches. That's not a
> lot of work to separate them though. But it should be done.

Well... This is the line I'm fighting with:

+ of_parse_phandle(dev->of_node, "ti,camera-flashes",
+							flash++)

If someone told me its fwnode equivalent, I might be able to get it to
work. Knowing what group_id is and if I could ignore it would help a
bit, too :-).

(Also, I'll be glad to test patches :-))

> > > I think we need to make the non-sensor sub-device support more generi=
c;
> > > it's not just the OMAP 3 ISP that needs it. I think we need to docume=
nt
> > > the property for the flash phandle as well; I can write one, or refre=
sh
> > > an existing one that I believe already exists.
> > >=20
> > > How about calling it either simply "flash" or "camera-flash"? Similar=
ly
> > > for lens: "lens" or "camera-lens". I have a vague feeling the "camera=
-"
> > > prefix is somewhat redundant, so I'd just go for "flash" or "lens".
> >=20
> > Actually, I'd go for "flash" and "focus-coil". There may be other
> > lens properties, such as zoom, mirror movement, lens identification,
> > ...
>=20
> Good point. Still there may be other ways to move the lens than the voice
> coil (which sure is cheap), so how about "flash" and "lens-focus"?

Sounds good to me.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliylBoACgkQMOfwapXb+vKAlgCfaoIIeXVh827dwK01sgT2Q81n
Ye0AoJKEbuLBCyVKDxvwQN/m8sUCndYi
=c60Q
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
