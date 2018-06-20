Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59194 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932953AbeFTUil (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 16:38:41 -0400
Date: Wed, 20 Jun 2018 22:38:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        nicolas@ndufresne.ca, niklas.soderlund@ragnatech.se,
        jerry.w.hu@intel.com, mario.limonciello@dell.com
Subject: Software-only image processing for Intel "complex" cameras
Message-ID: <20180620203838.GA13372@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Nokia N900, I have similar problems as Intel IPU3 hardware.

Meeting notes say that pure software implementation is not fast
enough, but that it may be useful for debugging. It would be also
useful for me on N900, and probably useful for processing "raw" images
=66rom digital cameras.

There is sensor part, and memory-to-memory part, right? What is
the format of data from the sensor part? What operations would be
expensive on the CPU? If we did everthing on the CPU, what would be
maximum resolution where we could still manage it in real time?

Would it be possible to get access to machine with IPU3, or would
there be someone willing to test libv4l2 patches?

Thanks and best regards,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlsqu04ACgkQMOfwapXb+vIa4wCgwmT55zoDfQFVYKryqeb95Bhx
1jwAnAn3xhrGeuiw5cmlIUu+4oZ5hN5y
=bDCw
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
