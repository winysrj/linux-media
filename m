Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55323 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2AEGHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 01:07:00 -0500
Received: by ghbg21 with SMTP id g21so80778ghb.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jan 2012 22:06:59 -0800 (PST)
Received: from mark by acer.purcell.id.au with local (Exim 4.77)
	(envelope-from <msp@debian.org>)
	id 1RigTU-0001wZ-5r
	for linux-media@vger.kernel.org; Thu, 05 Jan 2012 17:06:52 +1100
From: Mark Purcell <mark@purcell.id.au>
To: linux-dvb@linuxtv.org
Subject: Fwd: updated DVB-T frequencies for Italy
Date: Thu, 5 Jan 2012 16:52:37 +1100
Cc: 613097-forwarded@bugs.debian.org, "Marco d'Itri" <md@linux.it>,
	debian-italian@lists.debian.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3753094.WYrzYnaTOV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201201051652.43740.msp@debian.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart3753094.WYrzYnaTOV
Content-Type: multipart/mixed;
  boundary="Boundary-01=_mqTBP4BShx4STQ7"
Content-Transfer-Encoding: 7bit


--Boundary-01=_mqTBP4BShx4STQ7
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


=2D---------  Forwarded Message  ----------

Subject: updated DVB-T frequencies for Italy
Date: Sun, 13 Feb 2011, 07:26:43
=46rom: "Marco d'Itri" <md@linux.it>
To: Debian Bug Tracking System <submit@bugs.debian.org>
CC: debian-italian@lists.debian.org

Package: dvb-apps
Version: 1.1.1+rev1355-1
Severity: normal
Tags: patch

In Italy there are way too many broadcasting sites, even more than one
covering the same city, so it not really practical to ship a frequencies
file for each one.
Also, frequencies are still changing due to the progressing switchover.

The attached file lists all frequencies used in Italy with reasonable
modulation parameters and allows performing a complete frequencies
scan no matter where the user is located.

I recommend removing the other italian files since (at least) many of
them are out of date (they list pre-switchover frequencies) and are
redundant anyway.

=2D-=20
ciao,
Marco

=2D----------------------------------------

--Boundary-01=_mqTBP4BShx4STQ7
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=it-Anywhere

# This file lists all frequencies used in Western Europe for DVB-T.
# The transmission parameters listed here are the ones generally used in
# Italy, broadcast neworks in other countries do use different parameters.
# Moreover, other countries use a bandwidth of 8 MHz also for Band III
# channels.
#
# Compiled in December 2010 by Marco d'Itri <md@linux.it>.
#
# References:
# http://en.wikipedia.org/wiki/Band_I#Europe
# http://en.wikipedia.org/wiki/Band_III#Europe
# http://en.wikipedia.org/wiki/File:VHF_Usage.svg
# http://en.wikipedia.org/wiki/Television_channel_frequencies

# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy

### VHF - Band III ###
# 5
T 177500000 7MHz 2/3 NONE QAM64 8k 1/32 NONE
# 6
T 184500000 7MHz 2/3 NONE QAM64 8k 1/32 NONE
# 7
T 191500000 7MHz 2/3 NONE QAM64 8k 1/32 NONE
# 8
T 198500000 7MHz 2/3 NONE QAM64 8k 1/32 NONE
# 9
T 205500000 7MHz 2/3 NONE QAM64 8k 1/32 NONE
# 10
T 212500000 7MHz 2/3 NONE QAM64 8k 1/32 NONE
# 11
T 219500000 7MHz 2/3 NONE QAM64 8k 1/32 NONE
# 12
T 226500000 7MHz 2/3 NONE QAM64 8k 1/32 NONE

### UHF - Band IV ###
# 21
T 474000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 22
T 482000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 23
T 490000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 24
T 498000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 25
T 506000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 26
T 514000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 27
T 522000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 28
T 530000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 29
T 538000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 30
T 546000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 31
T 554000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 32
T 562000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 33
T 570000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 34
T 578000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 35
T 586000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 36
T 594000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 37
T 602000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

### UHF - Band V ###
# 38
T 610000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 39
T 618000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 40
T 626000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 41
T 634000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 42
T 643000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 43
T 650000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 44
T 658000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 45
T 666000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 46
T 674000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 47
T 682000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 48
T 690000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 49
T 698000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 50
T 706000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 51
T 714000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 52
T 722000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 53
T 730000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 54
T 738000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 55
T 746000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 56
T 754000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 57
T 762000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 58
T 770000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 59
T 778000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 60
T 786000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 61
T 794000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 62
T 802000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 63
T 810000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 64
T 818000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 65
T 826000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 66
T 834000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 67
T 842000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 68
T 850000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# 69
T 858000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE


--Boundary-01=_mqTBP4BShx4STQ7--

--nextPart3753094.WYrzYnaTOV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk8FOqYACgkQoCzanz0IthKseQCeIWlLNr50Dermc8B/ZIupqFHb
WswAn1owSlvyqF+AjGFPPogO+F13pDTW
=7ecJ
-----END PGP SIGNATURE-----

--nextPart3753094.WYrzYnaTOV--
