Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:41513 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab2CaQ3g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Mar 2012 12:29:36 -0400
Date: Sat, 31 Mar 2012 18:29:25 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T
 Stick [0ccd:0093]
Message-ID: <20120331182925.3b85d2bc@milhouse>
In-Reply-To: <4F771496.8080305@iki.fi>
References: <4F75A7FE.8090405@iki.fi>
	<20120330234545.45f4e2e8@milhouse>
	<4F762CF5.9010303@iki.fi>
	<20120331001458.33f12d82@milhouse>
	<20120331160445.71cd1e78@milhouse>
	<4F771496.8080305@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//oMpYPshF76jOtb.za.qpmO"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_//oMpYPshF76jOtb.za.qpmO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Mar 2012 17:28:38 +0300
Antti Palosaari <crope@iki.fi> wrote:

> Googling the filename reveals many links, here is one:
> http://xgazza.altervista.org/Linux/DVB/dvb-usb-af9035-01.fw

Hm, on tuner register access I get these errors:

[ 9259.080907] af9035_ctrl_msg: command=3D03 failed fw error=3D2
[ 9259.080922] i2c i2c-8: I2C write reg failed, reg: 07, val: 0f

Is it possible that this firmware is incompatible with my stick?
The firmware that I successfully used with the other af9035 driver seems to
be incompatible with your driver, though. It crashes it somewhere
on firmware download in one of the USB transfer's memcpy.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_//oMpYPshF76jOtb.za.qpmO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPdzDlAAoJEPUyvh2QjYsOeIIQANX6+iOzlykVRkBq/KPShvVV
7mYEdiAn39DpMKkw6IzMFl2tXkEwgTU2zeTAr7/2SG/EXbkzUdRm6MLEX0ksog06
ExAlK3SneQTbLVRIhcsyBb7o9VrgGiQ+I7n00QF5k3k7A/6qEMcelTmbU2h+oxYs
7RI+iz5TocAE3UFN0+xLkFbqKIPGhDie0jl5FyNU2WGr9aURIYXYQ+Y+cY6XNyGf
UFOO16oubMmMQRH5tvasEeNHZe4TSWN8SJvfFLYBdc3DOpkIo4ukubU5FmD8r1M9
NyzQq++sFqKtT7qAfWlgDK8UcO5X5sjKoWnh1650IHtIRawYJ5IAQtFojX1lukU/
kZBbwCaAxXxBDz3qvgAn+Jf3nYBmrStT0UFIPwY3w1QcGSh1mKAtLpthdkQyr0+r
q5wKiMlnmqA8+qWELpNkgs1KX5d1ktDgXsEOPcpSMs/cgTWZysidmKTfDY28c2pR
RcNKD+hpArMkyxcju9EDhnC47WzOeuAYFncR7A8frrc48E7IaacMpp6m+NX6ttVe
+jYolP4fmnmIF1jijaU7Bs7auG/zAri1qR3pReQbzgSRUsoVWV2F9SDrFq49ojCQ
uyIVW6SBBRSRdhhOwxa9w71hB5iBHPwEbM1bCSnqTY+AA9A7nUOskqzYypD0Rl2D
qnqeCQZI19HIxTR4ulBO
=XKOL
-----END PGP SIGNATURE-----

--Sig_//oMpYPshF76jOtb.za.qpmO--
