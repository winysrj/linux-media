Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52974 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbcEFABG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2016 20:01:06 -0400
Date: Fri, 6 May 2016 02:00:45 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.6-rc1] media updates
Message-ID: <20160506020045.75d9722b@mir>
In-Reply-To: <20160505080737.5961617e@recife.lan>
References: <20160315080552.3cc5d146@recife.lan>
	<20160503233859.0f6506fa@mir>
	<CA+55aFxAor=MJSGFkynu72AQN75bNTh9kewLR4xe8CpjHQQvZQ@mail.gmail.com>
	<20160504063902.0af2f4d7@mir>
	<CA+55aFyE82Hi29az_MG9oG0=AEg1o++Wng_DO2RvNHQsSOz87g@mail.gmail.com>
	<20160504212845.21dab7c8@mir>
	<CA+55aFxQSUHBvOSqyiqdt2faY6VZSXP0p-cPzRm+km=fk7z4kQ@mail.gmail.com>
	<20160504185112.70ea985b@recife.lan>
	<20160505010051.5b4149c8@mir>
	<20160505080737.5961617e@recife.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wdCK2VK+BuxNyydN1Ve4tT9"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/wdCK2VK+BuxNyydN1Ve4tT9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi

On 2016-05-05, Mauro Carvalho Chehab wrote:
> Em Thu, 5 May 2016 01:00:51 +0200
> Stefan Lippers-Hollmann <s.l-h@gmx.de> escreveu:
[...]
> Oh, in this case, it should be using IS_ENABLED() macro instead.
> The following patch should fix it. I tested here with some different
> setups, as described in the patch, and with your .i686 .config.
>=20
> Please double-check and ack if it is ok for you.
>=20
> Regards,
> Mauro
>=20
>=20
> [PATCH v2] [media] media-device: fix builds when USB or PCI is compiled
>  as module
>=20
> Just checking ifdef CONFIG_USB is not enough, if the USB is compiled
> as module. The same applies to PCI.
[...]

This patch works for me, both on amd64 and i386, tested with=20
dvb_usb_dw2102, dvb_usb_af9015 and dvb_usb_rtl28xxu.

> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Feel free to add

Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

Thanks a lot.

Regards
	Stefan Lippers-Hollmann

--Sig_/wdCK2VK+BuxNyydN1Ve4tT9
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXK96tAAoJEL/gLWWx0ULtxc4P/jhCwovWugRzJPIlKl3qYzo/
q/rczCr/46xdQ7oCkBkXj7pmuct9nqfWr9NufNkd3Rn8vhKUHSvYAJKqrLqAJre/
q/guxB8eN/zfyPPGKtlvzBPA9VoknlsAhM71cvyjtuwpc5riGzp5tiqw6/ttN4E9
Rj39V9y+A61JE+Ma02NkozZr/B42c/zzU7NP1MWS8kFyeuQWnKEITA4Na0f5Vz/e
oWFhs4G90DmFL7phvY9Eige/ufVGI/QvOWLFwb+pkD3KBWT/YDh6HIGxQ6/H+ecE
7fHKLA7CIk7RewdH27BzUThyUkh+8nZfhcZ1Gco857H57koxFteApq+XUuj/d2jX
CEWBzQ7D0yhuG9/rb7QOMPhjSjGKvMY0PiKyqD/H1ua8j40zeR7+BkS5LhZetczW
Q/05Jx9ZZCKkGJEQx+6btIl6gZaEpc5kBUg3pl2wwF8Xy1xwSYT260PMNLoPpzOn
q/Lv2/m0uudwd2B/PYMSv/iMZ7FndnNYTT6c4No2SFJzw0KTxW5PSpmBdV9BO7Mo
qINAWhSqsr2VrxeV3dh6qzlPRyem905OyWfvpbXq5Nlt6sb/EWdCjvUYHkadKKvP
5Oo1Jy7z1c+bqag0CjvBU9io6RmxwIaCwHDtpd47JZ9U9P4cMlb5kz8q0ehiQdcB
Pg8gEqlfsjb7F4UTsn+h
=/tjI
-----END PGP SIGNATURE-----

--Sig_/wdCK2VK+BuxNyydN1Ve4tT9--
