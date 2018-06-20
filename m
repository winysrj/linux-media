Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60418 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933053AbeFTVLq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 17:11:46 -0400
Date: Wed, 20 Jun 2018 23:11:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        niklas.soderlund@ragnatech.se, jerry.w.hu@intel.com,
        mario.limonciello@dell.com
Subject: Re: Software-only image processing for Intel "complex" cameras
Message-ID: <20180620211144.GA16945@amd>
References: <20180620203838.GA13372@amd>
 <b7707ec241d9d2d2966bdc32f7bb9bc55ac55c5d.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <b7707ec241d9d2d2966bdc32f7bb9bc55ac55c5d.camel@ndufresne.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > On Nokia N900, I have similar problems as Intel IPU3 hardware.
> >=20
> > Meeting notes say that pure software implementation is not fast
> > enough, but that it may be useful for debugging. It would be also
> > useful for me on N900, and probably useful for processing "raw"
> > images
> > from digital cameras.
> >=20
> > There is sensor part, and memory-to-memory part, right? What is
> > the format of data from the sensor part? What operations would be
> > expensive on the CPU? If we did everthing on the CPU, what would be
> > maximum resolution where we could still manage it in real time?
>=20
> The IPU3 sensor produce a vendor specific form of bayer. If we manage
> to implement support for this format, it would likely be done in
> software. I don't think anyone can answer your other questions has no
> one have ever implemented this, hence measure performance.

I believe Intel has some estimates.

What is the maximum resolution of camera in the current Dell systems?

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlsqwxAACgkQMOfwapXb+vKx+wCcCDf4R0kgu21QoKyRMJpuFxpf
jQYAoIpPoj1A9Flm58ISapnLgLZpSa2F
=eUKC
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
