Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44474 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbdBHWyr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 17:54:47 -0500
Date: Wed, 8 Feb 2017 23:34:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rob Herring <robh@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170208223451.GB18807@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170208213609.lnemfbzitee5iur2@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline
In-Reply-To: <20170208213609.lnemfbzitee5iur2@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > +
> > +This is a binding for a gpio controlled switch for camera interfaces. =
Such a
> > +device is used on some embedded devices to connect two cameras to the =
same
> > +interface of a image signal processor.
> > +
> > +Required properties
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +compatible	: must contain "video-bus-switch"
>=20
> video-bus-gpio-mux

Sakari already asked for rename here. I believe I waited reasonable
time, but got no input from you, so I did rename it. Now you decide on
different name.

Can we either get timely reactions or less bikeshedding?

Thanks,

                                                                Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlibnQsACgkQMOfwapXb+vK4AwCfWHApSSpUayjTh5nbxb5ftZpY
stkAn1uv9NjSXr4ZKN5ZScKUq8rfHl11
=Lg5y
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
