Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58185 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbdBOK67 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 05:58:59 -0500
Date: Wed, 15 Feb 2017 11:58:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: sakari.ailus@iki.fi, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 06/13] v4l2-async: per notifier locking
Message-ID: <20170215105856.GD29330@amd>
References: <20170214133956.GA8530@amd>
 <20170214160720.xamqwoqo7rnb2nxi@earth>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
Content-Disposition: inline
In-Reply-To: <20170214160720.xamqwoqo7rnb2nxi@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > From: Sebastian Reichel <sre@kernel.org>
> >=20
> > Without this, camera support breaks boot on N900.
>=20
> That's kind of vague. I just checked my original patch and it looks
> like I did not bother to write a proper patch description. I suggest
> to make this
>=20
> "Fix v4l2-async locking, so that v4l2_async_notifiers can be used
> recursively. This is important for sensors, that are only reachable
> by the image signal processor through some intermediate device."
>=20
> You should probably move move this patch directly before the
> video-bus-switch patch, since its a preparation for it.
>=20
> Also this is missing my SoB:
>=20
> Signed-off-by: Sebastian Reichel <sre@kernel.org>

Thanks, done.
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlikNHAACgkQMOfwapXb+vKWqwCgh15trxX73tNywc+RdUKPngVY
9PEAnjxZx7LtNj2FPrFdszXZO+7Iif+G
=AXTo
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
