Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:45867 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab2DCInK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Apr 2012 04:43:10 -0400
Date: Tue, 3 Apr 2012 10:43:02 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Hans-Frieder Vogt <hfvogt@gmx.net>,
	Gianluca Gennari <gennarone@gmail.com>
Subject: Re: [PATCH] af9035: fix and enhance I2C adapter
Message-ID: <20120403104302.16346945@milhouse>
In-Reply-To: <1333409555-679-1-git-send-email-crope@iki.fi>
References: <1333409555-679-1-git-send-email-crope@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aOWhIbdfzBD_hbntsKVMMwz"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/aOWhIbdfzBD_hbntsKVMMwz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  3 Apr 2012 02:32:35 +0300
Antti Palosaari <crope@iki.fi> wrote:

> There was a bug I2C adapter writes and reads one byte too much.
> As the most I2C clients has auto-increment register addressing
> this leads next register from the target register overwritten by
> garbage data.
>=20
> As a change remove whole register address byte usage and write
> data directly to the I2C bus without saying what are register
> address bytes to firmware.
>=20
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> Cc: Michael Buesch <m@bues.ch>
> Cc: Hans-Frieder Vogt <hfvogt@gmx.net>
> Cc: Gianluca Gennari <gennarone@gmail.com>

I can confirm that this fixes the issue. Thanks!

Tested-by: Michael Buesch <m@bues.ch>

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/aOWhIbdfzBD_hbntsKVMMwz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPergWAAoJEPUyvh2QjYsOdeMQAKctlWt125R7y+ZeEFPaNVOn
T1rS997JBh1iAdDRh57gclNNyW9DN3LWeTAZEA1ZzMDA8AQTWDy+hA0PksBTBbO9
rtjXpypiUooenWCv1uEBfya1OedBdyiDUuPY+LGS6GT2qQLXGH9y27ENYD/lDbm2
JZZ9SjaPSc448wf6Nq8sM4JpQsf5MdgF0JCGNbyjbeivLC5THMkPPQv9/BOZi6Fz
aR4mSF5UXEUPpysodDZBTah07LmQIiXzmuRXJDWn3wGPCIRNE3fDX0F0gYTuS9Rp
ISCJ6ILryzTrOIBJhVzp7ROPEbMNNgla8HrHz0VfG8CMFUZ8w763BDRgeikSk9yW
0UlP57QY0nh5xyMqoQ6LAkgsKoqyhsMErnOTECOX34/bBwTUPuchajOLmTbp6ao9
WcFZCSKsd9zcKzQP7TWholPP8L5FFqW1xIXm80I6P1xGCYyjyMlmzHgOjmZcvRGY
VseFgqQJRd+Ty9Brzbz5ikFtOhH6sn2zviSgZ4WlFA4ahe1AkokUrQxiDTrnsbjP
Qu77X/j67mDuQL4uqR7glWjJTggak18yaXAMeOaOT7wwkj9H5rLwqgPbGQfHNbUu
gcPiVgoYkXatBwceBmqIU6AoTsXX+0OIfU6rmYbc9L2PBkmFBJ/G1wU7CvEPBfpG
njzRiI65U5jOt2/VbQT9
=Hg23
-----END PGP SIGNATURE-----

--Sig_/aOWhIbdfzBD_hbntsKVMMwz--
