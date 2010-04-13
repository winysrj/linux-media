Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns1.tyldum.com ([91.189.178.231]:44185 "EHLO ns1.tyldum.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab0DMQ4T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Apr 2010 12:56:19 -0400
Received: from tyldum.com (unknown [192.168.168.50])
	by ns1.tyldum.com (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Tue, 13 Apr 2010 18:56:16 +0200 (CEST)
Date: Tue, 13 Apr 2010 18:56:16 +0200
From: Vidar Tyldum Hansen <vidar@tyldum.com>
To: linux-media@vger.kernel.org
Subject: Re: mantis crashes
Message-ID: <20100413165616.GC11631@mail.tyldum.com>
References: <20100413150153.GB11631@mail.tyldum.com>
 <87ochne35i.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Content-Disposition: inline
In-Reply-To: <87ochne35i.fsf@nemi.mork.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 13, 2010 at 06:19:21PM +0200, Bj=F8rn Mork wrote:
> Vidar Tyldum Hansen <vidar@tyldum.com> writes:
>=20
> > Hello list,
> >
> > I am having issues with my TerraTec Cinergy C DVB-C, described in detail
> > here: https://bugzilla.kernel.org/show_bug.cgi?id=3D15750
> >
> > The essence is that machine would reboot or hang at random intervals if
> > the card is actively used (mythtv or tvheadend running for instance).
> > Just loading the mantis module and let the card idle does not trigger
> > anything.
>=20
> Does the 2.6.31-20-generic Ubuntu kernel come bundled with the mantis
> driver, or did you build this yourself?  If so, from where and which
> version?

I should have clarified this, my apologies.
I am running the latest V4L from the official V4L HG repository. I have
bluntly built and installed it on top of the Ubuntu kernel, replacing
V4L entirely.

Other users with same card and kernel has reported no issues with the
same configuration. And the card works for a while...

I realize this is not optimal, though.

> AFAIK, mantis wasn't included in mainline until 2.6.33.  I've just filed
> a wishlist bug for Debian's 2.6.32 so I'd really be interested in any
> Ubuntu work on this...

Don't know why I didn't think of that. I'll see if I can do similar for
Ubuntu to signal the need.

> > I am trying to figure out if this is a driver or hardware issue, and by
> > enabling more verbose logging on the mantis module I ended up with the
> > syslog output attached to the bug report. It shows binary garbage and
> > function calls for parts of the kernel not in use by the machine in
> > question right before the crash occurred.
> >
> > I have not been able to find a different card to test with yet.
> >
> > So, based on this, is it possible to conclude whom to blame for the
> > crash?
>=20
> FWIW I have exactly the same card with no such problems observed.  I am
> using a standard Debian 2.6.32-4-amd64 kernel with mantis driver taken
> from vanilla 2.6.34-rc4 (after patching mantis-input.c to compensate for
> the recent ir layer changes).  This is also what I submitted to Debian
> in the wishlist bug report.

Interesting. I will see if I can get it working similarly on the Ubuntu
=2E31 kernel.


>=20
> Bj=F8rn
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
       Vidar Tyldum Hansen
                                 vidar@tyldum.com               PGP: 0x3110=
AA98

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvEojAACgkQsJJnSzEQqpjDXACfbD/GMltA74WfzP489YB2g1QX
7UgAn0JQfdlnzayJakJoS090gqSRwcdJ
=kjZQ
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
