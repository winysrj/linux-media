Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33543 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425860AbdD1WAI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 18:00:08 -0400
Date: Sat, 29 Apr 2017 00:00:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/2] v4l: Add camera voice coil lens control class,
 current control
Message-ID: <20170428220004.GA23906@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20170419105118.72b8e284@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Hmm... if the idea is to have a control that doesn't do ringing
> compensation, then it should be clear at the control's descriptions
> that:
>=20
> - V4L2_CID_FOCUS_ABSOLUTE should be used if the VCM has ringing
>   compensation;
> - V4L2_CID_VOICE_COIL_CURRENT and V4L2_CID_VOICE_COIL_RING_COMPENSATION
>   should be used otherwise.
>=20
> Btw, if the rationale for this patch is to support devices without
> ring compensation, so, both controls and their descriptions should
> be added at the same time, together with a patchset that would be
> using both.
>=20
> > How about adding such an explanation added to the commit message?
>=20
> It is not enough. Documentation should be clear that VCM devices
> with ring compensation should use V4L2_CID_FOCUS_ABSOLUTE.

Is ring compensation actually a big deal? We do not publish enough
information to userland about how fast the autofocus system is,
anyway, so it looks like userland can't depend on such details...
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkDu2QACgkQMOfwapXb+vLqYgCeNpXlRMeTg+9UQtMPv6mHHrH6
pO0An1dDK5AoJDtBf5ZC6RckgiQt8cto
=o4H3
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
