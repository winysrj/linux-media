Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40522 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248Ab3GZHuz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 03:50:55 -0400
Message-ID: <51F22A58.9030208@ti.com>
Date: Fri, 26 Jul 2013 10:50:48 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: =?UTF-8?B?SmFrdWIgUGlvdHIgQ8WCYXBh?= <jpc-ml@zenburn.net>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [omap3isp] xclk deadlock
References: <51D37796.2000601@zenburn.net> <1604535.2Z0SUEyxcF@avalon> <51E0165C.5000401@zenburn.net> <3227918.6DpNM0vnE9@avalon>
In-Reply-To: <3227918.6DpNM0vnE9@avalon>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="mOUBS1aTLeWmilnJr3fp4H2SDkhUdSsbg"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--mOUBS1aTLeWmilnJr3fp4H2SDkhUdSsbg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 17/07/13 15:50, Laurent Pinchart wrote:
> Hi Jakub,
>=20
> (CC'ing Tomi Valkeinen)
>=20
> On Friday 12 July 2013 16:44:44 Jakub Piotr C=C5=82apa wrote:

>> 2. When exiting from live the kernel hangs more often then not
>> (sometimes it is accompanied by "Unhandled fault: external abort on
>> non-linefetch" in "dispc_write_irqenable" in omapdss).
>=20
> I'll pass this one to Tomi :-)

Sounds like something is enabling/disabling dispc interrupts after the
clocks have already been turned off.

So what's the context here? What kernel? Using omapfb, or...? I hope not
omap_vout, because that's rather unmaintained =3D).

 Tomi



--mOUBS1aTLeWmilnJr3fp4H2SDkhUdSsbg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR8ipYAAoJEPo9qoy8lh716VgQAIle2Sr4dtqkwz8YC2RlYj9h
ZstdMJiJE5mzpePi7Z4f1vKXs2wRt6t6+yBs1EdR5MpfDdkyFH1+hIaBD3CGBYet
ljmEp1YlAZx+Fhlq0stSqwSxyOF9gt0aAl1rsD92OOmvefr8eCiIPx5fBbKdHhtu
785GMmSUk2dfFRV3HF3DeXAJmV+U0oflbhy3OQbMD8XO5uIrjsJMnTYB5khcsCpD
7jqkcCI7E1shyzWyWAsx3OUQVhROZhSJmasp5tLZYzQ1fdUoNrbfaEbg8x5CFZbj
aaYCsMgi5YGOWRdd+TCuS9CIO42Yi9BKKs+BsKewWMUc3e2FEFH5xvdXrYqcpsG1
RRH4nr3GLLgqB2TBSDcKs0xsBHtAzpOTWjBXa/uEu0bI0HaDFNiiHZA2MsvgBtVZ
yAMAIsZb64MUdC91JKft29TrCBzOA6cxYjIyEJO97hGO3dgXyirm13x9QKicpnf3
7760xolRnaWWcYf0VtK9k2M+2SmP70lgOk4TZ+cjvA6fiNmzbM94ijWpzJA4x5r2
ppfNUFc0815ZYbeKq4Rwstmg5eS5d48kjpUdVMXoa8rqD4iULsShz0sNiDMRegii
qmKgibvIP94aC7WeseuqA7vS3olp+0AVVZC1ovsMeeMFlxXeBK+q4+4Z2bpDf2h2
wuteYqdE5eO76dXuqCsQ
=URBR
-----END PGP SIGNATURE-----

--mOUBS1aTLeWmilnJr3fp4H2SDkhUdSsbg--
