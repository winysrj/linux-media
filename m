Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43352 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750910AbdBJVRn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 16:17:43 -0500
Date: Fri, 10 Feb 2017 22:17:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rob Herring <robh@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170210211739.GB1615@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170208213609.lnemfbzitee5iur2@rob-hp-laptop>
 <20170208223451.GB18807@amd>
 <CAL_JsqK2RHLoLc_ikHzP2B5_Lof2g9NG+zvamGe4o1ko1ggGQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <CAL_JsqK2RHLoLc_ikHzP2B5_Lof2g9NG+zvamGe4o1ko1ggGQA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2017-02-09 16:58:29, Rob Herring wrote:
> On Wed, Feb 8, 2017 at 4:34 PM, Pavel Machek <pavel@ucw.cz> wrote:
> >> > +
> >> > +This is a binding for a gpio controlled switch for camera interface=
s. Such a
> >> > +device is used on some embedded devices to connect two cameras to t=
he same
> >> > +interface of a image signal processor.
> >> > +
> >> > +Required properties
> >> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> > +
> >> > +compatible : must contain "video-bus-switch"
> >>
> >> video-bus-gpio-mux
> >
> > Sakari already asked for rename here. I believe I waited reasonable
> > time, but got no input from you, so I did rename it. Now you decide on
> > different name.
> >
> > Can we either get timely reactions or less bikeshedding?
>=20
> You mean less than 5 days because I don't see any other version of
> this? But in short, no, you can't.

Could we switch device tree bindings from "cc: subsystem, to: device
tree" to "to: subsystem, cc: device tree" mode? Currently it takes
more effort to merge the device tree parts than the relevant driver,
and that is not quite good.

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlieLfMACgkQMOfwapXb+vLnsgCeNcc8Nh0PChLaxzfMg86wi5+Q
7foAoJIINIWM/YEYJUcNCsB1O5tyJrsr
=J3G6
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
