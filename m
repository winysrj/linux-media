Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48430 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753725Ab0CSRNk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 13:13:40 -0400
Date: Fri, 19 Mar 2010 18:13:33 +0100
From: Steffen Pankratz <kratz00@gmx.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: em28xx - Your board has no unique USB ID and thus need a hint
 to  be detected
Message-ID: <20100319181333.3352a029@hermes>
In-Reply-To: <829197381003191007r1055f3dbo58d7712cff7cf19b@mail.gmail.com>
References: <20100319180129.6fb65141@hermes>
	<829197381003191007r1055f3dbo58d7712cff7cf19b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ph+lwhlIIidH+eWPw+HnACX";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/ph+lwhlIIidH+eWPw+HnACX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Mar 2010 13:07:23 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

> On Fri, Mar 19, 2010 at 1:01 PM, Steffen Pankratz <kratz00@gmx.de> wrote:
> > Hi,
> >
> > this USB stick is a Pinnacle Pctv Hybrid Pro 320e device
> > (ID eb1a:2881 eMPIA Technology, Inc.).
> >
> > Is there anything else you need to know?
> <snip>
>=20
> This was fixed some time ago.  Just install the current v4l-dvb code
> (instructions can be found at http://linuxtv.org/repo)

This is what I did.

hg tip output:

changeset:   14494:929298149eba
tag:         tip
user:        Douglas Schilling Landgraf <dougsland@redhat.com>
date:        Thu Mar 18 23:47:27 2010 -0300
summary:     ir-keytable: fix prototype for kernels < 2.6.22


--=20
Hermes powered by LFS SVN-20070420 (Linux 2.6.33.1)

Best regards, Steffen Pankratz.

--Sig_/ph+lwhlIIidH+eWPw+HnACX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkujsL0ACgkQqmIF0LCII9t8CACfYDl3EGPbyfuNzr9GDIL5lYqw
gF8AoJDtPL1IDLXZ41IDkYknerjh9DkP
=K5wv
-----END PGP SIGNATURE-----

--Sig_/ph+lwhlIIidH+eWPw+HnACX--
