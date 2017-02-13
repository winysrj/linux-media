Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51206 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdBMJyZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 04:54:25 -0500
Date: Mon, 13 Feb 2017 10:54:20 +0100
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170213095420.GA7065@amd>
References: <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170208213609.lnemfbzitee5iur2@rob-hp-laptop>
 <20170208223017.GA18807@amd>
 <CAL_JsqKSHvg+iB-SRd=YthauGP8mWeVF0j8X-fgLchwtOppH8A@mail.gmail.com>
 <CAL_JsqLfbAxBbXOyK0QOCc=wPe6=a+qyrAwtdbt3DtspK6oiaw@mail.gmail.com>
 <20170210195435.GA1615@amd>
 <20170210221742.GI13854@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20170210221742.GI13854@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Take a look at the wikipedia. If you do "one at a time" at 100Hz, you
> > can claim it is time-domain multiplex. But we are plain switching the
> > cameras. It takes second (or so) to setup the pipeline.
> >=20
> > This is not multiplex.
>=20
> The functionality is still the same, isn't it? Does it change what it is =
if
> the frequency might be 100 Hz or 0,01 Hz?

Well. In your living your you can have a switch, which is switch at
much less than 0.01Hz. You can also have a dimmer, which is a PWM,
which is switch at 100Hz or so. So yes, I'd say switch and mux are
different things.

> I was a bit annoyed for having to have two drivers for switching the sour=
ce
> (one for GPIO, another for syscon / register), where both of the drivers
> would be essentially the same with the minor exception of having a slight=
ly
> different means to toggle the mux setting.

Well, most of the video-bus-switch is the video4linux glue. Actual
switching is very very small part. So.. where is the other driver?
Looks like we have the same problem.

> The MUX framework adds an API for controlling the MUX. Thus we'll need on=
ly
> a single driver that uses the MUX framework API for V4L2. As an added bon=
us,
> V4L2 would be in line with the rest of the MUX usage in the kernel.
>=20
> The set appears to already contain a GPIO MUX. What's needed would be to =
use
> the MUX API instead of direct GPIOs usage.

If there's a driver that already does switching for video4linux
devices? Do you have a pointer?

								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlihgkwACgkQMOfwapXb+vKE6QCgiU3fHPC6AxTyWdxUdZygabqv
8+UAn03E4taDHUwumeZYXtg5hWQmZNoL
=0MYv
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
