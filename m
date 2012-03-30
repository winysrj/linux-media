Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:39851 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965642Ab2C3Vp6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Mar 2012 17:45:58 -0400
Date: Fri, 30 Mar 2012 23:45:45 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T
 Stick [0ccd:0093]
Message-ID: <20120330234545.45f4e2e8@milhouse>
In-Reply-To: <4F75A7FE.8090405@iki.fi>
References: <4F75A7FE.8090405@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BtEEhd.p1Sm5VnZl5EKTCGL"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/BtEEhd.p1Sm5VnZl5EKTCGL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Mar 2012 15:33:02 +0300
Antti Palosaari <crope@iki.fi> wrote:

> Terve Mauro and all the other hackers,
>=20
> I did some massive rewrite for my old AF9035/AF9033 driver that was=20
> never merged. Anyhow, here it is.
>=20
> New drivers here are:
> Infineon TUA 9001 silicon tuner driver
> Afatech AF9033 DVB-T demodulator driver
> Afatech AF9035 DVB USB driver

This looks pretty nice.

I recently wrote a tuner driver for the fc0011 tuner, which is used in some
af9035 sticks:
http://patchwork.linuxtv.org/patch/10503/

It was developed against an af903x driver by Hans-Frieder Vogt.

I'll port it to your AF9035 driver, ASAP, to check whether this works
on my DVB USB stick.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/BtEEhd.p1Sm5VnZl5EKTCGL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPdimJAAoJEPUyvh2QjYsO6a8QAJZolKisyR81Q4+AUBtlZFV9
rvXkSuss6h6qjWv5cHZ2Ubung7BQVDe/0gncxY8kQiEFrx6p/wcQvQzxZS9w8bG6
CvjxXGhk07LoM58LG2t9qKqbr5VbjrPlfhku26ap6vGAUpnHY7n74xjLJqJXddJl
jVUt/6JtC8og6+b0ya97jtbc/kcBtgfMqi4WaX/BLHep9yJm5uk+koLPsimrINp+
P5ZYh74DyM4Qpo4oywJCB60/xd0B03IIvk11QEroIDNzzBJjXbfJ1q4MxEXH2b88
TS3l9THDtrVJnVOD8x4rocgrNie1fdK5B/VxD2vPQG1CKITNFeZmSzojrhJEKD9u
4XGVVWCyYmxxB+MS3b1ql7N5KTjR7H8SXrvJxA2BM/j/1rS9cpCW04O3KfnmC8sH
fTvom4DR5PEuLUgo5Xq1dFjybu+3FAfQG49ZrRTo/IvlRV2M3QCrWMDGQbVfJIce
8C/Iw36tnrBaPwr0rhWsLJ1rjVWbeCrUWXfBlTQqG2U/yizhuu6+cJr4Z4klOIdZ
CiNZtr7Q+OjV7jXK/muADCQapbXXHw/oAVmRFTT++rvBOvg7pMPFMQDY/mCFq8Cl
qy1kURI/CbOHI5fTJX1YKgrx2UK2bnUgiNglr7AlZnncPqTn1iC6jHxS/c2Jet2M
MXQOTegIp0CZxkv4KHIm
=LeB5
-----END PGP SIGNATURE-----

--Sig_/BtEEhd.p1Sm5VnZl5EKTCGL--
