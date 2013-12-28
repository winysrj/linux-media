Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm6-vm9.access.bullet.mail.gq1.yahoo.com ([216.39.63.244]:48013
	"HELO nm6-vm9.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754146Ab3L1Rnq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 12:43:46 -0500
Message-ID: <52BF0C1A.4070804@att.net>
Date: Sat, 28 Dec 2013 12:36:26 -0500
From: "deadletterfile@att.net" <deadletterfile@att.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: tehpola@gmail.com
Subject: linuxtv patch/11200/
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ShBCqprINhkI0bBUBT2oLVGtPOHeumJju"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ShBCqprINhkI0bBUBT2oLVGtPOHeumJju
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I am writing regarding Mr. Mike Slegeir's patch 11200, which is listed
with a 'State: Not Applicable.'

I downloaded dvb-apps using hg on an x86_64 Fedora 20 system. The
compiled atsc_epg failed as described:

/usr/bin/atsc_epg -f ######### -t -p 3
tuning to ######### Hz, please wait...
tuner locked.
system time: Thu Dec 26 22:25:40 2013
TS STT time: Thu Dec 26 22:25:54 2013
MGT table:
   0: type =3D 0x0000, PID =3D 0x1FFB, terrestrial VCT with
current_next_indictor=3D1
   1: type =3D 0x0200, PID =3D 0x1E00, event ETT 0
   2: type =3D 0x0201, PID =3D 0x1E01, event ETT 1
   3: type =3D 0x0202, PID =3D 0x1E02, event ETT 2
   4: type =3D 0x0004, PID =3D 0x1E80, channel ETT
   5: type =3D 0x0203, PID =3D 0x1E03, event ETT 3
   6: type =3D 0x0100, PID =3D 0x1D00, EIT 0
   7: type =3D 0x0101, PID =3D 0x1D01, EIT 1
   8: type =3D 0x0102, PID =3D 0x1D02, EIT 2
   9: type =3D 0x0301, PID =3D 0x1FFB, RRT with rating region 1
  10: type =3D 0x0103, PID =3D 0x1D03, EIT 3
receiving EIT .Segmentation fault (core dumped)

Mr. Slegeir's patched atsc_epg program ran to completion with the
desired output.

I assume Mr. Slegeir nor myself have made some elementary mistake.
Assuming the above to be true, I hope Mr. Slegeir's work might be
readdressed and it (or a modified solution) might be merged into the
distributed source code in the future. Thank you.

Royboy626


--ShBCqprINhkI0bBUBT2oLVGtPOHeumJju
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlK/DBoACgkQz1/aqdDsM3U6jwCg46ZKR4MNF2pgve0WXyHqlooc
fGgAnjRTw/G8Ngeeeb4aDUyMFjxeCFhG
=NpY6
-----END PGP SIGNATURE-----

--ShBCqprINhkI0bBUBT2oLVGtPOHeumJju--
