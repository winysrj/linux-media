Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpjizak.jmnet.cz ([78.108.106.244]:42794 "EHLO
	smtpjizak.jmnet.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab0ADXyK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 18:54:10 -0500
Received: from localhost (wolf01 [127.0.0.1])
	by smtpjizak.jmnet.cz (Postfix) with ESMTP id 3AD96C0A002
	for <linux-media@vger.kernel.org>; Tue,  5 Jan 2010 00:54:06 +0100 (CET)
Received: from smtpjizak.jmnet.cz ([78.108.106.244])
	by localhost (mail.jiznak.czf [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0WQ-z5VSDisy for <linux-media@vger.kernel.org>;
	Tue,  5 Jan 2010 00:54:04 +0100 (CET)
Received: from [10.38.38.138] (pixla.hellnet.jiznak.czf [10.38.38.138])
	by smtpjizak.jmnet.cz (Postfix) with ESMTP id 128A6C0A053
	for <linux-media@vger.kernel.org>; Tue,  5 Jan 2010 00:54:04 +0100 (CET)
Subject: Re: DVBWorld DVB-S2 2005 PCI-Express Card
From: Jakub =?UTF-8?Q?L=C3=A1zni=C4=8Dka?= <jakub@jiznak.cz>
To: linux-media@vger.kernel.org
In-Reply-To: <8cd7f1781001040337q71c3cafcl9a2a4c6e77502ce6@mail.gmail.com>
References: <1262390254.8927.15.camel@sirius>
	 <8cd7f1781001040337q71c3cafcl9a2a4c6e77502ce6@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LC9YuAdI0V1Q1/uFAH7+"
Date: Tue, 05 Jan 2010 00:54:03 +0100
Message-Id: <1262649243.15593.9.camel@sirius>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-LC9YuAdI0V1Q1/uFAH7+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I think that`s not the same problem, maybe similar as you wrote. All 4
cards are same type. But only last one (if i write to shell #modprobe
cx23885) works and show in /dev/dvb .=20
Maybe it`s driver problem (doesn`t like more cards?).=20

Jakub.


Leszek Koltunski p=C3=AD=C5=A1e v Po 04. 01. 2010 v 19:37 +0800:
> I have a very similar problem with DVBWorld 2006 DVB-S2 card.
> The v4l-dvb ( freshly pulled ) compiles and loads, firmware is loaded,
> but when I actually try to use it ( dvbstream commands ) the following
> appears in /var/log/messages:
>=20
> Jan  4 18:30:24 november kernel: i2c_sendbytes: i2c error NAK or timeout =
occur
> Jan  4 18:30:24 november kernel: ds3000_readreg: reg=3D0xd1(error=3D-1)
> Jan  4 18:30:25 november kernel: i2c_sendbytes: i2c error NAK or timeout =
occur
> Jan  4 18:30:25 november kernel: ds3000_readreg: reg=3D0xd1(error=3D-1)
> Jan  4 18:30:25 november kernel: i2c_sendbytes: i2c error NAK or timeout =
occur
> Jan  4 18:30:25 november kernel: ds3000_writereg: writereg error(err
> =3D=3D -1, reg =3D=3D 0xf9, value =3D=3D 0x04)
> Jan  4 18:30:25 november kernel: i2c_sendbytes: i2c error NAK or timeout =
occur
> Jan  4 18:30:25 november kernel: ds3000_readreg: reg=3D0xf8(error=3D-1)
> Jan  4 18:30:25 november kernel: i2c_sendbytes: i2c error NAK or timeout =
occur
> Jan  4 18:30:25 november kernel: ds3000_writereg: writereg error(err
> =3D=3D -1, reg =3D=3D 0x03, value =3D=3D 0x12)
> Jan  4 18:30:25 november kernel: i2c_sendbytes: i2c error NAK or timeout =
occur
> Jan  4 18:30:25 november kernel: ds3000_tuner_readreg: reg=3D0x3d(error=
=3D-1)
> Jan  4 18:30:25 november kernel: i2c_sendbytes: i2c error NAK or timeout =
occur
> Jan  4 18:30:25 november kernel: ds3000_writereg: writereg error(err
> =3D=3D -1, reg =3D=3D 0x03, value =3D=3D 0x12)
> Jan  4 18:30:25 november kernel: i2c_sendbytes: i2c error NAK or timeout =
occur
> Jan  4 18:30:25 november kernel: ds3000_tuner_readreg: reg=3D0x21(error=
=3D-1)
>=20
> ... and many more of this.
>=20
> Actually I have to say I already tried DVBWorld 2006, NetUP dual
> DVB-S2 and TwinHan VP-1041 ( like the Technisat card ) but no success
> at all. DVBWorld is giving me errors like above, NetUP's driver loads
> but doesn't want to tune to anything, Twinhan can tune to one
> transponder and scan the channels but for reasons far beyond me fails
> to tune to anything else.
>=20
> DVB-T ( Leadtek WinFast ) is working for me perfectly, but DVB-S is an
> exercise in frustration...

--=-LC9YuAdI0V1Q1/uFAH7+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Toto je =?UTF-8?Q?digit=C3=A1ln=C4=9B?=
 =?ISO-8859-1?Q?_podepsan=E1?= =?UTF-8?Q?_=C4=8D=C3=A1st?=
 =?ISO-8859-1?Q?_zpr=E1vy?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAktCf5kACgkQXR2LPE1XFYtFNwCfTRZhsfAXuvsQGoNbLfFniJMg
/+EAn2eY0kRPHzBLAsx4Ss+w2KtwteU7
=wiGU
-----END PGP SIGNATURE-----

--=-LC9YuAdI0V1Q1/uFAH7+--

