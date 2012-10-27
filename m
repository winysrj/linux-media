Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50866 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab2J0Vee (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 17:34:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TSE1f-0003ki-MX
	for linux-media@vger.kernel.org; Sat, 27 Oct 2012 23:34:39 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 23:34:39 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 23:34:39 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: hvr-1600 records one, fails recording the other on an mplex
Date: Sat, 27 Oct 2012 17:34:10 -0400
Message-ID: <k6hk0s$63g$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig460C66AC942F1FA6AB5F1347"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig460C66AC942F1FA6AB5F1347
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

As I wrote about a number (3-4) of weeks ago, I am still having a
problem with my HVR-1600 failing on multiple digital recordings.  At the
time I reported this previously, there was a question of whether my
current version of MythTV was to blame.

To that end, I updated my MythTV to the latest (at the time) on the
0.25-fixes branch.  I also, at the same time, switched my primary
digital tuner to my HVR-950Q.  I ran in that configuration for a couple
of weeks without a single failed recording.

A week ago, I switched back to having my HVR-1600 as the primary device
to determine if it was the HVR-950Q switch or the MythTV update that
gave me such success and sure enough, on a particularly busy evening of
recording (but no busier than the same evening the prior two weeks where
the HVR-950Q worked flawlessly) one recording on a given multiplex
failed while another on the same multiplex, at the same time, was
successful.

Unsurprisingly "femon" reported "FE_HAS_LOCK" for the entire time period
of the failed recording.  I say unsurprisingly because as I mentioned
prior, another recording on the HVR-1600 at the same time was successful.=


Additionally, many, many times during the last week more than one
recording on a given multiplex on this HVR-1600 worked so this problem
is most definitely intermittent, but my experience for the last 3-4
weeks I think proves that it's a problem with the HVR-1600 and not
MythTV given that it's something that happens only with the HVR-1600 and
not with the HVR-950Q.

Unfortunately, there was nothing on the kernel log at the time of the
failed recording.

How can I gather further information on what might be going on which is
causing this failure?

b.


--------------enig460C66AC942F1FA6AB5F1347
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlCMU10ACgkQl3EQlGLyuXBkrgCeP6f5Wr9P/HQn/smq4C35+HI4
Ad8AoMelejXBnfT5haenQfzrFraCVlUe
=5p21
-----END PGP SIGNATURE-----

--------------enig460C66AC942F1FA6AB5F1347--

