Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44340 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbaLVUGz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 15:06:55 -0500
Date: Mon, 22 Dec 2014 20:06:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <20141222200627.GN17800@sirena.org.uk>
References: <1419114892-4550-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z7bbLlDR+qKEHzO8"
Content-Disposition: inline
In-Reply-To: <1419114892-4550-1-git-send-email-crope@iki.fi>
Subject: Re: [PATCHv2 1/2] regmap: add configurable lock class key for lockdep
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--z7bbLlDR+qKEHzO8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 21, 2014 at 12:34:51AM +0200, Antti Palosaari wrote:

> + * @lock_class_key: Custom lock class key for lockdep validator. Use that when
> + *                regmap in question is used for bus master IO in order to avoid
> + *                false lockdep nested locking warning. Valid only when regmap
> + *                default mutex locking is used.

Thinking about this further this comment definitely isn't accurate, it's
not just bus masters that are potentially affected but also things like
clock controllers that might need to be interacted with in order to do
I/O.  Thinking about those I'm even unsure that a per driver class
(which seems to be the idea here) will be enough, it's at least in
theory possible that two different instances of the same clock IP (or
generic regmap clock controller) will both need to be turned on for this
to work.

If it was just bus controllers it looks like we can probably just have
the clients set a flag saying that's what they are and then define the
class in the regmap core but I don't think that's all that's going on
here.

--z7bbLlDR+qKEHzO8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmHnCAAoJECTWi3JdVIfQk50H/RGS2wUXfa/aWuGNK/lZGSRo
2lgKusMBw2ddm5X0uZwsvV3RPraRQKUqiaToFbs/3gC2n71k+o/mi7ybhj9LGyal
i66TIKrkw2kTYnCCtpwc2+LodxME/hJpO5vf6vhe/F0ikWtNsJb4cS1pOYFSZ8rn
YFdn/TGQmhL5T402ozTa7xxGNtxCERoBcNOPJrxNsQERkBdYyp3y2cX1O/O9PdL9
Ml7BgPVSGKZhKlsXttKogwyJZbJsWK8/6ZiopGyfYR1THEQ0eMy11F9Edguw8kfa
RerT9csU0+AqZEEdSaotkgqkOM6hPFTYp4OAq/OALSWKwGqbfpPeqYi6Sj7E3Pw=
=XPvQ
-----END PGP SIGNATURE-----

--z7bbLlDR+qKEHzO8--
