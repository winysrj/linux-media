Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51359 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750981AbdBTWsP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 17:48:15 -0500
Date: Mon, 20 Feb 2017 23:48:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/2] v4l: Add camera voice coil lens control class,
 current control
Message-ID: <20170220224812.GA26600@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170214224750.GE11317@amd>
 <f3ba8ca3-0931-604e-d84c-43c0e43857db@linux.intel.com>
 <20170215080909.GA3693@amd>
 <20170220222618.GZ16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <20170220222618.GZ16975@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > I wonder... should we somehow expose the range of diopters to
> > > > userspace? I believe userland camera application will need that
> > > > information.
> > >=20
> > > It'd certainly be useful to be able to provide more information.
> > >=20
> > > The question is: where to store it, and how? It depends on the voice
> > > coil, the spring constant, the lens and the distance of the lens from
> > > the sensor --- at least. Probably the sensor size as well.
> > >=20
> > > On voice coil lenses it is also somewhat inexact.
> >=20
> > I was thinking read-only attribute providing minimum and maximum
> > diopters in case there's linear relationship as on N900.
> >=20
> > +#define V4L2_CID_VOICE_DIOPTERS_AT_REST (V4L2_CID_VOICE_COIL_CLASS_BAS=
E + 2)
> > +#define V4L2_CID_VOICE_DIOPTERS_AT_MAX (V4L2_CID_VOICE_COIL_CLASS_BASE=
 + 3)
>=20
> Where do you store that information and how? Should the user be also told
> how the applied current affects the value?

The information would come from device tree.

User already knows minimum and maximum, so if he knows there's linear
relationship, he has complete picture. I'm not sure if there are some
voice coils with anything else then linear relationship. I guess we
could do

+#define V4L2_CID_VOICE_CURRENT_TO_DIOPTERS (V4L2_CID_VOICE_COIL_CLASS_BASE=
 + 4)
#define ..._LINEAR 1

=2E..

> I also wonder whether that's the best way to provide the information to t=
he
> user --- we have things such as devices that are a part of a camera module
> and telling the user on which side of the device the camera is located.
>=20
> We've been planning to have a property API for this to provide the user w=
ith
> a tree of key-value pairs, with details unsettled as of yet, so it's
> certainly nothing that could be used yet.

You know the design better than I do. I believe read-only properties
would be easy enough for this.

> Do you have a user application that could make use of such information?

fcam-dev,
yes. https://gitlab.com/pavelm/fcam-devhttps://gitlab.com/pavelm/fcam-dev

I don't promise to make neccessary modifications -- currently it
hardcodes 0 and 20 diopters -- but it allows manual or automatic
focus; in both modes it is good to tell user where he is focusing, and
it is pretty much mandatory in the manual mode.

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlirciwACgkQMOfwapXb+vL6fgCfUcs4CAa4/Hm62I2VeASAT9Gv
Ye0AoIcT3vOWT1E+qMWrOJGHMXMHBp0b
=ytcn
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
