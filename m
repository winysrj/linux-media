Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37318 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752507AbdEILKZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 07:10:25 -0400
Date: Tue, 9 May 2017 13:10:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [patch, libv4l]: fix integer overflow
Message-ID: <20170509111023.GD28248@amd>
References: <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd>
 <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Q0rSlbzrZN6k9QnT"
Content-Disposition: inline
In-Reply-To: <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Q0rSlbzrZN6k9QnT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This bit me while trying to use absolute exposure time on Nokia N900:
> >=20
> > Can someone apply it to libv4l2 tree? Could I get some feedback on the
> > other patches? Is this the way to submit patches to libv4l2?
>=20
> Yes, it is. But I do need a Signed-off-by from you.

Ok, that should be it for today.

I also put all but the first patch into the git, at

https://gitlab.com/tui/v4l-utils/tree/merge

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Q0rSlbzrZN6k9QnT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkRo58ACgkQMOfwapXb+vIp3wCgnx/oorA+y6KoZ6EWc9i77gjo
8hMAoLj8OQMU42LbV/bIzXM37npysum+
=+92U
-----END PGP SIGNATURE-----

--Q0rSlbzrZN6k9QnT--
