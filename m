Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60063 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab2ECDaL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 23:30:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SPmk5-00047p-Oc
	for linux-media@vger.kernel.org; Thu, 03 May 2012 05:30:09 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 05:30:09 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 05:30:09 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: HVR-1600 QAM recordings with slight glitches in them
Date: Wed, 02 May 2012 23:29:57 -0400
Message-ID: <4FA1FBB5.8050106@interlinx.bc.ca>
References: <jn2ibp$pot$1@dough.gmane.org> <1335307344.8218.11.camel@palomino.walls.org> <jn7pph$qed$1@dough.gmane.org> <1335624964.2665.37.camel@palomino.walls.org> <4F9C38BE.3010301@interlinx.bc.ca> <4F9C559E.6010208@interlinx.bc.ca> <4F9C6D68.3090202@interlinx.bc.ca> <CAAMvbhH2o6SZVBU4D2dvUUVuOhtzLdO-R=TCuug7Y9hgZq2gmg@mail.gmail.com> <CAGoCfiwB2jZfeZ2aSQ7FSG-k5XDGJY_ykLPSD3Y3rbrUXmuOdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig608B93D80CB677CEADB65C02"
Cc: stoth@kernellabs.com
In-Reply-To: <CAGoCfiwB2jZfeZ2aSQ7FSG-k5XDGJY_ykLPSD3Y3rbrUXmuOdg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig608B93D80CB677CEADB65C02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-04-29 08:09 PM, Devin Heitmueller wrote:
>=20
> I don't know why you're not seeing valid data on femon with the 950q.
> It should be printing out fine, and it's on the same 0.1 dB scale.
> Try running just azap and see if the SNR is reported there.

$ azap -c ~/last-channel-scan.prev 100-3
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 651000000 Hz
video pid 0x0000, audio pid 0x07c1
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |=20
status 1f | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
status 1f | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
status 1f | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
status 1f | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
status 1f | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
status 1f | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
status 1f | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
status 1f | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
status 1f | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
status 1f | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
=2E..

Doesn't seem to be useful values.
=20
> This indeed feels like a marginal signal condition problem, and Andy's
> assertion is well founded that the mxl5005/s5h1409 isn't exactly the
> best combo compared to more modern tuners and demodulators (Hauppauge
> switched to the tda18271 and s5h1411 for the newer revision of the
> HVR-1600).

Well, now that the coax connector has come loose on the digital tuner
(i.e. it spins albeit with enough friction that screwing a coax connector=

on and off is still quite doable but it would seem spins enough to have
broken the connection internally and thus the tuner no longer receives
signal) maybe it's time to cut my losses here and just consider this
HVR-1600 garbage.  I've wasted more than enough time on what's turned
out to just be marginal hardware.  ~sigh~

I wonder if I can still find the supported hardware rev. of the KWorld
UB-435 around anywhere.  The local computer store has one for $40 but
they have no way of telling me if it's the new hardware rev. or the old
one.

Cheers,
b.


--------------enig608B93D80CB677CEADB65C02
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+h+7YACgkQl3EQlGLyuXBcCACfbmvRNB6r8Am/TvFf8yfUeQbj
+TwAoJkDeIcWm4CfOmxukvjAY4cJwM8X
=tYoR
-----END PGP SIGNATURE-----

--------------enig608B93D80CB677CEADB65C02--

