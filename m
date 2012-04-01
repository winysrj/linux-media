Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:42155 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab2DAIdW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 04:33:22 -0400
Date: Sun, 1 Apr 2012 10:33:15 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Daniel =?UTF-8?B?R2zDtmNrbmVy?= <daniel-gl@gmx.net>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T
 Stick [0ccd:0093]
Message-ID: <20120401103315.1149d6bf@milhouse>
In-Reply-To: <4F77DED5.2040103@iki.fi>
References: <4F75A7FE.8090405@iki.fi>
 <20120330234545.45f4e2e8@milhouse>
 <4F762CF5.9010303@iki.fi>
 <20120331001458.33f12d82@milhouse>
 <20120331160445.71cd1e78@milhouse>
 <4F771496.8080305@iki.fi>
 <20120331182925.3b85d2bc@milhouse>
 <4F77320F.8050009@iki.fi>
 <4F773562.6010008@iki.fi>
 <20120331185217.2c82c4ad@milhouse>
 <4F77DED5.2040103@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.Xj6CnliL_CZ/HiW81P8/OP"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/.Xj6CnliL_CZ/HiW81P8/OP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 01 Apr 2012 07:51:33 +0300
Antti Palosaari <crope@iki.fi> wrote:
> > I have no clue about the firmware format, so it will probably be easier
> > if you'd dive into that stuff as you already seem to know it.
>=20
> Done. I didn't have neither info, but there was good posting from Daniel=
=20
> Gl=C3=B6ckner that documents it! Nice job Daniel, without that info I was=
=20
> surely implemented it differently and surely more wrong way.
>=20
> I pushed my experimental tree out, patches are welcome top of that.
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_e=
xperimental
>=20
> I extracted three firmwares from windows binaries I have. I will sent=20
> those you, Michael, for testing. First, and oldest, is TUA9001, 2nd is=20
> from FC0012 device and 3rd no idea.

Great work. I'll rebase my tree on the new branch and check those firmware =
files asap.

> I need more AF903x hardware, please give links to cheap eBay devices=20
> etc. Also I would like to get one device where is AF9033 but no AF9035=20
> at all just for stand-alone demodulator implementation. I know there is=20
> few such devices, like AverMedia A336 for example...

This is my stick. It's a AF9035 with one FC0011 tuner chip:
http://www.amazon.de/Cabstone-DVB-T-Empf%C3%A4nger-Arbeitsspeicher-schwarz/=
dp/B00307551E/ref=3Dsr_1_1?ie=3DUTF8&qid=3D1333268959&sr=3D8-1

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/.Xj6CnliL_CZ/HiW81P8/OP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPeBLLAAoJEPUyvh2QjYsOHpsP/RIDcpVB98jFw/0Gxgi/grXb
GLGpcQNDjonruFjHmdzpNdKQdSyapKkMPCdEJVcOK6JWeUL6yrMKEczpDZ5d3p9B
EF8WhcDSYQtwjZlCsVsKuIK5dEvUuZ8lhev1XbujcgRxAmzQGDZo7AbKzprLaiDN
0qzyHdiwjTb1kwi3UDL9682fFtIjnFkPz8+4X+OVCOJZjAt4Jctrd8LbHwMr5xV7
3WYiBvilb83zrBbjoNTQOZGjYNvQrf0Soe77umyRDX/uOjTzgFY5E2XhgTCFju6+
ttto50XvEHBTeVejApJIIqQa/QfUssFppTXw97Ta53wuLERHzqqKurbQfpkGmAwW
Nlw6912oDbu55/vInc+iqYNHqsMwUzv0i8Ywcqg0xQpBJfQFRF4/aMq7AU7F/0gQ
PVO2M0B/ODfi+zaq9/HlFdAG8TlzL48ieyeUCU3PF0aSkPQNjbeWUIjvOaKEOWrb
CwVCGrkqF74bZm7leaIYI3OFm03YyOmFphvuYcKCJ7c2VLc31mCqEVEgx/vn4nHz
EKh6FY7j6UDX46PTeaxi7Yk1O20lAtNLt9PAE5dAt8r8MKcj/aTbBDezWqUizqIv
0C8GCqv9J9wllb/g2lWVp8p4L35jsQpRgMWcnD0SqfPvVuUBjE/6VRXpwWDSEXuA
/m521xf1x1RmJ5wxaCJQ
=eKl3
-----END PGP SIGNATURE-----

--Sig_/.Xj6CnliL_CZ/HiW81P8/OP--
