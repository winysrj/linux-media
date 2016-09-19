Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752717AbcISVsn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 17:48:43 -0400
Date: Mon, 19 Sep 2016 23:48:35 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 17/17] smiapp-pll: Don't complain aloud about failing
 PLL calculation
Message-ID: <20160919214834.aygru2wpiztpy2zu@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-18-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jkhn7mwcg2yspeck"
Content-Disposition: inline
In-Reply-To: <1473938551-14503-18-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jkhn7mwcg2yspeck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 15, 2016 at 02:22:31PM +0300, Sakari Ailus wrote:
> Don't complain about a failure to compute the pre_pll divisor. The
> function is used to determine whether a particular combination of bits per
> sample value and a link frequency can be used, in which case there are
> lots of unnecessary driver messages. During normal operation the failure
> generally does not happen. Use dev_dbg() instead.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--jkhn7mwcg2yspeck
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4F0yAAoJENju1/PIO/qaIoAQAIx6ubsM+kqrHKhMF3+f0Gd3
PLxVI0l4OpSPo8LPMUHoPEf8lfHxReeGtVVX+yKmsWEApiq8BfQmXQsNdR2Ib+Nq
9I0egpHarxkci/OgB7wh0AaOFZPwxmxN+bd7Bb0qWgEQo7c0ky561yeMy0cSckiB
SkvEcc4YsUGwhUwc0Mpc6jsFfTD/OMKj3zK2jJlHsKbKiRwL1t1WSnQVIv+bIL4m
9MH+y9buimQEvwWCqI5vvt9QFUKNeJtXgate1GD9+vrSlqOC5eoTlIBskpSXkK0/
35i5Itu8r5ejZwxr2GJ7HC81FguP6/MioPFsEF4FFccrf0k/J718UQuI6D6WOz1r
6cfIDbHA6kvxooca5mSUL1Pv+RZk/4hpGVBaky3dZtsA07p85IjsW2CgRVEhp2L2
1yYkd1ROH/s0XOnrfq2SX4tbwiyiHYAylxhw4ojPGarSQVNHEbCOAgfJD6IAyg0Y
vbMpG3mrzMUthjHgNPD3ESivRBY/vOyeVH6FmOxY4ydMFMgKm+Ay/+c5O7M2Buz8
uAWO/L58ryi2RvVfQuvgr8LFjCdhBZ8zVKHbJxo2ulVptgtDj9kcs4fFVQIQZBK6
560FfZYQV29yrRi6dp8KUG0PaPDkZlc6Ht95SKvIyyxGem5HQVrmaoRTL11Q65xt
nQOQT9OSyhT7C9Kb/0u8
=805p
-----END PGP SIGNATURE-----

--jkhn7mwcg2yspeck--
