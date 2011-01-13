Return-path: <mchehab@pedra>
Received: from smtp208.alice.it ([82.57.200.104]:58646 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566Ab1AMLiv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 06:38:51 -0500
Date: Thu, 13 Jan 2011 12:38:04 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.38] gspca for_2.6.38
Message-Id: <20110113123804.d391b10e.ospite@studenti.unina.it>
In-Reply-To: <20110113115953.4636c392@tele>
References: <20110113115953.4636c392@tele>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_Jan_2011_12_38_04_+0100_7QbaeYHp_Duzlw/K"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Thu__13_Jan_2011_12_38_04_+0100_7QbaeYHp_Duzlw/K
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Jan 2011 11:59:53 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> The following changes since commit
> 353b61709a555fab9745cb7aea18e1c376c413ce:
>=20
>   [media] radio-si470x: Always report support for RDS (2011-01-11 14:44:2=
8 -0200)
>=20
> are available in the git repository at:
>   git://linuxtv.org/jfrancois/gspca.git for_2.6.38
>

Hi Jean-Fran=E7ois, I had a look at the ov534 changes.

> Jean-Fran=E7ois Moine (9):
[...]
>       gspca - ov534: Use the new video control mechanism

In this commit, is there a reason why you didn't rename also
sd_setagc() into setagc() like for the other functions?

I am going to test the changes and report back if there's anything
more, I like the cleanup tho.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Thu__13_Jan_2011_12_38_04_+0100_7QbaeYHp_Duzlw/K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0u5BwACgkQ5xr2akVTsAHfLQCfcEWWCxug1wC/lH5YIQO4/kWd
bBMAoLEXfq/pFmwbUNnUn0T7lX7KN98/
=x9Ey
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Jan_2011_12_38_04_+0100_7QbaeYHp_Duzlw/K--
