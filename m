Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:40904 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946188AbcBSI2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 03:28:15 -0500
Message-ID: <1455870493.8834.8.camel@winder.org.uk>
Subject: Re: V4L docs and docbook
From: Russel Winder <russel@winder.org.uk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Keith Packard <keithp@keithp.com>,
	Graham Whaley <graham.whaley@linux.intel.com>
Date: Fri, 19 Feb 2016 08:28:13 +0000
In-Reply-To: <20160218072806.04484884@recife.lan>
References: <20160217145254.3085b333@lwn.net>
	 <20160217215138.15b6de82@recife.lan>
	 <1455783420.10645.21.camel@winder.org.uk>
	 <20160218063114.370b84cf@recife.lan> <20160218071014.61fb3d18@recife.lan>
	 <20160218072806.04484884@recife.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-h7m5Dmk5Xg7H04teiZSY"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-h7m5Dmk5Xg7H04teiZSY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-02-18 at 07:28 -0200, Mauro Carvalho Chehab wrote:
> Em Thu, 18 Feb 2016 07:10:14 -0200
> [=E2=80=A6]
>=20
> Stupid me: it should be just:
> 	asciidoc book.asciidoc
>=20
> Still, there are lots of broken things there, and lots of errors when
> building it:
> 	https://mchehab.fedorapeople.org/media-kabi-docs-test/book.html
>=20
> Ok, I would expect the need to handling some things manually, but
> it worries that it broke the tables. For example, see
> "Table 1. Control IDs" at https://mchehab.fedorapeople.org/media-kabi
> -docs-test/book.html
>=20
> It was mapped as a 3 cols table, but this is how it should be,
> instead:
> 	https://linuxtv.org/downloads/v4l-dvb-apis/control.html
> =09
> As this table has actually 5 cols, because some controls have a list
> of multiple values (see V4L2_CID_COLORFX for example).

I will not be able to do anything to help with any of this today, but I
can try and take a look tomorrow.

Certainly an automated translation will not do all the complicated
bits, that will need manual intervention. I may well be able to assist
on this. I think the transform from DocBook/XML is worth a bit of up
front effort now, so as to make everything so much easier for all
concerned in the future. Obviously I do not have data relating to this
project, just experience and anecdotal evidence from others.

--=20
Russel.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
Dr Russel Winder      t: +44 20 7585 2200   voip: sip:russel.winder@ekiga.n=
et
41 Buckmaster Road    m: +44 7770 465 077   xmpp: russel@winder.org.uk
London SW11 1EN, UK   w: www.russel.org.uk  skype: russel_winder


--=-h7m5Dmk5Xg7H04teiZSY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlbG0h0ACgkQ+ooS3F10Be9JHQCgno1JBsTgGtMTr71VguRW/ltI
o6MAnA8PUH1fg0/Rv6+YgvPIXRTaxgWs
=AhnA
-----END PGP SIGNATURE-----

--=-h7m5Dmk5Xg7H04teiZSY--

