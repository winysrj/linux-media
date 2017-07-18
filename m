Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58482 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751322AbdGRJ1z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 05:27:55 -0400
Date: Tue, 18 Jul 2017 11:27:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 11/13] gpio-switch is for some reason neccessary for camera
 to work.
Message-ID: <20170718092753.GA17216@amd>
References: <20170214134019.GA8631@amd>
 <20170717222051.byilkg3x7lljlyja@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20170717222051.byilkg3x7lljlyja@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On Tue, Feb 14, 2017 at 02:40:19PM +0100, Pavel Machek wrote:
> > Probably something fun happening in userspace.
>=20
> What's the status of this one?
>=20
> I don't think it has a chance to be merged in the foreseeable future. Why
> is it needed?

Good question. And agreed that this one is not for merging. I suspect
something in my userspace depends on gpio-switch device being
present.

I'll try to debug what is going on there once more.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllt1JkACgkQMOfwapXb+vKEyACgnd/8x83axbw06orstFDb8cNC
Z04AoJZa3s/WnKoiF4ObSb4GYoF3NAiz
=zvMb
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
