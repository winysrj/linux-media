Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57799 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756369AbeFSJJs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 05:09:48 -0400
Date: Tue, 19 Jun 2018 11:09:46 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
        Andreas Kemnade <andreas@kemnade.info>
Subject: Headsup with LogiLink DVB-T2/C Stick
Message-ID: <20180619090940.GA8659@taurus.defre.kleine-koenig.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I found patches by Andreas Kemnade[1] to support the LogiLink VG0022A
stick. After adapting them to v4.16 I can watch the DVB-T2 channels (didn't
test DVB-C yet).

Would it make sense to resubmit these?

Best regards
Uwe

[1] https://www.spinics.net/lists/linux-media/msg112928.html

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAlsoyFEACgkQwfwUeK3K
7AkMFggAlWyWMqhV+F85Dva3MXJYHOQWEpDa0TOMPc0QlFahABb3Um2ECGvnsQOb
XmqQEGGZIKSrHfrQwTwQBmaEckL4ot5YgWt4/7X6iPaVmtNlhJfUBLZaceKYS/O0
jyZJStBDFnWccszpDhvpClpvGQCo/lNbR3hM9+/vfIXocUTqjCc90ej8OP7hAxtU
jYF0j7+xNh+7ZRthrlGLjMjNRIt7h2PQYielSXqOW/exUrwH2Mpv3qHN7Rt4pkwr
LfvFhOWN00ITIQC8FsO8Vg4BMwP9vbzhbojauDrMyMa43CbcSY+xFi4uHGXwHXif
T2lFzhqAhbuKvZtMTNVVmo6tGZiBZg==
=h1Mi
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
