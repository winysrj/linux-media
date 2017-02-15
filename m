Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57980 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751421AbdBOKsX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 05:48:23 -0500
Date: Wed, 15 Feb 2017 11:48:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] smiapp: add CCP2 support
Message-ID: <20170215104819.GC29330@amd>
References: <20170208131127.GA29237@amd>
 <20170211220752.zr3j7irpxl42ewo3@ihha.localdomain>
 <20170211232258.GA11232@amd>
 <20170212221042.GA16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5QAgd0e35j3NYeGe"
Content-Disposition: inline
In-Reply-To: <20170212221042.GA16975@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > I pushed the two DT patches here:
> > >=20
> > > <URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=3Dccp2>
> >=20
> > Thanks for a branch. If you could the two patches that look ok there,
> > it would mean less work for me, I could just mark those two as applied
> > here.
>=20
> I think a verb could be missing from the sentence. :-) I'll send a pull
> request for the entire set, containing more than just the DT changes. Feel
> free to base yours on top of this.
>=20
> A word of warning: I have patches to replace the V4L2 OF framework by V4L2
> fwnode. The preliminary set (which is still missing V4L2 OF removal) is
> here, I'll post a refresh soon:
>=20
> <URL:http://www.spinics.net/lists/linux-media/msg106160.html>
>=20
> Let's see what the order ends up to be in the end. If the fwnode set is
> applicable first, then I'd like to rebase the lane parsing changes on top=
 of
> that rather than the other way around --- it's easier that way.
>=20
> >=20
> > Core changes for CSI2 support are needed.
>=20
> CCP2? We could get these and the smiapp and possibly also the omap3isp
> patches in first, to avoid having to manage a large patchset. What do you
> think?

Well... anything that reduces the ammount of patches I need to
maintain to keep camera working is welcome.

> > There are core changes in notifier locking, and subdev support.
> >=20
> > I need video-bus-switch, at least for testing.
> >=20
> > I need subdev support for omap3isp, so that we can attach flash and
> > focus devices.
> >=20
> > Finally dts support on N900 can be enabled.
>=20
> Yes! 8-)
>=20
> I don't know if any euros were saved by using that video bus switch but it
> sure has caused a lot of hassle (and perhaps some gray hair) for software
> engineers. X-)

Yes, switch is one of the problems. OTOH... Nokia did a great thing by
creating phone with reasonable design...
								=09
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--5QAgd0e35j3NYeGe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlikMfMACgkQMOfwapXb+vJGbwCguLSaZH2lhS5N29ZM+lq4yoFb
MWwAnAnCxH2SnfE7Iic+GiIPVYviGspI
=BvK8
-----END PGP SIGNATURE-----

--5QAgd0e35j3NYeGe--
