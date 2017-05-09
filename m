Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60525 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdEIICs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 04:02:48 -0400
Date: Tue, 9 May 2017 10:02:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [patch, libv4l]: fix integer overflow
Message-ID: <20170509080244.GA16975@amd>
References: <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd>
 <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
 <9722356b-aa92-293f-40c5-bcb30bf71147@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <9722356b-aa92-293f-40c5-bcb30bf71147@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-05-09 08:32:20, Hans Verkuil wrote:
> On 05/09/2017 08:29 AM, Hans Verkuil wrote:
> > On 05/09/2017 12:28 AM, Pavel Machek wrote:
> >> Hi!
> >>
> >> This bit me while trying to use absolute exposure time on Nokia N900:
> >>
> >> Can someone apply it to libv4l2 tree? Could I get some feedback on the
> >> other patches? Is this the way to submit patches to libv4l2?
> >=20
> > Yes, it is. But I do need a Signed-off-by from you.
>=20
> I saw other patches from you for libv4l without a Signed-off-by. Can you
> check them and reply with the Signed-off-by line?

Thanks for quick reply. Yes, will do.

Best regards,
									Pavel
								=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkRd6QACgkQMOfwapXb+vItRgCggoWXHlW3LGKRBq6hxgSahojQ
By8AnRDXtvJMPj/8jKg8nl9qW+h07rzi
=RkyN
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
