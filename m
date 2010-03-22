Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50604 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753282Ab0CVRqH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 13:46:07 -0400
Date: Mon, 22 Mar 2010 18:45:53 +0100
From: Steffen Pankratz <kratz00@gmx.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: em28xx - Your board has no unique USB ID and thus need a hint
 to  be detected
Message-ID: <20100322184553.0433ae24@hermes>
In-Reply-To: <829197381003191017k5adab45ejee5179bc66880cac@mail.gmail.com>
References: <20100319180129.6fb65141@hermes>
	<829197381003191007r1055f3dbo58d7712cff7cf19b@mail.gmail.com>
	<20100319181333.3352a029@hermes>
	<829197381003191017k5adab45ejee5179bc66880cac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/AsFeapCE5H5+yC08/CnO9un";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/AsFeapCE5H5+yC08/CnO9un
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Mar 2010 13:17:20 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

> On Fri, Mar 19, 2010 at 1:13 PM, Steffen Pankratz <kratz00@gmx.de> wrote:
> > On Fri, 19 Mar 2010 13:07:23 -0400
> > Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> >
> >> On Fri, Mar 19, 2010 at 1:01 PM, Steffen Pankratz <kratz00@gmx.de> wro=
te:
> >> > Hi,
> >> >
> >> > this USB stick is a Pinnacle Pctv Hybrid Pro 320e device
> >> > (ID eb1a:2881 eMPIA Technology, Inc.).
> >> >
> >> > Is there anything else you need to know?
> >> <snip>
> >>
> >> This was fixed some time ago. =C2=A0Just install the current v4l-dvb c=
ode
> >> (instructions can be found at http://linuxtv.org/repo)
> >
> > This is what I did.
> >
> > hg tip output:
> >
> > changeset: =C2=A0 14494:929298149eba
> > tag: =C2=A0 =C2=A0 =C2=A0 =C2=A0 tip
> > user: =C2=A0 =C2=A0 =C2=A0 =C2=A0Douglas Schilling Landgraf <dougsland@=
redhat.com>
> > date: =C2=A0 =C2=A0 =C2=A0 =C2=A0Thu Mar 18 23:47:27 2010 -0300
> > summary: =C2=A0 =C2=A0 ir-keytable: fix prototype for kernels < 2.6.22
>=20
> Hmm...  Interesting.  Your eeprom hash is different than everybody
> else who has a 320e.  I will have to do a manual comparison and see
> why it is different.

Hi Devin,

I don't want to push you but are there any news?

--=20
Hermes powered by LFS SVN-20070420 (Linux 2.6.33.1)

Best regards, Steffen Pankratz.

--Sig_/AsFeapCE5H5+yC08/CnO9un
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkunrNEACgkQqmIF0LCII9t0aQCglr4n+d1r+Y8aGM1GRUyy0/lh
kusAoNxuVTM/y7p5w1xV1roNK2fAqFbA
=wEb8
-----END PGP SIGNATURE-----

--Sig_/AsFeapCE5H5+yC08/CnO9un--
