Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52269 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbdL2QaY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 11:30:24 -0500
Date: Fri, 29 Dec 2017 17:30:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>, pali.rohar@gmail.com,
        sre@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        clayton@craftyguy.net, martijn@brixit.nl,
        Filip =?utf-8?Q?Matijevi=C4=87?= <filip.matijevic.pz@gmail.com>,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: Re: v4.15: camera problems on n900
Message-ID: <20171229163022.GA31142@amd>
References: <20171227210543.GA19719@amd>
 <20171227211718.favif66afztygfje@kekkonen.localdomain>
 <20171228202453.GA20142@amd>
 <20171229093855.hz44vpssb5mufzop@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20171229093855.hz44vpssb5mufzop@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-12-29 11:38:55, Sakari Ailus wrote:
> On Thu, Dec 28, 2017 at 09:24:53PM +0100, Pavel Machek wrote:
> > On Wed 2017-12-27 23:17:19, Sakari Ailus wrote:
> > > On Wed, Dec 27, 2017 at 10:05:43PM +0100, Pavel Machek wrote:
> > > > Hi!
> > > >=20
> > > > In v4.14, back camera on N900 works. On v4.15-rc1.. it works for few
> > > > seconds, but then I get repeated oopses.
> > > >=20
> > > > On v4.15-rc0.5 (commit ed30b147e1f6e396e70a52dbb6c7d66befedd786),
> > > > camera does not start.	 =20
> > > >=20
> > > > Any ideas what might be wrong there?
> > >=20
> > > What kind of oopses do you get?
> >=20
> > Hmm. bisect pointed to commit that can't be responsible.... Ideas
> > welcome.
>=20
> Hi Pavel,
>=20
> I tested N9 and capture appears to be working from the CSI-2 receiver
> (media tree master, i.e. v4.15-rc3 now).
>=20
> Which pipeline did you use?

I'm using the "main" sensor (5MPx) and am using capture (not preview)
pipeline.

I tested linux-next in the meantime, and that one seems to
work. (Which is strange, I believe it oopsed before. Perhaps something
random?) With linux-next working, it should not be hardto figure out
what is going on.

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlpGbZ4ACgkQMOfwapXb+vJtbQCfeJPqx2iNWEXM2acaAkkhCNkU
cAwAnRTtpQNFlCUiyRdxxF1Dh7QfAepn
=Nt9b
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
