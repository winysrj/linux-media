Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40921 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab2D1UkK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 16:40:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SOER7-0008In-1D
	for linux-media@vger.kernel.org; Sat, 28 Apr 2012 22:40:09 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2012 22:40:09 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2012 22:40:09 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: HVR-1600 QAM recordings with slight glitches in them
Date: Sat, 28 Apr 2012 16:39:58 -0400
Message-ID: <4F9C559E.6010208@interlinx.bc.ca>
References: <jn2ibp$pot$1@dough.gmane.org>  <1335307344.8218.11.camel@palomino.walls.org>  <jn7pph$qed$1@dough.gmane.org> <1335624964.2665.37.camel@palomino.walls.org> <4F9C38BE.3010301@interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig33E6F1A985250AECA664E24E"
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	stoth@kernellabs.com
In-Reply-To: <4F9C38BE.3010301@interlinx.bc.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig33E6F1A985250AECA664E24E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12-04-28 02:36 PM, Brian J. Murrell wrote:
> One more question...

And to answer my own question, and provide some more data...

> I've never gotten my mind around SNRs and dBs, etc.  Generally speaking=
,
> am I looking for these "snr" values to go up or down (i.e. closer to 0
> or further away) to make my signal better?

Clearly, bigger numbers are better.  When I hook my HVR-1600 directly up
to the cable connection coming into the house with a 25 foot cable and a
barrel connector the SNR goes up to "148" (32.8 dB) so that's my
ceiling.  I can't leave it hooked up like this for anything more than a
few minutes so I can't be sure that's a high enough SNR for me to get
perfect recordings every time.

If I add one two way splitter to the incoming cable with one feed going
off to my cable modem and one to the HVR-1600, the SNR drops to "145"
(32.5 dB).  But again, I can't really leave it like that for too long.
so splitting that leg of the 2-way split 3 more times through a 3 way
splitter reduces the SNR at the HVR-1600 to between "142" and "145"
(32.2 - 32.5 dB).

I typically have one more splitter downstream from that 3 way splitter
which is a 4 way splitter to feed all of the tuners on my Mythtv box and
introducing that splitter reduces the SNR at the HVR-1600 to between
"13c" and "13e" (31.6 - 31.8 dB).

I have no idea where in these range of values "acceptable" is though.
Given that the HVR-1600 seems to be more sensitive to signal quality
that just about anything else in here, I suppose I could feed it more
directly from a split closer to the source signal.

Cheers,
b.




--------------enig33E6F1A985250AECA664E24E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+cVZ4ACgkQl3EQlGLyuXCKZwCgpiBQDblyk/3Fdp/ZkntTF1p7
l0sAoLoDRN6AiD/XYC81cmLF5U/R1XXJ
=navW
-----END PGP SIGNATURE-----

--------------enig33E6F1A985250AECA664E24E--

