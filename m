Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:42615 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab2DAQgv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 12:36:51 -0400
Date: Sun, 1 Apr 2012 18:36:46 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: "Hans-Frieder Vogt" <hfvogt@gmx.net>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T
 Stick [0ccd:0093]
Message-ID: <20120401183646.7f88df5b@milhouse>
In-Reply-To: <201204011824.09876.hfvogt@gmx.net>
References: <4F75A7FE.8090405@iki.fi>
	<201204011642.35087.hfvogt@gmx.net>
	<20120401165601.17a76a03@milhouse>
	<201204011824.09876.hfvogt@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m=SJT2ELHGo=W8Hbu+G7p1_"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/m=SJT2ELHGo=W8Hbu+G7p1_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Apr 2012 18:24:09 +0200
"Hans-Frieder Vogt" <hfvogt@gmx.net> wrote:
> However, I found the problem: the buffer=20
> length needs to be msg[1].len, see below.

I spotted this bug, too, but it didn't fix the problem, as len is 1 for
both packets in my specific case. So it doesn't make a difference in this c=
ase.

But as I said in the previous mail: I did more debugging and I'm pretty sur=
e that
the actual i2c reads and writes work as expected. The problem is at another=
 level.

>  --- old/af9035.c 2012-04-01 16:41:53.694103691 +0200
> +++ new/af9035.c    2012-04-01 18:22:25.026930784 +0200
> @@ -209,24 +209,15 @@
>                                         msg[1].len);
>                 } else {
>                         /* I2C */
> -#if 0
> -                       /*
> -                        * FIXME: Keep that code. It should work but as i=
t is
> -                        * not tested I left it disabled and return -
> EOPNOTSUPP
> -                        * for the sure.
> -                        */
>                         u8 buf[4 + msg[0].len];
>                         struct usb_req req =3D { CMD_I2C_RD, 0, sizeof(bu=
f),
>                                         buf, msg[1].len, msg[1].buf };
> -                       buf[0] =3D msg[0].len;
> +                       buf[0] =3D msg[1].len;
>                         buf[1] =3D msg[0].addr << 1;
>                         buf[2] =3D 0x01;
>                         buf[3] =3D 0x00;
>                         memcpy(&buf[4], msg[0].buf, msg[0].len);
>                         ret =3D af9035_ctrl_msg(d->udev, &req);
> -#endif
> -                       pr_debug("%s: I2C operation not supported\n",=20
> __func__);
> -                       ret =3D -EOPNOTSUPP;
>                 }
>         } else if (num =3D=3D 1 && !(msg[0].flags & I2C_M_RD)) {
>                 if (msg[0].len > 40) {

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/m=SJT2ELHGo=W8Hbu+G7p1_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPeIQeAAoJEPUyvh2QjYsOLyQP/i79dTPqWgK/n4htzfJuyo2z
lI9Hm8sJBKzq9kBqk3DaYNrw0Alg20jbGe8ipbEk6XUSnXEwxdLdrCKCi5j/YVYU
Wv+eK2buPJ2+Kh6Pqhcd+OMDPv/lmu7zHHLdZyUF6sXJSfr3nhrEcuGdpsJzXKil
YTxrUfvMrQiEwC34I7mRa9ZiYhiiF5G86Be4jdxthZZLyhejqibPgCpnkRF5dPNg
3vU9alVk4E5xzwe5N63diDFvoG6h3fiQL8DFqAVY9TClNtfbht97cOYS5L50/zED
I5eY8noBzxVC/SxYEFOS+GiIln4py8QJ6NX2jzFCMBJP7WWIbGNcBBbsEV+MazA7
tZVrJ6bifHeY7krKSryhZA+AzOfCd95V8lISdmk2HjtYmQRpqiDzvnKEB1NStczn
TIQ9+bD8d7NY3rR8Lc3JYeKYvm4ZZ2vvTUHqvWpgaYQXLfVQ5KVqRtIXyWTDEB2w
pC/WjItxgDKk4BDJPp+f71sE4Onm9qX2iuRW88iTsAxV41zeStAVEKg5tsEAsk5g
UsL/ofDkgRWjn8UWx+D6JA9C7teVGDVrltIncTa3Uqy9RH8B5v8YYyD4s8HTfDHj
7jRrrQyH4JyFXAAMDnmGfWfs8SKXUSyBRTVfSUq/3CruH9FNUh5D3AbCucrp9EFA
+fWPOZpftsnmsRbmLpid
=dH1a
-----END PGP SIGNATURE-----

--Sig_/m=SJT2ELHGo=W8Hbu+G7p1_--
