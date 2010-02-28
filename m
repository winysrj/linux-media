Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-OUT05A.alice.it ([85.33.3.5]:1126 "EHLO
	smtp-OUT05A.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936410Ab0B1TLx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 14:11:53 -0500
Date: Sun, 28 Feb 2010 20:11:33 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org, Max Thrun <bear24rw@gmail.com>
Subject: Re: [PATCH 09/11] ov534: Cosmetics: fix indentation and hex digits
Message-Id: <20100228201133.d4e4b5c6.ospite@studenti.unina.it>
In-Reply-To: <20100228194636.423a6312@tele>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
	<1267302028-7941-10-git-send-email-ospite@studenti.unina.it>
	<20100228194636.423a6312@tele>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__28_Feb_2010_20_11_33_+0100_9PKE=vhHR1JiY5.A"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Sun__28_Feb_2010_20_11_33_+0100_9PKE=vhHR1JiY5.A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Feb 2010 19:46:36 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Sat, 27 Feb 2010 21:20:26 +0100
> Antonio Ospite <ospite@studenti.unina.it> wrote:
>=20
> >   * Indent with tabs, not with spaces.
> >   * Less indentation for controls index comments.
> 	[snip]
> > -    },
> > +},
> >  };
>=20
> I had preferred one more TAB for all controls.

I found it redundant, but I am preparing a v2 patch as per your request
now.

I'll also need to refresh patch 10, will send a v2 for it too after
discussing your comments on that one.

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Sun__28_Feb_2010_20_11_33_+0100_9PKE=vhHR1JiY5.A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuKv+UACgkQ5xr2akVTsAFCkwCfUuSj1iSToARrXSk75mxGnnMv
7igAn0nmb8VAwvGgJYjIK7jsRt5ih4yO
=5jft
-----END PGP SIGNATURE-----

--Signature=_Sun__28_Feb_2010_20_11_33_+0100_9PKE=vhHR1JiY5.A--
