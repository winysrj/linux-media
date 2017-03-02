Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35899 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932113AbdCBJCo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 04:02:44 -0500
Date: Thu, 2 Mar 2017 09:54:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Rob Herring <robh@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        p.zabel@pengutronix.de
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170302085456.GA27818@amd>
References: <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170208213609.lnemfbzitee5iur2@rob-hp-laptop>
 <20170208223017.GA18807@amd>
 <CAL_JsqKSHvg+iB-SRd=YthauGP8mWeVF0j8X-fgLchwtOppH8A@mail.gmail.com>
 <CAL_JsqLfbAxBbXOyK0QOCc=wPe6=a+qyrAwtdbt3DtspK6oiaw@mail.gmail.com>
 <20170210195435.GA1615@amd>
 <20170210221742.GI13854@valkosipuli.retiisi.org.uk>
 <20170213095420.GA7065@amd>
 <20170213102034.GI16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20170213102034.GI16975@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-02-13 12:20:35, Sakari Ailus wrote:
> Hi Pavel,
>=20
> On Mon, Feb 13, 2017 at 10:54:20AM +0100, Pavel Machek wrote:
> > Hi!
> >=20
> > > > Take a look at the wikipedia. If you do "one at a time" at 100Hz, y=
ou
> > > > can claim it is time-domain multiplex. But we are plain switching t=
he
> > > > cameras. It takes second (or so) to setup the pipeline.
> > > >=20
> > > > This is not multiplex.
> > >=20
> > > The functionality is still the same, isn't it? Does it change what it=
 is if
> > > the frequency might be 100 Hz or 0,01 Hz?
> >=20
> > Well. In your living your you can have a switch, which is switch at
> > much less than 0.01Hz. You can also have a dimmer, which is a PWM,
> > which is switch at 100Hz or so. So yes, I'd say switch and mux are
> > different things.
>=20
> Light switches are mostly on/off switches. It'd be interesting to have a
> light switch that you could use to light either of the light bulbs in a r=
oom
> but not to switch both of them on at the same time. Or off... :-)
>=20
> I wonder if everyone would be happy with a statement saying that it's a
> on / on switch which is used to implement a multiplexer?

I believe the difference is the timescale. If it switches "slow" it is
a switch. If it switches fast, it is a dimmer, mux, or something....

Anyway, someone else was faster, so they get to name their creation...

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli33eAACgkQMOfwapXb+vIFUgCeP5MP4Ffn+ZAGpA/pIXtj4z1M
H1QAoJoj6bKMmhWIPr+W5dIKWuqifQSq
=mtaR
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
